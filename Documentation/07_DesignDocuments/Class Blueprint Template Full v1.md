Class Blueprint Template Full v1.docx
BG3 Blueprint Pack — Usage Guide (with Import Wizard)

A practical, end-to-end guide for authoring, validating, previewing, importing, and exporting BG3 class mods using

the Blueprint Canvas (Sections §1–§22). This document is team-ready: follow it top-to-bottom to go from a blank
Canvas to a packed .pak.

0) What this pack is

A single-source-of-truth authoring template for BG3 class mods. You:

fill structured JSON per section,
validate & preview, then
export add-only LSX/Stats + Loc + Icons as a .pak.
Key capabilities baked in:

SubclassBase bucket (2 picks at L1: 1 offensive + 1 utility, then 1 pick each level L2→20 until complete).
SubclassSpec 10-row talents (rows 1–10), plus optional SUBCLASSSPEC_PASSIVES_ROW_1.
Specialization package (Key + Capstone at L13; Choice Nodes at L13/L15/L18; Passives L13→20).
Tiered upgrade tracks (tiers at L5/L8/L13/L18; tracks can use at or atTier).
Tag taxonomy + Tag Validator (Section §17).
Tooltip Composer with math, tiers, and upcasting (Section §19).
Full-9 casting support when enabled (Sections §10–§11 & §21 compatibility).
1) Prerequisites

JSON-friendly editor (VS Code recommended) and a BG3 mod packer.
The Blueprint Canvas (Sections §1–§22) in one place — treat it as the source of truth.
(Optional) Community Library dependency if you use its helpers.
2) Authoring Modes (choose once at kickoff)

Exact (You Specify Everything) — you fill every field; template doesn’t infer.
Guided Defaults — answer key prompts; sensible defaults fill the rest.
Best Guess Mode — provide name/theme/archetype; template drafts with [ASSUMPTION] markers you can
tighten or lock.
Helpful commands (if supported by your UI/CLI):

Start Class Interview , Use Best Guess Mode , Tighten Assumptions , Go Bold , List/Lock Assumptions.
3) Authoring Flow (10 steps)

Step 1 — §1–§3 (Preface, Meta, Mod Basics)

Set namespace (default VORGX), author, and mod identity.
These drive validation toggles, naming rules, and export metadata.
Step 2 — §4 (Class Details) & §5 (Class Core Abilities)

Define class identity: saves, proficiencies, starting kit.
In §5, author core class actions/passives/statuses using generic authoring (tips allowed in empty fields).
Tag assets (see §17 tagSets). Ensure each asset has PrimaryCategory and required tag groups.
Step 3 — §6–§7 (Subclass Details & Core Abilities)

Each subclass maintains its own full catalog (builders, spenders, passives, auras/stances, spells, feats).
Keep keys consistent with §6 identifiers and register them in §17.
Step 4 — §8 (Catalogs)

Create lists that wire your catalogs into progression:

Class Talents — LIST_CLASS_TALENTS_ROW_1...10 (row 1 granted at L1, then pick 1 every 2 levels).
SubclassSpec Talents — LIST_SUBCLASSSPEC_ROW_1...10 (+ optional
LIST_SUBCLASSSPEC_PASSIVES_ROW_1).
SubclassBase — LIST_SUBCLASSBASE_OFFENSE, LIST_SUBCLASSBASE_UTILITY, union into
LIST_SUBCLASSBASE_ALL (bucket; no rows).
Specialization — LIST_SPEC_KEY_TALENT, LIST_SPEC_CAPSTONE, LIST_SPEC_CHOICES_1...3,
LIST_SPEC_PASSIVES.
Step 5 — §9–§11 (Resources & Casting)

§9: define resource models (builders/spenders, caps, windows; per-rest recharge).
§10–§11: define casting model. For L9 spells , use CASTTRACK_STANDARD_FULL_9 and enable full9Casting
in §21 when ready. Upcasting rules live in §11.
Step 6 — §12–§13 (Level Plan & Tier Effects)

Map highlights: feats at 4/8/12/16/20; tiers at 5/8/13/18; specialization package at 13/15/18.
Describe tier effects in human text (what changes per tier).
Step 7 — §14 (Progression — authoring)

One atomic row per grant. Use UpgradeMarker rows for MARK_TIER_I...IV (5/8/13/18).
Wire groups: Class Talents, SubclassSpec Talents, SubclassBase stream, Specialization
(Key/Capstone/Nodes/Passives).
Step 8 — §15 (Progression — rendered table)

Auto-built from §14; renderer (Section §18) groups by Level, pins feats/markers, and can collapse the
SubclassBase stream.
Step 9 — §16 (Upgrade Tracks)

Centralize scaling via tracks[].plan[] using at (level) or atTier (I–IV) and typed delta (e.g., damageDieBonus,
saveDCBonus).
Targets must exist in §5/§7 and be registered in §17.
Step 10 — §17–§19 (Glossary, Renderer, Localization)

§17: register every key; include tag taxonomy and Tag Validator.
§18: control table columns, order, grouping, color maps, badges, and the Math pill.
§19: Tooltip Composer adds base math + tier + upcasting lines. Auto-stubs create missing titles.
4) Validate → Preview → Export

Validate — Section §

Runs:

Schema/order/add-only checks.
Progression contracts (feats/tiers/specialization/SubclassBase cadence).
Cross-refs (lists & keys exist; no same-level dupes).
Resources/Casting binds & constraints.
Tag compliance (taxonomy, singletons, required-per-primary).
Tooltip Math requirements (Base+Total; Upcasting when enabled; Tier summary when tracked).
Upgrade track grammar.
Preview — Section §

Filters: OnlyClass / OnlySubclass / OnlyTalents / OnlySpells.
Expand Math pill to verify equations and upcast tables.
Export — Section §

Keep addOnly=true.
For L9 casting , enable compatibility.full9Casting.enabled=true after §§10–§11 are set.
Optionally run GENERATE SKELETON once to create folder stubs.
Export to produce LSX/Stats/Loc/Icons and pack .pak.
5) Dynamic Import Wizard — Any Class/Subclass & Any Guide URL

Use this to seed catalogs from external pages (Wowhead/wikis/sheets). It scrapes → normalizes → maps to BG

tokens → applies Balance & Resource passes → stages for review → commits on approval.

Start the mini-wizard

You’ll be prompted for:

Class key (e.g., WAR, must exist in §17.classes).
Subclass key (e.g., SUBCLASS_), or select Class-level import.
Source URL (any public guide; example only: https://www.wowhead.com/...).
Scopes (checkboxes): Actions, Passives/Auras/Stances, Talent Rows (Class/SubclassSpec), SubclassBase
bucket, Specialization scaffolding.
Mapping profile (e.g., wow_to_bg3_default).
Balance style (conservative|standard|bold).
Resource rules (use §9 defaults or a specific spec).
Importer profile (generic default)

Create config/import_profiles.json once. The profile is site-agnostic but WoW-friendly.

{
"profiles": {

"wow_to_bg3_default": {

"scrape": {

"selectors": {

"abilityBlocks": ["article", ".guide-section", ".spell", ".talent"],

"title": [".heading", ".spell-name", "h2", "h3"],

"icon": [".icon", "img[src]"],

"textHtml": [".body", ".content", ".spell-text", "p", "li"]

},
"fields": ["name","icon","textHtml","textPlain","cooldown","charges","tags"]

},
"normalize": {

"splitSentences": true,

"stripMarkup": true,

"detectNumbers": true,

"units": ["sec","yard","cone","line","targets","stack","charge","bleed","execute"]

},

"mapping": {

"primaryCategory": { "default": "Action" },

"actionTiming": [

{ "when": "hasGCD || isActive", "to": "Action" },

{ "when": "isInstantOffGCD", "to": "BonusAction" }

],
"tempoRole": [

{ "when": "text ~= /(generate|build|grant)/i", "to": "Builder" },

{ "when": "text ~= /(consume|spend|cost)/i", "to": "Spender" },

{ "when": "text ~= /(execute|finish)/i", "to": "Finisher" }

],
"delivery": [

{ "when": "text ~= /(cone|cleave)/i", "to": "Cone" },

{ "when": "text ~= /(line|beam)/i", "to": "Line" },

{ "when": "text ~= /(throw|hurl|shoot)/i", "to": "Ranged" },

{ "when": "text ~= /(leap|charge|jump)/i", "to": "Leap" },

{ "when": "else", "to": "Melee" }

],
"cooldownBand": [

{ "when": "cooldown <= 20", "to": "Light" },

{ "when": "cooldown <= 60", "to": "Mid" },

{ "when": "else", "to": "Heavy" }

],
"scaling": [

{ "when": "text ~= /(weapon|strike|slash|bash)/i", "to": "Weapon" },

{ "when": "text ~= /(spell|arcane|holy|shadow)/i", "to": "Spell" },

{ "when": "else", "to": "Str" }

],
"damageType": [

{ "when": "text ~= /(bleed|rend)/i", "to": "Slashing" },

{ "when": "text ~= /(fire|flame)/i", "to": "Fire" },

{ "when": "text ~= /(frost|cold)/i", "to": "Cold" },

{ "when": "text ~= /(shadow|necrot)/i","to": "Necrotic" },

{ "when": "else", "to": "Bludgeoning" }

],
"stanceAuraDetection": [

{ "when": "text ~= /(stance|aura|shout|presence)/i", "to": "StanceOrAura" }

]
},
"tagging": {

"requiredFrom§17": true,

"flavor": ["Steel","Rage","Focus","Hunter","Arcane"],

"fallbacks": { "CooldownBand": "Light", "Scaling": "Weapon" }

},
"balance": { "style": "conservative" },

"resources": { "useClassDefaults": true },

"output": { "toSections": ["§7","§8","§16","§17","§19"] }

}
}
}
Staging & Review before Commit

The wizard stages all proposed changes (no live edits). You can review, retag, move between lists, rename keys, or
drop items.

{
"staging": {

"bufferKey": "IMPORT_STAGING",

"writeTargets": ["§7","§8","§16","§17","§19"],

"conflictMode": "append-only",

"onKeyCollision": "proposeRename",

"onListCollision": "mergeUnique"

},
"review": {

"diff": { "showAdded": true, "showChanged": true, "showRemoved": false, "groupBy": "section", "sortBy": "token" },

"bulkActions": ["retag","moveList","renameKey","dropItem"],

"approvals": { "requireZeroErrors": true, "allowWarnings": true, "preCommitChecks":
["tags","crossRefs","resources","tooltips","upgradeGrammar"] }

}
}
Approve to commit:

Writes to §§7/8/16/17/19 per rules (append/merge),
Runs §20 Validation over the whole Blueprint,
Opens §18 Preview and §21 Prepare Export.
CLI (example)

Stage (no changes to the Blueprint yet)
bp import external \

--class WAR \

--sub SUBCLASS_VORGX_WAR_ARMS \

--url "https://<your-guide-url>" \

--profile wow_to_bg3_default \

--scopes Actions,Passives,TalentRowsSubclass,SubclassBase \

--balance conservative \

--resources defaults \

--stage IMPORT_STAGING \

--preview --validate-staging

Review staged diff in UI
bp import review --stage IMPORT_STAGING --open-ui

Commit → Validate → Preview → Prepare Export
bp import commit --stage IMPORT_STAGING --run-validation --open-preview --prepare-export

6) Practical Recipes

A) Add a new spender that scales by tiers

§7: Create action with tags (ActionTiming:BonusAction, TempoRole:Spender, etc.).
§17: Register key.
§8: Place in a SubclassSpec row list.
§14: Grant at the desired level.
§16: Add TRACK_* with atTier deltas.
§19: Add Loc title/desc; composer renders math & tiers.
§20: Validate → §18 Preview → §21 Export.
B) Enable L9 casting for a subclass

§10–§11: Set casting model + upcasting rules.
§17: Ensure CASTTRACK_STANDARD_FULL_9 exists.
§14: Add CasterBind row.
§21: Set compatibility.full9Casting.enabled=true.
Validate & export.
C) Specialization branch

§8: Fill Specialization lists (Key/Capstone/Choices/Passives).
§14: Grant Key + Capstone + Choices_1 at L13; Choice_2 at L15; Choice_3 at L18; Passives each level 13→20.
§16: Add tracks as needed; §19 tooltips aggregate deltas.
7) Naming & Tag Rules (quick)

All keys start with your namespace (default VORGX).
Every asset includes PrimaryCategory and required groups per §17:
Action → ActionTiming, TempoRole, Delivery, CooldownBand
Spell → ActionTiming, TempoRole, School, CooldownBand
Passive → Identity
Aura/Stance → *Type, ToggleMechanic, ToggleRule, DurationKind
Singleton groups (e.g., ActionTiming) must have exactly one value.
8) Tooltips that explain (math, tiers, upcasting)

Provide base numbers (dice or flat), abilityMod, and prof flags.
Use §16 tracks for scaling — Tier summaries will auto-appear.
If §11 enables upcasting, the composer adds an Upcasting table.
In §18, use the Math pill to expand calculations.
9) Troubleshooting

missingCoreMath (tooltips) → supply base dice/flat and ensure composer variables exist.
choiceListMissing → §14 references a list key not present in §8.
assetNotInGlossary → add to §17 and ensure asset exists in §5/§7.
Upcasting missing → verify §11 upcast.enabled and that the composer is active.
SubclassBase exhausts early → add more entries to LIST_SUBCLASSBASE_ALL or accept idle stream
(warning only).
Icons missing → add uiIcon in §17 or rely on defaults.
10) Versioning & Releases

Maintain §22 Change Log ; exports can require a new entry.
Bump version in §21; use semver.
Artifacts: dist/<ModName>.pak + optional manifest.
11) Quickstart (20-minute checklist)

Fill §2–§4 identities; pick Best Guess Mode.
Add 1–2 core class abilities in §5.
Create one subclass with 3–5 abilities in §7.
Wire lists in §8 (Row 1s + SubclassBase bucket).
Author §14 grants for Levels 1–5 (include MARK_TIER_I at L5).
Create one §16 track using atTier: "I".
Add Loc titles in §19.
Run §20 Validation → fix errors.
Preview §18; tweak tags/colors.
Export §21 (skeleton → pack) and test in-game.
Appendix A — Minimal emitted stubs (neutral)

§7 — Actions (one sample)

{
"key": "ACTION_VORGX_WAR_ARMS_SampleStrike",

"tags": [

"PrimaryCategory:Action","ActionTiming:Action","TempoRole:Builder",

"Delivery:Melee","CooldownBand:Light","DamageType:Slashing","Scaling:Weapon"

],
"base": { "dice": "1d8", "abilityMod": "Str", "prof": true },

"economy": { "resource": "RES_VORGX_WAR_ARMS", "cost": 0 }

}
§8 — Catalog merges

{
"LIST_SUBCLASSSPEC_ROW_1": ["ACTION_VORGX_WAR_ARMS_SampleStrike"],

"LIST_SUBCLASSBASE_OFFENSE": ["ACTION_VORGX_WAR_ARMS_SampleStrike"],

"LIST_SUBCLASSBASE_ALL": ["ACTION_VORGX_WAR_ARMS_SampleStrike"]

}
§16 — Optional track seed

{
"tracks": {

"TRACK_VORGX_WAR_ARMS_STRIKES": {
"targets": ["ACTION_VORGX_WAR_ARMS_SampleStrike"],

"plan": [ { "atTier": "II", "apply": [ { "target": "ACTION_VORGX_WAR_ARMS_SampleStrike", "delta": {

"damageDieBonus": 1 } } ] } ]

}

}
}
§19 — Loc tokens

[
{ "token": "h_ACTION_VORGX_WAR_ARMS_SampleStrike", "lang": "en", "value": "Sample Strike" },

{ "token": "d_ACTION_VORGX_WAR_ARMS_SampleStrike", "lang": "en", "value": "Deliver a decisive blow. Deals
${dice}." }

]
You’re set. Use this guide alongside the Canvas. Import smartly, review diffs, validate strictly, preview with math,
and export add-only. Happy modding!

12c) Command Reference — Pack & Import Wizard

Quick, scannable list of commands (UI actions & CLI) supported by this Blueprint pack. Use these names/buttons

in your UI, or the bp CLI equivalents in scripts.

A. Authoring / Interview

Start Class Interview — Launches the kickoff questionnaire (choose Exact / Guided Defaults / Best Guess).
Caches answers for later.
Use Best Guess Mode — Enables lore-inferred drafting; missing fields are filled with [ASSUMPTION] markers.
Tighten Assumptions — Shrinks assumption ranges to conservative defaults (safer numbers, fewer edge
cases).
Go Bold — Expands assumptions to a more aggressive, high-power draft (still valid for validation).
List Assumptions — Prints all current [ASSUMPTION] items with their sources.
Lock Assumptions — Converts selected assumptions into fixed authoring values.
Patch Rules — Merges updated core rules into this project (feats/tier gates, cap ranges, tag sets).
Show Examples — Displays reference patterns (Paladin/Warrior/Hunter) for inspiration only.
B. Canvas Ops

Export Blueprint Canvas — Emits the filled §1–§22 JSON (no comments in values). Use as single source of
truth.
Validate Blueprint — Runs §20 suites (schema, tags, progression, tooltips math, resources, casting, tracks,
etc.).
Preview Blueprint — Opens §18 renderer (Progression Table, Upgrade Tracks timeline, Catalog cards).
C. Import Wizard (dynamic; staging → review → commit)

Import from External (Wizard) — Starts the guided import for any Class/Subclass + any URL.
Prompts: Class, Subclass, URL, Scopes, Mapping Profile, Balance Style, Resource Rules.
Stage Import — Scrapes + maps to BG3 + tags → writes to IMPORT_STAGING buffer only (no live edits).
Review Import — Opens diff view of staged changes (bulk actions: retag, move list, rename key, drop item).
Approve Import — Commits staged data into §§7/8/16/17/19, then auto-runs §20 → §18 → §21 prep.
Reject Import — Discards IMPORT_STAGING buffer.
CLI equivalents

bp import external --class <CLASS> --sub <SUBCLASS> --url <URL> --profile <PROFILE> --scopes <...> --
balance <style> --resources <rules> --stage IMPORT_STAGING --preview --validate-staging
bp import review --stage IMPORT_STAGING --open-ui
bp import commit --stage IMPORT_STAGING --run-validation --open-preview --prepare-export
bp import discard --stage IMPORT_STAGING
D. Tagging & Validation Controls

Run Tag Lint — Executes §17 Tag Validator alone (fast pass for tagSets/singletons/required-per-primary).
Set Validation Profile: dev/strict — Toggles §20 policy.strict and failOn/warnOn thresholds.
Explain Validation Failure — Prints focused fix-it guidance per suite (crossRefs, tags, tooltips, resources,
etc.).
E. Renderer (UI) Controls

Filter: OnlyClass / OnlySubclass / OnlyTalents / OnlySpells — Quick filters over the §15 table.
Toggle Math — Expands the tooltip math block (mechanics, upcasting, tiers) per row.
Collapse SubclassBase Stream — Hides the long baseline pick stream for scanning.
Pin Markers/Feats — Keeps tier markers and feat rows visible within a level group.
F. Resources & Casting

Bind Resource to Subclass — Adds/edits §9 binds for a subclass (builders/spenders, caps, windows, per-
rest).
Enable Full-9 Casting — Wires §10–§11 to a CASTTRACK_STANDARD_FULL_9 track and flips §
compatibility.full9Casting.enabled=true.
Add Upcasting Rule — Adds/edits §11 upcast table (per-slot deltas); tooltips auto-include the breakdown.
G. Upgrade Tracks

Add Upgrade Track — Creates a new §16 TRACK_* with targets and an empty plan.
Add Checkpoint (Level) — Appends { "at": <level>, "apply": [...] } to a track.
Add Checkpoint (Tier) — Appends { "atTier": "I|II|III|IV", "apply": [...] } (resolved via §14 tier map).
Validate Tracks — Runs the §20 upgrade grammar suite (duplicates, illegal deltas, missing targets).
H. Localization & Tooltips

Generate Loc Stubs — Creates missing h_*/d_* tokens from §17 glossary keys.
Rebuild Tooltips — Forces §19 Tooltip Composer to regenerate math/tier/upcast lines.
Lint Tooltips Math — Runs the §20 tooltips suite (require base & total; upcast; tier summary when
applicable).
I. Export & Packaging

GENERATE SKELETON — Creates folder tree & stub files (Progressions/, Stats/Generated/, Localization/,
GUI/Assets/).
Export (Dry Run) — Writes outputs to a temp folder + manifest (no packing) to preview file changes.
Export (Pack .pak) — Normalizes & writes LSX/Stats/Loc/Icons, then packs .pak per §21 options.
Conflict Scan — Dry-run check to ensure add-only; reports potential vanilla overlaps.
CLI equivalents

bp validate — Run full §20.
bp preview — Open §18 renderer.
bp export --dry-run — Generate outputs without packing.
bp export --pack — Produce .pak to dist/.
bp export --skeleton — Create the skeleton structure.
bp conflicts --scan-vanilla — Report potential overwrites.
J. Maintenance & Utilities

Bump Version — Updates §21 version and §22 changelog (semver). Optionally gates export until changelog
updated.
Generate README.md — Emits a repo/Nexus-ready README from Sections §1–§3 + highlights from §22.
Dump Manifest — Writes an export manifest with file hashes & counts for CI auditing.
Backup/Restore Canvas — Save/restore §1–§22 to/from snapshot files.
Tip: If your UI doesn’t expose some commands, you can still use the CLI equivalents above in scripts or CI.

1) Preface — Config

What this section does

This section defines global switches and defaults for the Blueprint renderer and validator. It does not produce
gameplay content; it controls how the rest of the Blueprint is interpreted, displayed, and checked before export

(e.g., multi-row progression tables, grant labels, subclass gates, resource caps, LSX normalization). It’s the first
thing the Mod Maker reads to ensure the rest of the document conforms to project and Community Library
conventions.

Authoring (drop-in JSON)

Paste this block verbatim under Preface — Config. Keep booleans and numbers as native types. No comments

inside values.

{
"renderer": {

"progressionTableMode": "multi-row-per-level",

"showGrantLabels": true,

"showUiNames": true,

"showShortDescriptions": true,

"showNotesAtAcquisition": true,

"compactTable": false,

"columnOrder": ["Lvl", "Grants", "Notes"],

"sortProgression": "byLevelThenGrant",

"normalizeDiceOnExport": true

},
"validation": {

"enabled": true,

"checkNamespace": true,

"checkAuthor": true,

"checkAddOnlyAuthoring": true,

"checkLevel1Rows": true,

"checkFeatLevels": [4, 8, 12, 16, 20],

"checkTierLevels": [3, 8, 13, 18],

"checkSubclassUnlockLevel": 1,

"checkSubclassCount": 3,

"checkAbilityPresetsRange": true,

"checkResourceCaps": true,

"checkIconPlaceholders": true,

"checkCasterSchema": "internal-or-external",

"lintTokens": true

},
"defaults": {

"namespace": "VORGX",

"author": "vorgx",

"maxLevel": 20,

"subclass": { "count": 3, "unlockLevel": 1 },

"featLevels": [4, 8, 12, 16, 20],

"tierLevels": [3, 8, 13, 18],

"icons": { "classPlaceholder": "VORGX_ICON_CLASS_GENERIC" },

"resource": { "windowCap": 11, "upcastMax": 9 },

"dice": { "d6": 6, "d8": 8, "d10": 10, "d12": 12 }

},
"rules": {

"communityLibraryIntegration": true,

"progressionSchema": "internal",

"allowExternalCasterProgression": true,

"unlockLevelCurve": "Patch8_L20",

"addOnly": true

},

"renderHooks": {

"RENDER:PROGRESSION_TABLE": true

}
}
Notes:• progressionTableMode: "multi-row-per-level" ensures each grant appears on its own row per level,

matching your requested readability style.• rules.unlockLevelCurve: "Patch8_L20" aligns to your level-20 curve
usage.• defaults.resource.windowCap: 11 supports your “11 pips with +9 upcast window” rule of thumb.

Field-by-field (what each drives)

renderer.progressionTableMode — Controls table layout. "multi-row-per-level" prints one row per grant under the

same level to avoid stuffed cells and improves scanability. renderer.showGrantLabels / showUiNames /
showShortDescriptions — Enforces “display text” discipline (no raw internal keys in the table). When true, the

Progression table uses human-readable grantLabel, uiName, and short tooltip copy.
renderer.showNotesAtAcquisition — Appends notesAtAcquisition bullets the first time a feature appears (costs,
scaling, upcast bands). renderer.columnOrder — Lets you lock the table to Lvl | Grants | Notes (or any order)

without touching content. renderer.normalizeDiceOnExport — Converts dice strings to numeric when writing LSX
(keeps dice in authoring, normalizes on export).

validation.enabled — Master on/off for lint checks before export. validation.checkNamespace / checkAuthor —
Ensures your declared namespace and author exist and are consistent across catalogs and progressions (prevents
mixed authors or stray namespaces). validation.checkAddOnlyAuthoring — Blocks accidental overwrites of
vanilla data (add-only). validation.checkLevel1Rows — Guarantees at least one L1 row (class identity

present). validation.checkFeatLevels — Confirms feats at 4/8/12/16/20 (can be overridden later, but default guard
holds). validation.checkTierLevels — Confirms Tier gates at [3,8,13,18] per your shifted

windows. validation.checkSubclassUnlockLevel / checkSubclassCount — Ensures subclasses unlock at 1 with
count=3 by default (mod-wide expectation). validation.checkAbilityPresetsRange — Validates each ability score
in presets is 3–20 inclusive. validation.checkResourceCaps — Asserts resource caps/windows follow the 11-

cap/+9-upcast policy. validation.checkIconPlaceholders — Ensures a placeholder icon exists if no final icon is
set. validation.checkCasterSchema — Warns if caster progression is set to external but no mapping is declared.

defaults.namespace / author — Project-wide defaults (your directive is NAMESPACE=VORGX,
author=vorgx). defaults.maxLevel — Export and validator expect level ceilings to match this

value. defaults.subclass.count / unlockLevel — Your template’s baseline subclass policy. defaults.featLevels /
tierLevels — Propagates to auto-validators for the progression authoring. defaults.icons.classPlaceholder —

Safe fallback to avoid invisible icons during UI review builds. defaults.resource.windowCap / upcastMax — Sets
global budget assumptions for spender windows and upcast bands. defaults.dice — The canonical normalization

targets when normalizeDiceOnExport is true.

rules.communityLibraryIntegration — Enables Community Library conventions and dependency

hints. rules.progressionSchema — "internal" for classes using your internal slot/tier rules; allow "external" if you
intentionally follow another mod’s schema. rules.allowExternalCasterProgression — Whitelist to permit external
schema on caster settings (used later in §10–11). rules.unlockLevelCurve — Establishes the intended level ceiling

and curve (e.g., Patch 8 to L20). rules.addOnly — Global invariant: never edit base records in place.

renderHooks.RENDER:PROGRESSION_TABLE — Asserts the Progression table should be rendered (the renderer

looks for this marker).

Validation checklist (for this section)

Preface JSON parses and all fields are native types (no strings for booleans/numbers).
namespace = "VORGX" and author = "vorgx" present.
maxLevel = 20 and unlockLevelCurve = "Patch8_L20" set.
progressionTableMode = "multi-row-per-level" and showGrantLabels = true.
featLevels = [4,8,12,16,20] and tierLevels = [3,8,13,18] configured.
subclass.count = 3 and subclass.unlockLevel = 1 set.
Resource policy set: resource.windowCap = 11, resource.upcastMax = 9.
Community Library integration flag set to true.
Validation enabled and includes checkAddOnlyAuthoring, lintTokens.
Dice normalization enabled if you plan to keep dice notation in authoring and LSX numbers in export.
Common pitfalls & how to avoid them

Missing grant labels → Set renderer.showGrantLabels = true and ensure every Catalog entry has grantLabel;
otherwise rows fall back to internal keys.
Overwriting vanilla content → Keep rules.addOnly = true and run validation.checkAddOnlyAuthoring.
Inconsistent subclass policy → If you change subclass unlocks in §7/§9C, update
defaults.subclass.unlockLevel here or the validator will flag it.
Unclear progression readability → Use "multi-row-per-level" to avoid compressed cells and ensure each
grant is obvious at a glance.
Caster progression mismatch → If you switch §10–11 to external schema, also set rules.progressionSchema
= "external" and keep validation.checkCasterSchema = "internal-or-external".
Improvement suggestions

Preset bundles : Add named renderer presets (e.g., "readable", "compact") to quickly flip table density.
Strict mode : Add validation.strict = true to fail export on warnings (useful for release builds).
Per-subclass column tint : Optional UI aid for multi-row tables to color-tag subclass grants.
Guided fixes : Extend validator to print direct fix-its (e.g., “Add grantLabel to ACTION_VX_001”).
Schema locks : Add rules.lockedFields to prevent accidental drift of tier/feat arrays across edits.
Example (filled)

{
"renderer": {

"progressionTableMode": "multi-row-per-level",

"showGrantLabels": true,

"showUiNames": true,

"showShortDescriptions": true,

"showNotesAtAcquisition": true,

"compactTable": false,

"columnOrder": ["Lvl", "Grants", "Notes"],

"sortProgression": "byLevelThenGrant",

"normalizeDiceOnExport": true

},

"validation": {

"enabled": true,

"checkNamespace": true,

"checkAuthor": true,

"checkAddOnlyAuthoring": true,

"checkLevel1Rows": true,

"checkFeatLevels": [4, 8, 12, 16, 20],

"checkTierLevels": [3, 8, 13, 18],

"checkSubclassUnlockLevel": 1,

"checkSubclassCount": 3,

"checkAbilityPresetsRange": true,

"checkResourceCaps": true,

"checkIconPlaceholders": true,

"checkCasterSchema": "internal-or-external",

"lintTokens": true

},
"defaults": {

"namespace": "VORGX",

"author": "vorgx",

"maxLevel": 20,

"subclass": { "count": 3, "unlockLevel": 1 },

"featLevels": [4, 8, 12, 16, 20],

"tierLevels": [3, 8, 13, 18],

"icons": { "classPlaceholder": "VORGX_ICON_CLASS_GENERIC" },

"resource": { "windowCap": 11, "upcastMax": 9 },

"dice": { "d6": 6, "d8": 8, "d10": 10, "d12": 12 }

},
"rules": {

"communityLibraryIntegration": true,

"progressionSchema": "internal",

"allowExternalCasterProgression": true,

"unlockLevelCurve": "Patch8_L20",

"addOnly": true

},
"renderHooks": {

"RENDER:PROGRESSION_TABLE": true

}

}
2) Meta

What this section does

Holds all project-wide identifiers and publishing metadata your Mod Maker/Exporter needs before it can build files

and wire LSX correctly. It does not grant gameplay content; it defines the “who/what/where” for the mod and the
class package (namespace, author, module/class keys, versioning, dependencies, icon/banner handles, links, and

packaging hints). Downstream steps (Progression, Catalog, Export) read this to construct meta.lsx, folder names,
and localization stubs.

Authoring (drop-in JSON)

Paste under Meta (keep types correct; no comments inside values).

{
"ids": {

"namespace": "VORGX",

"author": "vorgx",

"moduleUUID": "00000000-0000-0000-0000-000000000000",

"classKey": "CLASS_VORGX_GENERIC",

"slug": "vorgx-generic-class"

},
"titles": {

"modName": "VORGX — Generic Class (Template)",

"className": "Generic Class",

"shortName": "Generic",

"subtitle": "Blueprint Template v1.9",

"tagline": "Clean, add-only BG3 class scaffolding"

},

"version": {

"major": 0,

"minor": 1,

"patch": 0,

"label": "alpha",

"semver": "0.1.0-alpha"

},
"compatibility": {

"gameBuildMin": "4.1.1.0",

"gameBuildMax": "4.1.99.99",

"requiresCommunityLibrary": true,

"levelCurve": "Patch8_L20",

"progressionSchema": "internal"

},
"dependencies": [

{
"name": "GustavX",

"uuid": "cb555efe-2d9e-131f-8195-a89329d218ea",

"version64": "145241946983074840",

"required": true

},
{
"name": "BG3-Community-Library",

"uuid": "00000000-0000-0000-0000-000000000CLB1",

"required": true

}
],
"catalogAssets": {

"iconClass": "VORGX_ICON_CLASS_GENERIC",

"banner": "VORGX_BANNER_GENERIC",

"screenshotHandles": []

},
"packaging": {

"moduleFolder": "VORGX_GenericClass",

"publicFolder": "Public/VORGX_GenericClass",

"localizationFolder": "Localization",

"authorUrl": "https://nexusmods.com/users/000000000",

"readmeFile": "README.md",

"license": "MIT"

},
"links": {

"homepage": "",

"issueTracker": "",

"discord": ""

},
"tags": [

"Class",

"Add-Only",

"CommunityLibrary",

"Level20"

]
}
Field-by-field (what each drives)

ids.namespace — Canonical prefix for all generated keys (Stats/Progressions/Localization).
ids.author — Embeds into exporter metadata and optional .pak manifest.
ids.moduleUUID — The module’s GUID used in meta.lsx. Keep stable for the life of the mod.
ids.classKey — Internal class identifier (drives Catalog keys, Progression grants, and Token Glossary
anchors).
ids.slug — Safe, URL-friendly string used for folder names and link stubs.
titles.modName / className / shortName / subtitle / tagline — Human-readable strings shown in mod
manager pages and optional in-game descriptions; also used by the renderer in headers.
version.(major/minor/patch/label/semver) — Central version; exporter maps to LSX’s Version64 and
packaging filenames.
Tip: Keep semver authoritative; the exporter derives everything else from it if present.
compatibility.gameBuildMin/Max — Guard rails; validator warns if your environment doesn’t match tested
bounds.
compatibility.requiresCommunityLibrary — Tells validator/exporter to add the Community Library
dependency block.
compatibility.levelCurve — Signals you’re targeting the L20 curve (ties into Preface for validations).
compatibility.progressionSchema — "internal" (your template’s schema) or "external" (follows external
slot/tier source).
dependencies[] — Exact modules to list in meta.lsx > Dependencies. Include GustavX and Community
Library when required.
uuid/version64 — If known, set so the game can verify exact dep versions.
catalogAssets.iconClass / banner / screenshotHandles — Asset handles used by UI and for placeholder
visuals during development.
packaging.moduleFolder / publicFolder / localizationFolder — File system layout cues for exporter
(creates folders and routes generated LSX/LOC there).
packaging.authorUrl / readmeFile / license — Non-game content bundled alongside, referenced in readme
and Nexus metadata.
links.homepage / issueTracker / discord — For release pipelines and support links; optionally surfaced in
readme stubs.
tags[] — Lightweight labels the renderer can show (and that you can mirror on Nexus).
Validation checklist (for this section)

namespace and author present and match Preface — Config defaults.
moduleUUID is a valid GUID (not all zeros in a release build).
classKey matches Catalog/Progression usage (exact string).
semver is valid; exporter can derive Version64 as needed.
Community Library flag and dependency present if required.
levelCurve aligns with Preface (Patch8_L20) and maximum level 20.
Packaging folders are non-empty and file-system safe.
Icon/banner handles exist or a placeholder handle is set.
Common pitfalls & how to avoid them

Changing module UUID mid-project → Breaks save compatibility. Lock it after first test release.
Mismatched classKey → Causes orphaned Progression/Catalog rows. Centralise here; reference everywhere
else.
Forgetting Community Library dependency → Features may silently fail. Keep the flag and dependency in
sync.
SemVer drift → Always bump semver; let exporter derive Version64 to avoid manual mistakes.
Folder name vs slug mismatch → Use a single source (packaging.moduleFolder or ids.slug) and derive the
other.
Improvement suggestions

Auto-derive slugs/folders from titles.modName (kebab-case) to reduce typos.
Release channels : add version.channel (dev, beta, stable) to toggle validator strictness.
Publisher presets : store Nexus/Thunderstore metadata stubs here (categories, visibility) for one-click
publishing.
Multi-icon support : allow per-subclass icon overrides with fallback to iconClass.
Example (filled)

{
"ids": {

"namespace": "VORGX",

"author": "vorgx",

"moduleUUID": "8a7f5f2a-9d63-4d1c-b1aa-6d7c1f6cb999",

"classKey": "CLASS_VORGX_GENERIC",

"slug": "vorgx-generic-class"

},
"titles": {

"modName": "VORGX — Generic Class (Template)",

"className": "Generic Class",

"shortName": "Generic",

"subtitle": "Blueprint Template v1.9",

"tagline": "Clean, add-only BG3 class scaffolding"

},
"version": {

"major": 0,

"minor": 1,

"patch": 0,

"label": "alpha",

"semver": "0.1.0-alpha"

},
"compatibility": {

"gameBuildMin": "4.1.1.0",

"gameBuildMax": "4.1.99.99",

"requiresCommunityLibrary": true,

"levelCurve": "Patch8_L20",

"progressionSchema": "internal"

},
"dependencies": [

{
"name": "GustavX",

"uuid": "cb555efe-2d9e-131f-8195-a89329d218ea",

"version64": "145241946983074840",

"required": true

},
{
"name": "BG3-Community-Library",

"uuid": "11111111-2222-3333-4444-55555555clb1",

"required": true

}
],
"catalogAssets": {

"iconClass": "VORGX_ICON_CLASS_GENERIC",

"banner": "VORGX_BANNER_GENERIC",

"screenshotHandles": []

},
"packaging": {

"moduleFolder": "VORGX_GenericClass",

"publicFolder": "Public/VORGX_GenericClass",

"localizationFolder": "Localization",

"authorUrl": "https://nexusmods.com/users/000000000",

"readmeFile": "README.md",

"license": "MIT"

},
"links": {

"homepage": "",

"issueTracker": "",

"discord": ""

},
"tags": [

"Class",

"Add-Only",

"CommunityLibrary",

"Level20"

]
}
3) Mod Basics & Details

