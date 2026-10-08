Implemented Round 23. **App verification remains blocked by incomplete engine build metadata.**

- **Changed:** `Situation.kt`, `Fertility.kt`: default on; inclusive window `(earliest − 19)..(latest − 14)`, documented and tested for 6/8 days.
- **Changed:** `TodayViewModel.kt`, `MonthCalendar.kt`, `TodayLegend.kt`, `TodayCard.kt`, `TodayScreen.kt`: window state, underline markers, accessibility labels, legend, upcoming/current date line, disclaimer dialog.
- **Changed:** `SituationScreen.kt`: persisted switch, visible for compatible situations even after switching off.
- **Changed:** `MedicalDisclaimer.kt`, `OnboardingScreen.kt`, `InfoScreens.kt`, both `strings.xml`: shared disclaimer and EN/DE wording.
- **Changed:** engine and app tests cover maths, compatibility, defaults, restore, CSV, reset, persistence, accessibility, contrast, and disclaimer visibility.
- **Net:** **+303 lines** for this round. Removed centre-based window arithmetic and the obsolete “no fertility UI” regression.

**New string keys:** `medical_disclaimer_title`, `medical_disclaimer_note`, `pregnancy_chance_label`, `pregnancy_chance_estimate`, `pregnancy_chance_dates`, `pregnancy_chance_info`, `calendar_pregnancy_chance`, `show_pregnancy_chance`, `pregnancy_chance_detail`. Replaced existing `app_estimates`.

**Checked:** `powershell -NoProfile -ExecutionPolicy Bypass -File tools\check.ps1 -Schnell`. TDD red: 5 expected failures. Latest engine results: **115 tests, 0 failures**. Gate exit **1**: app compilation cannot resolve engine functions missing from its module metadata. Preserving the build directory was denied; stopped after two compilation failures per `AGENTS.md`. App tests remain uncompiled/unrun.

**Screenshots for Claude:**

- Added `today/fertile_enLight`, `today/fertile_deDark`, `today/disclaimer_enLight`, `settings/situationFertile_enLight`, `onboarding/welcome_deDark`.
- Updated `onboarding/welcome_enLight`.
- References untouched.

**Open points:** regenerate engine build outputs, rerun the gate, then execute app tests and record screenshots. CSV imports preserve existing opt-outs; fresh imports inherit default on.

**Worth knowing:** the gate’s reported 339 tests includes historical app results; 115 is the current engine count.