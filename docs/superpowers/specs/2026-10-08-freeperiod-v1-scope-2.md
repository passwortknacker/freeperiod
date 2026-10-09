# FreePeriod. – v1.0 scope revision 2 (2026-10-08)

Extends and partly overrides `2026-10-07-freeperiod-design.md`. Owner-approved in chat on
2026-10-08. Where this file and the original spec differ, **this file wins**.

## 0. Principle

Lightweight by default, more when you need it. Setup asks for life phase (and optionally the
contraception method) and configures the app; every extra is opt-in in Settings, never in the
user's face. No medical advice: we only show what the user logged, calendar arithmetic and clearly
labelled estimates; reminders only for what the user configured.

## 1. Design system (final reference: `docs/design/drafts/draft-5.png`)

- **Palette:** Daylight (draft 1) – warm cream surfaces, soft coral accent; dark mode as in the
  draft. No wallpaper/dynamic colour (removed).
- **Accent choice:** 6 accents, default **Coral**; others Plum, Sage, Ocean, Ochre, Ink. Each has a
  verified light + dark tonal set (accent, on-accent, container, period fill, today ring, selected
  chip) with WCAG AA text contrast and ≥3:1 for essential graphics. Predicted = dashed outline in a
  neutral-violet that works with all accents. Setting: Settings → Appearance → Accent colour.
- **Typography:** Bricolage Grotesque (headings, numerals) + DM Sans (text, controls); bundled
  font files (OFL) + licence; no downloadable fonts.
- **Shapes:** Fieldnote box style (cards/panels, corner shapes, borders) from draft 5.
- **Signature:** large cycle-day numeral followed by a coloured full stop with a small gap,
  baseline-aligned ("12."); also "History." style headings only where the draft shows it.
- **Chips/faces:** selected = filled accent container + slightly stronger border + medium weight;
  **no checkmarks**.
- **Bottom navigation:** selected pill taller, closer to the label (draft 5).
- **Icons:** own simple line icons or Material Symbols shapes (Apache-2.0); no proprietary sets.
- **Motion (subtle):** period start fills the calendar day (≈160 ms) + one light haptic; chip
  selection fade (≈120 ms); month change slide+fade (≈180 ms). Respect "remove animations".

## 2. Today

- Card: label ("Cycle day" or "Period · day N"), numeral + full stop, **horizontal mini timeline**
  to the right, prediction sentence + basis below, primary + secondary action.
- **Timeline = the whole current cycle:** axis from the current cycle's start (latest period
  start) to the end of the likely range (or, without a prediction, to start + max(typical/median
  length, cycle day + 3)). Marks: recorded period days (solid accent), expected remaining period
  days while ongoing (light accent, from typical period length), today (ring), likely next start
  range (dashed bracket). Labels: start date "Start", "Today", range "Likely". Same identity on
  day 1 and day 25. Pill rhythm: the bracket shows "Pill-free days" instead of "Likely".
  Menopause phase: no timeline; card shows "N months without a period" (or "Last period: date").
- Primary action: no ongoing period → "Period started"; ongoing → **"Period ended"**, which saves
  **yesterday** as the last bleeding day (today = first day without bleeding); if the period
  started today, end = start. Secondary: "Log today".
- Range passed: unchanged ("Your expected range has passed …").
- Calendar: period filled, predicted dashed, today ring, entry dot, legend; fertile window (if
  enabled) = soft band behind the numbers with its own legend item.

## 3. Day entry

- Order: **Mood**, Flow, Pain, Symptoms (open); Sex, Discharge, Tags, Note and any custom
  categories collapsed with a summary.
- **Note:** tapping expands an inline multi-line text field (soft background, autosave,
  placeholder "Anything else about today?", max 2000 chars); collapsed row shows the first words.
- **Customizable:** in Settings → Day entry: show/hide and reorder categories; show/hide built-in
  items; add own items (name + icon from a bundled set) to any multi-select category; add own
  categories (multi-select chips). "Tags" becomes the default custom category.
