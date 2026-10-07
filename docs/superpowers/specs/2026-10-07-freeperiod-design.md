# FreePeriod. – Design spec v1

Date: 2026-10-07 · Status: **draft for owner review** · Research: `docs/research.md` ·
Critical review: `aufpasser/runden/runde-1.md` (Codex gpt-6-astra)

## 0. Changes vs. owner decisions (please confirm or veto)

The review raised three points that change earlier choices. Claude's decision, with reasons:

| # | Earlier | Now | Why |
|---|---|---|---|
| A | Fertile window **on by default** in v1.0 | **v1.1, opt-in** (off by default, explainer on enable) | "Period start − 14 days" is the calendar method: inaccurate, and a band implies other days are "safe". Fertility/conception purposes can make the app a medical device under EU MDR. Opt-in with careful wording is defensible; on-by-default is avoidable risk. |
| B | All four feature groups in v1.0 | v1.0 = core + daily entry + period reminder + lock + backup/export. **v1.1** (≈ 2–4 weeks later) = widget, quick-settings tile, pill reminder, PDF report, importers, fertile window | Every surface is a reliability and privacy surface. Importers need real export files to test against. Shipping a solid v1.0 sooner beats a fragile big one. Nothing is dropped, only sequenced. |
| C | Supporter one-time **and** 1 €/month | **One-time only** (tiers, e.g. 2 / 5 / 10 €), v1.2 | "No subscriptions" is a core promise; a subscription, even cosmetic, contradicts it in reviews. Can be revisited if users ask. |

Unchanged: name **"FreePeriod."** (fallback "Plain Period"), DE+EN, calm & minimal look, home =
today card + month, GPL-3.0 (repo public at v1.0), native Kotlin/Compose, no INTERNET in v1.0.

## 1. Product

**For:** people who want to track their period simply and privately, without account, ads,
subscription or data leaving the phone. Store listing addresses women; in-app wording is neutral
("you").

**Promise (store + about screen):** No account. No ads. No subscription. No internet permission –
your data stays on your phone. Open source.

**Differentiation:** Daylio-like speed (log a day in < 5 s), honest predictions (ranges, never
false precision), history that survives a phone change (encrypted backup file), verifiable
privacy (no INTERNET permission, open source), polished calm UI on Google Play.

**Non-goals v1.x:** accounts, sync servers, social/community, articles/content, AI, contraception
or conception claims, temperature/sympto-thermal method, pregnancy mode, iOS.

## 2. Releases

- **v1.0:** onboarding (optional), today card + calendar, period start/end, daily entry (flow,
  mood, symptoms, pain, sex, discharge, custom tags, note), predictions, history & stats, period
  reminder + optional daily log reminder, app lock, encrypted backup/restore, CSV export,
  predictions pause, DE/EN, light/dark, optional dynamic colour.
- **v1.1:** home-screen widget, quick-settings tile, pill/contraception reminder, PDF report for
  doctor, import (drip CSV first; Clue if a real export file is available), fertile window opt-in.
- **v1.2:** Supporter one-time purchase (cosmetics: themes, icon packs, alternative app icons),
  Health Connect (optional, on-device), automatic weekly backup to chosen folder, more languages
  (ES, FR, PT, IT), F-Droid/IzzyOnDroid build without billing.

## 3. Architecture

- **Stack:** Kotlin, Jetpack Compose (Material 3), Room, DataStore, WorkManager,
  androidx.biometric. No network libraries, no analytics/crash SDKs. minSdk 26, target = latest
  required by Play. Per-app language via `LocaleManager`/AppCompat.
- **Modules:**
  - `:engine` – pure Kotlin/JVM, no Android: domain model, cycle derivation, prediction,
    backup payload (de)serialisation, CSV export. Heavily unit-tested.
  - `:app` – UI, Room, settings, reminders, lock, backup file I/O (SAF), crypto.
- **Manifest:** no `INTERNET`. `allowBackup` cloud backup disabled; device-to-device transfer
  allowed via `dataExtractionRules` (API 31+) and `fullBackupContent` (legacy) – verify on device.
  Release build checks the merged manifest for `INTERNET` and fails if present.

## 4. Data model

All dates are `LocalDate` (calendar days, no time zone; travel never shifts entries).

- `Period(id, start: LocalDate, end: LocalDate?, excludeCycle: Boolean)` – explicit boundaries.
  `end == null` = ongoing. `excludeCycle` = the cycle starting at this period is not used for
  predictions (user flag, e.g. after pill stop, pregnancy, illness).