What this section does

Defines the human framing and operational guard-rails of the mod: the pitch, goals, scope/out-of-scope, target
fantasy and uniqueness, supported languages, load-order guidance, start-of-game setup (e.g., starting gear

policy), and documentation links. Nothing here creates gameplay data directly; it informs later authoring (Catalog,
Progression, Localization) and drives what the README/Workshop page and in-game long descriptions should say.

Authoring (drop-in JSON)

Paste under Mod Basics & Details. Keep booleans/numbers as real types; no comments inside values.

{
"modBasics": {

"overview": {

"short": "Add-only BG3 class template to level 20 with Community Library alignment.",

"long": "This blueprint produces a fully wired, add-only BG3 class with subclasses, resources, tier gates, and a

clean multi-row progression table. It targets the Patch 8 level-20 curve, integrates Community Library conventions,
and ships with validator and export rules to avoid vanilla overwrites."

},
"goals": [

"Create a clean, reusable class blueprint aligned to Community Library.",

"Ship readable progression (multi-row per level) with human labels.",

"Maintain add-only authoring with strict validations before export."

],
"nonGoals": [

"Editing or overwriting vanilla classes, spells, or feats.",

"Introducing non-deterministic resource math that breaks tooltips."

],
"audience": ["Players who want new classes", "Modders who want a starting scaffold"],

"fantasyPillars": [

"Cohesive class fantasy with subclass-unique mechanics",

"Readable tooltips and grant labels; no raw keys in UI",

"Predictable resource windows (11-cap; +9 upcast budget)"

],
"uniquenessHooks": [

"Tier gates at 3/8/13/18 that unlock subclass-defining mechanics",

"Optional external caster progression support when needed"

],
"languages": ["en-US"],

"saveCompatibility": {

"safeToAddMidPlaythrough": true,

"safeToRemove": false,

"notes": "Removing mid-save can orphan features and cause issues."

},
"loadOrder": {

"hint": "After Community Library; before content packs that depend on this class",

"conflictNotes": "Add-only; should not conflict unless another mod reuses identical keys."

},

"startingGearPolicy": {

"enabled": true,

"variantBySubclass": true,

"notes": "Subclass-flavoured starter kits allowed if they do not grant permanent power spikes."

},
"uiPolicy": {

"requireDisplayText": true,

"tokensInUI": false,

"maxShortDescriptionChars": 80

},
"documentation": {

"readme": "README.md",

"changelog": "CHANGELOG.md",

"wiki": ""

},
"supportLinks": {

"issues": "",

"discord": "",

"homepage": ""

},
"accessibility": {

"colorSafeUI": true,

"avoidRelianceOnAudioCues": true,

"tooltipsExplainScaling": true

}
}
}
Field-by-field (what each drives)

modBasics.overview.short / long — The copy used for Steam/Workshop/Nexus and for the in-document
header; also feeds README.md stubs.
modBasics.goals / nonGoals — Guidance for reviewers and future contributors; validator can echo these
when a change would violate them.
modBasics.audience — Helps shape tone in docs and long tooltips (e.g., more explanation for player-facing
features).
modBasics.fantasyPillars — High-level design constraints referenced when writing subclass mechanics and
Tier text.
modBasics.uniquenessHooks — One-line differentiators you’ll echo in subclass “keystone” notes and
feature notes.
modBasics.languages — Seeds localization scaffolding (creates .loca stubs for listed languages).
modBasics.saveCompatibility — Shows add/remove safety flags in README and warns at export if set
inconsistently.
modBasics.loadOrder.hint / conflictNotes — Prints into README and optional mod-settings info; helps
players order mods correctly.
modBasics.startingGearPolicy.enabled / variantBySubclass / notes — If true, exporter will look for starter
gear rows (per subclass if enabled).
modBasics.uiPolicy.requireDisplayText — Enforces presence of uiName, grantLabel, and descriptionShort
in Catalog entries.
modBasics.uiPolicy.tokensInUI — If false, renderer rejects raw token IDs in player-facing text.
modBasics.uiPolicy.maxShortDescriptionChars — Lints descriptionShort length for tooltips.
modBasics.documentation.readme / changelog / wiki — File names/links surfaced in the Export and Meta
sections.
modBasics.supportLinks. * — Mirrors Meta links but is intended for player-facing docs.
modBasics.accessibility. * — Optional rules the validator can check (e.g., color contrast not enforced here,
but a flag to review).
Validation checklist (for this section)

overview.short ≤ ~120 chars; uiPolicy.maxShortDescriptionChars enforced across Catalog.
requireDisplayText = true; no raw keys appear in Progression/Notes.
languages[] non-empty; .loca stubs will be generated for each language.
Load-order hint present; Community Library mentioned if used elsewhere.
startingGearPolicy.enabled consistent with actual starter gear rows (if defined later).
Save-compat notes present (warn on safeToRemove=true unless you’ve tested).
Accessibility flags set (or intentionally omitted) with a brief note.
Common pitfalls & how to avoid them

Verbose short descriptions → Keep descriptionShort within the limit; move detail to long descriptions or
Notes.
Forgetting load-order hints → Players misplace the mod; always include a simple, explicit hint.
Inconsistent starter gear → If variantBySubclass=true, ensure each subclass defines a kit; otherwise set it to
false.
Tokens leaking into UI → With tokensInUI=false, run the validator; it’ll catch raw keys before export.
Ambiguous fantasy pillars → If subclasses drift from the pillars, update pillars or tighten subclass design
before authoring.
Improvement suggestions

Per-locale short-desc limits (some languages need more characters; allow per-language overrides).
Documentation quality gate (block export if README/CHANGELOG are missing).
Telemetry hooks (opt-in anonymous analytics for feature usage during playtesting).
Starter-gear presets (named kits you can reuse across subclasses with small deltas).
Example (filled)

{
"modBasics": {

"overview": {

"short": "Add-only class template to L20 with readable progression and strict validations.",

"long": "A reusable blueprint that generates a fully wired BG3 class up to level 20. It follows Community Library

conventions, renders progression in a multi-row layout with human labels, and enforces add-only authoring
through a validator and export pipeline."

},
"goals": [

"Readable multi-row progression with grant labels.",

"Tier gates at 3/8/13/18 enabling subclass-defining mechanics.",

"Strict add-only authoring; no vanilla overwrites."

],
"nonGoals": [

"Rebalancing vanilla classes or feats.",

"Disrupting base spell slot tables without explicit opt-in."

],
"audience": ["Players", "Modders"],

"fantasyPillars": [

"Subclass-driven identity anchored by tier gates",

"Clear tooltips with scaling explained",

"Predictable resource windows and upcasting budgets"

],
"uniquenessHooks": [

"Optional external caster schema support",

"Subclass-flavoured starter kits (optional)"

],
"languages": ["en-US"],

"saveCompatibility": {

"safeToAddMidPlaythrough": true,

"safeToRemove": false,

"notes": "Do not remove mid-save. Back up saves prior to testing."

},
"loadOrder": {

"hint": "Load after Community Library; before mods that depend on this class.",

"conflictNotes": "Add-only keys; conflicts only if another mod reuses identical keys."

},
"startingGearPolicy": {

"enabled": true,

"variantBySubclass": true,

"notes": "Flavour only, avoid permanent power creep."

},
"uiPolicy": {

"requireDisplayText": true,

"tokensInUI": false,

"maxShortDescriptionChars": 80

},
"documentation": {

"readme": "README.md",

"changelog": "CHANGELOG.md",

"wiki": ""

},
"supportLinks": {

"issues": "",

"discord": "",

"homepage": ""

},
"accessibility": {

"colorSafeUI": true,

"avoidRelianceOnAudioCues": true,

"tooltipsExplainScaling": true

}
}
}
4) Class Details

What this section does

Defines the class chassis: identity keys, HP model (dice or numbers), saving throws, proficiencies, skills list +

choose-N, movement/senses, languages, starter-gear policy hooks, and UI identity handles. No gameplay is
granted here; later sections reference this base.

Authoring (drop-in JSON — GENERIC with tips)

{
"classDetails": {

"identity": {

"classKey": "TODO — Set canonical internal key (e.g., CLASS__)",

"displayName": "TIP — Human name; final text goes in Localization",

"fantasy": "TIP — 1–2 lines describing the chassis (kept generic here)",

"roleTags": ["TIP — Optional labels: Tank|Striker|Controller|Support"],

"primaryAbility": "TIP — STR|DEX|CON|INT|WIS|CHA (drives presets & tooltips)",

"secondaryAbility": "TIP — Optional secondary stat (or leave empty)",

"savingThrows": ["TIP — Choose exactly two abilities", "TIP — e.g., Strength", "TIP — e.g., Constitution"],

"hitDie": "TIP — Dice or number (e.g., d10). Export will normalize.",

"baseHP": "TIP — Starting HP at L1 (dice or number)",

"hpPerLevel": "TIP — HP gained per level (dice or number)"

},

"movement": {

"baseSpeed": 0,

"bonusJump": 0,

"climbSpeed": 0,

"swimSpeed": 0

},
"proficiencies": {

"armour": {

"light": false,

"medium": false,

"heavy": false,

"shields": false

},
"weapons": {

"simple": false,

"martial": false,

"ranged": false,

"finesse": false

},
"tools": ["TIP — Optional list (e.g., ThievesTools)"],

"skills": {

"chooseN": 0,

"list": ["TIP — Add themed skill names; chooseN ≤ list length"]

}
},
"senses": {

"darkvision": 0,

"tremorsense": 0,

"blindsight": 0

},
"languages": ["TIP — Usually empty at class level"],

"startingGear": {

"enabled": false,

"baseKit": ["TIP — If enabled, add gear handles to grant at L1"],

"variantBySubclass": false

},

"restRechargePolicy": {

"shortRestFeatures": ["TIP — Feature keys that recharge on short rest"],

"longRestFeatures": ["TIP — Feature keys that recharge on long rest"]

},
"ui": {

"icon": "TIP — ICON__ (fallback in Preface)",

"colorHint": "TIP — Optional hex for UI tint (e.g., #AABBCC)"

},
"notes": ["TIP — Freeform reminders; non-functional"]

}
}
Field-by-field (what each drives)

identity.* — Canonical keys/UI labels/stat defaults; classKey must match §2 Meta and §14/§15 usage.
movement.* — Base metres; non-zero climb/swim often implies a gated feature later.
proficiencies.* — Default armour/weapon groups, tool list, and skills pick list.
senses/languages — Baseline sensory ranges and languages (classes usually empty).
startingGear.* — If enabled, you must grant items in §14 (per-subclass kits if flagged).
restRechargePolicy.* — Names of features that explicitly recharge; used for sanity checks.
ui.* — Visual hooks; icon must exist or fall back to Preface placeholder.
notes[] — For authoring UIs/docs only.
Validation checklist

classKey matches Meta.ids.classKey exactly.
savingThrows has exactly two valid abilities.
skills.chooseN ≤ skills.list.length.
HP fields use valid dice (e.g., "d10") or positive numbers.
If startingGear.enabled=true, §14 includes gear grants (and per-subclass if flagged).
Icon handle present or Preface placeholder available.
No raw token IDs in player-facing strings if UI policy forbids tokens.
Common pitfalls & how to avoid them

Mismatched classKey → Define once here and reuse everywhere.
Over-broad skill list → Keep it thematic; subclass identity goes to §7.
Dice/number mixups → Pick one style in authoring; rely on export normalization.
Forgotten starter gear → Disable or actually author the grants in §14.
Improvement suggestions

Add bonusProficienciesAtLevels: [] for planned extra proficiencies.
Add conditionalSpeeds (e.g., gains swim at Tier II) and lint against §13/§14.
Add rolePreset (Tank|Striker|Controller|Support) for tooling shortcuts.
Example (filled)

{
"classDetails": {

"identity": {

"classKey": "CLASS_VORGX_GENERIC",

"displayName": "Generic Class",

"fantasy": "Versatile chassis with tier-driven specialisation.",

"roleTags": ["Striker","Support"],

"primaryAbility": "Strength",

"secondaryAbility": "Constitution",

"savingThrows": ["Strength","Constitution"],

"hitDie": "d10",

"baseHP": "10",

"hpPerLevel": "d10"

},
"movement": { "baseSpeed": 9, "bonusJump": 0, "climbSpeed": 0, "swimSpeed": 0 },

"proficiencies": {

"armour": { "light": true, "medium": true, "heavy": false, "shields": true },

"weapons": { "simple": true, "martial": true, "ranged": true, "finesse": true },

"tools": [],

"skills": { "chooseN": 2, "list": ["Athletics","Perception","Insight","Acrobatics","Intimidation","Survival","History"] }

},
"senses": { "darkvision": 0, "tremorsense": 0, "blindsight": 0 },

"languages": [],

"startingGear": { "enabled": true, "baseKit":
["GEAR_VORGX_GENERIC_MELEE","GEAR_VORGX_GENERIC_RANGED"], "variantBySubclass": true },

"restRechargePolicy": { "shortRestFeatures": [], "longRestFeatures": [] },

"ui": { "icon": "VORGX_ICON_CLASS_GENERIC", "colorHint": "#C8D1FF" },

"notes": ["Subclass unlock at level 1; tier gates at 3/8/13/18."]

}
}
5) Class Core Abilities

What this section does

Defines shared, class-wide Catalog content (evergreen passives, stance toggles + statuses, class-wide choice

feats). Do not place subclass-specific mechanics here—those live in §7 and are granted in §14.

Authoring (drop-in JSON — GENERIC with tips)

{
"classCore": {

"skillBias": {

"primary": ["TIP — Suggest 1–3 skills (advisory only)"],

"secondary": ["TIP — Suggest 1–3 skills (advisory only)"],

"notes": "TIP — This guides UI suggestions; enforcement is in §4/§14."

},
"builders": [

"TIP — Leave empty unless a builder is truly shared by ALL subclasses"

],
"spenders": [

"TIP — Leave empty unless a spender is truly shared by ALL subclasses"

],
"passives": [

{
"key": "PASSIVE___CORE_ACCURACY",

"uiName": "TIP — Short, readable name",

"grantLabel": "TIP — What shows in the Progression table (e.g., +1 to hit)",

"descriptionShort": "TIP — ≤80 chars one-liner for tooltip",

"notesAtAcquisition": ["TIP — Bullets shown the first time this appears"],

"modifiers": [

{ "type": "TIP — e.g., AttackRollBonus", "value": 1, "condition": "TIP — e.g., ProficientWeapon" }

],
"tags": ["Passive","Core"],

"ui": { "icon": "TIP — ICON___PASSIVE" }

}
],
"toggles": [

{
"key": "TOGGLE___STANCE_DEFENSIVE",

"uiName": "TIP — Defensive Stance",

"grantLabel": "TIP — e.g., Stance — +AC; −Move; cancels Offensive",

"descriptionShort": "TIP — 1 line: what the stance does",

"notesAtAcquisition": ["TIP — Mutually exclusive with Offensive stance"],

"actionType": "TIP — BonusAction|Action|Free",

"cooldown": 0,

"toggleGroup": "STANCES___CORE",

"exclusiveWith": ["TOGGLE___STANCE_OFFENSIVE"],

"applies": [

{ "status": "STATUS___STANCE_DEFENSIVE", "duration": "Toggle" }

],
"removes": [],

"tags": ["Stance","Defense"],

"ui": { "icon": "TIP — ICON___STANCE_DEF" }

},
{
"key": "TOGGLE___STANCE_OFFENSIVE",

"uiName": "TIP — Offensive Stance",

"grantLabel": "TIP — e.g., Stance — +Dmg; −AC; cancels Defensive",

"descriptionShort": "TIP — 1 line: what the stance does",

"notesAtAcquisition": ["TIP — Mutually exclusive with Defensive stance"],

"actionType": "TIP — BonusAction|Action|Free",

"cooldown": 0,

"toggleGroup": "STANCES___CORE",

"exclusiveWith": ["TOGGLE___STANCE_DEFENSIVE"],

"applies": [

{ "status": "STATUS___STANCE_OFFENSIVE", "duration": "Toggle" }

],
"removes": [],

"tags": ["Stance","Offense"],

"ui": { "icon": "TIP — ICON___STANCE_OFF" }

}
],
"statuses": [

{
"key": "STATUS___STANCE_DEFENSIVE",

"uiName": "TIP — Defensive Stance",

"grantLabel": "Status",

"descriptionShort": "TIP — What bonuses/penalties apply while toggled",

"bonuses": [

{ "type": "TIP — e.g., AC", "value": 1 },

{ "type": "TIP — e.g., MoveSpeed", "value": -2 }

],
"stacking": "Replace",

"tags": ["Status","Defense"]

},
{
"key": "STATUS___STANCE_OFFENSIVE",

"uiName": "TIP — Offensive Stance",

"grantLabel": "Status",

"descriptionShort": "TIP — What bonuses/penalties apply while toggled",

"bonuses": [

{ "type": "TIP — e.g., DamageRollBonus", "valueDice": "1d4", "scope": "TIP — e.g., Weapon" },

{ "type": "TIP — e.g., AC", "value": -1 }

],
"stacking": "Replace",

"tags": ["Status","Offense"]

}
],
"feats": [

{
"key": "FEAT___COMBAT_STYLE",

"uiName": "TIP — Combat Style",

"grantLabel": "Feat — choose 1 style",

"descriptionShort": "TIP — One-liner; choice UI will show options",

"notesAtAcquisition": ["TIP — Choice list key must exist"],

"choiceListKey": "CHOICE___STYLES",

"tags": ["Feat","Choice"],

"ui": { "icon": "TIP — ICON___FEAT_STYLE" }

}
]
}
}
Field-by-field (what each drives)

skillBias — Suggests skills in UIs (non-binding).
builders / spenders — Keep empty unless truly shared across all subclasses.
passives — Always-on class-wide effects; use typed modifiers.
toggles / statuses — Shared stance framework; ensure mutual exclusivity via toggleGroup and
exclusiveWith.
feats — Global choice hooks; define the CHOICE_* list elsewhere (e.g., §8 or §14).
Validation checklist

All keys are namespaced and add-only.
Every record has uiName, grantLabel, descriptionShort (no raw keys in §15).
descriptionShort ≤ 80 chars (policy default).
Stances share a single toggleGroup and list each other in exclusiveWith.
Any CHOICE_* key resolves to a defined list before granting in §14.
No subclass-specific keys appear here (those belong in §7).
Common pitfalls & how to avoid them

Subclass leakage → Move unique mechanics to the appropriate §7 catalog.
Unclear table rows → Always set grantLabel so §15 reads cleanly.
Broken stance logic → Use one toggleGroup and reciprocal exclusiveWith.
Improvement suggestions

Add variantsByTier for shared abilities that scale at 3/8/13/18.
Standardise tags (Passive, Stance, Status, Feat) to power renderer filters/lints.
If stances aren’t part of this class fantasy, replace with your global mechanic template.
Example (filled)

{
"classCore": {

"skillBias": {

"primary": ["Athletics","Perception"],

"secondary": ["Insight","Survival"],

"notes": "Used by suggestions; not enforced."

},
"builders": [],

"spenders": [],

"passives": [

{
"key": "PASSIVE_VORGX_GENERIC_CORE_ACCURACY",

"uiName": "Core Accuracy",

"grantLabel": "Passive — +1 to hit (proficient)",

"descriptionShort": "Gain +1 to attack rolls with proficient weapons.",

"modifiers": [{ "type": "AttackRollBonus", "value": 1, "condition": "ProficientWeapon" }]

}
],
"toggles": [

{
"key": "TOGGLE_VORGX_GENERIC_STANCE_DEFENSIVE",

"uiName": "Defensive Stance",

"grantLabel": "Stance — +1 AC; −2 m move",

"descriptionShort": "Brace for defense at the cost of mobility.",

"actionType": "BonusAction",

"toggleGroup": "STANCES_VORGX_GENERIC_CORE",

"exclusiveWith": ["TOGGLE_VORGX_GENERIC_STANCE_OFFENSIVE"],

"applies": [{ "status": "STATUS_VORGX_GENERIC_STANCE_DEFENSIVE", "duration": "Toggle" }]

}
],
"statuses": [

{
"key": "STATUS_VORGX_GENERIC_STANCE_DEFENSIVE",

"uiName": "Defensive Stance",

"grantLabel": "Status",

"descriptionShort": "+1 AC, −2 m movement.",

"bonuses": [{ "type": "AC", "value": 1 }, { "type": "MoveSpeed", "value": -2 }],

"stacking": "Replace"

}
],
"feats": [

{
"key": "FEAT_VORGX_GENERIC_COMBAT_STYLE",

"uiName": "Combat Style",

"grantLabel": "Feat — choose 1 style",

"descriptionShort": "Choose a combat style from a predefined list.",

"choiceListKey": "CHOICE_VORGX_GENERIC_STYLES"

}
]
}
}
6) Subclass Details

What this section does

Declares each subclass slot your class supports and wires pointers used by:

§7 (per-subclass catalogs),
§13 (tier effects text),
§14–15 (progression & rendered table),
§9/§10/§11 (resources/casting if applicable).
No abilities live here; this is the index and wiring layer.

Authoring (drop-in JSON — GENERIC with tips)

{
"subclassDetails": {

"unlockLevel": 1,

"chooseOneAtUnlock": true,

"allowRespec": true,

"list": [

{
"key": "SUBCLASS___A",

"displayName": "TIP — UI name; actual copy in Localization",

"fantasy": "TIP — 1–2 lines; optional (localize later)",

"roleTags": ["TIP — e.g., Tank|Striker|Controller|Support"],

"primaryAbilityOverride": "TIP — Optional override (e.g., STR/DEX/CON/INT/WIS/CHA)",

"secondaryAbilityOverride": "TIP — Optional override or leave empty",

"savingThrowsOverride": ["TIP — Optional extra/provisional save", "TIP — or leave empty"],

"proficiencyOverrides": {

"armour": { "TIP": "Only list booleans you change (e.g., "heavy": true)" },

"weapons": { "TIP": "Only list booleans you change (e.g., "martial": true)" }

},
"resourceHint": {

"name": "TIP — Resource label (e.g., Rage/Resolve/Tempo)",

"type": "Pips",

"cap": 11,

"upcastMax": 9

},
"casterHint": { "isCaster": false, "model": "TIP — Full|Half|Third|null" },

"startingGearFlavor": { "enabled": false, "kitKey": "TIP — GEAR_<...> if enabled" },

"ui": { "icon": "ICON___SUB_A", "colorHint": "TIP — Optional hex" },

"notes": ["TIP — Freeform reminders for authoring tools (non-functional)"],

"catalogPointer": { "section7Block": "SUBCLASS_A" },

"tierTextPointer": { "section13Block": "SUBCLASS_A" }

},
{
"key": "SUBCLASS___B",

"displayName": "TIP — UI name",

"fantasy": "TIP — 1–2 lines; optional",

"roleTags": ["TIP — labels"],

"primaryAbilityOverride": "TIP — Optional",

"secondaryAbilityOverride": "TIP — Optional",

"savingThrowsOverride": [],

"proficiencyOverrides": { "armour": {}, "weapons": {} },

"resourceHint": { "name": "TIP — Resource name", "type": "Pips", "cap": 11, "upcastMax": 9 },

"casterHint": { "isCaster": false, "model": null },

"startingGearFlavor": { "enabled": false, "kitKey": "" },

"ui": { "icon": "ICON___SUB_B", "colorHint": "" },

"notes": [],

"catalogPointer": { "section7Block": "SUBCLASS_B" },

"tierTextPointer": { "section13Block": "SUBCLASS_B" }

},
{
"key": "SUBCLASS___C",

"displayName": "TIP — UI name",

"fantasy": "TIP — 1–2 lines; optional",

"roleTags": [],

"primaryAbilityOverride": "",

"secondaryAbilityOverride": "",

"savingThrowsOverride": [],

"proficiencyOverrides": { "armour": {}, "weapons": {} },

"resourceHint": { "name": "", "type": "Pips", "cap": 11, "upcastMax": 9 },

"casterHint": { "isCaster": false, "model": null },

"startingGearFlavor": { "enabled": false, "kitKey": "" },

"ui": { "icon": "ICON___SUB_C", "colorHint": "" },

"notes": [],

"catalogPointer": { "section7Block": "SUBCLASS_C" },

"tierTextPointer": { "section13Block": "SUBCLASS_C" }

}
]
}
}
Field-by-field (what each drives)

unlockLevel / chooseOneAtUnlock / allowRespec — When selection happens, whether only one is chosen,
and if respec allows switching.
list[] — One entry per subclass slot (keys must be unique & namespaced).
key — Canonical SUBCLASS_* used to scope §14 grants and to name §7 catalog blocks.
displayName / fantasy / roleTags — Player-facing labels; actual strings should be localized.
primary/secondaryAbilityOverride — Optional stat emphasis; affects presets/tooltip math (doesn’t
auto-grant).
savingThrowsOverride — Optional additional save proficiencies; keep empty unless the chassis
changes.
proficiencyOverrides.armour/weapons — Only specify booleans you’re changing (delta vs class base).
resourceHint — Non-authoritative hint for §9; validator checks naming/caps vs actual resource
definition.
casterHint — If isCaster=true, §10/§11 must define lists/model/resources for this subclass.
startingGearFlavor — If enabled, you must grant kitKey in §14 for this subclass.
ui.icon/colorHint — Handles; icon should exist or fall back to §1 placeholder.
catalogPointer.section7Block / tierTextPointer.section13Block — Must resolve to blocks in §7/§13.
Validation checklist (for this section)

unlockLevel matches project policy (default 1).
At least 3 entries in list (or as configured in §1).
All key values are unique and namespaced.
Every catalogPointer and tierTextPointer resolves to an existing §7/§13 block.
If any casterHint.isCaster=true, corresponding §10/§11 entries exist.
resourceHint.cap <= 11 and resourceHint.upcastMax <= 9 (unless §1 changes global policy).
If startingGearFlavor.enabled=true, §14 contains a grant for kitKey at the intended level.
Common pitfalls & how to avoid them

Dangling pointers → Create §7 and §13 blocks first (or fail validation until they exist).
Subclass leakage → Keep all subclass-unique abilities in that subclass’s §7 catalog (namespaced
accordingly).
Icon gaps → Provide a temporary icon; otherwise rely on §1 placeholder to avoid blank UI.
Caster mismatch → If isCaster=true, finish §10/§11 for that subclass before export.
Improvement suggestions

Add hasKeystoneAt: [9,13,18] to lint major spikes in §14.
Add tags: [] (freeform) to help renderer colour-code rows in §15.
Add difficultyHint: "Easy|Baseline|Hard" for internal balancing notes (non-functional).
Example (filled — flavour OK)

{
"subclassDetails": {

"unlockLevel": 1,

"chooseOneAtUnlock": true,

"allowRespec": true,

"list": [

{

"key": "SUBCLASS_VORGX_BERSERKER",

"displayName": "Berserker",

"fantasy": "Relentless melee bruiser who converts fury into brutal finishers.",

"roleTags": ["Striker","Bruiser"],

"primaryAbilityOverride": "Strength",

"secondaryAbilityOverride": "Constitution",

"savingThrowsOverride": [],

"proficiencyOverrides": { "armour": { "heavy": false }, "weapons": { "martial": true } },

"resourceHint": { "name": "Rage", "type": "Pips", "cap": 11, "upcastMax": 9 },

"casterHint": { "isCaster": false, "model": null },

"startingGearFlavor": { "enabled": true, "kitKey": "GEAR_VORGX_BERS_STARTER" },

"ui": { "icon": "VORGX_ICON_SUB_BERSERKER", "colorHint": "#F35A4B" },

"notes": ["Damage windows via spenders; control spikes later."],

"catalogPointer": { "section7Block": "BERSERKER" },

"tierTextPointer": { "section13Block": "BERSERKER" }

},
{
"key": "SUBCLASS_VORGX_SENTINEL",

"displayName": "Sentinel",

"fantasy": "Guardian who channels resolve into wards and counters.",

"roleTags": ["Tank","Controller"],

"primaryAbilityOverride": "Constitution",

"secondaryAbilityOverride": "Strength",

"savingThrowsOverride": ["Constitution"],

"proficiencyOverrides": { "armour": { "heavy": true, "shields": true }, "weapons": { "martial": true } },

"resourceHint": { "name": "Resolve", "type": "Pips", "cap": 11, "upcastMax": 9 },

"casterHint": { "isCaster": false, "model": null },

"startingGearFlavor": { "enabled": true, "kitKey": "GEAR_VORGX_SENT_STARTER" },

"ui": { "icon": "VORGX_ICON_SUB_SENTINEL", "colorHint": "#7BB2FF" },

"notes": ["Counters/taunts; warding finishers."],

"catalogPointer": { "section7Block": "SENTINEL" },

"tierTextPointer": { "section13Block": "SENTINEL" }

},
{
"key": "SUBCLASS_VORGX_WARCHANT",

"displayName": "Warchant",

"fantasy": "Battle skald who weaves light casting with martial rhythms.",

"roleTags": ["Support","Striker"],

"primaryAbilityOverride": "Charisma",

"secondaryAbilityOverride": "Strength",

"savingThrowsOverride": ["Charisma"],

"proficiencyOverrides": { "armour": { "medium": true, "shields": true }, "weapons": { "finesse": true, "ranged":
true } },

"resourceHint": { "name": "Tempo", "type": "Pips", "cap": 11, "upcastMax": 9 },

"casterHint": { "isCaster": true, "model": "Half" },

"startingGearFlavor": { "enabled": true, "kitKey": "GEAR_VORGX_WAR_STARTER" },

"ui": { "icon": "VORGX_ICON_SUB_WARCHANT", "colorHint": "#E8C457" },

"notes": ["Buffs/sonic themes; martial weave."],

"catalogPointer": { "section7Block": "WARCHANT" },

"tierTextPointer": { "section13Block": "WARCHANT" }

}
]
}
}
7) Subclass Core Abilities

(Builders; Spenders; Passives; Spells; Feats; Auras/Stances; Skill Bias)

What this section does

Creates a full, isolated catalog for each subclass. These catalogs contain everything unique to that subclass
(builders, spenders, passives, stances/auras, statuses, spells, feats, choice lists). Nothing is granted here directly

—§14 (Progression authoring) will grant these keys with rows scoped by subclass. The §6
catalogPointer.section7Block must match each block’s blockId below.

Authoring (drop-in JSON — GENERIC with tips)

(Keep types native; use your namespace & class prefix. No flavour in Authoring.)

{
"subclassCatalogs": [

{
"blockId": "SUBCLASS_A",

"subclassKey": "SUBCLASS___A",

"skillBias": {

"primary": ["TIP — 1–3 skills this subclass nudges toward"],

"secondary": ["TIP — 1–3 backup skills for suggestions"],

"notes": "TIP — Advisory only; enforcement via §4.skills and §14 grants."

},
"builders": [

{
"key": "ACTION___A_BUILDER_01",

"uiName": "TIP — Short name for builder",

"grantLabel": "TIP — e.g., Builder — on-hit +2 ",

"descriptionShort": "TIP — ≤80 chars one-liner of effect",

"notesAtAcquisition": ["TIP — Bullets shown on first acquisition (e.g., crit bonus)"],

"actionType": "TIP — Action|BonusAction|Reaction|Free",

"usesPerTurn": 1,

"cooldown": 0,

"rangeMeters": 1.5,

"targeting": "TIP — SingleEnemy|Cone|Self|Area",

"attackRollStat": "TIP — STR|DEX|INT|WIS|CHA or leave empty",

"save": "TIP — e.g., CON|DEX|WIS or null",

"damage": { "formula": "TIP — Weapon|XdY + STAT|none" },

"onHit": {

"buildResource": {

"resource": "TIP — Must match §9 resource name",

"amount": 2,

"critBonus": 1

}
},
"tags": ["Builder", "TIP — e.g., Melee|Ranged|Spell"],

"ui": { "icon": "TIP — ICON_<...>" }

}
],
"spenders": [

{
"key": "ACTION___A_SPENDER_01",

"uiName": "TIP — Short name for spender",

"grantLabel": "TIP — e.g., Finisher — spend 3–11 (upcast +9)",

"descriptionShort": "TIP — What spending does; state scaling/upcast briefly",

"notesAtAcquisition": ["TIP — Base cost, upcast per-pip effect, throttle if any"],

"actionType": "TIP — Action|BonusAction|Reaction|Free",

"usesPerTurn": 1,

"cooldown": 0,

"rangeMeters": 1.5,

"targeting": "TIP — SingleEnemy|Area|Self|Ally",

"attackRollStat": "TIP — or null",

"save": "TIP — or null",

"concentration": false,

"damage": {

"formula": "TIP — e.g., 2d8 + STAT|none",

"extra": { "perExtraPip": "TIP — e.g., 1d6|+1|+10%", "maxExtraPips": 9 }

},
"applies": [

{ "status": "STATUS___A_EFFECT_01", "duration": "TIP — 2t|3t|Toggle|UntilRest" }

],
"spendResource": {

"resource": "TIP — Must match §9",

"base": 3,

"upcastMax": 9,

"windowCap": 11

},
"tags": ["Spender", "TIP — e.g., Upcast|Control|Defense"],

"ui": { "icon": "TIP — ICON_<...>" }

}
],
"passives": [

{
"key": "PASSIVE___A_01",

"uiName": "TIP — Passive name",

"grantLabel": "Passive — TIP summary",

"descriptionShort": "TIP — ≤80 chars summary",

"notesAtAcquisition": ["TIP — Clarify scope (proficient only? weapon only?)"],

"modifiers": [

{ "type": "TIP — e.g., AttackRollBonus|AC|CritRange", "value": 1, "condition": "TIP — optional condition" }

],

"tags": ["Passive", "Subclass"],

"ui": { "icon": "TIP — ICON_<...>" }

}
],
"toggles": [

{
"key": "TOGGLE___A_STANCE_01",

"uiName": "TIP — Stance/Aura name",

"grantLabel": "Stance — TIP summary",

"descriptionShort": "TIP — ≤80 chars",

"notesAtAcquisition": ["TIP — Mutually exclusive with other stances if relevant"],

"actionType": "TIP — BonusAction|Action|Free",

"cooldown": 0,

"toggleGroup": "STANCES___A",

"exclusiveWith": ["TOGGLE___A_STANCE_02"],

"applies": [{ "status": "STATUS___A_STANCE_01", "duration": "Toggle" }],

"removes": [],

"tags": ["Stance", "Subclass"],

"ui": { "icon": "TIP — ICON_<...>" }

}
],
"statuses": [

{
"key": "STATUS___A_STANCE_01",

"uiName": "TIP — Status name",

"grantLabel": "Status",

"descriptionShort": "TIP — What it does while active",

"bonuses": [

{ "type": "TIP — e.g., AC|DamageRollBonus|SavingThrowBonus", "value": 1 },

{ "type": "TIP — e.g., MoveSpeed|ResistAll|Vulnerability", "value": -2 }

],
"stacking": "Replace",

"tags": ["Status", "Subclass"]

}
],
"feats": [

{
"key": "FEAT___A_PICK_01",

"uiName": "TIP — Subclass choice or feat",

"grantLabel": "Feat — choose 1",

"descriptionShort": "TIP — One-liner; options come from choice list",

"notesAtAcquisition": ["TIP — Indicate any restrictions or synergy"],

"choiceListKey": "CHOICE___A_LIST_01",

"tags": ["Feat", "Choice"],

"ui": { "icon": "TIP — ICON_<...>" }

}
],
"spells": {

"castingModel": "TIP — None|Half|Full|Third|Custom (if this subclass casts)",

"castingAbility": "TIP — INT|WIS|CHA (if casting is enabled)",

"spellLists": ["TIP — External list tags if using external schema (e.g., Cleric, Bard)"],

"known": ["TIP — SPELL_<...> keys or leave empty if granted via feats/actions"],

"prepared": ["TIP — SPELL_<...> keys if prepared model"],

"tags": ["TIP — e.g., Buff|Debuff|Control|Damage"],

"notes": "TIP — Keep concentration and durations sane; match §10–§11 if using casting"

}
},
{
"blockId": "SUBCLASS_B",

"subclassKey": "SUBCLASS___B",

"skillBias": { "primary": [], "secondary": [], "notes": "" },

"builders": [],

"spenders": [],

"passives": [],

"toggles": [],

"statuses": [],

"feats": [],

"spells": { "castingModel": "None", "castingAbility": "", "spellLists": [], "known": [], "prepared": [], "tags": [],

"notes": "" }

},
{
"blockId": "SUBCLASS_C",

"subclassKey": "SUBCLASS___C",

"skillBias": { "primary": [], "secondary": [], "notes": "" },

"builders": [],

"spenders": [],

"passives": [],

"toggles": [],

"statuses": [],

"feats": [],

"spells": { "castingModel": "None", "castingAbility": "", "spellLists": [], "known": [], "prepared": [], "tags": [],
"notes": "" }

}
]
}
Field-by-field (what each drives)

blockId — Anchor that §6 catalogPointer.section7Block must reference exactly.
subclassKey — Canonical SUBCLASS_* key; used by §14 to scope grant rows.
skillBias — Suggests skills in UIs (non-binding).
builders — Actions that generate the subclass resource on hits/conditions.
onHit.buildResource.resource must match the resource defined for this subclass in §9.
spenders — Actions that consume the subclass resource; support upcasting via base + upcastMax ≤
windowCap.
passives — Always-on subclass effects; use typed modifiers.
toggles / statuses — Auras/stances unique to the subclass; ensure mutual exclusivity via toggleGroup +
exclusiveWith.
feats — Subclass-specific choice hooks; options are provided via choiceListKey.
spells — Casting metadata for this subclass if applicable (high-level; §10–§11 will formalise casting & slot
mechanics).
ui/icon fields & display text — Each record intended for the UI should define uiName, grantLabel,
descriptionShort, and optional notesAtAcquisition[].
Validation checklist

