# FreePeriod. – release checklist v1.0.0

Status 2026-10-09: owner steps done, internal test positive, production release with versionCode 2
(versionCode 1 was used by the internal test upload).

Owner = Marvin (Play Console, keys, e-mail). Claude prepares everything else.

## Owner (one-time)
- [x] Support/privacy e-mail (dedicated Gmail) → replace `CONTACT_EMAIL` in `site/` and `store/`.
- [x] Developer name as shown on Play → replace `DEVELOPER_NAME`.
- [x] GitHub repo (public at launch, GPL-3.0) → replace `OWNER` in links; enable GitHub Pages
      via Settings → Pages → Source "GitHub Actions" (workflow `pages.yml` publishes `/site`) → privacy URL `https://pavoras.github.io/freeperiod/privacy/`.
- [x] Upload key: run `powershell -File tools\make-upload-key.ps1`, fill the two passwords in
      `%USERPROFILE%\dev-tools\keys\freeperiod-signing.properties`. Back the key up privately.
- [x] Play Console: create app "FreePeriod." (default language EN-US, add DE), free, category
      Health & Fitness. Enrol in Play App Signing (default).

## Claude (after owner steps)
- [x] Build: `gradle -Pfreeperiod.signing=<properties> :app:bundleRelease` → AAB; verify merged
      manifest (no INTERNET), size, versionCode 2 / versionName 1.0.0.
- [x] Store listing EN/DE from `store/listing-*.md`; screenshots + feature graphic from `store/`.
- [x] App content: privacy policy URL; Data safety per `store/data-safety.md`; Health apps
      declaration (menstrual cycle tracking); content rating questionnaire; target audience 13+;
      ads: none; news app: no; government app: no.
- [x] Internal testing track → install on owner's phone via Play → smoke test (onboarding, log,
      backup/restore, reminder, lock).
- [x] Testers (owner) – organisation account, no 12-tester/14-day rule.
- [ ] Production 100 % (first release, no existing users); after approval: Play badge + link on the site
      (`PLAY_STORE_URL`), tag `v1.0.0`. Repo is already public.
- Every new upload needs a higher versionCode.

## Not in v1.0 (by decision)
Fertile window (regulatory, spec rev 2 §11) · Clue/Flo import (waiting for example files) ·
widget/tile/PDF/Health Connect/auto backup (v1.1) · supporter purchase (later).
