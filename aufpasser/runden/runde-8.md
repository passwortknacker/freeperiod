**Changed**

- `reminders/*`: delivery, scheduling, notification/channel checks, time-change receiver.
- `lock/*`, `MainActivity.kt`: biometric gate, elapsed-time timeout, `FLAG_SECURE`, navigation preservation.
- `ui/onboarding/*`, `AppNav.kt`: three pages, Skip, explicit period end date, reminder opt-in.
- `ui/settings/*`: reminder, permission, time and lock controls.
- `AppContainer.kt`, `FreePeriodApp.kt`, manifest: DI, WorkManager initialization and permissions.
- EN/DE resources and notification icon added.
- **36 new tests**; existing Settings tests updated.
- **Net +1,267 lines** (+1,289 / −22). Removed the onboarding placeholder. Engine and dependencies unchanged.

**Checked**

Required `tools\check.ps1 -Schnell`: **GREEN, exit 0**. App and test sources compile. Cached engine results: **69 passed**; the script’s 162 total includes previous app results.

**Screenshots to record**

- `OnboardingScreenshotTest`: `page1_enLight`, `page2_deDark`, `page3_enLight`
- `SettingsScreenshotTest`: `main_enLight`, `main_deDark` updated
- `LockScreenshotTest`: `locked_enLight`

**Open points**

Robolectric, screenshot recording, lint/release and physical-device checks await Claude. References were not modified.