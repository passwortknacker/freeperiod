# FreePeriod. v1.0 Implementation Plan

> **For agentic workers:** Execution = Codex rounds supervised by Claude (owner preference,
> see `aufpasser/codex-projekt.md`). Each "Round" below is one Codex session; tasks inside a round
> are done in order, TDD. Steps use checkbox (`- [ ]`) syntax for tracking. Claude verifies every
> round outside the sandbox (Robolectric/Roborazzi, device) and commits.

**Goal:** Ship FreePeriod. v1.0 – a private, offline, free period tracker – to Google Play
production.

**Architecture:** Two Gradle modules. `:engine` is pure Kotlin/JVM (domain model, period rules,
prediction, reminder decisions, backup codec, CSV export) and carries all logic worth testing.
`:app` is a single-activity Compose app (Room, DataStore, WorkManager, BiometricPrompt, SAF) that
maps storage to engine types and renders engine results.

**Tech Stack:** Kotlin 2.2.21, AGP 8.10.1, Gradle 8.11.1, JDK 17, compileSdk/targetSdk 36,
minSdk 26, Jetpack Compose (Material 3, BOM), Navigation Compose, Room (KSP), DataStore
Preferences, WorkManager, androidx.biometric, kotlinx-serialization-json, kotlinx-coroutines,
JUnit 4, Robolectric 4.16.1, Roborazzi 1.50.0. Exact Compose/Room/KSP/etc. versions are resolved
once in Task 0 (latest stable compatible with Kotlin 2.2.21/AGP 8.10.1) and pinned in
`gradle/libs.versions.toml`; nobody bumps them without a reason.

**Spec:** `docs/superpowers/specs/2026-10-07-freeperiod-design.md` (read it; this plan does not
repeat its rules).

## Global Constraints

- applicationId / namespace `org.freeperiod.app`; engine package `org.freeperiod.engine`.
- App name "FreePeriod." (with full stop) in both languages; Play title "FreePeriod. – Period Tracker".
- **No `INTERNET` permission** and no network/analytics/crash SDK. The gate fails if the merged
  release manifest contains `android.permission.INTERNET`.
- Cloud backup off; device-to-device transfer on (`dataExtractionRules` + `fullBackupContent`).
- All calendar dates are `java.time.LocalDate`; stored as epoch-day `Long`. No time zones.
- Enums persisted by stable `name`, never ordinal.
- Strings only in resources, EN (`values/`) + DE (`values-de/`), always both. Neutral "you",
  no gendered wording in-app, no "late", no contraception/conception claims.
- Default accent: warm coral seed `#E8735A`; dynamic colour optional (Android 12+), default off.
- Copy, colours and icon decisions by Claude/owner; Codex does not invent marketing claims.
- Codex never commits, never touches signing keys or `C:\Users\kempe\dev-tools\keys`.
- Simplicity rule: remove before adding; each round reports net lines.

## Review Focus

1. **Logging in the past / editing old periods** – user enters a period that starts before an
   existing one or moves an end date across another period → must be rejected with a clear
   message, never silently overlap. Test: `PeriodRulesTest.overlapAfterMoveIsRejected` (Task 1).
2. **Restoring a backup over existing data / wrong password** → nothing changes unless the whole
   file decrypts and validates. Test: `BackupCodecTest.wrongPasswordFailsWithoutData` (Task 3) and
   `RestoreTest.failedRestoreKeepsExistingData` (Task 9).
3. **Device time zone/date change** (travel, midnight) → entries stay on their calendar day,
   "today" recomputes on resume. Test: `DayLogDaoTest.datesRoundTripAsEpochDay` (Task 5) and
   `TodayViewModelTest.todayRecomputesOnResume` (Task 6).
4. **Very first use with no data / skipped onboarding** → Today shows a friendly empty state and
   one clear action, no crash, no fake prediction. Test: `PredictionTest.noPeriodsGivesNoData`
   (Task 2) + screenshot `TodayScreenshotTest.empty` (Task 6).
5. **Ongoing period never ended** → stats exclude it, Today asks "Has your period ended?" after
   median+3 days, prediction still works. Test: `PeriodRulesTest.endQuestionAfterMedianPlusThree`
   (Task 1).

## Decisions from plan review (round 2) – binding, override older wording below

- **Periods:** inclusive boundaries; at most one ongoing period and it must be the latest; an
  ongoing period extends to infinity for overlap checks. Historical periods are created with
  `addPeriod(start, end)` in one call. `CycleUse` replaces `excludeCycle` everywhere (Room,
  backup, CSV column `cycle_use` with values `auto|include|exclude`, History toggle cycles
  AUTO → EXCLUDE/INCLUDE as appropriate: "Use for predictions" on/off overrides the automatic rule).
- **Rounding:** all medians of even count = mean of middle two; period length = median rounded
  half-up to Int; prediction centre offset = median rounded half-up. "Last 3 cycles" for symptom
  counts = dates from the start of the 3rd most recent completed cycle up to (excluding) the start
  of the latest period; fewer cycles → all completed cycles.
