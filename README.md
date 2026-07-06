# Feed Refiner for LinkedIn

A lightweight Chrome (Manifest V3) extension that reshapes your LinkedIn home
feed: pick a reading layout, switch off the clutter, and turn on optional
on-device insight tools that flag AI/spam content, dim engagement-pod comments,
summarize long posts, and keep your daily scrolling in check. **Everything runs
locally in your browser — no accounts, no servers, no tracking.**

## Features

### Layout presets
- **Focus Reader** — immersive, distraction-free single column (both side rails hidden).
- **Compact Grid** — wide, high-density reading column (right rail hidden).
- **Modern Classic** — the familiar layout, premium-clean and ready for your toggles.

### De-clutter toggles (mix and match with any preset)
- Hide promoted posts & ads
- Hide job recommendations ("Jobs recommended for you" carousel)
- Hide the post composer ("Start a post" box)
- Hide vanity metrics (reveal reaction/comment counts on hover only)
- Hide the left sidebar (profile & navigation rail)
- Hide the right sidebar (news, trending & puzzles)

### Insights (optional, 100% on-device)
- **AI content detector** — flags likely AI-written posts with a 🤖 badge using a
  family-based heuristic (lexical, structure, rhetoric, engagement, typography).
- **Spam detector** — flags emoji/hashtag storms and engagement-bait with a 📢 badge.
- **Comment silencer** — dims low-signal "engagement-pod" comments (canned praise,
  emoji-only reactions) to 25% so genuine discussion stands out.
- **⚡ TL;DR summarizer** *(on by default)* — adds a one-click button to long posts
  that condenses them to a 2-bullet summary with a local, deterministic
  frequency-based summarizer. Toggle back to the original instantly.

### Reading tools
- **Time Budget** — set a daily post limit; a gentle break screen appears once you
  reach it. Includes a live "Today's count" and a **Reset** button.

Changes apply instantly and your settings are remembered between visits.

## Privacy in one line

The insight tools read post and comment **text only inside your browser** to score
it — nothing is ever stored, logged, or sent anywhere. See
[PRIVACY-POLICY.md](PRIVACY-POLICY.md).

## Install (from source)

1. Clone or download this repo.
2. Open `chrome://extensions` and enable **Developer mode**.
3. Click **Load unpacked** and select the `extension/` folder.
4. Open [linkedin.com/feed](https://www.linkedin.com/feed), click the toolbar
   icon, and pick a preset.

## Project structure

```
extension/
  manifest.json         MV3 manifest
  content.js            runtime controller: tags feed nodes, applies state,
                        AI/spam/comment detection, TL;DR, Time Budget
  styles.css            design system for presets, badges, TL;DR box, overlay
  popup.html/.css/.js   control panel UI
  icons/                16 / 48 / 128 px icons
PRIVACY-POLICY.md       privacy policy
STORE-LISTING.md        Chrome Web Store listing copy
```

## How the detectors work (brief)

- **AI / spam detectors** — signals are grouped into capped "families"; a post is
  only flagged when independent families corroborate, which keeps false positives
  low (e.g. a normal post using "CEO"/"API" won't trip the spam caps filter).
- **TL;DR** — extractive summarization: split into sentences, build a
  stop-word-filtered word-frequency map, score each sentence by its normalized
  cumulative frequency (dampened by `√length`), and surface the top 2 in reading
  order. Deterministic, offline, never fabricates text.

## Disclaimer

This is an independent project and is not affiliated with, endorsed by, or
sponsored by LinkedIn.

## License

MIT — see [LICENSE](LICENSE).
