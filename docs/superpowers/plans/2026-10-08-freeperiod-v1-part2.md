# FreePeriod. v1.0 – Implementation Plan, part 2

> Execution = Codex rounds supervised by Claude (`aufpasser/codex-projekt.md`). **sol**
> (`gpt-6.1-sol`) writes logic/features, **astra** (`gpt-6-astra`) does design system and visual
> work. Claude decides, verifies (Robolectric/Roborazzi, device), commits. TDD throughout.

**Goal:** Ship v1.0 with the scope of `docs/superpowers/specs/2026-10-08-freeperiod-v1-scope-2.md`
on top of the finished part 1 (Tasks 0–12, commits up to `e5e9e10`).

**Spec:** `2026-10-08-freeperiod-v1-scope-2.md` (wins) + `2026-10-07-freeperiod-design.md`.
**Design reference:** `docs/design/drafts/draft-5.html|png` + README section 5.

## Decisions from review round 12 (binding – override task text below where they differ)

1. **Timeline:** `PredictionState.RangePassed` also carries `earliest`. `cycleTimeline(...)` takes
   `fallbackLength: Int` (typical length, else median, else 28). Axis end = max(today, every
   segment end, axisStart + fallbackLength − 1); without prediction max(start + fallbackLength − 1,
   today + 3). Pill mode: axis = current pack (pack start … pack end), label "Pack day N".
   Large font (fontScale ≥ 1.3): timeline stacks below the numeral.
2. **Fixture:** ongoing period from 04-10, range **05-07..05-09** (centre 05-08) → recorded
   04-10..04-12, rest 04-13..04-14, axis 04-10..05-09.
3. **Phases:** `LifePhase { REGULAR, TRYING_TO_CONCEIVE, PREGNANT, POSTPARTUM, PERIMENOPAUSE,
   MENOPAUSE }`. PERIMENOPAUSE = statistical predictions + perimenopause items + "Cycles may vary
   more in this phase." MENOPAUSE = no prediction, history summary + months counter.
   **Precedence:** manual pause or PREGNANT/POSTPARTUM/MENOPAUSE → no prediction, no fertile window,
   no period reminder; else combined pill with rhythm → scheduled break; combined pill without
   rhythm or continuous → no statistical prediction, card says "Add your pack rhythm to see
   scheduled breaks." / "Continuous use – no scheduled break."; else statistical. User preferences
   (e.g. fertile window on) are kept while suppressed. Engine API: `fertileWindow(state,
   situation)` returns null unless allowed.
4. **Pill:** `today < packStart → null`; activeDays 1..365, breakDays 0..30; wording "Scheduled
   break" (EN) / "Geplante Pause" (DE), never "pill-free".
5. **Customization model (simplified, replaces Task C1 entities):** built-in categories/items are
   defined in code (typed DayLog fields stay). Room v2: `TagEntity` += `categoryId: Long?`
   (null = default "Tags" category) + `iconKey: String` (stable key, never a resource id);
   new `CustomCategoryEntity(id, name, iconKey, sortOrder, archived)`; `UiOverrideEntity(key,
   hidden, sortOrder)` for visibility/order of built-in categories/items and custom categories;
   `DayLog` += `ovulationTest: OvulationTest?`; `SituationEntity(id = 0, …)`;
   `ReminderEntity(id, kind, title?, recurrence fields, time, enabled, lastDeliveredDate?)`;
   `HintDismissalEntity(startPeriodId)`. Selections of custom items keep using `DayTagEntity`.
   Notes longer than 2000 chars are preserved (limit applies to typing only).
   DataStore reminder prefs migrate once into `ReminderEntity` rows (flag `remindersMigrated`).
6. **Backup:** file format stays 1; payload `schemaVersion` 1 or 2 is read from the authenticated
   JSON first, then decoded with the matching model and converted to 2. Validation covers IDs,
   FKs, built-in keys, recurrence params, complete pill config. On restore: delivery identities
   (`lastNotifiedPeriodId`, `lastDeliveredDate`) reset; reminders keep their enabled flag and are
   rescheduled after the transaction.
7. **Recurrence:** occurrence k of EveryNMonths = `anchor.plusMonths(k·n)` (no drift: Jan 31 →
   Apr 30 → Jul 31); n in 1..999; future anchor → first occurrence = anchor; `nextDate(after,
   inclusive)`. Notification identity = (reminderId, date); delivered only if notifications and
   channel enabled. Local time → `ZonedDateTime.of(date, time, systemZone)` at scheduling (DST gap
   shifts forward, overlap earlier offset); reschedule on time/zone change and boot.