- **Fixtures:** every engine test passes an explicit `today`; unless a test says otherwise
  `today = latest start + 10 days`. App code gets `clock: () -> LocalDate` injected everywhere
  (ViewModels, repository, workers); "today" is recomputed on resume and at midnight while in
  foreground. Week start = `WeekFields.of(locale).firstDayOfWeek` (tests pin `Locale.GERMANY` /
  `Locale.US`).
- **Backup crypto bounds:** file ≤ 20 MB, iterations 100 000..10 000 000 (encode default
  600 000), header fixed 37 bytes parsed before any KDF work; decrypted JSON ≤ 50 MB; JSON parsed
  only after GCM authentication; fresh salt + nonce per export. Validation after decrypt: schema
  version, unique period IDs, unique day dates, unique tag IDs/names, tag references, period rules
  (with an explicit `today`), domain-setting ranges (typical length 15..90 or null). Engine tests
  use `iterations = 100_000` except one round trip at 600 000; no timing assertions. Encode and
  decode run on `Dispatchers.Default`.
- **Restore:** decode + validate fully → show summary → confirm → `replaceAll` (one transaction,
  includes domain settings). Autosaves are serialized by the repository mutex; workers read
  through the repository. Forgotten-password warning shown before creating a backup. Cancelled
  or failed SAF write → error text, no partial-success message. Privacy text notes that a folder
  chosen in a cloud app (e.g. Drive) uploads the file through that app.
- **Reminders:** period reminder **off by default** (opt-in in onboarding/settings); pause
  predictions disables only the period reminder, not the daily one. Manifest declares
  `POST_NOTIFICATIONS`; a reminder counts as delivered (stores `lastNotifiedPeriodId`) only if
  `NotificationManagerCompat.areNotificationsEnabled()` and the channel is enabled. Daily reminder
  = one-time work scheduled for the next local wall-clock `dailyReminderTime`, re-enqueued after
  each run and on `TIMEZONE_CHANGED`/`TIME_SET`/boot; period check = periodic 24 h work.
- **Language:** per-app language via Android 13+ system settings (`android:localeConfig`,
  `res/xml/locales_config.xml` with en, de); in-app "Language" row on API 33+ opens the system
  per-app language screen; below 33 the app follows the system language (no extra code).
- **Onboarding:** asks last period start and whether it has ended (if yes: end date picker);
  typical cycle length 15..90 or "I don't know". No invented 5-day end.
- **Lock:** `MainActivity` extends `FragmentActivity` (BiometricPrompt needs it);
  enable requires `KeyguardManager.isDeviceSecure`; timeout measured with
  `SystemClock.elapsedRealtime()`; process death = cold start = lock.
- **Screenshots:** Roborazzi references are recorded only for tests a round adds or changes
  (round answer lists them); Claude inspects each image before recording; never re-record all.
- **Rounds:** the old "settings" round is split: **"recovery"** = Task 9; **"device"** =
  Tasks 10–12.

---

## File Structure

```
settings.gradle.kts, build.gradle.kts, gradle.properties, gradle/libs.versions.toml
AGENTS.md                          rules for Codex (Task 0)
tools/check.ps1                    gate: -Schnell (sandbox-safe) / -Voll (Claude)
engine/build.gradle.kts
engine/src/main/kotlin/org/freeperiod/engine/
  Model.kt          Period, DayLog, Tag, enums (Flow, Mood, Pain, Sex, Discharge, Symptom)
  PeriodRules.kt    validation, cycles, cycle day, period lookup, end question
  Prediction.kt     PredictionSettings, PredictionState, predict(), predictedDays()
  Stats.kt          median/MAD helpers, period length, symptom counts
  Reminders.kt      periodReminderDue()
  backup/BackupData.kt, backup/BackupCodec.kt
  export/CsvExport.kt
engine/src/test/kotlin/org/freeperiod/engine/...  one test file per main file
app/build.gradle.kts, app/schemas/ (Room JSON)
app/src/main/AndroidManifest.xml, res/xml/data_extraction_rules.xml, res/xml/backup_rules.xml
app/src/main/java/org/freeperiod/app/
  FreePeriodApp.kt  Application: AppContainer (manual DI, no Hilt)
  MainActivity.kt   single activity, lock gate, FLAG_SECURE
  data/db/          FreePeriodDatabase.kt, Entities.kt, Converters.kt, PeriodDao.kt, DayLogDao.kt, TagDao.kt
  data/Repository.kt          Flows of engine types + write operations
  data/SettingsStore.kt       DataStore wrapper, AppSettings data class
  ui/theme/         Theme.kt, Color.kt, Type.kt
  ui/nav/           AppNav.kt (Today · History · Settings, onboarding gate)
  ui/today/         TodayScreen.kt, TodayViewModel.kt, MonthCalendar.kt, TodayCard.kt
  ui/day/           DayEntrySheet.kt, DayEntryViewModel.kt
  ui/history/       HistoryScreen.kt, HistoryViewModel.kt
  ui/settings/      SettingsScreen.kt, SettingsViewModel.kt, BackupScreen.kt
  ui/onboarding/    OnboardingScreen.kt
  reminders/        ReminderWorker.kt, ReminderScheduler.kt, Notifications.kt
  lock/             AppLock.kt (pure timeout logic + BiometricPrompt glue)
  backup/           BackupIo.kt (SAF read/write, restore transaction)
app/src/main/res/values{,-de}/strings.xml, values/themes.xml, drawable/ (icons), mipmap-*/
app/src/test/java/org/freeperiod/app/...   JVM + Robolectric/Roborazzi tests
site/privacy/index.html, site/privacy/de/index.html   privacy policy (GitHub Pages)
store/listing-en.md, store/listing-de.md
```

