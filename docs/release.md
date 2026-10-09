# FreePeriod. – release checklist v1.0.0

Owner = Marvin (Play Console, keys, e-mail). Claude prepares everything else.

## Owner (one-time)
- [ ] Support/privacy e-mail (dedicated Gmail) → replace `CONTACT_EMAIL` in `site/` and `store/`.
- [ ] Developer name as shown on Play → replace `DEVELOPER_NAME`.
- [ ] GitHub repo (public at launch, GPL-3.0) → replace `OWNER` in links; enable GitHub Pages
      via Settings → Pages → Source "GitHub Actions" (workflow `pages.yml` publishes `/site`) → privacy URL `https://pavoras.github.io/freeperiod/privacy/`.
- [ ] Upload key: run `powershell -File tools\make-upload-key.ps1`, fill the two passwords in
      `%USERPROFILE%\dev-tools\keys\freeperiod-signing.properties`. Back the key up privately.
- [ ] Play Console: create app "FreePeriod." (default language EN-US, add DE), free, category
      Health & Fitness. Enrol in Play App Signing (default).

## Claude (after owner steps)
- [ ] Build: `gradle -Pfreeperiod.signing=<properties> :app:bundleRelease` → AAB; verify merged
      manifest (no INTERNET), size, versionCode 1 / versionName 1.0.0.
- [ ] Store listing EN/DE from `store/listing-*.md`; screenshots + feature graphic from `store/`.
- [ ] App content: privacy policy URL; Data safety per `store/data-safety.md`; Health apps
      declaration (menstrual cycle tracking); content rating questionnaire; target audience 13+;
      ads: none; news app: no; government app: no.
- [ ] Internal testing track → install on owner's phone via Play → smoke test (onboarding, log,
      backup/restore, reminder, lock).
- [ ] Closed testing with 5–8 people (check whether the org account requires a minimum) → fix round.
- [ ] Production, staged rollout 20 % → 100 %; tag `v1.0.0`; make repo public.

## Not in v1.0 (by decision)
Fertile window (regulatory, spec rev 2 §11) · Clue/Flo import (waiting for example files) ·
widget/tile/PDF/Health Connect/auto backup (v1.1) · supporter purchase (later).
