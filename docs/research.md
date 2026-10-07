# Market research – free offline period tracker (2026-10-07)

## Mainstream (big reach, but ads / paywall / data)
- **Flo** – 100M+ installs, 4.7★. 1-star themes: data sharing (FTC settlement 2021) ~28 %,
  prediction accuracy ~19 %, aggressive paywall ~16 %, data loss on phone switch.
- **Clue** – Berlin, GDPR-positioned, freemium (Clue Plus).
- **Period Calendar (Simple Design)** – 100M+ installs, 4.89★, ads + premium. Proves "simple
  calendar" beats feature richness for the mass market.
- **Period Tracker (SimpleInnovation)** – 32M installs, ads.

## Privacy / offline niche (already exists, mostly hobby/FOSS, low reach)
- **drip** (Bloody Health, GPL-3) – local only, sympto-thermal method, password, import/export.
  Gender-neutral look; F-Droid + stores.
- **Mensinator** (MIT, Kotlin) – minimal: mark periods, averages, next prediction.
- **Mooneva** (GPL-3) – no INTERNET permission, PIN lock, disguised icon, PMS window,
  clinical report export. F-Droid.
- **Bluma** – offline, encrypted, open source, Android.
- **Euki** – Mozilla 10/10 privacy score, local only.
- **Periodical** – old F-Droid app, Knaus-Ogino.

## Takeaways
- "Offline + free + private" alone is NOT unique. The gap is **polish + reach**: FOSS apps look
  utilitarian and live on F-Droid; polished apps monetize with ads/subscriptions/data.
- Differentiator to aim for: Daylio-level delight and speed of logging, honest predictions,
  zero-friction switching (import), verifiable trust (no INTERNET permission), Play Store ASO.

## Platform / policy facts
- Play: Health apps declaration mandatory for Health & Fitness apps (menstrual tracking is a
  listed feature); privacy policy link required in Console AND inside the app.
- Health Connect (API 34+ / Jetpack) has MenstruationPeriodRecord, MenstruationFlowRecord,
  IntermenstrualBleedingRecord – optional on-device sync, needs extra Play permission declaration.
- Running cost can be ~0: no backend, no analytics SDK; Play Console vitals for crashes.

## Sources
- https://f-droid.org/en/packages/com.mooneva.app/
- https://f-droid.org/packages/com.drip/
- https://f-droid.org/packages/com.mensinator.app
- https://www.producthunt.com/p/bluma
- https://tuta.com/blog/best-period-apps
- https://unstar.app/blog/is-flo-legit-safe-period-tracker-app-reviews-2026
- https://www.appbrain.com/app/com.popularapp.periodcalendar
- https://support.google.com/googleplay/android-developer/answer/14738291
- https://developer.android.com/reference/kotlin/android/health/connect/datatypes/MenstruationFlowRecord
