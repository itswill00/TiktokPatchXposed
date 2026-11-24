# Feature reference

Every setting lives inside TikTok: **TikTok → Profile → ☰ → Settings and privacy → TiktokPatchXposed**.

Former experimental features are enabled by default; the remaining off-by-default switches are ordinary optional preferences.

## Feed

- **No ads** — in the feed, at startup, inside videos and in other video lists.
- **Hide LIVE** — streams in the feed and the LIVE button.
- **Hide "People you may know"** — videos and whole cards with people from your contacts.
- **Hide paid content and products**, **hide AI videos**.
- **Only fresh videos** — hides recommendations older than the chosen period.
- **Hide videos I've seen** — the module remembers what you watched and leaves it out when TikTok sends it again.
- **Own filter** — by words, hashtags, authors, countries, minimum likes/views and video duration.

## Playback

- **Auto-scroll everywhere** — in search, following and chats; profiles and liked videos have their own switch in the long-press menu. Off everywhere by default; photo posts by music length.
- **Exact date and time** — on videos, stories, comments and reposts, with seconds if you like.
- **Exact numbers** — likes, comments, shares, views and profile counts in full.
- **No like on double tap** — double-tapping a video no longer likes it.
- **Picture-in-picture** — TikTok's own floating video window.
- **3× speed** in TikTok's own speed menu.
- **Screen refresh rate** — hold 60, 90 or 120 Hz; TikTok no longer lowers it to the video's frame rate.
- **Own speeds** and **remember speed**.
- **Resume where you left off**, **keep "Clear display"**.
- **Seek on every video** — on short ones the bar stays hidden, drag along the bottom edge of the video.
- **Sound in muted videos** — brings back sound TikTok turned off over copyright, if the video still has it.
- **Quality for Wi-Fi and mobile data separately** (best, saver or TikTok's choice), **H.264 video**, **no HDR**, **photos in the best quality** (up to 8 MP).

## Interface

- **Own accent color** — a palette or HEX; recolors TikTok's red in buttons, icons, likes and your name.
- **Own font** — the system font or any `.ttf` / `.otf` from your phone instead of TikTok Sans.
- **AMOLED theme** — pure black, turns TikTok's dark theme on by itself.
- **Hide elements** — side buttons, the music disc, author and caption, the Tako button.
- **Interface opacity**, **OLED burn-in protection** and **keep brightness** (TikTok no longer turns it up in the camera and editor).
- **New profile layout**, **account creation date** under the name, **hide stories in the Inbox**.
- **Time on messages** — under every chat message.
- **"Read all"** — hold the Inbox tab.
- **Keep unsent messages** — a message the other person unsent stays, marked "Unsent" in red; photos, videos and stickers may need a restart.

## Comments

- **TikTok's translate buttons** — an icon on every foreign comment and "Translate all" in the comments header, even if TikTok never showed them to you.
- **Auto-translate comments** — turns TikTok's translation on for all comments right away.
- **Copy text only**, **author's country** (a flag next to the video date, in profiles and in comments), **@username of commenters**.
- **Flag details** — tap the flag to see the account and video region, languages and tagged place.
- **Comment reposts**; **repost your own videos**.
- **Up to 9 photos in a comment**.

## Downloads and links

- **No watermark**, **download any video**, **quality picker** and "Audio only".
- **All photos from a carousel**, **stickers and photos from comments**, **stickers from chats**.
- **Save stories and highlights** (hold a story) and **profile photos** (hold the enlarged photo).
- **Record LIVEs** — a REC button in a LIVE records it in the quality you pick to Movies/TikTok (MP4), or copies the stream link. Android 10+.
- **Save location and names** — where files go (by type, Download or DCIM) and a name template with author, date and quality.
- **Upload in HD**, as with TikTok's "Upload HD" switched on, and a bitrate choice: 12, 20 or 30 Mbit/s.
- **Upload the original (up to 4K)** — an unedited video goes up as the file itself, without TikTok re-encoding it.
- **Clean links** (no tracking), **links in your browser**, **screenshots everywhere**.

## Privacy

- **Invisible mode** — not showing up in story and highlight views (a separate switch), profile and video views. On your phone the story still counts as watched.
- **In chats:** hide "typing…", "online" and "Read" (with "Mark as read" in a message's menu and "Read" when you reply).
- **Block location**, **hide VPN**, **random device ID**, **hide root**, **no motion tracking**, **no passkey prompts**.
- **Analytics:** block third-party trackers (Google/Firebase, Facebook, AppsFlyer) and don't send TikTok's analytics.

## Region

- **Country**: SIM, carrier and time zone of about 190 countries (Germany by default).
- **Recommendations in my language**.
- **Own recommendation region**: the SIM stays in the chosen country while the feed comes from another one.

The module doesn't change the account's region or your IP address, so the result isn't guaranteed.

## Streaks

- **Auto streaks**: keep existing streaks in one-to-one chats going while TikTok is open. Sent when a streak starts to fade, or at your own time (if it would end sooner, it goes an hour before the end). A flame or a sticker from your favorites, to everyone or only chosen chats; the settings show how it will look in the chat. If you already wrote to that chat today (also from another phone), nothing is sent again. If TikTok rejects a flame, you get a notification.

## Experiments

- **Hidden TikTok features**: hold-to-speed-up, audio and photo comments, comments to favorites and more.
- **No forced login**, **no hashtag limit**, **camera extras** (teleprompter, green screen).

## Settings screen

A "Main" tab with the features people use most, and "All" with the full list. Search across settings, how many features are on in each section, **Feature status** (what was found in your TikTok version, and why something was not). Under "More": export and import of settings as a `.json` file, reset all settings and a **bug report** (log, crashes, device; attach it to an issue). If TikTok closes right after starting three times in a row, the module runs one launch in **safe mode** so the report can be saved.

---

Back to [README](../README.md) · [Building](BUILDING.md) · [Troubleshooting](TROUBLESHOOTING.md)