- `DayLog(date PK, flow: Flow?, mood: Mood?, symptoms: Set<Symptom>, pain: Pain?,
  sex: Sex?, discharge: Discharge?, note: String?)` + `Tag(id, name, archived)` +
  `DayTag(date, tagId)`. A missing field = **not logged** (unknown), distinct from `Flow.NONE`.
- Enums: `Flow {NONE, SPOTTING, LIGHT, MEDIUM, HEAVY}`, `Mood {GREAT, GOOD, OKAY, LOW, BAD}`,
  `Pain {NONE, MILD, MODERATE, SEVERE}`, `Sex {NONE, PROTECTED, UNPROTECTED}`,
  `Discharge {NONE, STICKY, CREAMY, WATERY, EGG_WHITE, UNUSUAL}`,
  `Symptom {CRAMPS, HEADACHE, BACKACHE, BLOATING, BREAST_TENDERNESS, ACNE, FATIGUE, NAUSEA,
  CRAVINGS, INSOMNIA, DIGESTION, ANXIOUS, IRRITABLE, SAD, ENERGETIC}`. Enum names are stored
  as stable strings (never ordinals).
- **Rules:**
  - "Period started" (today or a chosen date) creates a `Period` with `end = null`. "Period
    ended" sets `end`. Periods never overlap; editing in the calendar can move start/end.
  - Logging flow ≥ LIGHT on a day outside any period offers "Mark as period start?" (snackbar),
    never automatic. Spotting never starts a period.
  - Ongoing period older than (median period length + 3) days: today card asks "Has your period
    ended?" with the suggested end date. Ongoing periods are excluded from period-length stats.
- Room schema exported; every schema change ships a migration + migration test.

## 5. Prediction (`:engine`)

- **Cycle** = start of period *i* → start of period *i+1* (completed cycles only).
- **Eligible cycles:** not `excludeCycle`, length 15–90 days. Ineligible cycles stay in history
  with a visible reason ("unusually long – not used for predictions"); the user can include them.
- Use the most recent ≤ 12 eligible cycles. `L` = median length. Period length `P` = median of
  completed periods, default 5 if none.