Every blockId is unique and referenced by §6.
All keys are namespaced and add-only.
No class-core keys appear here (keep §5 strictly global).
For each subclass that uses a resource:
All builders[].onHit.buildResource.resource and spenders[].spendResource.resource match the §9
resource name.
base + upcastMax ≤ windowCap and windowCap ≤ global cap if §1 sets one (e.g., 11).
Every UI-facing record has uiName, grantLabel, descriptionShort (≤ 80 chars policy).
choiceListKey values resolve to defined lists (in §8 or §14).
If spells.castingModel != "None", §10–§11 provide the casting schema and resources.
Common pitfalls & how to avoid them

Cross-subclass leakage → Prefix keys per subclass (e.g., _A_, _B_) and scope grants by subclass in §14.
Dangling resources → Don’t invent resource names here; define them in §9 and reference them consistently.
Upcast overflow → Keep base + upcastMax within the resource window; validator should flag excess.
Missing display text → Always populate uiName, grantLabel, descriptionShort to keep §15 readable.
Inconsistent stances → Use one toggleGroup per stance family and reciprocal exclusiveWith.
Improvement suggestions

Add variantsByTier per ability to scale at 3/8/13/18 automatically.
Add keywords/tags consistently (Builder, Spender, Stance, Control, Defense, Damage) to power renderer
filters and lints.
Break large catalogs into multiple files on disk (exporter can merge) while keeping single-source §7 truth here.
For casters, add subclassSpellListKey to reference a consolidated list in §10.
Example (filled — flavour OK)

{
"subclassCatalogs": [

{
"blockId": "BERSERKER",

"subclassKey": "SUBCLASS_VORGX_BERSERKER",

"skillBias": { "primary": ["Athletics"], "secondary": ["Intimidation"], "notes": "Melee pressure focus." },

"builders": [

{
"key": "ACTION_VORGX_BERS_RAGING_STRIKE",

"uiName": "Raging Strike",

"grantLabel": "Builder — on-hit +2 Rage",

"descriptionShort": "Melee strike that builds Rage on hit.",

"notesAtAcquisition": ["On Hit: +2 Rage (crit: +3)."],

"actionType": "Action",

"usesPerTurn": 1,

"rangeMeters": 1.5,

"targeting": "SingleEnemy",

"attackRollStat": "Strength",

"damage": { "formula": "Weapon" },

"onHit": { "buildResource": { "resource": "Rage", "amount": 2, "critBonus": 1 } },

"tags": ["Builder","Melee","Weapon"]

}
],
"spenders": [

{
"key": "ACTION_VORGX_BERS_BLOODLETTING_FINISHER",

"uiName": "Bloodletting Finisher",

"grantLabel": "Finisher — spend 3–11 Rage (upcast +9)",

"descriptionShort": "Heavy finisher scaling per Rage spent.",

"actionType": "Action",

"usesPerTurn": 1,

"rangeMeters": 1.5,

"targeting": "SingleEnemy",

"attackRollStat": "Strength",

"damage": { "formula": "2d8 + STR", "extra": { "perExtraPip": "1d6", "maxExtraPips": 9 } },

"spendResource": { "resource": "Rage", "base": 3, "upcastMax": 9, "windowCap": 11 },

"tags": ["Spender","Upcast","Melee"]

}
],
"passives": [

{
"key": "PASSIVE_VORGX_BERS_BLOOD_FERVOR",

"uiName": "Blood Fervor",

"grantLabel": "Passive — +1 dmg vs. Bleeding",

"descriptionShort": "Deal +1 damage to Bleeding enemies.",

"modifiers": [{ "type": "DamageRollBonus", "value": 1, "condition": "TargetHasStatus(Bleeding)" }]

}

],
"toggles": [],

"statuses": [],

"feats": [],

"spells": { "castingModel": "None", "castingAbility": "", "spellLists": [], "known": [], "prepared": [], "tags": [],
"notes": "" }

},
{
"blockId": "SENTINEL",

"subclassKey": "SUBCLASS_VORGX_SENTINEL",

"skillBias": { "primary": ["Perception"], "secondary": ["Insight"], "notes": "Guard/control lean." },

"builders": [

{
"key": "ACTION_VORGX_SENT_GUARDIAN_STRIKE",

"uiName": "Guardian Strike",

"grantLabel": "Builder — on-hit +2 Resolve",

"descriptionShort": "Strike that builds Resolve on hit.",

"actionType": "Action",

"usesPerTurn": 1,

"rangeMeters": 1.5,

"targeting": "SingleEnemy",

"attackRollStat": "Strength",

"damage": { "formula": "Weapon" },

"onHit": { "buildResource": { "resource": "Resolve", "amount": 2 } }

}
],
"spenders": [

{
"key": "ACTION_VORGX_SENT_WARDING_FINISHER",

"uiName": "Warding Finisher",

"grantLabel": "Finisher — spend 3–11 Resolve",

"descriptionShort": "Defensive finisher applying Warded.",

"actionType": "Action",

"applies": [{ "status": "STATUS_VORGX_SENT_WARDED", "duration": "2t" }],

"spendResource": { "resource": "Resolve", "base": 3, "upcastMax": 9, "windowCap": 11 }

}
],
"passives": [],

"toggles": [],

"statuses": [

{
"key": "STATUS_VORGX_SENT_WARDED",

"uiName": "Warded",

"grantLabel": "Status",

"descriptionShort": "+1 AC and resist slashing.",

"bonuses": [

{ "type": "AC", "value": 1 },

{ "type": "ResistPhysicalSlashing", "value": 1 }

],
"stacking": "Replace"

}
],
"feats": [],

"spells": { "castingModel": "None", "castingAbility": "", "spellLists": [], "known": [], "prepared": [], "tags": [],

"notes": "" }

},
{
"blockId": "WARCHANT",

"subclassKey": "SUBCLASS_VORGX_WARCHANT",

"skillBias": { "primary": ["Performance"], "secondary": ["Persuasion"], "notes": "Buff/sonic weave." },

"builders": [

{
"key": "ACTION_VORGX_WAR_TEMPO_STRIKE",

"uiName": "Tempo Strike",

"grantLabel": "Builder — on-hit +2 Tempo",

"descriptionShort": "Weapon hit fuels Tempo.",

"actionType": "Action",

"onHit": { "buildResource": { "resource": "Tempo", "amount": 2 } }

}
],
"spenders": [

{
"key": "ACTION_VORGX_WAR_BOOMING_FINISHER",

"uiName": "Booming Finisher",

"grantLabel": "Finisher — spend 3–11 Tempo",

"descriptionShort": "Thunderous strike scaling with Tempo spent.",

"actionType": "Action",

"damage": { "formula": "1d8 Thunder", "extra": { "perExtraPip": "1d4 Thunder", "maxExtraPips": 9 } },

"spendResource": { "resource": "Tempo", "base": 3, "upcastMax": 9, "windowCap": 11 }

}
],
"passives": [],

"toggles": [],

"statuses": [],

"feats": [],

"spells": {

"castingModel": "Half",

"castingAbility": "Charisma",

"spellLists": ["Bard"],

"known": [],

"prepared": [],

"tags": ["Buff","Thunder"],

"notes": "Light casting, mostly buffs and thunder-flavoured tools."

}
}
]
}
8) Class / Subclass Distribution Presets

What this section does

Defines recommended starting distributions the UI/tools can surface at character creation or respec:

Ability scores (one Default + at least two alternates , each ability between 3–20)
Skill picks (within §4 skills list & choose-N)
Optional presets for Fighting Style / Feat / Known/Prepared Spells (if applicable)
Optional per-subclass overrides (so each subclass can suggest its own spread)
These presets do not grant anything; §14 grants still control actual features. Presets are suggestions for builds and
for auto-filling choices in UIs.

Authoring (drop-in JSON — GENERIC with tips)

{
"presets": {

"abilityScoreRules": {

"min": 3,

"max": 20,

"totalBudgetTip": "TIP — If using a point-buy or array, document here for authors (non-functional)."

},
"classPresets": {

"default": {

"label": "TIP — Name shown in UI (e.g., Default)",

"abilities": {

"STR": "TIP — 3–20",
"DEX": "TIP — 3–20",
"CON": "TIP — 3–20",
"INT": "TIP — 3–20",
"WIS": "TIP — 3–20",
"CHA": "TIP — 3–20"
},
"skills": ["TIP — Up to §4.skills.chooseN; must exist in §4.skills.list"],

"notes": ["TIP — Rationale for this spread (authoring hint; non-functional)"]

},
"alternateA": {

"label": "TIP — Alt A",

"abilities": { "STR": "", "DEX": "", "CON": "", "INT": "", "WIS": "", "CHA": "" },

"skills": ["TIP — Alternative skill set"],

"notes": ["TIP — What this alt optimises"]

},
"alternateB": {

"label": "TIP — Alt B",

"abilities": { "STR": "", "DEX": "", "CON": "", "INT": "", "WIS": "", "CHA": "" },

"skills": [],

"notes": []

}
},
"subclassOverrides": [

{
"subclassKey": "SUBCLASS___A",

"default": {

"label": "TIP — Subclass A Default",

"abilities": { "STR": "", "DEX": "", "CON": "", "INT": "", "WIS": "", "CHA": "" },

"skills": ["TIP — Must stay within §4 list & choose-N"],

"notes": ["TIP — Why this subclass prefers this spread"]

},
"alternateA": {

"label": "TIP — Alt A",

"abilities": { "STR": "", "DEX": "", "CON": "", "INT": "", "WIS": "", "CHA": "" },

"skills": [],

"notes": []

},
"alternateB": {

"label": "TIP — Alt B",

"abilities": { "STR": "", "DEX": "", "CON": "", "INT": "", "WIS": "", "CHA": "" },

"skills": [],

"notes": []

}
},
{
"subclassKey": "SUBCLASS___B",

"default": { "label": "TIP — Subclass B Default", "abilities": { "STR": "", "DEX": "", "CON": "", "INT": "", "WIS": "",

"CHA": "" }, "skills": [], "notes": [] },

"alternateA": { "label": "Alt A", "abilities": { "STR": "", "DEX": "", "CON": "", "INT": "", "WIS": "", "CHA": "" }, "skills": [],
"notes": [] },

"alternateB": { "label": "Alt B", "abilities": { "STR": "", "DEX": "", "CON": "", "INT": "", "WIS": "", "CHA": "" }, "skills": [],
"notes": [] }

}
],
"optionalPicks": {

"fightingStyle": {

"enabled": false,

"choiceListKey": "CHOICE___STYLES",

"preset": "TIP — Optional default option key from the list or empty"

},
"feat": {

"enabled": false,

"choiceListKey": "CHOICE___FEATS",

"preset": "TIP — Optional default feat key or empty"

},
"spells": {

"enabled": false,

"modelTip": "TIP — If subclass is a caster, coordinate with §10–§11",

"known": ["TIP — SPELL_<...> default picks"],

"prepared": ["TIP — SPELL_<...> default prepared (if prepared model)"]

}
}
}
}
Field-by-field (what each drives)

abilityScoreRules.min/max — Validation boundaries for presets; mirrors §1 validator (3–20).
classPresets — Global presets if a user hasn’t picked a subclass yet (or for non-subclass screens).
default / alternateA / alternateB — At least 3 named variants. Tools should highlight Default.
abilities.STR...CHA — Integers in [3,20]. These don’t modify the game; they prefill UI or docs.
skills[] — Must be chosen from §4.skills.list and respect §4.skills.chooseN.
subclassOverrides[] — Per-subclass replacements; same shape as classPresets. When a subclass is
selected, these override the global presets.
optionalPicks — Preselects for choice UIs (styles, feats, spells). They must reference existing choice lists or
spell keys; §14 still does the granting.
Validation checklist (for this section)

All ability values are integers within 3–20 (no strings when finalised).
Every preset defines all six abilities (no omissions).
skills[] entries exist in §4 and do not exceed chooseN.
If optionalPicks.fightingStyle.enabled=true, the choiceListKey exists and §14 grants the style at the right level.
If optionalPicks.spells.enabled=true, subclass/caster settings exist in §10–§11 and keys resolve to valid
spells.
For subclassOverrides[], each subclassKey matches §6 and has exactly three variants (default/A/B).
Common pitfalls & how to avoid them

Inconsistent presets vs. class role → Align Default to §4 primary/secondary ability and §6 overrides.
Skills exceeding choose-N → Count them; tooling should lint, but keep it tight initially.
Preset feat/style keys that don’t exist → Ensure CHOICE_* lists are authored (Section 8C/14) before
enabling.
Subclass overrides missing → If you mark a subclass as a caster or tanky chassis in §6, add matching presets
here.
Improvement suggestions

Add a "tags": ["New Player","Optimised","Off-Meta"] field per preset so the UI can label them.
Support a "recommendedOrder": 1|2|3 for how presets appear in selection UIs.
Add "arrayName": "TIP — e.g., Standard Array 15/14/13/12/10/8" for docs.
Example (filled — flavour OK)

{
"presets": {

"abilityScoreRules": { "min": 3, "max": 20, "totalBudgetTip": "Standard Array style; adjust as desired." },

"classPresets": {

"default": {

"label": "Default",

"abilities": { "STR": 16, "DEX": 12, "CON": 14, "INT": 8, "WIS": 10, "CHA": 10 },

"skills": ["Athletics", "Perception"],

"notes": ["Leans into STR primary; reasonable CON."]

},
"alternateA": {

"label": "Dexterity Focus",

"abilities": { "STR": 10, "DEX": 16, "CON": 14, "INT": 8, "WIS": 12, "CHA": 10 },

"skills": ["Acrobatics", "Perception"],

"notes": ["Ranged/finesse tilt."]

},
"alternateB": {

"label": "Skilled Support",

"abilities": { "STR": 12, "DEX": 12, "CON": 14, "INT": 8, "WIS": 14, "CHA": 10 },

"skills": ["Insight", "Survival"],

"notes": ["More perception/insight utility."]

}
},
"subclassOverrides": [

{
"subclassKey": "SUBCLASS_VORGX_BERSERKER",

"default": {

"label": "Berserker Default",

"abilities": { "STR": 16, "DEX": 12, "CON": 14, "INT": 8, "WIS": 10, "CHA": 10 },

"skills": ["Athletics", "Intimidation"],

"notes": ["Melee pressure & checks."]

},
"alternateA": {

"label": "Durable Bruiser",

"abilities": { "STR": 15, "DEX": 10, "CON": 16, "INT": 8, "WIS": 10, "CHA": 10 },

"skills": ["Athletics", "Survival"],

"notes": ["More CON for sustain."]

},
"alternateB": {

"label": "Precision",

"abilities": { "STR": 14, "DEX": 16, "CON": 14, "INT": 8, "WIS": 10, "CHA": 10 },

"skills": ["Acrobatics", "Perception"],

"notes": ["Finesse lean."]

}
},
{
"subclassKey": "SUBCLASS_VORGX_SENTINEL",

"default": {

"label": "Sentinel Default",

"abilities": { "STR": 14, "DEX": 10, "CON": 16, "INT": 8, "WIS": 12, "CHA": 10 },

"skills": ["Perception", "Insight"],

"notes": ["Guard/control bias."]

},
"alternateA": {

"label": "Shieldwall",

"abilities": { "STR": 12, "DEX": 10, "CON": 17, "INT": 8, "WIS": 12, "CHA": 10 },

"skills": ["Perception", "Athletics"],

"notes": ["Heavier CON for frontline."]

},
"alternateB": {

"label": "Off-Tank",

"abilities": { "STR": 16, "DEX": 10, "CON": 14, "INT": 8, "WIS": 12, "CHA": 10 },

"skills": ["Athletics", "Intimidation"],

"notes": []

}
},
{
"subclassKey": "SUBCLASS_VORGX_WARCHANT",

"default": {

"label": "Warchant Default",

"abilities": { "STR": 12, "DEX": 12, "CON": 14, "INT": 8, "WIS": 10, "CHA": 16 },

"skills": ["Performance", "Persuasion"],

"notes": ["Charisma primary; hybrid melee."]

},
"alternateA": {

"label": "Support Caster",

"abilities": { "STR": 10, "DEX": 12, "CON": 14, "INT": 8, "WIS": 12, "CHA": 16 },

"skills": ["Performance", "Insight"],

"notes": []

},

"alternateB": {

"label": "Aggressive Skald",

"abilities": { "STR": 14, "DEX": 12, "CON": 14, "INT": 8, "WIS": 10, "CHA": 14 },

"skills": ["Athletics", "Performance"],

"notes": []

}
}
],
"optionalPicks": {

"fightingStyle": { "enabled": true, "choiceListKey": "CHOICE_VORGX_GENERIC_STYLES", "preset": "" },

"feat": { "enabled": false, "choiceListKey": "CHOICE_VORGX_GENERIC_FEATS", "preset": "" },

"spells": { "enabled": false, "modelTip": "Subclass-specific in §10–§11", "known": [], "prepared": [] }

}
}
}
9) Class / Subclass Resource & Mechanics

(builders/spenders, caps, windows — now with WoW-style archetypes)

What this section does

Defines every custom resource your class or its subclasses use, and (new) provides a registry of WoW-style

resource archetypes you can attach to each subclass. Archetypes come pre-parameterised
(cap/regen/decay/dual-resource wiring) and can be overridden per subclass.

Authoring (drop-in JSON — GENERIC with tips + WoW archetypes)

Paste this over your current §9. Fill the subclassScoped[].archetypeKey for each subclass, then tweak any
overrides you need.

{
"resources": {

"policy": {

"defaultPipCap": 11,

"defaultUpcastMax": 9,

"notes": "TIP — Pips are great for CP/Holy Power/Soul Shards/Essence; Points for 0–100 bars like Focus/Energy;
Charges for Runes."

},
"archetypes": [

{
"key": "ARCH_WOW_RAGE",

"displayName": "Rage",

"type": "Points",

"cap": 100,

"floor": 0,

"startValue": 0,

"upcastMax": 0,

"regen": { "shortRest": 0, "longRest": "cap", "perTurn": 0, "onCrit": 0, "onKill": 0 },

"decay": { "perTurn": 0, "outOfCombatPerTurn": 5 },

"buildRules": [{ "source": "OnHit", "amount": 10, "critBonus": 5, "conditions": ["WeaponAttack"],
"throttlePerTurn": 2, "refundOnMiss": false }],

"spendRules": [{ "key": "SPEND_RAGE_GENERIC", "base": 30, "upcastMax": 0, "windowCap": 100,
"allowPartial": true, "refundOnFail": false, "throttlePerTurn": 2 }],

"ui": { "visible": true, "showAsMeter": true, "icon": "ICON_RESOURCE_RAGE", "colorHint": "#C54A3B" },

"notes": ["TIP — Decays/reset OOC in WoW; emulate with small OOC drain if desired."]

},
{
"key": "ARCH_WOW_HOLY_POWER",

"displayName": "Holy Power",

"type": "Pips",

"cap": 5,

"floor": 0,

"startValue": 0,

"upcastMax": 4,

"regen": { "shortRest": 0, "longRest": "cap", "perTurn": 0, "onCrit": 0, "onKill": 0 },

"decay": { "perTurn": 0, "outOfCombatPerTurn": 0 },

"buildRules": [{ "source": "OnHit", "amount": 1, "critBonus": 0, "conditions": ["WeaponAttack"],
"throttlePerTurn": 3, "refundOnMiss": false }],

"spendRules": [{ "key": "SPEND_HOLY_POWER_GENERIC", "base": 3, "upcastMax": 2, "windowCap": 5,
"allowPartial": false, "refundOnFail": false, "throttlePerTurn": 1 }],

"ui": { "visible": true, "showAsMeter": true, "icon": "ICON_RESOURCE_HOLYPOWER", "colorHint": "#EAD38B" },

"notes": ["TIP — Classic builder→spender cycle at 3 spend; cap 5."]

},
{
"key": "ARCH_WOW_FOCUS",

"displayName": "Focus",

"type": "Points",

"cap": 100,

"floor": 0,

"startValue": 50,

"upcastMax": 0,

"regen": { "shortRest": 0, "longRest": "cap", "perTurn": 10, "onCrit": 0, "onKill": 0 },

"decay": { "perTurn": 0, "outOfCombatPerTurn": 0 },

"buildRules": [{ "source": "PassivePerTurn", "amount": 10, "critBonus": 0, "conditions": [], "throttlePerTurn": 1,

"refundOnMiss": false }],

"spendRules": [{ "key": "SPEND_FOCUS_GENERIC", "base": 30, "upcastMax": 0, "windowCap": 100,
"allowPartial": true, "refundOnFail": false, "throttlePerTurn": 3 }],

"ui": { "visible": true, "showAsMeter": true, "icon": "ICON_RESOURCE_FOCUS", "colorHint": "#9BC3FF" },

"notes": ["TIP — Passive regen bar; haste-scaled in WoW (emulate with item/status if needed)."]

},
{
"key": "ARCH_WOW_ENERGY_CP",

"displayName": "Energy + Combo Points",

"type": "Dual",

"primary": { "type": "Points", "cap": 100, "startValue": 100, "regenPerTurn": 20, "icon":

"ICON_RESOURCE_ENERGY", "colorHint": "#F5D742" },

"secondary": { "type": "Pips", "cap": 5, "startValue": 0, "icon": "ICON_RESOURCE_CP", "colorHint": "#FFFFFF" },

"buildRules": [

{ "source": "OnHit", "amount": 1, "critBonus": 1, "conditions": ["WeaponAttack"], "throttlePerTurn": 4,

"appliesTo": "secondary" },

{ "source": "PassivePerTurn", "amount": 20, "appliesTo": "primary" }

],
"spendRules": [{ "key": "SPEND_CP_FINISHER", "base": 1, "upcastMax": 4, "windowCap": 5, "allowPartial":

false, "refundOnFail": false, "throttlePerTurn": 1, "appliesTo": "secondary" }],

"notes": ["TIP — Builders grant CP; finishers spend CP; Energy fuels builders."]

},
{
"key": "ARCH_WOW_INSANITY",

"displayName": "Insanity",

"type": "Points",

"cap": 100,

"floor": 0,

"startValue": 0,

"regen": { "shortRest": 0, "longRest": "cap", "perTurn": 0, "onCrit": 0, "onKill": 0 },

"decay": { "perTurn": 0, "outOfCombatPerTurn": 0 },

"buildRules": [{ "source": "OnHit", "amount": 8, "conditions": ["SpellAttack"], "throttlePerTurn": 3 }],

"spendRules": [{ "key": "SPEND_INSANITY_GENERIC", "base": 50, "upcastMax": 50, "windowCap": 100,

"allowPartial": true, "refundOnFail": false, "throttlePerTurn": 1 }],

"ui": { "visible": true, "showAsMeter": true, "icon": "ICON_RESOURCE_INSANITY", "colorHint": "#AA66CC" },

"notes": ["TIP — Builder→spender bar; big spender like Devouring Plague analogue."]

},
{
"key": "ARCH_WOW_RUNES_RP",

"displayName": "Runes + Runic Power",

"type": "Dual",

"primary": { "type": "Charges", "cap": 6, "rechargeSeconds": 10, "icon": "ICON_RESOURCE_RUNES",

"colorHint": "#7ED2E9" },

"secondary": { "type": "Points", "cap": 100, "icon": "ICON_RESOURCE_RUNICPOWER", "colorHint": "#3DDAD7"

},

"buildRules": [

{ "source": "OnSpendPrimary", "amount": 10, "appliesTo": "secondary", "conditions": ["RuneConsumer"] }

],

"spendRules": [

{ "key": "SPEND_RP_GENERIC", "base": 40, "upcastMax": 60, "windowCap": 100, "appliesTo": "secondary" }

],
"notes": ["TIP — Haste reduces Rune recharge in WoW; emulate via status that reduces rechargeSeconds."]

},
{
"key": "ARCH_WOW_MAELSTROM",

"displayName": "Maelstrom",

"type": "Points",

"cap": 100,

"startValue": 0,

"buildRules": [{ "source": "OnHit", "amount": 8, "conditions": ["SpellAttack"], "throttlePerTurn": 3 }],

"spendRules": [{ "key": "SPEND_MAELSTROM_GENERIC", "base": 50, "allowPartial": true, "windowCap": 100 }],

"notes": []

},
{
"key": "ARCH_WOW_MAELSTROM_WEAPON",

"displayName": "Maelstrom Weapon (Stacks)",

"type": "Stacks",

"cap": 10,

"startValue": 0,

"buildRules": [{ "source": "OnProc", "amount": 1, "throttlePerTurn": 10 }],

"spendRules": [{ "key": "SPEND_MW_GENERIC", "base": 5, "upcastMax": 5, "windowCap": 10 }],

"ui": { "visible": true, "showAsMeter": true, "icon": "ICON_RESOURCE_MW", "colorHint": "#00C7A9" },

"notes": ["TIP — Optimal spends at 5–10 stacks."]

},
{
"key": "ARCH_WOW_ASTRAL_POWER",

"displayName": "Astral Power",

"type": "Points",

"cap": 100,

"startValue": 0,

"buildRules": [{ "source": "OnHit", "amount": 8, "conditions": ["SpellAttack"] }],

"spendRules": [{ "key": "SPEND_AP_GENERIC", "base": 40, "allowPartial": true, "windowCap": 100 }],

"notes": []

},
{
"key": "ARCH_WOW_SOUL_SHARDS",

"displayName": "Soul Shards",

"type": "Pips",

"cap": 5,

"startValue": 0,

"buildRules": [{ "source": "OnFrag", "amount": 0.2, "throttlePerTurn": 10 }],

"spendRules": [{ "key": "SPEND_SHARD_GENERIC", "base": 1, "upcastMax": 4, "windowCap": 5 }],

"ui": { "visible": true, "showAsMeter": true, "icon": "ICON_RESOURCE_SHARDS", "colorHint": "#5B2F7E" },

"notes": ["TIP — 50 fragments = 1 shard in WoW; represent via fractional build."]

},
{
"key": "ARCH_WOW_FURY",

"displayName": "Fury",

"type": "Points",

"cap": 100,

"startValue": 0,

"decay": { "outOfCombatPerTurn": 5 },

"buildRules": [{ "source": "OnHit", "amount": 10, "conditions": ["WeaponAttack"], "throttlePerTurn": 3 }],

"spendRules": [{ "key": "SPEND_FURY_GENERIC", "base": 30, "allowPartial": true, "windowCap": 100 }],

"ui": { "visible": true, "showAsMeter": true, "icon": "ICON_RESOURCE_FURY", "colorHint": "#B00020" },

"notes": []

},
{
"key": "ARCH_WOW_ESSENCE",

"displayName": "Essence",

"type": "Pips",

"cap": 5,

"startValue": 5,

"regen": { "perTurn": 1 },

"spendRules": [{ "key": "SPEND_ESSENCE_GENERIC", "base": 1, "upcastMax": 4, "windowCap": 5 }],

"ui": { "visible": true, "showAsMeter": true, "icon": "ICON_RESOURCE_ESSENCE", "colorHint": "#6BE0D6" },

"notes": ["TIP — Passive pip regen ~1 per few seconds in WoW."]

}

],
"classWide": [],

"subclassScoped": [

{
"scope": "SUBCLASS___A",

"archetypeKey": "TIP — Pick one from archetypes (e.g., ARCH_WOW_RAGE)",

"overrides": {

"cap": "TIP — Optional numeric override",

"buildRules": "TIP — Optional array to replace or extend",

"ui": "TIP — Override icon/color if needed"

},
"bind": {

"builders": ["TIP — ACTION_<...> keys from §7.SUBCLASS_A.builders"],

"spenders": ["TIP — ACTION_<...> keys from §7.SUBCLASS_A.spenders"]

}
},
{
"scope": "SUBCLASS___B",

"archetypeKey": "ARCH_WOW_ENERGY_CP",

"overrides": {},

"bind": { "builders": [], "spenders": [] }

},
{
"scope": "SUBCLASS___C",

"archetypeKey": "ARCH_WOW_ESSENCE",

"overrides": {},

"bind": { "builders": [], "spenders": [] }

}
]
}
}
Field-by-field (what each drives)

policy — Global defaults (e.g., 11-pip/+9 upcast window for pip-style resources).
archetypes[] — Ready-made resource blueprints derived from your WoW reference (Rage, Holy Power,
Focus, Energy+CP, Insanity, Runes+RP, Maelstrom, Maelstrom Weapon stacks, Astral Power, Soul Shards,
Fury, Essence). Use as-is or override per subclass.
classWide[] — Rare: a universal meter shared by all subclasses (usually empty).
subclassScoped[] — Attach one archetypeKey to each subclass (scope must match §6).
overrides — Optional per-subclass tweaks (e.g., change cap from 5→6 “Deeper Stratagem”-style).
bind.builders/spenders — Explicit keys from §7; validator cross-checks for dangling references.
Validation checklist

Every scope resolves to a valid §6 subclass key.
Each archetypeKey matches an entry in archetypes[].
Dual resources (Energy+CP, Runes+RP) declare both meters and set appliesTo in rules correctly.
For all bound spenders: ensure base + upcastMax ≤ cap/windowCap where relevant.
No cross-subclass leakage: builders/spenders listed for a scope must come from that subclass’s §7 catalog.
UI visibility sane (hidden meters documented if you choose to hide).
Common pitfalls & how to avoid them

Overflowing spends → Align spender base/upcastMax with the chosen archetype’s cap.
Unclear dual-resource wiring → Use appliesTo in rules to separate primary/secondary meters.
Over-busy OOC rules → If you mimic decay/reset from WoW, keep numbers small so players can read the bar.
Missing binds → Attach §7 action keys so the validator can catch missing or mis-scoped references.
Improvement suggestions

Add variantsByTier to archetypes to scale cap/regen at 3/8/13/18.
Add talentModifiers notes (e.g., “+1 pip cap with Feat_X”) so the exporter can patch caps when that feat is
chosen.
Provide statusHooks (e.g., haste reduces rechargeSeconds) to emulate WoW haste/haste-like modifiers.
Example (filled — mapping our earlier three subclasses)

{
"resources": {

"policy": { "defaultPipCap": 11, "defaultUpcastMax": 9, "notes": "" },

"archetypes": [ "... kept as above ..." ],

"classWide": [],

"subclassScoped": [

{

"scope": "SUBCLASS_VORGX_BERSERKER",

"archetypeKey": "ARCH_WOW_RAGE",

"overrides": { "decay": { "outOfCombatPerTurn": 3 } },

"bind": {

"builders": ["ACTION_VORGX_BERS_RAGING_STRIKE"],

"spenders": ["ACTION_VORGX_BERS_BLOODLETTING_FINISHER"]

}
},
{
"scope": "SUBCLASS_VORGX_SENTINEL",

"archetypeKey": "ARCH_WOW_FURY",

"overrides": { "spendRules": [{ "key": "SPEND_FURY_GENERIC", "base": 30, "allowPartial": true, "windowCap":
100 }] },

"bind": {

"builders": ["ACTION_VORGX_SENT_GUARDIAN_STRIKE"],

"spenders": ["ACTION_VORGX_SENT_WARDING_FINISHER"]

}
},
{
"scope": "SUBCLASS_VORGX_WARCHANT",

"archetypeKey": "ARCH_WOW_ESSENCE",

"overrides": {},

"bind": {

"builders": ["ACTION_VORGX_WAR_TEMPO_STRIKE"],

"spenders": ["ACTION_VORGX_WAR_BOOMING_FINISHER"]

}
}
]
}
}
10) Casting Details and Settings

What this section does

Declares the casting model for the class and/or each subclass:

Caster flag (on/off), casting model (Full/Half/Third/Custom/None), and casting ability (INT/WIS/CHA).
Spell list sources and filters (school, tags), plus optional learn/prepare policies.
Components & foci (verbal/somatic/material; arcane/holy/druidic focus), concentration policy notes.
Slot/point track selection (the shape , not the numeric pools—those are in §11).
Per- subclass overrides to support hybrid classes where only some subclasses cast.
Nothing here grants a specific spell; §14 does grants, and §11 provides the resource math and upcasting.

Authoring (drop-in JSON — GENERIC with tips)

{
"casting": {

"classWide": {

"isCaster": false,

"model": "TIP — None|Full|Half|Third|Custom",

"castingAbility": "TIP — INT|WIS|CHA (if model != None)",

"knownPreparedPolicy": {

"mode": "TIP — Known|Prepared|Learned",

"maxKnownByLevel": "TIP — array or formula; leave empty for Prepared",

"prepareSlotsByLevel": "TIP — array or formula; leave empty for Known",

"learnOnLevelUp": true

},
"slotTrack": "TIP — STANDARD_FULL|STANDARD_HALF|STANDARD_THIRD|CUSTOM (shape only; §11 sets

pools)",

"spellLists": [

"TIP — List keys or ‘School’/‘Tag’ filters (e.g., LIST_ARCANE_CONTROL, SCHOOL_Evocation, TAG_Buff)"

],
"listFilters": {

"include": ["TIP — Optional tags/schools to include"],

"exclude": ["TIP — Optional tags/schools to exclude"]

},
"components": {

"verbal": true,

"somatic": true,

"material": false,

"requiresFocus": false,

"focusType": "TIP — Arcane|Divine|Druidic|Instrument|null"

},
"concentration": {

"enabled": true,

"notes": "TIP — State general policy (e.g., one concentration effect at a time)."

},
"ritualCasting": {

"enabled": false,

"notes": "TIP — If true, spells with Ritual tag can be cast without expending slots using time."

},
"scrollUsage": {

"canUseScrolls": true,

"useClassListForScrolls": true,

"notes": "TIP — If false, restrict scroll usage to specific lists."

},
"ui": {

"icon": "ICON___CASTING",

"colorHint": "TIP — Optional hex tint for casting UI"

},
"notes": ["TIP — Freeform guidance; non-functional."]

},
"subclassOverrides": [

{
"subclassKey": "SUBCLASS___A",

"isCaster": false,

"model": "None",

"castingAbility": "",

"knownPreparedPolicy": {

"mode": "Known",

"maxKnownByLevel": [],

"prepareSlotsByLevel": [],

"learnOnLevelUp": false

},
"slotTrack": "TIP — Usually None when non-caster",

"spellLists": [],

"listFilters": { "include": [], "exclude": [] },

"components": { "verbal": true, "somatic": true, "material": false, "requiresFocus": false, "focusType": null },

"concentration": { "enabled": true, "notes": "" },

"ritualCasting": { "enabled": false, "notes": "" },

"scrollUsage": { "canUseScrolls": true, "useClassListForScrolls": true, "notes": "" },

"ui": { "icon": "ICON___SUB_A_CAST", "colorHint": "" },

"notes": []

},
{
"subclassKey": "SUBCLASS___B",

"isCaster": false,

"model": "None",

"castingAbility": "",

"knownPreparedPolicy": { "mode": "Known", "maxKnownByLevel": [], "prepareSlotsByLevel": [],
"learnOnLevelUp": false },

"slotTrack": "None",

"spellLists": [],

"listFilters": { "include": [], "exclude": [] },

"components": { "verbal": true, "somatic": true, "material": false, "requiresFocus": false, "focusType": null },

"concentration": { "enabled": true, "notes": "" },

"ritualCasting": { "enabled": false, "notes": "" },

"scrollUsage": { "canUseScrolls": true, "useClassListForScrolls": true, "notes": "" },

"ui": { "icon": "ICON___SUB_B_CAST", "colorHint": "" },

"notes": []

},
{
"subclassKey": "SUBCLASS___C",

"isCaster": true,

"model": "TIP — Full|Half|Third|Custom",

"castingAbility": "TIP — INT|WIS|CHA",

"knownPreparedPolicy": {

"mode": "TIP — Known|Prepared",

"maxKnownByLevel": "TIP — if Known (e.g., [2,3,4,...])",

"prepareSlotsByLevel": "TIP — if Prepared (e.g., [3,4,5,...])",

"learnOnLevelUp": true

},
"slotTrack": "TIP — STANDARD_HALF or CUSTOM",

"spellLists": ["TIP — e.g., LIST_BARD_SUPPORT or SCHOOL_Enchantment"],

"listFilters": { "include": ["TIP — TAG_Buff"], "exclude": ["TIP — TAG_Necrotic"] },

"components": { "verbal": true, "somatic": true, "material": false, "requiresFocus": true, "focusType":
"Instrument" },

"concentration": { "enabled": true, "notes": "TIP — Subclass C leans on concentration buffs." },

"ritualCasting": { "enabled": false, "notes": "" },

"scrollUsage": { "canUseScrolls": true, "useClassListForScrolls": true, "notes": "" },

"ui": { "icon": "ICON___SUB_C_CAST", "colorHint": "" },

"notes": ["TIP — Hybrids: ensure §11 defines matching slot/point pools."]

}
]
}
}
Field-by-field (what each drives)

