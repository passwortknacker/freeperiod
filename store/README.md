# Release copy and artwork handoff

Only `site/` and `store/` belong to this round. App sources and screenshot references are read-only inputs. No site deployment, Play submission or PNG recording is performed here.

## Files and publication values

- `../site/index.html`: landing page with a temporary text badge for Google Play.
- `../site/privacy/index.html` and `../site/privacy/de/index.html`: English and German privacy policies, effective 2026-10-08.
- `../site/styles.css` and `../site/assets/fonts/`: Daylight palette, bundled Bricolage Grotesque and DM Sans, and their unchanged OFL notices. No external font request is needed.
- `../site/.nojekyll`: retained when publishing the site directory on GitHub Pages.
- `listing-en.md` and `listing-de.md`: four copyable listing fields with character counts. Both use the requested title, “FreePeriod. – Period Tracker”.
- `data-safety.md`: proposed Data safety answers, Health apps notes, content rating prompts and 13+ audience notes.
- `feature-graphic.html`, `screenshots.html`, `screenshots-de.html` and `artwork.css`: renderable artwork sources.

Replace these values before publication:

| Placeholder | Replacement |
|---|---|
| `JaySay (Marvin Kemper)` | Legal organisation name corresponding to the Google Play developer account. |
| `support@jaysay.it` | Monitored support/privacy contact address, including the mailto links. |
| `pavoras` | Actual GitHub owner in repository and proposed GitHub Pages URLs. If using a custom domain, replace the privacy URLs too. |
| `PLAY_STORE_URL` | Live Google Play listing URL for `org.freeperiod.app`; the current text badge is a placeholder, not official badge artwork. |

The policies assume GitHub Pages hosting and describe support email handling. Confirm those arrangements, controller contact details, retention practices and any applicable provider/legal-notice requirements before publishing. Play declarations remain proposals for the organisation to review against the live Console and final release. No medical-device certification is claimed. CSV import/export is included because it is an explicit release fact for this round, overriding older plan text that deferred import.

## Render the artwork

Open the HTML files from this checkout, keeping `site/`, `store/` and `app/` as siblings. All fonts and screenshots resolve locally. No build step or network access is needed.

Use a browser at 100% zoom and device scale factor 1. Wait for `document.fonts.ready` and for the images to finish decoding before capturing. Claude should inspect the resulting PNGs for wrapping and image quality; source checks are not browser rendering.

| HTML | Element to capture | Output dimensions |
|---|---|---|
| `feature-graphic.html` | `#feature-graphic` | 1024 × 500 px |
| Either screenshot board | Each `#shot-*` article below | 1080 × 1920 px each |

The screenshot board is a three-column, two-row overview. Capture individual articles for the store, not the entire overview. Export with an opaque background. Keep the original image aspect ratio; do not crop away or relabel app controls.

Suggested PNG names and selectors:

| Selector | EN name | DE name |
|---|---|---|
| `#shot-today` | `01-today-en.png` | `01-today-de.png` |
| `#shot-period` | `02-period-en.png` | `02-period-de.png` |
| `#shot-diary` | `03-diary-en.png` | `03-diary-de.png` |
| `#shot-history` | `04-history-en.png` | `04-history-de.png` |
| `#shot-settings` | `05-settings-en.png` | `05-settings-de.png` |
| `#shot-setup` | `06-setup-en.png` | `06-setup-de.png` |

## Screenshot inputs

| Panel | English reference | German board reference |
|---|---|---|
| Today | `today/regular_enLight.png` | `today/regular_deDark.png` |
| Ongoing period | `today/ongoingDay3_enLight.png` | `today/ongoingDay3_deDark.png` |
| Day entry | `day/filled_enLight.png` | `day/filled_deDark.png` |
| History | `history/chart_enLight.png` | `history/chart_deDark.png` |
| Settings | `settings/main_enLight.png` | `settings/main_deDark.png` |
| Past periods | `onboarding/pastPeriods_enLight.png` | `onboarding/pastPeriods_deDark.png` |

All references are relative to `../app/src/test/screenshots/`. German panels use the dark-mode references. Captions describe existing functions; no fertile-window image or claim is included.

Re-recorded app references will automatically appear in the boards. Final artwork review should use the references from the release candidate, since another round is changing the app in parallel.

Rendered PNGs (feature graphic and 2 × 6 screenshots) are in `png/` (`python tools/render-store.py`). Re-render after re-recording the app references.
