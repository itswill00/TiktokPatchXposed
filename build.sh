#!/usr/bin/env bash
# Smart build helper for TiktokPatchXposed.
# - one Gradle invocation for the selected tasks (incremental, no duplicate work)
# - uploads every freshly built APK to Telegram, skipping unchanged files
# - credentials stay in source/local.properties (gitignored) or env vars
set -uo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SRC="$ROOT/source"
CACHE_DIR="${TMPDIR:-/tmp}/opencode/tpx-build"
mkdir -p "$CACHE_DIR"
CACHE="$CACHE_DIR/uploaded-hashes.tsv"
LOG="$CACHE_DIR/last-build.log"

VARIANT="all"
RUN_TESTS=1
DO_BUILD=1
DO_UPLOAD=1
FORCE_UPLOAD=0
CLEAN=0
STRICT=0
DAEMON=0

log()  { printf '\033[1;36m[build]\033[0m %s\n' "$*"; }
warn() { printf '\033[1;33m[warn]\033[0m %s\n' "$*" >&2; }
fail() { printf '\033[1;31m[fail]\033[0m %s\n' "$*" >&2; }

usage() {
    cat <<'EOF'
Usage: ./build.sh [options]

  --debug            build debug APK only
  --release          build release APK only
  --all              build both (default)
  --no-tests         skip unit tests
  --clean            run clean first
  --daemon           keep the Gradle daemon (default: --no-daemon)
  --no-upload        build only, do not send to Telegram
  --upload-only      skip Gradle, upload existing APKs
  --force-upload     send even if the APK hash did not change
  --strict           exit non-zero if an upload fails
  --help             show this help

Environment overrides: TELEGRAM_BOT_TOKEN, TELEGRAM_CHAT_ID
Config: source/local.properties -> telegram.botToken, telegram.chatId
EOF
}

while [[ $# -gt 0 ]]; do
    case "$1" in
        --debug)        VARIANT="debug" ;;
        --release)      VARIANT="release" ;;
        --all)          VARIANT="all" ;;
        --no-tests)     RUN_TESTS=0 ;;
        --clean)        CLEAN=1 ;;
        --daemon)       DAEMON=1 ;;
        --no-upload)    DO_UPLOAD=0 ;;
        --upload-only)  DO_BUILD=0 ;;
        --force-upload) FORCE_UPLOAD=1 ;;
        --strict)       STRICT=1 ;;
        -h|--help)      usage; exit 0 ;;
        *) fail "unknown option: $1"; usage; exit 2 ;;
    esac
    shift
done

prop() {
    [[ -f "$SRC/local.properties" ]] || return 0
    sed -n "s/^[[:space:]]*$1[[:space:]]*=[[:space:]]*//p" "$SRC/local.properties" | tail -n 1 | tr -d '\r'
}

TOKEN="${TELEGRAM_BOT_TOKEN:-$(prop telegram.botToken)}"
CHAT="${TELEGRAM_CHAT_ID:-$(prop telegram.chatId)}"
COMMIT="$(git -C "$ROOT" rev-parse --short HEAD 2>/dev/null || echo unknown)"
BRANCH="$(git -C "$ROOT" branch --show-current 2>/dev/null || echo detached)"
VER="$(sed -n 's/.*versionName = "\([^"]*\)".*/\1/p' "$SRC/app/build.gradle.kts" | head -n 1)"
CODE="$(sed -n 's/.*versionCode = \([0-9][0-9]*\).*/\1/p' "$SRC/app/build.gradle.kts" | head -n 1)"

declare -a TASKS=() APKS=()
if [[ "$RUN_TESTS" == 1 ]]; then TASKS+=("testDebugUnitTest"); fi
case "$VARIANT" in
    debug)   TASKS+=("assembleDebug");   APKS+=("$SRC/app/build/outputs/apk/debug/app-debug.apk") ;;
    release) TASKS+=("assembleRelease"); APKS+=("$SRC/app/build/outputs/apk/release/app-release.apk") ;;
    all)     TASKS+=("assembleDebug" "assembleRelease")
             APKS+=("$SRC/app/build/outputs/apk/debug/app-debug.apk" "$SRC/app/build/outputs/apk/release/app-release.apk") ;;
esac
if [[ "$CLEAN" == 1 ]]; then TASKS=("clean" "${TASKS[@]}"); fi

