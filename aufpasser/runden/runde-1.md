## Verdict

**Proceed with a narrower v1.0; the current brief is not ready for implementation.**  
The strongest proposition is fast, private tracking with honest estimates and dependable recovery; differentiation remains unproven.  
Remove default fertility predictions and resolve period semantics before specifying screens. Policy, legal, and competitor details below marked **verify** require external confirmation.

## Findings

Sorted by severity. “Blocker” means resolve before approving the spec or committing to release.

1. **Blocker · Fertility display creates avoidable safety and regulatory exposure.**  
   “Next period minus 14 days” cannot establish ovulation or reliably bound fertile days. A soft band can still imply that other days are safe. “Not contraception” does not determine regulatory status. **Recommendation:** remove fertility/ovulation from v1.0. Before reconsidering, obtain an EU MDR intended-purpose assessment covering functionality, screenshots, and marketing; claims supporting conception also need scrutiny (**verify**). Do not imply contraceptive reliability.

2. **Blocker · Derived periods conflict with start/end logging.**  
   Example: start Monday, end Friday, no intervening entries. These buttons cannot encode a five-day period using flow observations alone without fabricating observations. Automatically merging one-day gaps also confuses missing entries with confirmed non-bleeding. **Recommendation:** persist explicit period boundaries alongside optional daily observations. Distinguish unknown, no bleeding, spotting, and menstrual flow. Infer suggested periods from logs, but allow corrections; exclude unfinished periods from duration statistics.

3. **High · Differentiation is asserted, not demonstrated.**  
   Against Flo/Clue/Period Calendar, privacy and freedom from ads/paywalls appeal, but users surrender established history and familiar workflows. Against drip/Mooneva/Mensinator, the proposed features substantially overlap. The research’s review percentages lack a documented sample; install counts do not prove calendar simplicity caused success. “Private apps are utilitarian” needs validation. **Recommendation:** compare current versions (**verify**), then test with 5–8 target users. Measure logging speed, migration success, and prediction comprehension. “Logged in seconds; history survives a phone change” is a stronger recommendation trigger than another feature checklist.

4. **High · v1.0 contains too many independent reliability surfaces.**  
   Widgets, tiles, pill scheduling, PDF generation, several importers, custom tags, and two lock mechanisms multiply testing and maintenance. Codex accelerates implementation, not product validation or device coverage. **Recommendation:** cut these to later releases, retaining encrypted recovery and a narrow logging experience. Promise only one importer after proving its format.

5. **High · Predictions hide uncertainty and exclude relevant users.**  
   Discarding cycles over 90 days conceals potentially real history; clipping variability to seven days manufactures precision. An unasked 28-day default looks personalized. Missing logs can resemble long cycles. **Recommendation:** use a median of recent, explicitly eligible completed cycles; retain all observations and explain exclusions. After at least three confirmed cycles, show a historical spread labelled as such, not a calibrated confidence interval. Before that, show insufficient history or a clearly user-supplied estimate. Suppress misleading forecasts when variability is large. Provide optional tracking-only/pause modes for hormonal contraception, pregnancy/postpartum, and changing patterns. PCOS, teens, and perimenopause need uncertainty handling, not a universal “irregular” threshold or diagnosis. Say “expected range passed,” not medically definitive “late.”

6. **High · Recovery promises exceed what Android configuration alone guarantees.**  
   Cloud backup, device transfer, and SAF export are separate mechanisms. A Drive-backed SAF provider can upload files despite this app lacking `INTERNET`; scheduled access can fail. Android/OEM transfer behavior and backup-rule versions need device verification (**verify**). **Recommendation:** make manual encrypted export/restore the recovery baseline; defer scheduled backups. Use a versioned authenticated format, vetted cryptography, explicit KDF parameters, and atomic restore validation. Explain password loss. Separately configure legacy and newer backup rules, then test D2D transfer, including how device-bound lock credentials are reset.

7. **High · App lock is not database encryption.**  
   File-based encryption is a reasonable v1 baseline for ordinary device loss; an app lock does not independently encrypt Room data. Widgets, notifications, recents, screenshots, exports, and imported content can expose sensitive information. **Recommendation:** document the threat model, use biometric/device-credential authentication, and defer a custom PIN implementation. Default notifications to neutral text; obscure recents and sensitive secondary surfaces. Disguised icons do not hide Settings/store history. Revisit SQLCipher only if the chosen threat model requires stronger at-rest protection.

8. **High · Release compliance needs explicit ownership.**  
   **Verify:** Health apps declaration, applicable medical disclaimer, Data safety, public privacy-policy requirements, target API deadlines, and organisation verification. “No data collected/shared” must follow the actual SDK/build audit, not the offline slogan. Separate local processing, user-directed exports, Play diagnostics, and support contacts. GDPR does not automatically disappear: operator access to support messages or diagnostic attachments creates separate obligations (**verify**). Avoid collecting health histories through support. Clarify teen audience, content rating, and relevant Play audience policies (**verify**).