classWide.isCaster/model — Base caster state for the class; often false/None for martial chassis with
caster subclasses handled in subclassOverrides.
model — Full (wizard/cleric-like), Half (paladin/ranger-like), Third (eldritch knight/arcane trickster-like),
Custom (provide your own slot/point shapes in §11), None (no casting).
castingAbility — Governs save DC and attack roll mods for spells (DC = 8 + prof + ability mod; attack =
proficiency + ability mod).
knownPreparedPolicy —
mode: "Known" → number of known spells per level (maxKnownByLevel) and optional learning behaviour.
mode: "Prepared" → preparable count per level (prepareSlotsByLevel); known list may be the entire list or a
learned subset.
slotTrack — The shape of available spell levels (e.g., STANDARD_HALF). The actual pools & recharge live in
§11 (slots/points and upcasting).
spellLists — Sources to populate the available list: other class lists, schools, or tag-based groups (e.g.,
TAG_Buff, TAG_Control).
listFilters — Include/exclude filters to refine the available list; keeps subclass identity tight.
components/focus — Whether spells require V/S/M and a focus item; helps exporter add equipment hooks
(focus) and UI flags.
concentration — Whether concentration rules apply; affects tooltips and validator checks.
ritualCasting — Enables time-based ritual casting for spells with the Ritual tag.
scrollUsage — Controls scroll-equipping and whether the class uses its own list for scroll validation.
subclassOverrides[] — Per-subclass casting profile overriding the class-wide baseline.
Validation checklist

If any subclassOverrides.isCaster=true , ensure model != None and castingAbility is set.
For Known model: maxKnownByLevel covers levels 1–20 (or your cap), values are non-decreasing integers.
For Prepared model: prepareSlotsByLevel covers levels 1–20, values are non-decreasing integers.
slotTrack exists and is compatible with the chosen model (e.g., STANDARD_HALF with Half model).
Every spellLists entry resolves to a known list key or valid filter token; filters don’t conflict with each other.
If requiresFocus=true, confirm a focus item is granted somewhere in §14 or via starting gear.
If classWide is non-caster but a subclass is a caster, ensure only that subclass has casting grants in §14–
§15.
Upcasting rules are not set here—check §11 binds a resource (slots/points) that supports upcast where
needed.
Common pitfalls & how to avoid them

Overbroad spell access → Use listFilters.exclude to remove out-of-theme tags (e.g., necrotic for a holy
subclass).
Mismatched slot track → Don’t select STANDARD_FULL for a Half caster; pick a matching track or set
Custom.
Missing focus → If requiresFocus=true, add the focus item grant in §14 (and ensure it’s equippable).
Prepared counts too high → Keep prepared limits conservative; validators should flag > known list or
inconsistent shapes.
Subclasses silently inheriting classWide caster settings → Explicitly override isCaster=false for non-caster
subclasses to avoid accidental grants.
Improvement suggestions

Add schoolAffinity metadata (e.g., Evocation +1 DC) if you plan feats or items to key off it later (validated in
§18).
Add learningSources (scrolls/trainer/reward-only) to document pipeline; exporter can annotate README.
Add spontaneousUpcast: true hint if your model encourages free upcast for certain spell families (actual
mechanic in §11).
For Custom models, include customTrackId to reuse shapes across multiple subclasses.
Example (filled — flavour OK; matches earlier subclasses)

{
"casting": {

"classWide": {

"isCaster": false,

"model": "None",

"castingAbility": "",

"knownPreparedPolicy": { "mode": "Known", "maxKnownByLevel": [], "prepareSlotsByLevel": [],

"learnOnLevelUp": false },

"slotTrack": "None",

"spellLists": [],

"listFilters": { "include": [], "exclude": [] },

"components": { "verbal": true, "somatic": true, "material": false, "requiresFocus": false, "focusType": null },

"concentration": { "enabled": true, "notes": "" },

"ritualCasting": { "enabled": false, "notes": "" },

"scrollUsage": { "canUseScrolls": true, "useClassListForScrolls": true, "notes": "" },

"ui": { "icon": "VORGX_ICON_CLASS_GENERIC_CAST", "colorHint": "" },

"notes": []

},
"subclassOverrides": [

{
"subclassKey": "SUBCLASS_VORGX_BERSERKER",

"isCaster": false,

"model": "None",

"castingAbility": "",

"knownPreparedPolicy": { "mode": "Known", "maxKnownByLevel": [], "prepareSlotsByLevel": [],

"learnOnLevelUp": false },

"slotTrack": "None",

"spellLists": [],

"listFilters": { "include": [], "exclude": [] },

"components": { "verbal": true, "somatic": true, "material": false, "requiresFocus": false, "focusType": null },

"concentration": { "enabled": true, "notes": "" },

"ritualCasting": { "enabled": false, "notes": "" },

"scrollUsage": { "canUseScrolls": true, "useClassListForScrolls": true, "notes": "" },

"ui": { "icon": "VORGX_ICON_SUB_BERS_CAST", "colorHint": "" },

"notes": []

},
{
"subclassKey": "SUBCLASS_VORGX_SENTINEL",

"isCaster": false,

"model": "None",

"castingAbility": "",

"knownPreparedPolicy": { "mode": "Known", "maxKnownByLevel": [], "prepareSlotsByLevel": [],

"learnOnLevelUp": false },

"slotTrack": "None",

"spellLists": [],

"listFilters": { "include": [], "exclude": [] },

"components": { "verbal": true, "somatic": true, "material": false, "requiresFocus": false, "focusType": null },

"concentration": { "enabled": true, "notes": "" },

"ritualCasting": { "enabled": false, "notes": "" },

"scrollUsage": { "canUseScrolls": true, "useClassListForScrolls": true, "notes": "" },

"ui": { "icon": "VORGX_ICON_SUB_SENT_CAST", "colorHint": "" },

"notes": []

},
{
"subclassKey": "SUBCLASS_VORGX_WARCHANT",

"isCaster": true,

"model": "Half",

"castingAbility": "Charisma",

"knownPreparedPolicy": { "mode": "Known", "maxKnownByLevel":

[2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21], "prepareSlotsByLevel": [], "learnOnLevelUp": true },

"slotTrack": "STANDARD_HALF",

"spellLists": ["LIST_BARD_SUPPORT"],

"listFilters": { "include": ["TAG_Buff","TAG_Thunder"], "exclude": ["TAG_Necrotic"] },

"components": { "verbal": true, "somatic": true, "material": false, "requiresFocus": true, "focusType":
"Instrument" },

"concentration": { "enabled": true, "notes": "Buff-heavy; many effects use concentration." },

"ritualCasting": { "enabled": false, "notes": "" },

"scrollUsage": { "canUseScrolls": true, "useClassListForScrolls": true, "notes": "" },

"ui": { "icon": "VORGX_ICON_SUB_WAR_CAST", "colorHint": "" },

"notes": []

}
]
}
}
11) Casting Resources & Mechanics (updated for L1–L9)

What this section does

Defines the numeric casting pools (slots or points), recovery , and upcasting. Now includes tracks up to L9 and
an integration hint for Level 13–20/7–9 slots support. Nexus Mods

Authoring (drop-in JSON — GENERIC with tips; 9th-level ready)

{
"castingResources": {

"policy": {

"upcast": {

"enabled": true,

"minSlotLevel": 1,

"maxSlotLevel": 9,

"overflowPolicy": "Deny",

"scalingHint": "TIP — e.g., +1 die per slot above base (document in §14 grants).",

"notes": "TIP — If your content allows 7–9, ensure §10.slotTrack uses a 9-level track."

},
"recovery": {

"longRest": "All",

"shortRest": "None",

"partialPattern": "TIP — If you emulate Warlock-style refresh, describe it here."

}
},
"tracks": {

"STANDARD_FULL_9": {
"type": "Slots",

"byLevel": {

"1": { "L1": 2, "L2": 0, "L3": 0, "L4": 0, "L5": 0, "L6": 0, "L7": 0, "L8": 0, "L9": 0 },
"2": { "L1": 3, "L2": 0, "L3": 0, "L4": 0, "L5": 0, "L6": 0, "L7": 0, "L8": 0, "L9": 0 },
"3": { "L1": 4, "L2": 2, "L3": 0, "L4": 0, "L5": 0, "L6": 0, "L7": 0, "L8": 0, "L9": 0 },
"4": { "L1": 4, "L2": 3, "L3": 0, "L4": 0, "L5": 0, "L6": 0, "L7": 0, "L8": 0, "L9": 0 },
"5": { "L1": 4, "L2": 3, "L3": 2, "L4": 0, "L5": 0, "L6": 0, "L7": 0, "L8": 0, "L9": 0 },
"6": { "L1": 4, "L2": 3, "L3": 3, "L4": 0, "L5": 0, "L6": 0, "L7": 0, "L8": 0, "L9": 0 },
"7": { "L1": 4, "L2": 3, "L3": 3, "L4": 1, "L5": 0, "L6": 0, "L7": 0, "L8": 0, "L9": 0 },
"8": { "L1": 4, "L2": 3, "L3": 3, "L4": 2, "L5": 0, "L6": 0, "L7": 0, "L8": 0, "L9": 0 },
"9": { "L1": 4, "L2": 3, "L3": 3, "L4": 3, "L5": 1, "L6": 0, "L7": 0, "L8": 0, "L9": 0 },
"10": { "L1": 4, "L2": 3, "L3": 3, "L4": 3, "L5": 2, "L6": 0, "L7": 0, "L8": 0, "L9": 0 },
"11": { "L1": 4, "L2": 3, "L3": 3, "L4": 3, "L5": 2, "L6": 1, "L7": 0, "L8": 0, "L9": 0 },
"12": { "L1": 4, "L2": 3, "L3": 3, "L4": 3, "L5": 2, "L6": 1, "L7": 0, "L8": 0, "L9": 0 },
"13": { "L1": 4, "L2": 3, "L3": 3, "L4": 3, "L5": 2, "L6": 1, "L7": 1, "L8": 0, "L9": 0 },
"14": { "L1": 4, "L2": 3, "L3": 3, "L4": 3, "L5": 2, "L6": 1, "L7": 1, "L8": 0, "L9": 0 },
"15": { "L1": 4, "L2": 3, "L3": 3, "L4": 3, "L5": 2, "L6": 1, "L7": 1, "L8": 1, "L9": 0 },
"16": { "L1": 4, "L2": 3, "L3": 3, "L4": 3, "L5": 2, "L6": 1, "L7": 1, "L8": 1, "L9": 0 },
"17": { "L1": 4, "L2": 3, "L3": 3, "L4": 3, "L5": 2, "L6": 1, "L7": 1, "L8": 1, "L9": 1 },
"18": { "L1": 4, "L2": 3, "L3": 3, "L4": 3, "L5": 2, "L6": 1, "L7": 1, "L8": 1, "L9": 1 },
"19": { "L1": 4, "L2": 3, "L3": 3, "L4": 3, "L5": 2, "L6": 2, "L7": 1, "L8": 1, "L9": 1 },
"20": { "L1": 4, "L2": 3, "L3": 3, "L4": 3, "L5": 2, "L6": 2, "L7": 1, "L8": 1, "L9": 1 }
},
"notes": "TIP — Standard full-caster shape up to 9th-level slots."

},
"STANDARD_HALF_9": {
"type": "Slots",

"byLevel": {

"1": { "L1": 0, "L2": 0, "L3": 0, "L4": 0, "L5": 0, "L6": 0, "L7": 0, "L8": 0, "L9": 0 },

"2": { "L1": 2, "L2": 0, "L3": 0, "L4": 0, "L5": 0, "L6": 0, "L7": 0, "L8": 0, "L9": 0 },
"3": { "L1": 3, "L2": 0, "L3": 0, "L4": 0, "L5": 0, "L6": 0, "L7": 0, "L8": 0, "L9": 0 },
"4": { "L1": 3, "L2": 0, "L3": 0, "L4": 0, "L5": 0, "L6": 0, "L7": 0, "L8": 0, "L9": 0 },
"5": { "L1": 4, "L2": 2, "L3": 0, "L4": 0, "L5": 0, "L6": 0, "L7": 0, "L8": 0, "L9": 0 },
"6": { "L1": 4, "L2": 2, "L3": 0, "L4": 0, "L5": 0, "L6": 0, "L7": 0, "L8": 0, "L9": 0 },
"7": { "L1": 4, "L2": 3, "L3": 0, "L4": 0, "L5": 0, "L6": 0, "L7": 0, "L8": 0, "L9": 0 },
"8": { "L1": 4, "L2": 3, "L3": 0, "L4": 0, "L5": 0, "L6": 0, "L7": 0, "L8": 0, "L9": 0 },
"9": { "L1": 4, "L2": 3, "L3": 2, "L4": 0, "L5": 0, "L6": 0, "L7": 0, "L8": 0, "L9": 0 },
"10": { "L1": 4, "L2": 3, "L3": 2, "L4": 0, "L5": 0, "L6": 0, "L7": 0, "L8": 0, "L9": 0 },
"11": { "L1": 4, "L2": 3, "L3": 3, "L4": 0, "L5": 0, "L6": 0, "L7": 0, "L8": 0, "L9": 0 },
"12": { "L1": 4, "L2": 3, "L3": 3, "L4": 0, "L5": 0, "L6": 0, "L7": 0, "L8": 0, "L9": 0 },
"13": { "L1": 4, "L2": 3, "L3": 3, "L4": 1, "L5": 0, "L6": 0, "L7": 0, "L8": 0, "L9": 0 },
"14": { "L1": 4, "L2": 3, "L3": 3, "L4": 1, "L5": 0, "L6": 0, "L7": 0, "L8": 0, "L9": 0 },
"15": { "L1": 4, "L2": 3, "L3": 3, "L4": 2, "L5": 0, "L6": 0, "L7": 0, "L8": 0, "L9": 0 },
"16": { "L1": 4, "L2": 3, "L3": 3, "L4": 2, "L5": 0, "L6": 0, "L7": 0, "L8": 0, "L9": 0 },
"17": { "L1": 4, "L2": 3, "L3": 3, "L4": 3, "L5": 0, "L6": 0, "L7": 0, "L8": 0, "L9": 0 },
"18": { "L1": 4, "L2": 3, "L3": 3, "L4": 3, "L5": 0, "L6": 0, "L7": 0, "L8": 0, "L9": 0 },
"19": { "L1": 4, "L2": 3, "L3": 3, "L4": 3, "L5": 1, "L6": 0, "L7": 0, "L8": 0, "L9": 0 },
"20": { "L1": 4, "L2": 3, "L3": 3, "L4": 3, "L5": 2, "L6": 0, "L7": 0, "L8": 0, "L9": 0 }
},
"notes": "TIP — Half casters cap at L5; higher columns remain 0 for clarity."

},
"STANDARD_THIRD_9": {
"type": "Slots",

"byLevel": {

"1": { "L1": 0, "L2": 0, "L3": 0, "L4": 0, "L5": 0, "L6": 0, "L7": 0, "L8": 0, "L9": 0 },
"2": { "L1": 0, "L2": 0, "L3": 0, "L4": 0, "L5": 0, "L6": 0, "L7": 0, "L8": 0, "L9": 0 },
"3": { "L1": 2, "L2": 0, "L3": 0, "L4": 0, "L5": 0, "L6": 0, "L7": 0, "L8": 0, "L9": 0 },
"4": { "L1": 3, "L2": 0, "L3": 0, "L4": 0, "L5": 0, "L6": 0, "L7": 0, "L8": 0, "L9": 0 },
"5": { "L1": 3, "L2": 0, "L3": 0, "L4": 0, "L5": 0, "L6": 0, "L7": 0, "L8": 0, "L9": 0 },
"6": { "L1": 3, "L2": 0, "L3": 0, "L4": 0, "L5": 0, "L6": 0, "L7": 0, "L8": 0, "L9": 0 },
"7": { "L1": 4, "L2": 0, "L3": 0, "L4": 0, "L5": 0, "L6": 0, "L7": 0, "L8": 0, "L9": 0 },
"8": { "L1": 4, "L2": 0, "L3": 0, "L4": 0, "L5": 0, "L6": 0, "L7": 0, "L8": 0, "L9": 0 },
"9": { "L1": 4, "L2": 2, "L3": 0, "L4": 0, "L5": 0, "L6": 0, "L7": 0, "L8": 0, "L9": 0 },
"10": { "L1": 4, "L2": 2, "L3": 0, "L4": 0, "L5": 0, "L6": 0, "L7": 0, "L8": 0, "L9": 0 },
"11": { "L1": 4, "L2": 3, "L3": 0, "L4": 0, "L5": 0, "L6": 0, "L7": 0, "L8": 0, "L9": 0 },
"12": { "L1": 4, "L2": 3, "L3": 0, "L4": 0, "L5": 0, "L6": 0, "L7": 0, "L8": 0, "L9": 0 },
"13": { "L1": 4, "L2": 3, "L3": 1, "L4": 0, "L5": 0, "L6": 0, "L7": 0, "L8": 0, "L9": 0 },
"14": { "L1": 4, "L2": 3, "L3": 1, "L4": 0, "L5": 0, "L6": 0, "L7": 0, "L8": 0, "L9": 0 },
"15": { "L1": 4, "L2": 3, "L3": 2, "L4": 0, "L5": 0, "L6": 0, "L7": 0, "L8": 0, "L9": 0 },
"16": { "L1": 4, "L2": 3, "L3": 2, "L4": 0, "L5": 0, "L6": 0, "L7": 0, "L8": 0, "L9": 0 },
"17": { "L1": 4, "L2": 3, "L3": 3, "L4": 0, "L5": 0, "L6": 0, "L7": 0, "L8": 0, "L9": 0 },
"18": { "L1": 4, "L2": 3, "L3": 3, "L4": 0, "L5": 0, "L6": 0, "L7": 0, "L8": 0, "L9": 0 },
"19": { "L1": 4, "L2": 3, "L3": 3, "L4": 1, "L5": 0, "L6": 0, "L7": 0, "L8": 0, "L9": 0 },
"20": { "L1": 4, "L2": 3, "L3": 3, "L4": 1, "L5": 0, "L6": 0, "L7": 0, "L8": 0, "L9": 0 }
},
"notes": "TIP — Third casters cap at L4; higher columns remain 0."

},
"SPELL_POINTS_HIGH": {
"type": "Points",

"poolByLevel": {

"1": 4, "2": 6, "3": 14, "4": 17, "5": 27, "6": 32, "7": 38, "8": 44, "9": 57, "10": 64,
"11": 73, "12": 73, "13": 83, "14": 83, "15": 94, "16": 94, "17": 107, "18": 114, "19": 123, "20": 133
},
"slotCost": { "L1": 2, "L2": 3, "L3": 5, "L4": 6, "L5": 7, "L6": 9, "L7": 10, "L8": 11, "L9": 13 },

"dailyCap": { "perLevelCastCap": { "L6": 1, "L7": 1, "L8": 1, "L9": 1 } },

"notes": "Variant spell points per DMG: 6th+ slots 1/day each level; pools & costs shown. Adjust if desired."

}
},
"classWide": {

"slotTrack": "TIP — STANDARD_FULL_9|STANDARD_HALF_9|STANDARD_THIRD_9|SPELL_POINTS_HIGH|None",

"recovery": { "longRest": "All", "shortRest": "None" },

"overflow": { "convertExcessTo": "None", "rate": 0 },

"notes": ["TIP — Defaults for the class; subclasses can override."]

},
"subclassOverrides": [

{
"subclassKey": "SUBCLASS___A",

"slotTrack": "None",

"recovery": { "longRest": "All", "shortRest": "None" },

"overflow": { "convertExcessTo": "None", "rate": 0 },

"notes": []

},
{
"subclassKey": "SUBCLASS___B",

"slotTrack": "None",

"recovery": { "longRest": "All", "shortRest": "None" },

"overflow": { "convertExcessTo": "None", "rate": 0 },

"notes": []

},
{
"subclassKey": "SUBCLASS___C",

"slotTrack": "TIP — STANDARD_FULL_9|STANDARD_HALF_9|SPELL_POINTS_HIGH",

"recovery": { "longRest": "All", "shortRest": "None" },

"overflow": { "convertExcessTo": "None", "rate": 0 },

"notes": ["TIP — Ensure §10.model matches this track."]

}
],
"integrationHints": {

"unlockLevelCurve377": {

"enabled": true,

"notes": "Supports levels 13–20 and casting with slot levels 7–9. If using 5e Spells, follow the author’s load
order.",

"requiresBoonOfHighMagicForL9": true,

"loadOrderTip": "1) 5e Spells 2) UnlockLevelCurve 3) UnlockLevelCurve_Patch_5eSpells"

}
}
}
}
Why these values?

The Full/Half/Third tables extend to L9 , mirroring standard 5e-style slot progressions (full casters gain L7 at
L13, L8 at L15, and L9 at L17, with a second L6 at 19–20; half casters cap at L5; third casters cap at L4).
The Spell Points variant includes costs and pool totals for L1–L9 and enforces the DMG rule of only one
6th–9th slot per long rest , which matches the canonical constraint for high-level slot creation.
dnd5e.wikidot.com
The integration hint reflects the mod’s support for slot levels 7–9 and its note that Boon of High Magic is
needed to access 9th-level slots , plus the recommended load order when using 5e Spells. Nexus Mods
Field-by-field (what each drives)

policy.upcast.maxSlotLevel: 9 — Allows §14 grants to reference slot levels up to 9 (validators should clamp
above this).
tracks.STANDARD_*_9 — Ready-to-use 9-column slot shapes; pick the one that matches §10.model.
tracks.SPELL_POINTS_HIGH — Point-pool mapping for L1–L9 with per-rest caps on 6th–9th (DMG variant).
dnd5e.wikidot.com
integrationHints.unlockLevelCurve377 — Documentation aid for setups that add L13–20 + 7–9 slots ,
including the Boon of High Magic requirement for L9 and load order when pairing with 5e Spells. Nexus Mods
Validation checklist

If any subclass in §10 is a caster and uses STANDARD_FULL_9 (or Spell Points maxSlotLevel ≥ 7 ), ensure
your environment supports 7–9 slots (e.g., UnlockLevelCurve 377) and, if needed, grant Boon of High Magic
at the appropriate level/feat. Nexus Mods
For Spell Points , enforce L6–L9 1×/LR casting and block point purchases above policy.upcast.maxSlotLevel.
dnd5e.wikidot.com
Non-caster subclasses must explicitly set slotTrack: "None" to avoid inheriting slots.
Common pitfalls & how to avoid them

Forgetting the 9th-level gate → If you expect L9, include a grant for a “High Magic Boon” (feat/status) or
ensure the external mod provides it. Nexus Mods
Model/track mismatch → §10.model must align with the chosen 9-level track.
Spell Points overuse → Remember the 6th–9th 1/day rule; add lints in §18. dnd5e.wikidot.com
Improvement suggestions

Add variantsByTier to unlock L7 at tier 15, L8 at 17, L9 at 19 if you’re pacing late-game differently.
Add externalFlags: "hasUnlockLevelCurve": true to let exporters auto-adjust UI/tooltips for 7–9.
Provide a simple compat patch profile that toggles between STANDARD_FULL_9 and SPELL_POINTS_HIGH.
Example (filled — flavour OK)

{
"castingResources": {

"policy": {

"upcast": { "enabled": true, "minSlotLevel": 1, "maxSlotLevel": 9, "overflowPolicy": "Deny", "scalingHint": "+1 die
per slot over base", "notes": "" },

"recovery": { "longRest": "All", "shortRest": "None", "partialPattern": "" }

},
"tracks": { "STANDARD_FULL_9": { "type": "Slots", "byLevel": { "1": { "L1":
2,"L2":0,"L3":0,"L4":0,"L5":0,"L6":0,"L7":0,"L8":0,"L9":0 }, "2": { "L1":

3,"L2":0,"L3":0,"L4":0,"L5":0,"L6":0,"L7":0,"L8":0,"L9":0 }, "3": { "L1":
4,"L2":2,"L3":0,"L4":0,"L5":0,"L6":0,"L7":0,"L8":0,"L9":0 }, "4": { "L1":

4,"L2":3,"L3":0,"L4":0,"L5":0,"L6":0,"L7":0,"L8":0,"L9":0 }, "5": { "L1":
4,"L2":3,"L3":2,"L4":0,"L5":0,"L6":0,"L7":0,"L8":0,"L9":0 }, "6": { "L1":

4,"L2":3,"L3":3,"L4":0,"L5":0,"L6":0,"L7":0,"L8":0,"L9":0 }, "7": { "L1":
4,"L2":3,"L3":3,"L4":1,"L5":0,"L6":0,"L7":0,"L8":0,"L9":0 }, "8": { "L1":
4,"L2":3,"L3":3,"L4":2,"L5":0,"L6":0,"L7":0,"L8":0,"L9":0 }, "9": { "L1":

4,"L2":3,"L3":3,"L4":3,"L5":1,"L6":0,"L7":0,"L8":0,"L9":0 }, "10": { "L1":
4,"L2":3,"L3":3,"L4":3,"L5":2,"L6":0,"L7":0,"L8":0,"L9":0 }, "11": { "L1":

4,"L2":3,"L3":3,"L4":3,"L5":2,"L6":1,"L7":0,"L8":0,"L9":0 }, "12": { "L1":
4,"L2":3,"L3":3,"L4":3,"L5":2,"L6":1,"L7":0,"L8":0,"L9":0 }, "13": { "L1":
4,"L2":3,"L3":3,"L4":3,"L5":2,"L6":1,"L7":1,"L8":0,"L9":0 }, "14": { "L1":
4,"L2":3,"L3":3,"L4":3,"L5":2,"L6":1,"L7":1,"L8":0,"L9":0 }, "15": { "L1":

4,"L2":3,"L3":3,"L4":3,"L5":2,"L6":1,"L7":1,"L8":1,"L9":0 }, "16": { "L1":
4,"L2":3,"L3":3,"L4":3,"L5":2,"L6":1,"L7":1,"L8":1,"L9":0 }, "17": { "L1":

4,"L2":3,"L3":3,"L4":3,"L5":2,"L6":1,"L7":1,"L8":1,"L9":1 }, "18": { "L1":
4,"L2":3,"L3":3,"L4":3,"L5":2,"L6":1,"L7":1,"L8":1,"L9":1 }, "19": { "L1": 4,"L2":3,"L3":3,"L4":3,"L5":
2,"L6":2,"L7":1,"L8":1,"L9":1 }, "20": { "L1": 4,"L2":3,"L3":3,"L4":3,"L5": 2,"L6":2,"L7":1,"L8":1,"L9":1 } } } },

"classWide": { "slotTrack": "None", "recovery": { "longRest": "All", "shortRest": "None" }, "overflow": {
"convertExcessTo": "None", "rate": 0 }, "notes": [] },

"subclassOverrides": [

{ "subclassKey": "SUBCLASS_VORGX_BERSERKER", "slotTrack": "None", "recovery": { "longRest": "All",
"shortRest": "None" }, "overflow": { "convertExcessTo": "None", "rate": 0 }, "notes": [] },

{ "subclassKey": "SUBCLASS_VORGX_SENTINEL", "slotTrack": "None", "recovery": { "longRest": "All", "shortRest":
"None" }, "overflow": { "convertExcessTo": "None", "rate": 0 }, "notes": [] },

{ "subclassKey": "SUBCLASS_VORGX_WARCHANT", "slotTrack": "STANDARD_FULL_9", "recovery": { "longRest":
"All", "shortRest": "None" }, "overflow": { "convertExcessTo": "None", "rate": 0 }, "notes": [] }

],
"integrationHints": {

"unlockLevelCurve377": {

"enabled": true,

"requiresBoonOfHighMagicForL9": true,

"loadOrderTip": "1) 5e Spells 2) UnlockLevelCurve 3) UnlockLevelCurve_Patch_5eSpells"

}
}
}
}
12) Comprehensive Level Plan (Class & Subclass)

What this section does

Provides a single, human-readable plan of what happens at each character level (1–20) for:

Class-wide beats (proficiencies, stances, passives, feat levels, extra attack windows, etc.)
Subclass beats (unlock, keystones, feature spikes, resource evolutions)
Tier gates (3/8/13/18) and milestones (9/13/15/18 keystones, 20 capstone)
Casting/cap unlock notes (if applicable), referencing §10–§11 tracks (no grants here; §14 does the granting)
This is the script the team reads and the validator cross-checks against §14 (authoring) and §15 (rendered table).

Authoring (drop-in JSON — GENERIC with tips)