- **Phase-specific built-in items** appear automatically for the phase (and can be hidden):
  Menopause → hot flushes, night sweats, brain fog, joint pain (insomnia exists); Trying to
  conceive → ovulation test (negative/positive).

## 4. My situation (life phase + method)

- **Life phase:** Regular tracking (default), Trying to conceive, Pregnant, After birth /
  breastfeeding, Perimenopause / menopause. Asked in setup, changeable in Settings.
  - Pregnant, After birth: predictions and the period reminder pause automatically (diary stays).
  - Trying to conceive: offers to enable the fertile window (still opt-in + disclaimer).
  - Menopause: no prediction; months-without-period counter; menopause items on.
- **Method (optional):** None, Pill (combined), Mini-pill, Ring, Patch, Hormonal IUD, Copper IUD,
  Implant, Injection, Condoms, Other.
  - Pill (combined): optional pack rhythm (21+7, 24+4, 28 continuous, custom active/break days) +
  pack start date → calendar/timeline show **pill-free days** (calendar arithmetic) instead of a
  statistical prediction; offer daily pill reminder.
  - Mini-pill: offer daily reminder; predictions labelled "may be irregular".
  - Ring/Patch/Injection: offer reminder at the user's interval.
  - IUD/Implant: offer reminder on a date the user enters (e.g. replacement/check-up).
  - Never: efficacy/protection statements, dosing advice. Missed pill → only "Check your package
  leaflet or ask your pharmacy."

## 5. Reminders (generic engine)

- One reminder engine; method presets only pre-fill it. Kinds: period due (prediction-based,
  N days before), daily log, pill, method, custom.
- Recurrence: daily; every N days; weekly on a weekday; monthly on day D; every N months from an
  anchor date; once on a date. Time of day per reminder. All opt-in; neutral text by default.
- Settings → Reminders lists all, add/edit/delete.

## 6. Predictions v2

- Centre = last start + round-half-up(median of the **last 6** eligible cycles).
- Half-width from the **last 12** eligible cycles: 1–2 cycles → max(2, ceil((max−min)/2));
  ≥3 → max(1, ceil(MAD × 1.5)); > 7 → "varies a lot".
- **Missed-log hint:** a completed cycle longer than 1.6 × median (with ≥3 eligible cycles) shows
  "That was a long cycle. Did you forget to log a period?" in History (dismissable).
- Pill rhythm, pregnancy, postpartum, menopause, pause: as in §4.
- **Fertile window (opt-in):** only when the state is a date range and the phase/method do not
  suppress it (no pill/ring/patch/injection/implant/hormonal IUD, not pregnant/postpartum/
  menopause). Estimated ovulation = predicted start centre − 14 days; window = ovulation − 5 …
  ovulation + 1. Enabling shows a disclaimer dialog: "This is a rough calendar estimate. It is not
  suitable for contraception or medical decisions." Label everywhere: "Possible fertile days
  (estimate)".

## 7. Onboarding v2 (all skippable)

1. Welcome + three promises. 2. Life phase. 3. Method (optional, with pill rhythm if pill).
4. **Past periods:** a vertically scrolling calendar of the last 6 months; drag across days to
   mark a period (or tap single days; tap again to unmark); creates completed periods.
5. Usual cycle length or "I don't know" (hidden when ≥2 periods entered). 6. Reminders opt-in.

## 8. History v2

- Horizontally scrollable bar chart, latest cycle at the right, older cycles fade at the left.
- Tap a bar → bottom sheet: dates, cycle length, period length, reason if auto-excluded,
  "Use for predictions" switch.
- Below the chart: only the excluded cycles inside the visible range (compact row + switch).
- Averages panel; symptom frequency (monthly view in menopause phase).

## 9. Removed / moved

- Removed: dynamic (wallpaper) colour.
- Moved to v1.1: automatic weekly backup (joins import, Health Connect, widget, quick-settings
  tile, PDF report). v1.2: supporter purchase (decision later), more languages, F-Droid.
- Monetization v1.0: none in the app. Donation links only on GitHub README/website.

## 10. Release facts