TESTS="not run"
if [[ "$DO_BUILD" == 1 ]]; then
    FLAGS=(--console=plain)
    [[ "$DAEMON" == 0 ]] && FLAGS+=(--no-daemon)
    log "gradle: ./gradlew ${FLAGS[*]} ${TASKS[*]}"
    ( cd "$SRC" && ./gradlew "${FLAGS[@]}" "${TASKS[@]}" ) 2>&1 | tee "$LOG"
    status=${PIPESTATUS[0]}
    if [[ "$status" != 0 ]]; then fail "Gradle exited with $status"; exit "$status"; fi
    if [[ -d "$SRC/app/build/test-results/testDebugUnitTest" ]]; then
        TESTS="$(python3 - "$SRC/app/build/test-results/testDebugUnitTest" <<'PY'
import glob, re, sys
total = failed = 0
for path in glob.glob(sys.argv[1] + '/*.xml'):
    head = open(path, encoding='utf-8', errors='ignore').read(4000)
    m = re.search(r'<testsuite[^>]*', head)
    if not m: continue
    def get(k):
        n = re.search(r'%s="(\d+)"' % k, m.group())
        return int(n.group(1)) if n else 0
    total += get('tests'); failed += get('failures') + get('errors')
print('%d passed' % total if failed == 0 and total else '%d passed, %d failed' % (total, failed))
PY
)"
    fi
else
    log "upload-only: skipping Gradle"
fi

upload_one() {
    local apk="$1" variant="$2"
    if [[ ! -f "$apk" ]]; then warn "$variant: APK not found: $apk"; return 1; fi
    local hash key old response caption
    hash="$(sha256sum "$apk" | awk '{print $1}')"
    key="$(basename "$apk")"
    old="$(awk -F '\t' -v k="$key" '$1==k {print $2}' "$CACHE" 2>/dev/null | tail -n 1)"
    if [[ "$old" == "$hash" && "$FORCE_UPLOAD" == 0 ]]; then
        log "$variant: unchanged (${hash:0:12}), upload skipped"
        return 0
    fi
    if [[ -z "$TOKEN" || -z "$CHAT" ]]; then
        warn "$variant: Telegram credentials missing; upload skipped"
        return 1
    fi
    caption="$(cat <<EOF
<b>TiktokPatchXposed</b> · <b>${variant}</b>
Version ${VER} (${CODE}) · commit <code>${COMMIT}</code>
Branch: <code>${BRANCH}</code>
Tests: ${TESTS}
SHA-256: <code>${hash:0:12}…</code>
EOF
)"
    response="$(curl -sS --fail --retry 3 --connect-timeout 10 --max-time 180 \
        -X POST \
        -F "chat_id=${CHAT}" \
        -F "document=@${apk}" \
        -F "parse_mode=HTML" \
        --form-string "caption=${caption}" \
        "https://api.telegram.org/bot${TOKEN}/sendDocument" 2>&1)"
    if [[ $? != 0 ]] || ! grep -q '"ok"[[:space:]]*:[[:space:]]*true' <<<"$response"; then
        warn "$variant: Telegram upload failed: ${response:0:300}"
        return 1
    fi
    awk -F '\t' -v k="$key" '$1!=k' "$CACHE" >"$CACHE.tmp" 2>/dev/null || true
    printf '%s\t%s\n' "$key" "$hash" >>"$CACHE.tmp"
    mv "$CACHE.tmp" "$CACHE"
    log "$variant: uploaded $(du -h "$apk" | cut -f1) → Telegram"
}

upload_failed=0
if [[ "$DO_UPLOAD" == 1 ]]; then
    apk_index=0
    for apk in "${APKS[@]}"; do
        if [[ "$VARIANT" == "all" ]]; then
            [[ "$apk" == *"/debug/"* ]] && variant="debug" || variant="release"
        else
            variant="$VARIANT"
        fi
        upload_one "$apk" "$variant" || upload_failed=1
        apk_index=$((apk_index + 1))
    done
else
    log "upload disabled by --no-upload"
fi

log "summary: ${VARIANT} · ${TESTS} · commit ${COMMIT} @ ${BRANCH}"
for apk in "${APKS[@]}"; do
    [[ -f "$apk" ]] && printf '  %-22s %s\n' "$(basename "$apk")" "$(du -h "$apk" | cut -f1)"
done
[[ "$upload_failed" == 1 && "$STRICT" == 1 ]] && exit 1
exit 0
