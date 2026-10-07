## Verdict

**Fix the contracts below before implementation; the architecture and v1.0 scope are sound.**  
No v1.1+ features crept in. All explicit Task 1–2 numerical expectations are correct; coverage and executability need corrections.

## Must-fix

1. **Tasks 1, 5, 7: outlier inclusion is impossible.**  
   Clearing `excludeCycle` cannot override the mandatory 15–90-day filter, contradicting spec §5. **Correction:** replace the Boolean with `AUTO / INCLUDE / EXCLUDE`, propagate through Room/backup/CSV, and test explicitly including 14- and 91-day cycles. This resolves a contradiction already present in the spec.

2. **Tasks 1, 5, 8, 12: historical period creation is blocked; onboarding fabricates dates.**  
   `startPeriod(pastDate)` creates an ongoing period overlapping every later period, so valid historical insertion cannot succeed. `endPeriod(start+4)` invents an observed duration and can produce a future end. **Correction:** add atomic creation with optional explicit end, expose boundary editing, and ask for the actual end during onboarding. Define inclusive boundaries, at most one ongoing period, and ongoing validation through infinity. Remove the unexplained 21–45 onboarding restriction or obtain an explicit product decision.

3. **Tasks 3, 10: reminder deduplication is wrong.**  
   The first `today == earliest-daysBefore` branch bypasses `lastNotifiedFor`; using `earliest` as identity also permits repeats after prediction edits. **Correction:** require “inside reminder window **and** cycle not notified,” keyed by stable period ID. Default reminders off to match onboarding opt-in. Pause only period reminders, preserving daily logging. Declare/request `POST_NOTIFICATIONS`, check channel/system permission before marking notification delivered, and reschedule against local time after timezone/DST changes. A repeating 24-hour interval does not preserve a chosen wall-clock time.

4. **Tasks 3, 5, 9: restore has no atomic contract.**  
   `Repository(db, clock).snapshot()` cannot supply `BackupSettings`; Room replacement followed by DataStore update is not one transaction. **Correction:** store the two backed-up domain settings in Room alongside restored records; retain device preferences in DataStore. Validate schema version, duplicate IDs/dates/tag names, references, enum/date/settings values and period rules before presenting confirmation. Pass validation date explicitly; coordinate restore with autosaves/workers.

5. **Task 3: crypto parsing permits resource exhaustion.**  
   Iterations have no upper bound; malformed input can force enormous PBKDF2 work before authentication. **Correction:** define accepted iteration bounds, input/decrypted-size limits and bounded header parsing; authenticate before JSON parsing. Generate fresh salt/nonce per export and authenticate the exact serialized header. Keep production encoding at ≥600,000 iterations; isolate reduced-cost tests. Run both encoding and decoding off-main-thread. PBKDF2-HMAC-SHA256 availability/provider interoperability on API 26+, Unicode passwords and low-end-phone duration: **verify** on device; no timing assertions.

6. **Tasks 0, 4–6, 8–9: v1 requirements lack implementable coverage.**  
   Missing explicit work: per-app language, inline tag renaming, secondary “Log today,” month swiping/day-entry wiring and guaranteed migration tests. **Correction:** assign these acceptance criteria; add `renameTag`; define locale persistence/configuration and the API 26–32 fallback. Resolve `Flow` domain-enum versus coroutine `Flow` imports explicitly. Replace exclusive `DayMarker` values with independent flags so predicted+logged and today combinations render correctly.

7. **Tasks 1–2, 6–8: deterministic semantics are incomplete.**  
   Period-length median returns `Int` without rounding rules; “last three cycles” boundaries are unspecified; “Monday-first (locale first-day-of-week)” conflicts. Some prediction fixtures omit `today`, so they can unexpectedly produce `RangePassed`. **Correction:** specify half-up period-length rounding, completed-cycle counting windows, locale-derived week starts, injected clocks/locales/zones, and fixed fixture dates. Inject a clock into day-entry validation too. Test even medians/MAD, width 7 versus 8, ongoing periods and midnight while foregrounded.

