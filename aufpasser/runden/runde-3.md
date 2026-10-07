**Changed:** only `engine/`, **+1,041 net lines**.

- `Model.kt`, `LocalDateSerializer.kt`: serializable domain types, ISO dates, `DayLog.isEmpty()`.
- `PeriodRules.kt`: validation, cycles, lookup, cycle day, period length, end suggestions.
- `Stats.kt`: median, MAD, `symptomCounts`.
- `Prediction.kt`: all specified states, ranges, eligibility filtering, twelve-cycle limit.
- `backup/BackupData.kt`, `backup/BackupCodec.kt`: bounded JCA encryption, authenticated headers, complete payload validation.
- `export/CsvExport.kt`: RFC 4180 output with `cycle_use`.
- `Reminders.kt`: catch-up window and deduplication by period ID.
- Seven focused test files added; placeholder `Engine.NAME` and `SmokeTest` removed.

**Checked:** `powershell -NoProfile -ExecutionPolicy Bypass -File tools\check.ps1 -Schnell` → **GREEN, exit 0**. **69 engine tests passed**; app compilation passed. Script aggregate: 70, including an existing app test result. Red results captured before each task implementation.

**Screenshot tests added/changed:** none.

**Decisions / deviations:** added a clock-injected decode overload; MB limits use decimal bytes; tag-name uniqueness is case-insensitive; empty median/MAD inputs throw; CSV collections have deterministic ordering. Codec remains synchronous per the interface, so app callers must use `Dispatchers.Default`.