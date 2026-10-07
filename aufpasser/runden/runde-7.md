**Recommend “Full Stop”: warm editorial typography, coral punctuation, and a compact chronological cycle visual.** It makes the name itself the identity, preserves the existing coral direction, and gives FreePeriod. character without decorative clutter.

The screenshots suggest three priorities: reduce Today’s oversized card, separate the nearly touching prediction rings, and replace Day entry’s uniform wall of chips with clearer hierarchy.

**Shared rules for all three directions**

- Preserve prediction ranges, basis labels, contextual actions, and all engine states. Never imply a fixed cycle, biological phases, or percentage “complete”.
- Calendar grammar stays consistent: filled circle = recorded period; dashed circle = predicted; outer solid ring = today; dot below = daily entry. Each flag remains independently visible, with a text legend and combined TalkBack description.
- Use 48 dp minimum touch targets, wrapping labels, and content-driven heights. At large font sizes, stack layouts and allow scrolling above navigation. Never shrink text to fit.
- Palette values below are proposed tokens, not verified contrast results. Require AA text contrast and 3:1 essential graphical contrast before acceptance. Supporting colours decorate category headings and illustrations, never communicate health status alone.
- Bundle the proposed OFL font families, required weights, and licence files. Use original vectors for illustrations. No downloadable fonts, chart library, Lottie, or new runtime dependencies.
- Honour disabled system animations and haptics. No idle animation, streaks, confetti, or sounds. Wallpaper colours may change interface accents; period/prediction tokens retain their meaning and contrast.

**1. Full Stop**

*A small personal journal with the confidence of good editorial design.*

**Signature:** a precisely placed full stop beside generous numerals and short horizontal rules. The wordmark’s coral dot recurs at timeline endpoints and in the launcher icon.

| Token | Light | Dark |
|---|---|---|
| Background / card | `#FAF7F2` / `#FFFFFF` | `#191817` / `#252321` |
| Primary / secondary text | `#242320` / `#625D57` | `#F4EFE8` / `#C1B8AE` |
| Action accent | `#A23F2A` | `#FFB4A3` |
| Recorded period | `#A23F2A` | `#FFB4A3` |
| Prediction outline | `#686079` | `#C9BDDD` |
| Sage / ochre / blue | `#49695B` / `#856121` / `#496A85` | `#A9C9B8` / `#E3C17F` / `#ACC9E0` |

Keep most surfaces neutral. Coral carries actions and period records; the three supporting colours appear only in small category symbols. No tinted container around every section.

**Typography:** Fraunces Semibold for the wordmark and cycle-day numeral; Source Sans 3 Regular/Semibold for everything else. Start with 48 sp numerals, 28 sp screen titles, 16 sp body, and 14 sp supporting text. Keep dates and controls in sans serif.

**Screen treatment**

- **Today:** 20 dp card padding, 20 dp corners. “Cycle day” sits above a large numeral. Below, a 40 dp chronological strip runs from the last start to the later of today or the predicted start-range end. Recorded period days form a solid segment; today is a dot; the predicted start range is a dashed bracket. Label dates beneath. Prediction sentence and basis follow, then the contextual action. No prediction means an elapsed-only strip; no data means no strip.
- **Calendar:** 32 dp period/prediction circles within minimum 48 dp cells; 40 dp today ring and 4 dp log dot. Prediction dashes are thinner than recorded fills. Preserve space between adjacent outlines.
- **Day entry:** date becomes the main heading. Flow, Mood, Pain, and Symptoms remain open; Sex, Discharge, Tags, and Note use individually expandable rows with saved-value summaries. Five restrained face vectors retain text labels. Selected chips gain a checkmark, border, and tint. Use 8 dp gaps between wrapped chips.
- **History:** replace repeated large cards with aligned rows separated by rules. Each row has date, a proportional cycle-length bar ending in a full stop, numeric length, period-length text, and the existing prediction-use control. Use one zero-based scale across rows; excluded cycles retain their true length and explicit reason.
- **Onboarding:** “FreePeriod.” above one oversized coral full stop and three plain privacy statements. “Get started” and visible “Skip”.
- **Empty states:** a short rule ending in a dot, one useful sentence, one action. No example health data.
- **Launcher:** cream background, heavy charcoal “F”, coral full stop; preserve both shapes in the monochrome version.

