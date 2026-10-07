**Changed**

- `ui/settings/*`: Settings, backup/restore, CSV export, Privacy, About.
- `backup/BackupIo.kt`: SAF I/O with a 20 MB read cap.
- `AppContainer.kt`, `AppNav.kt`: wiring; removed Settings placeholder.
- `AndroidManifest.xml`, `locales_config.xml`: EN/DE per-app languages.
- Both `strings.xml`: bilingual settings, recovery and privacy text.
- `HistoryScreen.kt`: plain rounded cycle bar.
- `DayEntrySheet.kt`: selected mood keeps accent tint.
- Test sources: **27 new tests**.
- **Net: +1,261 lines** (+1,269 / −8). Engine and dependencies unchanged.

**Checked**

`powershell -NoProfile -ExecutionPolicy Bypass -File tools\check.ps1 -Schnell`: **GREEN, exit 0**, without overrides. App and test sources compile; cached engine results: **69 passed**. App tests and lint await Claude.

**Screenshots to record**

- `SettingsScreenshotTest`: `main_enLight`, `main_deDark`
- `BackupScreenshotTest`: `backupForm_enLight`, `restoreSummary_deLight`
- `PrivacyScreenshotTest`: `privacy_enLight`
- Re-record History `withCycles_enLight`, `withCycles_deDark`; Day entry `filled_enLight`, `filled_deDark`. Names unchanged.

**Open points / deviations**

- Unknown-length streams reaching exactly 20 MB are rejected to avoid reading beyond the cap.
- Privacy/source URLs and contact remain placeholders.
- Screenshot references were not modified.