---

## M0 – Setup

### Task 0: Toolchain, skeleton, gate (Claude, with network)

**Files:** Create everything at repo root listed above for Gradle; `engine/` + `app/` minimal;
`AGENTS.md`; `tools/check.ps1`; `LICENSE` (GPL-3.0 text); `README.md` (short).

- [ ] **Step 1:** Copy Gradle 8.11.1 from `Diktier App/.tools/gradle-8.11.1` to
  `C:\Users\kempe\dev-tools\gradle-8.11.1` (no download). `local.properties` =
  `sdk.dir=C\:/Users/kempe/dev-tools/android-sdk` (git-ignored).
- [ ] **Step 2:** Write `libs.versions.toml` with AGP 8.10.1, Kotlin 2.2.21, compose compiler
  plugin 2.2.21, kotlinx-serialization plugin 2.2.21, Roborazzi 1.50.0, Robolectric 4.16.1,
  JUnit 4.13.2; resolve latest stable compatible Compose BOM, activity-compose, navigation-compose,
  lifecycle, Room, KSP (matching 2.2.21), DataStore, WorkManager, biometric, core-ktx,
  coroutines, serialization-json.
- [ ] **Step 3:** `:engine` (kotlin-jvm, JVM 17, serialization plugin, junit) with
  `Model.kt` placeholder test `SmokeTest.engineCompiles`; `:app` (compose, ksp, room plugin
  schema dir `app/schemas`) with `MainActivity` showing "FreePeriod." text, theme with coral seed,
  manifest without INTERNET, backup rules (cloud excluded, device transfer included).
- [ ] **Step 4:** `tools/check.ps1`: sets `JAVA_HOME=dev-tools\jdk17`,
  `GRADLE_USER_HOME=dev-tools\gradle-home`, `ANDROID_HOME=dev-tools\android-sdk`; `-Schnell` runs
  `:engine:test :app:assembleDebug :app:compileDebugUnitTestKotlin --offline`; `-Voll` adds
  `:app:testDebugUnitTest :app:lintDebug :app:processReleaseMainManifest` and fails if
  `app/build/intermediates/merged_manifest/release/**/AndroidManifest.xml` contains
  `android.permission.INTERNET`; `-Aufnehmen` records Roborazzi references. Logs to
  `.tools/check-*.log`; exit code = result.
- [ ] **Step 5:** Run `tools\check.ps1 -Voll` **online once** (fills shared Gradle cache), then
  `-Schnell` with `--offline` → both exit 0.
- [ ] **Step 6:** `AGENTS.md` (rules: prohibitions, check commands, Robolectric not in sandbox
  → write carefully, `@Config(sdk = [35])`, red test first for bugs, answer format, simplicity).
- [ ] **Step 7:** Commit `chore: project skeleton, toolchain and gate`.

### Task 0b: Trademark + listing prerequisites (Claude/owner, parallel)
- [ ] EUIPO/TMview + DPMA search "FreePeriod"; record result in `docs/decisions.md`.
- [ ] Owner: support/privacy e-mail later (spec §11), Play Console app entry created at M6.

---

## M1–M4 Engine (Round "engine", Codex, sandbox-testable)

### Task 1: Domain model + period rules

**Files:** Create `engine/.../Model.kt`, `PeriodRules.kt`, `Stats.kt`; tests
`PeriodRulesTest.kt`, `StatsTest.kt`.