8. **Task 5: relational and concurrent-write guarantees are missing.**  
   `DayTag` references tags but not its owning day; validation outside a transaction can admit overlapping concurrent writes. **Correction:** add a cascading day FK and required indices; transact validation plus period mutation and day-log/tag replacement. Serialize autosaves so rapid taps or date navigation cannot overwrite newer state. Clear-day undo must restore tag links.

9. **Task 0: backup configuration is not specified sufficiently.**  
   “Cloud excluded, device transfer included” requires API-specific behavior; blanket `allowBackup=false` is not an adequate implementation. **Correction:** write explicit API 31+ cloud/device-transfer rules and legacy rules. API 28–30 transfer flags and the API 26–27 limitation are **verify** items; use a privacy-preserving fallback and document any D2D exception. Explain that SAF cloud providers can upload selected exports despite this app lacking INTERNET.

10. **Task 0: one skeleton build does not establish offline readiness.**  
    Later tests, release shrinking, locale support and bundled icons introduce additional artifacts. **Correction:** preload all runtime/test/plugin dependencies, SDK components, Robolectric images and assets; exercise representative tests and release shrinking before an offline gate. Make the INTERNET check fail when its manifest path matches nothing, and inspect the packaged release permissions plus dependency manifest origins. Whether selected Compose/WorkManager/biometric/Room artifacts contribute permissions: **verify** from resolved artifacts.

## Should-fix

- **Task 11:** select a BiometricPrompt-compatible activity; **verify** the pinned biometric implementation across API 26–30. Require device screen-lock security separately from transient biometric availability. Use monotonic timeout measurement; test credential fallback, cancellation, process recreation and SAF/background transitions. **Verify** FLAG_SECURE effects on recents, screenshots and casting.
- **Tasks 3/9:** explicitly include forgotten-password warning, consistent backup snapshots, cancelled/partial SAF writes and CSV tag escaping. RFC 4180 does not resolve ambiguity inside semicolon-joined tag names.
- **Tasks 13–14:** retain dependency/license audit; **verify** current Play health declarations, Data safety treatment of user-directed exports/support, target API and audience age bands. “16+” alone is not a complete audience decision. Add the spec’s WIPO check.
- **Quality gates:** compare screenshots against reviewed references; do not overwrite baselines at every exit. Exercise API 26 and 36 behavior, DE large text, future ends and database migration policy.

## Simplifications

- Split Tasks 9–12 into recovery/export and reminders/lock/onboarding rounds; the current settings round combines too many independent failure surfaces.
- Keep JCA crypto in `:engine` for ordinary JVM tests; document this small deviation from the spec’s module boundary.
- Preserve two modules/manual DI. Remove the unconditional five-day onboarding completion instead of adding recovery logic around it.

## Verified OK

- **Task 1:** overlaps and self-ID exclusion expectations are correct; January 1→29 = 28 days, January 29→February 28 = 30. Eligibility boundaries 14/15/90/91 are correct. March 12 is cycle day 12. Median `[4,5,7]` and empty fallback are 5. With inclusive duration, March 8 is day 8: no question; March 9 is day 9: suggest March 5.
- **Task 2:** March 1 +30 = March 31, ±3 = March 28–April 3. February 1→March 3 =30; +30 = April 2, ±2 = March 31–April 4. `[27,33]` gives 30±3. Regular history gives April 23±1. `[26,30,35,28]`: median29, MAD2, width3. `[25,45,30,60]`: median37.5, MAD10, width15, hence `Varies`. Exclusion leaves three cycles; last-12 selection gives width1. April 27 is three days past April 24, cycle day33. Predicted days end April 28.
- **Crypto structure:** AES-256-GCM, 12-byte nonce, 128-bit tag, 16-byte salt and authenticated 37-byte header are coherent.
- **Changed:** none. **Verified:** documents/local configuration and hand arithmetic; no network or runtime tests.