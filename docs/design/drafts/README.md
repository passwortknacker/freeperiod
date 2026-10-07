# FreePeriod. · Round 9

Open each HTML file directly in a browser at 100% zoom. Each board contains four fixed **360 × 780 px** screens, separated by **24 px**: Today, Day entry, History, and Today in dark mode. The board scrolls horizontally on smaller displays instead of shrinking the phones.

## 1 · Daylight

[Open draft-1.html](draft-1.html)

**Idea:** A warm, precise daily journal with a soft coral palette and comfortable sans-serif typography. A seven-day date ruler brings today into focus without turning the cycle into a countdown.

| Token | Light | Dark |
|---|---|---|
| Background / surface | `#FBF7F2` / `#FFFDF9` | `#211E1C` / `#2D2825` |
| Text / secondary text | `#302923` / `#6E6159` | `#FBF2E9` / `#C6B5A9` |
| Action / action text | `#F3B6A4` / `#302923` | `#EDB4A1` / `#302923` |
| Selected surface | `#F9DED3` | `#513C33` |
| Recorded period / outline | `#F3B6A4` / `#886357` | `#EDB4A1` / `#EDB4A1` |
| Prediction outline | `#71645C` | `#D1BAAD` |

**Fonts:** DM Sans, weights 400–700, for text and numerals. OFL; `Segoe UI`, then sans-serif, offline fallbacks.

**Signature:** The large numeral ends in a full stop, echoing FreePeriod.; a small outlined date tile anchors the ruler. Rounded, pale surfaces and dark text keep the coral soft without white-on-pastel contrast problems.

**Motion:** Move the selected ruler tile by one date over 160 ms; fade selection checkmarks over 100 ms. No idle motion; respect reduced motion and system haptic settings.

| EN | DE |
|---|---|
| Choose what you want to record. | Wähle, was du festhalten möchtest. |
| Your entry is saved. | Dein Eintrag ist gespeichert. |

**Distinctive because:** It makes the name's punctuation useful, gives a familiar calendar a recognisable date ruler, and uses coral as a soft material rather than a loud brand colour. This is the closest fit to the owner's five answers.

## 2 · Fieldnote

[Open draft-2.html](draft-2.html)

**Idea:** An evergreen and pale citron journal with the clarity of a well-made field notebook. A vertical, open timeline connects the recorded start, today, and the predicted range without drawing a closed cycle or implying completion.

| Token | Light | Dark |
|---|---|---|
| Background / surface | `#F4F3E9` / `#FFFEF5` | `#17271F` / `#21362B` |
| Text / secondary text | `#213F33` / `#5E6B5F` | `#F0F4DF` / `#B7C5AF` |
| Action / action text | `#244E3D` / `#FFFEF5` | `#DCE9A8` / `#213F33` |
| Selected surface | `#E6EDBC` | `#3C502E` |
| Recorded period / outline | `#DFE9AA` / `#627047` | `#DCE9A8` / `#DCE9A8` |
| Prediction outline | `#5C6D56` | `#C5D2AC` |

**Fonts:** Bricolage Grotesque, weights 500–700, for headings and numerals; DM Sans, weights 400–700, for controls and text. Both OFL; `Trebuchet MS` / `Segoe UI` fallbacks.

**Signature:** The vertical timeline, opposing rounded corners, and small end marks on the History bars. History reads like a ledger, with a single dark summary panel instead of a stack of cards.

**Motion:** Reveal an expanded detail row over 160 ms and fade its saved-value summary. No animated timeline growth, leaf movement, or ambient effects; remove transitions when reduced motion is enabled.

| EN | DE |
|---|---|
| Your days, at your pace. | Deine Tage, dein Tempo. |
| Record as much or as little as you like. | Halte so viel oder so wenig fest, wie du möchtest. |

**Distinctive because:** The notebook structure, asymmetrical corners, expressive sans-serif numerals, and green/citron contrast create a tactile identity without botanical illustrations or wellness symbolism.

## 3 · Interval