**Interfaces – Produces:**
```kotlin
enum class CycleUse { AUTO, INCLUDE, EXCLUDE }   // replaces spec's excludeCycle Boolean (review 2)
data class Period(val id: Long, val start: LocalDate, val end: LocalDate?, val cycleUse: CycleUse = CycleUse.AUTO)
data class Tag(val id: Long, val name: String, val archived: Boolean = false)
data class DayLog(val date: LocalDate, val flow: FlowLevel? = null, val mood: Mood? = null,
  val symptoms: Set<Symptom> = emptySet(), val pain: Pain? = null, val sex: Sex? = null,
  val discharge: Discharge? = null, val note: String? = null, val tagIds: Set<Long> = emptySet())
enum class FlowLevel { NONE, SPOTTING, LIGHT, MEDIUM, HEAVY }   // not "Flow": clashes with coroutines Flow
// + Mood, Pain, Sex, Discharge, Symptom exactly as spec §4
data class Cycle(val startPeriodId: Long, val start: LocalDate, val nextStart: LocalDate, val length: Int,
  val periodLength: Int?, val eligible: Boolean, val ineligibleReason: IneligibleReason?)
enum class IneligibleReason { EXCLUDED_BY_USER, TOO_SHORT, TOO_LONG }
// eligible = cycleUse == INCLUDE || (cycleUse == AUTO && length in 15..90); reason set only when !eligible
enum class PeriodError { OVERLAP, END_BEFORE_START, START_IN_FUTURE, END_IN_FUTURE }
object PeriodRules {
  fun validate(existing: List<Period>, candidate: Period, today: LocalDate): PeriodError?  // ignores candidate.id in existing
  fun cycles(periods: List<Period>): List<Cycle>                 // sorted by start, completed only
  fun periodOn(periods: List<Period>, date: LocalDate, today: LocalDate): Period?  // ongoing covers start..today
  fun cycleDay(periods: List<Period>, today: LocalDate): Int?    // days since latest start ≤ today, +1
  fun typicalPeriodLength(periods: List<Period>): Int            // median of completed, default 5
  fun endQuestion(periods: List<Period>, today: LocalDate): LocalDate?  // suggested end or null
  fun suggestsPeriodStart(log: DayLog, periods: List<Period>, today: LocalDate): Boolean
}
object Stats { fun median(values: List<Int>): Double; fun mad(values: List<Int>): Double }
```
`DayLog.isEmpty()` = all fields null/empty.

- [ ] **Step 1: Failing tests** (`PeriodRulesTest`), dates in 2026:
  - `overlapIsRejected`: existing 03-01..03-05, candidate 03-04..03-08 → `OVERLAP`.
  - `overlapAfterMoveIsRejected`: existing A 03-01..03-05 (id 1), B 03-29..04-02 (id 2); candidate
    id 1 moved to end 03-30 → `OVERLAP`; candidate id 1 end 03-06 → null.
  - `ongoingPeriodBlocksLaterStart`: existing 03-01..null, today 03-04, candidate start 03-03 → `OVERLAP`.
  - `endBeforeStart` → `END_BEFORE_START`; start tomorrow → `START_IN_FUTURE`.
  - `cyclesAreStartToStart`: starts 01-01, 01-29, 02-28 → lengths [28, 30]; reasons null.
  - `cycleFlags`: length 14 → `TOO_SHORT`, 91 → `TOO_LONG`, period with `EXCLUDE` → `EXCLUDED_BY_USER`
    on the cycle starting at it; 15 and 90 eligible; 14 and 91 with `INCLUDE` → eligible.
  - `onlyOneOngoingAndItIsLatest`: existing 03-01..03-05 and 04-01..null; candidate 02-01..null → `OVERLAP`
    (an ongoing period extends to infinity); candidate 02-01..02-05 → null (historical insert OK).
  - `endInFuture` → `END_IN_FUTURE`. Boundaries are inclusive (03-01..03-05 and 03-05..03-08 overlap).
  - `cycleDayCountsFromLatestStart`: start 03-01, today 03-12 → 12; no periods → null.
  - `typicalPeriodLengthIgnoresOngoing`: completed lengths 4,5,7 + ongoing → 5; none → 5.
  - `endQuestionAfterMedianPlusThree`: median 5, ongoing from 03-01: today 03-08 → null,
    today 03-09 → 03-05.
  - `lightFlowOutsidePeriodSuggestsStart`: LIGHT outside period → true; SPOTTING → false; LIGHT
    inside a period → false.
- [ ] **Step 2:** Run `tools\check.ps1 -Schnell` → FAIL (unresolved references).
- [ ] **Step 3:** Implement. Median of even count = mean of the two middle values; MAD = median
  of |x − median|.
- [ ] **Step 4:** `-Schnell` → PASS.

### Task 2: Prediction

**Files:** Create `engine/.../Prediction.kt`; test `PredictionTest.kt`.

**Interfaces – Consumes:** Task 1. **Produces:**
```kotlin
data class PredictionSettings(val typicalCycleLength: Int? = null, val paused: Boolean = false)
enum class Basis { USER_ENTERED, EARLY_ESTIMATE, HISTORY }
sealed interface PredictionState {
  data object Paused : PredictionState
  data object NoData : PredictionState                        // no periods at all
  data class NeedMoreData(val cycleDay: Int) : PredictionState // periods but no basis
  data class Range(val earliest: LocalDate, val latest: LocalDate, val basis: Basis,
    val cyclesUsed: Int, val periodLength: Int, val cycleDay: Int) : PredictionState
  data class Varies(val minLength: Int, val maxLength: Int, val cyclesUsed: Int, val cycleDay: Int) : PredictionState
  data class RangePassed(val latest: LocalDate, val daysPassed: Int, val cycleDay: Int) : PredictionState
}
fun predict(periods: List<Period>, settings: PredictionSettings, today: LocalDate): PredictionState
fun predictedDays(state: PredictionState): ClosedRange<LocalDate>?  // Range: earliest..latest+periodLength-1
```
Algorithm exactly as spec §5: most recent ≤ 12 eligible cycles; centre = last start +
round-half-up(median); half-width: 0 cycles + typical → 3; 1–2 cycles → max(2, ceil((max−min)/2));
≥3 → max(1, ceil(MAD × 1.5)); half-width > 7 → `Varies`. `RangePassed` when today > latest.

