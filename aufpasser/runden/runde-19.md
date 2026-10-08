**Changed:** 20 files, **+945 / −251, net +694 lines**, excluding astra’s presentation changes.

- `ui/onboarding/`: six skippable steps, saved draft, six-month picker, ongoing-period confirmation and overlap reporting.
- `ui/history/`: scrollable bars, cycle sheet, visible-range exclusions, persistent hints and monthly menopause symptoms.
- `AppNav.kt`: saved-state creation and action wiring.
- `ReminderSummary.kt`: period-due offset summary; two dialog screenshot tests now freeze the clock.
- Resources/tests: EN/DE copy and behavior coverage; obsolete onboarding/history screenshot cases replaced.

**Checked:** `tools\check.ps1 -Schnell` **GREEN, exit 0**. 103 engine tests green; app and test sources compile. Robolectric/Roborazzi execution remains for Claude.

**Screenshot tests:**

- Onboarding: `welcome_enLight`, `phase_enLight`, `pastPeriods_enLight`, `pastPeriods_deDark`, `reminders_enLight`
- History: `chart_enLight`, `chart_deDark`, `sheet_enLight`, `empty_enLight`, `menopause_enLight`
- Fixed: `addItem_enLight`, `pillRhythm_deLight`

**Choices:** dragging requires long press to preserve ordinary scrolling. Skipped overlaps are reported on the final step before completion.