- **Next start range:**
  - 0 eligible cycles: if the user entered a typical length in onboarding → last start + typical
    ± 3 days, labelled "based on what you entered". Else no prediction ("Log your next period to
    see a prediction").
  - 1–2 cycles: centre = last start + `L`; half-width = max(2, (max − min) / 2 rounded up);
    labelled "early estimate".
  - ≥ 3 cycles: centre = last start + `L`; half-width = max(1, ceil(MAD × 1.5)) where MAD =
    median absolute deviation; labelled "based on your last N cycles".
  - If half-width > 7 days: no date range; show "Your cycles vary a lot (X–Y days)" instead.
- **Displayed:** "Next period likely 12–15 Oct" (always a range; half-width ≥ 1). Predicted period days in calendar = range start … range end + `P` − 1, outlined/dashed,
  never filled like logged days.
- **After the range end without a new period:** "Your expected range has passed (N days ago)" +
  buttons "Period started" / "Pause predictions". No "late" wording, no medical claims.
- **Pause predictions** (setting): hides all predictions and period reminders (e.g. hormonal
  contraception, pregnancy, breastfeeding).
- Cycle day = days since current/last period start + 1.
- Engine API is pure functions: `predict(periods, settings, today) -> PredictionState`,
  covered by table-driven tests (regular, irregular, 1–2 cycles, excluded, gaps, ongoing period,
  long cycles, typical-length-only, range passed).

## 6. Screens

Navigation: bottom bar **Today · History · Settings**. Accent: warm coral default; optional
"Use wallpaper colours" (dynamic colour, Android 12+).

1. **Onboarding (skippable, 3 steps):** promise screen → optional last period start + typical
   cycle length → optional reminders (asks notification permission on Android 13+).
2. **Today:**
   - Card: cycle day, prediction text (§5), one contextual primary button: "Period started" /
     "Has your period ended?" / "Log today". Secondary text button "Log today" if primary is
     period-related.
   - Month calendar below, swipe between months. Markers must not rely on colour alone: logged
     period days = filled circle; predicted = dashed outline; days with a log = small dot;
     today = ring. Tap a day → day entry.
3. **Day entry** (full-height bottom sheet): date header with prev/next day, period
   start/end toggle, chip rows for flow, mood (5 faces), pain, sex, discharge, symptom grid
   (line icons + label), tags (add/edit inline), note. Autosave on every change; "Clear day"
   with undo.
4. **History:** averages (cycle length, period length, based on N cycles), list of cycles
   (start date, cycle length bar, period length, excluded badge + toggle), symptom frequency for
   the last 3 cycles (simple counts).
5. **Settings:** typical cycle length; pause predictions; reminders (period due N days before,
   default 2; daily log reminder + time, default off); app lock; backup & restore; CSV export;
   language; dynamic colour; privacy policy (in-app text + link); about (version, licence,
   source code link, open-source licences). No donation links in the Play build.

Copy: DE + EN, short, warm, no jargon, no gendered assumptions in-app.

## 7. Privacy & security

- **Threat model v1:** (a) lost/stolen locked phone → Android file-based encryption; (b) someone
  briefly using the unlocked phone or seeing notifications → app lock, neutral notifications,
  hidden recents preview; (c) data leaving the device → no INTERNET, no SDKs, cloud backup off.
  Out of scope v1: forensic access to an unlocked device (no SQLCipher in v1).
- **App lock:** `BiometricPrompt` with `BIOMETRIC_WEAK | DEVICE_CREDENTIAL` (no custom PIN).
  Locks on cold start and after 1 min in background (configurable: immediately / 1 / 5 min).
  When enabled: `FLAG_SECURE` (blank recents, no screenshots). If the device has no screen lock,
  the option explains that and stays off.
- **Notifications:** neutral by default ("Reminder from FreePeriod." / "Time for your daily
  check-in"); explicit wording only if the user opts in.
- **Backup file (`.fpbackup`):** JSON payload (versioned schema) encrypted with AES-256-GCM;
  key via PBKDF2-HMAC-SHA256 (≥ 600 000 iterations, random 16-byte salt) from a user password;
  header = magic + format version + KDF params + nonce. Restore: decrypt and validate everything
  first, then replace data in one transaction; show summary before confirming. Clear warning:
  forgotten password = backup unreadable. Saved via SAF to any location the user picks.
- **CSV export:** unencrypted, with warning; one row per day + periods file; for portability.
- **Data safety form:** "no data collected, no data shared" – confirmed by a merged-manifest and
  dependency audit before submission.

## 8. Reminders

WorkManager daily worker computes the prediction and posts: "period expected in N days"
(once per cycle), optional daily log reminder at a chosen time (inexact; no exact-alarm
permission). Rescheduled on boot/app update by WorkManager. Respects pause predictions.

## 9. Testing & quality gates

- `:engine`: table-driven unit tests for prediction, period rules, backup round trip (encrypt →
  decrypt → equal), CSV export.
- `:app`: Room DAO + migration tests, ViewModel tests, Robolectric + Roborazzi screenshots of key
  screens (DE/EN, light/dark, large font).
- Gate script (`tools/check.ps1`): build, unit tests, lint, merged-manifest INTERNET check.
- Accessibility: TalkBack labels, 48 dp targets, contrast AA, German text expansion.
- Physical-device checks (Claude/owner): lock, notifications, backup/restore, D2D transfer.

## 10. Release path (Google Play, organisation account)

1. **M0 Setup:** trademark check "FreePeriod" (EUIPO/DPMA/WIPO), package name, repo skeleton,
   `AGENTS.md`, gate script, signing key (owner-held, path only).
2. **M1 Data + core:** engine model, Room, period start/end, Today card + calendar.
3. **M2 Predictions + History.**
4. **M3 Day entry** (all fields, tags, autosave).
5. **M4 Settings, reminders, lock, backup/restore, CSV export, onboarding.**
6. **M5 Polish:** copy DE/EN, accessibility, icon, screenshots, privacy policy page (GitHub
   Pages), store listing DE/EN, Health apps declaration, Data safety, content rating.
7. **M6 Testing tracks:** internal test → closed test with 5–8 real users (task: log a period,
   a day, read the prediction, back up & restore) → fix round. Verify in Console whether the
   org account has a closed-testing minimum.
8. **M7 Production:** staged rollout 20 % → 100 %, repo public (GPL-3.0), tag v1.0.0.

## 11. Open items for the owner

- Package name (permanent once published): proposal `org.freeperiod.app`.
- Privacy policy + support contact: which e-mail address and where to host (GitHub Pages
  proposed).
