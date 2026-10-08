**Implemented in scope; GREEN is blocked.**

- **Changed:** theme tokens/fonts/shapes, shared components, scoped screens, accent persistence/picker, EN/DE strings and font licences. Removed wallpaper colours and always-expanded optional fields. **Net: +763 lines**.
- **Checked:** `tools\check.ps1 -Schnell`, exit **1**. First run: 102 engine tests, 1 failure, plus compilation errors. Scoped errors corrected. Retry stopped before compilation on an external TOML BOM.
- **Screenshots:** existing names retained. Added `AccentScreenshotTest.settingsAppearance_enLight` and `dayEntry_{coral,plum,sage,ocean,ochre,ink}_enLight`. Not rendered or recorded.
- **Open:** `gradle/libs.versions.toml` needs its BOM removed; the parallel round’s CSV test failed.

May I change the single root theme call in `MainActivity.kt` from `dynamicColor` to `accent`? Your explicit scope fence excludes that file; the unchanged call prevents compilation.