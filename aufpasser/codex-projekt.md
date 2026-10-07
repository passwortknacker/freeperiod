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
- Resume: `--add-dir` is NOT inherited. Pass the Gradle cache explicitly:
  `codex exec resume <thread> -m <model> -c model_reasoning_effort=high -c sandbox_mode=workspace-write -c approval_policy=never -c 'sandbox_workspace_write.writable_roots=["C:\\Users\\kempe\\dev-tools\\gradle-home"]' --json -o … -`

## Round log
| Round | Model/effort | Thread | Result |
|---|---|---|---|
| 1 | gpt-6-astra/high, read-only | 01a11748-43fb-7d42-91e4-7c5864544b74 | Critical review of brief → spec v1 (fertility opt-in v1.1, explicit periods, scope split, one-time supporter) |
| 2 | gpt-6-astra/high, read-only | 01a1175b-18da-7b31-ab82-83a714771403 | Plan review: 10 must-fix (CycleUse, addPeriod, reminder keyed by period, restore atomic incl. domain settings in Room, crypto bounds, coverage, rounding, DB FKs/mutex, backup rules, offline readiness) → plan amended |
| 3 | gpt-6.1-sol/high | 01a1176e-8211-79a2-b7f9-496cc769cad6 | Engine Tasks 1–3: 69 tests green, +1041 lines; reviewed Prediction + BackupCodec OK; commit 552d287 |
| 4 | gpt-6.1-sol/high | 01a11785-e4e0-7950-bcac-280ebc04dac8 | Core Tasks 4–6: 103 tests, 12 Today screenshots OK; full gate green; commit 8e58f58 |
| 5 | resume of 4 | 01a11785-… | History + Day entry (Tasks 7–8): 136 tests, screenshots OK; resume lost gradle-home write access (Codex used local cache); commit 95d3c17 |
| 6 | gpt-6.1-sol/high fresh | 01a117c2-4b22-7b11-85e1-a26f717328bf | Recovery Task 9: 162 tests; MoodIconTest removed (Robolectric capture timeout); commit cef96fa |
| 7 | gpt-6-astra/high read-only | – | 3 design directions (Full Stop / Dayline / Soft Forms) |
| 8 | resume of 6 | 01a117c2-… | Device Tasks 10–12: 198 tests; commit dcd96dd |
| 9 | gpt-6-astra/high | 01a11813-0a4c-7020-8b81-854675f0a080 | 3 design drafts as HTML boards (draft 1 = owner notes: soft, grounded sans, timeline/ruler, calm, subtle) |

| 10–11 | astra resume of 9 | 01a11813-… | Combined draft 4 → refined draft 5 (final design reference) |
| 12 | gpt-6-astra/high read-only | 01a1189b-8ee2-7d40-916d-6938f4702311 | Review spec rev 2 + plan part 2 → 14 binding decisions |
| 13 | gpt-6.1-sol/high | 01a118a0-a60d-7e90-83bb-a61633d096de | Round A engine v2 (parallel to 14) |
| 14 | gpt-6-astra/high | 01a118a0-e435-70d1-bd90-18c211b2f96e | Round B1 design system (all screens except Today) |

Device: Marvin's S22 Ultra via Wi-Fi debugging (`adb connect 192.168.178.21:<port>`; port changes, pairing already done for this laptop).

Start rounds with `aufpasser\runden\start.ps1 -N <n> [-Model m] [-Resume id] [-ReadOnly]`.
HTML mockups → PNG: headless Edge (`msedge --headless=new --screenshot=… --window-size=…`) from a temp dir without spaces.

## Toolchain notes
- Gradle 8.11.1 at `C:\Users\kempe\dev-tools\gradle-8.11.1` (copied from JaySay), JDK 17, SDK 36, shared
  `dev-tools\gradle-home` cache (filled online by Claude via `tools\check.ps1 -Voll -Online`).
- WorkManager's ACCESS_NETWORK_STATE/FOREGROUND_SERVICE + SystemForegroundService removed in manifest.
