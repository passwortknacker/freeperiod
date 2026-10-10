# FreePeriod. 1.1 – scope and decisions

Date: 2026-10-10 (owner decisions in chat after the 1.0.0 submission). Builds on spec rev 2
(`2026-10-08-freeperiod-v1-scope-2.md`); where they differ, this file wins for 1.1.

## 1. Ground rule: a diary, not a medical device or service

FreePeriod. stores what the user enters and shows it back. It never evaluates, recommends,
warns or interprets. This applies to every text, icon, screen, store listing and website line.

- **No medication advice.** The app ships **no medicine names**, no doses, no dose limits, no
  interaction or overuse warnings, no "time for your next dose" logic. Users type in what they
  take; we only count what they logged.
- **No disease names as app modes.** No setting, item set, screen or store text is named after a
  disease or condition (no "endometriosis mode", "PCOS mode"). Life phases (pregnancy,
  postpartum, menopause) are life phases, not diseases, and stay.
- **Banned wording** (EN/DE, app + store + site): treatment/Behandlung, therapy/Therapie,
  manage your condition, monitor your health/symptoms for a condition, diagnosis, dose
  recommendation, "helps with", "relieves", any brand or active-ingredient name.
- **Allowed wording:** log, note, diary, track what you take, summary of your entries.
- Every report or export that leaves the app carries the "not a medical device" note.

## 2. In scope for 1.1

### 2.1 Copper methods (done 2026-10-10)
`Method.COPPER_CHAIN` (Kupferkette, frameless IUD) and `Method.COPPER_BALL` (Kupferball, IUB).
Same behaviour as `IUD_COPPER`: non-hormonal (higher-chance days allowed), one-time reminder preset.

### 2.2 Customize everything
Owner wish: nothing is set in stone. Two stages, both in 1.1.

**Stage A – change what exists:** for every built-in category and item: rename, change icon,
hide, reorder items inside a category (categories can already be reordered/hidden). A renamed
built-in item shows the user's name in every language; "reset to default" brings back the
translated label.

**Stage B – add own items** to mood, pain, symptoms, sex, discharge and custom categories; own
items can be deleted (archived if used in past entries, like tags). Built-in items can only be
hidden, never deleted, so old entries keep their meaning. Custom categories get a type:
multi-select (today) or single choice.

**Flow is Stage A only** (rename/hide, no own levels): flow from LIGHT upwards offers a period
start (`PeriodRules`), so extra levels would change period logic.

**Data approach (keeps old data valid):** built-in items keep their enum names as permanent keys
("GREAT", "CRAMPS"); own items get `custom:<id>` keys. DayLog single-choice fields become option
keys, sets become key sets; flow stays `FlowLevel`. Existing rows, backups (schema 1/2) and CSV
files need no conversion of values. Room 2→3 migration, backup schema 3 (readers for 1/2 kept),
CSV keeps built-in keys and writes own items by name (import matches by name, creates missing).
1.0 cannot read 1.1 backups (acceptable). Custom symptoms are today tags in the
`builtin:symptoms` category – the design round decides whether to keep or fold them into options.
Scales (mood, pain) use the user's order wherever an order matters.

### 2.3 Medication log
- A category type for anything the user takes; available to everyone, **off by default**.
- The user adds their own entries (name, optionally with strength, e.g. "Ibuprofen 400 mg" –
  typed by the user, never suggested). Per day: tap to log, +/− for how many times.
- Label "Medication"/"Medikamente"; hint: "Log what you took. FreePeriod. gives no advice on
  medication." / "Notiere, was du genommen hast. FreePeriod. gibt keine Hinweise zu Medikamenten."
- No preset list, no reminders offered from this category (general reminders exist).
- Hormone therapy in menopause is logged here; no separate HRT feature.

### 2.4 Pain diary item set (instead of an "endometriosis" setting)
Under Customize day entry: "Add an item set → Pain diary". Turns on, once: Pain, Medication, and
creates editable categories "Where it hurts" (lower belly, back, legs, pelvis, head …), "Pain
during" (sex, bowel movements, peeing), "Daily life" (missed work/school, cancelled plans, rested
in bed). Everything stays renamable/hideable; removing the set asks whether to hide its items too;
entries are never deleted. No disease name anywhere. Open: 0–10 pain scale as a set option.

### 2.5 Menopause additions
- New built-in symptom items for peri-/menopause (shown automatically in those phases, hideable):
  vaginal dryness, mood swings, heart racing, low sex drive (exact list/wording in the round).
- Static sentence in the menopause phase description: bleeding after a year without periods is
  worth mentioning to a doctor. Never triggered by the user's entries.
- Symptom trends by month in History (spec rev 2 already plans a monthly view for menopause).

### 2.6 PDF summary
"Summary of your entries" for a chosen range (3/6/12 months or custom): periods and cycle
lengths, a day grid with flow, pain, medication counts and symptoms, optional notes (off by
default). Android `PdfDocument`, saved via the system file picker / share sheet (no INTERNET).
No scores, no flags, no interpretation; "not a medical device" note on every page.

### 2.7 Automatic backup
Encrypted with the user's backup password into a folder the user picks (persistable SAF tree);
daily or weekly via WorkManager; keeps the last 5 files; shows the last successful backup and a
quiet notice when it fails. The password is stored encrypted with an Android Keystore key. If a
cloud app syncs that folder, backups leave the phone without FreePeriod. getting INTERNET.

## 3. Not in 1.1
Home-screen widget (→ 1.2; must respect the app lock), Health Connect, Clue/Flo import (needs
example files), F-Droid, more languages, supporter purchase.

## 4. Release and work split
- versionCode 3, versionName 1.1.0. Update store texts (neutral "log what you take", no disease
  names) and check whether the Play health-apps declaration needs medication added; data safety
  stays "no data collected". Automatic backup is an on-device backup, not a cloud backup: the app
  writes an encrypted file to a folder the user chose (which may belong to a Drive or Nextcloud
  app; uploading is then that app's doing, as with manual backups today). Only reword
  `store/data-safety.md` and the privacy pages so they describe this optional scheduled local
  backup accurately; no new Play answers expected.
- Stage A+B data model → Codex round after the quota reset (Wed 2026-10-14), plan by Claude first.
  Medication, pain diary and menopause build on it. Automatic backup and PDF → Claude, can start
  before.
