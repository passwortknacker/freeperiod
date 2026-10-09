# FreePeriod. – project state and handover

Last updated: 2026-10-09 (after submitting v1.0.0 for Play review). Read this first in a new session,
then `AGENTS.md` (rules) and `aufpasser/codex-projekt.md` (Codex rounds and decision log).

## 1. What it is

Free, ad-free, offline Android period tracker: period calendar with estimates, daily diary, history,
reminders, app lock, encrypted backups, CSV export/import. EN + DE. No account, no INTERNET
permission, no analytics/crash SDKs. Not a medical device, not contraception. GPL-3.0, public repo.

- Owner: Marvin (decides product/design, owns Play Console, keys, e-mail). Talk to him in German,
  short; he writes German or English.
- Claude: supervisor and main developer since round 24 (plans, codes, verifies, commits, pushes).
- Codex: only for big rounds it does better; quota must last until the weekly reset
  (next: Wed 2026-10-14 10:15). See `aufpasser/codex-projekt.md` and the `codex-delegation` skill.

## 2. Where things are

| What | Where |
|---|---|
| Repo | `C:\Users\kempe\Desktop\Projekte\Period Tracker`, GitHub `pavoras/freeperiod` (public, `main` only) |
| Website + privacy policy | `site/` → https://pavoras.github.io/freeperiod/ (EN `/privacy/`, DE `/privacy/de/`), deployed by `.github/workflows/pages.yml` on every push to `site/**` |
| Play package | `org.freeperiod.app` (debug: `org.freeperiod.app.debug`) |
| Store texts | `store/listing-en.md`, `store/listing-de.md` (with character counts), `store/data-safety.md` |
| Store artwork | `store/*.html` → `python tools/render-store.py` → `store/png/` (6 EN + 6 DE screenshots, feature graphic, `icon-512.png`); inputs are the Roborazzi references in `app/src/test/screenshots/` |
| Spec | `docs/superpowers/specs/2026-10-07-freeperiod-design.md` + **rev 2** `2026-10-08-freeperiod-v1-scope-2.md` (rev 2 wins; §13 = decisions of 2026-10-09) |
| Plans | `docs/superpowers/plans/2026-10-07-freeperiod-v1.md`, `…-v1-part2.md` |
| Release checklist | `docs/release.md` |
| Design reference | `docs/design/drafts/draft-5.png` (final), Daylight palette in `ui/theme/` |
| Codex rounds | `aufpasser/runden/prompt-N.txt`, `runde-N.md` (jsonl/log git-ignored) |
| Signing | upload key + properties under `%USERPROFILE%\dev-tools\keys\` – **never read or print**; pass only the path |

## 3. Release state

- v1.0.0 **versionCode 2** submitted for production review on 2026-10-09 (100 %, managed publishing
  optional). Internal test track has versionCode 1 (same content minus plural fixes) – tested OK by owner.
- Every new upload needs a higher `versionCode` (`app/build.gradle.kts`).
- Play Console answers used: see `docs/release.md` and `store/data-safety.md` (no data collected/shared,
  health app: menstrual tracking, audience 13+, no ads, category Health & Fitness).

**When Google approves** (owner tells you):
1. `site/index.html`: replace `PLAY_STORE_URL` and the text placeholder with the official Google
   Play badge (owner must approve downloading the badge from Google's badge generator) and
   `https://play.google.com/store/apps/details?id=org.freeperiod.app`. Push → site redeploys.
2. `git tag v1.0.0 && git push --tags` (tag the commit that built versionCode 2: `83fa0dc`).
3. Check the live listing EN/DE (texts, images, privacy link, install).
4. Update this file, `docs/release.md`, memory.

**If Google asks questions or rejects:** draft answers from `store/data-safety.md` and the
"not a medical device" position (spec rev 2 §11–12). Never claim certification.

## 4. Build, test, verify

Toolchain: Kotlin 2.2.21, AGP 8.10.1, Gradle 8.11.1 (`~/dev-tools/gradle-8.11.1`), JDK 17
(`~/dev-tools/jdk17`), shared cache `~/dev-tools/gradle-home`, Compose BOM 2025.10.01,
Robolectric 4.16.1, Roborazzi 1.50.0, compileSdk/targetSdk 36, minSdk 26. Offline builds.

