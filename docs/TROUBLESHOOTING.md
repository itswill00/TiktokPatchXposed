# Troubleshooting

## The module is not in TikTok's settings

1. In LSPosed, make sure the module is enabled and TikTok is ticked.
2. Force-stop TikTok and open it again.
3. Check the module's **Feature status** page — it reports what was found in your TikTok version.

## A feature stopped working after a TikTok update

Open **Feature status**. If it says **"Not found in this TikTok version"**, open an [issue](https://github.com/itswill00/TiktokPatchXposed/issues) and attach:

- your TikTok version and APK source (Google Play / universal / beta);
- your Android version and LSPosed version;
- the module's **bug report** from **More → Bug report**.

## TikTok shows "Restore the app"

Tap **Cancel**. Restoring resets TikTok's data.

## Safe mode

If TikTok closes right after starting three times in a row, the next launch runs in **safe mode**: nearly all features are off so you can open the settings and save a bug report. After saving the report, restart TikTok normally.

## Known limitations

- The TikTok icon cannot be changed by an Xposed module.
- Some elements drawn as images may keep TikTok's original colors even with a custom accent.
- TikTok's servers may reject very long comments, multi-photo comments or hashtag changes even when the client allows them.
- Region spoofing does not change your account region or IP address, so results are not guaranteed.
- 🧪 features work but are not fully tested; new features are off by default.

## Reporting a bug

Use **More → Bug report** inside the module. It collects the log, crashes and device information. Attach it to a GitHub issue — please redact any private data you do not want to share.

---

Back to [README](../README.md) · [Features](FEATURES.md) · [Building](BUILDING.md)