8. **Onboarding picker:** contiguous selected days form one period; a block that includes today
   asks "Still ongoing?" (yes → end null); tapping a marked day unmarks it (splits blocks). Commit
   via one repository transaction `addPeriods(list)`; blocks overlapping existing periods are
   skipped and reported. Cycle-length question hidden when ≥1 eligible completed cycle exists.
   Non-drag alternative: tap start and end day (accessibility).
9. **Long-cycle hint:** baseline = up to 12 eligible cycles before the candidate (≥3), threshold
   length > 1.6 × median (median 28 → 45 qualifies, 44 not); candidates include auto-excluded
   long cycles; dismissal persisted. Copy: "This cycle was longer than your recent cycles. Review
   your entries if you'd like."
10. **Months counter:** "N full months since your last recorded period ended" (complete months
    from end + 1; ongoing → 0; no completed period → hidden). Example end 04-14, today 05-15 → 1.
11. **Wording (EN; DE equivalents):** general "FreePeriod. records what you enter and shows
    calendar estimates. It does not diagnose conditions or recommend treatment."; fertility
    disclaimer as spec + label "Possible fertile days (estimate)", never "safe days"; reminders
    "Notifications may arrive later than the time you choose."; phase picker "Choose the view
    that suits your situation. You can change it anytime."
12. **Defaults (lightweight):** Regular → short symptom set + "More"; Sex, Discharge, Tags, Note,
    custom categories collapsed; all reminders off; TTC only offers the fertile window.
13. **Round order:** A (sol, engine incl. model contract) ∥ B1 (astra, design system applied to
    all screens except Today) → B2 (astra, Today) → C1 (sol, persistence + backup v2 + migration)
    → C2 (reminders) → C3 (day entry) → C4 (onboarding + History) → D → E. Every round leaves the
    app compiling (new sealed states get minimal UI branches in the same round).
14. **Regulatory:** Claude re-checks current EU MDR/Play wording for the fertile window before C2.

## Global constraints (additions to part 1)

- All part-1 constraints stay (no INTERNET, LocalDate epoch days, enums by name, EN+DE strings,
  neutral wording, Codex never commits, simplicity rule).
- Room schema goes to **version 2** with a tested migration from 1; backup schema **version 2**;
  `BackupCodec.decode` accepts schema 1 (migrated in memory) and 2.
- No screen hard-codes colours, fonts or shapes: everything via the design-system tokens
  (`ui/theme/`). Accent is a setting.
- Fonts: Bricolage Grotesque + DM Sans static TTFs in `app/src/main/res/font/` with OFL text in
  `app/src/main/assets/licenses/` (Claude downloads from github.com/google/fonts before round C).

## Review focus

1. Migration v1 → v2 on a device with real data (periods, logs, tags) keeps everything; tags
   become items of the default "Tags" category. Test `MigrationTest.v1ToV2KeepsData`.
2. Restore of a schema-1 backup into v2. Test `BackupCodecTest.decodesSchema1`.
3. Pill rhythm across pack boundaries and a pack start in the future. Test
   `PillScheduleTest.breakDaysAcrossPacks`, `futurePackStartHasNoBreakYet`.
4. Phase switch mid-cycle (Regular → Pregnant → Regular) hides/restores predictions and reminders
   without losing data. Test `SituationTest.phaseSwitchRestoresPredictions`.
5. Drag-select in onboarding across month boundaries and over an existing period. Test
   `PastPeriodPickerTest.dragAcrossMonths`, `overlapMergesNotDuplicates`.

---

## Round A – engine v2 (sol, sandbox-testable)

### Task A1: Prediction v2 + timeline + fertile window + missed-log

**Files:** modify `engine/.../Prediction.kt`, `Stats.kt`; create `Timeline.kt`, `Fertility.kt`;
tests `PredictionTest`, `TimelineTest`, `FertilityTest`.