[Open draft-3.html](draft-3.html)

**Idea:** A crisp graphic calendar in ultramarine, ice, and midnight blue, with generous numerals and very little card chrome. A 30-day tick strip and a compact column chart make time and recorded cycle lengths immediately comparable.

| Token | Light | Dark |
|---|---|---|
| Background / surface | `#F3F5FB` / `#FFFFFF` | `#141C33` / `#1D2945` |
| Text / secondary text | `#192449` / `#59647E` | `#F1F4FF` / `#B4BFD9` |
| Action / action text | `#334BC4` / `#FFFFFF` | `#B3C3FF` / `#192449` |
| Selected surface | `#DDE4FF` | `#33466D` |
| Recorded period / outline | `#334BC4` / `#334BC4` | `#B3C3FF` / `#B3C3FF` |
| Prediction outline | `#53658E` | `#B4BFD9` |

**Fonts:** Space Grotesk, weights 400–700, for headings and numerals; Inter, weights 400–700, for body and controls. Both OFL; Arial / `Segoe UI` fallbacks. No monospaced type.

**Signature:** Oversized blue cycle-day numerals above a calendar-length tick strip. The strip maps actual April dates, not percentage completion; solid, outlined, and dashed ticks retain distinct meanings in monochrome.

**Motion:** Fade the current-date outline over 120 ms and translate a month transition by 12 px over 160 ms. Keep chart columns still when entering History; honour reduced motion.

| EN | DE |
|---|---|
| Your cycle, clearly laid out. | Dein Zyklus, übersichtlich dargestellt. |
| Next period likely Apr 28–30. | Nächste Periode voraussichtlich 28.–30. Apr. |

**Distinctive because:** It commits to typographic scale, aligned rules, and a true column chart, giving FreePeriod. a strong graphic identity without making Today feel like a medical dashboard.

## Recommendation

Choose **Daylight**: it directly answers the owner's preferences and has the calmest daily entry.
Choose **Fieldnote** if a more tactile, distinctive journal identity matters most.
Choose **Interval** if the owner prefers confident graphic design and stronger data visibility.

## Review notes

- Static visual mockups, not a working app: buttons illustrate controls; the four optional entry rows use native HTML disclosure elements. Opening a row scrolls the sheet, preserving the fixed phone dimensions. No JavaScript, image files, icon fonts, or embedded raster assets are used by the HTML.
- The only external resources are the explicitly requested Google Fonts stylesheet links. No fonts were downloaded during this offline round. Offline viewing uses the declared fallback fonts; final approval should also inspect the named web fonts. A production Android implementation would bundle the selected font and its OFL licence, with no network font loading.
- All calendar cells and controls have at least 48 × 48 px targets. Filled and outlined period markers, dashed predictions, today's solid ring, a saved-entry dot, checkmarks, labels, and the hatched excluded bar avoid colour-only meaning. The month uses US English week order; April 12, 2026 is Sunday.
- Small labels are for the requested 360 px review boards. Android implementation must support scalable text, wrapping, TalkBack, and scrolling without shrinking text. The selected direction still needs native large-font and German screenshot coverage.
- The requested History dates and lengths are intentionally preserved as independent design fixtures. They do not form a valid sequence of consecutive period starts and do not reconcile with the Today fixture; do not reuse them as engine test data. The four displayed eligible lengths have a median of **28.5 days**; the excluded 14-day cycle does not contribute. Displayed period lengths are 5, 5, 4, 6, and 5 days, with median **5 days**.
- In this Today state no period is ongoing, so **Period started** is primary and **Log today** remains secondary. The entry shows no flow and no start on April 12; an end-period control belongs to an ongoing-period state.
- Build and Robolectric/Roborazzi checks are not run: this round only changes static design files, and the prescribed Gradle check writes outside the scope fence. No app screenshot tests or reference images are added or changed. Local browser review artifacts stay under `.review/` inside this directory.
- **Verified offline in Chrome 154:** all 12 phone frames measure 360 × 780 px; all nine gaps measure 24 px; all controls meet 48 × 48 px; default content fits without horizontal overflow or vertical clipping. Computed visible text contrast passes AA thresholds in the rendered fallback fonts; essential control and calendar outlines were also checked against 3:1. All three rendered boards were visually inspected. Named Google Fonts remain unverified offline.