**Motion:** successful period start fills its calendar circle over 160 ms with one light haptic; chip checkmarks fade in over 120 ms; month changes slide 16 dp and fade over 180 ms.

**Voice**

| EN | DE |
|---|---|
| A little space for your cycle. | Ein bisschen Raum für deinen Zyklus. |
| Choose what you want to record. | Wähle, was du festhalten möchtest. |
| Your entry is saved. | Dein Eintrag ist gespeichert. |

**Risk:** overly literary styling could feel precious. Restrict the serif to two roles; no paper textures, handwritten notes, or decorative punctuation in controls.

**Compose cost:** medium. Mainly theme, layout, bundled fonts, and one small Canvas timeline. No new dependencies.

**2. Dayline**

*A clear, colourful instrument for understanding your own records.*

**Signature:** a fine calendar ruler with round endpoints. Cobalt navigation, precise numerals, and small chart annotations create a confident graphic identity.

| Token | Light | Dark |
|---|---|---|
| Background / card | `#F4F7FB` / `#FFFFFF` | `#111923` / `#1C2734` |
| Primary / secondary text | `#182638` / `#536175` | `#EDF3FC` / `#B6C3D5` |
| Action accent | `#2855B6` | `#ADC6FF` |
| Recorded period | `#A44432` | `#FFB5A4` |
| Prediction outline | `#62579A` | `#CBC0FF` |
| Teal / amber / slate | `#246B64` / `#855C16` / `#526C85` | `#92D2C6` / `#EAC274` / `#B0C9E1` |

Cobalt identifies interaction, terracotta identifies recorded periods. Supporting colours belong to small category icons, never entire chart backgrounds.

**Typography:** IBM Plex Sans Regular/Medium throughout; IBM Plex Mono Medium for the cycle numeral and chart values. Use 44 sp display numerals and 16 sp body text. Avoid monospaced paragraphs.

**Screen treatment**

- **Today:** a labelled seven-day ruler centred on today, with previous/next dates. Recorded periods occupy solid circular markers; predicted days use dashed markers. “Cycle day 12” remains prominent above it; the full predicted start range appears below even when outside the ruler. This is a date window, not a countdown.
- **Calendar:** the shared marker sizes, with quieter weekday headings and a small legend immediately below the month. Cobalt is reserved for navigation and focus.
- **Day entry:** compact section headings paired with line icons. Flow, Mood, and Pain appear first; remaining sections follow in a single scroll. Use equal-height controls that wrap, selected checkmarks, and five simple outlined faces. Category colour appears only beside headings.
- **History:** compact horizontal bar chart, newest cycle first, shared zero-based day axis, exact values at bar ends. A labelled median reference line adds context. Selecting a row reveals its period length, exclusion reason, and prediction-use toggle. No smoothing or invented trend line.
- **Onboarding:** three connected labelled points: “No account”, “No ads”, “Works offline”. Follow with one sentence explaining local storage and the start action.
- **Empty states:** a single unpopulated ruler with “Your recorded cycles will appear here”; no artificial bars or zero averages.
- **Launcher:** cobalt field, three short ascending rules, one contrasting full stop. Monochrome keeps the geometry.

**Motion:** successful period start gives one light haptic; selecting a chart row moves its outline over 140 ms; changing day translates the ruler exactly one cell over 180 ms. Do not animate chart lengths on every visit.

**Voice**

| EN | DE |
|---|---|
| Your cycle, clearly laid out. | Dein Zyklus, übersichtlich dargestellt. |
| Based on your last 3 cycles. | Basierend auf deinen letzten 3 Zyklen. |
| No prediction yet. You can still log today. | Noch keine Vorhersage. Du kannst heute trotzdem etwas eintragen. |

**Risk:** can become clinical or dashboard-heavy. Limit History to one chart and two summary values; keep technical annotations out of Today.

**Compose cost:** medium. Custom chart/ruler drawing plus accessible row semantics. No new dependencies.

**3. Soft Forms**

*A calm collection of rounded shapes that feels tactile and approachable.*

