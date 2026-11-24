# Contributing

Thanks for helping improve TiktokPatchXposed.

## Workflow

1. Fork the repository or create a branch from `main`.
2. Make one logical change per commit.
3. Run the tests and build before pushing.
4. Open a pull request with a short description of what changed and how you verified it.

## Branch naming

Use a short, descriptive branch name, for example:

```text
feat/tiktok-47.9.3-compat
fix/comment-translate-expiry
docs/readme-structure
```

## Commit messages

- Write messages in **English**.
- Use the imperative mood: `Fix …`, `Add …`, `Guard …`, `Check …`.
- Sign every commit with `git commit -s`.

The signoff must match your GitHub identity:

```text
Signed-off-by: itswill00 <anstykx00@gmail.com>
```

Check it with:

```shell
gh api user --jq .login
git config user.name
git config user.email
git log -1 --format=full
```

## Tests and build

```shell
./build.sh                  # tests + debug + release + Telegram upload
./build.sh --no-upload      # local build only
./build.sh --no-tests       # faster build when tests were already run
```

For a focused test run:

```shell
cd source && ./gradlew testDebugUnitTest
```

New pure logic should come with a JUnit4 test in `source/app/src/test/java/com/golda/patchertiktok/`. No device or Robolectric is needed.

## Code layout

- All module code lives in one flat package: `com.golda.patchertiktok`.
- A feature is usually a small final class with `static void install(ClassLoader loader)`.
- Registration happens in `Module.java`; failures are isolated by `Module.run(...)` and shown in **Feature status**.
- Settings keys live in `Prefs.java`; UI strings live in `I18n.java` tables for all 13 languages.
- Hook/reflection helpers: `Hooks.java`, `Reflect.java`, `Discovery.java`, `DexFinder.java`.

When adding a setting:

1. add the key in `Prefs.java` (and to the export/import key arrays if it is a value, not a switch);
2. add the row in `ModSettingsActivity.java`;
3. append the strings to **every** language table in `I18n.java` — `I18nTest` checks table parity and format specifiers;
4. wire the feature in `Module.java`;
5. add unit tests for any pure logic.

## Secrets

Never commit credentials. The Telegram bot token and chat ID belong in `source/local.properties` (gitignored) or in environment variables (`TELEGRAM_BOT_TOKEN`, `TELEGRAM_CHAT_ID`).

## Documentation

- Start here: [README.md](README.md) / [README-RU.md](README-RU.md)
- Full feature list: [docs/FEATURES.md](docs/FEATURES.md) / [docs/FEATURES-RU.md](docs/FEATURES-RU.md)
- Build details: [docs/BUILDING.md](docs/BUILDING.md)
- Troubleshooting: [docs/TROUBLESHOOTING.md](docs/TROUBLESHOOTING.md)
- Docs index: [docs/README.md](docs/README.md)

## License

By contributing you agree that your changes are licensed under the [MIT License](LICENSE).
