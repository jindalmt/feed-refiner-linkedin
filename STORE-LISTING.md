# Chrome Web Store — Listing Copy

Copy/paste the sections below into the Developer Dashboard. Replace anything in
[BRACKETS] with your own values before submitting.

---

## Item name (max 45 chars)

Feed Refiner for LinkedIn

---

## Summary (max 132 chars)

Reshape your LinkedIn feed: reading presets, de-clutter toggles, on-device AI/spam flags, TL;DR summaries & a daily post limit.

---

## Description (store "Detailed description" field)

Feed Refiner gives you back control of your LinkedIn home feed. Choose a
reading layout that fits how you work, switch off the parts you don't want to
see, and turn on optional insight tools that cut through the noise — all from a
single popup, with changes applied instantly. Everything runs on your device.

WHAT YOU GET

Three one-click layout presets:
• Focus Reader — an immersive, distraction-free single column. Both side rails
  hidden so you focus on the posts and nothing else.
• Compact Grid — a wider, high-density reading column with the right rail hidden.
  Great for skimming quickly.
• Modern Classic — keeps the familiar layout, premium-clean and ready for your
  de-clutter toggles.

Standalone de-clutter toggles (mix and match with any preset):
• Hide promoted posts & ads
• Hide job recommendations
• Hide the post composer
• Hide vanity metrics (reveal counts on hover only)
• Hide the left sidebar
• Hide the right sidebar

Insight tools — all optional, all 100% on your device:
• AI content detector — flags likely AI-written posts with a subtle 🤖 badge.
• Spam detector — flags emoji/hashtag storms and engagement-bait with a 📢 badge.
• Comment silencer — gently dims low-signal "engagement-pod" comments (canned
  praise, emoji-only reactions) so real discussion stands out.
• ⚡ TL;DR summarizer (on by default) — one click condenses a long post into a
  2-bullet summary using a local, offline text summarizer. Toggle it off in the
  popup, or flip back to the original instantly.
• Time Budget — set a daily post limit and get a gentle break screen when you
  reach it, with a live counter and reset.

WHY YOU'LL LIKE IT

• Instant — changes apply the moment you flip a switch, no page reload.
• Remembers you — your preset, toggles and daily count are saved locally and
  restored every visit.
• Private by design — the insight tools analyze post and comment text only inside
  your browser. Nothing is stored, logged, or sent to any server. No accounts,
  no tracking, no external code.
• Lightweight — mostly CSS restyling with a small content script.

HOW TO USE

1. Pin the extension and open linkedin.com/feed.
2. Click the toolbar icon.
3. Pick a preset, then toggle anything you want to hide or any insight tool.

Source code and issues: https://github.com/jindalmt/feed-refiner-linkedin

Feed Refiner is an independent project and is not affiliated with, endorsed
by, or sponsored by LinkedIn.

---

## Category

Productivity

---

## Language

English (United States)

---

## Permission justifications (Privacy practices tab)

storage:
Used to save the user's chosen layout preset, de-clutter/insight toggle settings,
and their local daily post counter in the browser so preferences persist between
visits. No data leaves the device.

activeTab / host access (www.linkedin.com/feed):
Required so the extension can restyle the LinkedIn feed page, apply the user's
selected layout, and run the optional on-device insight tools. The extension only
runs on linkedin.com/feed. The insight tools (AI/spam detection, comment
silencer, TL;DR) read the visible text of feed posts and comments in-page purely
to score/summarize it locally; that text is never stored, logged, or transmitted.

Single purpose:
The extension has one purpose — let the user customize and de-clutter their own
LinkedIn home feed, including optional on-device tools that reduce low-value
content and summarize long posts.

Are you using remote code? No.

Data usage — this item does NOT:
• collect or use personally identifiable information
• collect health, financial, authentication, or location data
• sell or transfer user data to third parties
• use or transfer data for purposes unrelated to the item's single purpose
• use or transfer data to determine creditworthiness or for lending

---

## Screenshots (you must provide — 1280×800 or 640×400)

Suggested set (take with the extension active on a real feed):
1. Focus Reader preset — single clean column.
2. Compact Grid preset — wide reading column, right rail hidden.
3. The popup open, showing the preset cards + De-clutter / Insights / Time Budget sections.
4. A post with the 🤖 AI and/or 📢 Spammy badge visible.
5. The ⚡ TL;DR summary box expanded on a long post.
6. Before/after: promoted posts hidden.
