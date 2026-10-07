**Verdict**  
Revision 2 is implementable, but part 2 is not ready for execution: several behavioral contracts and migration paths remain incomplete.  
The visual direction is strong; customization and six-step onboarding need tighter defaults to preserve lightweight use.

**Must-fix**

- **High · A1, timeline contract.** `RangePassed` currently retains only `latest`, so it cannot supply the original bracket. `cycleTimeline` also lacks the configured fallback length. Preserve range geometry independently of display state; pass fallback length explicitly. Set the axis end to at least today and every displayed segment’s end. Without prediction, use `max(start + length, today + 3 days)`: the specified `start + cycleDay + 3` reaches **today + 4**, because cycle day is one-based. Define a pack-based axis when no period exists.

- **High · A1, impossible prediction fixture.** May 6–9 contains four dates and cannot result from an integer centre with symmetric integer half-width. For April 10 + 28 days, use **May 7–9**, centred on May 8. The recorded April 10–12 and expected April 13–14 segments remain correct. The draft’s ongoing timeline ends at today and omits the next range; scope revision 2 overrides that design behavior.

- **High · A2, situation rules.** One `MENOPAUSE` value conflates perimenopause tracking with the no-prediction counter mode. Separate these modes explicitly, without inferring either from elapsed time. Specify precedence: manual pause and suppressing phases prevent predictions/fertile overlays regardless of method. Preserve user preferences while temporarily suppressing their effects. Enforce fertility eligibility inside the engine API; `fertileWindow(state)` alone cannot prevent prohibited combinations.

- **High · A2, pill edge cases.** `packStart > today + activeDays` contradicts `futurePackStartHasNoBreakYet`: it permits near-future packs. Replace it with **`today < packStart → null`**. Require positive active days, nonnegative break days and bounded arithmetic. Continuous use produces neither a break bracket nor statistical fallback. Distinguish **“Pack day”** from bleeding-based cycle day. Define behavior when a combined-pill method has no configured rhythm.

- **High · A4/C1, incomplete migration.** Backup v2 lists item definitions but omits an explicit representation of **day-to-item selections**. Add it, ovulation results, configuration overrides and persisted hint dismissals. Update `DayLog.isEmpty`, mappings, snapshot/restore and CSV so custom-only entries survive. Preserve tag IDs, archive flags, links, `CycleUse`, null-versus-`NONE`, and existing notes exceeding 2,000 characters. Add an idempotent migration of reminder preferences from DataStore; Room migration alone cannot preserve them. Register the migration in `AppContainer`.

- **High · A4, restore contract.** Keep encrypted **file format 1** distinct from payload **schema 2**. After authentication, inspect the schema and select the appropriate decoder before conversion. Validate IDs, foreign keys, built-in keys, recurrence parameters and complete pill configurations. Restore all domain data transactionally; reconcile scheduled work afterward. Define whether restored reminders require re-enabling, and prevent old delivery identifiers from suppressing notifications for unrelated restored periods.

- **High · A3/C2, recurrence and delivery.** Define inclusive/exclusive behavior, future anchors, invalid `n`, and month-end policy. Calculate every-N-month occurrences from the **original anchor**, preventing January 31 → April 30 → July 30 drift; July must remain **31**. Add local-time tests for DST gaps/overlaps, timezone changes, denied notifications, edits/deletions, restore, and delayed workers. Store the period reminder’s `daysBefore` and delivery identity explicitly. A recurrence date alone does not define a notification occurrence.

- **High · C4, onboarding loses ongoing periods.** “Creates completed periods” removes part 1’s ability to record a current ongoing period. When selection includes today, ask **“Still ongoing?”** Define contiguous selection, unmarking/splitting and overlap resolution. Existing `addPeriod` rejects overlaps; merging requires an atomic operation that preserves IDs and inclusion overrides. Hide typical length only when an **eligible completed cycle** exists, not merely two period records.

**Should-fix**

- **Medium · A1, long-cycle hint.** Specify the baseline window and whether the candidate participates. Recommend the preceding 12 eligible cycles, at least three, excluding the candidate; evaluate all completed candidates, including automatically excluded long cycles. With median 28, the threshold is **44.8**: 44 does not qualify, 45 does. Persist dismissal by cycle identity. Gentler copy: **“This cycle was longer than your recent cycles. Review your entries if you’d like.”**

