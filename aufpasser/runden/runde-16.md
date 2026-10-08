**GREEN:** `tools\check.ps1 -Schnell`, exit **0**. All **103 engine tests pass**; app assembly and app-test compilation succeed. The four printed failures are cached Robolectric results.

**Changed:**

- `data/db/`, `AppContainer.kt`, `app/schemas/.../2.json`: Room v2 entities, migration, registration, and generated schema.
- `Repository.kt`, mapping files: v2 flows/writes, transactional batch insertion, snapshot/restore.
- `SettingsStore.kt`: idempotent reminder migration, legacy control bridge, delivery reset.
- `reminders/`: scheduling and delivery read Room rows.
- Engine backup validation: shared v2 validator replaces duplicated schema-1 validation.
- Data/reminder/settings tests: migration, rollback, v2 round trips, restore identities, hidden-item preservation, and accent-test correction.

**Net:** +1289 / −65 = **+1224 lines**, including 530 generated schema lines.

**Screenshot tests:** none.

**Open points:** Claude must run Robolectric to verify the four reported regressions and new storage tests. Decision 15 remains C4.

**Worth knowing:** CSV export still needs to pass `customCategories` from its UI call site, outside this round’s scope.