{
"levelPlan": {

"policy": {

"tiers": [3, 8, 13, 18],

"featLevels": [4, 8, 12, 16, 20],

"extraAttackWindows": [5, 11, 17],

"notes": "TIP — Adjust beats if your class deviates. This plan is documentation; §14 will implement."

},
"classBeats": [

{ "level": 1, "summary": "TIP — Core chassis online: proficiencies, base stance, core passive, subclass selection
if unlockLevel=1." },

{ "level": 2, "summary": "TIP — Early passive/utility. Consider builder access if class-wide." },

{ "level": 3, "summary": "TIER I (3): TIP — First spike. Unlock stance variant or resource efficiency." },

{ "level": 4, "summary": "FEAT: TIP — Generic feat/ASIs; hook to §14." },

{ "level": 5, "summary": "WINDOW: Extra Attack I (if martial). Spell progression step if caster." },

{ "level": 6, "summary": "TIP — Defensive/offensive passive scaling." },

{ "level": 7, "summary": "TIP — Utility ribbon or subclass synergy nudge." },

{ "level": 8, "summary": "TIER II (8) + FEAT: TIP — Spike; consider new spender rank or stance upgrade." },

{ "level": 9, "summary": "KEYSTONE (9): TIP — Big class identity moment (or leave to subclass)."},

{ "level": 10, "summary": "TIP — Quality-of-life feature or consolidation." },

{ "level": 11, "summary": "WINDOW: Extra Attack II (if applicable)."},

{ "level": 12, "summary": "FEAT: TIP — Another feat/ASI." },

{ "level": 13, "summary": "TIER III (13) + KEYSTONE: TIP — Major spike (casting L7 if supported)."},

{ "level": 14, "summary": "TIP — High-level sustain/efficiency." },

{ "level": 15, "summary": "KEYSTONE (15): TIP — Power-defining upgrade." },

{ "level": 16, "summary": "FEAT: TIP — Late feat/ASI." },

{ "level": 17, "summary": "WINDOW: Extra Attack III (martials) / casting L9 availability if supported (see §11)."},

{ "level": 18, "summary": "TIER IV (18) + KEYSTONE: TIP — Endgame spike." },

{ "level": 19, "summary": "TIP — Capstone prelude or resource cap tweak." },

{ "level": 20, "summary": "CAPSTONE: TIP — Signature endgame feature." }

],
"subclassBeats": [

{
"subclassKey": "SUBCLASS___A",

"beats": [

{ "level": 1, "summary": "UNLOCK: TIP — Builder + stance/aura (if subclass unlocks at 1)." },

{ "level": 3, "summary": "TIER I: TIP — Empower builder/defensive hook." },

{ "level": 5, "summary": "TIP — Finisher rank I or spender access." },

{ "level": 8, "summary": "TIER II: TIP — Resource efficiency +1 or stance upgrade." },

{ "level": 9, "summary": "KEYSTONE (9): TIP — Major subclass identity effect." },

{ "level": 13, "summary": "TIER III + KEYSTONE: TIP — Strong spike." },

{ "level": 15, "summary": "KEYSTONE (15): TIP — Late spike (e.g., finisher scaling)." },

{ "level": 18, "summary": "TIER IV + KEYSTONE: TIP — Endgame defining effect." },

{ "level": 20, "summary": "CAPSTONE: TIP — Ultimate subclass payoff." }

]
},
{
"subclassKey": "SUBCLASS___B",

"beats": [

{ "level": 1, "summary": "UNLOCK: TIP — Builder + ward/counter access." },

{ "level": 3, "summary": "TIER I: TIP — Defensive wall online." },

{ "level": 5, "summary": "TIP — Finisher rank I or control spender." },

{ "level": 8, "summary": "TIER II: TIP — Ward scaling or taunt mechanic." },

{ "level": 9, "summary": "KEYSTONE (9): TIP — Reaction/counter package." },

{ "level": 13, "summary": "TIER III + KEYSTONE." },

{ "level": 15, "summary": "KEYSTONE (15)." },

{ "level": 18, "summary": "TIER IV + KEYSTONE." },

{ "level": 20, "summary": "CAPSTONE." }

]
},
{
"subclassKey": "SUBCLASS___C",

"beats": [

{ "level": 1, "summary": "UNLOCK: TIP — Hybrid casting flag + builder." },

{ "level": 3, "summary": "TIER I: TIP — Early buff weave." },

{ "level": 5, "summary": "TIP — Finisher rank I; first meaningful spell slot tier if Half/Full." },

{ "level": 8, "summary": "TIER II + FEAT synergy." },

{ "level": 9, "summary": "KEYSTONE (9): TIP — Signature weave (e.g., on-spend rider)." },

{ "level": 13, "summary": "TIER III + KEYSTONE (casting L7 if enabled in §11)." },

{ "level": 15, "summary": "KEYSTONE (15): TIP — Strong weave upgrade." },

{ "level": 17, "summary": "TIP — If using §11 STANDARD_FULL_9, L9 slot becomes available here." },

{ "level": 18, "summary": "TIER IV + KEYSTONE." },

{ "level": 20, "summary": "CAPSTONE." }

]

}
],
"castingNotes": [

"TIP — If §11 uses STANDARD_FULL_9 or SPELL_POINTS_HIGH, document 7–9 slot availability milestones

(13/15/17).",

"TIP — If external mod (e.g., UnlockLevelCurve) is required for L7–L9, mention and ensure §14 grants any

needed 'High Magic' boon.",

"TIP — For Half/Third casters, keep higher columns at 0 in §11 and reflect here for clarity."

],
"resourceNotes": [

"TIP — Reference §9 archetypes by name (e.g., Rage/Resolve/Tempo) and document when caps/regen change.",

"TIP — Keep base + upcastMax within windowCap at all times; call out increases at tiers if used."

]
}
}
Field-by-field (what each drives)

policy — Tier gates, expected feat levels, and optional extra-attack windows; validators compare §14/§15
against this.
classBeats[] — The global plan: high-level milestones without keys (no grants here).
subclassBeats[] — Per-subclass milestones; subclassKey must match §6.
castingNotes/resourceNotes — Cross-references to §10–§11 (casting) and §9 (resources) to prevent drift.
Validation checklist

Every subclassKey resolves to a §6 entry.
Tiers in policy.tiers appear in classBeats and each subclassBeats block.
featLevels align with §14 feat rows (and §15 rendered rows).
If casting is enabled in §10/§11 with 7–9 support, classBeats/subclassBeats mention those milestones.
No grant keys appear here (those belong only in §14); this section remains narrative/plan-only.
Common pitfalls & how to avoid them

Plan vs. grants divergence → Every summary beat should correspond to concrete §14 rows; keep a 1:1
checklist while authoring.
Forgetting subclass cadence → Ensure each subclass has spikes at 9/13/15/18 (or document deviations in
policy.notes).
Caster mismatches → If a subclass is non-caster, don’t mention slot milestones in its beats.
Improvement suggestions

Add "labels" to beats (e.g., "labels":["Keystone","Tier II"]) so the renderer can colour-code the §15 table
headings.
Add "recommendedTestScenarios" per tier (internal QA notes only) if you want the validator to suggest test
cases.
Include "gatingDependencies" (e.g., “requires High Magic Boon at 17”) so §14 can auto-emit the row when we
reach that level.
Example (filled — flavour OK; matches our earlier class)

{
"levelPlan": {

"policy": { "tiers": [3,8,13,18], "featLevels": [4,8,12,16,20], "extraAttackWindows": [5,11,17], "notes": "" },

"classBeats": [

{ "level": 1, "summary": "Core chassis online; subclass chosen at 1; stance framework granted; one core
passive." },

{ "level": 2, "summary": "Utility passive." },

{ "level": 3, "summary": "TIER I (3): first spike; stance upgrade or spender access." },

{ "level": 4, "summary": "FEAT." },

{ "level": 5, "summary": "Extra Attack I (martial window)." },

{ "level": 6, "summary": "Scaling passive." },

{ "level": 7, "summary": "Utility ribbon." },

{ "level": 8, "summary": "TIER II (8) + FEAT; spender rank or stance morph." },

{ "level": 9, "summary": "KEYSTONE (9): signature mechanic enabled." },

{ "level": 10, "summary": "QoL/efficiency feature." },

{ "level": 11, "summary": "Extra Attack II (window) or resource efficiency." },

{ "level": 12, "summary": "FEAT." },

{ "level": 13, "summary": "TIER III (13) + KEYSTONE; (casters: L7 slot milestone if using STANDARD_FULL_9)." },

{ "level": 14, "summary": "Sustain/defense upgrade." },

{ "level": 15, "summary": "KEYSTONE (15) spike." },

{ "level": 16, "summary": "FEAT." },

{ "level": 17, "summary": "Extra Attack III (window) / casters: L9 slot unlock with compatible mod." },

{ "level": 18, "summary": "TIER IV (18) + KEYSTONE." },

{ "level": 19, "summary": "Pre-capstone tune." },

{ "level": 20, "summary": "CAPSTONE." }

],
"subclassBeats": [

{
"subclassKey": "SUBCLASS_VORGX_BERSERKER",

"beats": [

{ "level": 1, "summary": "UNLOCK: Raging Strike (builder) + stance synergy." },

{ "level": 3, "summary": "TIER I: Rage gains small efficiency." },

{ "level": 5, "summary": "Finisher rank I." },

{ "level": 8, "summary": "TIER II: Rage window tools." },

{ "level": 9, "summary": "KEYSTONE: damage window amplifier." },

{ "level": 13, "summary": "TIER III: finisher rank II." },

{ "level": 15, "summary": "KEYSTONE: crit/ramp interaction." },

{ "level": 18, "summary": "TIER IV: execute-style bonus." },

{ "level": 20, "summary": "CAPSTONE: always-on battle high." }

]
},
{
"subclassKey": "SUBCLASS_VORGX_SENTINEL",

"beats": [

{ "level": 1, "summary": "UNLOCK: Guardian Strike (builder) + warding tools." },

{ "level": 3, "summary": "TIER I: Warded baseline." },

{ "level": 5, "summary": "Warding Finisher rank I (control/defense)." },

{ "level": 8, "summary": "TIER II: counter/taunt loop." },

{ "level": 9, "summary": "KEYSTONE: reaction engine." },

{ "level": 13, "summary": "TIER III: ward scaling." },

{ "level": 15, "summary": "KEYSTONE: bulwark upgrade." },

{ "level": 18, "summary": "TIER IV: group mitigation." },

{ "level": 20, "summary": "CAPSTONE: implacable guardian." }

]
},
{
"subclassKey": "SUBCLASS_VORGX_WARCHANT",

"beats": [

{ "level": 1, "summary": "UNLOCK: Tempo Strike (builder) + hybrid casting flag (Half model)." },

{ "level": 3, "summary": "TIER I: basic weave buff online." },

{ "level": 5, "summary": "Finisher rank I; first meaningful slot tier for Half track." },

{ "level": 8, "summary": "TIER II: weave sustain; FEAT synergy." },

{ "level": 9, "summary": "KEYSTONE: spend-proc anthem." },

{ "level": 13, "summary": "TIER III: strong buff weave; (if Full track) L7 slot milestone." },

{ "level": 15, "summary": "KEYSTONE: anthem mastery." },

{ "level": 17, "summary": "If using STANDARD_FULL_9, L9 slot unlock (requires High Magic boon if using

external mod)." },

{ "level": 18, "summary": "TIER IV: chorus overdrive." },

{ "level": 20, "summary": "CAPSTONE: endless refrain." }

]
}
],
"castingNotes": [

"STANDARD_FULL_9 milestones: L7@13, L8@15, L9@17.",

"If using external L13–20 mod with High Magic requirement, ensure §14 grants the boon at 17+."

],
"resourceNotes": [

"Rage/Resolve/Tempo (from §9) follow 11-cap/+9 window unless overridden; finisher base+upcast tuned at

tiers.",

"Builders throttled to ~1–2 gains/turn to avoid runaway loops; adjust at Tier II/III if needed."

]
}
}
13) Tier Effects (human text)

What this section does

Provides the player-facing narrative of how the class and each subclass evolves by tier (I–IV) with optional
keystone callouts. This is not mechanical data—it's the curated text used by:

§6 tierTextPointer (per-subclass “About this subclass” panels)
Tooltips, README, and mod page summaries
§12 plan cross-links (for QA consistency)
No grants or stats live here; keep it readable, concise, and aligned with §4–§12.

Authoring (drop-in JSON — GENERIC with tips)

{
"tierEffects": {

"classSummary": {

"overview": "TIP — 2–3 sentences describing the class fantasy and rotation pillars.",

"resourceNotes": [

"TIP — Mention §9 resource archetype(s) at a high level (e.g., 'build with X, spend on Y').",

"TIP — Windows/thresholds (e.g., 'finishers hit hardest at high pips')."

],
"castingNotes": [

"TIP — If §10/§11 enable casting, outline the model (Full/Half/Third/Points) and high-slot milestones.",

"TIP — If 7–9 slots rely on an external mod, note it neutrally."

]
},
"tiers": {

"I": {
"levels": "1–4",

"classBeats": [

"TIP — What comes online early: proficiencies, baseline stance, first builder/spender access."

],
"keystone": "TIP — If you put a class keystone at 9 instead, leave this empty."

},

"II": {
"levels": "5–8",

"classBeats": [

"TIP — Martial window (Extra Attack I) or first meaningful slot tier for casters.",

"TIP — Efficiency knobs (reduced costs, improved builders)."

],
"keystone": ""

},
"III": {
"levels": "9–13",

"classBeats": [

"TIP — Midgame identity spike; reference §12 milestones.",

"TIP — If Full casting with 9-level track, mention L7 slot at 13."

],
"keystone": "TIP — Note the signature mechanic if it lands here."

},
"IV": {
"levels": "14–20",

"classBeats": [

"TIP — Endgame scaling, sustain loops, and capstone.",

"TIP — If Full 9-level track, mention L8 at 15 and L9 at 17."

],
"keystone": "TIP — Capstone theme in one line."

}

},
"subclasses": [

{
"blockId": "SUBCLASS_A",

"overview": "TIP — One-paragraph subclass identity statement.",

"resourceNotes": [

"TIP — Reference §9 resource name and what builders/spenders do (no numbers)."

],
"tierBeats": {

"I": ["TIP — Early play pattern; any stance/aura that defines pacing."],

"II": ["TIP — First spender rank/defensive wall/utility spike."],

"III":["TIP — Keystone synergy or weave with class features."],

"IV": ["TIP — Endgame loop; what changes in boss fights."]

},
"keystones": {

"L9": "TIP — One-line headline of the L9 keystone.",

"L13": "TIP — One-line headline of the L13 keystone.",

"L15": "TIP — One-line headline of the L15 keystone.",

"L18": "TIP — One-line headline of the L18 keystone."

}
},
{
"blockId": "SUBCLASS_B",

"overview": "TIP — One-paragraph identity statement.",

"resourceNotes": ["TIP — How this subclass uses its meter differently."],

"tierBeats": { "I": [], "II": [], "III": [], "IV": [] },

"keystones": { "L9": "", "L13": "", "L15": "", "L18": "" }

},
{
"blockId": "SUBCLASS_C",

"overview": "TIP — Identity statement; mention hybrid casting if applicable.",

"resourceNotes": ["TIP — Builder/spender weave; buff windows if any."],

"tierBeats": { "I": [], "II": [], "III": [], "IV": [] },

"keystones": { "L9": "", "L13": "", "L15": "", "L18": "" }

}
],
"notes": [

"TIP — Keep statements sync'd with §12; the validator will check headings/keystone mentions.",

"TIP — Avoid numbers here; put mechanics in §7/§9/§11/§14."

]
}
}
Field-by-field (what each drives)

classSummary — Top-level copy used in the class info panel, README, and mod page.
tiers.I–IV — Short, human-readable summaries for each tier across the class; ties to §12 policy tiers.
subclasses[].blockId — Must match §6 catalogPointer.section7Block and §6 tierTextPointer.section13Block.
subclasses[].overview / resourceNotes — One paragraph + bullets on how the subclass plays; no hard
numbers.
tierBeats — Per-tier highlights, aligned with §12 beats; keep 1–3 bullets per tier for clarity.
keystones.L9/L13/L15/L18 — One-liners naming the “headline” feature at those levels (no rules text).
notes[] — Internal reminders; non-functional.
Validation checklist

Every subclasses[].blockId is present in §6 and §7 (pointers resolve cleanly).
Tier ranges (I–IV) align with §12 policy.tiers (3/8/13/18).
If §11 enables L7–L9 slots (Full 9-track or Spell Points High), Tier III/IV text mentions those milestones.
No numeric mechanics appear (keep those in §7/§9/§11/§14).
All keystone headings (9/13/15/18) exist for each subclass or are intentionally left blank with a note.
Common pitfalls & how to avoid them

Mechanics creep → Resist adding damage, DCs, or durations; link to §7/§14 keys instead.
Pointer drift → If you rename a subclass block, update blockId here and pointers in §6.
Caster mismatch → Don’t promise 7–9 slots in text unless §11 provides a track that enables it.
Improvement suggestions

Add "labels" per bullet (e.g., "Control", "Sustain", "Burst") so the renderer can tag text.
Add "spoilerFree": true on lines safe for mod pages (exporter can filter).
Provide a "marketingBlurb" variant for Nexus/Steam page copy separate from in-game tooltips.
Example (filled — flavour OK; matches our earlier setup)

{
"tierEffects": {

"classSummary": {

"overview": "A martial chassis that builds momentum through weapon strikes and converts it into powerful

finishers. Defensive stances and tactical windows define the rhythm.",

"resourceNotes": [

"Your meter grows through on-hit builders and fuels spenders that scale with additional pips.",

"Windows matter: hold for high-impact finishers or drip for control and defense."

],
"castingNotes": [

"One subclass weaves light magic (Half/Full track as configured).",

"If your loadout supports high-level slots, milestones arrive at L13 (7th), L15 (8th), and L17 (9th)."

]
},
"tiers": {

"I": {
"levels": "1–4",

"classBeats": [

"Foundational stance and first builder/spender unlock establish the core loop."

],
"keystone": ""

},
"II": {
"levels": "5–8",

"classBeats": [

"Martial window opens (Extra Attack I) or first meaningful slot tier for casters.",

"Smoother generation and cheaper key tools shape a midgame rotation."

],
"keystone": ""

},
"III": {
"levels": "9–13",

"classBeats": [

"Signature mechanic lands; subclass identities diverge sharply.",

"If using a 9-level track, 7th-level slots become available at L13."

],
"keystone": "Midgame keystone consolidates the build’s primary play pattern."

},
"IV": {
"levels": "14–20",

"classBeats": [

"Endgame sustain and capstone finalize the loop.",

"If supported, 8th-level slots at L15 and 9th-level slots at L17."

],
"keystone": "Capstone brings a unique surge or permanent boon."

}
},
"subclasses": [

{
"blockId": "BERSERKER",

"overview": "Relentless frontline bruiser who channels rage into crushing finishers.",

"resourceNotes": [

"Rage builds on hits and fuels heavy finishers; hold pips for big windows."

],
"tierBeats": {

"I": ["Early builder and stance establish aggressive momentum."],

"II": ["Finisher rank and efficiency improve the damage window."],

"III":["Keystone unlocks burst tools keyed to high pip spends."],

"IV": ["Execute-leaning payoffs and a powerful endgame surge."]

},
"keystones": {

"L9": "Fury Window",

"L13": "Bloodrush",

"L15": "Relentless Critical",

"L18": "Unstoppable Onslaught"

}
},
{
"blockId": "SENTINEL",

"overview": "Shielded guardian who converts resolve into wards and counters.",

"resourceNotes": [

"Resolve accumulates steadily; spenders project protection and control."

],
"tierBeats": {

"I": ["Ward baseline anchors the frontline."],

"II": ["Counter-taunt tools stabilize tough encounters."],

"III":["Reaction engine matures; group mitigation rises."],

"IV": ["Bulwark-grade protection and reliable boss uptime."]

},
"keystones": {

"L9": "Bulwark Answer",

"L13": "Unyielding Guard",

"L15": "Perfect Read",

"L18": "Aegis of the Many"

}
},
{
"blockId": "WARCHANT",

"overview": "Battle skald who weaves weapon rhythm with inspiring magic.",

"resourceNotes": [

"Tempo grows on strikes; finishers and buffs weave into a supportive cadence."

],
"tierBeats": {

"I": ["Hybrid loop of light spells and weapon tempo."],

"II": ["Anthem tools elevate allies; spender rank improves burst."],

"III":["Keystone syncs spenders with buffs; 7th-level slots arrive if on Full 9-track."],

"IV": ["Chorus-style overdrive with late-tier spells; 8th/9th-level slots if available."]

},
"keystones": {

"L9": "Echoing Anthem",

"L13": "Resonant Verse",

"L15": "Crescendo",

"L18": "Endless Refrain"

}
}
],
"notes": [

"Keep this text updated if §12 milestones change.",

"Surface external requirements (e.g., high-level slots) only as neutral notes."

]
}
}
Authoring stub (generic, tier-aware; no flavour)

{

"upgradeTracks": {

"TRACK___CORE": [
{ "atTier": "I", "apply": [ { "target": "ACTION_<...>_PrimaryStrike", "delta": { "damageDieBonus": 1 } } ] },

{ "atTier": "II", "apply": [ { "target": "ACTION_<...>_PrimaryStrike", "delta": { "damageDieBonus": 2 } } ] },

{ "atTier": "III", "apply": [ { "target": "ACTION_<...>_PrimaryStrike", "delta": { "damageDieBonus": 3 } } ] },

{ "atTier": "IV", "apply": [ { "target": "ACTION_<...>_PrimaryStrike", "delta": { "damageDieBonus": 4 } } ] }

],
"TRACK__STRIKES": [
{ "at": 5, "apply": [

{ "target": "ACTION_<...>_MortalStrike", "delta": { "damageDieBonus": 1 } },

{ "target": "ACTION_<...>Overpower", "delta": { "statusBonusTo": "ACTION<...>_MortalStrike",
"damageDieBonusDelta": 1 } },

{ "target": "ACTION_<...>_Execute", "delta": { "damageDieBonus": 1 } }

]},
{ "at": 10, "apply": [

{ "target": "ACTION_<...>_MortalStrike", "delta": { "damageDieBonus": 2 } },

{ "target": "ACTION_<...>Overpower", "delta": { "statusBonusTo": "ACTION<...>_MortalStrike",

"damageDieBonusDelta": 1 } },

{ "target": "ACTION_<...>_Execute", "delta": { "damageDieBonus": 2 } }

]},
{ "at": 15, "apply": [

{ "target": "ACTION_<...>_MortalStrike", "delta": { "damageDieBonus": 3 } },

{ "target": "ACTION_<...>Overpower", "delta": { "statusBonusTo": "ACTION<...>_MortalStrike",

"damageDieBonusDelta": 1 } },

{ "target": "ACTION_<...>_Execute", "delta": { "damageDieBonus": 3 } }

]},
{ "at": 20, "apply": [

{ "target": "ACTION_<...>_MortalStrike", "delta": { "damageDieBonus": 4 } },

{ "target": "ACTION_<...>Overpower", "delta": { "statusBonusTo": "ACTION<...>_MortalStrike",
"damageDieBonusDelta": 1 } },

{ "target": "ACTION_<...>_Execute", "delta": { "damageDieBonus": 4 } }

]}
],
"TRACK__AOE": [
{ "at": 5, "apply": [

{ "target": "ACTION_<...>_Cleave", "delta": { "refEffect": "EFX_TwoTargetStrike" } },

{ "target": "ACTION_<...>_Bladestorm", "delta": { "damageDieBonus": 1 } }

]},

{ "at": 10, "apply": [

{ "target": "ACTION_<...>_Cleave", "delta": { "extraTargetIfAdjacent": true } },

{ "target": "ACTION_<...>_Bladestorm", "delta": { "damageDieBonus": 2 } }

]},

{ "at": 15, "apply": [

{ "target": "ACTION_<...>_Cleave", "delta": { "damageDieBonus": 1 } },

{ "target": "ACTION_<...>_Bladestorm", "delta": { "damageDieBonus": 3 } }

]},
{ "at": 20, "apply": [

{ "target": "ACTION_<...>_Cleave", "delta": { "damageDieBonus": 2 } },

{ "target": "ACTION_<...>_Bladestorm", "delta": { "damageDieBonus": 4 } }

]}
],
"TRACK__DOTS": [
{ "at": 5, "apply": [ { "target": "STATUS_<...>_Bleed_Rend", "delta": { "tickDiceBonus": 1 } } ] },

{ "at": 10, "apply": [ { "target": "STATUS_<...>_Bleed_DeepWounds", "delta": { "tickDiceBonus": 1 } } ] },

{ "at": 15, "apply": [ { "target": "STATUS_<...>_Bleed_Rend", "delta": { "tickDiceBonus": 2 } } ] },

{ "at": 20, "apply": [ { "target": "STATUS_<...>_Bleed_DeepWounds", "delta": { "tickDiceBonus": 2 } } ] }

],
"TRACK___UTILITY": [
{ "atTier": "I", "apply": [ { "target": "ACTION_<...>_RallyingCry_THP", "delta": { "diceTierBonus": 1 } } ] },

{ "atTier": "II", "apply": [ { "target": "ACTION_<...>_RallyingCry_THP", "delta": { "diceTierBonus": 2 } } ] },

{ "atTier": "III","apply": [ { "target": "ACTION_<...>_RallyingCry_THP", "delta": { "diceTierBonus": 3 } } ] },

{ "atTier": "IV", "apply": [ { "target": "ACTION_<...>_RallyingCry_THP", "delta": { "diceTierBonus": 4 } } ] }

]
}
}
Delta vocabulary (what we’ll validate/transform)

damageDieBonus / tickDiceBonus — increments to damage/heal dice tiers.
damageDieBonusDelta — bonus granted conditionally (e.g., from a buff/status to another action).
extraTargetIfAdjacent / refEffect — toggles or swaps to predefined effect templates.
statusBonusTo — links a buffing action/status to a target action (exporter emits the proper Status/Passive
modifier).
Plus the common numeric knobs: saveDCBonus, attackRollBonus, rangeMetersDelta, durationTurnsDelta,
etc.
Validator rules we’ll enforce in §20

Every target must exist in §5 or §7.
Tier-aware rows resolve to concrete levels using §12.policy.tiers (default: I→5, II→10, III→15, IV→20).
No negative tier/level or duplicate at for the same track.
Deltas must use allowed fields (we’ll lint unknown knobs).
Cross-references (statusBonusTo, refEffect) must resolve to known keys/templates.
14) Progression (authoring)

What this section does

Authoritative, atomic grants for levels 1–20, wiring:

Talent cadence
Class Talents (ROW_1 auto-grant at L1, then ROW_2→ROW_10 every 2 levels).
SubclassSpec Talents (ROW_1 auto-grant at L1 incl. passives, then ROW_2→ROW_10 every 2 levels).
SubclassBase (BUCKET) : L1 two picks (1 Offense + 1 Utility), then 1 pick each level from L2→ from
LIST_SUBCLASSBASE_ALL until exhausted.
Specialization: Key + Capstone at 13; Choice Nodes at 13/15/18; Passives stream 13→20.
Resources/Casting/Upgrade markers/High-slot gate as before.
Authoring (drop-in JSON — GENERIC with tips)