**Produces:**
```kotlin
// predict(): centre from the last 6 eligible cycles, half-width from the last 12 (spec §6).
data class CycleTimeline(val axisStart: LocalDate, val axisEnd: LocalDate, val today: LocalDate,
  val recordedPeriod: ClosedRange<LocalDate>?, val expectedPeriodRest: ClosedRange<LocalDate>?,
  val bracket: ClosedRange<LocalDate>?, val bracketKind: BracketKind?)
enum class BracketKind { LIKELY, PILL_FREE }
fun cycleTimeline(periods: List<Period>, state: PredictionState, pill: PillSchedule?, today: LocalDate): CycleTimeline?
fun fertileWindow(state: PredictionState): ClosedRange<LocalDate>?   // Range only: centre−14 → −5..+1
fun longCycleHints(cycles: List<Cycle>): Set<Long>                   // startPeriodIds, >1.6×median, needs ≥3 eligible
fun periodEndForTapToday(ongoing: Period, today: LocalDate): LocalDate = maxOf(ongoing.start, today.minusDays(1))
```
- [ ] Tests (2026 dates, explicit today): `centreUsesLastSixSpreadUsesLastTwelve` (12 cycles:
  first six 32, last six 28 → centre +28, half-width from all 12: MAD of [32×6,28×6] = 2 →
  ceil(3) = 3), `timelineDayThreeOfOngoingPeriod` (start 04-10, ongoing, today 04-12, typical
  period 5, range 05-06..05-09 → recorded 04-10..04-12, rest 04-13..04-14, bracket 05-06..05-09,
  axis 04-10..05-09), `timelineWithoutPredictionExtendsPastToday`, `timelinePillFree`,
  `fertileWindowFromCentre` (centre 04-23 → 04-04..04-10), `noFertileWindowWhenVaries`,
  `longCycleHint`, `periodEndTapIsYesterday`, `periodEndTapSameDayIsStart`.

### Task A2: Situation + pill schedule

**Files:** create `engine/.../Situation.kt`, `PillSchedule.kt`; tests.
```kotlin
enum class LifePhase { REGULAR, TRYING_TO_CONCEIVE, PREGNANT, POSTPARTUM, MENOPAUSE }
enum class Method { NONE, PILL_COMBINED, PILL_PROGESTIN, RING, PATCH, IUD_HORMONAL, IUD_COPPER, IMPLANT, INJECTION, CONDOM, OTHER }
data class PillSchedule(val packStart: LocalDate, val activeDays: Int, val breakDays: Int)  // breakDays 0 = continuous
data class Situation(val phase: LifePhase = LifePhase.REGULAR, val method: Method = Method.NONE,
  val pill: PillSchedule? = null, val fertileWindowEnabled: Boolean = false)
fun PillSchedule.breakDaysAround(today: LocalDate): ClosedRange<LocalDate>?  // current or next break; null if continuous or packStart > today+activeDays
fun Situation.predictionMode(): PredictionMode   // STATISTICAL, PILL_FREE, PAUSED, MENOPAUSE
fun Situation.fertileWindowAllowed(): Boolean
fun monthsWithoutPeriod(periods: List<Period>, today: LocalDate): Int?
```
`predict(...)` gets an overload `predict(periods, settings, situation, today)` that returns `Paused`
for PAUSED, and a new state `PredictionState.PillFree(breakDays, cycleDay)` and
`PredictionState.Menopause(monthsWithoutPeriod, lastStart)`.
- [ ] Tests: `breakDaysAcrossPacks` (21+7 from 01-01 → breaks 01-22..01-28, 02-19..02-25),
  `continuousHasNoBreak`, `futurePackStartHasNoBreakYet`, `phaseSwitchRestoresPredictions`,
  `hormonalMethodsDisallowFertileWindow`, `monthsWithoutPeriodCounts`.

### Task A3: Reminder recurrence

**Files:** create `engine/.../Recurrence.kt`; test `RecurrenceTest`.
```kotlin
sealed interface Recurrence { data object Daily; data class EveryNDays(val n: Int, val anchor: LocalDate)
  data class Weekly(val day: DayOfWeek); data class MonthlyOnDay(val day: Int)
  data class EveryNMonths(val n: Int, val anchor: LocalDate); data class Once(val date: LocalDate) }
fun Recurrence.nextDate(after: LocalDate, inclusive: Boolean): LocalDate?   // MonthlyOnDay 31 → last day of short months
```
- [ ] Tests: daily, every 3 days from anchor, weekly Monday, monthly day 31 in Feb → Feb 28/29,
  every 3 months from 2026-01-31 → 04-30, once in past → null.

### Task A4: Backup schema 2

Add to `BackupData`: `situation: Situation`, `categories`, `items` (see Task C1 model),
`reminders`; `schemaVersion = 2`; decode schema 1 → v2 in memory (tags → items of category
"tags"). Tests `decodesSchema1`, `roundTripV2`, validation of new references.

**Round A exit:** `-Schnell` green; Claude reviews; commit.

---