**Signature:** a large solid dot paired with an open curved line, with slightly asymmetric card corners. Flat shapes provide warmth without characters or lifestyle imagery.

| Token | Light | Dark |
|---|---|---|
| Background / card | `#F4F7F1` / `#FFFFFF` | `#151C19` / `#222D27` |
| Primary / secondary text | `#20352C` / `#58675E` | `#EFF5EA` / `#B8C8BB` |
| Action accent | `#28634D` | `#A8D5B8` |
| Recorded period | `#A14431` | `#FFB59D` |
| Prediction outline | `#59689A` | `#BCCAFF` |
| Ochre / lilac / aqua | `#86611F` / `#795887` / `#286D72` | `#E6C77E` / `#D8B8E4` / `#9BD5D7` |

Use one pale accent shape in the Today card and small category accents elsewhere. No gradients, transparency stacks, or rainbow mood scales.

**Typography:** Manrope Regular/Semibold, including a 48 sp cycle numeral. Rounded geometry comes from layout and illustration, keeping text straightforward.

**Screen treatment**

- **Today:** an open 120-degree arc beside the numeral shows elapsed days since the last start, with equal distance per day and labelled start/today endpoints. Recorded period days occupy the corresponding solid segment. Predictions remain a separate dashed date-range capsule below, so the arc never implies a complete cycle or “remaining” time.
- **Calendar:** shared circular markers, generous spacing, a softly rounded month container. No joining neighbouring circles into blobs.
- **Day entry:** neutral sections with small coloured category tabs. Mood faces use identical circular outlines and equal visual weight. Selected controls show a checkmark and thicker outline. Symptoms use a wrapping icon-and-label grid; optional details expand below.
- **History:** rounded bars with full-stop endpoints on a common zero-based scale. Keep explicit day counts and exclusion labels. Two modest summary tiles stack at large font sizes.
- **Onboarding:** three flat shapes arranged around the FreePeriod. wordmark, then privacy copy and a clear start action.
- **Empty states:** one open curve and dot, short guidance, one action. No smiling mascot reacting to missing records.
- **Launcher:** deep green field with a cream open curve and terracotta dot; clearly an abstract mark, without lunar imagery.

**Motion:** a successful period start gives one light haptic; selected controls compress to 98% and return over 140 ms; expanded sections reveal over 180 ms. Faces never change expression autonomously.

**Voice**

| EN | DE |
|---|---|
| A moment for yourself. | Ein Moment für dich. |
| How are you feeling today? | Wie fühlst du dich heute? |
| Record as much or as little as you like. | Halte so viel oder so wenig fest, wie du möchtest. |

**Risk:** excessive curves can drift into wellness clichés. Use one hero illustration per screen, no floating blobs, and no symbolic meaning assigned to shapes.

**Compose cost:** medium, highest of the three because the curved timeline needs careful sizing and semantics. No new dependencies.

**Recommendation and first five changes**

Choose **Full Stop**, with Dayline’s precise History chart conventions. It ties directly to the name, retains coral, and creates distinction through typography and useful information design.

1. **Define complete theme tokens and typography:** warm neutral surfaces, explicit text/control colours, Fraunces numerals, Source Sans 3 body. Remove incidental lavender surfaces.
2. **Rebuild Today’s hierarchy:** compact header, chronological strip, prediction, action. Remove oversized vertical gaps; retain all state-specific text.
3. **Standardise calendar geometry:** separated markers, independent flags, visible legend, accessible descriptions, and navigation-safe scrolling.
4. **Restructure Day entry:** consistent chip spacing, checkmarked selections, labelled faces, and expandable secondary categories.
5. **Replace History’s repeated cards:** aligned proportional bars, exact values, compact summaries, readable exclusion reasons, and accessible controls.

**Changed:** none; net lines 0, nothing removed.  
**Checked:** spec, binding plan decisions, theme, and 12 screenshot references inspected. Build/tests not run for this concept round; test counts and exit code N/A.  
**Screenshot tests added/changed:** none.  
**Open points / deviations:** final font files and contrast require verification. Dayline and Soft Forms replace the plan’s coral action accent; Full Stop preserves it. No network calls or downloads.