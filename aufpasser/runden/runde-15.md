**Today is implemented in the working tree; GREEN and Undo integration remain blocked.**

- **Changed:** `ui/today/` card, timeline, calendar, motion, end-period feedback and tests; Settings icons/dividers; Day entry spacing; EN/DE resources. Removed the old end-confirmation dialog and obsolete screenshot methods. **Net +585 lines**.
- **Checked:** `tools\check.ps1 -Schnell`, exit **1**. Both workspace Android-home attempts failed on `debug.keystore.lock`. Engine tests were cached; app/test compilation and screenshot rendering remain unverified.
- **Screenshots to record:** `regular_enLight`, `regular_deDark`, `regular_enLarge`, `ongoingDay3_enLight`, `rangePassed_enLight`, `scheduledBreak_enLight`, `menopause_enLight`, `empty_enLight`, `calendarPredicted_enLight`. Also refresh existing Settings/Day screenshots.
- **Open:** Undo is implemented and tested in source, but hidden until its navigation callback is wired.

May I add `onUndoEnd = { todayViewModel.undoPeriodEnd(it) }` to the Today call in `AppNav.kt`? Your explicit scope fence excludes that file.