- [ ] **Step 1: Failing tests** (last start = start of most recent period):
  - `noPeriodsGivesNoData`; `pausedWins` (paused + data → `Paused`).
  - `noCyclesNoTypicalNeedsMoreData`: one period 03-01, today 03-10 → `NeedMoreData(10)`.
  - `typicalLengthOnly`: one period 03-01, typical 30, today 03-10 → Range 03-28..04-03, `USER_ENTERED`, cyclesUsed 0.
  - `oneCycleEarlyEstimate`: starts 02-01, 03-03 (30) → centre 04-02, Range 03-31..04-04, `EARLY_ESTIMATE`.
  - `twoCyclesEarlyEstimate`: cycles 27, 33 → centre +30, half-width 3.
  - `regularHistory`: starts 01-01, 01-29, 02-26, 03-26 → Range 04-22..04-24, `HISTORY`, cyclesUsed 3.
  - `irregularHistory`: cycles 26, 30, 35, 28 → median 29, MAD 2 → half-width 3.
  - `variesTooMuch`: cycles 25, 45, 30, 60 → `Varies(25, 60, 4, …)`.
  - `excludedAndTooLongIgnored`: cycles 28, 95(TOO_LONG), 28(excluded), 28, 28 → cyclesUsed 3.
  - `onlyLast12Used`: 14 cycles, first two 40, rest 28 → half-width 1, cyclesUsed 12.
  - `rangePassed`: regularHistory with today 04-27 → `RangePassed(04-24, 3, cycleDay)`.
  - `predictedDaysAddsPeriodLength`: Range 04-22..04-24, periodLength 5 → 04-22..04-28.
- [ ] **Step 2:** `-Schnell` → FAIL. **Step 3:** implement. **Step 4:** `-Schnell` → PASS.

### Task 3: Backup codec, CSV export, reminder decision

**Files:** Create `engine/.../backup/BackupData.kt`, `backup/BackupCodec.kt`,
`export/CsvExport.kt`, `Reminders.kt`; tests `BackupCodecTest.kt`, `CsvExportTest.kt`,
`RemindersTest.kt`.

**Produces:**
```kotlin
@Serializable data class BackupSettings(val typicalCycleLength: Int?, val predictionsPaused: Boolean)
@Serializable data class BackupData(val schemaVersion: Int = 1, val periods: List<Period>,
  val dayLogs: List<DayLog>, val tags: List<Tag>, val settings: BackupSettings)
// Model types get @Serializable with LocalDate serialized as ISO string (custom serializer in engine).
sealed interface DecodeResult { data class Ok(val data: BackupData) : DecodeResult
  data object NotABackup : DecodeResult; data object UnsupportedVersion : DecodeResult
  data object WrongPasswordOrCorrupt : DecodeResult; data object InvalidContent : DecodeResult }
object BackupCodec {
  const val ITERATIONS = 600_000
  fun encode(data: BackupData, password: CharArray, random: SecureRandom = SecureRandom(), iterations: Int = ITERATIONS): ByteArray
  fun decode(bytes: ByteArray, password: CharArray): DecodeResult
}
object CsvExport { fun days(logs: List<DayLog>, tags: List<Tag>): String; fun periods(periods: List<Period>): String }
fun periodReminderDue(state: PredictionState, latestPeriodId: Long?, daysBefore: Int, today: LocalDate,
  lastNotifiedPeriodId: Long?): Boolean
```
File layout: `"FPBK"` (4 bytes ASCII) · format version (1 byte = 1) · iterations (Int BE) ·
salt (16) · nonce (12) · AES-256-GCM ciphertext+tag (128-bit); header bytes are the GCM AAD;
key = PBKDF2WithHmacSHA256(password, salt, iterations, 256). Decode rejects iterations
< 100 000 as `InvalidContent`. After decrypt, `InvalidContent` if `PeriodRules.validate` finds
overlaps or a DayLog references an unknown tag.
CSV: RFC 4180, header `date,flow,mood,pain,sex,discharge,symptoms,tags,note` (symptoms/tags
joined with `;`, enum names lowercase) and `start,end,exclude_cycle`; ISO dates; sorted by date.
Reminder: due iff state is `Range` **and** today in (earliest − daysBefore)..earliest **and**
`latestPeriodId != null && latestPeriodId != lastNotifiedPeriodId` (one reminder per cycle, keyed by
the period that started it); never for other states.

