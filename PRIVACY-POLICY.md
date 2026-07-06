# Privacy Policy — Feed Refiner for LinkedIn

**Last updated: 5 July 2026**

Feed Refiner for LinkedIn ("the extension") is committed to protecting your
privacy. This policy explains what the extension does and does not do with your
information.

## Summary

The extension does **not** collect, store, transmit, sell, or share any personal
data. Everything it does happens locally inside your own web browser.

## What the extension stores

The extension saves your chosen layout preset (Focus Reader, Compact Grid, or
Modern Classic), your de-clutter and insight toggle settings (such as hiding
promoted posts, the AI/spam detectors, the comment silencer, or the ⚡ TL;DR
summarizer), and your local daily post counter used by the optional Time Budget
feature. These preferences are stored using the browser's local
`chrome.storage.local` API so that your settings are remembered between visits.

This data:

- never leaves your device;
- is not transmitted to us or to any third party;
- is not used for advertising, analytics, tracking, or profiling;
- can be cleared at any time by removing the extension or clearing your browser's
  extension data.

## What the extension accesses

The extension runs only on `https://www.linkedin.com/feed/` pages. It reads the
structure of the feed to apply your chosen visual layout and hide the elements
you selected.

When you enable an optional insight tool (the AI content detector, spam detector,
comment silencer, or the ⚡ TL;DR summarizer), the extension also reads the
visible **text** of feed posts and comments so it can score or summarize that
text. This analysis happens **entirely on your device, in memory, at the moment
you view a post**. The extension does **not** store, log, record, or transmit
that text, your messages, your profile, or any other information. Nothing is sent
to us or to any third party, and no copy of the text is retained after the page
is closed.

## Data collection

We collect **no** personal information. There are no accounts, no servers, no
cookies set by the extension, and no analytics.

## Third parties

The extension does not send data to any third party and does not include any
third-party tracking or advertising code.

## Permissions

- **storage** — to save your layout, toggle, and daily-count preferences locally.
- **activeTab / host access to www.linkedin.com/feed** — to restyle the LinkedIn
  feed page you are viewing and, when enabled, run the on-device insight tools
  described above.

## Changes to this policy

If this policy changes, the updated version will be published at this URL with a
revised "Last updated" date.

## Contact

For questions about this policy, open an issue at:
https://github.com/jindalmt/feed-refiner-linkedin/issues

---

*Feed Refiner for LinkedIn is an independent project and is not affiliated
with, endorsed by, or sponsored by LinkedIn.*