{
"progression": {

"policy": {

"subclassUnlockLevel": 1,

"featLevels": [4, 8, 12, 16, 20],

"tierBreaks": [5, 8, 13, 18],

"talentCadence": {

"class": { "start": 3, "everyN": 2, "rows":
["ROW_2","ROW_3","ROW_4","ROW_5","ROW_6","ROW_7","ROW_8","ROW_9","ROW_10"] },

"spec": { "start": 3, "everyN": 2, "rows":

["ROW_2","ROW_3","ROW_4","ROW_5","ROW_6","ROW_7","ROW_8","ROW_9","ROW_10"] },

"baseBucket": {

"level1BonusPicks": { "OFFENSE": 1, "UTILITY": 1 },

"stream": { "start": 2, "end": 20, "perLevel": 1, "listKey": "LIST_SUBCLASSBASE_ALL", "stopWhenComplete":
true },

"notes": "TIP — No row gating; ALL is the curated baseline bucket."

},

"special": {

"keyAt": 13, "capstoneAt": 13,

"nodes": [

{ "listKey": "LIST_SPEC_CHOICES_1", "at": 13, "choose": 1 },

{ "listKey": "LIST_SPEC_CHOICES_2", "at": 15, "choose": 1 },

{ "listKey": "LIST_SPEC_CHOICES_3", "at": 18, "choose": 1 }

],
"passives": { "start": 13, "end": 20, "perLevel": 1, "listKey": "LIST_SPEC_PASSIVES", "stopWhenComplete": true

}

}
},
"notes": "TIP — Mirrors §8 groups/definitions and §12 plan; validator will flag drift."

},
"rows": [

/* L1 — Class chassis */

{ "id": "ROW_L1_CORE_PROFS", "level": 1, "scope": "CLASS", "appliesTo": "CLASS", "type": "Proficiency", "key":
"PROF___START", "tags": ["starter"] },

{ "id": "ROW_L1_BASE_STANCE", "level": 1, "scope": "CLASS", "appliesTo": "CLASS", "type": "Passive", "key":

"PASSIVE___BASE_STANCE", "tags": ["stance"] },

{ "id": "ROW_L1_PRIMARY_STRIKE", "level": 1, "scope": "CLASS", "appliesTo": "CLASS", "type": "Action", "key":

"ACTION___PRIMARY_STRIKE", "tags": ["builder"] },

/* L1 — Subclass selection */

{ "id": "ROW_L1_PICK_SUBCLASS", "level": 1, "scope": "CLASS", "appliesTo": "CLASS", "type": "Choice",
"choiceListKey": "CHOICE___SUBCLASSES", "tags": ["subclass"] },

/* L1 — Example subclass A bindings (repeat pattern per subclass) */

{ "id": "ROW_L1_SUBA_RES_BIND", "level": 1, "scope": "SUBCLASS_A", "appliesTo":
"SUBCLASSA", "type": "ResourceBind", "key": "RES__A",

"tags": ["resource"] },

{ "id": "ROW_L1_SUBA_CAST_BIND", "level": 1, "scope": "SUBCLASS___A", "appliesTo":

"SUBCLASS___A", "type": "CasterBind", "key": "CASTTRACK_TIP—
STANDARD_FULL_9|STANDARD_HALF_9|STANDARD_THIRD_9|SPELL_POINTS_HIGH|None", "tags": ["casting"],

"notes": "TIP — Only if this subclass casts." },

/* TALENTS — Class: Row 1 at L1; cadence for Row 2..10 */

{ "id": "ROW_L1_CLASS_TALENTS_ROW1_UNLOCK", "level": 1, "scope": "CLASS", "appliesTo": "CLASS", "type":
"ListUnlock", "key": "LIST_CLASS_TALENTS_ROW_1", "tags": ["talent","class"] },

{ "id": "ROW_L1_CLASS_TALENTS_ROW1_ALL", "level": 1, "scope": "CLASS", "appliesTo": "CLASS", "type":
"Choice", "choiceListKey": "LIST_CLASS_TALENTS_ROW_1", "quantity": "ALL", "tags": ["talent","grantAll"] },

{ "id": "ROW_L3_CLASS_TALENT_ROW2", "level": 3, "scope": "CLASS", "appliesTo": "CLASS", "type": "Choice",
"choiceListKey": "LIST_CLASS_TALENTS_ROW_2", "quantity": 1, "tags": ["talent","cadence2"] },

{ "id": "ROW_L5_CLASS_TALENT_ROW3", "level": 5, "scope": "CLASS", "appliesTo": "CLASS", "type": "Choice",
"choiceListKey": "LIST_CLASS_TALENTS_ROW_3", "quantity": 1, "tags": ["talent","cadence2"] },

{ "id": "ROW_L7_CLASS_TALENT_ROW4", "level": 7, "scope": "CLASS", "appliesTo": "CLASS", "type": "Choice",
"choiceListKey": "LIST_CLASS_TALENTS_ROW_4", "quantity": 1, "tags": ["talent","cadence2"] },

{ "id": "ROW_L9_CLASS_TALENT_ROW5", "level": 9, "scope": "CLASS", "appliesTo": "CLASS", "type": "Choice",
"choiceListKey": "LIST_CLASS_TALENTS_ROW_5", "quantity": 1, "tags": ["talent","cadence2"] },

{ "id": "ROW_L11_CLASS_TALENT_ROW6", "level": 11, "scope": "CLASS","appliesTo": "CLASS","type":
"Choice","choiceListKey":"LIST_CLASS_TALENTS_ROW_6","quantity":1,"tags":["talent","cadence2"] },

{ "id": "ROW_L13_CLASS_TALENT_ROW7", "level": 13, "scope": "CLASS","appliesTo": "CLASS","type":
"Choice","choiceListKey":"LIST_CLASS_TALENTS_ROW_7","quantity":1,"tags":["talent","cadence2"] },

{ "id": "ROW_L15_CLASS_TALENT_ROW8", "level": 15, "scope": "CLASS","appliesTo": "CLASS","type":

"Choice","choiceListKey":"LIST_CLASS_TALENTS_ROW_8","quantity":1,"tags":["talent","cadence2"] },

{ "id": "ROW_L17_CLASS_TALENT_ROW9", "level": 17, "scope": "CLASS","appliesTo": "CLASS","type":

"Choice","choiceListKey":"LIST_CLASS_TALENTS_ROW_9","quantity":1,"tags":["talent","cadence2"] },

{ "id": "ROW_L19_CLASS_TALENT_ROW10","level": 19, "scope": "CLASS","appliesTo": "CLASS","type":

"Choice","choiceListKey":"LIST_CLASS_TALENTS_ROW_10","quantity":1,"tags":["talent","cadence2"] },

/* TALENTS — SubclassSpec: Row 1 at L1; cadence for Row 2..10 (per subclass) */

{ "id": "ROW_L1_SUBA_SPEC_PASSIVES", "level": 1, "scope": "SUBCLASS_A",
"appliesTo": "SUBCLASS_A", "type": "Choice", "choiceListKey":

"LIST_SUBCLASSSPEC_PASSIVES_ROW_1", "quantity": "ALL", "tags": ["talent","passive","grantAll"], "notes": "TIP —
Omit if none." },

{ "id": "ROW_L1_SUBA_SPEC_ROW1_UNLOCK", "level": 1, "scope": "SUBCLASS_A",
"appliesTo": "SUBCLASS_A", "type": "ListUnlock", "key":
"LIST_SUBCLASSSPEC_ROW_1", "tags": ["talent"] },

{ "id": "ROW_L1_SUBA_SPEC_ROW1_ALL", "level": 1, "scope": "SUBCLASS_A",
"appliesTo": "SUBCLASS_A", "type": "Choice", "choiceListKey":

"LIST_SUBCLASSSPEC_ROW_1", "quantity": "ALL", "tags": ["talent","grantAll"] },

{ "id": "ROW_L3_SUBA_SPEC_ROW2", "level": 3, "scope": "SUBCLASS_A",
"appliesTo": "SUBCLASS_A", "type": "Choice", "choiceListKey":
"LIST_SUBCLASSSPEC_ROW_2", "quantity": 1, "tags": ["talent","cadence2"] },

{ "id": "ROW_L5_SUBA_SPEC_ROW3", "level": 5, "scope": "SUBCLASS_A",
"appliesTo": "SUBCLASS_A", "type": "Choice", "choiceListKey":

"LIST_SUBCLASSSPEC_ROW_3", "quantity": 1, "tags": ["talent","cadence2"] },

{ "id": "ROW_L7_SUBA_SPEC_ROW4", "level": 7, "scope": "SUBCLASS___A",

"appliesTo": "SUBCLASS___A", "type": "Choice", "choiceListKey":
"LIST_SUBCLASSSPEC_ROW_4", "quantity": 1, "tags": ["talent","cadence2"] },

{ "id": "ROW_L9_SUBA_SPEC_ROW5", "level": 9, "scope": "SUBCLASS_A",
"appliesTo": "SUBCLASS_A", "type": "Choice", "choiceListKey":

"LIST_SUBCLASSSPEC_ROW_5", "quantity": 1, "tags": ["talent","cadence2"] },

{ "id": "ROW_L11_SUBA_SPEC_ROW6", "level": 11, "scope": "SUBCLASS___A",

"appliesTo": "SUBCLASS___A", "type": "Choice", "choiceListKey":
"LIST_SUBCLASSSPEC_ROW_6", "quantity": 1, "tags": ["talent","cadence2"] },

{ "id": "ROW_L13_SUBA_SPEC_ROW7", "level": 13, "scope": "SUBCLASS___A",

"appliesTo": "SUBCLASS___A", "type": "Choice", "choiceListKey":
"LIST_SUBCLASSSPEC_ROW_7", "quantity": 1, "tags": ["talent","cadence2"] },

{ "id": "ROW_L15_SUBA_SPEC_ROW8", "level": 15, "scope": "SUBCLASS_A",
"appliesTo": "SUBCLASS_A", "type": "Choice", "choiceListKey":

"LIST_SUBCLASSSPEC_ROW_8", "quantity": 1, "tags": ["talent","cadence2"] },

{ "id": "ROW_L17_SUBA_SPEC_ROW9", "level": 17, "scope": "SUBCLASS___A",

"appliesTo": "SUBCLASS___A", "type": "Choice", "choiceListKey":
"LIST_SUBCLASSSPEC_ROW_9", "quantity": 1, "tags": ["talent","cadence2"] },

{ "id": "ROW_L19_SUBA_SPEC_ROW10","level": 19, "scope": "SUBCLASS_A",
"appliesTo": "SUBCLASS_A", "type": "Choice", "choiceListKey":
"LIST_SUBCLASSSPEC_ROW_10","quantity": 1, "tags": ["talent","cadence2"] },

/* TALENTS — SubclassBase BUCKET: L1 Offense+Utility, then L2+ baseline stream until done */

{ "id": "ROW_L1_SUBA_BASE_OFF", "level": 1, "scope": "SUBCLASS_A", "appliesTo":
"SUBCLASS_A", "type": "Choice", "choiceListKey": "LIST_SUBCLASSBASE_OFFENSE",

"quantity": 1, "tags": ["talent","baseline","offense"] },

{ "id": "ROW_L1_SUBA_BASE_UTL", "level": 1, "scope": "SUBCLASS___A", "appliesTo":

"SUBCLASS___A", "type": "Choice", "choiceListKey": "LIST_SUBCLASSBASE_UTILITY",
"quantity": 1, "tags": ["talent","baseline","utility"] },

{ "id": "ROW_L2P_SUBA_BASE_ANY","level": 2, "scope": "SUBCLASS___A", "appliesTo":

"SUBCLASS___A", "type": "Choice", "choiceListKey": "LIST_SUBCLASSBASE_ALL",
"quantity": 1, "tags": ["talent","baseline","repeatTillComplete"], "notes": "TIP — Exporter skips automatically once

ALL is exhausted." },

/* FEATS & UPGRADE MARKERS */
{ "id": "ROW_L4_FEAT", "level": 4, "scope": "CLASS", "appliesTo": "CLASS", "type": "Choice", "choiceListKey":

"CHOICE__GENERIC_FEATS", "quantity": 1, "tags": ["feat"] },

{ "id": "ROW_L8_FEAT", "level": 8, "scope": "CLASS", "appliesTo": "CLASS", "type": "Choice", "choiceListKey":

"CHOICE__GENERIC_FEATS", "quantity": 1, "tags": ["feat"] },

{ "id": "ROW_L12_FEAT", "level": 12, "scope": "CLASS", "appliesTo": "CLASS", "type": "Choice", "choiceListKey":

"CHOICE__GENERIC_FEATS", "quantity": 1, "tags": ["feat"] },

{ "id": "ROW_L16_FEAT", "level": 16, "scope": "CLASS", "appliesTo": "CLASS", "type": "Choice", "choiceListKey":

"CHOICE__GENERIC_FEATS", "quantity": 1, "tags": ["feat"] },

{ "id": "ROW_L20_FEAT", "level": 20, "scope": "CLASS", "appliesTo": "CLASS", "type": "Choice", "choiceListKey":
"CHOICE__GENERIC_FEATS", "quantity": 1, "tags": ["feat"] },

{ "id": "ROW_L5_MARK_TIER_I", "level": 5, "scope": "CLASS", "appliesTo": "CLASS", "type": "UpgradeMarker",

"key": "MARK_TIER_I", "tags": ["upgrade"] },

{ "id": "ROW_L8_MARK_TIER_II", "level": 8, "scope": "CLASS", "appliesTo": "CLASS", "type": "UpgradeMarker",

"key": "MARK_TIER_II", "tags": ["upgrade"] },

{ "id": "ROW_L13_MARK_TIER_III","level": 13, "scope": "CLASS", "appliesTo": "CLASS", "type": "UpgradeMarker",

"key": "MARK_TIER_III", "tags": ["upgrade"] },

{ "id": "ROW_L18_MARK_TIER_IV", "level": 18, "scope": "CLASS", "appliesTo": "CLASS", "type": "UpgradeMarker",
"key": "MARK_TIER_IV", "tags": ["upgrade"] },

/* SPECIALIZATION package (per subclass) */

{ "id": "ROW_L13_SUBA_SPEC_KEY", "level": 13, "scope": "SUBCLASS_A",
"appliesTo": "SUBCLASS_A", "type": "Choice", "choiceListKey":

"LIST_SPEC_KEY_TALENT", "quantity": 1, "tags": ["talent","specialization","key"] },

{ "id": "ROW_L13_SUBA_SPEC_CAPSTONE", "level": 13, "scope": "SUBCLASS_A",
"appliesTo": "SUBCLASS_A", "type": "Choice", "choiceListKey": "LIST_SPEC_CAPSTONE",

"quantity": 1, "tags": ["talent","specialization","capstone"] },

{ "id": "ROW_L13_SUBA_NODE1", "level": 13, "scope": "SUBCLASS___A", "appliesTo":

"SUBCLASS___A", "type": "Choice", "choiceListKey": "LIST_SPEC_CHOICES_1", "quantity":
1, "tags": ["talent","specialization","choiceNode"] },

{ "id": "ROW_L15_SUBA_NODE2", "level": 15, "scope": "SUBCLASS_A", "appliesTo":
"SUBCLASS_A", "type": "Choice", "choiceListKey": "LIST_SPEC_CHOICES_2", "quantity":

1, "tags": ["talent","specialization","choiceNode"] },

{ "id": "ROW_L18_SUBA_NODE3", "level": 18, "scope": "SUBCLASS___A", "appliesTo":

"SUBCLASS___A", "type": "Choice", "choiceListKey": "LIST_SPEC_CHOICES_3", "quantity":
1, "tags": ["talent","specialization","choiceNode"] },

{ "id": "ROW_L13_SUBA_SPEC_PASSIVE", "level": 13, "scope": "SUBCLASS_A",
"appliesTo": "SUBCLASS_A", "type": "Choice", "choiceListKey": "LIST_SPEC_PASSIVES",
"quantity": 1, "tags": ["talent","specialization","passive"] },

{ "id": "ROW_L14_SUBA_SPEC_PASSIVE", "level": 14, "scope": "SUBCLASS_A",
"appliesTo": "SUBCLASS_A", "type": "Choice", "choiceListKey": "LIST_SPEC_PASSIVES",

"quantity": 1, "tags": ["talent","specialization","passive"] },

{ "id": "ROW_L15_SUBA_SPEC_PASSIVE", "level": 15, "scope": "SUBCLASS___A",

"appliesTo": "SUBCLASS___A", "type": "Choice", "choiceListKey": "LIST_SPEC_PASSIVES",
"quantity": 1, "tags": ["talent","specialization","passive"] },

{ "id": "ROW_L16_SUBA_SPEC_PASSIVE", "level": 16, "scope": "SUBCLASS_A",
"appliesTo": "SUBCLASS_A", "type": "Choice", "choiceListKey": "LIST_SPEC_PASSIVES",

"quantity": 1, "tags": ["talent","specialization","passive"] },

{ "id": "ROW_L17_SUBA_SPEC_PASSIVE", "level": 17, "scope": "SUBCLASS_A",
"appliesTo": "SUBCLASS_A", "type": "Choice", "choiceListKey": "LIST_SPEC_PASSIVES",

"quantity": 1, "tags": ["talent","specialization","passive"] },

{ "id": "ROW_L18_SUBA_SPEC_PASSIVE", "level": 18, "scope": "SUBCLASS___A",

"appliesTo": "SUBCLASS___A", "type": "Choice", "choiceListKey": "LIST_SPEC_PASSIVES",
"quantity": 1, "tags": ["talent","specialization","passive"] },

{ "id": "ROW_L19_SUBA_SPEC_PASSIVE", "level": 19, "scope": "SUBCLASS_A",
"appliesTo": "SUBCLASS_A", "type": "Choice", "choiceListKey": "LIST_SPEC_PASSIVES",

"quantity": 1, "tags": ["talent","specialization","passive"] },

{ "id": "ROW_L20_SUBA_SPEC_PASSIVE", "level": 20, "scope": "SUBCLASS___A",

"appliesTo": "SUBCLASS___A", "type": "Choice", "choiceListKey": "LIST_SPEC_PASSIVES",
"quantity": 1, "tags": ["talent","specialization","passive"] },

/* High-slot integration (optional) */

{ "id": "ROW_L17_HIGH_MAGIC_BOON", "level": 17, "scope": "SUBCLASS___A",

"appliesTo": "SUBCLASS__A", "type": "Passive", "key":
"PASSIVE_HIGH_MAGIC_BOON", "tags": ["casting","gate"] }

]
}
}
Field-by-field (what each drives)

policy.talentCadence.baseBucket — the SubclassBase logic: L1 double-pick, then a per-level stream from
LIST_SUBCLASSBASE_ALL.
rows — the concrete Choice rows: two at L1 (OFFENSE, UTILITY), then the repeating
ROW_L2P_SUBA_BASE_ANY line at L2 that the exporter repeats each level until the list is empty.
Validation checklist (this section)

SubclassBase
LIST_SUBCLASSBASE_OFFENSE, LIST_SUBCLASSBASE_UTILITY, and LIST_SUBCLASSBASE_ALL exist in
§8.
L1 includes exactly two SubclassBase picks (one Offense, one Utility).
From L2 to 20 , there’s a single repeating SubclassBase ALL pick; exporter/validator ensures no dupes
and auto-stops when exhausted.
No SubclassBase rows anywhere (we removed them).
Class/SubclassSpec cadence still covers ROW_2→ROW_10 exactly once each.
Specialization package hits 13 (Key/Capstone/Node1), 15 (Node2), 18 (Node3), 13–20 Passives.
Common pitfalls & how to avoid them

ALL list curation — Keep ALL as a curated union of baseline abilities. If you add/removes items later, ensure
saved games don’t already own duplicates (validator warns).
Per-level stream + Feat levels — Having both at L4/8/12/16/20 is fine (distinct rows).
Bucket exhaustion — If the ALL list runs out early, remaining ROW_L2P_SUBA_BASE_ANY rows silently no-op
(exporter skips).
Improvement suggestions

Add maxPicks metadata to ALL (in §8) so the validator can predict exhaustion and highlight when/if it will
complete before L20.
Add "labels":["Baseline"] to these rows so §15 can group them visually.
Example (filled — minimal, neutral)

{
"progression": {

"policy": {

"subclassUnlockLevel": 1,

"featLevels": [4,8,12,16,20],

"tierBreaks": [5,8,13,18],

"talentCadence": {

"class": { "start": 3, "everyN": 2, "rows":
["ROW_2","ROW_3","ROW_4","ROW_5","ROW_6","ROW_7","ROW_8","ROW_9","ROW_10"] },

"spec": { "start": 3, "everyN": 2, "rows":
["ROW_2","ROW_3","ROW_4","ROW_5","ROW_6","ROW_7","ROW_8","ROW_9","ROW_10"] },

"baseBucket": { "level1BonusPicks": { "OFFENSE": 1, "UTILITY": 1 }, "stream": { "start": 2, "end": 20, "perLevel":
1, "listKey": "LIST_SUBCLASSBASE_ALL", "stopWhenComplete": true } },

"special": { "keyAt": 13, "capstoneAt": 13, "nodes": [{"listKey":"LIST_SPEC_CHOICES_1","at":13,"choose":1},
{"listKey":"LIST_SPEC_CHOICES_2","at":15,"choose":1},{"listKey":"LIST_SPEC_CHOICES_3","at":18,"choose":1}],

"passives": { "start": 13, "end": 20, "perLevel": 1, "listKey": "LIST_SPEC_PASSIVES", "stopWhenComplete": true } }

},
"notes": ""

},
"rows": [

{ "id": "ROW_L1_SUBA_BASE_OFF", "level": 1, "scope": "SUBCLASS_VORGX_FIGHTER_A", "appliesTo":
"SUBCLASS_VORGX_FIGHTER_A", "type": "Choice", "choiceListKey": "LIST_SUBCLASSBASE_OFFENSE", "quantity":

1, "tags": ["talent","baseline"] },

{ "id": "ROW_L1_SUBA_BASE_UTL", "level": 1, "scope": "SUBCLASS_VORGX_FIGHTER_A", "appliesTo":

"SUBCLASS_VORGX_FIGHTER_A", "type": "Choice", "choiceListKey": "LIST_SUBCLASSBASE_UTILITY", "quantity": 1,
"tags": ["talent","baseline"] },

{ "id": "ROW_L2P_SUBA_BASE_ANY", "level": 2, "scope": "SUBCLASS_VORGX_FIGHTER_A", "appliesTo":
"SUBCLASS_VORGX_FIGHTER_A", "type": "Choice", "choiceListKey": "LIST_SUBCLASSBASE_ALL", "quantity": 1,

"tags": ["talent","baseline","repeatTillComplete"] }

/* ... plus all the other rows from above for class/spec/specialization/feats/markers ... */

]
}
}
15) Progression (rendered table)

What this section does

Renders your §14 “authoring rows” into a fully-expanded, chronological table (1–20) with one row per
grant.
Repeats cadence patterns (e.g., “pick 1 each level”) into explicit rows for each affected level.
Feeds the UI table , validator cross-checks , and export pipeline (Progressions/Stats/Passives/Lists/Loc).
Authoring (drop-in JSON — GENERIC with tips)

{
"renderedProgression": {

"columns": ["level","scope","appliesTo","grantType","key","choiceListKey","quantity","perRest","charges","tags"],

"notes": [

"TIP — This section is auto-derived from §14; hand-edit only if your pipeline supports overrides.",

"TIP — Keep values atomic; no comments inside values.",

"TIP — Empty fields should be null, not omitted, if your tooling expects fixed-width rows."

],
"rows": [

{ "level": 1, "scope": "TIP — CLASS|SUBCLASS_<...>", "appliesTo": "TIP — same as scope", "grantType": "TIP —
Action|Passive|Choice|Feat|ListUnlock|ResourceBind|CasterBind|UpgradeMarker|...", "key": "", "choiceListKey": "",

"quantity": 0, "perRest": null, "charges": null, "tags": [] }

/* TIP — Populate with a row for every concrete grant. See Example below. */

]
}
}
Field-by-field (what each drives)

columns — Fixed schema for every row; renderers/validators assume this order.
rows[]
level — Character level for the grant.
scope/appliesTo — CLASS for global grants; or the exact subclass key (e.g., SUBCLASS_VORGX_WAR_A).
grantType — Mirrors §14 type.
key — Concrete asset key for non-Choice rows (Action/Passive/etc.); null for Choice rows.
choiceListKey — Present only for grantType="Choice" or ListUnlock.
quantity — 1, ALL, or numeric.
perRest/charges — Optional resource limits (stick to null if unused).
tags — Non-functional labels used by your renderer/validator (e.g., ["feat"], ["talent","baseline"]).
Validation checklist (for this section)

Every §14 row appears here exactly once per concrete grant (cadence rows are fully expanded ).
Order is strictly increasing by level; ties at a level keep class rows before subclass for readability.
Choice rows have choiceListKey set and key=null; non-choice rows invert that (have key set,
choiceListKey=null).
SubclassBase bucket correctly expands to: L1×2 picks (OFFENSE & UTILITY) and L2→20 ×1 pick/level until
LIST_SUBCLASSBASE_ALL is exhausted.
Specialization shows: L13: Key + Capstone + ChoiceNode1 + Passive , L15: ChoiceNode2 + Passive , L18:
ChoiceNode3 + Passive , plus passives at 14/16/17/19/20.
Tier markers present at 5/8/13/18 (or your §14 policy), and Feat rows at 4/8/12/16/20.
All keys/lists referenced exist in §§5–8–9–10–11.
Common pitfalls & how to avoid them

Forgetting to expand streams — Ensure “pick every level” items render as distinct rows per level (L2→20).
Mixing up key vs. choiceListKey — Only Choice/ListUnlock use choiceListKey; everything else uses key.
Subclass scoping typos — The appliesTo value must exactly match §6 identifiers.
Row collisions — If two rows at the same level grant the same key, dedupe (validator should warn).
Improvement suggestions

Add "labels" for renderer colouring (e.g., "labels":["Cadence","Tier II"]) without changing the fixed columns.
Emit a "diffFromSection14": {...} blob for QA showing any divergence (hand-edits here vs. §14).
Example (filled — generic, reflects §14 exactly)

Notes• This example shows a complete expansion for one class with one subclass block

SUBCLASS_VORGX_WAR_A.• If you have multiple subclasses, repeat the subclass-scoped rows per subclass key.•
Where a stream is defined (SubclassBase ALL picks), we explicitly list every level it fires.

{
"renderedProgression": {

"columns": ["level","scope","appliesTo","grantType","key","choiceListKey","quantity","perRest","charges","tags"],

"notes": [],

"rows": [

/* ——— Level 1: chassis & unlocks ——— */

{ "level": 1, "scope": "CLASS", "appliesTo": "CLASS", "grantType": "Proficiency", "key":
"PROF_VORGX_WAR_START", "choiceListKey": null, "quantity": 1, "perRest": null, "charges": null, "tags": ["starter"]

},

{ "level": 1, "scope": "CLASS", "appliesTo": "CLASS", "grantType": "Passive", "key":

"PASSIVE_VORGX_WAR_BASE_STANCE", "choiceListKey": null, "quantity": 1, "perRest": null, "charges": null, "tags":
["stance"] },

{ "level": 1, "scope": "CLASS", "appliesTo": "CLASS", "grantType": "Action", "key":
"ACTION_VORGX_WAR_PRIMARY_STRIKE", "choiceListKey": null, "quantity": 1, "perRest": null, "charges": null,

"tags": ["builder"] },

{ "level": 1, "scope": "CLASS", "appliesTo": "CLASS", "grantType": "Choice", "key": null, "choiceListKey":

"CHOICE_VORGX_WAR_SUBCLASSES", "quantity": 1, "perRest": null, "charges": null, "tags": ["subclass"] },

{ "level": 1, "scope": "SUBCLASS_VORGX_WAR_A", "appliesTo": "SUBCLASS_VORGX_WAR_A", "grantType":
"ResourceBind", "key": "RES_VORGX_WAR_A", "choiceListKey": null, "quantity": 1, "perRest": null, "charges": null,
"tags": ["resource"] },

{ "level": 1, "scope": "SUBCLASS_VORGX_WAR_A", "appliesTo": "SUBCLASS_VORGX_WAR_A", "grantType":
"CasterBind", "key": "CASTTRACK_STANDARD_FULL_9", "choiceListKey": null, "quantity": 1, "perRest": null,

"charges": null, "tags": ["casting"] },

/* Class Talents — Row 1 ALL at L1 */

{ "level": 1, "scope": "CLASS", "appliesTo": "CLASS", "grantType": "ListUnlock", "key":

"LIST_CLASS_TALENTS_ROW_1", "choiceListKey": null, "quantity": 1, "perRest": null, "charges": null, "tags":
["talent","class"] },

{ "level": 1, "scope": "CLASS", "appliesTo": "CLASS", "grantType": "Choice", "key": null, "choiceListKey":

"LIST_CLASS_TALENTS_ROW_1", "quantity": "ALL", "perRest": null, "charges": null, "tags": ["talent","grantAll"] },

/* SubclassSpec — passives + Row 1 ALL at L1 */

{ "level": 1, "scope": "SUBCLASS_VORGX_WAR_A", "appliesTo": "SUBCLASS_VORGX_WAR_A", "grantType":

"Choice", "key": null, "choiceListKey": "LIST_SUBCLASSSPEC_PASSIVES_ROW_1", "quantity": "ALL", "perRest": null,
"charges": null, "tags": ["talent","passive","grantAll"] },

{ "level": 1, "scope": "SUBCLASS_VORGX_WAR_A", "appliesTo": "SUBCLASS_VORGX_WAR_A", "grantType":

"ListUnlock", "key": "LIST_SUBCLASSSPEC_ROW_1", "choiceListKey": null, "quantity": 1, "perRest": null, "charges":
null, "tags": ["talent"] },

{ "level": 1, "scope": "SUBCLASS_VORGX_WAR_A", "appliesTo": "SUBCLASS_VORGX_WAR_A", "grantType":
"Choice", "key": null, "choiceListKey": "LIST_SUBCLASSSPEC_ROW_1", "quantity": "ALL", "perRest": null, "charges":

null, "tags": ["talent","grantAll"] },

/* SubclassBase BUCKET — Offense + Utility picks at L1 */

{ "level": 1, "scope": "SUBCLASS_VORGX_WAR_A", "appliesTo": "SUBCLASS_VORGX_WAR_A", "grantType":
"Choice", "key": null, "choiceListKey": "LIST_SUBCLASSBASE_OFFENSE", "quantity": 1, "perRest": null, "charges":

null, "tags": ["talent","baseline","offense"] },

{ "level": 1, "scope": "SUBCLASS_VORGX_WAR_A", "appliesTo": "SUBCLASS_VORGX_WAR_A", "grantType":

"Choice", "key": null, "choiceListKey": "LIST_SUBCLASSBASE_UTILITY", "quantity": 1, "perRest": null, "charges":
null, "tags": ["talent","baseline","utility"] },

/* ——— Level 2 → 20: Baseline stream (1 pick per level until ALL exhausted) ——— */

{ "level": 2, "scope": "SUBCLASS_VORGX_WAR_A", "appliesTo": "SUBCLASS_VORGX_WAR_A", "grantType":

"Choice", "key": null, "choiceListKey": "LIST_SUBCLASSBASE_ALL", "quantity": 1, "perRest": null, "charges": null,
"tags": ["talent","baseline","stream"] },

{ "level": 3, "scope": "SUBCLASS_VORGX_WAR_A", "appliesTo": "SUBCLASS_VORGX_WAR_A", "grantType":
"Choice", "key": null, "choiceListKey": "LIST_SUBCLASSBASE_ALL", "quantity": 1, "perRest": null, "charges": null,

"tags": ["talent","baseline","stream"] },

{ "level": 4, "scope": "SUBCLASS_VORGX_WAR_A", "appliesTo": "SUBCLASS_VORGX_WAR_A", "grantType":

"Choice", "key": null, "choiceListKey": "LIST_SUBCLASSBASE_ALL", "quantity": 1, "perRest": null, "charges": null,
"tags": ["talent","baseline","stream"] },

{ "level": 5, "scope": "SUBCLASS_VORGX_WAR_A", "appliesTo": "SUBCLASS_VORGX_WAR_A", "grantType":
"Choice", "key": null, "choiceListKey": "LIST_SUBCLASSBASE_ALL", "quantity": 1, "perRest": null, "charges": null,

"tags": ["talent","baseline","stream"] },

{ "level": 6, "scope": "SUBCLASS_VORGX_WAR_A", "appliesTo": "SUBCLASS_VORGX_WAR_A", "grantType":
"Choice", "key": null, "choiceListKey": "LIST_SUBCLASSBASE_ALL", "quantity": 1, "perRest": null, "charges": null,

"tags": ["talent","baseline","stream"] },

{ "level": 7, "scope": "SUBCLASS_VORGX_WAR_A", "appliesTo": "SUBCLASS_VORGX_WAR_A", "grantType":

"Choice", "key": null, "choiceListKey": "LIST_SUBCLASSBASE_ALL", "quantity": 1, "perRest": null, "charges": null,
"tags": ["talent","baseline","stream"] },

{ "level": 8, "scope": "SUBCLASS_VORGX_WAR_A", "appliesTo": "SUBCLASS_VORGX_WAR_A", "grantType":
"Choice", "key": null, "choiceListKey": "LIST_SUBCLASSBASE_ALL", "quantity": 1, "perRest": null, "charges": null,

"tags": ["talent","baseline","stream"] },

{ "level": 9, "scope": "SUBCLASS_VORGX_WAR_A", "appliesTo": "SUBCLASS_VORGX_WAR_A", "grantType":

"Choice", "key": null, "choiceListKey": "LIST_SUBCLASSBASE_ALL", "quantity": 1, "perRest": null, "charges": null,
"tags": ["talent","baseline","stream"] },

{ "level": 10, "scope": "SUBCLASS_VORGX_WAR_A", "appliesTo": "SUBCLASS_VORGX_WAR_A", "grantType":

"Choice", "key": null, "choiceListKey": "LIST_SUBCLASSBASE_ALL", "quantity": 1, "perRest": null, "charges": null,
"tags": ["talent","baseline","stream"] },

{ "level": 11, "scope": "SUBCLASS_VORGX_WAR_A", "appliesTo": "SUBCLASS_VORGX_WAR_A", "grantType":
"Choice", "key": null, "choiceListKey": "LIST_SUBCLASSBASE_ALL", "quantity": 1, "perRest": null, "charges": null,
"tags": ["talent","baseline","stream"] },

{ "level": 12, "scope": "SUBCLASS_VORGX_WAR_A", "appliesTo": "SUBCLASS_VORGX_WAR_A", "grantType":

"Choice", "key": null, "choiceListKey": "LIST_SUBCLASSBASE_ALL", "quantity": 1, "perRest": null, "charges": null,
"tags": ["talent","baseline","stream"] },

{ "level": 13, "scope": "SUBCLASS_VORGX_WAR_A", "appliesTo": "SUBCLASS_VORGX_WAR_A", "grantType":
"Choice", "key": null, "choiceListKey": "LIST_SUBCLASSBASE_ALL", "quantity": 1, "perRest": null, "charges": null,
"tags": ["talent","baseline","stream"] },

{ "level": 14, "scope": "SUBCLASS_VORGX_WAR_A", "appliesTo": "SUBCLASS_VORGX_WAR_A", "grantType":
"Choice", "key": null, "choiceListKey": "LIST_SUBCLASSBASE_ALL", "quantity": 1, "perRest": null, "charges": null,

"tags": ["talent","baseline","stream"] },

{ "level": 15, "scope": "SUBCLASS_VORGX_WAR_A", "appliesTo": "SUBCLASS_VORGX_WAR_A", "grantType":

"Choice", "key": null, "choiceListKey": "LIST_SUBCLASSBASE_ALL", "quantity": 1, "perRest": null, "charges": null,
"tags": ["talent","baseline","stream"] },

{ "level": 16, "scope": "SUBCLASS_VORGX_WAR_A", "appliesTo": "SUBCLASS_VORGX_WAR_A", "grantType":
"Choice", "key": null, "choiceListKey": "LIST_SUBCLASSBASE_ALL", "quantity": 1, "perRest": null, "charges": null,

"tags": ["talent","baseline","stream"] },

{ "level": 17, "scope": "SUBCLASS_VORGX_WAR_A", "appliesTo": "SUBCLASS_VORGX_WAR_A", "grantType":

"Choice", "key": null, "choiceListKey": "LIST_SUBCLASSBASE_ALL", "quantity": 1, "perRest": null, "charges": null,
"tags": ["talent","baseline","stream"] },

{ "level": 18, "scope": "SUBCLASS_VORGX_WAR_A", "appliesTo": "SUBCLASS_VORGX_WAR_A", "grantType":

"Choice", "key": null, "choiceListKey": "LIST_SUBCLASSBASE_ALL", "quantity": 1, "perRest": null, "charges": null,
"tags": ["talent","baseline","stream"] },

{ "level": 19, "scope": "SUBCLASS_VORGX_WAR_A", "appliesTo": "SUBCLASS_VORGX_WAR_A", "grantType":
"Choice", "key": null, "choiceListKey": "LIST_SUBCLASSBASE_ALL", "quantity": 1, "perRest": null, "charges": null,
"tags": ["talent","baseline","stream"] },

{ "level": 20, "scope": "SUBCLASS_VORGX_WAR_A", "appliesTo": "SUBCLASS_VORGX_WAR_A", "grantType":

"Choice", "key": null, "choiceListKey": "LIST_SUBCLASSBASE_ALL", "quantity": 1, "perRest": null, "charges": null,
"tags": ["talent","baseline","stream"] },

/* ——— Feats and Tier markers ——— */

{ "level": 4, "scope": "CLASS", "appliesTo": "CLASS", "grantType": "Choice", "key": null, "choiceListKey":

"CHOICE_VORGX_GENERIC_FEATS", "quantity": 1, "perRest": null, "charges": null, "tags": ["feat"] },

{ "level": 8, "scope": "CLASS", "appliesTo": "CLASS", "grantType": "Choice", "key": null, "choiceListKey":

"CHOICE_VORGX_GENERIC_FEATS", "quantity": 1, "perRest": null, "charges": null, "tags": ["feat"] },

{ "level": 12, "scope": "CLASS", "appliesTo": "CLASS", "grantType": "Choice", "key": null, "choiceListKey":

"CHOICE_VORGX_GENERIC_FEATS", "quantity": 1, "perRest": null, "charges": null, "tags": ["feat"] },

{ "level": 16, "scope": "CLASS", "appliesTo": "CLASS", "grantType": "Choice", "key": null, "choiceListKey":

"CHOICE_VORGX_GENERIC_FEATS", "quantity": 1, "perRest": null, "charges": null, "tags": ["feat"] },

{ "level": 20, "scope": "CLASS", "appliesTo": "CLASS", "grantType": "Choice", "key": null, "choiceListKey":
"CHOICE_VORGX_GENERIC_FEATS", "quantity": 1, "perRest": null, "charges": null, "tags": ["feat"] },

{ "level": 5, "scope": "CLASS", "appliesTo": "CLASS", "grantType": "UpgradeMarker", "key": "MARK_TIER_I",

"choiceListKey": null, "quantity": 1, "perRest": null, "charges": null, "tags": ["upgrade"] },

{ "level": 8, "scope": "CLASS", "appliesTo": "CLASS", "grantType": "UpgradeMarker", "key": "MARK_TIER_II",

"choiceListKey": null, "quantity": 1, "perRest": null, "charges": null, "tags": ["upgrade"] },

{ "level": 13, "scope": "CLASS", "appliesTo": "CLASS", "grantType": "UpgradeMarker", "key": "MARK_TIER_III",

"choiceListKey": null, "quantity": 1, "perRest": null, "charges": null, "tags": ["upgrade"] },

{ "level": 18, "scope": "CLASS", "appliesTo": "CLASS", "grantType": "UpgradeMarker", "key": "MARK_TIER_IV",
"choiceListKey": null, "quantity": 1, "perRest": null, "charges": null, "tags": ["upgrade"] },

/* ——— Class Talents cadence (ROW_2→ROW_10 at 3/5/7/9/11/13/15/17/19) ——— */

{ "level": 3, "scope": "CLASS", "appliesTo": "CLASS", "grantType": "Choice", "key": null, "choiceListKey":

"LIST_CLASS_TALENTS_ROW_2", "quantity": 1, "perRest": null, "charges": null, "tags": ["talent","cadence2","class"]
},

{ "level": 5, "scope": "CLASS", "appliesTo": "CLASS", "grantType": "Choice", "key": null, "choiceListKey":
"LIST_CLASS_TALENTS_ROW_3", "quantity": 1, "perRest": null, "charges": null, "tags": ["talent","cadence2","class"]

},

{ "level": 7, "scope": "CLASS", "appliesTo": "CLASS", "grantType": "Choice", "key": null, "choiceListKey":

"LIST_CLASS_TALENTS_ROW_4", "quantity": 1, "perRest": null, "charges": null, "tags": ["talent","cadence2","class"]
},

{ "level": 9, "scope": "CLASS", "appliesTo": "CLASS", "grantType": "Choice", "key": null, "choiceListKey":

"LIST_CLASS_TALENTS_ROW_5", "quantity": 1, "perRest": null, "charges": null, "tags": ["talent","cadence2","class"]
},

{ "level": 11, "scope": "CLASS", "appliesTo": "CLASS", "grantType": "Choice", "key": null, "choiceListKey":
"LIST_CLASS_TALENTS_ROW_6", "quantity": 1, "perRest": null, "charges": null, "tags": ["talent","cadence2","class"]
},

{ "level": 13, "scope": "CLASS", "appliesTo": "CLASS", "grantType": "Choice", "key": null, "choiceListKey":

"LIST_CLASS_TALENTS_ROW_7", "quantity": 1, "perRest": null, "charges": null, "tags": ["talent","cadence2","class"]
},

{ "level": 15, "scope": "CLASS", "appliesTo": "CLASS", "grantType": "Choice", "key": null, "choiceListKey":
"LIST_CLASS_TALENTS_ROW_8", "quantity": 1, "perRest": null, "charges": null, "tags": ["talent","cadence2","class"]
},

{ "level": 17, "scope": "CLASS", "appliesTo": "CLASS", "grantType": "Choice", "key": null, "choiceListKey":
"LIST_CLASS_TALENTS_ROW_9", "quantity": 1, "perRest": null, "charges": null, "tags": ["talent","cadence2","class"]

},

{ "level": 19, "scope": "CLASS", "appliesTo": "CLASS", "grantType": "Choice", "key": null, "choiceListKey":

"LIST_CLASS_TALENTS_ROW_10","quantity": 1, "perRest": null, "charges": null, "tags": ["talent","cadence2","class"]
},

/* ——— SubclassSpec cadence (ROW_2→ROW_10 at 3/5/7/9/11/13/15/17/19) ——— */

{ "level": 3, "scope": "SUBCLASS_VORGX_WAR_A", "appliesTo": "SUBCLASS_VORGX_WAR_A", "grantType":

"Choice", "key": null, "choiceListKey": "LIST_SUBCLASSSPEC_ROW_2", "quantity": 1, "perRest": null, "charges":
null, "tags": ["talent","cadence2","spec"] },

{ "level": 5, "scope": "SUBCLASS_VORGX_WAR_A", "appliesTo": "SUBCLASS_VORGX_WAR_A", "grantType":
"Choice", "key": null, "choiceListKey": "LIST_SUBCLASSSPEC_ROW_3", "quantity": 1, "perRest": null, "charges":
null, "tags": ["talent","cadence2","spec"] },

{ "level": 7, "scope": "SUBCLASS_VORGX_WAR_A", "appliesTo": "SUBCLASS_VORGX_WAR_A", "grantType":

"Choice", "key": null, "choiceListKey": "LIST_SUBCLASSSPEC_ROW_4", "quantity": 1, "perRest": null, "charges":
null, "tags": ["talent","cadence2","spec"] },

{ "level": 9, "scope": "SUBCLASS_VORGX_WAR_A", "appliesTo": "SUBCLASS_VORGX_WAR_A", "grantType":
"Choice", "key": null, "choiceListKey": "LIST_SUBCLASSSPEC_ROW_5", "quantity": 1, "perRest": null, "charges":
null, "tags": ["talent","cadence2","spec"] },

{ "level": 11, "scope": "SUBCLASS_VORGX_WAR_A", "appliesTo": "SUBCLASS_VORGX_WAR_A", "grantType":
"Choice", "key": null, "choiceListKey": "LIST_SUBCLASSSPEC_ROW_6", "quantity": 1, "perRest": null, "charges":

null, "tags": ["talent","cadence2","spec"] },

{ "level": 13, "scope": "SUBCLASS_VORGX_WAR_A", "appliesTo": "SUBCLASS_VORGX_WAR_A", "grantType":

"Choice", "key": null, "choiceListKey": "LIST_SUBCLASSSPEC_ROW_7", "quantity": 1, "perRest": null, "charges":
null, "tags": ["talent","cadence2","spec"] },

{ "level": 15, "scope": "SUBCLASS_VORGX_WAR_A", "appliesTo": "SUBCLASS_VORGX_WAR_A", "grantType":
"Choice", "key": null, "choiceListKey": "LIST_SUBCLASSSPEC_ROW_8", "quantity": 1, "perRest": null, "charges":

null, "tags": ["talent","cadence2","spec"] },

{ "level": 17, "scope": "SUBCLASS_VORGX_WAR_A", "appliesTo": "SUBCLASS_VORGX_WAR_A", "grantType":

"Choice", "key": null, "choiceListKey": "LIST_SUBCLASSSPEC_ROW_9", "quantity": 1, "perRest": null, "charges":
null, "tags": ["talent","cadence2","spec"] },

{ "level": 19, "scope": "SUBCLASS_VORGX_WAR_A", "appliesTo": "SUBCLASS_VORGX_WAR_A", "grantType":

"Choice", "key": null, "choiceListKey": "LIST_SUBCLASSSPEC_ROW_10","quantity": 1, "perRest": null, "charges":
null, "tags": ["talent","cadence2","spec"] },

/* ——— Specialization package ——— */

{ "level": 13, "scope": "SUBCLASS_VORGX_WAR_A", "appliesTo": "SUBCLASS_VORGX_WAR_A", "grantType":
"Choice", "key": null, "choiceListKey": "LIST_SPEC_KEY_TALENT", "quantity": 1, "perRest": null, "charges": null,

"tags": ["talent","specialization","key"] },

{ "level": 13, "scope": "SUBCLASS_VORGX_WAR_A", "appliesTo": "SUBCLASS_VORGX_WAR_A", "grantType":
"Choice", "key": null, "choiceListKey": "LIST_SPEC_CAPSTONE", "quantity": 1, "perRest": null, "charges": null,

"tags": ["talent","specialization","capstone"] },

{ "level": 13, "scope": "SUBCLASS_VORGX_WAR_A", "appliesTo": "SUBCLASS_VORGX_WAR_A", "grantType":

"Choice", "key": null, "choiceListKey": "LIST_SPEC_CHOICES_1", "quantity": 1, "perRest": null, "charges": null,
"tags": ["talent","specialization","choiceNode"] },

{ "level": 15, "scope": "SUBCLASS_VORGX_WAR_A", "appliesTo": "SUBCLASS_VORGX_WAR_A", "grantType":
"Choice", "key": null, "choiceListKey": "LIST_SPEC_CHOICES_2", "quantity": 1, "perRest": null, "charges": null,

"tags": ["talent","specialization","choiceNode"] },

{ "level": 18, "scope": "SUBCLASS_VORGX_WAR_A", "appliesTo": "SUBCLASS_VORGX_WAR_A", "grantType":

"Choice", "key": null, "choiceListKey": "LIST_SPEC_CHOICES_3", "quantity": 1, "perRest": null, "charges": null,
"tags": ["talent","specialization","choiceNode"] },

/* Specialization passive stream (13→20) */

{ "level": 13, "scope": "SUBCLASS_VORGX_WAR_A", "appliesTo": "SUBCLASS_VORGX_WAR_A", "grantType":

"Choice", "key": null, "choiceListKey": "LIST_SPEC_PASSIVES", "quantity": 1, "perRest": null, "charges": null, "tags":
["talent","specialization","passive"] },

{ "level": 14, "scope": "SUBCLASS_VORGX_WAR_A", "appliesTo": "SUBCLASS_VORGX_WAR_A", "grantType":
"Choice", "key": null, "choiceListKey": "LIST_SPEC_PASSIVES", "quantity": 1, "perRest": null, "charges": null, "tags":

["talent","specialization","passive"] },

{ "level": 15, "scope": "SUBCLASS_VORGX_WAR_A", "appliesTo": "SUBCLASS_VORGX_WAR_A", "grantType":
"Choice", "key": null, "choiceListKey": "LIST_SPEC_PASSIVES", "quantity": 1, "perRest": null, "charges": null, "tags":

["talent","specialization","passive"] },

{ "level": 16, "scope": "SUBCLASS_VORGX_WAR_A", "appliesTo": "SUBCLASS_VORGX_WAR_A", "grantType":

"Choice", "key": null, "choiceListKey": "LIST_SPEC_PASSIVES", "quantity": 1, "perRest": null, "charges": null, "tags":

["talent","specialization","passive"] },

{ "level": 17, "scope": "SUBCLASS_VORGX_WAR_A", "appliesTo": "SUBCLASS_VORGX_WAR_A", "grantType":

"Choice", "key": null, "choiceListKey": "LIST_SPEC_PASSIVES", "quantity": 1, "perRest": null, "charges": null, "tags":
["talent","specialization","passive"] },

{ "level": 18, "scope": "SUBCLASS_VORGX_WAR_A", "appliesTo": "SUBCLASS_VORGX_WAR_A", "grantType":
"Choice", "key": null, "choiceListKey": "LIST_SPEC_PASSIVES", "quantity": 1, "perRest": null, "charges": null, "tags":

["talent","specialization","passive"] },

{ "level": 19, "scope": "SUBCLASS_VORGX_WAR_A", "appliesTo": "SUBCLASS_VORGX_WAR_A", "grantType":

"Choice", "key": null, "choiceListKey": "LIST_SPEC_PASSIVES", "quantity": 1, "perRest": null, "charges": null, "tags":
["talent","specialization","passive"] },

{ "level": 20, "scope": "SUBCLASS_VORGX_WAR_A", "appliesTo": "SUBCLASS_VORGX_WAR_A", "grantType":

"Choice", "key": null, "choiceListKey": "LIST_SPEC_PASSIVES", "quantity": 1, "perRest": null, "charges": null, "tags":
["talent","specialization","passive"] },

/* ——— High-slot / Capstone examples ——— */

{ "level": 17, "scope": "SUBCLASS_VORGX_WAR_A", "appliesTo": "SUBCLASS_VORGX_WAR_A", "grantType":
"Passive", "key": "PASSIVE_VORGX_HIGH_MAGIC_BOON", "choiceListKey": null, "quantity": 1, "perRest": null,

"charges": null, "tags": ["casting","gate"] }

]
}
}
16) Upgrade Tracks

What this section does

Defines level/tier-based scaling for actions, passives, and statuses you authored elsewhere.Tracks listen to
markers from §14/§15 (e.g., MARK_TIER_I...IV) or exact levels and apply typed, additive deltas (e.g.,
damageDieBonus, saveDCBonus, etc.).This keeps your scaling centralised and LSX-safe (exporter emits add-only

patches).

Authoring (drop-in JSON — GENERIC with tips)

{
"upgrade": {

"policy": {

"tierToLevelMap": { "I": 5, "II": 8, "III": 13, "IV": 18 },

"consumeMarkers": true,

"notes": "TIP — Mirrors §14.policy.tierBreaks; change once and all tracks follow."

},
"tracks": {

"TRACK___CORE": {
"targets": ["ACTION___PRIMARY_STRIKE"],

"plan": [

{ "atTier": "I", "apply": [ { "delta": { "damageDieBonus": 1 } } ] },

{ "atTier": "II", "apply": [ { "delta": { "damageDieBonus": 2 } } ] },

{ "atTier": "III","apply": [ { "delta": { "damageDieBonus": 3 } } ] },

{ "atTier": "IV", "apply": [ { "delta": { "damageDieBonus": 4 } } ] }

],
"tags": ["class","core"],

"notes": "TIP — Targets must exist in §5."

},

"TRACK__STRIKES": {
"targets": [

"ACTION_<...>_MortalStrike",

"ACTION_<...>_Overpower",

"ACTION_<...>_Execute"

],
"plan": [

{ "at": 5, "apply": [

{ "target": "ACTION_<...>_MortalStrike", "delta": { "damageDieBonus": 1 } },

{ "target": "ACTION_<...>Overpower", "delta": { "statusBonusTo":"ACTION<...>_MortalStrike",

"damageDieBonusDelta": 1 } },

{ "target": "ACTION_<...>_Execute", "delta": { "damageDieBonus": 1 } }

]},
{ "at": 10, "apply": [

{ "target": "ACTION_<...>_MortalStrike", "delta": { "damageDieBonus": 2 } },

{ "target": "ACTION_<...>Overpower", "delta": { "statusBonusTo":"ACTION<...>_MortalStrike",
"damageDieBonusDelta": 1 } },

{ "target": "ACTION_<...>_Execute", "delta": { "damageDieBonus": 2 } }

]},
{ "at": 15, "apply": [

{ "target": "ACTION_<...>_MortalStrike", "delta": { "damageDieBonus": 3 } },

{ "target": "ACTION_<...>Overpower", "delta": { "statusBonusTo":"ACTION<...>_MortalStrike",

"damageDieBonusDelta": 1 } },

{ "target": "ACTION_<...>_Execute", "delta": { "damageDieBonus": 3 } }

]},
{ "at": 20, "apply": [

{ "target": "ACTION_<...>_MortalStrike", "delta": { "damageDieBonus": 4 } },

{ "target": "ACTION_<...>Overpower", "delta": { "statusBonusTo":"ACTION<...>_MortalStrike",
"damageDieBonusDelta": 1 } },

{ "target": "ACTION_<...>_Execute", "delta": { "damageDieBonus": 4 } }

]}
],
"tags": ["subclass","strikes"]

},
"TRACK__AOE": {
"targets": ["ACTION_<...>Cleave","ACTION<...>_Bladestorm"],

"plan": [

{ "at": 5, "apply": [

{ "target": "ACTION_<...>_Cleave", "delta": { "refEffect":"EFX_TwoTargetStrike" } },

{ "target": "ACTION_<...>_Bladestorm","delta": { "damageDieBonus": 1 } }

]},

{ "at": 10, "apply": [

{ "target": "ACTION_<...>_Cleave", "delta": { "extraTargetIfAdjacent": true } },

{ "target": "ACTION_<...>_Bladestorm","delta": { "damageDieBonus": 2 } }

]},
{ "at": 15, "apply": [

{ "target": "ACTION_<...>_Cleave", "delta": { "damageDieBonus": 1 } },

{ "target": "ACTION_<...>_Bladestorm","delta": { "damageDieBonus": 3 } }

]},
{ "at": 20, "apply": [

{ "target": "ACTION_<...>_Cleave", "delta": { "damageDieBonus": 2 } },

{ "target": "ACTION_<...>_Bladestorm","delta": { "damageDieBonus": 4 } }

]}

],
"tags": ["subclass","aoe"]

},
"TRACK__DOTS": {
"targets": ["STATUS_<...>Bleed_Rend","STATUS<...>_Bleed_DeepWounds"],

"plan": [

{ "atTier": "I", "apply": [ { "target": "STATUS_<...>_Bleed_Rend", "delta": { "tickDiceBonus": 1 } } ] },

{ "atTier": "II", "apply": [ { "target": "STATUS_<...>_Bleed_DeepWounds", "delta": { "tickDiceBonus": 1 } } ] },

{ "atTier": "III","apply": [ { "target": "STATUS_<...>_Bleed_Rend", "delta": { "tickDiceBonus": 2 } } ] },

{ "atTier": "IV", "apply": [ { "target": "STATUS_<...>_Bleed_DeepWounds", "delta": { "tickDiceBonus": 2 } } ] }

],
"tags": ["subclass","dots"]

},
"TRACK___UTILITY": {
"targets": ["ACTION_<...>_RallyingCry_THP"],

"plan": [

{ "atTier": "I", "apply": [ { "delta": { "diceTierBonus": 1 } } ] },

{ "atTier": "II", "apply": [ { "delta": { "diceTierBonus": 2 } } ] },

{ "atTier": "III","apply": [ { "delta": { "diceTierBonus": 3 } } ] },

{ "atTier": "IV", "apply": [ { "delta": { "diceTierBonus": 4 } } ] }

],
"tags": ["class","utility"]

}
}
}
}
Delta vocabulary (supported knobs)

Additive unless noted; exporter transforms to Stats/Passives/Statuses safely.

Damage/Healing : damageDieBonus, tickDiceBonus, healDieBonus, flatBonus, critRangeDelta
Accuracy/Defense : attackRollBonus, saveDCBonus, acBonus, resistBonus, vulnBonus
Targeting/Area : rangeMetersDelta, radiusMetersDelta, extraTargetIfAdjacent, refEffect
Duration/Charges : durationTurnsDelta, chargesDelta, perRestOverride ("Short"|"Long")
Links/Synergies : statusBonusTo, damageDieBonusDelta, applyStatusOnHit
Casting-specific (if needed): slotCostDelta, upcastDicePerTier, concentrationSaveBonus
TIP — Use only what your exporter knows; unknown fields are linted and dropped.

