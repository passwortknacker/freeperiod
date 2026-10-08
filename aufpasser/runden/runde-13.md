**A1–A4 implemented; required GREEN verification is blocked.**

**Changed:**

- `Prediction.kt`, `Stats.kt`, `Timeline.kt`, `Fertility.kt`: prediction v2, timeline, fertile window, long-cycle hints, tap-end rule.
- `Situation.kt`, `PillSchedule.kt`, `Recurrence.kt`: precedence, validated pill rhythm, months counter, recurrence without anchor drift.
- `Model.kt`, `Reminders.kt`, `LocalTimeSerializer.kt`: v2 model contracts.
- `backup/*.kt`: authenticated schema dispatch, schema-1 conversion, extended validation.
- `CsvExport.kt`: `ovulation_test` and `custom_items` columns.
- Engine tests: 33 added, including corrected fixtures and boundary cases.
- `TodayCard.kt`: minimal branches for new states.

**Net:** +785 / −44 = **+741 lines**. Replaced schema-1-only decoding and the old centre calculation.

**Checked:** `powershell -NoProfile -ExecutionPolicy Bypass -File tools\check.ps1 -Schnell`

- Earlier engine run: **101 passed, 1 CSV assertion failed**. Assertion corrected afterward.
- Final two attempts: **exit 1**, before compilation, with `GeneratedClassCompilationException: Unable to compile generated classes`.
- Corrected CSV test and final app compilation remain unverified. Stopped after two identical failures per `AGENTS.md`.

**Screenshot tests:** none.

**Decisions:** documented override-key grammar; future pill packs return `NeedsPillRhythm`. The parallel round supplied symptom labels/icons.