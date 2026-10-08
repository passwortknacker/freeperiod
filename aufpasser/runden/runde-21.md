**Quick check GREEN. Net +613 lines: 667 added, 54 removed.**

**Changed**

- `CsvImport.kt` + tests: CSV parsing, date-format choices, bleeding-day grouping and first-row preservation.
- `Import*.kt`, onboarding/nav, Backup screen/routes, EN/DE strings: shared preview, overlap reporting and existing backup restore. Full restore completes onboarding without overwriting restored settings.
- Settings dialog components + regression tests: bounded editor layout, corrected gesture timing, visible chart targets and dialog-scoped “None” selection. Removed nested dialog wrappers and premature clock freezes.
- `app/build.gradle.kts`: external signing configuration gated to release packaging; version remains `1 / 1.0.0`. Relative `storeFile` resolves from the properties-file directory.

**Checked**

`powershell -NoProfile -ExecutionPolicy Bypass -File tools\check.ps1 -Schnell`: **exit 0**. **112 engine tests passed**, including 9 CSV tests; app and app-test Kotlin compiled. Diff check clean.

**Screenshot tests**

- Added: `OnboardingScreenshotTest.import_enLight`, `ImportScreenshotTest.preview_enLight`.
- Changed: History `sheet_enLight`; Situation `methodPicker_enLight`, `pillRhythm_deLight`; DayEntrySettings `addItem_enLight`; Backup `backupForm_enLight`.
- Re-record onboarding `pastPeriods_enLight` and `pastPeriods_deDark` too.

**Open points**

Claude must verify the six Robolectric fixes and release packaging. The quick gate’s six reported app failures are cached XML from the earlier run; Robolectric was not executed under `AGENTS.md`.