- **Medium · A2, months without periods.** Missing logs cannot establish absence of bleeding. Use **“N full months since your last recorded period ended.”** Define complete calendar months from the first day after the recorded end; ongoing → 0, no completed history → unknown. Example: end April 14, today May 15 → 1. Avoid interpreting the count as menopause confirmation.

- **Medium · scope coverage.** Add explicit acceptance criteria for mini-pill uncertainty wording, phase-specific item visibility that preserves manual overrides, ovulation-test entry/clearing, custom-item CSV export, persistent hint dismissal, and original period-end prompting. The new Today shortcut saves yesterday; a historical **last bleeding day** picker must continue saving its selected date. Show confirmation with Undo/Edit.

- **Medium · wording and release review.** “Not a medical app” and an opt-in disclaimer are not evidence of regulatory clearance. Current EU MDR/Play requirements were **not verified**, given the network prohibition. Require Claude’s current-source review before fertile-window implementation is locked. Suggested copy:
  - General: **“FreePeriod records what you enter and shows calendar estimates. It does not diagnose conditions or recommend treatment.”**
  - Fertility: retain the specified disclaimer and **“Possible fertile days (estimate)”**; never label other dates “safe.”
  - Pill rhythm: **“Scheduled break from active pills, based on your entries.”** “Pill-free” can misdescribe placebo days.
  - Reminders: **“Reminder from FreePeriod.”** Scheduling disclosure: **“Notifications may arrive later than the time you choose.”**
  - Life phase: **“Choose the view that suits your situation. You can change it anytime.”**

- **Medium · design feasibility.** Compose can implement this system, but the README establishes neither six palettes nor actual bundled-font fit. Test all text/background pairs at AA and essential outlines at ≥3:1, including overlapping calendar marks. Keep the pastel full stop decorative. Use visible border-width/shape changes plus selected semantics for chips. Give Canvas a localized date/segment description; use scalable text labels and stack the timeline below the numeral at large text sizes. Add TalkBack-accessible chart actions and non-drag period selection.

**Simplifications**

- **C1:** Keep typed built-in `DayLog` fields. Define built-in categories/items in code; persist only visibility/order overrides. Extend existing tag/link storage with category and icon references for custom items, rather than replacing all built-ins with database definitions. This removes duplicated identity, nullable built-in/custom columns, seeding requirements and competing selection stores. Use stable icon keys, never Android resource IDs.

- **Defaults:** Regular tracking gets the core Today view and a short symptom set with “More.” Sex, discharge, tags, notes and custom categories stay collapsed. TTC adds an optional fertility offer, never automatic activation. Pregnancy/postpartum prioritize “Log today” and hide prediction controls. Perimenopause retains tracking with relevant symptoms; menopause mode uses recorded-history summaries. All reminders remain off until enabled; phase changes preserve previous choices.

- **Rounds:** A1 depends on A2; A4 depends on C1’s domain contract; B consumes storage/settings planned only in C. Fonts are needed **before B**, not before C. Split sol work into model contract → engine rules → persistence/backup migration → reminders → entry → onboarding → History. Astra handles tokens early, Today after engine integration, then final visuals. Update exhaustive app consumers with new prediction states so each round compiles. Claude owns migrations on device, notification/DST checks, bundled-font rendering and inspection of changed screenshot references.

**Verified OK**

- Six 32-day plus six 28-day cycles: overall median **30**, MAD **2**, half-width **3**; latest-six centre offset **28**.
- April 23 centre → estimated ovulation April 9 → window **April 4–10**, seven inclusive days.
- January 1, 21+7: breaks **January 22–28** and **February 19–25**.
- February day-31 clamping: **28 in 2026**, **29 in 2028**. January 31 + three months → **April 30**.
- Yesterday clamped to period start correctly handles same-day ending.
- Draft History needs correction: November 20 → December 18 is **28**, not 14; January 16 → February 15 is **30**, not 27. Generate labels from one period fixture.

**Changed:** None; net 0 lines, nothing removed.  
**Checked:** Read-only source review and manual arithmetic; 0 tests run, no test exit code. `-Schnell` was not run because it writes build outputs.  
**Screenshot tests added/changed:** None. **Open points:** rule decisions and current regulatory/policy verification above.