- [ ] **Step 1: Failing tests:** `roundTripEqualsInput` (iterations 600 000 once, other tests may
  pass 100 000), `wrongPasswordFailsWithoutData` (→ `WrongPasswordOrCorrupt`),
  `flippedByteFails`, `randomBytesAreNotABackup`, `futureVersionUnsupported` (version byte 2),
  `lowIterationsRejected`, `overlappingPeriodsRejected`; `csvQuotesCommasQuotesAndNewlines`
  (note `a,"b"\nc` → `"a,""b""\nc"`), `csvHeaderAndOrder`; `reminderFiresTwoDaysBefore`,
  `reminderNotRepeatedForSameRange`, `reminderCatchesUpIfMissedDay`, `noReminderWhenPausedOrVaries`.
- [ ] **Step 2–4:** FAIL → implement → `-Schnell` PASS.

**Engine round exit:** Claude reviews engine code + test names against this plan; commits
`feat(engine): model, rules, prediction, backup, export, reminders`.

---

## M1–M2 App core (Round "core", Codex; Claude runs Robolectric)

### Task 4: Theme, navigation, settings store

**Files:** `ui/theme/*`, `ui/nav/AppNav.kt`, `data/SettingsStore.kt`, `FreePeriodApp.kt`,
`MainActivity.kt`; tests `SettingsStoreTest.kt` (Robolectric).

**Produces:**
```kotlin
// Device preferences only (DataStore). Domain settings (typicalCycleLength, predictionsPaused)
// live in Room (Task 5) so that restore is one transaction.
data class AppSettings(val onboardingDone: Boolean = false, val dynamicColor: Boolean = false,
  val lockEnabled: Boolean = false, val lockTimeout: LockTimeout = LockTimeout.ONE_MINUTE,
  val periodReminder: Boolean = false, val periodReminderDaysBefore: Int = 2,
  val dailyReminder: Boolean = false, val dailyReminderTime: LocalTime = LocalTime.of(20, 0),
  val explicitNotifications: Boolean = false, val lastNotifiedPeriodId: Long? = null)
enum class LockTimeout { IMMEDIATELY, ONE_MINUTE, FIVE_MINUTES }
class SettingsStore(context: Context) { val settings: Flow<AppSettings>; suspend fun update(transform: (AppSettings) -> AppSettings) }
class AppContainer(context: Context) { val repository: Repository; val settings: SettingsStore }
```
- [ ] Tests: `defaultsMatchSpec`, `updatePersists`. Theme: coral seed `#E8735A`, light/dark,
  dynamic when enabled and API ≥ 31. Bottom bar Today · History · Settings; onboarding route
  shown while `!onboardingDone`.

### Task 5: Room + repository

**Files:** `data/db/*`, `data/Repository.kt`; tests `PeriodDaoTest`, `DayLogDaoTest`,
`RepositoryTest` (Robolectric, in-memory DB).

Entities: `PeriodEntity(id PK auto, startEpochDay INDEX, endEpochDay?, cycleUse)`,
`DayLogEntity(epochDay PK, flow?, mood?, symptoms: String /*';'-joined names*/, pain?, sex?,
discharge?, note?)`, `TagEntity(id PK auto, name UNIQUE NOCASE, archived)`,
`DayTagEntity(epochDay, tagId)` PK(epochDay, tagId), FK → DayLog cascade, FK → Tag cascade,
index on tagId; `DomainSettingsEntity(id = 0 PK, typicalCycleLength?, predictionsPaused)`.
DB version 1, `exportSchema = true`. Every write that validates (period mutations, day log +
tag links, replaceAll) runs inside `db.withTransaction`; writes are serialized by one `Mutex` in
the repository so rapid taps cannot overwrite newer state.

**Produces:**
```kotlin
class Repository(db: FreePeriodDatabase, clock: () -> LocalDate = { LocalDate.now() }) {
  val periods: Flow<List<Period>>; val dayLogs: Flow<Map<LocalDate, DayLog>>; val tags: Flow<List<Tag>>
  val domainSettings: Flow<BackupSettings>
  suspend fun addPeriod(start: LocalDate, end: LocalDate?): Result<Period>  // atomic; validates via PeriodRules
  suspend fun endPeriod(id: Long, end: LocalDate): Result<Period>
  suspend fun updatePeriod(period: Period): Result<Period>                  // move start/end, cycleUse
  suspend fun deletePeriod(id: Long)
  suspend fun saveDayLog(log: DayLog)                            // empty log → row deleted (with tag links)
  suspend fun addTag(name: String): Tag; suspend fun renameTag(id: Long, name: String); suspend fun archiveTag(id: Long)
  suspend fun updateDomainSettings(settings: BackupSettings)
  suspend fun snapshot(): BackupData                             // one read transaction, incl. domain settings
  suspend fun replaceAll(data: BackupData)                       // one write transaction, incl. domain settings
}
class PeriodValidationException(val error: PeriodError) : Exception()
```
- [ ] Tests: `datesRoundTripAsEpochDay`, `startPeriodRejectsOverlap` (Result failure with
  `OVERLAP`), `emptyDayLogDeletesRow`, `tagsJoinedPerDay`, `replaceAllIsAtomic` (throwing inside
  → old data kept), `snapshotReplaceRoundTrip`.