| Command | Use |
|---|---|
| `powershell -NoProfile -ExecutionPolicy Bypass -File tools\check.ps1 -Schnell` | engine + app unit tests, compile (~3 min) |
| `… -Voll` | + Roborazzi compare, lint, release build, INTERNET check (~15 min). Required before every commit of app code |
| `… -Aufnehmen [-Tests 'org.freeperiod.app.ui.today.*']` | re-record screenshot references (Claude only), then **look at the changed PNGs** |
| engine only | `JAVA_HOME=~/dev-tools/jdk17 GRADLE_USER_HOME=~/dev-tools/gradle-home ~/dev-tools/gradle-8.11.1/bin/gradle -q --offline :engine:test` |
| signed AAB | `gradle -q --offline -Pfreeperiod.signing="$USERPROFILE/dev-tools/keys/freeperiod-signing.properties" :app:bundleRelease` → `app/build/outputs/bundle/release/app-release.aab`; verify with `jarsigner -verify` and that the manifest has no INTERNET |
| debug APK for the owner | `app/build/outputs/apk/debug/app-debug.apk` (built by `-Voll`), send with SendUserFile |

Last full gate: 376 tests green (2026-10-09). 63 screenshot references.

Working habits that matter here:
- Long runs (gate, recording) in the background **with a watcher** (progress every ≤ 5–15 min,
  stall detection when logs stop changing); never let a run finish unnoticed. Don't edit sources
  while a gate runs.
- Several Kotlin files are CRLF (e.g. `MonthCalendar.kt`, `TodayScreen.kt`, `TodayCard.kt`): edit
  with a CRLF-preserving script or check `git diff --stat` for whole-file churn.
- Robolectric: text fields inside dialogs never idle (test the row, not the dialog field); use
  `performScrollToNode` for LazyColumn items; qualifier order matters (`w360dp-h800dp-night-xxhdpi`).
- The `mipmap-anydpi-v26` folder must keep its `-v26` (lint suggests removing it; that breaks the build).
- Render HTML to PNG with headless Edge (see `tools/render-store.py`).
- Owner's phone: S22 Ultra via Wi-Fi adb (`adb connect 192.168.178.21:<port>`, port changes).

## 5. Architecture in one screen

- `:engine` (pure Kotlin, JVM tests): `Model.kt`, `PeriodRules.kt`, `Prediction.kt` (probability
  model, see §6), `Fertility.kt` (higher-chance days), `Situation.kt`, `PillSchedule.kt`,
  `Reminders.kt`/`Recurrence.kt`, `Timeline.kt`, `Stats.kt`, `backup/` (encrypted codec, schema 2,
  V1 reader), `export/CsvExport.kt`, `import/CsvImport.kt`.
- `:app` (Compose, manual DI in `AppContainer`): `data/` (Room DB version 2 + `Migrations.kt`,
  `SettingsStore` DataStore), `backup/`, `lock/AppLock.kt`, `reminders/` (WorkManager, boot/time
  receivers), `ui/` (`today`, `day`, `history`, `settings`, `onboarding`, `nav`, `components`,
  `theme`).
- Dates are `LocalDate` stored as epoch day; `clock: () -> LocalDate` injected; enums by name.
- All texts in `res/values/strings.xml` (EN) and `res/values-de/strings.xml` (DE); counts use
  `<plurals>`.

## 6. Key product decisions (details in spec rev 2 §13 and `aufpasser/codex-projekt.md`)

- Prediction: normal distribution of the start (centre ± spread from cycle history), times the
  period length. Calendar marks a day "likely" from 60 %, "possible" from 30 %. Exactly two periods:
  the next one, and the one after with spread × √2, marked "possible" from 20 %.
- Higher-chance-of-pregnancy days: on by default (hidden for hormonal methods, pregnancy,
  menopause), always with the disclaimer. No "fertile window" wording, no "Eisprung"/"fruchtbar".
- CSV export is one file (one row per day, `period_day` column) and re-importable.
- Accents: Coral (default), Plum, Sage, Ocean, Ochre, Ink. Ink is the dark, non-pastel alternative.
  Today uses exactly the same accent as other screens; pale fills get a thin edge.
- Settings order: Appearance tile, Customize day entry, Typical cycle length (measured value),
  My situation, Reminders, Language | Pause predictions, App lock | Backup, CSV, privacy, feedback,
  about, delete.
- Wording: warm, neutral "you"/"du", no gendered wording, no "late", no contraception/conception claims.

## 7. Open / next

- Wait for Play review; then §3 "When Google approves".
- Pre-launch report in Play Console: ask the owner for a screenshot, fix anything real.
- After launch: watch Android vitals and reviews (draft replies for the owner).
- v1.1 candidates (owner to prioritise): home-screen widget, PDF export for the doctor,
  Health Connect, automatic backup, Clue/Flo import (needs example files), supporter purchase.
  Big rounds → Codex after the quota reset.
- Known cosmetic: store screenshots show a half calendar row above the legend (real app rendering);
  the DE day-entry screenshot shows the "Sex" row at the bottom (owner avoided the word in the
  listing text; offer a change if it matters).
