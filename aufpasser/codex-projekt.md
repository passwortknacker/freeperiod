# Codex in FreePeriod. – project addendum to skill `codex-delegation`

Same conventions as JaySay (`Diktier App/aufpasser/codex-projekt.md`) unless stated here.
Fixed rules for Codex live in `AGENTS.md` (created in M0; do not repeat them in prompts).

## Roles
- Claude = supervisor ("Aufpasser"), owner = Marvin. Short answers to Marvin.
- Claude weekly quota is scarce → implementation goes to Codex; Claude plans, reviews, verifies,
  commits.

## Models
- Coding: `gpt-6.1-sol`, effort `high`; `xhigh` only after asking Marvin.
- Design/judgement/review/images: `gpt-6-astra`.
- Never: `gpt-6-luna`, `gpt-6-sol` (6.0), `ultra`, effort below `high`.

## Paths and commands
- Repo: `C:\Users\kempe\Desktop\Projekte\Period Tracker`. Rounds: `aufpasser/runden/prompt-N.txt`,
  `runde-N.md|.jsonl|.log` (jsonl/log git-ignored).
- Start (fresh, detached), from repo root:
  `Start-Process powershell -ArgumentList '-NoProfile','-ExecutionPolicy','Bypass','-Command',"Set-Location '<repo>'; Get-Content -Raw -Encoding utf8 aufpasser\runden\prompt-N.txt | codex exec -m <model> -c model_reasoning_effort=high --json -C '<repo>' -s workspace-write -c approval_policy=never -o aufpasser\runden\runde-N.md - > aufpasser\runden\runde-N.jsonl 2> aufpasser\runden\runde-N.log" -WindowStyle Hidden`
- Review-only rounds: `-s read-only`.

## Round log
| Round | Model/effort | Thread | Result |
|---|---|---|---|
| 1 | gpt-6-astra/high, read-only | 01a11748-43fb-7d42-91e4-7c5864544b74 | Critical review of brief → spec v1 (fertility opt-in v1.1, explicit periods, scope split, one-time supporter) |
| 2 | gpt-6-astra/high, read-only | 01a1175b-18da-7b31-ab82-83a714771403 | Plan review: 10 must-fix (CycleUse, addPeriod, reminder keyed by period, restore atomic incl. domain settings in Room, crypto bounds, coverage, rounding, DB FKs/mutex, backup rules, offline readiness) → plan amended |
| 3 | gpt-6.1-sol/high | (running) | Engine: Tasks 1–3 |

## Toolchain notes
- Gradle 8.11.1 at `C:\Users\kempe\dev-tools\gradle-8.11.1` (copied from JaySay), JDK 17, SDK 36, shared
  `dev-tools\gradle-home` cache (filled online by Claude via `tools\check.ps1 -Voll -Online`).
- WorkManager's ACCESS_NETWORK_STATE/FOREGROUND_SERVICE + SystemForegroundService removed in manifest.