Field-by-field (what each drives)

policy.tierToLevelMap — Resolves atTier to concrete levels (must match §14/§15 markers).
policy.consumeMarkers — If true, validator ensures MARK_TIER_* rows exist in §14/§15; otherwise plain
level checks apply.
tracks[NAME].targets — Default targets when apply[].target is omitted (allows concise deltas).
tracks[NAME].plan[] — Sequence of checkpoints:
at (level) or atTier (I–IV).
apply[] — one or more deltas; may specify a target or inherit from targets.
tracks[NAME].tags/notes — Non-functional metadata (renderer/filtering).
Validation checklist (for this section)

Marker presence : if any atTier is used and consumeMarkers=true, §15 contains the corresponding
UpgradeMarker row(s).
Target existence : every referenced target (explicit or inherited from targets) exists in §5/§7 catalogs.
No duplicate checkpoints within a single track (at or the same resolved level from atTier).
Allowed knobs only : all delta keys are recognized; unknown keys flagged.
Add-only : no negative or multiplicative overwrites that violate add-only authoring (your exporter enforces).
Cross-link integrity : statusBonusTo references a valid action/status key.
Subclass scoping : tracks named for subclasses only touch assets under that subclass catalog.
Common pitfalls & how to avoid them

Tier drift — If you change §14 tierBreaks, also update tierToLevelMap (or leave at levels only).
Missing keys — Build §5/§7 first; run validator to catch target typos before exporting.
Over-scaling — Keep dice bonuses within your §12 tier policy (1/2/3/4 typical); don’t exceed the 11-pip cap
rule you set.
Ambiguous targets — Prefer explicit target inside apply when a track touches heterogenous assets.
Improvement suggestions

Add conditions on checkpoints (e.g., "requiresSpecialization":"SLAYER") so the same track file works across
branches.
Support batch templates (e.g., "deltaTemplate":"DicePerTier(1,2,3,4)") for bulk authoring; exporter expands
to concrete deltas.
Emit a preview report (before export) showing the final dice/bonuses per level for quick QA.
Example (filled — neutral, mirrors your style)

{
"upgrade": {

"policy": { "tierToLevelMap": { "I": 5, "II": 8, "III": 13, "IV": 18 }, "consumeMarkers": true, "notes": "" },

"tracks": {

"TRACK_VORGX_WAR_CORE": {
"targets": ["ACTION_VORGX_WAR_PRIMARY_STRIKE"],

"plan": [

{ "atTier": "I", "apply": [ { "delta": { "damageDieBonus": 1 } } ] },

{ "atTier": "II", "apply": [ { "delta": { "damageDieBonus": 2 } } ] },

{ "atTier": "III","apply": [ { "delta": { "damageDieBonus": 3 } } ] },

{ "atTier": "IV", "apply": [ { "delta": { "damageDieBonus": 4 } } ] }

],

"tags": ["class","core"]

},
"TRACK_VORGX_WAR_A_STRIKES": {
"targets":

["ACTION_VORGX_WAR_A_MortalStrike","ACTION_VORGX_WAR_A_Overpower","ACTION_VORGX_WAR_A_Execute"
],

"plan": [

{ "at": 5, "apply": [

{ "target":"ACTION_VORGX_WAR_A_MortalStrike", "delta": { "damageDieBonus": 1 } },

{ "target":"ACTION_VORGX_WAR_A_Overpower", "delta": {

"statusBonusTo":"ACTION_VORGX_WAR_A_MortalStrike", "damageDieBonusDelta": 1 } },

{ "target":"ACTION_VORGX_WAR_A_Execute", "delta": { "damageDieBonus": 1 } }

]},
{ "at": 10, "apply": [

{ "target":"ACTION_VORGX_WAR_A_MortalStrike", "delta": { "damageDieBonus": 2 } },

{ "target":"ACTION_VORGX_WAR_A_Overpower", "delta": {
"statusBonusTo":"ACTION_VORGX_WAR_A_MortalStrike", "damageDieBonusDelta": 1 } },

{ "target":"ACTION_VORGX_WAR_A_Execute", "delta": { "damageDieBonus": 2 } }

]},

{ "at": 15, "apply": [

{ "target":"ACTION_VORGX_WAR_A_MortalStrike", "delta": { "damageDieBonus": 3 } },

{ "target":"ACTION_VORGX_WAR_A_Overpower", "delta": {
"statusBonusTo":"ACTION_VORGX_WAR_A_MortalStrike", "damageDieBonusDelta": 1 } },

{ "target":"ACTION_VORGX_WAR_A_Execute", "delta": { "damageDieBonus": 3 } }

]},
{ "at": 20, "apply": [

{ "target":"ACTION_VORGX_WAR_A_MortalStrike", "delta": { "damageDieBonus": 4 } },

{ "target":"ACTION_VORGX_WAR_A_Overpower", "delta": {
"statusBonusTo":"ACTION_VORGX_WAR_A_MortalStrike", "damageDieBonusDelta": 1 } },

{ "target":"ACTION_VORGX_WAR_A_Execute", "delta": { "damageDieBonus": 4 } }

]}
],
"tags": ["subclass","strikes"]

},
"TRACK_VORGX_WAR_A_AOE": {
"targets": ["ACTION_VORGX_WAR_A_Cleave","ACTION_VORGX_WAR_A_Bladestorm"],

"plan": [

{ "at": 5, "apply": [

{ "target":"ACTION_VORGX_WAR_A_Cleave", "delta": { "refEffect":"EFX_TwoTargetStrike" } },

{ "target":"ACTION_VORGX_WAR_A_Bladestorm","delta": { "damageDieBonus": 1 } }

]},
{ "at": 10, "apply": [

{ "target":"ACTION_VORGX_WAR_A_Cleave", "delta": { "extraTargetIfAdjacent": true } },

{ "target":"ACTION_VORGX_WAR_A_Bladestorm","delta": { "damageDieBonus": 2 } }

]},
{ "at": 15, "apply": [

{ "target":"ACTION_VORGX_WAR_A_Cleave", "delta": { "damageDieBonus": 1 } },

{ "target":"ACTION_VORGX_WAR_A_Bladestorm","delta": { "damageDieBonus": 3 } }

]},
{ "at": 20, "apply": [

{ "target":"ACTION_VORGX_WAR_A_Cleave", "delta": { "damageDieBonus": 2 } },

{ "target":"ACTION_VORGX_WAR_A_Bladestorm","delta": { "damageDieBonus": 4 } }

]}
],
"tags": ["subclass","aoe"]

},
"TRACK_VORGX_WAR_A_DOTS": {
"targets": ["STATUS_VORGX_WAR_A_Bleed_Rend","STATUS_VORGX_WAR_A_Bleed_DeepWounds"],

"plan": [

{ "atTier":"I", "apply":[ { "target":"STATUS_VORGX_WAR_A_Bleed_Rend", "delta": { "tickDiceBonus": 1 } } ] },

{ "atTier":"II", "apply":[ { "target":"STATUS_VORGX_WAR_A_Bleed_DeepWounds", "delta": { "tickDiceBonus": 1 }
} ] },

{ "atTier":"III","apply":[ { "target":"STATUS_VORGX_WAR_A_Bleed_Rend", "delta": { "tickDiceBonus": 2 } } ] },

{ "atTier":"IV", "apply":[ { "target":"STATUS_VORGX_WAR_A_Bleed_DeepWounds", "delta": { "tickDiceBonus": 2 }

} ] }

],
"tags": ["subclass","dots"]

},
"TRACK_VORGX_WAR_UTILITY": {
"targets": ["ACTION_VORGX_WAR_RallyingCry_THP"],

"plan": [

{ "atTier":"I", "apply":[ { "delta": { "diceTierBonus": 1 } } ] },

{ "atTier":"II", "apply":[ { "delta": { "diceTierBonus": 2 } } ] },

{ "atTier":"III","apply":[ { "delta": { "diceTierBonus": 3 } } ] },

{ "atTier":"IV", "apply":[ { "delta": { "diceTierBonus": 4 } } ] }

],
"tags": ["class","utility"]

}
}
}
}
17) Token Glossary

What this section does

Central registry of all canonical keys the Blueprint references (class/subclass IDs, actions, passives, statuses,
lists, resources, caster tracks, tier markers, upgrade tracks, specialization lists, and loc tokens).It also defines a
controlled tag vocabulary plus lint rules so every asset can be consistently tagged and validated across §§4–16

and used by §18 (renderer) and §19 (localization).

Authoring (drop-in JSON — generic with tips)

{
"glossary": {

"policy": {

"namespace": "VORGX",

"author": "vorgx",

"namingRules": {

"classKey": "<CLASS_KEY>",

"subclassKey": "SUBCLASS_",

"action": "ACTION_[]_VerbObject",

"passive": "PASSIVE_[]_PassiveName",

"status": "STATUS_[]_StatusName",

"effect": "EFX__DescriptiveName",

"list": "LIST__",

"choice": "CHOICE__",

"resource": "RES_[]",

"casterTrack": "CASTTRACK_",

"marker": "MARK_TIER_",

"upgradeTrack": "TRACK_[]_Bucket"

},
"notes": "TIP — Keep keys additive-only; avoid overwriting vanilla."

},
"classes": [

{ "key": "<CLASS_KEY>", "displayName": "", "notes": "TIP — One per player class." }

],
"subclasses": [

{ "key": "SUBCLASS_", "parentClass": "<CLASS_KEY>", "displayName": "",
"notes": "TIP — Must match §6 exactly." }

],
"actions": [

{ "key": "ACTION___PRIMARY_STRIKE", "scope": "CLASS", "tags": [], "notes": "" }

/* TIP — Add every action referenced in §§5/7/14/16. */

],
"passives": [

{ "key": "PASSIVE___BASE_STANCE", "scope": "CLASS", "tags": [], "notes": "" }

],
"statuses": [

{ "key": "STATUS__Bleed_Rend", "scope": "SUBCLASS", "tags": [], "notes": "" }

],
"effects": [

{ "key": "EFX_TwoTargetStrike", "kind": "visual|logic", "notes": "TIP — Referenced by upgrade tracks or actions." }

],
"lists": [

/* Class Talents (10 rows) */

{ "key": "LIST_CLASS_TALENTS_ROW_1" }, { "key": "LIST_CLASS_TALENTS_ROW_2" },

{ "key": "LIST_CLASS_TALENTS_ROW_3" }, { "key": "LIST_CLASS_TALENTS_ROW_4" },

{ "key": "LIST_CLASS_TALENTS_ROW_5" }, { "key": "LIST_CLASS_TALENTS_ROW_6" },

{ "key": "LIST_CLASS_TALENTS_ROW_7" }, { "key": "LIST_CLASS_TALENTS_ROW_8" },

{ "key": "LIST_CLASS_TALENTS_ROW_9" }, { "key": "LIST_CLASS_TALENTS_ROW_10" },

/* SubclassSpec Talents (10 rows + optional passives row) */

{ "key": "LIST_SUBCLASSSPEC_ROW_1" }, { "key": "LIST_SUBCLASSSPEC_ROW_2" },

{ "key": "LIST_SUBCLASSSPEC_ROW_3" }, { "key": "LIST_SUBCLASSSPEC_ROW_4" },

{ "key": "LIST_SUBCLASSSPEC_ROW_5" }, { "key": "LIST_SUBCLASSSPEC_ROW_6" },

{ "key": "LIST_SUBCLASSSPEC_ROW_7" }, { "key": "LIST_SUBCLASSSPEC_ROW_8" },

{ "key": "LIST_SUBCLASSSPEC_ROW_9" }, { "key": "LIST_SUBCLASSSPEC_ROW_10" },

{ "key": "LIST_SUBCLASSSPEC_PASSIVES_ROW_1" },

/* SubclassBase BUCKET (no rows) */

{ "key": "LIST_SUBCLASSBASE_OFFENSE" },

{ "key": "LIST_SUBCLASSBASE_UTILITY" },

{ "key": "LIST_SUBCLASSBASE_ALL" },

/* Specialization package */

{ "key": "LIST_SPEC_KEY_TALENT" },

{ "key": "LIST_SPEC_CAPSTONE" },

{ "key": "LIST_SPEC_CHOICES_1" },

{ "key": "LIST_SPEC_CHOICES_2" },

{ "key": "LIST_SPEC_CHOICES_3" },

{ "key": "LIST_SPEC_PASSIVES" }

],
"choices": [

{ "key": "CHOICE___SUBCLASSES", "notes": "TIP — Offered at subclassUnlockLevel in
§14." },

{ "key": "CHOICE__GENERIC_FEATS", "notes": "TIP — Feats at 4/8/12/16/20." }

],
"resources": [

{ "key": "RES__", "model": "pips|points|stacks", "max": 0, "perRest":
"Short|Long|None", "notes": "TIP — Class-wide if needed." },

{ "key": "RES_", "model": "pips|points|stacks", "max": 0, "perRest":
"Short|Long|None", "notes": "TIP — Per subclass resource (§9)." }

],
"casterTracks": [

{ "key": "CASTTRACK_STANDARD_FULL_9", "notes": "TIP — Full 9-level slots (supports L9)." },

{ "key": "CASTTRACK_STANDARD_HALF_9", "notes": "" },

{ "key": "CASTTRACK_STANDARD_THIRD_9", "notes": "" },

{ "key": "CASTTRACK_SPELL_POINTS_HIGH", "notes": "TIP — Spell points model, if used." }

],
"markers": [

{ "key": "MARK_TIER_I" }, { "key": "MARK_TIER_II" }, { "key": "MARK_TIER_III" }, { "key": "MARK_TIER_IV" }

],
"upgradeTracks": [

{ "key": "TRACK___CORE" },

{ "key": "TRACK__STRIKES" },

{ "key": "TRACK__AOE" },

{ "key": "TRACK__DOTS" },

{ "key": "TRACK___UTILITY" }

],
"specialization": [

{ "key": "SPEC_", "lists":

["LIST_SPEC_KEY_TALENT","LIST_SPEC_CAPSTONE","LIST_SPEC_CHOICES_1","LIST_SPEC_CHOICES_2","LIST_SPE
C_CHOICES_3","LIST_SPEC_PASSIVES"], "notes": "TIP — Optional index for tooling/renderer." }

],
"loc": [

{ "token": "h_ACTION_<...>_PRIMARY_STRIKE", "value": "", "notes": "TIP — Title" },

{ "token": "d_ACTION_<...>_PRIMARY_STRIKE", "value": "", "notes": "TIP — Description" }

/* TIP — Add title/description tokens for all player-facing assets; §19 aggregates these. */

],
"tagSets": {

"PrimaryCategory": ["Action","Passive","Aura","Stance","Spell"],

"ActionTiming": ["Action","BonusAction","Reaction","Free"],

"TempoRole": ["Builder","Spender","Finisher","Setup","Payoff","Maintenance"],

"WindowGating": ["PrimaryWindow","SharedMode","Ungated"],

"Delivery": ["Melee","Ranged","Thrown","Cone","Line","Blast","Leap","Teleport"],

"DamageType":

["Bludgeoning","Piercing","Slashing","Fire","Cold","Lightning","Thunder","Acid","Poison","Necrotic","Radiant","Psychic","
Force"],

"School":
["Abjuration","Conjuration","Divination","Enchantment","Evocation","Illusion","Necromancy","Transmutation"],

"AuraType": ["Defensive","Offensive","Control","Support","Zone","Tether","Mark","Summoner","Environmental"],

"StanceType": ["Defensive","Aggressive","Mobile","Control","Precision","Berserk","Guardian","Assassin"],

"ToggleMechanic": ["Free","Action","BonusAction","Reaction"],

"ToggleRule": ["ExclusiveInGroup","Stackable","ConsumesConcentration","NoConcentration"],

"Radius": ["Self","5ft","10ft","15ft","30ft","Line","Cone"],

"DurationKind": ["Sustained","UntilRest","Timed"],

"Economy": ["Channel","Reserve","None"],

"ControlType":
["Knockback","Prone","Stun","Grapple","Restrain","Blind","Silence","Frighten","Charmed","Slow","Root"],

"UtilityType":
["Cleanse","Dispel","Hide","Reveal","Summon","CreateCover","Interact","MovementBuff","DamageBuff","DefenseBuff"

,"Heal","TempHP"],

"DefenseType": ["DR","Resistance","Immunity","TempHP","Guard","Parry"],

"MobilityType": ["Dash","Disengage","Jump","Pull","Swap","Blink"],

"Scaling": ["Str","Dex","Con","Int","Wis","Cha","Weapon","Spell","Proficiency","Level"],

"CooldownBand": ["Light","Mid","Heavy"],

"Identity": ["Aggro","Defense","Control","Mobility","Pet","Ranged","Execute"],

"SlotKind": ["SharedSlots","PactSlots","NoSlots"],

"Complexity": ["Simple","Moderate","Advanced"],

"Flavor":
["Curses","Blessing","Rage","Focus","Hunter","Vigil","Elemental_Fire","Elemental_Cold","Elemental_Lightning","Shado

w","Radiant","Nature","Steel","Arcane"]

},

"tagRules": {

"singletons":

["PrimaryCategory","ActionTiming","CooldownBand","WindowGating","AuraType","StanceType","ToggleMechanic","Tog
gleRule","DurationKind","Economy","Radius","SlotKind","Complexity"],

"requiredPerPrimary": {

"Action": ["ActionTiming","TempoRole","Delivery","CooldownBand"],

"Passive": ["Identity"],

"Aura": ["AuraType","ToggleMechanic","ToggleRule","DurationKind"],

"Stance": ["StanceType","ToggleMechanic","ToggleRule","DurationKind"],

"Spell": ["ActionTiming","TempoRole","School","CooldownBand"]

},
"flavorExt": { "allowedCustom": [], "regex": "^[A-Z][A-Za-z0-9_]{2,24}$" }

}
}
}
Field-by-field (what each drives)

policy.namespace/author — single source for namespacing and attribution during export.
policy.namingRules — human-readable patterns; validator uses these to flag off-pattern keys.
classes/subclasses — identities used by §6 and scoping in §§14–15.
actions/passives/statuses/effects — gameplay assets consumed by §§5/7/16.
lists/choices — catalogs used by §§7–8 and wired by §§14–15.
resources/casterTracks — referenced in §§9–11 and bound at §14.
markers/upgradeTracks — tier markers from §§14–15 and scaling plans in §16.
specialization — optional index per branch to group its lists (useful in UI/validator).
loc — minimal localization tokens for §19 building.
tagSets — the controlled vocabulary for asset tagging.
tagRules — lint constraints: singletons, required tags per PrimaryCategory, and safe extension for Flavor.
Validation checklist (for this section)

Uniqueness : every key here is unique across all buckets.
Coverage : every token referenced in §§5/7/8/9/10/11/14/15/16 appears here.
Namespace : all keys follow policy.namespace and namingRules.
Tag integrity :
Exactly one PrimaryCategory per asset with tags.
All required groups present per PrimaryCategory.
Singleton groups have at most one value.
All tag values are from tagSets (or match flavorExt.regex).
Common pitfalls & how to avoid them

Key drift between sections → author here first; reference elsewhere.
Choice vs List confusion → CHOICE_* is what players pick from (e.g., Feats/Subclasses); LIST_* catalogs
ability entries.
Missing subclass scoping → SUBCLASS_<NAMESPACE>_<CLASS>_<ID> must exactly match §6.
Untagged assets when renderer expects tags → keep a minimal tag set (PrimaryCategory + the required
groups).
Improvement suggestions

Add "deprecated": true to retired keys; validators can warn without failing.
Add "uiIcon": "Icon_<name>" hints to actions/passives for §18 previews.
Add "owner": "§5|§7|§8" metadata to each token for large-team traceability.
Example (filled — small, neutral)

{
"glossary": {

"policy": { "namespace": "VORGX", "author": "vorgx" },

"classes": [{ "key": "WAR", "displayName": "War" }],

"subclasses": [{ "key": "SUBCLASS_VORGX_WAR_A", "parentClass": "WAR", "displayName": "Path A" }],

"actions": [

{
"key": "ACTION_VORGX_WAR_PRIMARY_STRIKE",

"scope": "CLASS",

"tags": [

"PrimaryCategory:Action","ActionTiming:Action","TempoRole:Builder",

"Delivery:Melee","CooldownBand:Light","DamageType:Slashing","Scaling:Weapon"

]
}
],
"passives": [

{
"key": "PASSIVE_VORGX_WAR_BASE_STANCE",

"scope": "CLASS",

"tags": [

"PrimaryCategory:Stance","StanceType:Aggressive","ToggleMechanic:Free",

"ToggleRule:ExclusiveInGroup","DurationKind:Sustained","Complexity:Simple","Identity:Aggro"

]
}
],
"lists": [

{ "key": "LIST_CLASS_TALENTS_ROW_1" },

{ "key": "LIST_SUBCLASSBASE_ALL" }

],

"choices": [{ "key": "CHOICE_VORGX_WAR_SUBCLASSES" }],

"resources": [{ "key": "RES_VORGX_WAR_A", "model": "pips", "max": 3, "perRest": "Short" }],

"casterTracks": [{ "key": "CASTTRACK_STANDARD_FULL_9" }],

"markers": [{ "key": "MARK_TIER_I" }],

"upgradeTracks": [{ "key": "TRACK_VORGX_WAR_CORE" }]

}
}
17B — Token Glossary (Tag Validator Add-On)

Authoring (drop-in JSON — add under glossary)

{
"tagValidator": {

"scope": {

"scanSections": ["§5","§7","§8","§14","§15","§16"],

"assetBuckets": {

"Action": "actions",

"Passive": "passives",

"Aura": "passives",

"Stance": "passives",

"Spell": "actions"

},

"notes": "TIP — Map PrimaryCategory to the glossary bucket that defines the asset keys."

},
"rules": {

"useTagSets": true,

"enforceSingletons": true,

"requirePerPrimary": true,

"allowFlavorExt": true,

"requiredCore": ["PrimaryCategory"],

"additionalPerCategory": {

"Action": ["ActionTiming","TempoRole","Delivery","CooldownBand"],

"Passive": ["Identity"],

"Aura": ["AuraType","ToggleMechanic","ToggleRule","DurationKind"],

"Stance": ["StanceType","ToggleMechanic","ToggleRule","DurationKind"],

"Spell": ["ActionTiming","TempoRole","School","CooldownBand"]

}
},
"linkage": {

"glossaryBuckets": ["actions","passives","statuses","effects","lists","choices"],

"crossCheckAssets": true,

"failOnMissingAsset": true,

"notes": "Ensures any tagged key actually exists in the right glossary bucket and in its defining section (e.g., §5/

§7)."

},
"severity": {

"unknownTagValue": "error",

"unknownTagGroup": "error",

"missingRequiredGroup": "error",

"multipleSingletons": "error",

"unusedTagGroup": "warn",

"assetNotInGlossary": "error",

"assetNotInSection": "error"

},
"report": {

"emitSummary": true,

"emitPerAsset": true,

"maxExamplesPerIssue": 10,

"format": "compact",

"notes": "Renderer can show per-row badges in §15 for quick fixes."

}
}
}
Field-by-field (what each drives)

scope.scanSections — where the validator looks for tagged assets (definitions and references).
scope.assetBuckets — maps PrimaryCategory to the glossary bucket that defines those assets (so cross-
checks know where to look).
rules.useTagSets — only values in glossary.tagSets are allowed (except Flavor when allowFlavorExt=true and
it matches regex).
rules.enforceSingletons — groups in glossary.tagRules.singletons must appear ≤1 time per asset.
rules.requirePerPrimary — assets must include all groups listed in
glossary.tagRules.requiredPerPrimary[PrimaryCategory].
rules.requiredCore — base groups that must exist on every tagged asset.
linkage.crossCheckAssets — verify that each tagged asset’s key is present in the appropriate glossary
bucket and also defined in its authoring section (e.g., §5 Actions, §7 Catalog).
severity — error/warn levels for different findings.
report — controls output shape and noise level.
Validation checklist (tags)

Every tagged asset includes PrimaryCategory (and exactly one).
All required groups for that category are present (see additionalPerCategory).
No singleton group appears more than once (e.g., only one ActionTiming).
Every Group:Value pair uses a known Group and a value from tagSets[Group] (or Flavor that matches regex).
Every tagged key exists in the glossary and is defined in its home section (e.g., §5 for Actions, §7 for subclass
Actions).
No tags appear on assets that are not player-facing unless intentionally allowed by your tooling (optional
rule).
Common pitfalls & how to avoid them

“Spell” assets tagged as Action → use PrimaryCategory:Spell and add School.
Forgetting CooldownBand on actions/spells → validator will error; add Light|Mid|Heavy.
Typos (ActionTimng) → flagged as unknownTagGroup. Fix spelling or extend tagSets.
Assets referenced but not in glossary → add them to §17 and ensure they exist in §5/§7.
Multiple ActionTiming values on one action → collapse to one (singleton).
Improvement suggestions

Configure profiles (e.g., strict, lenient) under tagValidator.rulesProfile and switch in §20 for CI vs. local builds.
Emit a fix-it suggestion list by encoding defaults per class (e.g., melee builders default to Delivery:Melee).
Add renderer color maps in §18 (e.g., color by TempoRole, badge by CooldownBand).
Example — validator findings (compact)

{
"tagReport": {

"summary": {

"assetsScanned": 126,

"errors": 4,

"warnings": 2

},
"issues": [

{
"asset": "ACTION_VORGX_WAR_PRIMARY_STRIKE",

"where": "§5.actions[0]",

"problems": [

{ "code": "missingRequiredGroup", "group": "CooldownBand", "expect": ["Light","Mid","Heavy"] }

],
"suggest": ["Add tag: "CooldownBand:Light""]

},
{
"asset": "ACTION_VORGX_WAR_A_Bladestorm",

"where": "§7.subclass.actions[2]",

"problems": [

{ "code": "unknownTagValue", "group": "Delivery", "value": "Sweep", "expect":
["Melee","Ranged","Thrown","Cone","Line","Blast","Leap","Teleport"] }

],
"suggest": ["Replace with one of expected Delivery values"]

},
{
"asset": "PASSIVE_VORGX_WAR_BASE_STANCE",

"where": "§5.passives[1]",

"problems": [

{ "code": "multipleSingletons", "group": "ToggleMechanic", "values": ["Free","BonusAction"] }

],
"suggest": ["Keep a single ToggleMechanic value"]

},
{
"asset": "ACTION_VORGX_WAR_A_Execute",

"where": "§16.tracks.targets[2]",

"problems": [

{ "code": "assetNotInGlossary", "bucket": "actions" }

],
"suggest": ["Add to §17.glossary.actions OR fix key in §16"]

}
],
"warnings": [

{
"asset": "PASSIVE_VORGX_WAR_THICK_HIDE",

"where": "§7.passives[4]",

"problems": [

{ "code": "unusedTagGroup", "group": "Radius", "value": "Self" }

],
"hint": "Passive doesn’t use Radius; remove tag or downgrade to Flavor"

}
]
}
}
18) Renderer Rules

What this section does

Controls how your Blueprint renders in UI (preview tables, diff views, and quick QA):

Columns, order, and grouping for §15 rows.
Color/badge rules based on §17 tag taxonomy.
Collapsers (e.g., the baseline SubclassBase stream).
Icons/tooltips using §17/§19 tokens.
Warnings display fed by §20 validator.
Authoring (drop-in JSON — generic with tips)

{
"renderer": {

"policy": {

"defaultView": "ProgressionTable",

"levelRange": [1, 20],

"notes": "TIP — UI starts on the rendered progression (Section 15)."

},
"columns": {

"table": [

{ "key": "level", "label": "Lvl", "width": 44, "align": "center" },

{ "key": "scope", "label": "Scope", "width": 120, "align": "left" },

{ "key": "grantType", "label": "Type", "width": 96, "align": "left" },

{ "key": "displayName", "label": "Name", "flex": 1, "align": "left" },

{ "key": "tags", "label": "Tags", "width": 280, "align": "left" },

{ "key": "charges", "label": "Uses", "width": 60, "align": "center" }

],
"notes": "TIP — displayName is composed via templates from §17 keys + §19 Loc."

},
"grouping": {

"primary": { "by": "level", "headerFormat": "Level ${level}" },

"secondary": { "by": "scope", "order": ["CLASS","SUBCLASS_*"] },

"collapseRules": [

{ "id": "BASELINE_STREAM", "match": { "choiceListKey": "LIST_SUBCLASSBASE_ALL" }, "collapsedByDefault":

true, "summary": "SubclassBase — 1 pick/level until exhausted" }

],
"pinRules": [

{ "id": "TIER_MARKERS", "match": { "grantType": "UpgradeMarker" }, "pinned": true },

{ "id": "FEATS", "match": { "grantType": "Choice", "choiceListKey": "CHOICE_FEATS" }, "pinned": true }

],

"notes": "TIP — Keep markers and feats visible even when collapsing streams."

},
"sorting": {

"withinLevel": [

{ "by": "grantType", "order":
["UpgradeMarker","Choice","Action","Passive","Status","ListUnlock","ResourceBind","CasterBind","Feat"] },

{ "by": "scope", "order": ["CLASS","SUBCLASS_*"] }

],
"notes": "TIP — Class rows first, then subclass."

},
"colorMaps": {

"byTag": {

"TempoRole": {

"Builder": "#5c9d3b", "Spender": "#d44d4d", "Finisher": "#7d3bd4",

"Setup": "#d49b3b", "Payoff": "#3b80d4", "Maintenance": "#7a8a9a"

},
"CooldownBand": { "Light": "#6ea3ff", "Mid": "#e6c453", "Heavy": "#e87461" },

"PrimaryCategory": { "Action": "#7bd389", "Spell": "#6cc3ff", "Passive": "#c9c9c9", "Stance": "#ffd166", "Aura":
"#f4978e" }

},
"byGrantType": {

"UpgradeMarker": "#a78bfa",

"Choice": "#94d2bd",

"ResourceBind": "#f2cc8f",

"CasterBind": "#9bf6ff"

},
"notes": "TIP — Safe defaults; override per project if desired."

},
"badges": {

"left": [ { "fromTag": "ActionTiming" }, { "fromTag": "School" }, { "fromTag": "Delivery" } ],

"right": [ { "fromTag": "CooldownBand" }, { "fromTag": "TempoRole" } ],

"notes": "TIP — Only show badges that exist on the asset (no empty shells)."

},
"icons": {

"lookup": "§17.glossary.actions/passives/statuses[*].uiIcon || defaults",

"defaults": {

"Action": "Icon_Action_Generic",

"Spell": "Icon_Spell_Generic",

"Passive": "Icon_Passive_Generic",

"Stance": "Icon_Stance_Generic",

"Aura": "Icon_Aura_Generic",

"UpgradeMarker": "Icon_Tier",

"Choice": "Icon_List"

},
"sizePx": 22,

"notes": "TIP — Provide explicit uiIcon in §17 for player-facing assets to avoid defaults."

},
"displayTemplates": {

"name": {

"Action": "${loc.h_ACTION_${key}}",

"Passive": "${loc.h_PASSIVE_${key}}",

"Status": "${loc.h_STATUS_${key}}",

"Spell": "${loc.h_ACTION_${key}}",

"default": "${key}"

},
"tooltip": {

"Action": "${loc.d_ACTION_${key}}",

"Passive": "${loc.d_PASSIVE_${key}}",

"Status": "${loc.d_STATUS_${key}}",

"Spell": "${loc.d_ACTION_${key}}",

"Choice": "Choose from ${choiceListKey}",

"UpgradeMarker": "Tier upgrade checkpoint",

"default": ""

},
"notes": "TIP — Requires §19 Loc tokens; falls back to key if missing."

},
"filters": {

"quick": [

{ "id": "OnlyClass", "expr": "scope == 'CLASS'" },

{ "id": "OnlySubclass","expr": "scope =~ '^SUBCLASS_'" },

{ "id": "OnlyTalents", "expr": "grantType == 'Choice' && choiceListKey =~ 'LIST_.TALENTS.'" },

{ "id": "OnlySpells", "expr": "tags has 'PrimaryCategory:Spell'" }

],
"advanced": { "dsl": true, "notes": "TIP — Allow tag queries: tags.has('TempoRole:Builder') && level>=5" }

},
"warnings": {

"source": "§20.validationReport",

"showBadges": true,

"badgeColor": "#ef4444",

"tooltip": "${issue.code}: ${issue.details}",

"notes": "TIP — Surface validator issues inline on the affected rows."

},
"sections": [

{ "id": "ProgressionTable", "uses": "§15.renderedProgression.rows" },

{ "id": "UpgradeTracks", "uses": "§16.upgrade.tracks", "render": "timeline" },

{ "id": "Catalogs", "uses": "§8.catalog", "render": "cards", "notes": "TIP — Optional: show by groups/lists." }

]
}
}
Field-by-field (what each drives)

policy — default view and level bounds for progressive UIs.
columns.table — fixed table schema for §15 rows; displayName/tooltip come from displayTemplates + §19
Loc.
grouping — primary (Level) and secondary (Scope) grouping; collapseRules let you compress predictable
streams (e.g., SubclassBase), while pinRules keep feats/markers visible.
sorting.withinLevel — deterministic ordering at the same level (markers → choices → actions...).
colorMaps — chip/background colors per tag or grant type.
badges — which tags to surface as small chips left/right of the name.
icons — lookups to UI icons from §17; falls back to defaults.
displayTemplates — string templates for names/tooltips referencing §19 tokens; safe fallback to keys.
filters — built-in toggles and an advanced DSL query mode over row fields/tags.
warnings — inline surfacing of §20 validator messages.
sections — which data blocks the renderer can show (table/timeline/cards).
Validation checklist (for this section)

All template tokens referenced in displayTemplates exist in §19 (or graceful fallback works).
collapseRules /match patterns correctly identify streams (e.g., choiceListKey == LIST_SUBCLASSBASE_ALL).
pinRules don’t hide collapsed content (pinned rows remain visible).
colorMaps keys match §17 tagSets names/values; no orphan colors.
icons.lookup resolves for all player-facing assets, else defaults exist.
filters use valid fields (level, scope, grantType, tags, etc.).
warnings.source points at §20 path used by your pipeline.
Common pitfalls & how to avoid them

Missing Loc → show the key (via default) but flag in §20/§19 to add titles/descriptions.
Over-collapsing → collapse only repeatable streams; keep unique big moments (specialization, feats)
visible/pinned.
Tag color drift → if you extend tagSets in §17, add matching colors here or use a default palette.
Scope sort issues → always keep CLASS before SUBCLASS within a level.
Improvement suggestions

Add per-profile presets (e.g., "profile":"QA" turns on OnlySubclass + warnings pane by default).
Add diff mode to compare two Blueprints (color rows changed/added/removed).
Show aggregate chips per level (count of Builders/Spenders/Spells) for balance snapshots.
Example (filled — minimal, neutral)

{
"renderer": {

"policy": { "defaultView": "ProgressionTable", "levelRange": [1,20] },

"grouping": {

"collapseRules": [

{ "id": "BASELINE_STREAM", "match": { "choiceListKey": "LIST_SUBCLASSBASE_ALL" }, "collapsedByDefault":
true, "summary": "SubclassBase — 1 pick/level" }

],
"pinRules": [

{ "id": "TIER_MARKERS", "match": { "grantType": "UpgradeMarker" }, "pinned": true }

]
},
"colorMaps": {

"byTag": { "TempoRole": { "Builder": "#5c9d3b", "Spender": "#d44d4d" } },

"byGrantType": { "Choice": "#94d2bd", "UpgradeMarker": "#a78bfa" }

},
"badges": { "left": [{ "fromTag": "ActionTiming" }], "right": [{ "fromTag": "TempoRole" }] },

"icons": { "defaults": { "Action": "Icon_Action_Generic", "Choice": "Icon_List", "UpgradeMarker": "Icon_Tier" } },

"displayTemplates": { "name": { "default": "${key}" }, "tooltip": { "Choice": "Choose from ${choiceListKey}",
"default": "" } },

"filters": { "quick": [{ "id": "OnlySubclass", "expr": "scope =~ '^SUBCLASS_'" }] },

"warnings": { "source": "§20.validationReport" },

"sections": [ { "id": "ProgressionTable", "uses": "§15.renderedProgression.rows" } ]

}
}
Patch B — §18 Renderer: “Math” pill (expand/collapse)

What this patch does

Adds a Math pill to the progression table that expands/collapses the tooltip’s calculation block (the composer’s

mechanics/upcasting/tiers sections). Keeps the base one-liner visible; heavy math stays behind an interaction.

Authoring (drop-in JSON — merge into §18.renderer)

{
"uiControls": {

"pills": [

{
"id": "PILL_MATH",

"label": "Math",

"icon": "Icon_Calculator",

"shows": ["mechanics_Action","mechanics_Spell","mechanics_DOT","upcasting","tiers"],

"defaultOpen": false,

"notes": "Toggles detailed math blocks from §19.tooltipComposer.sections"

}
],
"behavior": {

"rememberPerRow": true,

"rememberPerSession": true

}
},
"displayTemplates": {

"tooltip": {

"Action": "${composer.base}\n${PILL_MATH?composer.math:''}",

"Spell": "${composer.base}\n${PILL_MATH?composer.math:''}",

"Passive": "${composer.base}",

"default": "${composer.base}"

}
}
}
How it works (field-by-field)

uiControls.pills[0].shows — which §19 composer sections are considered “math” and hidden until
expanded.
defaultOpen — start collapsed.
behavior.rememberPerRow/Session — UX nicety: keep what the user last opened.
displayTemplates.tooltip — renderer stitches two parts:
composer.base = header + summary (always visible)
composer.math = selected sections (shown when Math pill is toggled)
Validation checklist (for this patch)

PILL_MATH only targets sections that exist in your composer.
displayTemplates.tooltip fallbacks exist (if composer is missing, UI falls back to §19 plain tooltip).
Icons map to a valid UI asset (or your defaults).
Common pitfalls & fixes

Double math (math also in base): ensure your composer doesn’t include mechanics in the base block.
Nothing expands : verify §19 has those sections enabled and populated.
Example (minimal UI config merged)

{
"renderer": {

"uiControls": {

"pills": [{ "id": "PILL_MATH", "label": "Math", "shows": ["mechanics_Action","upcasting","tiers"], "defaultOpen":
false }],

"behavior": { "rememberPerRow": true }

}
}
}
19) Localization — Tooltip Composer (detailed math, tiers & upcasting)

What this section does

Adds a structured tooltip generator that:

Explains what the ability does in plain language.
Shows base math (dice + modifiers), tier bonuses (from §16), and upcasting deltas (from §11).
Adapts wording per PrimaryCategory (Action/Spell/Passive/Stance/Aura).
Pulls variables from §§5/7 (ability stats), §11 (casting), §16 (upgrade tracks), and §17 (tags).
Authoring (drop-in JSON — generic with tips; paste under localization)

{
"tooltipComposer": {

"policy": {

"maxLines": 16,

"showVariablesTable": true,

"mathFormat": "inline", /* inline | block */

"diceStyle": "XdY(+Z)", /* how dice expressions render */

"showCritLine": true,

"showSaveLine": true,

"showScalingNotes": true,

"notes": "TIP — Keep concise but complete; hide sections that are not applicable."

},
"variableSources": {

"abilityData": "§5.actions|§7.actions (base dice, abilityMod, prof, tags)",

"statusData": "§5.statuses|§7.statuses (DoT/HoT dice, durations)",

"castingData": "§11.casting (slotProgression, upcastDicePerTier, slotCost)",

"upgradeTracks": "§16.upgrade.tracks (resolved deltas per tier/level)",

"tags": "§17.glossary.tagSets (Delivery, School, TempoRole, etc.)"

},
"helpers": {

"fmtDice": "${diceCount}d${dieSize}${flatBonus?+${flatBonus}:``}",

"sum": "${base + abilityMod + prof + tierBonus + misc}",

"joinDeltas":"${deltas.map(d=>d.label+': '+d.value).join(', ')}",

"plural": "${n==1?one:many}",

"notes": "TIP — Your exporter implements these helper functions."

},
"sections": {

"header": "${name}",

"summary": "${oneLine || 'Use this to ' + role + ' (' + tags.join(', ') + ').'}",

"mechanics_Action": [

"Base Damage: ${fmtDice(baseDice)} ${damageType} ${scaling?(scales with ${scaling}):``}",

"${abilityMod!=0?Ability Mod: ${abilityMod >=0?'+':''}${abilityMod}:``}",

"${prof>0?Proficiency: +${prof}:``}",

"${tierBonus!=0?Tier Bonus: +${tierBonus} (from ${tierSource}):``}",

"${misc!=0?Misc: ${misc >=0?'+':''}${misc}:``}",

"Total (on hit): ${sum}"

],
"mechanics_Spell": [

"Base: ${fmtDice(baseDice)} ${school?(${school}):``}",

"${upcast.enabled?Upcasting: +${upcast.perLevelDice} per slot level above ${upcast.baseSlot}:``}",

"${saveType?Save: ${saveType} vs DC ${saveDC}:``}",

"${concentration?Concentration: required:Concentration: none}"

],
"mechanics_DOT": [

"Damage over Time: ${fmtDice(dotDice)} each turn for ${dotTurns} ${plural(dotTurns,'turn','turns')}",

"${tierDotBonus?Tier Bonus: +${tierDotBonus} per tick:``}"

],
"delivery": [

"Delivery: ${delivery}${range?, Range: ${range}m:}${radius?`, Radius: ${radius}m`:}${targets?, Targets: ${targets}:``}"

],
"economy": [

"${resourceCost?Resource: ${resource} ${resourceCost}:Resource: none}",

"${charges?Charges: ${charges} per ${perRest}:``}",

"${cooldown?Cooldown: ${cooldown}:``}"

],
"crit": [

"${showCritLine?Critical: ${critDice?fmtDice(critDice):'weapon crit rules apply'}${critRange?, Range:
${critRange}+:' '}:''}"

],
"scaling": [

"${showScalingNotes?Scaling: +${scalingMod} from ${scalingSource} per tier/slot as applicable.:''}"

],
"tiers": [

"${tierSummary || 'Tiers: I ('+tierAt[0]+'), II ('+tierAt[1]+'), III ('+tierAt[2]+'), IV ('+tierAt[3]+')'}",

"${tierDeltas?joinDeltas(tierDeltas):''}"

],
"upcasting": [

"${upcast.enabled?Upcast Breakdown::''}",

"${upcast.enabled?upcast.table:''}" /* exporter renders a mini table: Slot→Extra Dice/Targets/Radius */

],
"footer": "${keywords?Keywords:+keywords.join(', '):''}"

},
"templates": {

"Action": ["header","summary","mechanics_Action","delivery","economy","crit","tiers","footer"],

"Spell": ["header","summary","mechanics_Spell","delivery","economy","upcasting","crit","tiers","footer"],

"Passive": ["header","summary","scaling","tiers","footer"],

"Stance": ["header","summary","economy","footer"],

"Aura": ["header","summary","delivery","economy","footer"]

},
"rendering": {

"composeFrom": "§18.displayTemplates.tooltip when empty",

"markdown": true,

"bulletStyle": "• ",

"notes": "TIP — If §18.tooltip has a value, use it; else compose from these sections."

}
}
}
Field-by-field (what each drives)

policy — length and formatting preferences (crit/save/scaling visibility).
variableSources — where the exporter pulls numbers and flags from.
helpers — formatting utilities (dice strings, sums, joining deltas).
sections — reusable building blocks; the exporter hides lines where interpolations are empty.
templates — which blocks to stitch together per PrimaryCategory.
rendering.composeFrom — fallback chain with §18; if §18 already supplies a tooltip, keep it, otherwise
compose here.
Validation checklist (tooltips)

Every player-facing asset resolves to at least header + one mechanics block.
Numbers present : baseDice, abilityMod/saveDC/prof where relevant; hidden if not applicable.
Tier integration : tierAt[] pulled from §16/§14 policy; tierDeltas reflect resolved upgrade track deltas.
Upcasting : only shows if upcast.enabled and §11 provides perLevelDice/table; otherwise the whole block
hides.
No orphan variables : any ${...} that can’t be resolved must collapse to an empty string (no raw placeholders).
Length guard : if content exceeds maxLines, collapse Upcasting table first, then Scaling notes.
Common pitfalls & how to avoid them

Mismatched keys — Make sure the action/passive keys in §5/§7 match the tokens used for name/desc.
Missing source data — If an asset lacks baseDice or school, the composer hides those lines; optionally warn
in §20.
Tier drift — When you move tier levels in §14 or §16, the tooltip will automatically reflect them (pulls from
policy).
Improvement suggestions

Add a per-class glossary of terminology (e.g., define “Primary Window”) and auto-append to tooltips on first
unlock.
Allow short/long modes (tap/hold to expand) in the renderer: short shows summary + key math; long shows
full blocks.
Render a compact math table for complicated spenders (columns: Base, Stat, Prof, Tier, Misc, Total).
Example (filled — neutral, two abilities)

Example A — Martial Action (Builder with tiers)

Primary Strike

Quick melee attack to set up spends (Builder, Melee, Light).
Base Damage: 1d8 Slashing (scales with Weapon)
Ability Mod: +4
Proficiency: +3
Tier Bonus: +1 (from TRACK_VORGX_WAR_CORE @ Tier II)
Total (on hit): 1d8 + 8
Delivery: Melee, Range: 1.5m
Resource: none
Critical: weapon crit rules apply
Tiers: I (5), II (8), III (13), IV (18)
Damage Bonus per Tier: I:+1, II:+2, III:+3, IV:+4
Example B — Spell (Upcasting + save + tiers)

Frost Lance

Hurl a shard of frost that chills foes (Spender, Evocation).
Base: 3d8 (Evocation)
Upcasting: +1d8 per slot above 2nd
Save: CON vs DC 15
Concentration: none
Delivery: Ranged, Range: 18m
Resource: Spell Slot 2nd
Critical: weapon crit rules apply
Tiers: I (5), II (8), III (13), IV (18)
Tier Effects: +1 die at Tier II, +2 die at Tier III (from TRACK_VORGX_MAGE_A_ICE_BLAST)
Upcast Breakdown:
3rd: +1d8 → 4d8 total
4th: +2d8 → 5d8 total
5th: +3d8 → 6d8 total
20) Validation

