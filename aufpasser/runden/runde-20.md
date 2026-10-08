**Implemented. Quick check GREEN, exit 0.**

**Changed**

- `SituationScreen.kt`: compact phase radio list, method sheet, tidier pill-rhythm dialog.
- `RemindersScreen.kt`: padded cards, edit/delete icons, separate notification options, compact editor pickers.
- `DayEntrySettingsScreen.kt`: padded panels and accessible reorder icons.
- `AppearanceScreen.kt`: calmer swatches, large-text layout, refreshed preview.
- `SettingsPresentation.kt`, `SettingsScreen.kt`: shared presentation helpers and meaningful navigation icons.
- Launcher/notification XML: original rounded **F.**, cream background, monochrome and white silhouettes.
- EN/DE strings and screenshot coverage updated.

**Net:** +368 lines. Removed long option stacks and text-heavy action rows.

**Checked:** `tools\check.ps1 -Schnell`; app and test sources compiled. 103 cached engine tests pass; wrapper reports 104 existing results, zero failures.

**Screenshots for Claude**

- `SituationScreenshotTest`: `situation_enLight`, `pillRhythm_deLight`, **new** `methodPicker_enLight`, `situation_deLargeDark`
- `RemindersScreenshotTest`: `list_enLight`, `editor_enLight`, **new** `editor_deLargeDark`
- `DayEntrySettingsScreenshotTest`: `main_enLight`, `addItem_enLight`, **new** `main_deLargeDark`
- `AccentScreenshotTest`: `settingsAppearance_enLight`, **new** `settingsAppearance_deLargeDark`
- `SettingsScreenshotTest`: `main_enLight`, `main_deDark`
- **New** `IconScreenshotTest`: `launcher_light`, `launcher_dark` with 192 px icons

**Open:** References were not recorded, per `AGENTS.md`. New app tests and visual review remain with Claude.