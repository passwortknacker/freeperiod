Implemented Tasks 4–6 within `app/`.

**Changed**

- `AppContainer.kt`, `FreePeriodApp.kt`, `MainActivity.kt`, `Theme.kt`: manual DI, FragmentActivity, settings-driven theme.
- `SettingsStore.kt`: device preferences with specified defaults.
- `data/db/*.kt`, exported `1.json`: Room v1 entities, converters, DAOs, indices and cascading FKs.
- `Repository.kt`, `DatabaseMapping.kt`: complete interface, serialized transactional writes, validation and atomic restore.
- `AppNav.kt`, `NavigationIcons.kt`: bottom navigation, onboarding and day placeholders.
- `ui/today/*.kt`: contextual card, accessible locale-aware calendar, actions, midnight/resume refresh.
- EN/DE `strings.xml`; test files: bilingual copy and 33 new app tests.
- **Net:** +1,762 lines (+1,774/−12). Replaced the placeholder activity entry and streamlined theme selection; retained `SmokeScreenshotTest`.

**Checked**

- `powershell -NoProfile -ExecutionPolicy Bypass -File tools\check.ps1 -Schnell`: **GREEN, exit 0**. Reported 70 engine tests, zero failures; app and test sources compile.
- App Robolectric/Roborazzi tests and lint remain for Claude.

**Screenshot tests to record**

`TodayScreenshotTest`:

- `empty_enLight`, `empty_deDark`, `empty_enLarge`
- `regular_enLight`, `regular_deDark`, `regular_enLarge`
- `rangePassed_enLight`, `rangePassed_deDark`, `rangePassed_enLarge`
- `ongoing_enLight`, `ongoing_deDark`, `ongoing_enLarge`

**Open points / deviations:** Claude’s runtime checks and screenshot inspection remain. No engine API or dependency changes; screenshot references untouched.