### Task 6: Today screen + calendar

**Files:** `ui/today/*`; tests `TodayViewModelTest`, `TodayScreenshotTest` (Roborazzi).

**Produces:** `TodayViewModel(repository, settings, clock)` exposing
`StateFlow<TodayUiState>` with `prediction: PredictionState`, `endQuestion: LocalDate?`,
`month: YearMonth`, `days: Map<LocalDate, DayMarks>`;
`data class DayMarks(val period: Boolean, val predicted: Boolean, val logged: Boolean, val today: Boolean)`
(independent flags, any combination renders); actions `startPeriodToday()` (= `addPeriod(today, null)`),
`confirmEnd(date)`, `showMonth(YearMonth)`, `onResume()`.
Card texts (EN, DE in resources) per state: `NoData` "Welcome! Tap below when your period starts.";
`NeedMoreData` "Cycle day %d · Log your next period to see a prediction"; `Range` "Cycle day %d ·
Next period likely %s" + basis line ("based on what you entered" / "early estimate" / "based on
your last %d cycles"); `Varies` "Your cycles vary a lot (%d–%d days)"; `RangePassed` "Your
expected range has passed (%d days ago)" with buttons "Period started" / "Pause predictions";
`Paused` "Predictions paused". Primary button: ongoing period → "Has your period ended?" when
`endQuestion != null`, else "Log today"; no ongoing → "Period started".
Calendar: Monday-first (locale first-day-of-week), filled circle = PERIOD, dashed outline =
PREDICTED, dot = LOGGED, ring = today; content descriptions per day.
- [ ] Tests: `todayRecomputesOnResume` (clock advanced → cycle day changes),
  `startPeriodTodayCreatesPeriod`, `endQuestionShownAfterThreshold`; screenshots `empty`,
  `regular`, `rangePassed`, `ongoing` × (EN light, DE dark, EN fontScale 1.5).

**Core round exit:** Claude runs `-Voll`, records Roborazzi references, inspects screenshots,
installs debug APK on device, commits.

---

## M2–M3 (Round "history+day", Codex)

### Task 7: History screen
**Files:** `ui/history/*`; tests `HistoryViewModelTest`, screenshot `HistoryScreenshotTest`.
Shows averages (cycle length = median of eligible, period length, "based on N cycles"), list of
cycles newest first (start date, length bar relative to max, period length, ineligible badge with
reason text, toggle "Use for predictions" → `updatePeriod(cycleUse = …)`), symptom counts
over the last 3 cycles (`Stats.symptomCounts(logs, from, to): Map<Symptom, Int>`, add to
`Stats.kt` with test `symptomCountsInRange`).
- [ ] Tests: `averagesUseEligibleOnly`, `toggleExcludeUpdatesPeriod`, `emptyHistoryState`.

### Task 8: Day entry sheet
**Files:** `ui/day/*`; tests `DayEntryViewModelTest`, screenshot `DayEntryScreenshotTest`.
`DayEntryViewModel(date, repository)`; every change → `saveDayLog` (debounce none, write on each
tap); prev/next day; "Clear day" → snackbar with Undo restoring the previous `DayLog`;
period toggle ("Period started on this day" / "Period ended on this day") calling repository and
showing validation errors as text ("This overlaps another period"); after saving flow ≥ LIGHT
outside a period, snackbar "Mark as period start?" (uses `PeriodRules.suggestsPeriodStart`).
Tags: chips + "Add tag" inline field; long-press → archive. Mood as 5 face icons with labels.
Symptom grid with line icons (Material Symbols outlined, bundled as vector drawables).
- [ ] Tests: `tapSavesImmediately`, `clearDayUndoRestores`, `suggestStartOnLightFlow`,
  `overlapShowsError`, `futureDayNotEditable` (dates after today are read-only).

---

## M4 (Rounds "recovery" = Task 9 and "device" = Tasks 10–12, Codex)

