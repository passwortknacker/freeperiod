# FreePeriod. – rules for Codex

Android app (Kotlin, Compose) + pure-Kotlin `:engine`. Supervisor: Claude ("Aufpasser") sets
rounds and verifies outside your sandbox. Source of truth: spec
`docs/superpowers/specs/2026-10-07-freeperiod-design.md` and plan
`docs/superpowers/plans/2026-10-07-freeperiod-v1.md` (its "Decisions from plan review" section
overrides older wording).

## Never
- No `git commit/push/tag/checkout/reset/stash`, no branch changes. Only change the working tree.
- Never read or print `%USERPROFILE%\dev-tools\keys`, signing properties, `~/.codex/auth.json`,
  `.env`, tokens. No secrets in code, docs, logs or tests.
- No network access or downloads. No new dependencies or version bumps in
  `gradle/libs.versions.toml` unless the round asks for it (the offline cache only has what is
  pinned there).
- Never add the `INTERNET` permission or any network, analytics, ads or crash-reporting library.
- Do not record Roborazzi references and do not edit files under `app/src/test/screenshots/`.
- Do not edit `docs/superpowers/**`, `aufpasser/**`, `AGENTS.md` (Claude maintains them).
- No user health data in logs (no `Log.d` of dates, notes, symptoms).

## Checks
- Only via `powershell -NoProfile -ExecutionPolicy Bypass -File tools\check.ps1 -Schnell`
  (engine tests + app compile, offline). Wait for it; read `.tools/check-schnell.log` only on
  failure.
- Robolectric/Roborazzi tests do not run in your sandbox: write them carefully (`@Config(sdk =
  [35])` only, `@GraphicsMode(NATIVE)` for screenshots, `composeRule.waitForIdle()` before
  asserting). Claude runs them. Simulate older APIs via `@Config(sdk = [35])` +
  `ReflectionHelpers.setStaticField(Build.VERSION::class.java, "SDK_INT", …)` where needed.
- Newer platform APIs only inside `if (Build.VERSION.SDK_INT >= …) { … }` blocks (lint NewApi).
- TDD: write the failing test first; for bugs a red test before the fix.

## Code rules
- Dates are `java.time.LocalDate`, stored as epoch day; inject `clock: () -> LocalDate` instead of
  calling `LocalDate.now()` in logic. Enums persisted by `name`, never ordinal.
- All user-visible text in `res/values/strings.xml` (EN) **and** `res/values-de/strings.xml`
  (DE), consistent, short, warm, neutral "you"/"du", no gendered wording, no "late", no
  contraception/conception claims.
- Manual DI via `AppContainer`; no Hilt/Koin. Keep files focused (one responsibility each).
- Simplicity (owner rule): find the cause, prefer removing or streamlining over adding layers,
  special cases or retries. Report net lines changed and what you removed.

## Answer at the end of every round (short, English)
Changed (files, one line each) · Checked (command, test counts, exit code) · Screenshot tests
added/changed (names, for Claude to record) · Open points / deviations from the plan.
