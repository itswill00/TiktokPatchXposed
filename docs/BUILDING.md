# Building

## Requirements

| Tool | Version |
| --- | --- |
| JDK | 17 |
| Android SDK | 36 (`platforms;android-36`, `build-tools;36.0.0`) |
| Gradle | 8.13 (supplied by the wrapper) |
| Git | any recent version |

The Gradle project lives in [`source/`](../source). `source/local.properties` is gitignored and holds local machine settings.

## Quick start

```shell
./build.sh
```

That single command:

1. runs `testDebugUnitTest`;
2. builds both `assembleDebug` and `assembleRelease` in one Gradle invocation;
3. uploads every **new** APK to Telegram;
4. prints a compact summary with test count, commit and APK sizes.

If an APK hash is unchanged since the last upload, the upload is skipped. Use `--force-upload` to send it anyway.

## `build.sh` options

| Option | Effect |
| --- | --- |
| `--debug` / `--release` / `--all` | Pick the variant. Default: `--all`. |
| `--no-tests` | Skip unit tests. |
| `--clean` | Run `clean` before the build. |
| `--daemon` | Keep the Gradle daemon (default is `--no-daemon`). |
| `--no-upload` | Build locally, send nothing. |
| `--upload-only` | Skip Gradle and upload existing APKs. |
| `--force-upload` | Upload even when the APK hash did not change. |
| `--strict` | Exit non-zero if an upload fails. |
| `--help` | Show inline help. |

Examples:

```shell
./build.sh --release --no-tests          # release only, no test run
./build.sh --debug --force-upload        # always send the debug APK
./build.sh --upload-only --release        # re-send an already built release APK
./build.sh --clean --all --no-upload      # clean local build, no Telegram
```

## Telegram upload setup

Credentials are read from the environment first, then from `source/local.properties`:

```properties
sdk.dir=/path/to/android-sdk
telegram.botToken=123456:ABC...
telegram.chatId=-1001234567890
```

```shell
export TELEGRAM_BOT_TOKEN='123456:ABC...'
export TELEGRAM_CHAT_ID='-1001234567890'
```

The bot must be a member of the target chat and allowed to post documents. The token is never committed: `local.properties` is listed in [`.gitignore`](../.gitignore).

Each upload uses `sendDocument` with a caption containing the variant, version, commit, branch, test result and a shortened SHA-256.

## Manual Gradle build

```shell
cd source
./gradlew testDebugUnitTest assembleDebug assembleRelease
```

Output:

```text
source/app/build/outputs/apk/debug/app-debug.apk
source/app/build/outputs/apk/release/app-release.apk
```

## Unit tests only

```shell
cd source
./gradlew testDebugUnitTest
```

Results are written as XML to `source/app/build/test-results/testDebugUnitTest/`. Tests are pure JVM logic: no device, emulator or Robolectric is required.

## CI

[`.github/workflows/android.yml`](../.github/workflows/android.yml) builds debug + release, runs the unit tests and uploads both APKs as workflow artifacts on push and pull request to `main`.

## Compatibility notes

The module hooks readable TikTok names and discovers obfuscated places by strings and signatures on the first launch of a new version, then caches them. Compressed code (betas, universal APKs), relocated classes and LSPatch-patched installs are supported. Each feature starts separately: if one is not found, the others keep working.

Version 4.5.0 was tested on TikTok 47.6.3, 47.5.3, 47.4.3 and 47.1.4. The code has also been statically checked against TikTok global 47.9.3; on-device verification is still recommended after any TikTok update.

---

Back to [README](../README.md) · [Features](FEATURES.md) · [Contributing](../CONTRIBUTING.md)
