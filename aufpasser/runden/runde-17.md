**Changed:** 34 files, **+1,323 / −301, net +1,022 lines**, excluding astra’s parallel changes.

- `ui/settings/`: situation, pill rhythm, reminder editing and day-entry customization; removed legacy reminder controls.
- `ui/day/`, navigation and Today wiring: saved situation, visibility/order, custom items and ovulation tests.
- `reminders/`, `Repository.kt`, `AppContainer.kt`: recurrence-based one-time scheduling and delivery identities.
- `MigrationTest.kt`: direct SQLite v1 fixture; removed helper/instrumentation hacks.
- `BackupViewModel.kt`, icons and EN/DE resources: custom-category CSV export and localized controls.

**Checked:** `tools\check.ps1 -Schnell` **GREEN, exit 0**. 103 engine tests pass; app and test sources compile. Robolectric/Roborazzi were not executed. The script’s “104 / 1 failed” includes the stale migration-test report.

**Screenshot tests for Claude:**

- `SituationScreenshotTest`: `situation_enLight`, `pillRhythm_deLight`
- `RemindersScreenshotTest`: `list_enLight`, `editor_enLight`
- `DayEntrySettingsScreenshotTest`: `main_enLight`, `addItem_enLight`
- `DayEntryScreenshotTest`: `menopause_enLight`

Existing Settings main and DayEntry filled/empty references also change.

**Decisions left open by the plan:** custom symptom items use a backing category marked `builtin:symptoms`, preserving Room v2. Method reminder intervals and one-off dates require user entry before saving.