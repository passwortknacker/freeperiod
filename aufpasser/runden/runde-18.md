Implemented all four fixes. **Quick check GREEN, exit 0.**

**Changed**

- `TodayCard.kt`, `FpSurfaces.kt`: centred, single-line actions with stacking when needed; numeral stop gap reduced to 2 dp.
- `TodayFill.kt`, `MonthCalendar.kt`, `TodayLegend.kt`, `TodayScreen.kt`: borderless period fills and primary action, adjusted for ≥3:1 contrast.
- `CycleTimelineView.kt`, `TimelinePosition.kt`: more space for short period segments and a small today-marker halo.
- Today tests/fixtures: German layout checks at fontScale 1.5, contrast coverage, timeline ordering/spacing checks.

**Net:** +179 lines. Removed period outlines, the extra inner today ring, and fixed action-width allocation.

**Checked:** `tools\check.ps1 -Schnell`, using a single-use daemon. App and test sources compile; 103 engine tests pass from cache. The wrapper’s reported app failure is stale; app tests were not run.

**Screenshots for Claude to record**

Changed: `regular_enLight`, `regular_deDark`, `regular_enLarge`, `ongoingDay3_enLight`, `rangePassed_enLight`, `scheduledBreak_enLight`, `menopause_enLight`, `empty_enLight`, `calendarPredicted_enLight`.

Added: `regular_deLarge`.

**Open:** Screenshots were not re-rendered, per `AGENTS.md`. Visual review and execution of the new app tests remain with Claude.