## 4 · Combined

[Open draft-4.html](draft-4.html)

**Idea:** The owner's selected combination brings Daylight's warm cream and slightly richer coral together with Fieldnote's typography and opposing rounded corners. A horizontal mini timeline sits beside the large **12.**, while History uses Interval's vertical columns inside the same visual system.

| Token | Light | Dark |
|---|---|---|
| Background / surface | `#FBF7F2` / `#FFFDF9` | `#211E1C` / `#302724` |
| Text / secondary text | `#302923` / `#6E6159` | `#FBF2E9` / `#C6B5A9` |
| Action / action text | `#EFA78F` / `#302923` | `#EFAC93` / `#302923` |
| Selected surface | `#F6D1C0` | `#604034` |
| Recorded period / outline | `#EFA78F` / `#8E5E4C` | `#EFAC93` / `#EFAC93` |
| Prediction outline | `#71645C` | `#D1BAAD` |
| Chart fill / outline | `#EFA78F` / `#8E5E4C` | `#EFAC93` / `#EFAC93` |

**Fonts:** Bricolage Grotesque 500–700 for headings and numerals; DM Sans 400–700 for controls and text, as in Fieldnote. Both OFL, with the same offline fallback fonts and Google Fonts links as draft 2.

**Signature:** A coral full stop after the large cycle-day numeral, beside a horizontal recorded-start / today / likely-start timeline. The solid period segment, today ring with entry dot, and dashed predicted segment use the calendar's marker language; full prediction wording and basis remain below.

**Panels and chart:** Fieldnote's opposing corner shapes carry through cards, primary actions, selected chips, and navigation. The shared averages panel uses coral with dark text; the five History columns retain their shared zero baseline, values above, dates below, hatched excluded cycle, caption, and excluded-cycle card with its prediction-use toggle. Thin dark outlines keep the soft coral chart and calendar fills identifiable against the cream background.

**Selection:** No checkmarks on chips, faces, symptoms, or the saved-status line. Selected entries combine a coral fill with a 2 px border, heavier text, and `aria-pressed`; all five mood faces retain their labels. The calendar, collapsed detail rows, and supplied data are preserved.

**Motion:** Brief selection-fill fades (100–120 ms) and detail-row reveals (160 ms); no idle motion or chart growth on entry. Honour reduced motion. These remain design notes, with no JavaScript or animation required by the board.

| EN | DE |
|---|---|
| Choose what you want to record. | Wähle, was du festhalten möchtest. |
| Your entry is saved. | Dein Eintrag ist gespeichert. |

**Trade-off:** The numeral is 78 px instead of Fieldnote's 86 px so the 178 px timeline can stay alongside it. Its date and marker labels are 11 px, with the full-size prediction below; the board retains 48 px controls, four 360 × 780 px phones, and 24 px gaps. Native larger-text layouts should stack this pair instead of shrinking either part.

**Checked in this round:** `python -B -`, 26 in-memory structural, content, geometry-budget, fallback-font measurement, and contrast checks passed, exit 0. The 26 palette-pair measurements have minima of 5.60:1 for text and 3.23:1 for essential outlines; decorative brand/full-stop accents are not information-bearing text. Fallback timeline labels have at least 26 px horizontal separation; closed Day entry and History content budgets are 730/732 px and 649.8/666 px respectively.

**Verification limit:** This round did not launch a browser, write preview images, or fetch fonts: a new Chrome session would write profile files outside the two-file scope fence. These are static fit and contrast checks, not a fresh browser-rendered overflow check; named-font rendering still needs owner/Claude review. No build, app tests, or screenshot tests were run or changed. The original README content and drafts 1–3 remain untouched.
