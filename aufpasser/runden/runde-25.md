Implemented Stage A + B.

**Changed:**

- Engine model, selection and appearance files: centralized exclusivity, label/icon resolution and custom single-choice categories.
- Backup and CSV files: schema 3, backward decoding, own-item names and round trips.
- Room entities, mapping, migrations and schema: version 2 → 3; lazy marker categories; archive used items and delete unused ones.
- Customize, day-entry, History and preview files: rename/icon/reset, visibility, ordering, own items and adaptive choice grids.
- Import UI and EN/DE strings: diary import and customization text.
- Tests: engine coverage plus migration, UI, repository and screenshot cases.

**Net:** +1,457 lines across 46 files, including 547 generated schema lines. Removed duplicate choice/chip rendering and the symptoms-only add-item path.

**Checked:**  
`powershell -NoProfile -ExecutionPolicy Bypass -File tools\check.ps1 -Schnell`

- **GREEN, exit 0:** 135 engine tests passed; app and test Kotlin compiled.
- `git diff --check` passed.

**New screenshot tests for Claude to record:**

- `DayEntrySettingsScreenshotTest.expandedMoodWithOwnItem_enLight`
- `DayEntrySettingsScreenshotTest.renameEntry_enLight`
- `DayEntryScreenshotTest.sixMoods_enLargeLight`
- `DayEntryScreenshotTest.sixMoods_enLargeDark`

**Open points:** Robolectric, screenshot comparisons and lint await Claude’s full check, per AGENTS.md. Existing DayEntry and History references need review for changed rendering. Changing a custom category to “Pick one” preserves historical selections; subsequent selections enforce exclusivity.