### Task 9: Settings, backup/restore, CSV export
**Files:** `ui/settings/*`, `backup/BackupIo.kt`; tests `SettingsViewModelTest`, `RestoreTest`.
Settings per spec §6. Backup: password + confirm (min 8 chars), `ACTION_CREATE_DOCUMENT`
`freeperiod-YYYY-MM-DD.fpbackup` (mime `application/octet-stream`), encode on
`Dispatchers.Default`. Restore: `ACTION_OPEN_DOCUMENT`, password, decode, show summary ("N periods,
M days logged"), confirm → `repository.replaceAll` + settings update. Errors mapped to text per
`DecodeResult`. CSV export: two files via create-document (`…-days.csv`, `…-periods.csv`) with a
warning dialog first. Privacy policy screen = in-app text (resource string, EN/DE) + link to
`https://<owner>.github.io/freeperiod/privacy/` (URL constant in one place, set at M5).
About: version, licence GPL-3.0, source link, open-source licences list (static text).
- [ ] Tests: `failedRestoreKeepsExistingData`, `restoreReplacesDataAndSettings`,
  `passwordMismatchBlocksBackup`.

### Task 10: Reminders
**Files:** `reminders/*`; tests `ReminderWorkerTest` (work-testing + Robolectric).
`ReminderScheduler.sync(settings)` enqueues unique periodic work "period-reminder" (24 h) and
"daily-log" (24 h, initial delay to next `dailyReminderTime`), cancels when disabled or paused.
Worker reads repository + settings, calls `periodReminderDue`, posts notification, stores
`lastNotifiedPeriodId`. Channel "Reminders". Texts neutral by default ("Reminder from FreePeriod." /
"Time for your daily check-in"); explicit ("Your period may start in %d days") only if
`explicitNotifications`. Android 13+: permission requested when the user enables a reminder or in
onboarding; denied → setting shows "Notifications are off in system settings" with button.
- [ ] Tests: `postsOnceTwoDaysBefore`, `neutralTextByDefault`, `nothingWhenPaused`,
  `scheduleCancelledWhenDisabled`.

### Task 11: App lock
**Files:** `lock/AppLock.kt`, `MainActivity.kt`; tests `AppLockTest` (pure JVM).
`fun shouldLock(enabled: Boolean, coldStart: Boolean, backgroundedAtMs: Long?, nowMs: Long, timeout: LockTimeout): Boolean`.
BiometricPrompt `BIOMETRIC_WEAK or DEVICE_CREDENTIAL`; content hidden until success; enable only
if `BiometricManager.canAuthenticate(...) == BIOMETRIC_SUCCESS`, otherwise explanatory text.
`FLAG_SECURE` set while lock enabled.
- [ ] Tests: `coldStartLocks`, `withinTimeoutStaysOpen`, `afterTimeoutLocks`,
  `immediatelyLocksOnAnyBackground`, `disabledNeverLocks`.

### Task 12: Onboarding
**Files:** `ui/onboarding/OnboardingScreen.kt`; screenshot test.
3 pages per spec §6: promise ("No account. No ads. No subscription. Your data stays on your
phone."), optional last period start (date picker ≤ today, "Has it ended?" + end date → `addPeriod(start, end?)`) + typical cycle length (15–90,
"I don't know" = null), reminders (opt-in, permission). "Skip" on every page → `onboardingDone`.
- [ ] Tests: `skipMarksDone`, `enteringDataCreatesPeriodAndTypicalLength`.

**Settings round exit:** Claude `-Voll`, device test (lock, notification, backup → reinstall → restore,
D2D transfer if two devices available), commit.

---

## M5 Polish & store (Round "polish", Codex + Claude)

### Task 13: Copy, accessibility, icon, store assets
- [ ] Codex (astra): review all EN/DE strings for tone (short, warm, neutral, no jargon) and
  consistency; TalkBack labels; 48 dp targets; contrast; German overflow in screenshots at
  fontScale 1.5.
- [ ] Codex (astra): adaptive launcher icon (vector; calm, minimal, a full stop motif, coral) +
  monochrome layer; 3 variants → Claude shows owner, owner picks.
- [ ] `site/privacy/` EN/DE privacy policy (no data collected; local storage; backup files;
  contact e-mail placeholder until owner provides it – release blocker), GitHub Pages.
- [ ] `store/listing-en.md`, `store/listing-de.md`: title, short description (80), full
  description; phone screenshots from Roborazzi (EN/DE) with masked dates of no real person.

---

## M6–M7 Release (Claude + owner)

### Task 14: Release build + Play Console
- [ ] Owner creates upload key (stored outside repo, path only) – signing config reads
  `-Pfreeperiod.signing=<external properties>` like JaySay; never in repo.
- [ ] `bundleRelease` with R8; verify merged manifest (no INTERNET), APK size, versionCode 1,
  versionName 1.0.0.
- [ ] Play Console: create app "FreePeriod." (free, Health & Fitness), privacy policy URL,
  Health apps declaration (menstrual tracking), Data safety (no data collected/shared, data
  not encrypted in transit = N/A), content rating, target audience 16+ (verify policy for teens),
  store listing EN/DE.
- [ ] Internal testing → owner + Claude device checks.
- [ ] Closed testing with 5–8 users (verify org-account minimum); task list: log a period, log a
  day, read prediction, back up and restore. Fix round.
- [ ] Production staged rollout 20 % → 100 %; make GitHub repo public (GPL-3.0); tag `v1.0.0`.

---

## Rounds overview

| Round | Tasks | Model | Verification |
|---|---|---|---|
| setup | Task 0 (Claude) | – | `-Voll` online, `-Schnell` offline |
| engine | 1–3 | gpt-6.1-sol high | `-Schnell` in sandbox; Claude review |
| core | 4–6 | gpt-6.1-sol high | Claude `-Voll`, screenshots, device |
| history+day | 7–8 | resume core | same |
| recovery | 9 | gpt-6.1-sol high (fresh) | same + backup/restore on device |
| device | 10–12 | resume recovery | same + lock/notifications on device |
| polish | 13 | gpt-6-astra high | owner picks icon; Claude checks visuals |
| release | 14 | Claude + owner | Play Console |
