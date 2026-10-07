Implemented Tasks 7–8 and both Today fixes.

**Changed**

- `ui/history/*`: eligible-cycle medians, CycleUse toggles, newest-first cycles, symptom counts.
- `ui/day/*`, `AppNav.kt`: full-height entry sheet, ordered autosaves, period validation, tags, Clear + Undo, future-day restrictions.
- `PredictionRangeFormatter.kt`, `TodayCard.kt`: compact EN/DE date ranges.
- Drawable XMLs, `themes.xml`, bilingual strings: 20 outlined icons and labels.
- Tests: 33 new tests.
- **Net: +1,650 lines** (+1,682/−32). Removed History/day placeholders and the verbose formatter. Engine and dependencies unchanged.

**Checked**

`powershell -NoProfile -ExecutionPolicy Bypass -File tools\check.ps1 -Schnell`: **GREEN, exit 0**. Engine: 69 cached tests, zero failures. App and test sources compile; app tests and lint await Claude.

**Screenshots to record**

- `TodayScreenshotTest`: `calendarPredicted_enLight`; updated `regular_enLight`, `regular_deDark`, `regular_enLarge`.
- `HistoryScreenshotTest`: `withCycles_enLight`, `withCycles_deDark`, `empty_enLight`.
- `DayEntryScreenshotTest`: `filled_enLight`, `filled_deDark`, `empty_enLarge`.

**Open points:** Claude’s runtime checks and reference recording remain. Verification used a workspace-local cache and temporary debug key; rebuild with the normal key before device installation.