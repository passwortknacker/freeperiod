# FreePeriod. – product brief (draft, 2026-10-07)

Status: **superseded** by `docs/superpowers/specs/2026-10-07-freeperiod-design.md` (kept as input
of review round 1). Research: `docs/research.md`.

## Goal and success
- Free Android period tracker, no ads, no subscription, ~0 € running cost, works fully offline.
- Success = **reach** (help as many people as possible; ASO and polish matter) + **reputation**
  (open source, GPL-3.0, repo public at v1.0). Donations are a nice-to-have.
- Inspiration: Daylio (fast icon-based logging), Flo/Clue (feature set), Period Calendar by
  Simple Design (100M+ installs: simple calendar wins mass market).
- Market gap: polished + private. Private FOSS trackers exist (drip, Mensinator, Mooneva, Bluma,
  Euki) but are utilitarian and mostly on F-Droid; polished trackers monetize via ads/paywall/data.
- Owner: one developer with an existing Google Play organisation account (another app live).
  Implementation mostly by Codex, supervised by Claude.

## Decisions so far (by the owner)
- Name: **"FreePeriod."** (the full stop is part of the name; pun on period = full stop).
  Play title "FreePeriod. – Period Tracker" (28/30). Fallback name "Plain Period" if Play objects
  to "free" in the title (metadata policy bans price/promotional info; brand pun = grey area).
- Languages at launch: DE + EN; more (ES, FR, PT, IT …) in v1.x.
- Look: calm & minimal, lots of white space, one warm accent (e.g. coral), line icons,
  Material You aware.
- Home: "today" card on top ("Cycle day 12 · period in ~9–11 days" + one primary button:
  "Period started" or "How are you today?"), current month calendar below.
- Fertile window + ovulation: estimate, **on by default**, clearly labelled
  "estimate – not contraception". No temperature / sympto-thermal method.
- v1.0 scope (all four chosen):
  1. Core: one-tap period start/end, calendar, next-period prediction as a range, stats
     (average cycle and period length, history).
  2. Daily entry Daylio-style: flow, mood, symptoms, pain, sex, discharge, note, custom tags.
  3. Reminders (period due, pill), home-screen widget, quick-settings tile.
  4. Encrypted backup file, import (Clue, drip, CSV), PDF report for doctor, biometric/PIN lock.
- Monetization: v1.0 none. v1.1 optional "Supporter" via Play Billing: cosmetics only (themes,
  icon packs, alternative app icons, badge); one-time (~4.99 €) and ~1 €/month. All tracking
  features free forever, promised in writing. No external donation links inside the Play app
  (Play payments policy; WireGuard precedent). GitHub Sponsors/Ko-fi in repo/website only.

## Proposed by Claude (not yet approved)
### Approach
Native Kotlin + Jetpack Compose (same stack as owner's other app). Alternatives rejected:
Flutter (widget/tile/Health Connect need native anyway, new tooling), Compose Multiplatform
(iOS not requested).

### Architecture and privacy
- Modules: `:engine` (pure Kotlin/JVM: cycle derivation, prediction, import parsers) and `:app`
  (Compose UI, Room DB, DataStore settings, reminders, Glance widget, TileService, BiometricPrompt
  lock, PdfDocument report, backup).
- Single source of truth: one `DayLog` per date (flow level incl. spotting, mood, symptoms set,
  pain, sex, discharge, pill taken, tags, note). Periods are **derived** from flow days
  (merge gaps of ≤1 day); "period started/ended" buttons just write flow on days.
- **No INTERNET permission in v1.0.**
- Phone switch: allow Android device-to-device transfer; disable cloud auto-backup; manual
  password-encrypted backup file (AES-GCM, key from PBKDF2/Argon2) + optional weekly automatic
  backup into a user-chosen SAF folder (can be a Drive folder).
- At-rest: rely on Android file-based encryption + optional app lock; no SQLCipher in v1.
- Discreet mode: neutral notification texts, optional disguised launcher icon (activity-alias).
- Crash data only via Play Console vitals; no analytics SDK. minSdk 26, target latest.

### Prediction (planned)
- Cycle length = start-to-start. Use last ≤12 cycles; ignore implausible (<15 or >90 days) and
  user-excluded cycles (e.g. pregnancy, after stopping the pill).
- Next start = last start + median cycle length; range = ± variability (e.g. MAD/SD clipped to
  1–7 days). Fewer than 2 cycles → user's typical length from onboarding (default 28) + wide range.
- Period length = median of logged periods (default 5).
- Ovulation ≈ next start − 14; fertile window = ovulation −5 … +1; shown as soft band + label.
- Show confidence ("based on N cycles"); flag irregularity when variation ≥ ~8 days;
  "period X days late" gently when past the range.

### Onboarding
Optional: last period start, usual cycle length; skippable. Neutral wording ("you").

### Testing
Engine unit tests (heavy), Room/repository tests, Robolectric + Roborazzi screenshot tests for
key screens (DE/EN, light/dark).

### Release (rough)
Internal test → closed test → production on owner's Play organisation account. Needs:
privacy policy (in app + Console), Health apps declaration, Data safety form ("no data
collected/shared"), content rating, store listing DE/EN, screenshots. Website for privacy policy
on a cheap static host (owner's domain, e.g. GitHub Pages).
