# Feed Beautifier for LinkedIn

A lightweight Chrome (Manifest V3) extension that lets you reshape your LinkedIn
home feed with three reading presets and one-click de-clutter toggles. Everything
runs locally in your browser — no accounts, no servers, no tracking.

## Features

**Layout presets**
- **Zen** — distraction-free single column (both side rails hidden).
- **Executive** — wide, information-dense reading column (right rail hidden).
- **Minimalist (Classic)** — familiar layout, ready for your toggles.

**De-clutter toggles** (mix and match with any preset)
- Hide promoted / sponsored posts
- Hide engagement-bait / vanity widgets
- Hide the left sidebar
- Hide the right sidebar
- Silence the messaging overlay

Changes apply instantly and your settings are remembered between visits.

## Install (from source)

1. Clone or download this repo.
2. Open `chrome://extensions` and enable **Developer mode**.
3. Click **Load unpacked** and select the `extension/` folder.
4. Open [linkedin.com/feed](https://www.linkedin.com/feed), click the toolbar
   icon, and pick a preset.

## Project structure

```
extension/
  manifest.json     MV3 manifest
  content.js        runtime controller (tags feed nodes, applies state)
  styles.css        design system for presets + modifier rules
  popup.html/.css/.js   control panel UI
  icons/            16 / 48 / 128 px icons
make-icons.ps1      regenerates the PNG icons
PRIVACY-POLICY.md   privacy policy
STORE-LISTING.md    Chrome Web Store listing copy
```

## Privacy

The extension stores only your layout preset and toggle settings, locally via
`chrome.storage.local`. Nothing is collected or transmitted. See
[PRIVACY-POLICY.md](PRIVACY-POLICY.md).

## Disclaimer

This is an independent project and is not affiliated with, endorsed by, or
sponsored by LinkedIn.

## License

MIT