What this section does

Runs a unified, pre-export sanity suite over the entire Blueprint. It:

Enforces schema/types/order and add-only authoring.
Verifies cross-section links (lists, assets, upgrade targets).
Checks progression policy (feats, tiers, specialization, SubclassBase bucket stream).
Validates resources/casting (binds, caps, full-9 support).
Lints tags against §17’s taxonomy and coverage rules.
Audits tooltips for math/tier/upcasting completeness.
Emits a structured report for UI/CI (fail on errors, warn on nits).
Authoring (drop-in JSON — generic with tips)

{
"validation": {

"policy": {

"namespace": "VORGX",

"strict": true,

"failOn": ["error"],

"warnOn": ["warn"],

"notes": "TIP — Set strict=false for drafts; CI should keep strict=true."

},
"suites": {

"schema": {

"enabled": true,

"rules": {

"types": true,

"noCommentsInValues": true,

"requiredSections":
["§1","§2","§3","§4","§5","§6","§7","§8","§9","§10","§11","§12","§13","§14","§15","§16","§17","§18","§19","§21","§22"],

"requiredOrder": true,

"addOnlyAuthoring": true

}
},
"namespace": {

"enabled": true,

"rules": {

"prefix": "VORGX",

"buckets":
["actions","passives","statuses","effects","lists","choices","resources","casterTracks","markers","upgradeTracks","speci

alization"],

"disallowVanillaKeys": true

}
},
"progression": {

"enabled": true,

"rules": {

"featLevels": [4,8,12,16,20],

"tierBreaks": [5,8,13,18],

"subclassUnlockLevel": 1,

"specialization": { "keyAt": 13, "capstoneAt": 13, "nodesAt": [13,15,18], "passivesRange": [13,20], "perLevel": 1
},

"classTalentCadenceLevels": [3,5,7,9,11,13,15,17,19],

"specTalentCadenceLevels": [3,5,7,9,11,13,15,17,19],

"subclassBase": {

"level1BonusPicks": { "OFFENSE": 1, "UTILITY": 1 },

"stream": { "start": 2, "end": 20, "perLevel": 1, "listKey": "LIST_SUBCLASSBASE_ALL", "stopWhenComplete":

true }

}
},
"checks": {

"allRowsAtomic": true,

"listsResolve": true,

"choiceQuantitiesValid": true,

"classRowsBeforeSubclassAtSameLevel": true

}
},
"crossRefs": {

"enabled": true,

"rules": {

"sectionLinks": [

{ "from": "§14.rows[].choiceListKey", "mustExistIn": "§8.lists[].key" },

{ "from": "§14.rows[].key", "mustExistInAny":
["§5.actions[].key","§5.passives[].key","§7.actions[].key","§7.passives[].key","§7.statuses[].key"] },

{ "from": "§16.tracks[].targets", "mustExistInAny":
["§5.actions[].key","§5.passives[].key","§7.actions[].key","§7.passives[].key","§7.statuses[].key"] },

{ "from": "§16.plan[].apply[].target","mustExistInAny": ["§5.actions[].key","§7.actions[].key","§7.statuses[].key"]
},

{ "from": "§14.rows[].key", "mustNotDuplicateAtSameLevel": true }

],
"markersPresent": ["MARK_TIER_I","MARK_TIER_II","MARK_TIER_III","MARK_TIER_IV"]

}
},
"resources": {

"enabled": true,

"rules": {

"bindsMustPointToDefinedResource": true,

"builderSpenderBalance": { "minBuilders": 1, "minSpenders": 1 },

"capRange": { "min": 0, "max": 11 },

"perRestAllowed": ["Short","Long","None"]

}
},
"casting": {

"enabled": true,

"rules": {

"allowFull9": true,

"allowedTracks":

["CASTTRACK_STANDARD_FULL_9","CASTTRACK_STANDARD_HALF_9","CASTTRACK_STANDARD_THIRD_9","CASTT
RACK_SPELL_POINTS_HIGH"],

"requireBindForCasterSubclass": true,

"highSlotGateOptional": true

}
},
"presets": {

"enabled": true,

"rules": {

"statBounds": { "min": 3, "max": 20 },

"sumSoftHint": { "min": 69, "max": 75 },

"savesTwoProficiencies": true

}
},
"icons": {

"enabled": true,

"rules": {

"requireIconForPlayerFacing": true,

"defaultIconAllowed": true

}
},
"upgradeTracks": {

"enabled": true,

"rules": {

"atOrAtTierOnly": true,

"noDuplicateCheckpoints": true,

"deltasAllowed": [

"damageDieBonus","tickDiceBonus","healDieBonus","flatBonus","critRangeDelta",

"attackRollBonus","saveDCBonus","acBonus","resistBonus","vulnBonus",

"rangeMetersDelta","radiusMetersDelta","extraTargetIfAdjacent","refEffect",

"durationTurnsDelta","chargesDelta","perRestOverride","statusBonusTo",

"damageDieBonusDelta","applyStatusOnHit","slotCostDelta","upcastDicePerTier","concentrationSaveBonus"

]
}
},
"tags": {

"enabled": true,

"source": "§17.tagValidator",

"inheritFromGlossary": true

},
"tooltips": {

"enabled": true,

"rules": {

"requireForBuckets": ["actions"],

"requireFieldsByPrimary": {

"Action": ["hasBaseDiceOrFlat", "hasTotalLine"],

"Spell": ["hasBaseDiceOrFlat", "hasTotalLineOrSaveDC"]

},
"requireUpcastWhenEnabled": true,

"requireTierSummaryWhenTracked": true,

"failOn": ["missingCoreMath","missingUpcast","missingTierSummary"],

"warnOn": ["noCritLine","noDelivery"]

},
"sources": {

"tooltipComposer": "§19.tooltipComposer",

"tags": "§17.glossary.tagSets",

"upgradeTracks": "§16.upgrade.tracks",

"casting": "§11"

}
}
},
"report": {

"emitSummary": true,

"emitPerSuite": true,

"emitPerIssue": true,

"limitPerSuite": 50,

"format": "compact|json",

"notes": "TIP — Keep compact for UI; switch to json for CI logs."

}
}
}
Field-by-field (what each drives)

policy — global validator behaviour: namespace expectation, strictness, error/warn thresholds.
suites.schema — JSON hygiene & section ordering; enforces add-only authoring.
suites.namespace — all keys must be namespaced; rejects vanilla collisions.
suites.progression — feat/tier/subclass/spec cadence; SubclassBase bucket (2 picks at L1 + 1 per level
L2→20, stop when complete).
suites.crossRefs — resolves all keys and lists across §§5/7/8/14/15/16; checks for duplicate grants at a level;
ensures tier markers exist.
suites.resources — resource binds point to defined resources; caps/windows inside policy; per-subclass
builder/spender floor.
suites.casting — only allowed casting tracks; caster subclasses must have a binder; full-9 allowed (per §11).
suites.presets — ability presets within 3–20; soft total bounds; saving throws have two proficiencies.
suites.icons — every player-facing asset has an icon (explicit or default).
suites.upgradeTracks — legal checkpoint grammar and delta vocabulary; no duplicate at levels or resolved
atTier collisions.
suites.tags — imports §17 Tag Validator: tagSets, singletons, required-per-primary, cross-bucket asset
existence.
suites.tooltips — requires core math lines for Actions/Spells; enforces upcasting block when enabled; tier
summary when tracked by §16; warns on missing crit/delivery.
report — structured output for renderers and CI.
Validation checklist (for this section)

Section order & schema valid; no comments in values; add-only mutations.
Namespace : all keys start with VORGX (or your chosen prefix).
Progression : feats at 4/8/12/16/20; tier markers at 5/8/13/18; specialization at 13 (Key+Capstone+Node1), 15
(Node2), 18 (Node3), passives each level 13→20; SubclassBase stream present.
Cross-refs : every choiceListKey exists in §8; all actions/passives/statuses referenced exist in §5/§7; no same-
level dupes.
Resources : binds to defined RES_*; caps/windows inside allowed bounds; ≥1 builder and ≥1 spender per
subclass.
Casting : only allowed CASTTRACK_*; caster subclasses bound; L9 support consistent with §11.
Upgrade Tracks : allowed deltas only; no duplicate checkpoints; at or atTier (not both) within an apply.
Tags : PrimaryCategory present; required groups satisfied; singleton groups unique; all tag values from §17
tagSets (or pass Flavor regex); assets exist in glossary & authoring sections.
Tooltips :
Actions/Spells have Base and Total (or Save DC for save-based spells).
If upcasting exists in §11, Upcasting section/table renders.
If §16 touches an asset, Tier summary renders.
Optional niceties (Crit, Delivery) surface as warnings if absent.
Common pitfalls & how to avoid them

Tier drift — If you move tierBreaks in §14, also sync §16 tierToLevelMap and keep this suite’s tierBreaks
updated.
CHOICE vs LIST — wire §14 rows to CHOICE_* (UI pickers) or LIST_* (catalogs) appropriately; crossRefs will
flag mismatches.
Caster bind forgotten — adding spells without a §14 CasterBind row fails
casting.requireBindForCasterSubclass.
Tooltip missing math — ensure §19 tooltip composer has access to baseDice/abilityMod/prof/tier deltas;
otherwise the math block won’t render.
Tag typos — rely on §17 tagSets and tagValidator; extend Flavor via regex if you need bespoke themes.
Duplicate upgrade levels — keep each track’s checkpoints unique after atTier resolves to concrete levels.
Improvement suggestions

Add profiles (e.g., "profile":"dev|strict") to toggle failOn/warnOn sets.
Auto-generate fix-it patches (JSON Patch) for common errors (e.g., inject CooldownBand:Light for melee
builders).
Emit coverage metrics : % of assets with complete tooltips, tag compliance rate, builder/spender ratios, etc.
Provide exemptions list for legacy content while migrating (time-boxed, with TODO notes).
Example (filled — compact report)

{
"validationReport": {

"summary": { "suites": 11, "errors": 3, "warnings": 5 },

"schema": { "errors": [], "warnings": [] },

"namespace": { "errors": [], "warnings": [] },

"progression": {

"errors": [],

"warnings": [{ "code": "subclassBaseExhaustsEarly", "level": 14, "details": "LIST_SUBCLASSBASE_ALL has 12

entries; stream no-ops from L15." }]

},
"crossRefs": {

"errors": [

{ "code": "choiceListMissing", "from": "§14.rows[27].choiceListKey", "value": "LIST_SUBCLASSSPEC_ROW_8" }

],

"warnings": []

},
"resources": { "errors": [], "warnings": [{ "code": "noSpenderDetected", "subclass": "SUBCLASS_VORGX_WAR_A"
}] },

"casting": { "errors": [], "warnings": [] },

"presets": { "errors": [], "warnings": [] },

"icons": { "errors": [], "warnings": [{ "code": "missingIcon", "asset": "ACTION_VORGX_WAR_A_Execute" }] },

"upgradeTracks": { "errors": [], "warnings": [] },

"tags": {

"errors": [

{ "code": "missingRequiredGroup", "asset": "ACTION_VORGX_WAR_PRIMARY_STRIKE", "group":
"CooldownBand" }

],
"warnings": [

{ "code": "unusedTagGroup", "asset": "PASSIVE_VORGX_WAR_THICK_HIDE", "group": "Radius", "value": "Self" }

]
},
"tooltips": {

"errors": [

{ "code": "missingCoreMath", "asset": "ACTION_VORGX_WAR_PRIMARY_STRIKE" },

{ "code": "missingUpcast", "asset": "ACTION_VORGX_MAGE_ICE_LANCE" }

],
"warnings": [

{ "code": "noCritLine", "asset": "ACTION_VORGX_WAR_PRIMARY_STRIKE" },

{ "code": "noDelivery", "asset": "ACTION_VORGX_MAGE_ICE_LANCE" }

]
}
}
}
21) Export Settings

What this section does

Controls how the Blueprint is turned into a BG3 mod package :

Maps Blueprint sections to LSX/LSF files and the folder tree.
Normalizes data (dice → ints for LSX, booleans, enums).
Sets mod meta (UUIDs, versioning, dependencies).
Handles icons/loc emission and skeleton generation (optional “GENERATE SKELETON”).
Supports add-only exports , up to level 9 casting (when enabled in §§10–11), and Community Library
conventions.
Authoring (drop-in JSON — generic with tips)

{

"export": {

"policy": {

"namespace": "VORGX",

"author": "vorgx",

"modName": "",

"modFolder": "",

"version": "0.1.0",

"buildNumber": 1,

"semver": true,

"addOnly": true,

"normalize": {

"diceToInts": true,

"bools": true,

"enumsUpper": true,

"stripEmpty": true

},
"targetGame": "BG3",

"notes": "TIP — Keep addOnly=true; exporter emits only new rows/tags."

},
"paths": {

"root": "Public/Mods/${modFolder}/",

"meta": "Mods/${modFolder}/meta.lsx",

"generated": "Public/${modFolder}/",

"progressions": "Public/${modFolder}/Progressions/",

"stats": "Public/${modFolder}/Stats/Generated/",

"icons": "Public/${modFolder}/GUI/Assets/",

"localization": "Localization/${modFolder}/",

"scripts": "Public/${modFolder}/Scripts/",

"notes": "TIP — Mirrors typical BG3 mod structure; adjust if your packer expects different casing."

},
"files": {

"meta": {

"author": "${author}",

"name": "${modName}",

"folder": "${modFolder}",

"version": "${version}",

"uuid": "<AUTO-GEN>",

"dependencies": [

{ "uuid": "CommunityLibrary-UUID", "optional": true, "notes": "TIP — Include if you rely on its helpers." }

],
"targets": ["Story","Public"],

"notes": "TIP — UUIDs auto-generate unless provided."

},

"progressions": {

"from": "§15.renderedProgression.rows",

"to": "Progressions/*.lsx",

"partitionBy": "appliesTo",

"includeMarkers": true,

"notes": "TIP — One LSX per class/subclass for sane diffs."

},
"stats": {

"actions": { "from": "§5.actions + §7.actions", "to": "Stats/Generated/Actions/*.txt" },

"passives": { "from": "§5.passives + §7.passives", "to": "Stats/Generated/Passives/*.txt" },

"statuses": { "from": "§5.statuses + §7.statuses", "to": "Stats/Generated/Status_/.txt" },

"lists": { "from": "§8.catalog", "to": "Stats/Generated/Lists/*.txt" },

"resources": { "from": "§9.resources", "to": "Stats/Generated/Resources/*.txt" },

"casting": { "from": "§10 + §11", "to": "Stats/Generated/SpellCasting/*.txt" },

"upgrade": { "from": "§16.upgrade", "to": "Stats/Generated/Upgrades/*.txt" },

"notes": "TIP — Exporter flattens JSON to Larian Stats format per bucket."

},
"icons": {

"from": "§5 + §7 (uiIcon hints) + §17.glossary.loc",

"to": "GUI/Assets/Icons_*.dds",

"placeholders": true,

"atlas": { "makeAtlas": true, "maxSize": 2048, "padding": 2 },

"notes": "TIP — If uiIcon missing, generate a neutral placeholder per PrimaryCategory."

},
"localization": {

"from": "§19.localization",

"to": "Localization/${modFolder}/${modFolder}_English.loca.xml",

"lang": "en",

"multiLang": false,

"notes": "TIP — Enable multiLang to emit per-language files."

}
},
"options": {

"skeleton": {

"enabled": true,

"readme": true,

"includeExamples": false,

"folders": ["Progressions","Stats/Generated","Localization","GUI/Assets","Scripts"],

"notes": "TIP — “GENERATE SKELETON” switch. Creates empty files with stubs for each bucket."

},
"packing": {

"output": "dist/${modFolder}.pak",

"compress": true,

"hashContent": true,

"sign": false,

"exclude": ["/.psd","/.md","*/.map"],

"notes": "TIP — Add signature only if your pipeline supports it."

},
"conflicts": {

"detectOverlaps": true,

"scanVanilla": true,

"reportOnly": true,

"notes": "TIP — Report if you would overwrite vanilla; with addOnly=true export should avoid it."

}
},
"bridges": {

"tierMapFrom§14": true,

"upcastTableFrom§11": true,

"tagTaxonomyFrom§17": true,

"tooltipComposerFrom§19": true,

"validationFrom§20": true,

"notes": "TIP — Bridges pull computed data into exporters (e.g., Tier → Upgrade Tracks → Stats)."

},
"compatibility": {

"full9Casting": {

"enabled": false,

"track": "CASTTRACK_STANDARD_FULL_9",

"patchLists": true,

"notes": "TIP — Flip to true when §10–§11 enable L9; exporter ensures slot tables and lists are present."

},
"communityLibrary": {

"require": false,

"uuid": "CommunityLibrary-UUID",

"notes": "TIP — Set require=true if you use CL statuses/functions."

}

}
}
}
Field-by-field (what each drives)

policy
namespace/author/modName/modFolder — identity for meta.lsx and file tree.
version/buildNumber/semver — used in meta and dist naming.
addOnly — guarantees no vanilla overwrites ; exporter filters out collisions.
normalize — output hygiene (dice to ints for LSX; strip empty/nulls).
paths — root map for where each bucket lands inside the mod.
files.meta — meta.lsx contents: UUID , version, name, dependencies. If CommunityLibrary is required, list its
UUID.
files.progressions — flattens §15 one-row-per-grant to Progressions LSX; optionally partition per scope
(class vs subclass).
files.stats — emits Larian Stats text files for Actions/Passives/Statuses/Lists/Resources/Casting/Upgrades.
Uses §16 to materialize tier deltas.
files.icons — packs UI icons; can auto-generate placeholders and a packed DDS atlas for performance.
files.localization — writes §19 tokens to *.loca.xml; multi-language optional.
options.skeleton — “GENERATE SKELETON”: creates folders and stub files (README with wiring notes,
placeholder icons, empty LSX/Stats files).
options.packing — .pak creation, compression, content hashing, signature placeholder, excludes.
options.conflicts — dry-run scan for any accidental vanilla overlap (should be clean with addOnly).
bridges — computed data feeds : Tier map (from §14) → Upgrade Tracks (§16), Upcast tables (§11), Tags (§17),
Tooltips (§19), and the §20 validator.
compatibility.full9Casting — when true, exporter enforces L9 spell support : slot tables, lists, and any
needed binds (it does not change gameplay—this mirrors §§10–11 settings).
Validation checklist (for this section)

Meta : name/folder/version present; unique UUID ; dependencies valid (if used).
Paths resolve and are writable; no duplicate output filenames across buckets.
Normalization : dice strings converted to integers for LSX; booleans/enums canonical; empty fields stripped.
Add-only : no file produced would overwrite a vanilla asset (conflict scanner clean).
Bridges : tier map exists; upcast data exists when full9Casting.enabled=true; tag taxonomy present.
Icons/Loc : every player-facing asset has an icon (or placeholder) and a title token; descriptions
recommended.
Packing : .pak contains only whitelisted folders; excludes applied.
Skeleton (if enabled): all directories created with correct casing, and README points to § index and keys.
Common pitfalls & how to avoid them

Mismatched folder casing — BG3 is picky; stick to Public/Mods/<Mod>/ and Public/<Mod>/....
Missing UUID — always set or auto-generate; never reuse across unrelated mods.
Dice left as strings in LSX — keep normalize.diceToInts=true.
Accidentally overwriting vanilla — keep addOnly=true and run conflict scan.
Forgetting L9 wiring — turning on compatibility.full9Casting without §§10–11 data will fail the bridge check.
Improvement suggestions

Add a “dryRun” mode that writes all outputs to a temp folder and produces a manifest diff without packing.
Generate an export manifest (dist/manifest.json) listing every emitted file, counts per bucket, and hash
sums.
Support profiled exports (dev, release) with toggles: include examples, strip comments, compress textures.
Hook a post-pack smoke test : load .pak, parse LSX headers, and assert Progressions/Stats are present.
Example (filled — minimal, neutral)

{
"export": {

"policy": { "namespace": "VORGX", "author": "vorgx", "modName": "Vorgx_Warrior", "modFolder": "Vorgx_Warrior",

"version": "0.3.2", "buildNumber": 42, "semver": true, "addOnly": true,

"normalize": { "diceToInts": true, "bools": true, "enumsUpper": true, "stripEmpty": true } },

"paths": {

"root": "Public/Mods/Vorgx_Warrior/",

"meta": "Mods/Vorgx_Warrior/meta.lsx",

"generated": "Public/Vorgx_Warrior/",

"progressions": "Public/Vorgx_Warrior/Progressions/",

"stats": "Public/Vorgx_Warrior/Stats/Generated/",

"icons": "Public/Vorgx_Warrior/GUI/Assets/",

"localization": "Localization/Vorgx_Warrior/"

},
"files": {

"meta": { "author": "vorgx", "name": "Vorgx_Warrior", "folder": "Vorgx_Warrior", "version": "0.3.2", "uuid": "<AUTO-
GEN>", "dependencies": [] },

"progressions": { "from": "§15.renderedProgression.rows", "to": "Progressions/Warrior.lsx", "partitionBy":
"appliesTo", "includeMarkers": true },

"stats": {

"actions": { "from": "§5.actions + §7.actions", "to": "Stats/Generated/Actions/*.txt" },

"passives": { "from": "§5.passives + §7.passives", "to": "Stats/Generated/Passives/*.txt" },

"statuses": { "from": "§5.statuses + §7.statuses", "to": "Stats/Generated/Status_Effects/*.txt" },

"lists": { "from": "§8.catalog", "to": "Stats/Generated/Lists/*.txt" },

"resources": { "from": "§9.resources", "to": "Stats/Generated/Resources/*.txt" },

"casting": { "from": "§10 + §11", "to": "Stats/Generated/SpellCasting/*.txt" },

"upgrade": { "from": "§16.upgrade", "to": "Stats/Generated/Upgrades/*.txt" }

},
"icons": { "from": "§5 + §7 + §17", "to": "GUI/Assets/Icons_Class_Warrior.dds", "placeholders": true, "atlas": {
"makeAtlas": true, "maxSize": 2048, "padding": 2 } },

"localization": { "from": "§19.localization", "to": "Localization/Vorgx_Warrior/Vorgx_Warrior_English.loca.xml",
"lang": "en" }

},
"options": {

"skeleton": { "enabled": true, "readme": true, "folders":
["Progressions","Stats/Generated","Localization","GUI/Assets"] },

"packing": { "output": "dist/Vorgx_Warrior.pak", "compress": true, "hashContent": true, "exclude":

["/.psd","/.md"] },

"conflicts": { "detectOverlaps": true, "scanVanilla": true, "reportOnly": true }

},
"bridges": { "tierMapFrom§14": true, "upcastTableFrom§11": true, "tagTaxonomyFrom§17": true,

"tooltipComposerFrom§19": true, "validationFrom§20": true },

"compatibility": { "full9Casting": { "enabled": false, "track": "CASTTRACK_STANDARD_FULL_9", "patchLists": true }

}

}
}
22) Change Log

What this section does

Keeps a structured, human- and machine-readable history of edits to the Blueprint:

Records what changed , why , and where (section/keys).
Tags each change with type (add/update/remove/fix), breaking status , and impact on validation/export.
Powers diff views in §18 and versioning in §21 (export metadata).
Authoring (drop-in JSON — generic with tips)

{
"changelog": {

"policy": {

"semver": true,

"dateFormat": "YYYY-MM-DD",

"timezone": "project",

"requireEntryOnExport": true,

"autogenFromDiff": true,

"notes": "TIP — If autogenFromDiff=true, exporter proposes an entry based on section/key diffs; you can edit

before packing."

},
"unreleased": {

"since": "",

"summary": {

"added": 0,

"changed": 0,

"removed": 0,

"fixed": 0,

"notes": "TIP — Aggregated counters update as you append changes."

},
"changes": [

{
"type": "add|change|remove|fix",

"section": "§",

"scope": "CLASS|SUBCLASS_<...>|GLOBAL",

"keys": [],

"title": "",

"details": "",

"rationale": "",

"breaking": false,

"tickets": [],

"validationImpact": "none|requiresReRun|mayFail",

"exportImpact": "none|requiresRebuild",

"author": "",

"date": ""

}
]
},
"releases": [

{
"version": "0.0.0",

"date": "",

"author": "",

"compat": { "full9Casting": false, "requiresCommunityLibrary": false },

"summary": {

"added": 0,

"changed": 0,

"removed": 0,

"fixed": 0,

"highlights": []

},
"changes": [

{
"type": "add",

"section": "§5",

"scope": "CLASS",

"keys": ["ACTION_<...>_PRIMARY_STRIKE"],

"title": "Add Primary Strike",

"details": "Initial builder action wired to resource model.",

"rationale": "Core loop needs a builder.",

"breaking": false,

"tickets": ["JIRA-123"],

"validationImpact": "requiresReRun",

"exportImpact": "requiresRebuild"

} ] } ] } }
Field-by-field (what each drives)

policy
semver — release versioning matches §21 export.policy.semver.
requireEntryOnExport — exporter blocks packaging if Unreleased has changes but no version tag.
autogenFromDiff — exporter proposes additions by diffing §§4–21 since last release.
unreleased — staging area:
since — ISO date of last version tag.
summary — counters for quick glance in UI.
changes[] — granular edits (use section, scope, keys to make diffs precise).
validationImpact — hints §20 to surface focused re-runs in UI.
exportImpact — tells §21 whether to rebuild the package.
releases[] — frozen, tagged versions:
version/date/author — matches §21 meta.
compat — snapshot of feature flags (e.g., full-9 casting ).
summary.highlights — bullet snippets shown in README or Nexus page notes.
changes[] — same schema as Unreleased, but immutable.
Validation checklist (for this section)

Unreleased entries have type, section, and at least one key (unless the change is purely policy/renderer).
Release entries include version (semver), date , and author.
Breaking changes list a rationale.
Export block : if requireEntryOnExport=true and unreleased.changes is non-empty, §21 must fail unless you
tag a new release.
Counters (summary) match the number of entries by type.
Common pitfalls & how to avoid them

Forgetting to tag — leave requireEntryOnExport=true so exports prompt you to bump the version.
Vague keys — always include explicit token names (from §17) in keys[] to make diffs actionable.
No rationale — provide a short “why” to aid future balance/QA reviews.
Missed impacts — set validationImpact/exportImpact so tooling knows whether to re-run heavy checks or
rebuild.
Improvement suggestions

Generate a CHANGELOG.md during §21 export using releases[] + current Unreleased.
Add contributors metadata per entry for multi-author efforts.
Support labels (e.g., ["balance","ux","content"]) to filter in the §18 renderer.
Hook auto-close notes to your issue tracker (e.g., add “Fixes JIRA-123”).
Example (filled — minimal, neutral)

{
"changelog": {

"policy": { "semver": true, "dateFormat": "YYYY-MM-DD", "requireEntryOnExport": true, "autogenFromDiff": true },

"unreleased": {

"since": "2025-10-01",

"summary": { "added": 1, "changed": 2, "removed": 0, "fixed": 1 },

"changes": [

{ "type": "change", "section": "§16", "scope": "SUBCLASS_VORGX_WAR_A", "keys":
["TRACK_VORGX_WAR_A_STRIKES"], "title": "Rebalance strike dice per tier", "details": "+1 die at Tier II/III",

"rationale": "Bring spenders in line with builders", "breaking": false, "tickets": [], "validationImpact":
"requiresReRun", "exportImpact": "requiresRebuild", "author": "vorgx", "date": "2025-10-10" },

{ "type": "fix", "section": "§15", "scope": "CLASS", "keys": ["LIST_CLASS_TALENTS_ROW_8"], "title": "Fix missing

list link", "details": "choiceListKey corrected", "rationale": "Validator crossRef error", "breaking": false, "tickets":
["QA-55"], "validationImpact": "requiresReRun", "exportImpact": "requiresRebuild", "author": "vorgx", "date": "2025-

10-10" }

]
},
"releases": [

{
"version": "0.3.2",

"date": "2025-10-07",

"author": "vorgx",

"compat": { "full9Casting": false, "requiresCommunityLibrary": false },

"summary": { "added": 3, "changed": 1, "removed": 0, "fixed": 2, "highlights": ["Added SubclassBase stream and
Specialization package", "Wired Tag Validator and Renderer badges"] },

"changes": [

{ "type": "add", "section": "§7", "scope": "SUBCLASS_VORGX_WAR_A", "keys":

["ACTION_VORGX_WAR_A_MortalStrike"], "title": "Add spender", "details": "New spender with bleed synergy",
"rationale": "Subclass identity", "breaking": false, "tickets": [], "validationImpact": "requiresReRun", "exportImpact":

"requiresRebuild" },

{ "type": "change", "section": "§14", "scope": "CLASS", "keys": ["LIST_CLASS_TALENTS_ROW_1"], "title":

"Cadence polish", "details": "Ensure class talents unlock at L1 and every 2 levels", "rationale": "Parity with design
doc", "breaking": false, "tickets": ["DES-18"], "validationImpact": "requiresReRun", "exportImpact":
"requiresRebuild" }

]
}
]
}
}
This is a offline tool, your data stays locally and is not send to any server!
Feedback & Bug Reports