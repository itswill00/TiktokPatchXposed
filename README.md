# TiktokPatchXposed

[![CI](https://github.com/itswill00/TiktokPatchXposed/actions/workflows/android.yml/badge.svg)](https://github.com/itswill00/TiktokPatchXposed/actions/workflows/android.yml)
[![Release](https://img.shields.io/github/v/release/itswill00/TiktokPatchXposed)](https://github.com/itswill00/TiktokPatchXposed/releases/latest)
[![License: MIT](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)
[![Platform](https://img.shields.io/badge/platform-Android%208.1%2B-green.svg)](https://www.android.com/)

**English** | [Russian](README-RU.md)

An [LSPosed](https://github.com/JingMatrix/LSPosed) module for TikTok. It removes ads, lets you download anything in the quality you want, turns on features TikTok rolls out only to some people, and adds many small things: auto-scroll everywhere, your own color, font and AMOLED theme, hiding parts of the screen, country flags, invisible mode and auto streaks. All settings live right inside TikTok.

> **Current version: 4.5.0** · Tested on TikTok **47.6.3**, **47.5.3**, **47.4.3**, **47.1.4** (Google Play and universal APK), **Android 16**. A static compatibility check has also been done against TikTok global **47.9.3**.

## Contents

- [Highlights](#highlights)
- [Screenshots](#screenshots)
- [Installation](#installation)
- [Documentation](#documentation)
- [Building](#building)
- [Compatibility](#compatibility)
- [Limitations](#limitations)
- [Disclaimer](#disclaimer)

## Highlights

| Area | Examples |
| --- | --- |
| **Feed** | no ads, hide LIVE and "People you may know", only fresh/unseen videos, own filter by words, authors, countries, likes, views and duration |
| **Playback** | auto-scroll everywhere, exact dates and counts, own speeds, 3×, refresh rate, seek on every video, separate Wi-Fi/mobile quality |
| **Interface** | own accent color and font, AMOLED theme, hide elements, opacity, burn-in protection, time on messages |
| **Comments** | translate buttons and auto-translate, copy text only, author flags, comment reposts |
| **Downloads** | no watermark, quality picker, carousels, stickers, stories, avatars, LIVE recording, clean links |
| **Privacy** | invisible mode, hide typing/online/read, block trackers, random device ID |
| **Region & streaks** | SIM country, recommendations in your language, auto streaks with flames or stickers |
| **Experiments** | hidden TikTok features, no forced login, no hashtag limit, camera extras |

See the [full feature reference](docs/FEATURES.md). Former experimental features are enabled by default; other switches stay optional.

## Screenshots

<details>
<summary>Show screenshots</summary>

<p align="center">
  <img src="docs/media/main-en.png" width="250" alt="The module's main settings screen">
  <img src="docs/media/status-en.png" width="250" alt="Feature status">
  <img src="docs/media/interface-en.png" width="250" alt="The Interface section">
</p>

<p align="center">
  <img src="docs/media/hide-en.png" width="250" alt="Hide elements">
  <img src="docs/media/color-en.png" width="250" alt="Own accent color">
  <img src="docs/media/downloads-en.png" width="250" alt="Downloads and links">
</p>

</details>

## Installation

**You need:** Android 8.1+, root and [LSPosed](https://github.com/JingMatrix/LSPosed) (libxposed 101–102 or old LSPosed 1.9.x), TikTok from Google Play (`com.zhiliaoapp.musically`).

1. Download the APK from the latest [release](https://github.com/itswill00/TiktokPatchXposed/releases/latest) and install it.
2. In LSPosed, enable the module and tick TikTok.
3. Force-stop TikTok and open it again.

**Settings:** `TikTok → Profile → ☰ → Settings and privacy → TiktokPatchXposed` (the first row). The screen is translated into 13 languages, including Arabic and Chinese, and follows TikTok's language. When a setting needs a restart, a **Restart** button appears at the bottom. To update, install the new APK over the old one; settings are kept.

## Documentation

| Document | About |
| --- | --- |
| [Full feature reference](docs/FEATURES.md) | Every feature by area, no experimental labels |
| [Building](docs/BUILDING.md) | JDK/SDK, `build.sh`, Telegram upload, Gradle and CI |
| [Troubleshooting](docs/TROUBLESHOOTING.md) | Common problems, safe mode, limitations, bug reports |
| [Contributing](CONTRIBUTING.md) | Branches, signed commits, tests, code layout |
| [Docs index](docs/README.md) | All documents in one place |
| [Russian README](README-RU.md) | Russian translation |

## Building

```shell
./build.sh
```

The script runs the unit tests, builds debug and release, uploads new APKs to Telegram and prints a compact summary. Options and manual Gradle commands are in [docs/BUILDING.md](docs/BUILDING.md).

## Compatibility

The module hooks only TikTok's readable names. Obfuscated places are discovered by strings and signatures on the first launch of a new version, then cached. Compressed code (betas, universal APKs), relocated classes and LSPatch-patched installs are supported. Each feature starts separately: if one is not found, the others keep working.

## Limitations

- The TikTok icon cannot be changed.
- Some elements drawn as images may keep TikTok's original colors.
- TikTok's servers may reject very long comments, multi-photo comments or hashtag changes.
- Region spoofing does not change your account region or IP address, so the result is not guaranteed.

See [docs/TROUBLESHOOTING.md](docs/TROUBLESHOOTING.md) for details.

## Disclaimer

> Modifying the client and automated actions can lead to account restrictions. Use at your own risk. This is an unofficial project, not affiliated with TikTok or ByteDance.

## License

[MIT](LICENSE) © TiktokPatchXposed contributors.