- Package `org.freeperiod.app` (final). Target audience 13+. Privacy policy on GitHub Pages
  (domain later). Support contact: a dedicated Gmail address (owner provides).

## 11. Change 2026-10-08 (regulatory check) – fertile window removed from v1.0

A competitor ("Period Tracker and Calendar", SimpleInnovation) markets itself as a **CE Class I
medical device** for "predictions for upcoming periods and estimated fertile windows", and a Swiss
court ruled that software estimating fertile phases for conception/contraception qualifies as a
medical device. Because the owner does not want legally grey territory, the **fertile window is
not shipped in v1.0** (engine code stays, no UI, no setting). "Trying to conceive" remains a
logging view only (ovulation tests, no estimates). Period predictions stay, framed as calendar
estimates from the user's own entries. Revisit only with proper legal advice.

## 12. Owner decision 2026-10-08 (evening) – "higher chance of pregnancy" days in v1.0, default on

Supersedes §11. Claude advised against it (EU MDR Art. 2(1) lists software intended for the control or
support of conception as a medical device; a disclaimer does not change an evident purpose; Clue is CE
Class I for the same feature; main practical risk in Germany: competitor warning letters). The owner
decided, knowing this: ship it in v1.0, **on by default**, with a prominent disclaimer. Implementation
keeps the risk as low as possible:

- Wording: "Days with a higher chance of pregnancy" / "Tage mit erhöhter Chance auf eine
  Schwangerschaft" – always marked as a **calendar estimate**. Never "fertile window", "ovulation day",
  "safe days" or anything that suggests contraception or conception planning.
- Shown only for statistical predictions in compatible situations (`fertileWindowAllowed()`); hidden
  for pregnancy, postpartum, menopause, hormonal methods, "varies a lot" and when predictions are paused.
- One setting to switch it off (Settings › My situation). No push notifications for these days.
- Disclaimer ("FreePeriod. is not a medical device …": no contraception, no help to conceive, no
  medical advice, no diagnosis, no treatment; all estimates are calendar estimates from the user's
  own entries without any reliability) appears: once in onboarding (welcome step), in Settings ›
  Privacy & info, next to the days (info tap), in the store listing and on the website.

## 13. Owner decisions 2026-10-09 (post-polish, shipped in 1.0.0)

- **Prediction as a probability:** the start of the next period is a normal distribution
  (centre ± spread; spread from cycle history: `max(1, MAD × 1.4826)`, early estimate
  `max(1.5, (max − min) / 2)`, typed length only 2.5 days). A day's chance of being a period day =
  sum of start weights over the period length. Calendar: **likely** from 60 %, **possible** from
  30 % (dashed ring). If no day of the next period reaches 30 %, the start range shows as possible.
- **Two periods, never more:** the period after next uses centre + cycle length and spread × √2,
  and counts as possible from **20 %** (short periods with wide spread never reach 30 %). Not shown
  for a typed length alone. Start-days-only was rejected by the owner.
- Today card shows no prediction sentence and no basis line when the timeline shows the range; the
  basis lives in History. Calendar snaps whole week rows; legend in two lines under a divider
  ("Erwartet"/"Likely", "Möglich"/"Possible").
- **CSV export:** one file, one row per day, `period_day` column; FreePeriod.'s import reads it back.
- **Settings:** typical cycle length shows the measured value ("28 Tage") once cycles exist;
  archived categories can be restored; app lock explains itself when switched on and offers
  immediately / 1 / 5 / 10 / 15 minutes.
- **Day entry:** 102 icons in 10 groups for items and categories; opening the note scrolls to it
  and focuses it.
- **Accents:** Today uses the same accent as every other screen (pale fills get a thin edge for
  contrast). Ink is the dark, non-pastel alternative (light #2F3440 with light text, dark graphite
  #9A9EA6); text on an accent follows the fill's luminance.
- **Texts:** counts use plural forms in EN and DE ("based on your last cycle", "vor 1 Tag").
- **Store:** shorter full descriptions, the word "sex" avoided in listing texts; artwork headings
  use the app's Bricolage cut (SemiBold, opsz 24, normal width), captions ≥ 12 dp on a phone.