9. **High · Monetization conflicts with the promise and may change privacy claims.**  
   “No subscription” contradicts a monthly Supporter subscription. Billing’s exact manifest permissions are **verify** against the selected Billing AAR and merged release manifest; this review cannot establish whether that version adds or requires `INTERNET`. Play-mediated purchases also involve network communication outside this app’s process. **Recommendation:** defer Billing; prefer a one-time supporter purchase later. Test purchase, restore, offline entitlement, and permissions before promising compatibility with a permission-free build. Digital cosmetics generally require Play Billing, subject to current regional/program exceptions (**verify**). Keep a separate FOSS build without Billing.

10. **High · The name introduces avoidable launch uncertainty.**  
    The proposed title fits the stated 30-character limit, but “Free” may trigger promotional-metadata scrutiny despite being branding (**verify**). The name is descriptive, hard to distinguish in search, and the punctuation adds little spoken identity. **Recommendation:** retain “Period Tracker” as the searchable descriptor; clear both candidate names through Play search, domains, DPMA/EUIPO/WIPO and appropriate trademark advice (**verify**). “Plain Period” is not automatically cleared. Decide before artwork and package publication.

11. **Medium · Architecture is sensible; persistence and interoperability need tightening.**  
    Two modules are sufficient. Keep `:engine` Android-free; avoid extra modules until boundaries justify them. **Recommendation:** use stable IDs, explicit local dates, provenance, versioned backup schemas, and migration tests. Define timezone/travel semantics; do not let stored dates shift with timezone changes. Avoid a universal future-event framework. Health Connect later needs record identity, deduplication, permissions, and deletion semantics. The research’s API-34-only shorthand overlooks older-device availability through the separate app (**verify**).

12. **Medium · Import and UX promises need evidence.**  
    “CSV” is not a competitor format. drip CSV and Clue account-data/JSON exports are candidates, not validated contracts (**verify** current availability, fields, and versions); Flo and Period Calendar portability remains unproven. **Recommendation:** obtain consented/anonymized fixtures, show import previews, and make duplicates/conflicts explicit. For UX, prioritize a stable “Log today” action, contextual start/end shortcuts, undo, and backdating. Keep onboarding skippable. Use a warm default accent with optional dynamic color; test contrast, non-color calendar markers, TalkBack, large fonts, and German text expansion.

## Optimized plan

**Audience:** people wanting simple menstrual history and approximate period timing, without accounts, ads, or fertility guidance.

- **v1.0:** Kotlin/Compose; DE/EN; calendar and explicit periods; flow, pain, a small symptom set, notes; transparent period estimates; basic history; device-credential lock; encrypted export/restore; neutral optional period reminder; GPL-3.0 source.
- **Conditional v1.0:** one validated importer, if essential to the chosen switching audience.
- **v1.1:** widget, additional proven importers, custom tags, accessible clinician-oriented export.
- **v1.2:** Health Connect, evaluated automatic backups, optional one-time supporter cosmetics.
- **Defer without commitment:** fertility predictions, pill reminders, tile, disguised icons, subscription.

Keep zero-backend architecture, but budget ongoing dependency updates, support, translation review, and Play compliance.

## Milestones

Estimates are focused developer-days, including Codex supervision; exclude external legal work and store waiting time.

| Milestone | Deliverable / exit gate | Effort |
|---|---|---:|
| M0 | Audience interviews, competitor/export verification, name and intended-purpose decisions | 3–5 days |
| M1 | Approved spec, period semantics, threat model, prediction examples, recovery design | 3–5 |
| M2 | Complete logging/calendar/history vertical slice; engine and migration tests | 8–12 |
| M3 | Prediction, lock, encrypted recovery, reminder; physical-device checks | 7–10 |
| M4 | Import if validated; DE/EN accessibility and usability testing | 5–8 |
| M5 | Internal then closed beta; restore/upgrade matrix, policy forms, listing screenshots | 5–8 |
| M6 | Signed release, staged Play rollout, source publication, support process | 2–4 |

**Approximately 7–11 focused weeks**, with additional beta/review calendar time. Organisation accounts generally do not face the newer-personal-account 12-testers/14-days gate; **verify** this account’s Console requirements. Still run a meaningful beta. Pursue IzzyOnDroid/F-Droid afterward; verify eligibility, build reproducibility, dependencies, and signing compatibility before promising cross-store updates.

## Open questions for the owner

1. Accept removing fertility predictions from v1.0?
2. Which users and existing tracker define the first migration target?
3. Is “no subscription” permanent, or only “no paid tracking features”?
4. Is protection on an already-unlocked/shared device a core requirement?
5. Accept renaming if metadata or trademark checks raise concerns?

**Changed:** No files.  
**Verified:** Read both supplied documents; no network checks or runtime tests, as this is a planning review.