## Round B – design system + Today (astra; Claude runs screenshots)

### Task B1: Design system
**Files:** `ui/theme/{Color,Type,Shape,Tokens,Theme}.kt`, `res/font/*`, `ui/components/*`
(FpCard, FpChip, FpFaceChip, FpButton, FpSectionRow, FpNavBar, FpTopBar, FpSwitchRow,
FpLegend). `AppSettings.accent: Accent` (enum CORAL default, PLUM, SAGE, OCEAN, OCHRE, INK)
replaces `dynamicColor`. Apply to every existing screen (no visual regressions: all screenshots
re-recorded and inspected). Accent picker in Settings → Appearance (swatches, preview).
- [ ] Tests: `accentPersists`, contrast unit test over all 6 accents × light/dark for text-on-
  accent and selected-chip text (WCAG ratio ≥ 4.5), screenshots for each accent on Today.

### Task B2: Today redesign
Numeral + full stop + `CycleTimelineView(CycleTimeline)` (Canvas, semantics description),
card states incl. PillFree and Menopause, "Period ended" (uses `periodEndForTapToday`), calendar
markers + fertile band + legend, motion per spec §1 (respects animator duration scale).
- [ ] Screenshots: regular, ongoing day 3, rangePassed, pillFree, menopause, empty, dark, DE,
  fontScale 1.5, fertile window on.

**Round B exit:** Claude records + inspects every screenshot, sends a board to the owner.

---

## Round C – features (sol)

### Task C1: Room v2 + customization model
Entities: `CategoryEntity(id, key /*builtin key or null*/, name?, kind /*BUILTIN_MOOD…, CUSTOM_MULTI*/, hidden, sortOrder)`,
`ItemEntity(id, categoryId, builtinKey?, name?, icon, hidden, archived, sortOrder)` (replaces
`TagEntity`; tags migrate to items in category "tags"), `DayItemEntity(epochDay, itemId)`
(replaces `DayTagEntity`), `SituationEntity(id=0, phase, method, pillPackStart?, pillActive?,
pillBreak?, fertileWindowEnabled)`, `ReminderEntity(id, kind, title?, recurrence fields, time,
enabled)`. Built-in symptoms stay engine enums (stats/backup); their visibility/order lives in
`ItemEntity` rows with `builtinKey`. New built-in symptoms: HOT_FLUSHES, NIGHT_SWEATS, BRAIN_FOG,
JOINT_PAIN; DayLog field `ovulationTest: OvulationTest? {NEGATIVE, POSITIVE}`.
- [ ] Tests: `v1ToV2KeepsData`, `hiddenItemsNotShownButKeptInHistory`, `customItemRoundTrip`.

### Task C2: My situation + reminders UI
Settings → My situation (phase, method, pill rhythm/pack start, fertile window toggle with
disclaimer dialog); Settings → Reminders (list, add/edit/delete, presets from method);
scheduler: one unique one-time work per reminder at next occurrence, re-enqueued after firing,
on boot/time change; period-due reminder keeps its engine rule.
- [ ] Tests: presets per method, `reminderReschedulesAfterFiring`, disclaimer required to enable.

### Task C3: Day entry v2 + customization UI
Mood first; collapsed rows with summaries; inline note (2000 chars, preview); Settings → Day
entry (show/hide/reorder categories and items, add item with icon, add category).
- [ ] Tests: `noteAutosavesAndPreviews`, `reorderPersists`, `customCategoryShowsInEntry`.

### Task C4: Onboarding v2 + History v2
Onboarding steps per spec §7 incl. `PastPeriodPicker` (6 months, drag + tap, merges with
existing, creates completed periods via `addPeriod`). History: horizontally scrollable chart
(LazyRow of bars, latest right, edge fade), bar tap → sheet, excluded-in-range list, long-cycle
hint, monthly symptom view in menopause.
- [ ] Tests: `dragAcrossMonths`, `overlapMergesNotDuplicates`, `barTapOpensSheet`,
  `excludedListMatchesVisibleRange`.

**Round C exit:** Claude full gate + screenshots + device test.

## Round D – visual polish of new screens (astra)
Onboarding visuals, My situation, Reminders, Day-entry settings, History sheet, empty states,
launcher icon (adaptive + monochrome; "F" + coral full stop), store screenshots EN/DE.

## Round E – release (Claude + owner)
Privacy policy (GitHub Pages, EN/DE), README with donation links, store listing EN/DE, Data
safety, Health apps declaration, target audience 13+, upload key, internal → closed test →
production; repo public.
