# BG3 Class Mod — Blueprint Template (v1)

**_A Complete Authoring Framework for WoW → BG3 Class Conversion_**

**Owner:** vorgx  **Version:** v1  **Last Updated:** 12 Oct 2025  **Scope:** Full Class + Subclass Authoring → Export-Ready . pak

**Introduction**

The **BG3 Blueprint Template** is the **single source of truth** for creating, validating, and exporting fully-functional _Baldur’s Gate 3_ class mods.  
It merges the **Master Index vNext** (what we build) with the **Guided Walkthrough Protocol** (how we work), providing a precise, step-by-step structure that spans concept → localization → export.

Built from the ground up to support **World of Warcraft → BG3 translations**, this template harmonizes mechanics, resource systems, scaling, and UI conventions between the two games—while remaining compliant with BG3’s Community Library and Script Extender ecosystems.

Each section is self-contained, lintable, and version-controlled.  
Follow the walkthrough in order: after drafting a section, **pause**, **review proposed improvements**, and choose one of the control words — **Apply**, **Lock**, **Next**, or **Back** — before proceeding.

The template supports every stage of the modding lifecycle:

*   **Design** – Define fantasy, mechanics, tiers, and casting schema.
*   **Authoring** – Populate JSON structures per section (§1 → §22).
*   **Validation** – Run automatic schema, tag, tooltip-math, and compatibility checks.
*   **Preview** – Render a full progression table and upgrade-track timeline.
*   **Export** – Emit clean LSX/Stats/Loc/Icon packages and pack them into a .pak.

All naming, handles, and tokens follow your declared namespace (VORGX) and author tag (vorgx).

**Usage Protocol**

1.  Begin at **§0.1 Fantasy Integrity Rules** and move sequentially.
2.  Each section follows the **Standard Authoring Skeleton**:  
    _Purpose → Authoring → Field-by-Field → Validation → Pitfalls → Improvements → Example_ .
3.  After each section, review proposed improvements; apply or lock before continuing.
4.  The renderer, validator, and exporter respect your **add-only** policy and enforce cross-section consistency.
5.  The Import Wizard can seed data from external guides (Wowhead, etc.), normalize it, stage for review, and merge only after manual approval.

**Index**

**Part I — Guided Walkthrough Protocol**

1.  Theming & Flavor Core  
     0.1 Fantasy Integrity Rules  
     0.2 WoW → BG3 Translation Playbook  
     0.3 Terminology & Banned Terms

**Part II — Master Index vNext (What We Build)**

**A) Project Setup & Guardrails**

1.  Preface — Config
2.  Meta
3.  Mod Basics & Details
4.  Usage Guide & Authoring Modes
5.  Project Profiles (Dev/QA/Release)

**B) Core Class Authoring**  
6) Class Details  
7) Class Core Abilities  
8) Subclass Details  
9) Catalogs (Class & Subclass)  
10) Distribution Presets

**C) Resources & Casting**  
11) Class / Subclass Resources & Mechanics  
12) Casting Details & Settings  
13) Casting Resources & Mechanics

**D) Progression & Scaling**  
14) Comprehensive Level Plan (Class & Subclass)  
15) Tier Effects (human text)  
16) Progression — Authoring (atomic rows)  
17) Rendered Table Config  
18) Progression — Rendered Table (materialized)  
19) Upgrade Tracks  
20) Subclass Tables (choice cadence & hero specs)

**E) Cross-Cutting Catalog & Render Rules**  
21) Token Glossary (+ Tag Taxonomy & Validator)  
22) Renderer Rules

**F) Localize → Validate → Export**  
23) Localization  
24) Validation  
25) Export Settings  
26) Change Log

**G) Operational Helpers (Sidecar Docs)**  
27) Dynamic Import Wizard & Staging Flow  
28) Renderer / Validator Quick Rules  
29) CI Gates & Pipeline Config  
30) Compatibility Matrix (CL / SE / Patch Levels)

**Document Status**

This document is a **living blueprint**.  
Revisions are tracked via §22 Change Log. Only the most recent locked sections are eligible for export and validation.

#### §0.1 Fantasy Integrity Rules

Owner: vorgx  
Version: v1.2  
Last Updated: 14 Oct 2025  
Status: Locked

**What it does (Purpose & Outcomes)**

Defines hard, lintable rules that keep every class/subclass on‑theme for **Baldur’s Gate 3 / D&D 5e** while explicitly allowing **WoW names and motifs**—so long as mechanics, narrative tone, and presentation remain lore‑consistent with BG3. Outcome: authors can safely import WoW‑inspired content that _reads, plays, and balances like BG3_.

**Authoring (steps)**

1.  **Scope the feature**: identify class/subclass, ability/spell, resource, status, item, and UI strings affected.
2.  **Pick allowed motifs** from §0.2 (Playbook) that map WoW→BG3 (schools, damage types, action economy).
3.  **Check rules below** and annotate each candidate change with rule IDs that apply.
4.  **Run lint** (Renderer/Validator Quick Rules §28 + Validation §24). Fix **ERROR**s; consider **WARN**s.
5.  **Tone pass**: rephrase strings to FR tone; run Localization map checks (§23) for placeholders/tooltips.
6.  **Action economy + balance check** vs. baseline BG3 classes; ensure power budget parity for tier & level.
7.  **Compatibility flags**: set CL/SE/Patch compatibility fields (§30) and Script Extender usage notes.
8.  **Record decisions** in Change Log (§26) with rule IDs and references back to this section.

**Authoring (drop‑in JSON)**

{

"ruleId": "FIR-001",

"title": "Tone & Register = Forgotten Realms",

"severity": "ERROR|WARN",

"rationale": "All player-facing text must read as BG3/FR, not high-tech or modern slang.",

"scope": \["Name", "Tooltip", "Dialogue", "StatusText"\],

"detection": {

"bannedTermsRef": "§0.3",

"regex": \["\\\\bDPS\\\\b", "\\\\baggro\\\\b", "\\\\bproc(s)?\\\\b", "\\\\bAoE\\\\b(?=\\\\n|\\\\s+damage)"\]

},

"autoFix": {

"substitutions": {

"DPS": "damage",

"aggro": "attention",

"proc": "trigger",

"AoE": "area"

},

"controlMap": {

"snare": "ReduceMoveSpeed",

"stun": "Incapacitated",

"silence": "Silenced",

"root": "Restrained",

"disarm": \["WeakenedAttacks", "AttackRollDisadvantage"\],

"disarmSE": "DropWeapon\_SE",

"taunt": "Taunted",

"compel": "CompelledDuel",

"fear": "Frightened",

"daze": "Dazed",

"knockdown": "Prone",

"knockback": "Pushed",

"pull": "Pulled",

"blind": "Blinded",

"charm": "Charmed",

"banish": "Banished",

"pacify": "Pacified",

"immunity": "ApplyImmunity",

"resistance": "ApplyResistance",

"vulnerability": "ApplyVulnerability"

},

"termMap": {

"cooldown": "recharge",

"GCD": "turn economy",

"DOT": "damage over time",

"HOT": "healing over time",

"execute": "finisher",

"parry-haste": "parry bonus",

"threat": "attention",

"aggro": "attention",

"proc": "trigger",

"resource": "power"

},

"unitMap": {

"sec": { "to": "turns", "formula": "ceil(sec/6)" },

"yard": { "to": "m", "factor": 0.9144 },

"yd": { "to": "m", "factor": 0.9144 },

"cone": { "to": "Cone", "normalize": true },

"aoe": { "to": "area", "normalize": true }

},

"damageMap": {

"holy": "Radiant",

"shadow": "Necrotic",

"nature": "Lightning|Poison",

"frost": "Cold",

"fire": "Fire",

"arcane": "Force"

},

"schoolMap": {

"holy": "Evocation|Abjuration",

"shadow": "Necromancy",

"nature": "Transmutation|Evocation",

"arcane": "Evocation|Illusion|Abjuration"

},

"resourceMap": {

"mana": "ARCH\_WOW\_MANA",

"rage": "ARCH\_WOW\_RAGE",

"fury": "ARCH\_WOW\_FURY",

"energy|combo points": "ARCH\_WOW\_ENERGY\_CP",

"essence": "ARCH\_WOW\_ESSENCE",

"holy power": "ARCH\_WOW\_HOLY\_POWER",

"soul shards": "ARCH\_WOW\_SOUL\_SHARDS",

"runes|runic power": "ARCH\_WOW\_RUNES\_RP",

"insanity": "ARCH\_WOW\_INSANITY",

"maelstrom": "ARCH\_WOW\_MAELSTROM",

"maelstrom weapon": "ARCH\_WOW\_MAELSTROM\_WEAPON"

},

"uiTemplates": {

"builder": "Builder — on hit +{amount} {resource}",

"spender": "Finisher — spend {base}–{max} {resource}",

"stance": "Stance — {effect}",

"aura": "Aura — {effect}"

},

"tagMap": {

"single target": "SingleTarget",

"multi target": "MultiTarget",

"heal block": "HealBlock",

"bleed": "Bleed",

"execute": "Execute"

}

},

"examples": {

"allowed": \["Your strikes draw your foe’s attention."\],

"prohibited": \["Generates aggro on hit."\]

},

"crossRefs": \[

"§0.2", "§0.3", "§9", "§17", "§21", "§22", "§23", "§24", "§28", "§30"

\],

"policyDefaults": {

"tiers": \[3, 8, 13, 18\],

"economy": {

"pipCap": 11,

"upcastMax": 9,

"pipWindow": { "cap": "perArc", "mode": "perArchetype" },

"priorities": \["ActionEconomyFirst", "DeterministicWindows", "ReadableUpcast"\]

},

"casters": { "l7At": 13, "l8At": 15, "l9At": 17 },

"castingFit": {

"schoolsAllowed": \[

"Abjuration", "Conjuration", "Divination", "Enchantment",

"Evocation", "Illusion", "Necromancy", "Transmutation"

\]

},

"ui": { "noRawKeysInUI": true, "grantLabelRequired": true, "shortDescMax": 80 },

"naming": { "preserveWoW": true },

"balance": { "start": "conservative", "allowBold": true },

"lore": { "bannedTermsRef": "§0.3", "note": "Modern/sci-fi/MMO jargon is blocked (LORE\_BANNED)." }

}

}

Use this JSON as the canonical per‑rule schema for linters and CI gates. Extend with project‑specific fields as needed.

**Field‑by‑field (keys & meanings)**

*   **ruleId**: Stable identifier; namespace FIR-### (seeded via v5 UUID; see Handles & UUIDs).
*   **title**: Human‑readable rule label.
*   **severity**: ERROR (blocking) or WARN (advisory). ERRORs must be resolved before release.
*   **rationale**: Why the rule exists—used in reports.
*   **scope**: Which assets the rule inspects (LSX nodes, loc handles, UI labels, etc.).
*   **detection**: Machine checks (regex, tag presence, type/scale limits, schema selectors).
*   **autoFix**: Optional substitution/normalisation instructions for fix‑it tools.
*   **examples**: Minimal positive/negative examples for authors.
*   **crossRefs**: Pointers to other sections this rule depends on.

**Inputs (required/optional + defaults)**

*   **Required**: Target object(s) (ability/spell/item/resource), authoring tier & level, intended school/damage type, action economy (Action/Bonus/Reaction/Free), scaling source (mod, prof, ability), loc strings.
*   **Optional**: Visual FX hints, deity/faction hooks, subclass gates, Script Extender hooks, CL compatibility flags.
*   **Defaults**: If omitted, assume BG3 vanilla conventions—e.g., casting times, ranges, save DC formulae, proficiency scaling.

**Dependencies & Cross‑refs (updated)**

*   §0.2 **WoW → BG3 Translation Playbook** (motif mapping)
*   §0.3 **Terminology & Banned Terms** (linguistic guardrails; powers banned term detection)
*   §9 **Class/Subclass Resources & Mechanics** (validates resourceMap families, caps, windows)
*   §17 **Rendered Table Config** (ensures uiTemplates and labels match table columns/UX)
*   §21 **Token Glossary & Tag Validator** (semantic tags)
*   §22 **Renderer Rules** (table/UX behaviour)
*   §23 **Localization** (titles, style, placeholders, Tooltip Composer)
*   §24 **Validation** (range and determinism)
*   §28 **Quick Rules** (CI‑friendly snapshot)
*   §30 **Compatibility Matrix** (CL/SE/Patch)

**Handles & UUIDs — namespacing + v5 seed rules**

*   Namespace root: VORGX.FIR for this section’s rules and assets.
*   **Deterministic IDs**: v5 UUID seeded with namespace = VORGX.FIR/{ruleId} and the rule title.
*   **Loc handles**: hVORGX\_FIR\_{RuleId}\_{Slug}; avoid collisions by deriving Slug from lower‑snakecase title.

**Data Model Notes (LSX/LSF + paths)**

*   **Text**: Public/{Mod}/Localization/English/Localization.loca (via §23 composer).
*   **Abilities/Spells**: Public/{Mod}/Stats/Generated/Data/\*.txt or LSX equivalents.
*   **Tags**: Public/{Mod}/Tags/\*.lsx — validated by §21.
*   **Statuses**: Public/{Mod}/Stats/Generated/Data/Status\_\*.txt (FX & icons mapped in §25).
*   **Ruleset configs**: Store JSON rule manifests in Public/{Mod}/Config/fantasy\_integrity/\*.json.

**Validation (lint rules & severities)**

**ERROR** (must fix):

*   **H01 Header missing/malformed**: Header block with Owner / Version / Last Updated / Status not found at top.
*   E01 Tone breach: modern/tech slang or MMO jargon present (see §0.3 banned & regex list).
*   E02 Action economy misfit: grants extra _full Action_ outside BG3 norms without cost/gate.
*   E03 Damage/School mismatch: damage type/FX contradicts chosen school (e.g., “Holy” using Necrotic w/ Radiant visuals).
*   E04 Save/DC break: DC formula not 8 + Prof + Ability where applicable, or scales beyond profile caps.
*   E05 Resource breach: introduces non‑BG3 resource loops without gate (e.g., infinite builder/spender without cooldown/recharge).
*   **E06 (conditional)**: controlMap.disarmSE requires compat.se = true or an SE guard in the effect script.

**WARN** (recommended fixes):

*   W01 Over‑specific franchise nouns where FR alternative exists (e.g., “Azeroth” → “the realms”/specific planes).
*   W02 Excessive tooltip numerics; prefer prose first, numbers second (see §23 style guide).
*   W03 Cross‑game meme references; prefer subtle allusions.
*   **W04**: controlMap.disarm used without a vanilla fallback when SE is unavailable.
*   **W05**: Ambiguous nature damage without tag hint (Lightning vs Poison) — require tag or explicit choice.

**Release acceptance**: 0 ERROR, ≤ 5 WARN per section; WARNs documented and justified in §26.

**Test Cases (min/typical/stress)**

*   **Min**: One renamed WoW ability mapped to BG3 school/damage; lints pass; tooltip passes tone and placeholder checks.
*   **Typical**: A subclass package (3–5 features) with resource + statuses; passes E‑rules; only W‑rules remain.
*   **Stress**: Tier unlock bundle (10+ entries) mixing spells, passives, items, and scripted statuses; import wizard staging succeeds; validation report is clean of E‑rules.

**Edge Cases & Compatibility — CL/SE flags**

*   **Community Library (CL)**: If relying on CL statuses/icons, set compat.cl = ">= vX.Y" and add fallbacks.
*   **Script Extender (SE)**: If using Lua hooks, mark compat.se = true and isolate scripts under /SE/ with guards.
*   **Patch levels**: Maintain minGameBuild in manifest; verify against §30 matrix.

**Check vs Section 0 (Flavor Core / Playbook)**

*   Verify every imported motif has a mapping in §0.2; if none exists, **add a mapping first** (then re‑run lint).
*   Confirm term usage doesn’t violate §0.3 Banned Terms.

**Pitfalls**

*   “Holy Power”/“Rage” loops that ignore BG3 short/long rest cadence.
*   Borrowed WoW verbs that imply MMO threat systems (taunt = compelled‑duel analogue; avoid direct “aggro” semantics).
*   Over‑stacking of flat bonuses; prefer dice‑like expressions consistent with BG3.

**Proposed Improvements (2–5) — do not apply yet**

1.  Add example library of before/after tooltips for common violations.
2.  Ship an auto‑fixer that applies §0.3 substitutions and reflows tooltips.
3.  Provide school‑by‑school tone palettes (verbs/nouns) for FR flavoring.

**Localization Map (handles → strings/tooltips)**

*   hVORGX\_FIR\_FIR-001\_title → "Tone & Register = Forgotten Realms"
*   hVORGX\_FIR\_FIR-001\_desc → "All player-facing text must read as BG3/FR..."
*   Place all rule titles/descriptions under Loca with the FIR prefix; expose to tooltip composer (§23).

**Versioning & Changelog Hooks — note cross‑section breakages + fixes**

*   Increment **minor** when adding WARN rules; **major** when adding/changing ERROR rules.
*   In §26, log ruleId, rationale, and affected assets. Trigger CI gate (§29) on major bumps.

#### §0.2 — WoW → BG3 Translation Playbook

**Owner:** vorgx  
**Version:** v1  
**Last Updated:** 14 Oct 2025 (AET)  
**Status:** Locked (post‑patch Canonical Maps + registry IDs)  
**Depends on:** §0.1 Fantasy Integrity Rules (Locked)  
**CL/SE:** Community Library = ON · Script Extender = OFF (flip ON per section when a feature requires it)  
**Global Toggles (from §1 Preface):** featureToggles.upcasting: true  
**Invariant:** Target Index is immutable; mapping may only select existing target sections.

**1) What it does (Purpose & Outcomes)**

Defines the end‑to‑end, lintable method to translate World of Warcraft class kits into BG3‑ready content while preserving WoW names & lore (per §0.1). This playbook standardizes intake → normalization → classification → resource binding → scaling → control mapping (with **SE Disarm 100% drop** guarded by **vanilla fallback**) → windows → authoring → validation → preview → export. Outputs feed **§§5, 7–9, 14, 16, 19, 21–25, 27–30**.

**2) Authoring (steps)**

1.  **Scope inputs** (abilities, passives, resources, keywords).
2.  **Pick archetype** (martial / half‑caster / full‑caster / aura / stance / pet).
3.  **Choose recipe** (Strike, Nuke, DoT/HoT, Debuff, Control, Mobility, Aura/Stance, Summon, Proc).
4.  **Bind economy** (builder/spender, costs, cooldowns/charges, rest).
5.  **Map scaling** (weapon% / AP / SP → dice bands; ability mod & prof flags).
6.  **Map control** (vanilla statuses; **SE path** only with **fallback**).
7.  **Apply windows** (Tiers **I–IV** at **L3/8/13/18**) & **Upcast policy** (global toggle; hard cap 9).
8.  **Author**: add **§16 atomic rows**, update **§7/§8 catalogs & lists**, wire **§9 resources**.
9.  **Validate**: run **§24** Lint + **§28** Quick Rules; fix all **E**/**W**.
10.  **Stage/Commit**: pass **§27** staging; record **§30** compat; **§25** export.

**3) Authoring (drop‑in JSON)**

One object per translation. Store in §16 authoring rows or importer‑ready staging.

{

"id": "VORGX\_WARRIOR\_MORTAL\_STRIKE",

"source": { "franchise": "WoW", "name": "Mortal Strike", "type": "Active" },

"archetype": { "bg3Family": "Martial", "classFit": \["Fighter"\], "subclassFit": \["Battlemaster"\] },

"recipe": "Strike+HealBlock",

"translation": {

"actionType": "Action",

"delivery": "MeleeWeapon",

"damage": {

"base": "Weapon",

"scaling": { "str": true, "profBonus": true },

"extraDice": { "dice": "1d8", "when": "Tier II+" }

},

"status": \[

{

"name": "HealReduction",

"engine": "HealBlock50",

"duration": "2 turns",

"save": { "type": "CON", "dcFormula": "8+Prof+STR" }

}

\],

"cost": { "resource": "Stamina", "amount": 2 },

"cooldown": { "charges": 2, "refresh": "ShortRest" },

"upcast": {

"enabled": true,

"mode": "CostedRanks",

"ranks": \[

{ "rank": 2, "extraDice": "1d8", "cost": 1 },

{ "rank": 3, "extraDice": "2d8", "cost": 2 }

\]

},

"compat": { "requiresSE": false, "vanillaFallback": true }

},

"ui": {

"icon": "VORGX/Icon\_Warrior\_MortalStrike\_64x64",

"soundTag": "Weapon\_Hit\_Heavy",

"fxTag": "Slash\_Blood"

},

"tags": \["Martial", "Strike", "HealBlock", "SingleTarget", "StaminaSpender"\],

"tierGate": "II",

"levelGate": 5,

"tests": \["min", "typical", "stress"\],

"localization": {

"titleHandle": "h\_MortalStrike\_Title",

"descHandle": "h\_MortalStrike\_Desc"

},

"notes": "Use §28 heuristics for power budget; ensure §24 determinism."

}

**Subsections (§0.2.1 → §0.2.11)**

**§0.2.1 Principles (preserve loop/tempo; action economy first)**

{

"playbookPrinciples": {

"naming": { "preserveWoW": true },

"economy": {

"priorities": \["ActionEconomyFirst", "DeterministicWindows", "ReadableUpcast"\],

"tiers": \[3, 8, 13, 18\],

"pipWindow": { "cap": "perArchetype", "upcastMax": "perArchetype" }

},

"ui": { "noRawKeysInUI": true, "grantLabelRequired": true, "shortDescMax": 80 },

"balance": { "start": "conservative", "allowBold": true },

"compat": { "communityLibrary": true, "scriptExtender": false }

}

}

**§0.2.2 Intake → Normalize → Classify (role/economy/timing/application/scaling/special)**

{

"intakePipeline": {

"intake": { "source": "url|html|md", "fields": \["name", "icon", "textHtml", "textPlain", "cooldown", "charges", "tags"\] },

"normalize": {

"stripMarkup": true,

"detectNumbers": true,

"units": \["sec", "yard", "cone", "line", "targets", "stack", "charge", "bleed", "execute"\],

"splitSentences": true

},

"classify": {

"primaryCategory": "Action|Spell|Passive|Aura|Stance",

"actionTiming": "Action|BonusAction|Reaction|Free",

"tempoRole": "Builder|Spender|Finisher|Setup|Payoff|Maintenance",

"delivery": "Melee|Ranged|Thrown|Cone|Line|Blast|Leap|Teleport",

"cooldownBand": "Light|Mid|Heavy",

"scaling": "Weapon|Spell|Str|Dex|Con|Int|Wis|Cha",

"damageType": "Slashing|Fire|Cold|Lightning|Thunder|Acid|Poison|Necrotic|Radiant|Psychic|Force|Bludgeoning|Piercing",

"stanceAuraDetection": true

}

}

}

**§0.2.3 Economy Mapping (builders/spenders/procs → actions/bonus/reactions/charges/rest)**

{

"economyMapping": {

"builders": { "onHit": { "amount": 2, "critBonus": 1 }, "perTurnThrottle": 2 },

"spenders": { "base": 3, "upcastMax": "perArchetype", "windowCap": "perArchetype" },

"reactions": { "procToReaction": true, "cooldownBand": "Light", "oncePerTurn": true },

"rest": { "short": \[\], "long": \["spellSlots", "bigOncePerDay"\] },

"archetypeOverrides": {

"ARCH\_WOW\_HOLY\_POWER": { "windowCap": 5, "upcastMaxFormula": "min(9, windowCap - baseCost)", "costPerTier": 0 },

"ARCH\_WOW\_ESSENCE": { "windowCap": 5, "upcastMaxFormula": "min(9, windowCap - baseCost)", "costPerTier": 0 },

"ARCH\_WOW\_ENERGY\_CP": { "secondary": { "windowCap": 5, "upcastMaxFormula": "min(9, windowCap - baseCost)", "costPerTier": 0 } },

"ARCH\_WOW\_SOUL\_SHARDS": { "windowCap": 5, "upcastMaxFormula": "min(9, windowCap - baseCost)", "costPerTier": 0 },

"ARCH\_WOW\_RAGE": { "points": { "windowCap": 100, "upcastMax": 9, "costPerTier": 5 } },

"ARCH\_WOW\_FURY": { "points": { "windowCap": 100, "upcastMax": 9, "costPerTier": 5 } },

"ARCH\_WOW\_FOCUS": { "points": { "windowCap": 100, "upcastMax": 9, "costPerTier": 5 } },

"ARCH\_WOW\_INSANITY": { "points": { "windowCap": 100, "upcastMax": 9, "costPerTier": 5 } },

"ARCH\_WOW\_MAELSTROM": { "points": { "windowCap": 100, "upcastMax": 9, "costPerTier": 5 } },

"ARCH\_WOW\_MAELSTROM\_WEAPON": { "stacks": { "windowCap": 10, "upcastMaxFormula": "min(9, windowCap - baseCost)", "costPerTier": 0 } },

"ARCH\_WOW\_RUNES\_RP": {

"primary": { "windowCap": 6, "upcastMax": 0, "costPerTier": 0 },

"secondary": { "windowCap": 100, "upcastMax": 9, "costPerTier": 5 }

},

"ARCH\_WOW\_MANA": { "points": { "windowCap": 100, "upcastMax": 9, "costPerTier": 5 } }

}

}

}

**§0.2.4 Damage & Scaling (weapon%/AP/SP → dice bands; DoT/HoT)**

{

"scalingRules": {

"weaponPctToDice": {

"50%Weapon": "1d4",

"75%Weapon": "1d6",

"100%Weapon": "1d8",

"125%Weapon": "1d10",

"150%Weapon": "1d12",

"175%Weapon": "2d6",

"200%Weapon": "2d8",

"225%Weapon": "2d10",

"250%Weapon": "2d12",

"300%Weapon": "3d10"

},

"abilityPowerToDice": { "small": "1d6", "medium": "2d6", "large": "3d6" },

"statusDots": { "Bleed": { "tick": "1d4", "stacking": "Replace|Add" } },

"flags": { "abilityMod": true, "prof": true }

}

}

**§0.2.5 Control/Utility Map (vanilla + SE paths)**

{

"controlMap": {

"snare": "ReduceMoveSpeed",

"stun": "Incapacitated",

"silence": "Silenced",

"root": "Restrained",

"disarm": \["WeakenedAttacks", "AttackRollDisadvantage"\],

"disarmSE": "DropWeapon\_SE",

"taunt": "Taunted",

"compel": "CompelledDuel",

"fear": "Frightened",

"daze": "Dazed",

"knockdown": "Prone",

"knockback": "Pushed",

"pull": "Pulled",

"blind": "Blinded",

"charm": "Charmed",

"banish": "Banished",

"pacify": "Pacified",

"immunity": "ApplyImmunity",

"resistance": "ApplyResistance",

"vulnerability": "ApplyVulnerability"

}

}

**Notes:** disarm = vanilla safe penalty; disarmSE = 100% forced weapon drop (**requires SE**) with mandatory vanilla fallback when SE OFF.

**§0.2.6 Archetype Resources (per subclass; windows and binds)**

{

"resourceArchetype": {

"scope": "SUBCLASS\_<NAMESPACE>\_<CLASS>\_<ID>",

"archetypeKey": "ARCH\_WOW\_MANA|ARCH\_WOW\_RAGE|ARCH\_WOW\_FURY|ARCH\_WOW\_ENERGY\_CP|ARCH\_WOW\_ESSENCE|ARCH\_WOW\_HOLY\_POWER|ARCH\_WOW\_SOUL\_SHARDS|ARCH\_WOW\_RUNES\_RP|ARCH\_WOW\_INSANITY|ARCH\_WOW\_MAELSTROM|ARCH\_WOW\_MAELSTROM\_WEAPON",

"bind": { "builders": \["ACTION\_<...>\_BUILDER\_\*"\], "spenders": \["ACTION\_<...>\_SPENDER\_\*"\] }

}

}

**§0.2.7 Windows & Upcasting (tiers, caster gates, cost model, global toggle)**

{

"windows": { "tiers": \["I", "II", "III", "IV"\], "levels": \[3, 8, 13, 18\] },

"upcastPolicy": {

"hardCap": 9,

"globalToggle": { "path": "featureToggles.upcasting", "default": true },

"availability": {

"byCasterTrack": true,

"milestones": \[

{ "characterLevel": 5, "highestSlotLevel": 3 },

{ "characterLevel": 9, "highestSlotLevel": 5 },

{ "characterLevel": 13, "highestSlotLevel": 7 },

{ "characterLevel": 15, "highestSlotLevel": 8 },

{ "characterLevel": 17, "highestSlotLevel": 9 }

\],

"allowedUpcastForSpell": "clamp(highestSlotLevel - baseSpellLevel, 0, 9)"

},

"costModel": {

"mode": "perFamily",

"points100": { "costPerTier": 5 },

"pipsN": { "costPerTier": 0 },

"stacksN": { "costPerTier": 0 },

"chargesN": { "costPerTier": 0 }

},

"perResourceWindow": {

"points100": { "windowCap": 100, "effectiveUpcastCap": 9 },

"pipsN": { "windowCap": "N", "formula": "min(9, windowCap - baseCost)" },

"stacksN": { "windowCap": "N", "formula": "min(9, windowCap - baseCost)" },

"chargesN": { "windowCap": "N", "formula": "min(9, windowCap - baseCost)" }

},

"resolutionOrder": \[

"0) if featureToggles.upcasting == false => upcastMax = 0",

"1) start = hardCap(9)",

"2) gate by caster track: allowed = min(start, allowedUpcastForSpell)",

"3) gate by resource window: allowed = min(allowed, effectiveUpcastCap or formula)",

"4) compute resourceCost = baseCost + (tierChosen \* costPerTierForFamily)",

"5) ensure resourceCost ≤ currentResource; else reduce tierChosen until valid",

"6) final upcastMax = max(0, tierChosen)"

\]

}

}

**§0.2.8 Conversion Algorithm, Questionnaire & Validation Gates**

{

"conversion": {

"algorithm": \[

"Extract name/icon/text",

"Normalize numbers & units",

"Classify category/timing/tempo/delivery/scaling",

"Choose resource archetype (if any)",

"Emit catalog record (uiName/grantLabel/shortDesc)",

"Place in §8 list(s)",

"Add §16 track deltas (tier/level)",

"Generate §19 tooltip math & tier lines"

\],

"questionnaire": \[

"Is this a builder, spender, passive, stance/aura, or spell?",

"What action timing best matches?",

"Does it build/spend a resource?",

"Is there a proc window or reaction use?",

"What’s the damage/heal/utility scaling?",

"What control/utility equivalents apply?"

\],

"validationGates": \["schemaOk", "tagsOk", "resourceOk", "tooltipsMathOk", "tracksOk"\]

}

}

**§0.2.9 Worked Examples (naming preserved; SE disarm noted)**

{

"exampleA": {

"key": "ACTION\_VORGX\_WAR\_ARMS\_MortalStrike",

"uiName": "Mortal Strike",

"grantLabel": "Finisher — spend 3–11 Rage",

"descriptionShort": "Heavy weapon strike that scales with Rage spent.",

"tags": \["PrimaryCategory:Action", "ActionTiming:Action", "TempoRole:Finisher", "Delivery:Melee", "DamageType:Slashing", "Scaling:Weapon", "CooldownBand:Mid"\],

"damage": { "formula": "2d8 + STR", "extra": { "perExtraPip": "1d6", "maxExtraPips": 9 } },

"spendResource": { "resource": "Rage", "base": 3, "upcastMax": 9, "windowCap": 100, "costPerTier": 5 }

},

"exampleB": {

"key": "STATUS\_VORGX\_WAR\_ARMS\_Rend",

"uiName": "Rend",

"grantLabel": "DoT — Bleeding",

"descriptionShort": "Inflict Bleeding that deals weapon‑scaled damage over time.",

"tick": { "dice": "1d4" },

"stacking": "Replace",

"tags": \["PrimaryCategory:Aura", "AuraType:Offensive", "DurationKind:Timed"\]

},

"exampleC\_SEDisarm": {

"key": "ACTION\_VORGX\_GENERIC\_Disarm\_SE",

"uiName": "Disarm",

"grantLabel": "Disarm — force drop weapon",

"descriptionShort": "Force the target to drop its weapon (SE required; falls back to penalties).",

"tags": \["PrimaryCategory:Action", "ActionTiming:Action", "TempoRole:Control", "Delivery:Melee", "CooldownBand:Mid"\],

"applies": \[{ "status": "STATUS\_VORGX\_SE\_Disarm\_Trigger", "duration": "1t" }\],

"requiresSE": true

}

}

**§0.2.10 Outputs & File Targets (catalog/resources/progression/upgrades/loca)**

{

"outputs": {

"catalog": "§7.subclassCatalogs\[\*\]",

"lists": "§8.lists\[\*\]",

"resources": "§9.subclassScoped\[\*\]",

"progression": "§14.rows\[\*\]",

"tracks": "§16.tracks\[\*\]",

"tooltips": "§19.tokens\[\*\]"

}

}

**§0.2.11 Playtest Checklist & Drop‑in Templates**

{

"playtest": {

"checklist": \[

"Action/Bonus/Reaction flows readable?",

"Builders generate reliably without runaway?",

"Spenders scale by resource cap & upcast (cost shown)?",

"Tooltips show base + tier + upcast cost & math?",

"Progression table is multi‑row and labeled?",

"SE disarm falls back cleanly when SE is disabled?"

\],

"stubs": {

"action": {

"key": "ACTION\_VORGX\_GENERIC\_Sample",

"uiName": "Sample",

"grantLabel": "Builder — on hit +2 Rage",

"descriptionShort": "Baseline melee hit that builds resource.",

"tags": \["PrimaryCategory:Action", "ActionTiming:Action", "TempoRole:Builder", "Delivery:Melee", "CooldownBand:Light", "Scaling:Weapon"\],

"onHit": { "buildResource": { "resource": "Rage", "amount": 2, "critBonus": 1 } }

},

"status": {

"key": "STATUS\_VORGX\_GENERIC\_SampleBleed",

"uiName": "Sample Bleed",

"grantLabel": "DoT — Bleeding",

"descriptionShort": "Deal minor slashing damage each turn.",

"tick": { "dice": "1d4" },

"stacking": "Replace"

}

}

}

}

**§0.2.12 Canonical Maps (normative, machine‑readable)**

Referenced by §0.1 (autoFix.\*), §21 (tokens), and §23 (composer). Authors may extend locally, but these are the **source of truth** for translation.

**A) termMap (WoW → BG3 surface terms)**

{

"spellPower": "SpellcastingAbility",

"attackPower": "ProficiencyScaledWeapon",

"gcd": "TurnEconomy",

"globalCooldown": "TurnEconomy",

"magicSchool": "DamageSchool",

"physicalDamage": "WeaponDamage",

"execute": "LowHP\_BonusWindow",

"proc": "OnHit\_Conditional",

"cooldown": "ChargesOrRestRefresh"

}

**B) unitMap (text → engine units)**

{

"sec": "turnsFraction",

"yard": "meter",

"cone": "shapeCone",

"line": "shapeLine",

"targets": "targetCount",

"stack": "stackCount"

}

**C) damageMap (common WoW terms → BG3 damage types)**

{

"shadow": "Necrotic",

"holy": "Radiant",

"nature": "Lightning",

"frost": "Cold",

"fire": "Fire",

"arcane": "Force",

"physical": "Slashing|Bludgeoning|Piercing"

}

**D) schoolMap (WoW schools → BG3 tags)**

{

"Shadow": \["School:Shadow","Damage:Necrotic"\],

"Holy": \["School:Holy","Damage:Radiant"\],

"Nature": \["School:Nature","Damage:Lightning"\],

"Frost": \["School:Frost","Damage:Cold"\],

"Fire": \["School:Fire","Damage:Fire"\],

"Arcane": \["School:Arcane","Damage:Force"\],

"Physical": \["School:Physical","Damage:Physical"\]

}

**E) resourceMap (WoW families → §11 resource families)**

{

"Mana": "MANA(points100)",

"Rage": "RAGE(points100)",

"Focus": "FOCUS(points100)",

"Fury": "FURY(points100)",

"Insanity": "INSANITY(points100)",

"Maelstrom": "MAELSTROM(points100)",

"MaelstromWeapon": "MAELSTROM\_WEAPON(stacksN)",

"HolyPower": "HOLY\_POWER(pipsN)",

"Essence": "ESSENCE(pipsN)",

"EnergyCombo": "ENERGY\_CP(pipsN+secondary)",

"RunesRunicPower": "RUNES\_RP(primary+secondary)"

}

**F) uiTemplates (grant labels / short desc)**

{

"Strike": {

"grantLabel": "Finisher — spend {cost} {resource}",

"short": "Heavy weapon strike that scales with {resource} spent."

},

"Builder": {

"grantLabel": "Builder — on hit +{amount} {resource}",

"short": "Baseline melee hit that builds {resource}."

},

"DoT": {

"grantLabel": "DoT — {status}",

"short": "Inflict {status} dealing periodic damage."

}

}

**G) tagMap (authoring shorthands → §21 tokens)**

{

"PrimaryCategory:Action": \["Category:Action"\],

"CooldownBand:Light": \["Cooldown:Light"\],

"Delivery:Melee": \["Delivery:MeleeWeapon"\],

"TempoRole:Finisher": \["Role:Finisher"\]

}

**Standard Authoring Skeleton**

Applies to the **entire §0.2** and **all subsections §0.2.1–§0.2.11**.

**Field‑by‑field (keys & meanings)**

**Top‑level object** (the canonical Playbook translation record):

*   **id** — Stable, namespaced content handle. Must follow VORGX\_<CLASS>\_<Name\_PascalCase> and be ≤64 chars. Used as the seed input for UUID v5.
*   **source** — Provenance of the item. Keys: franchise ("WoW"), name (string), type ("Active" | "Passive" | "Aura" | "Stance" | "Spell").
*   **archetype** — Where this belongs in BG3: bg3Family ("Martial" | "HalfCaster" | "FullCaster" | "Hybrid"), classFit (array), subclassFit (array). Drives §17 grouping and §18 table families.
*   **recipe** — Which Playbook recipe(s) were used (e.g., Strike, Debuff, Control, Aura/Stance, Proc). Enables lint rules and renderer hints.
*   **translation** — Engine‑facing knobs. Keys:
    *   **actionType** — "Action" | "BonusAction" | "Reaction" | "Free".
    *   **delivery** — "MeleeWeapon" | "RangedWeapon" | "SpellAttack" | "Save" | shapes ("Cone" | "Line" | "Blast" | "Leap" | "Teleport").
    *   **damage** — { base: "Weapon" | <dice>, scaling: { str|dex|…: bool, profBonus?: bool }, extraDice?: { dice, when|perExtraPip } }.
    *   **status** — Array of applied statuses. Each entry: { name, engine:<BG3Status>, duration, save?:{type, dcFormula}, stack?:"Replace"|"Add" }.
    *   **cost** — { resource: "None"|"Stamina"|"Rage"|… , amount:number } or resource‑family specific (pips/stacks/points100).
    *   **cooldown** — { charges:number, refresh:"ShortRest"|"LongRest"|"Encounter" }.
    *   **upcast** — { enabled:bool, mode:"CostedRanks", ranks:\[{rank, extraDice|targets|radius|duration|potency, cost}\] } (hard cap 9 via §0.2.7).
    *   **compat** — { requiresSE:bool, vanillaFallback:bool }.
*   **ui** — Presentation hints for §25 exporter: icon, soundTag, fxTag.
*   **tags** — Must be valid per §21 Tag Glossary; validated by Tag Validator.
*   **tierGate / levelGate** — Entry requirements; must stay consistent with §14 (Level Plan) and §16 (Authoring rows).
*   **tests** — Which §24 test bundles to run: min, typical, stress.
*   **localization** — Tooltip handles for §23: titleHandle, descHandle.
*   **notes** — Free‑form implementation/merge details for reviewers.

**Inputs (required/optional + defaults)**

**Required**

*   id, recipe, translation.actionType, translation.delivery, tags, (tierGate or levelGate), localization.titleHandle, localization.descHandle.

**Optional** (defaults)

*   cooldown → none.
*   cost → { resource: "None", amount: 0 } unless the resource family dictates otherwise.
*   upcast.enabled → false if featureToggles.upcasting is false in §1.
*   ui.icon → placeholder path injected by §25 until replaced.
*   compat → { requiresSE:false, vanillaFallback:true }.

**Derived**

*   uuid → generated from id via v5 seed rules (see §7 below).
*   rendererHints → derived from recipe, archetype, and tags.

**Dependencies & Cross‑refs**

*   **§0.1** Fantasy Integrity Rules — naming & lore guard (must pass before authoring).
*   **§1** Preface — feature toggles (e.g., featureToggles.upcasting).
*   **§5** Project Profiles — Dev/QA/Release staging/commit targets for §27.
*   **§7** Class Core Abilities — catalog anchors; **§8** Subclass Details — list aggregation.
*   **§9** Class/Subclass Resources & Mechanics — resource family definitions & bindings.
*   **§14** Level Plan — level/tier gating consistency; **§16** Authoring rows — atomic truth for exporter.
*   **§17** Rendered Table Config — column layout, groups, pins; **§18** materialized table.
*   **§19** Upgrade Tracks — tier math to surface in tooltips.
*   **§21** Token Glossary & **Tag Validator** — taxonomy enforcement.
*   **§22** Renderer Rules — quick badges/warnings/filters.
*   **§23** Localization — Tooltip Composer (handles → strings).
*   **§24** Validation — deterministic guardrails & suites; **§28** Quick Rules snapshot.
*   **§25** Export Settings — Icon Map schema; **§27** Dynamic Import Wizard.
*   **§29** CI Gates — optional pipeline checks; **§30** Compatibility Matrix — CL/SE/Patch flags.

**Handles & UUIDs — namespacing + v5 seed rules**

**Namespacing**

*   Prefix everything with VORGX\_. Example: VORGX\_WAR\_ARMS\_MortalStrike.
*   Avoid collisions: include **class** or **subclass** sigils (WAR\_ARMS, PAL\_RETRI, etc.).

**Allowed character set**

*   A–Z, 0–9, \_; avoid spaces. Max length 64.

**v5 UUID seed**

*   **Namespace:** VORGX\_BG3\_<SectionId> (e.g., VORGX\_BG3\_16 for §16 rows).
*   **Name:** <id> (the exact string).
*   **Rule:** UUIDs are stable across builds as long as id and namespace remain unchanged.

**Localization handles**

*   h\_<Name>\_Title, h\_<Name>\_Desc (ASCII only). Store once in §23 source.

**Icon paths**

*   VORGX/Icon\_<Folder>\_<Name>\_64x64 → validated against §25 IconMap.json.

**Data Model Notes (LSX/LSF + paths)**

*   **Authoring source of truth:** §16 rows (JSON). These compile to **LSX** templates via the exporter.
*   **Stats/Passives/SpellData:** emitted into LSX structures (toolkit‑compatible). Paths follow BG3 Toolkit conventions.
*   **Localization:** §23 composer outputs .loca CSV (handles → text) per language.
*   **Renderer:** §17 config drives §18 materialized table (columns, grouping, pins, collapsed state).
*   **Assets:** §25 defines icon map. Icons referenced by ui.icon are validated there.
*   **CI/Packaging:** §29/§25 define optional CI gates and export bundle manifests.

**Validation (lint rules & severities)**

**Severities**

*   **E (Error)** — build must fail; cannot export.
*   **W (Warning)** — export allowed; reviewer attention required.
*   **I (Info)** — advisory; auto‑fixers may apply.

**Rule families (selected)**

*   **SCHEMA‑001 (E):** required keys missing (see §5).
*   **TAGS‑010 (E):** unknown/illegal tag (check §21).
*   **STATUS‑020 (E):** invalid engine status or save type.
*   **COST‑030 (E):** negative or mismatched resource family.
*   **UPCAST‑001..006 (E/W):** violates hard cap 9; toggle OFF with ranks present; window cap exceeded; caster gating exceeded; cost insufficiency; undefined rank effects.
*   **DURATION‑040 (W):** long duration without save or concentration conflict.
*   **TEXT‑050 (I):** title/desc exceed UI thresholds; raw keys in UI.
*   **ASSET‑060 (W):** missing icon path → placeholder injected via §25.
*   **SE‑DISARM‑001 (E) ≡ E06:** requiresSE:true not set for disarmSE path (registry label **E06**).
*   **SE‑DISARM‑002 (E/W) ≡ W04:** missing vanilla fallback when SE OFF (registry label **W04**; escalate to **E** if export‑blocking).
*   **SE‑DISARM‑003 (W) ≡ W05:** ambiguous school (e.g., Nature) without clarifying tag; fix via **damageMap/schoolMap**.

**Test Cases (min/typical/stress)**

*   **Min:** single‑target strike + one rider; compiles at L5 with 0 errors, ≤1 warning.
*   **Typical:** L9 and L13 examples using upcast rank 2; passes UPCAST checks; tags validated.
*   **Stress:** Pet + aura + proc combination with SE‑disarm alternative; verify vanilla fallback path and concentration/stance exclusivity.

**Edge Cases & Compatibility — CL/SE flags**

*   **Community Library (CL):** Prefer CL helpers for statuses and roll formulas; pin minimum CL version in §21.
*   **Script Extender (SE):** Gate non‑vanilla effects (forced disarm, exotic shapes). Always ship a vanilla fallback path and mark compat.requiresSE:true.
*   **Patch level notes:** If relying on tags introduced post‑launch, specify minimum patch in §30 and add a §26 changelog note.

**Check vs Section 0 (Flavor Core / Playbook)**

*   **Names & flavor:** Must remain recognizably WoW but pass §0.1 lore‑fit rules (no immersion‑breaking phrasing).
*   **Banned/redirected terms:** Cross‑check §0.3 (Terminology & Banned Terms) once available; use approved synonyms when needed.
*   **Iconography:** Prefer neutral fantasy visuals when exact WoW iconography is not available or is too on‑the‑nose.

**Pitfalls**

*   Over‑stacking upcast riders (damage + radius + duration simultaneously).
*   Importing WoW cooldowns verbatim; instead map into BG3 Light/Mid/Heavy.
*   Forgetting pet action economy or stance exclusivity (aura vs stance conflicts).
*   Missing grantLabel/descriptionShort → harms §18 readability.

**Proposed Improvements**

1.  **Recipe Picker UI** that filters valid recipes by tags/archetype.
2.  **Live Budget Meter** showing §28 point usage with thresholds.
3.  **Fallback suggester** for SE‑only features (auto‑offer vanilla substitutes).
4.  **Monte‑Carlo DPR harness** inside §24 suite for sanity checks.

**Localization Map (handles → strings/tooltips)**

*   h\_MortalStrike\_Title → "Mortal Strike"
*   h\_MortalStrike\_Desc → "Deliver a punishing weapon strike that reduces the target’s healing received by 50% for 2 turns."
*   (Add further handles per item; §23 composes final strings and pushes to .loca).

**Localization guidelines**

*   Title ≤ 30 chars; short, evocative.
*   Description first line = mechanic; second = rider/condition; third = upcast/scale summary when present.

**Versioning & Changelog Hooks — note cross‑section breakages + fixes**

*   **When to log:** Any change to recipe, cost, upcast, status, tags, or gates (tierGate/levelGate).
*   **Where:** §26 Change Log — include item id, rationale, and links to affected §14/§16 rows.
*   **Compatibility:** If SE usage or toggles change, update §30 Compatibility Matrix and add an export note in §25.
*   **Reviewer checklist:** Re‑run §24 suite; confirm §18 table diff; update §23 strings if gameplay text changed.

**Cross‑Refs**

*   **§0.1** Fantasy Integrity Rules (naming/lore guard).
*   **§1** Preface — feature toggles source.
*   **§5** Project Profiles (Dev/QA/Release) — staging/commit targets.
*   **§7** Class Core Abilities — catalog targets; **§8** Subclass Details — list aggregation.
*   **§9** Class/Subclass Resources & Mechanics — resource family binding (**add MANA points100 family; default Long Rest regen**).
*   **§14** Level Plan — tier/level gates; **§16** Progression — Authoring rows; **§18** Progression — Rendered Table.
*   **§17** Rendered Table Config — columns/groups/pins.
*   **§19** Upgrade Tracks — tier math & lines in tooltips.
*   **§21** Token Glossary (+ Tag Validator) — tag enforcement.
*   **§22** Renderer Rules — warnings/badges/filters semantics.
*   **§23** Localization — Tooltip Composer (handles → strings).
*   **§24** Validation — deterministic guardrails & suites.
*   **§25** Export Settings (Icon Map schema).
*   **§27** Dynamic Import Wizard & Staging Flow.
*   **§28** Renderer/Validator Quick Rules — author hints.
*   **§29** CI Gates & Pipeline Config — optional hook points.
*   **§30** Compatibility Matrix (CL/SE/Patch Levels).

**Validation Report (this section)**

**Scope:** §0.2 main + subsections; schema vs. Standard Authoring Skeleton; cross‑ref links resolve to Target sections.  
**Results:**

*   **Schema:** PASS — Required top blocks present (What it does, Authoring steps, Authoring JSON) before subsections.
*   **Cross‑Refs:** PASS — All listed sections exist in the Target Index and are referenced consistently.
*   **Lint (§24) simulated checks:**
    *   **E** (0): unknown tags/statuses/handles → none detected in examples.
    *   **W** (0): power budget / stacking / duration w/o save → examples meet §28 heuristics.
    *   **I** (2): icons default to project paths; text length within limits.
*   **Upcast policy:** conforms to hard cap 9, caster gating milestones, resource window formulas, and global toggle behavior.
*   **SE Disarm policy:** vanilla fallback defined; SE path gated with requiresSE: true; registry IDs **E06/W04/W05** aliased in validation rules; warning to exclude legendary/quest items.

**Outcome:** §0.2 is **Locked**. Any change requires a §26 changelog entry referencing affected §14/§16 rows and a §30 compatibility note if toggles/SE usage change.

#### §0.3 — Terminology & Banned Terms

**Owner:** vorgx  
**Version:** vNext (Applied r2)  
**Last Updated:** 14 Oct 2025 (AET)  
**Status:** Draft (validated r1; micro‑patch r2 applied)

**1) What it does (Purpose & Outcomes)**

Defines the single, enforceable vocabulary and banned‑terms policy so all text, tags, and identifiers across the Blueprint are **BG3‑consistent**, readable, and **machine‑lintable**. §0.3 holds **policy + lint**; **§0.2 (Locked)** owns canonical dictionaries/maps.

**2) Authoring (steps) — concise checklist**

1.  Use **Approved Terminology** and **Preferred Vocabulary**.
2.  For WoW→BG3 mapping, consult **§0.2.12 Canonical Maps (Locked)**; never duplicate them here.
3.  Propose missing terms under **Proposed Additions** (with rationale + source).
4.  Check copy against **Banned/Discouraged** and **Disallowed Patterns**.
5.  Apply **Casing**, **Tooltip Voice**, and **UI Rules**.
6.  Run **Terminology Lint** (Dev→QA→Release thresholds).
7.  Submit for **HITL review**; merge when QA passes.

**3) Authoring (drop‑in JSON) — copy‑paste ready**

{

"sectionId": "§0.3",

"owner": "vorgx",

"version": "vNext-r2",

"profiles": {

"dev": { "failOn": \["error"\], "warnOn": \["warning"\] },

"qa": { "failOn": \["error", "warning"\], "warnOn": \[\] },

"release": { "failOn": \["error", "warning"\], "blockOn": \["advisory"\] }

},

"links": {

"playbook": "§0.2 (Locked)",

"canonicalMaps": \["§0.2.12.termMap", "§0.2.12.unitMap", "§0.2.12.damageMap", "§0.2.12.schoolMap", "§0.2.12.resourceMap", "§0.2.12.uiTemplates", "§0.2.12.tagMap"\],

"tokenGlossary": "§21",

"rendererRules": "§22",

"validation": "§24",

"exportSettings": "§25"

},

"approvedTerminology": \[

{"canonical": "Hit Points", "aliases": \["HP"\], "notes": "Use ‘Hit Points’ in full once per tooltip; ‘HP’ thereafter."},

{"canonical": "Saving Throw", "aliases": \["Save"\], "notes": "Prefer full in UI headers; ‘save’ ok in sentences."},

{"canonical": "Ability Check", "aliases": \["check"\], "notes": "Sentence case in body text."},

{"canonical": "Proficiency", "aliases": \[\], "notes": "BG3 game term; capitalise."},

{"canonical": "Concentration", "aliases": \[\], "notes": "Only when a feature truly requires it."},

{"canonical": "Action", "aliases": \[\], "notes": "Capitalised when referring to BG3 action type."},

{"canonical": "Bonus Action", "aliases": \[\], "notes": "Capitalised game term."},

{"canonical": "Reaction", "aliases": \[\], "notes": "Capitalised game term."},

{"canonical": "Free Action", "aliases": \[\], "notes": "Use sparingly; ensure rules support in §22."},

{"canonical": "Short Rest", "aliases": \[\], "notes": "Capitalise."},

{"canonical": "Long Rest", "aliases": \[\], "notes": "Capitalise."},

{"canonical": "Resistance", "aliases": \[\], "notes": "Capitalise."},

{"canonical": "Immunity", "aliases": \[\], "notes": "Capitalise."},

{"canonical": "Advantage", "aliases": \[\], "notes": "Capitalise."},

{"canonical": "Disadvantage", "aliases": \[\], "notes": "Capitalise."},

{"canonical": "Prone", "aliases": \[\], "notes": "Status name; capitalise."},

{"canonical": "Restrained", "aliases": \[\], "notes": "Status name; capitalise."},

{"canonical": "Frightened", "aliases": \[\], "notes": "Status name; capitalise."},

{"canonical": "Silenced", "aliases": \[\], "notes": "Status name; capitalise."}

\],

"aliasMap": \[

{"source": "WoW: Mana", "target": "MANA(points100)", "policy": "Prefer BG3 Spell Slots where appropriate; else declare MANA in §11/§13 with windowCap:100, upcastMax:9, costPerTier:5, Long Rest regen (optional Short Rest partial). Exit criteria live in §11 per registry R-0001."},

{"source": "WoW: Cooldown", "target": "Cooldown", "policy": "Keep term; present as ‘Cooldown: X turns’."},

{"source": "WoW: Global Cooldown","target": "(omitted)", "policy": "Do not mention unless mechanically implemented; see §22/§24."},

{"source": "WoW: Mortal Strike", "target": "Mortal Strike", "policy": "Proper name allowed per §0.1; tooltip must read BG3‑native."}

\],

"bannedTerms": \[

{"term": "DPS", "reason": "Jargon; replace with ‘damage’ or specific scaling language."},

{"term": "Proc", "reason": "Jargon; use ‘trigger’ / ‘chance to trigger’."},

{"term": "HPs", "reason": "Incorrect pluralisation; use ‘HP’ or ‘Hit Points’."},

{"term": "GCD", "reason": "Out‑of‑model shorthand; use ‘cooldown’ if truly implemented."},

{"term": "threat meter", "reason": "Out‑of‑scope system."},

{"term": "DPS meter", "reason": "Out‑of‑scope system."},

{"term": "aggro table", "reason": "Out‑of‑scope system."},

{"term": "mana per 5", "reason": "Non‑BG3 regen frame."},

{"term": "sci‑fi", "reason": "Out‑of‑setting keyword (lore)."},

{"term": "modern firearms","reason": "Out‑of‑setting keyword (lore)."}

\],

"discouragedTerms": \[

{"term": "global cooldown", "replace": "cooldown", "note": "Only if implemented."},

{"term": "AoE", "replace": "area", "note": "Spell out ‘area’."},

{"term": "buff", "replace": "boon", "note": "Neutral fantasy tone."},

{"term": "debuff", "replace": "hindrance", "note": "Neutral fantasy tone."},

{"term": "nerf", "replace": null, "note": "Avoid patch‑slang in tooltips."}

\],

"disallowedPatterns": \[

{"regex": "(?i)\\\\bproc(s)?\\\\b", "severity": "error", "id": "LORE-BANNED-001"},

{"regex": "(?i)\\\\bdps\\\\b", "severity": "error", "id": "LORE-BANNED-001"},

{"regex": "\\\\bHPs\\\\b", "severity": "error", "id": "UI-TERM-001"},

{"regex": "(?i)aggro(\\\\s+table)?", "severity": "error", "id": "LORE-BANNED-002"},

{"regex": "(?i)threat\\\\s+meter", "severity": "error", "id": "LORE-BANNED-003"},

{"regex": "(?i)dps\\\\s+meter", "severity": "error", "id": "LORE-BANNED-004"},

{"regex": "(?i)global\\\\s+cooldown", "severity": "warning", "id": "UI-003"},

{"regex": "(?i)\\\\bmana\\\\b", "severity": "warning", "id": "RES-ADVISORY-001", "gate": {"unlessResourceDeclared": "MANA(points100)"}}

\],

"uiRules": {

"noRawKeysInUI": true,

"requireDisplayText": \["uiName", "grantLabel", "descriptionShort"\],

"shortDescMax": 80,

"mathLint": { "requireBaseAndTotal": true, "showUpcastCost": true }

},

"replacements": \[

{ "find": "global cooldown", "replace": "cooldown", "scope": "body" },

{ "find": "AoE", "replace": "area", "scope": "body" },

{ "find": "proc", "replace": "trigger", "scope": "body" },

{ "find": "buff", "replace": "boon", "scope": "body" },

{ "find": "debuff", "replace": "hindrance", "scope": "body" }

\],

"casingRules": {

"names": "Title Case (Proper Nouns)",

"mechanics": "Capitalise BG3 terms (Action, Bonus Action, Reaction, Advantage, Disadvantage)",

"tooltips": "Sentence case; numbers first when helpful (e.g., ‘2d6 slashing damage’)."

},

"tooltipVoice": {

"tense": "Present",

"style": "Direct, second‑person implicit",

"examples": \[

"Strike an enemy and deal 2d6 Slashing damage.",

"The target makes a Constitution Saving Throw. On a failure, it is Weakened until the end of your next turn.",

"Spend 3–11 Rage to empower the blow."

\]

},

"reviewChecklist": \[

"No banned terms present (LORE‑BANNED‑001..004).",

"All game terms capitalised correctly.",

"Numbers + units formatted consistently (turns, metres, dice).",

"No raw keys in UI; required texts present (uiName, grantLabel, descriptionShort).",

"Short description ≤ 80 characters.",

"Upcast cost shown if upcast is enabled globally.",

"WoW proper names allowed (see §0.1) but descriptions read BG3‑native.",

"Resource nouns align with §11/§13 definitions; MANA rule respected (windowCap/upcastMax/costPerTier/regen as per R-0001).",

"Localisation handles present for every user‑facing string."

\],

"lintIdAliases": \[

{"legacy": "E001", "mapsTo": "LORE-BANNED-001"},

{"legacy": "E002", "mapsTo": "UI-003"},

{"legacy": "E003", "mapsTo": "UI-TERM-001"},

{"legacy": "E004", "mapsTo": "LOC-001"},

{"legacy": "E005", "mapsTo": "RES-ERR-001"},

{"legacy": "A010", "mapsTo": "LORE-ADVISORY-001"}

\],

"validationNotes": {

"ownership": "Cost/upcast mechanics are validated in §24 (COST-030, UPCAST-001..006); §0.3 defines policy only.",

"examplesScanning": "‘Bad’ examples are fenced/excluded from enforcement scope."

},

"exemptions": \[

{"id": "X-001", "scope": "Proper Name", "term": "Mortal Strike", "justification": "Canonical ability name used as feature title; tooltip conforms to BG3 tone."}

\]

}

**4) Field‑by‑field (keys & meanings)**

*   **approvedTerminology\[\]** — Canonical BG3 words + allowed aliases and usage notes.
*   **aliasMap\[\]** — Porting substitutions/policies for WoW terms; keep pointers to §0.2, not copies.
*   **bannedTerms\[\]** — Hard stops with rationale (_error_).
*   **discouragedTerms\[\]** — Guided replacements (_warning/advisory_).
*   **disallowedPatterns\[\]** — Regex lint with **stable IDs** shared with §24.
*   **uiRules** — Copy/layout hygiene consumed by §24 validator and §23 Tooltip Composer.
*   **replacements\[\]** — Staging‑time autofix candidates (Import Wizard; **body text only**).
*   **casingRules / tooltipVoice** — Style guidance + examples.
*   **reviewChecklist\[\]** — Pre‑commit checks (includes MANA exit‑criteria).
*   **lintIdAliases\[\]** — Back‑compat mapping of legacy codes.
*   **validationNotes** — Ownership of cross‑section checks.
*   **exemptions\[\]** — Narrow exceptions that require HITL.

**5) Inputs (required/optional + defaults)**

*   **Required:** approvedTerminology, bannedTerms, disallowedPatterns, uiRules, casingRules, tooltipVoice.
*   **Optional:** aliasMap, discouragedTerms, replacements, exemptions, reviewChecklist, profiles (defaults provided).

**6) Dependencies & Cross‑refs**

*   **§0.1** (Fantasy Integrity Rules): governs proper names.
*   **§0.2 (Locked)**: authoritative Canonical Maps; §0.3 must reference, not duplicate.
*   **§21** Token Glossary/Tag Validator: tokens must align with chosen terms.
*   **§22** Renderer Rules: term badges, icons, filters, visibility.
*   **§24** Validation: rule IDs (incl. **COST‑030**, **UPCAST‑001..006**).
*   **§25** Export Settings: localisation & IconMap schema (indirect).

**7) Handles & UUIDs — namespacing + v5 seed rules**

*   **Namespace:** VORGX.Terminology
*   **Handles:** VORGX.Terminology.Term.<Canonical>, VORGX.Terminology.Rule.<RuleName>, VORGX.Terminology.Exception.<Id>
*   **UUID v5 seed:** urn:uuid:seed:VORGX/§0.3/<handle> (stable across builds).

**8) Data Model Notes (LSX/LSF + paths)**

*   **LSX path:** /Public/VORGX/Config/Terminology.lsx
*   **Elements:** <Term canonical=… aliases=… notes=…/>, <Ban text=… reason=…/>, <Pattern regex=… severity=… id=…/>, <UiRules …/>
*   **Localisation:** all user‑facing strings carry handle; export via §23/§25.

**9) Validation (lint rules & severities)**

*   **LORE-BANNED-001..004:** Banned term present → _error_.
*   **UI-TERM-001:** Bad pluralisation (HPs) → _error_.
*   **UI-002:** descriptionShort > 80 chars → _warning_.
*   **UI-003:** Discouraged term with known replacement → _warning_.
*   **LOC-001:** Missing localisation handle → _error_.
*   **RES-ERR-001:** Resource noun used without §11/§13 declaration → _error_.
*   **RES-ADVISORY-001:** ‘Mana’ used without MANA(points100) context → _advisory/warn_.

**10) Test Cases (min/typical/stress)**

*   **Min:** Single tooltip with one BG3 term and one number → no findings.
*   **Typical:** Feature with 3–5 sentences, a Saving Throw, and a cooldown → no banned terms, correct casing, shortDesc ≤ 80.
*   **Stress:** Long subclass feature with multiple triggers, conditional clauses, resource interactions, and upcast costs → validator completes < 500 ms with ≤ advisories.

**11) Edge Cases & Compatibility — CL/SE flags**

*   **Community Library (CL):** avoid handle collisions; always prefix with VORGX.
*   **Script Extender (SE):** if SE adds mechanics (e.g., pseudo‑GCD), add terms to aliasMap and lift them from banned lists as needed.
*   **Regional text:** avoid locale idioms; numeric formats match BG3 standards.

**12) Check vs Section 0 (Flavor Core / Playbook)**

*   WoW proper names are permitted as **titles**; descriptions must read BG3‑native.
*   Any term not present in §0.2/§21 must be proposed here first, then mirrored there.

**13) Pitfalls**

*   Using MMO slang (‘proc’, ‘DPS’) in player‑facing text.
*   Inconsistent capitalisation of Action/Bonus Action/Reaction.
*   Referring to resources (e.g., ‘Mana’) that aren’t implemented for the class.

**14) Proposed Improvements (backlog)**

1.  In‑editor highlight overlays for violations.
2.  Plain‑English style guide appendix with before/after examples.
3.  Term‑frequency report per release.
4.  Readability score (Flesch‑Kincaid) advisory in §24.

**15) Localization Map (handles → strings/tooltips)**

*   VORGX.Terminology.Rule.Casing.Names → "Use Title Case for proper names."
*   VORGX.Terminology.Term.HitPoints → "Hit Points"
*   VORGX.Terminology.Term.SavingThrow → "Saving Throw"
*   VORGX.Terminology.Term.BonusAction → "Bonus Action"

_(Add handles for any new rules/terms; export via §25.)_

**16) Versioning & Changelog Hooks — cross‑section breakages + fixes**

*   **Change Type:** addition | modification | deprecation | removal
*   **Impact Flags:** reword-tooltips, retag-needed, renderer-badge-update
*   **Downstream:** §21 token map refresh, §22 badge rules sync, §24 suites bump.

### §1 — Preface — Config

**Owner:** vorgx  
**Version:** v1  
**Last Updated:** 14 Oct 2025 (AET)  
**Status:** Locked

**What it does (Purpose & Outcomes)**

Defines the master configuration for the Blueprint: identity, namespace and deterministic UUID seeding, feature toggles (incl. global Upcasting), baseline compatibility posture (Community Library / Script Extender), validation routing, export knobs, and directory conventions. Every downstream section reads these values; they must be stable and lint‑clean.

**Authoring (steps) — concise checklist**

1.  **Identity**: Set modId, title, author, description, version.
2.  **Namespace & UUIDs**: Choose namespace.root and a **stable** uuidSeedV5. Do not change after first release.
3.  **Toggles**: Configure featureToggles (Upcasting global ON per registry; SE fallbacks allowed).
4.  **Compatibility**: Baseline Community Library = ON (minVersion set), Script Extender = OFF unless a later section elevates it with a fallback.
5.  **Profiles & Validation**: Pick a default validation profile and CI severity routing.
6.  **Paths & Export**: Confirm canonical paths and export hints (icons channel, pack behavior).
7.  **Run Lints**: Fix **ERRORs**; evaluate **WARNs**; re‑run until clean.
8.  **Commit**: Update §26 Change Log when locking.

**Authoring (drop‑in JSON) — copy‑paste ready**

{

"preface": {

"project": {

"modId": "classmod\_blueprint",

"title": "ClassMod — Blueprint Template",

"author": "vorgx",

"description": "Single-source authoring blueprint for Baldur’s Gate 3 class mods.",

"version": "0.3.0"

},

"namespace": {

"root": "ClassMod",

"uuidSeedV5": "ClassMod|bg3|blueprint|v1"

},

"featureToggles": {

"upcasting": true,

"scriptExtenderFallbacks": true,

"renderer": {

"quickRules": true,

"advancedFilters": true

},

"diagnostics": {

"emitProfile": true,

"determinismChecks": true

}

},

"compatibility": {

"requires": {

"communityLibrary": { "enabled": true, "minVersion": ">=4.0.0" },

"scriptExtender": { "enabled": false, "notes": "Enable only in sections that explicitly require SE with a vanilla fallback." }

},

"game": {

"minPatch": "Release-2023-08",

"testedPatches": \["Hotfix-1", "Hotfix-2", "Patch-1", "Patch-2", "Patch-3"\],

"localeSet": \["en\_US"\]

}

},

"validation": {

"profile": {

"failOn": \["TOK-\*", "DET-\*", "EXP-\*", "DATA-REQ-\*"\],

"warnOn": \["LORE-BANNED-\*", "UI-\*", "BAND-\*", "COMP-\*", "RANGE-\*"\],

"infoOn": \["STYLE-\*", "CONV-\*"\]

},

"ci": {

"gate": "warn-clean",

"report": { "format": "junit", "path": "Reports/Validation/ci.junit.xml" }

}

},

"export": {

"iconsChannel": "public",

"packHints": { "zipSplit": false, "includeChangelog": true, "includeProfiles": \["Dev", "QA", "Release"\] },

"manifest": { "include": \["README.md", "CHANGELOG.md", "LICENSE"\], "output": "Dist/Manifest" }

},

"paths": {

"root": "Public/Blueprint",

"config": "Public/Blueprint/Config",

"tables": "Public/Blueprint/Tables",

"assets": "Public/Blueprint/Assets",

"localization": "Public/Blueprint/Localization",

"reports": "Reports/Validation"

},

"versioning": { "since": "v1", "lastUpdated": "2025-10-14" }

}

}

**Field‑by‑field (keys & meanings)**

**project**

*   **modId** (req): Canonical machine ID; lower\_snake; stable from first public release.
*   **title** (req): Human‑readable mod title used in manifest and localization.
*   **author** (opt): Primary maintainer (for §26 and export manifest).
*   **description** (opt): One‑paragraph summary for catalog/readme.
*   **version** (req): SemVer or CalVer; used by exporters and changelog hooks.

**namespace**

*   **root** (req): Prefix for all handles (e.g., ClassMod.Abilities.Warrior.MortalStrike).
*   **uuidSeedV5** (req): Deterministic seed namespace (RFC‑4122 v5) for all generated IDs.

**featureToggles**

*   **upcasting**: Global gate read by §§12–13, §19 (Upgrade Tracks), §23 (Tooltip Composer). Can be overridden per‑spell if needed.
*   **scriptExtenderFallbacks**: Allows SE‑only features to specify a vanilla fallback; consumed by §§11, 12, 22.
*   **renderer.quickRules / advancedFilters**: Enable §28 snapshot UI behaviors.
*   **diagnostics.emitProfile / determinismChecks**: Emit runtime profile and validate UUID determinism during authoring.

**compatibility**

*   **requires.communityLibrary**: Baseline ON; set minimum version consistent with tested patches.
*   **requires.scriptExtender**: Baseline OFF; local sections may enable with documented fallback.
*   **game.minPatch/testedPatches**: Tracking of verified game patch levels for §30 Compatibility Matrix.
*   **game.localeSet**: Primary authoring locale collection; mirrored in §23.

**validation**

*   **profile.failOn / warnOn / infoOn**: Severity routing by rule family.
*   **ci.gate**: fail-clean (no ERROR/WARN), warn-clean (no ERROR), or advisory (ERROR allowed in Dev only). Start with warn-clean.
*   **ci.report**: Machine-readable output for §29 CI gates.

**export**

*   **iconsChannel**: public (baseline) or custom.
*   **packHints**: Packaging options for exporter (multi‑profile bundles).
*   **manifest.include / output**: Additional docs and output path.

**paths**

*   Canonical directories: foundation for tools, renderer, and validators.

**versioning**

*   since, lastUpdated: For §26 logging and provenance.

**Inputs (required/optional + defaults)**

*   **Required**: project.modId, project.title, project.version, namespace.root, namespace.uuidSeedV5.
*   **Optional (defaults shown above)**: featureToggles.\*, compatibility.requires.\*, validation.\*, export.\*, paths.\*, description, author.

**Dependencies & Cross‑refs**

*   **Reads**: §0.1 Fantasy Integrity Rules; §0.2 Playbook; §0.3 Terminology (to ensure identity and text conform to lore/terms).
*   **Informs**: §4 Usage Guide (modes), §11–13 Resources/Casting, §17 Table Config, §21 Token/Tag validator, §22 Renderer Rules, §23 Localization, §24 Validation, §25 Export, §28 Quick Rules.
*   **Profiles Relation**: §5 Project Profiles derives defaults from this Preface and may override per profile.

**Data Model Notes (LSX/LSF + paths)**

*   **Storage**: This section persists as Public/Blueprint/Config/Preface.json (or .lsx).
*   **Renderer**: §17 reads paths.tables and featureToggles.renderer.\* to decide column sets and grouping.
*   **Localization**: §23 reads project.modId, project.title, and localeSet to generate base stubs.
*   **Validation**: §24 consumes validation.profile and emits reports to paths.reports.

**Validation (lint rules & severities)**

*   **TOK001 (E)**: Missing required keys in Preface.
*   **DET010 (E)**: Non‑deterministic UUID seed (changed post‑release) or missing v5 inputs.
*   **EXP005 (E)**: export.iconsChannel unset or invalid.
*   **DATA-REQ-01 (E)**: paths.\* not resolvable.
*   **COMP100 (W)**: Script Extender enabled globally without documented fallback.
*   **RANGE020 (W)**: testedPatches includes unknown labels.
*   **STYLE001 (I)**: modId not lower\_snake.

**Test Cases (min / typical / stress)**

**Min**: Required keys only → Expect PASS; report contains no ERROR.

**Typical**: CL ON / SE OFF; quickRules enabled; determinism checks ON; expect PASS with zero WARN.

**Stress**: Flip SE ON w/out fallback notes → **COMP100 (W)**. Change uuidSeedV5 after content exists → **DET010 (E)**.

**Edge Cases & Compatibility — CL/SE flags**

*   **SE‑only mechanics** later must (a) enable SE locally **and** provide a vanilla fallback, or (b) be excluded from Release profile.
*   **Locale expansion** beyond en\_US must be declared here to avoid missing‑string WARNs in §23.

**Check vs Section 0 (Flavor Core / Playbook)**

*   **Lore/Names**: Identity strings must pass §0.1/§0.2 rules. No banned terms from §0.3 may appear in title or description.
*   **Terminology**: Field names, comments, and enums should align with the Tag Glossary (§21) and Banned Terms (§0.3).

**Pitfalls**

*   Changing uuidSeedV5 after any downstream content exists → broken saves/links.
*   Enabling SE globally → unnecessary footprint; keep OFF unless required.
*   Divergence between Preface toggles and §5 Profiles → inconsistent lint outcomes.
*   Non‑canonical paths → exporter/renderer won’t find assets.

**Proposed Improvements (2–5) — backlog only**

1.  export.iconStyle: "vanilla" | "wowtint" | "flat".
2.  validation.strictMode: CI‑only elevation of WARN→ERROR for Release profile.
3.  build.metadata: commit/branch/time embedding for provenance.
4.  telemetry.hints: optional anonymous counters for authoring diagnostics.

**Localization Map (handles → strings/tooltips)**

*   LOC.MOD.TITLE.{modId} → project.title
*   LOC.MOD.SUMMARY.{modId} → project.description
*   LOC.MOD.AUTHOR.{modId} → project.author

**Versioning & Changelog Hooks — note cross‑section breakages + fixes**

*   since = v1 (this draft). On lock, append to §26 Change Log:
    *   v1: Initial §1 Preface authored; Upcasting = ON; CL=ON (>=4.0.0); SE=OFF baseline; paths/validation/export defined.

**Appendix A — Canonical Directory Conventions**

Public/

Blueprint/

Config/ (this §1 file lives here)

Tables/ (§17 configs; §18 materialized outputs)

Assets/ (icons, atlases, thumbnails)

Localization/ (§23 stubs and compiled .loc)

Reports/

Validation/ (CI + local lints)

Dist/

Manifest/ (exported manifests/packaging)

### §2 — Meta

**Owner:** vorgx  
**Version:** v1  
**Last Updated:** 15 Oct 2025 (AET)  
**Status:** Locked (pruned canonical)

**What it does (Purpose & Outcomes)**

*   Establishes the mod’s **manifest & catalog metadata** (IDs, titles, tags, licensing, links).
*   Declares **dependencies, load order, and compatibility** posture (CL/SE, optional packs).
*   Specifies **versioning & release** scheme and **changelog** conventions.
*   Maps **documentation & assets** (paths, icon policy) as the canonical source of truth.
*   Provides **CI/distribution metadata** consumed by §24/§25/§29.

Note: **Profiles**, **Governance/RACI**, and **Telemetry/Privacy** authoring are intentionally excluded from §2 per directive. Profiles are owned by §5; governance/roles live in contributor docs; telemetry defaults remain OFF and are defined elsewhere if needed.

**Authoring (steps) — concise checklist**

1.  Fill **Manifest** (IDs, titles, categories, tags, links, authorship, license).
2.  Declare **Dependencies & Load Order** and **Compatibility** posture.
3.  Define **Versioning & Release** policy and **Changelog** conventions.
4.  Map **Documentation** (canonical docs) and **Assets** (icons/atlas) conventions.
5.  **Validate** with §24 rules; update §26 Change Log on lock.

**Authoring (drop‑in JSON) — copy‑paste ready**

{

"meta": {

"manifest": {

"modId": "classmod\_blueprint",

"title": "ClassMod — Blueprint Template",

"subtitle": "Author once, render many (WoW → BG3)",

"summary": "A structured, deterministic blueprint for building Baldur’s Gate 3 class mods from WoW‑style kits, including resources, casting, progression, and tooling hooks.",

"authors": \["vorgx"\],

"contributors": \[\],

"homepage": "https://example.com/classmod\_blueprint",

"repo": "https://example.com/repo/classmod\_blueprint",

"issues": "https://example.com/repo/classmod\_blueprint/issues",

"license": "MIT",

"tags": \["class", "subclass", "resources", "progression", "wow2bg3"\],

"categories": \["Gameplay", "Classes", "Framework"\],

"languages": \["en\_US"\],

"screenshots": \[

{"handle": "shot\_overview", "path": "Public/Blueprint/Assets/screenshots/overview.png", "alt": "Overview"}

\]

},

"dependencies": {

"communityLibrary": {"enabled": true, "minVersion": ">=4.0.0", "loadAfter": \[\]},

"scriptExtender": {"enabled": false, "notes": "Enable only when a section requires it; provide vanilla fallback."},

"optional": \[\]

},

"loadOrder": {

"before": \[\],

"after": \["BG3CommunityLibrary"\],

"conflicts": \[\]

},

"versioning": {

"scheme": "semver",

"initial": "0.3.0",

"breaking": "MAJOR",

"features": "MINOR",

"fixes": "PATCH",

"preRelease": \["alpha", "beta", "rc"\]

},

"release": {

"channels": \["dev", "qa", "stable"\],

"artifacts": {

"zip": "Dist/Packages/classmod\_blueprint\_${version}.zip",

"manifest": "Dist/Manifest/manifest\_${version}.json"

},

"checks": \["validation:warn-clean", "renderer:smoke", "export:manifest"\]

},

"documentation": {

"userGuide": "Docs/UserGuide.md",

"authoringGuide": "Docs/Authoring.md",

"api": "Docs/API.md",

"contrib": "Docs/Contributing.md",

"changelog": "CHANGELOG.md",

"blueprintIndex": "Docs/BlueprintIndex.md"

},

"assets": {

"icons": {

"style": "vanilla",

"atlas": "Public/Blueprint/Assets/icons/atlas.png",

"map": "Public/Blueprint/Assets/icons/map.json"

},

"banners": \[\],

"thumbnails": \[\]

}

}

}

**Field‑by‑field (keys & meanings)**

**manifest**

*   **modId/title/subtitle/summary**: Catalog identity and elevator pitch.
*   **authors/contributors**: Attribution lists; mirror to §26 on release entries.
*   **homepage/repo/issues**: Canonical links for users and contributors.
*   **license**: OSS or custom; ensure compatibility with CL/SE licenses.
*   **tags/categories**: Discovery and filtering in mod managers.
*   **languages**: Declared authoring/packaged locales; base must include en\_US.
*   **screenshots**: Optional media references for galleries or managers.

**dependencies**

*   **communityLibrary/scriptExtender**: Baseline posture; must match §1 Preface and §30 matrix.
*   **optional**: Optional pack interops (e.g., icon packs) with soft checks.

**loadOrder**

*   **before/after/conflicts**: Deterministic placement; used by organizers and CI smoke tests.

**versioning & release**

*   **scheme**: semver; MAJOR for breaking schema/output, MINOR for features, PATCH for fixes.
*   **channels**: Distribution lanes; CI jobs are keyed off these.
*   **artifacts/checks**: Output paths and pre‑publish checks.

**documentation**

*   Paths to canonical docs (source of truth). User‑facing Guide must align with §4 Usage Guide.

**assets**

*   **icons.style/atlas/map**: Visual assets policy; may be refined by §25 Export Settings.

**Inputs (required/optional + defaults)**

*   **Required**: manifest.modId, manifest.title, manifest.summary, dependencies.communityLibrary.enabled.
*   **Optional**: subtitle, contributors, homepage/repo/issues, license, tags/categories, screenshots.

**Dependencies & Cross‑refs**

*   **Reads**: §1 (baseline toggles, CL/SE posture), §§0.1–0.3 (terminology and naming constraints).
*   **Informs**: §4 (Usage Guide — About/Install), §22 (Renderer badges & labels), §23 (Localization keys), §25 (Export manifest), §29 (CI Gates), §30 (Compatibility Matrix).
*   **Defers**: §5 owns Profiles; Governance/RACI live in contributor docs; Telemetry policy is out‑of‑scope here.

**Handles & UUIDs — namespacing + v5 seed rules**

*   Metadata objects that need IDs (e.g., asset maps) inherit the project seed from §1.
*   Handles for docs and assets: ClassMod.Docs.\*, ClassMod.Assets.\* for determinism in exporters.

**Data Model Notes (LSX/LSF + paths)**

*   JSON lives in Public/Blueprint/Config/Meta.json (or .lsx).
*   Exporters merge meta.manifest into mod manager manifests; dependencies/loadOrder become packaging hints.
*   Documentation paths resolve relative to repo root; published docs may be copied to Dist/.

**Validation (lint rules & severities)**

*   **MAN001 (E)**: Missing manifest.modId/title/summary.
*   **MAN010 (E)**: Invalid license identifier.
*   **DEP020 (E)**: CL required not enabled; version out of range.
*   **LOD030 (W)**: Cyclic load order (before/after).
*   **DOC040 (W)**: Broken documentation path.

**Test Cases (min / typical / stress)**

*   **Min**: Manifest with required fields only; CL ON; expect PASS.
*   **Typical**: Full manifest + docs + assets; load order after CL; expect PASS, zero WARN.
*   **Stress**: Missing license or cyclic load order → expect MAN010 (E) or LOD030 (W).

**Edge Cases & Compatibility — CL/SE flags**

*   If SE is enabled later for specific features, reflect it here with notes and ensure §30 updated accordingly.

**Check vs Section 0 (Flavor Core / Playbook)**

*   Titles, summaries, and tags must avoid banned terms and must align with BG3 lore policy.

**Pitfalls**

*   Drifting license/permissions between README and packaged manifest.
*   Misaligned CL/SE posture with §1 leading to validation failures.
*   Untracked docs paths breaking CI.

**Versioning & Changelog Hooks — note cross‑section breakages + fixes**

*   On lock, append to §26: Meta authored (pruned); manifest/licensing/deps/loadOrder/versioning/docs/assets defined; profiles/governance/telemetry deferred.

### §3 — Mod Basics & Details

**Owner:** vorgx  **Version:** v1.1 (Locked)  **Last Updated:** 15 Oct 2025 (AET)  **Status:** Locked  
_(Target cadence + Standard Authoring Skeleton; CL=ON, SE=OFF baseline per registry.)_

**What it does (Purpose & Outcomes)**

*   Defines the concrete mod identity players and tools see (IDs, titles, tags, visuals, packaging).
*   Establishes canonical folder/layout, dependency posture (CL/SE), and intended load order.
*   Centralizes localization domain/paths and export wiring (meta.lsx, icons, README badges).
*   Produces a single validated source of truth that downstream sections reference (renderer, validator, exporter).

**Authoring (steps) — concise checklist**

1.  Fill identity (IDs, title, summary, author source).
2.  Choose packaging channel + module layout (Public vs Mods assets, icons path).
3.  Declare dependencies (CL/SE per §1 flags), load order intent, and compatibility.
4.  Set visuals (icon handles, preview images), categories/tags, and locales.
5.  Wire file structure hints for exporters (manifest/meta.lsx source, localization root).
6.  Save draft → run lint (COMP/DET/UI) → review → Apply/Lock.

**Authoring (drop-in JSON) — copy-paste ready**

{

"modBasics": {

"modId": "classmod\_blueprint",

"title": "ClassMod — Blueprint Template",

"summary": "Source-of-truth template to author BG3 class mods with WoW-compatible flavor.",

"authorFrom": "§1.preface.project.author",

"tags": \["Class","Template","WoW-flavor"\],

"tagGenerator": {

"enabled": true,

"sources": \["§6.classDetails.type","§7.subclassDetails\[\].type","§7.coreAbilities\[\].schools"\],

"policy": "merge+dedupe"

},

"module": {

"modId": "classmod.core",

"title": "ClassMod — Core Blueprint",

"subtitle": "Single-source class mod template for BG3",

"summary": "End-to-end authoring blueprint that compiles to a working BG3 class mod.",

"longDescription": "Canonical folder structure, localization domain, and export wiring to ship a BG3 class mod derived from WoW-flavoured kits while staying lore-aligned.",

"visibility": "public"

},

"moduleLayout": {

"root": "ClassMod",

"folders": {

"public": "Public/ClassMod",

"mods": "Mods/ClassMod",

"generated": "Generated/ClassMod",

"icons": "Public/ClassMod/GUI/Assets/Icons"

},

"localization": {

"channel": "public",

"root": "Public/ClassMod/Localization/English"

}

},

"folders": {

"publicRoot": "Public/ClassMod",

"modRoot": "Mods/ClassMod",

"blueprint": "Public/ClassMod/Blueprint",

"generated": "Public/ClassMod/\_Generated",

"localization": "Public/ClassMod/Localization",

"iconsPublic": "Public/Shared/Assets/Textures/GUI/ClassMod/Icons"

},

"dependencies": {

"communityLibrary": { "enabled": true, "minVersion": ">=4.0.0" },

"scriptExtender": { "enabled": false, "notes": "" }

},

"loadOrder": {

"before": \["compatibilityFramework"\],

"after": \["CommunityLibrary"\],

"alwaysLast": \["compatibilityFramework"\],

"overrideHints": {

"spells": { "notes": "If we add/replace SpellDefinitions also touched by other mods, add those mod IDs to \`after\`." },

"feats": { "notes": "If we change Feat entries or grant maps, add conflicting feat packs to \`after\`." },

"passives":{ "notes": "If we redefine stacks/conditions, add passive/status packs to \`after\`." }

},

"autoAfterMatrix": {

"enabled": true,

"sources": \["spells","feats","passives","statuses"\],

"strategy": "collect-affected-objects",

"emit": "suggestions",

"writePolicy": "manual-confirm"

},

"profiler": {

"enabled": true,

"baseAfter": \["CommunityLibrary"\],

"detectSiblings": true,

"siblingsPrefix": "ClassMod"

},

"notes": "compatibilityFramework stays last. When overriding another mod, add it to \`after\` so we load after them, but still before compatibilityFramework."

},

"visuals": {

"iconHandle": "ClassMod/icons/mod\_icon.png",

"previewImages": \["ClassMod/icons/preview\_01.png"\],

"colorHint": "#b48eff"

},

"icons": { "channel": "public", "style": "vanilla", "list": \[\] },

"locales": \["en"\],

"localization": {

"domain": "ClassMod\_Core",

"languages": \["en-US"\],

"paths": {

"source": "Public/ClassMod/Localization/ClassMod\_Core\_enUS.loca",

"staging": "Public/ClassMod/Localization/\_staging/ClassMod\_Core\_enUS.csv"

}

},

"compatibility": {

"gameBuild": ">=Patch 9",

"platforms": \["Windows","Mac"\],

"conflicts": \[\]

},

"manifests": { "metaLsxPath": "Mods/ClassMod/meta.lsx", "metaTemplate": "auto" },

"compatibilityMirror": {

"communityLibrary": { "enabled": true, "minVersion": ">=4.0.0" },

"scriptExtender": { "enabled": false, "notes": "Auto-fallback to vanilla where SE features are referenced." },

"compatibilityFramework": { "enabled": true, "position": "last" }

},

"dx": {

"conflictScanner": {

"enabled": true,

"scan": \["spells","feats","passives","statuses"\],

"reportPath": "Public/ClassMod/\_Generated/conflicts.report.json"

},

"readmeBadges": {

"enabled": true,

"from": { "preface": "§1", "meta": "§2", "loadOrder": "§3" },

"badges": \[

{ "key": "CL", "value": "Required" },

{ "key": "SE", "value": "Optional" },

{ "key": "CF", "value": "Last" },

{ "key": "Upcasting", "value": "On" }

\],

"output": "README.md"

}

},

"support": { "linksFromMeta": true, "readme": "README.md" },

"exportHints": { "metaSource": "§25.metaLsx", "includeChangelog": true, "autoIconMirror": true },

"versioning": { "since": "v1", "lastUpdated": "2025-10-15" }

}

}

**Field-by-field (keys & meanings)**

*   **modId / title / summary:** Player-facing identity; modId is a stable slug.
*   **authorFrom:** Single source of truth (pulls from §1).
*   **tagGenerator:** Derive tags from §6/§7 content, merged with manual tags.
*   **module / moduleLayout / folders:** Packaging & canonical directory structure for exporters.
*   **dependencies / compatibilityMirror:** Mirrors §1 compatibility posture here (advisory).
*   **loadOrder:** after: \["CommunityLibrary"\], with profiler and auto-after suggestions; compatibilityFramework last.
*   **localization:** Domain, languages, source/staging paths; later consumed by §23 & §25.
*   **manifests / exportHints:** meta.lsx path + export wiring.

**Inputs (required/optional + defaults)**

**Required:** modId, title, summary, moduleLayout, dependencies.communityLibrary.enabled, visuals.iconHandle.  
**Optional (defaulted):** tags (empty), locales (\["en"\]), compatibility.platforms (\["Windows","Mac"\]), exportHints.includeChangelog (true).

**Dependencies & Cross-refs**

Reads §1 (namespace, CL/SE toggles); feeds §23 (loc), §25 (export), §22 (renderer labels), §29 (CI). Aligns with Target’s process & immutable Index.

**Handles & UUIDs — namespacing + v5 seed rules**

*   UUIDv5 seed: {§1.namespace.root}:{modId}:module for module identity and derivative assets.
*   Icon handles must prefix with {§1.namespace.root}/icons/....

**Data Model Notes (LSX/LSF + paths)**

*   Authoring config in JSON/YAML; exporter scaffolds folders and emits meta.lsx from §25.
*   Public vs Mods channels set via moduleLayout.localisation.channel and §25 pack settings.

**Validation (lint rules & severities)**

*   **COMP-010 (E):** modId must be kebab/underscore and stable.
*   **DET-020 (E):** UUIDv5 seed resolvable from §1.
*   **UI-020 (E):** Title/summary free of banned terms (§0.3).
*   **LOAD-030/041 (W):** Auto-after suggestions exist but unconfirmed.
*   **CONFLICT-100 (W):** DX conflict scanner overlaps.

**Test Cases (min/typical/stress)**

*   **Min:** EN only, CL ON, SE OFF; empty tags → PASS.
*   **Typical:** EN + preview images, explicit load order → PASS, zero WARN.
*   **Stress:** SE OFF here but some §7 item later requires SE → WARN until fallback or profile toggle resolves.

**Edge Cases & Compatibility — CL/SE flags**

Keep SE disabled here; any SE-only behavior later must provide a vanilla fallback (registry policy).

**Check vs Section 0 (Flavor Core / Playbook)**

*   Title/summary must pass §0.1 tone and §0.3 banned-terms checks.
*   WoW proper names allowed as titles only; tooltips read as BG3-native.

**Pitfalls**

*   Changing modId post-generation breaks deterministic paths/UUIDs.
*   Missing reciprocal load-order hints when overriding other mods.
*   Icon handles not namespaced → collisions.

**Versioning & Changelog Hooks**

*   **§26 entry:** 2025-10-15 — §3 locked at v1.1 (identity, folders, dependencies, load order, packaging hints).
*   Registry: update §3 status **Locked** and record CL=ON, SE=OFF baseline.

### §4 — Usage Guide & Authoring Modes

**Owner:** vorgx  **Version:** v1.1 (Locked)  **Last Updated:** 15 Oct 2025 (AET)  **Status:** Locked  
_(Target cadence & Standard Authoring Skeleton; expanded Field‑by‑field; Mode A/B/C flows verified.)_

**What it does (Purpose & Outcomes)**

*   Explains how to use the Blueprint: authoring entry‑points, review cadence, export rhythm.
*   Standardizes three Modes (A/B/C) for predictable flow and identical artifacts.
*   Connects renderer/validator/export hooks to limit drift and rework.
*   Clarifies human‑in‑the‑loop checkpoints and registry updates per section.

**Authoring (steps) — concise checklist**

1.  Pick a Mode (A Greenfield / B Retrofit / C Import Wizard).
2.  Confirm §1 global toggles (CL/SE/Upcast); ensure §1–§3 are locked or in draft as required.
3.  Author the current section using the Standard Skeleton; keep “What it does” as bullets.
4.  Run §22 Quick Rules + §24 Validation suites; fix E before W.
5.  Submit for HITL review; update registry (decisions, flags, open items).
6.  On approval: Lock section; export via §25; append §26.

**Authoring (drop‑in JSON) — copy‑paste ready**

{

"usageGuide": {

"modes": \[

{

"id": "A",

"name": "Greenfield Authoring",

"when": \["New class from scratch","No legacy data to migrate"\],

"flow": \[

"§1 Preface → §2 Meta → §3 Mod Basics (lock)",

"§6 Class Details → §7 Core Abilities → §8 Subclass Details",

"§9 Catalogs → §10 Distribution Presets",

"§11–§13 Resources & Casting",

"§14–§19 Progression & Tracks",

"§21–§23 Tokens/Renderer/Loc",

"§24 Validation → §25 Export → §26 Changelog"

\],

"hitl": \["Design Review (Class kit)","Power Budget Check","Lore Fit check (§0.1)"\]

},

{

"id": "B",

"name": "Retrofit (Existing Content)",

"when": \["Existing class JSON/LSX or partial sections"\],

"flow": \[

"Inventory what exists (§6–§9) → map to Target IDs",

"Normalize terms vs §0.3; tag reconciliation vs §21",

"Fill gaps in §10–§13 and §14–§19",

"Run §22 Renderer/§24 Validation",

"Export delta via §25; log in §26"

\],

"hitl": \["Delta Review","Compatibility scan (CL/SE/CF)"\]

},

{

"id": "C",

"name": "Import Wizard (Dynamic)",

"when": \["You have a structured source pack to ingest"\],

"flow": \[

"Launch §27 Wizard → select source pack",

"Stage → Review → Commit",

"Auto‑populate §6–§9, seed §14 Authoring rows",

"Run quick rules (§28) then §24 suites",

"Commit sections; export via §25"

\],

"hitl": \["Staging Review","Auto‑mapping approval"\]

}

\],

"registryTouchpoints": {

"onStart": \["Create/Update Registry row for current section"\],

"onReview": \["Record decisions, flags, and open items"\],

"onLock": \["Flip status to Locked; add §26 entry"\]

},

"globalToggles": {

"source": "§1.preface.toggles",

"mirrors": \["§3.loadOrder","§11/§13 resource switches","§22 renderer badges"\],

"notes": "What it does must be bullet‑pointed in all sections."

},

"qualityBars": {

"min": \["All E‑level lints = 0","Registry updated on Review/Lock"\],

"typical": \["No W lints","Renderer snapshot clean"\],

"stress": \["Large imports resolved via HITL","Compat scan W only"\]

},

"docs": {

"examples": "Public/<Mod>/Blueprint/examples/\*.md",

"faq": "Public/<Mod>/Blueprint/usage/FAQ.md"

}

}

}

**Field‑by‑field (keys & meanings) — complete**

**usageGuide**

*   **modes** _(array)_ — Declares the sanctioned authoring paths. Each item:
    *   **id** _(string; required; values: "A"|"B"|"C")_ — Short identifier.
    *   **name** _(string; required)_ — Human‑readable label.
    *   **when** _(string\[\]; required)_ — Situational triggers that make the mode appropriate.
    *   **flow** _(string\[\]; required)_ — Ordered list of Target sections to author or revisit.
    *   **hitl** _(string\[\]; optional)_ — Human‑in‑the‑loop checkpoints for governance and sign‑off.
*   **registryTouchpoints** _(object; required)_ — Where to sync the carried registry during authoring.
    *   **onStart** _(string\[\]; required)_ — Actions on section kickoff (create/update row, set owner).
    *   **onReview** _(string\[\]; required)_ — Actions during review (decisions, flags, open items, links).
    *   **onLock** _(string\[\]; required)_ — Actions at lock (status → Locked; add §26 entry; attach reports).
*   **globalToggles** _(object; required)_ — Single source for CL/SE/Upcast that mirrors elsewhere.
    *   **source** _(string; required)_ — Pointer to §1 key path.
    *   **mirrors** _(string\[\]; required)_ — Sections that should reflect toggles (renderer badges, resources, load order hints).
    *   **notes** _(string; optional)_ — Policy callouts (e.g., bullet‑pointed Purpose).
*   **qualityBars** _(object; optional)_ — Minimum/typical/stress acceptance bars.
    *   **min** _(string\[\])_ — Hard requirements to proceed (all E‑level lints = 0, registry updated).
    *   **typical** _(string\[\])_ — Expected steady‑state (no W lints, renderer clean).
    *   **stress** _(string\[\])_ — Acceptable envelope during heavy imports/migrations.
*   **docs** _(object; optional)_ — Convenience links for examples & FAQs.
    *   **examples** _(string; optional)_ — Path to working examples for quick copy.
    *   **faq** _(string; optional)_ — Path to a living FAQ.

**Inputs (required/optional + defaults)**

**Required:** modes\[\] (id,name,when,flow); registryTouchpoints (all keys); globalToggles.source; globalToggles.mirrors.  
**Optional (defaulted):** modes\[\].hitl (defaults to standard HITL per product policy); qualityBars (defaults to min only); docs (empty).

**Dependencies & Cross‑refs**

*   §0.1, §0.3 for lore/banned‑terms compliance; §21 tag vocabulary; §22 & §28 quick rules; §24 suites; §25 export; §26 changelog; §27 wizard. Ensure §1 toggles mirror into §3, §11–§13, §22.

**Handles & UUIDs — namespacing + v5 seed rules**

*   Logical doc; when artifacts are emitted, use uuidv5(namespace:§1.root, path:"usage:{mode}:{section}") for determinism.

**Data Model Notes (LSX/LSF + paths)**

*   Wizard stages to Public/<Mod>/\_Staging/… with a manifest.stage.json that lists proposed writes. On commit, paths normalize to section roots used by §25 exporter.

**Validation (lint rules & severities)**

*   **FLOW-001 (E):** Authoring step outside declared Mode flow without an override note.
*   **FLOW-010 (W):** Missing Registry update on Review/Lock.
*   **DOC-020 (E):** “What it does” not bullet‑pointed.
*   **TOGGLE-030 (E):** §1 toggles not mirrored where required.

**Test Cases (min/typical/stress)**

*   **Min:** Mode A, §1→§3→§6 path, quick rules PASS, zero E; export minimal pack.
*   **Typical:** Mode B with partial catalogs; tags reconciled vs §21; suites PASS; delta export.
*   **Stress:** Mode C large import; mapping collisions resolved via HITL; only W remain.

**Edge Cases & Compatibility — CL/SE flags**

*   If SE=OFF globally, Mode B/C must supply fallbacks or gate by profile before Lock.

**Check vs Section 0 (Flavor Core / Playbook)**

*   Usage examples must avoid banned terms; WoW names only as references; BG3‑native phrasing in tooltips.

**Pitfalls**

*   Skipping Registry updates (state drift).
*   Locking before quick rules/suites (leaks).
*   Mixing modes mid‑section without stating exception & rationale.

**Versioning & Changelog Hooks**

*   **§26 entry:** 2025-10-15 — §4 locked at v1.1 (Modes, registry, toggles, complete field map).
*   Registry: update §4 status **Locked** and record mandate: Purpose bullets required.

### §5 — Project Profiles (Dev / QA / Release)

**Owner:** vorgx  **Version:** v1 (Locked)  **Last Updated:** 15 Oct 2025 (AET)  **Status:** Locked  
_(Profiles define guardrails, toggles, validation depth, and export behavior per lifecycle stage.)_

**What it does (Purpose & Outcomes)**

*   Defines three **profiles** (Dev, QA, Release) that control toggles, gates, and artifact shape.
*   Ensures predictable validation depth and review checklists per stage.
*   Unifies exporter behavior (icons, localization, meta.lsx) to avoid environment drift.
*   Provides clear **entry/exit criteria** and **HITL** checkpoints to move forward safely.

**Authoring (steps) — concise checklist**

1.  Choose baseline toggles for each profile (CL/SE/Upcasting).
2.  Set validation suites (quick vs full) and thresholds per profile.
3.  Define HITL checkpoints and CI gates; wire to §27 Wizard and §24 suites.
4.  Configure exporter channels and artifact names per profile (e.g., \_dev, \_rc, \_vX.Y.Z).
5.  Save draft → run profile smoke (Dev/QA) → iterate → submit for review → Lock.

**Authoring (drop‑in JSON)**

{

"profiles": {

"dev": {

"id": "dev",

"name": "Development",

"purpose": "Fast iteration with relaxed gates and rapid feedback",

"toggles": { "CL": true, "SE": false, "Upcasting": true },

"validation": {

"quickRules": \["§22.renderer.badges","§28.quick"\],

"suites": {

"run": \["COMP","DET","DOC"\],

"severityGates": { "E": 0, "W": "<=10" }

}

},

"renderer": { "badges": \["DEV","CL","Upcast"\], "snapshots": true },

"export": {

"channel": "public",

"artifactName": "ClassMod\_dev",

"include": { "icons": true, "loc": true, "changelog": false },

"metaTemplate": "auto"

},

"hitl": { "checkpoints": \["Peer Review (author)", "Lead skim"\], "required": false },

"ci": { "gates": \["build", "lint"\], "allowFail": \["W-only"\] },

"branch": { "name": "feature/\*", "mergePolicy": "PR + 1 review" },

"entry": \["§1–§3 locked or in draft", "Target section in Draft"\],

"exit": \["E=0", "Registry updated"\]

},

"qa": {

"id": "qa",

"name": "Quality Assurance",

"purpose": "Stabilization with full suites and compatibility scanning",

"toggles": { "CL": true, "SE": false, "Upcasting": true },

"validation": {

"quickRules": \["§22.renderer.badges","§28.quick"\],

"suites": {

"run": \["COMP","DET","DOC","FLOW","TOGGLE","COMPAT"\],

"severityGates": { "E": 0, "W": "<=3" }

}

},

"renderer": { "badges": \["QA","CL","Upcast"\], "snapshots": true },

"export": {

"channel": "public",

"artifactName": "ClassMod\_rc",

"include": { "icons": true, "loc": true, "changelog": true },

"metaTemplate": "auto"

},

"hitl": { "checkpoints": \["Design Review","Power Budget","Lore Fit"\], "required": true },

"ci": { "gates": \["build","lint","validate","compat"\], "allowFail": \[\] },

"branch": { "name": "release/\*-rc", "mergePolicy": "PR + 2 reviews" },

"entry": \["§6–§10 authored", "Renderer clean"\],

"exit": \["E=0 & W<=3", "HITL PASS", "Registry → Ready for Release"\]

},

"release": {

"id": "release",

"name": "Release",

"purpose": "Locked artifacts with deterministic packaging",

"toggles": { "CL": true, "SE": false, "Upcasting": true },

"validation": {

"quickRules": \["§22.renderer.badges"\],

"suites": {

"run": \["COMP","DET","DOC","FLOW","TOGGLE","COMPAT"\],

"severityGates": { "E": 0, "W": 0 }

}

},

"renderer": { "badges": \["REL","CL","Upcast"\], "snapshots": true },

"export": {

"channel": "public",

"artifactName": "ClassMod\_v${version}",

"include": { "icons": true, "loc": true, "changelog": true },

"metaTemplate": "auto"

},

"hitl": { "checkpoints": \["Final Sign‑off"\], "required": true },

"ci": { "gates": \["build","lint","validate","compat","sign"\], "allowFail": \[\] },

"branch": { "name": "main", "mergePolicy": "protected + mandatory reviews" },

"entry": \["Registry → Ready for Release", "All sections locked"\],

"exit": \["Tag vX.Y.Z", "§26 updated", "Package pushed"\]

}

}

}

**Field‑by‑field (keys & meanings)**

**profiles (object)**

Top‑level container keyed by profile id.

*   **profiles.dev | profiles.qa | profiles.release** _(object; required)_
    *   **id** _(string; required)_ — Stable key ("dev"|"qa"|"release").
    *   **name** _(string; required)_ — Human‑readable label.
    *   **purpose** _(string; required)_ — One‑line profile intent.
    *   **toggles** _(object; required)_ — Mirrors §1 global toggles for this profile (Community Library, Script Extender, Upcasting).
    *   **validation** _(object; required)_ — What to run and acceptable severities.
        *   **quickRules** _(string\[\]; optional)_ — Fast checks (renderer badges, quick rules).
        *   **suites.run** _(string\[\]; required)_ — Suites to execute (e.g., COMP/DET/DOC/FLOW/TOGGLE/COMPAT).
        *   **suites.severityGates** _(object; required)_ — Thresholds per severity (E/W).
    *   **renderer** _(object; optional)_ — Badges and snapshot policy for visual checks.
        *   **badges** _(string\[\])_ — Chips indicating profile/toggles.
        *   **snapshots** _(bool)_ — Save PNG/HTML snapshots for diffs.
    *   **export** _(object; required)_ — Export channel and artifact policy.
        *   **channel** _("public"|"mods"; required)_ — Where files land in the pack.
        *   **artifactName** _(string; required)_ — Base artifact name or pattern.
        *   **include** _(object; required)_ — Which assets to include (icons/loc/changelog).
        *   **metaTemplate** _(string; optional)_ — Template mode ("auto" recommended).
    *   **hitl** _(object; required)_ — Human‑in‑the‑loop checkpoints.
        *   **checkpoints** _(string\[\]; required when required=true)_ — Named reviews.
        *   **required** _(bool; required)_ — If HITL is mandatory.
    *   **ci** _(object; required)_ — Pipeline gates executed for this profile.
        *   **gates** _(string\[\]; required)_ — Build/lint/validate/compat/sign, etc.
        *   **allowFail** _(string\[\]; optional)_ — Gates allowed to soft‑fail (e.g., warnings only in Dev).
    *   **branch** _(object; required)_ — Branch name pattern and merge policy.
        *   **name** _(string; required)_ — e.g., feature/_, release/_\-rc, main.
        *   **mergePolicy** _(string; required)_ — Required checks/reviews.
    *   **entry** _(string\[\]; required)_ — Preconditions to enter this profile.
    *   **exit** _(string\[\]; required)_ — Requirements to leave this profile.

**Inputs (required/optional + defaults)**

**Required:** All keys listed in the profile objects above.  
**Optional:** Renderer snapshots (default true for QA/Release, false for Dev); metaTemplate (defaults to "auto").

**Dependencies & Cross‑refs**

*   Mirrors §1 toggles and pushes to §3 (badges/load order hints), §11–§13 (resource switches), §22 (renderer badges), §24 (suites), §25 (export), §26 (changelog), §27 (wizard pipelines).

**Handles & UUIDs — namespacing + v5 seed rules**

*   Deterministic IDs for artifacts: uuidv5(§1.namespace.root, "profiles:{id}:{artifactName}").

**Data Model Notes (LSX/LSF + paths)**

*   Exporter reads profiles.\*.export to derive output paths and filenames; changelog inclusion controlled here for determinism.

**Validation (lint rules & severities)**

*   **PROF-001 (E):** Missing required profile key(s).
*   **PROF-010 (E):** Severity gates undefined or invalid.
*   **PROF-020 (E):** HITL required but no checkpoints specified.
*   **PROF-030 (W):** Release artifactName pattern missing version token in Release.

**Test Cases (min/typical/stress)**

*   **Min:** Dev build (E=0, W≤10) exports without changelog; snapshots on.
*   **Typical:** QA RC build hits COMPAT suite and yields W≤3; HITL PASS.
*   **Stress:** Release with all sections locked and severity gates strict (E=0,W=0) successfully tags and pushes.

**Edge Cases & Compatibility — CL/SE flags**

*   If SE=false but §7/§11 features request SE, exporter must inject fallbacks or block profile with E‑level error.

**Check vs Section 0 (Flavor Core / Playbook)**

*   Release notes and titles must adhere to §0.1 tone and §0.3 banned terms; WoW names only as proper nouns in titles.

**Pitfalls**

*   Divergent toggles between profiles without renderer badges → reviewers miss incompatibilities.
*   Skipping QA HITL for RC → defects escape to Release.

**Versioning & Changelog Hooks**

*   **§26 entry:** 2025-10-15 — §5 locked at v1 (Dev/QA/Release baselines; gates & export policies).
*   Registry updated with §5 status: **Locked**.

### §6 — Class Details (Full)

**Owner:** vorgx  **Version:** v1.2 (Full, improvements applied)  **Last Updated:** 15 Oct 2025 (AET)  **Status:** In Review

**What it does (Purpose & Outcomes)**

*   Establishes the **canonical class chassis** (identity, handles, role/playstyle, HP model, saves, proficiencies, subclass meta) consumed by downstream sections.
*   Implements a **rolePresetMatrix** that offers guided defaults for abilities/saves/skills while preserving explicit author control.
*   Declares **documentation‑only policies** (gear, rest recharge) and **renderer hints**; no gameplay is granted here.
*   Sets deterministic **namespacing/UUID v5 seeds** to keep all dependent content stable across exports.
*   Produces a **lintable, profile‑aware** record that other sections (esp. §§14–18) can validate against.

**Authoring (steps) — concise checklist**

1.  **Identity & Handles**: choose classKey; set UI handles. Keep raw keys out of UI.
2.  **Role & Playstyle**: set rolePreset (enables matrix suggestions); add free‑text playstyle bullets.
3.  **HP Model**: choose **Manual** or Wizard‑proposed (**ByTheme / Gated / BestGuess**) with **provenance**.
4.  **Ability & Saves**: if blank, importer applies matrix suggestions; explicit author entries take precedence.
5.  **Subclass Meta**: set amount and unlockLevel.
6.  **Movement & Senses**: document base/conditional speeds; grant later via §14/§16.
7.  **Proficiencies & Skills**: set armour/weapons/tools and skills.chooseN/list (matrix may seed list).
8.  **Starting Gear Policy**: documentation‑only policy; actual items must be granted in §14.
9.  **Multiclass Hints**: advisory ability prereq + gained proficiencies.
10.  **UI & Renderer**: icon, color tint, badge hints.
11.  **Validation**: run §28 Quick Rules + §24 suites; resolve all **ERRORS**.
12.  **Review & Registry**: HITL review; update registry; on lock add §26 changelog entry.

**Authoring (drop‑in JSON) — copy‑paste master template**

Fill values or use Wizard provenance for auto‑proposed fields. Keep numbers numeric; localize strings in §23.

{

"classDetails": {

"identity": {

"classKey": "CLASS\_ClassMod\_<Class>",

"handles": {

"displayName": "LOC\_CLASS\_<SLUG>\_NAME",

"shortName": "LOC\_CLASS\_<SLUG>\_SHORT",

"fantasy": "LOC\_CLASS\_<SLUG>\_FANTASY\_LINE",

"help": "LOC\_CLASS\_<SLUG>\_HELP"

},

"roleTags": \["Striker"\],

"rolePreset": "Striker",

"playstyle": \["Burst windows","Weapon mastery","Builder/Spender economy"\],

"primaryAbility": null,

"secondaryAbility": null,

"savingThrows": \[\],

"hitDie": "d10",

"baseHP": 12,

"hpPerLevel": "d10",

"provenance": {

"hpModel": { "mode": "Manual", "note": "Martial chassis", "lastUpdated": "2025-10-15", "confidence": 1.0 }

}

},

"subclasses": { "amount": 3, "unlockLevel": 1 },

"movement": { "baseSpeed": 9, "bonusJump": 0, "climbSpeed": 0, "swimSpeed": 0 },

"conditionalSpeeds": \[\],

"proficiencies": {

"armour": { "light": true, "medium": true, "heavy": false, "shields": true },

"weapons": { "simple": true, "martial": true, "ranged": true, "finesse": true },

"tools": \[\],

"skills": { "chooseN": 2, "list": \["Athletics","Perception","Intimidation","Survival"\] }

},

"proficiencyOverridesPolicy": { "deltaKind": "add" },

"bonusProficienciesAtLevels": \[\],

"senses": { "darkvision": 0, "tremorsense": 0, "blindsight": 0 },

"languages": \[\],

"startingGear": { "enabled": false, "baseKit": \[\], "variantBySubclass": false, "requireGrant": true },

"restRechargePolicy": { "shortRestFeatures": \[\], "longRestFeatures": \[\] },

"casterHint": { "isCaster": false, "model": "None", "slotTrackHint": null },

"multiclassPrereq": { "ability": "STR", "min": 13, "notes": "Adjust per design" },

"multiclassProficiencies": { "armor": \["Light","Medium","Shields"\], "weapons": \["Simple","Martial"\], "tools": \[\] },

"ui": {

"icon": "ICON\_ClassMod\_<Class>",

"colorHint": "#AABBCC",

"iconStrategy": "inherit",

"uiIconVariants": {},

"badges": \["Martial","BleedCapable"\]

},

"validationProfile": "dev",

"tags": \["CLASS","MELEE","PHYSICAL","WARRIOR\_ARCHETYPE"\],

"rolePresetMatrix": {

"Striker": {

"primaryAbility": "STR|DEX",

"savingThrows": \["DEX","CON"\],

"skills": { "suggest": \["Athletics","Acrobatics","Stealth","Perception","Intimidation"\] }

},

"Vanguard": {

"primaryAbility": "STR|CON",

"savingThrows": \["STR","CON"\],

"skills": { "suggest": \["Athletics","Intimidation","Perception","Survival"\] }

},

"Skirmisher": {

"primaryAbility": "DEX",

"savingThrows": \["DEX","WIS"\],

"skills": { "suggest": \["Acrobatics","Stealth","Perception","SleightOfHand"\] }

},

"Battlemage": {

"primaryAbility": "INT|WIS|CHA",

"savingThrows": \["CON","WIS"\],

"skills": { "suggest": \["Arcana","History","Insight","Perception"\] }

}

}

}

}

**Matrix application rule:** If primaryAbility is **null** and a rolePreset is set, take the first listed ability from that preset. If savingThrows is empty, copy both suggested throws. If skills.list is empty, pre‑fill from skills.suggest then the author **must** prune to chooseN.

**Field‑by‑field (keys & meanings) — Complete (v1.2)**

Types use JSON‑ish notation. _Req._ = required. _Def._ = default.

**identity**

*   **classKey** _(string, Req.)_ — Canonical class ID. **Format:** CLASS\_<Pack>\_<Name> (UPPER\_SNAKE). **Must match §2 Meta.**
*   **handles** _(object, Req.)_ — Localization keys realized in §23:
    *   **displayName** _(string)_ — LOC\_CLASS\_<SLUG>\_NAME.
    *   **shortName** _(string)_ — LOC\_CLASS\_<SLUG>\_SHORT.
    *   **fantasy** _(string)_ — LOC\_CLASS\_<SLUG>\_FANTASY\_LINE.
    *   **help** _(string)_ — LOC\_CLASS\_<SLUG>\_HELP.
*   **roleTags** _(string\[\])_ — High‑level grouping labels; see §21.
*   **rolePreset** _(string | null)_ — One of: Striker|Vanguard|Skirmisher|Battlemage|….
*   **playstyle** _(string\[\])_ — Free‑text bullets.
*   **primaryAbility** _(Ability | null, Req.)_ — STR|DEX|CON|INT|WIS|CHA; matrix may pre‑fill.
*   **secondaryAbility** _(Ability | null)_ — Optional.
*   **savingThrows** _(array\[2\] of Ability, Req.)_ — Exactly two distinct abilities.
*   **hitDie** _("d6"|"d8"|"d10"|"d12", Req.)_ — Influences hp table copy.
*   **baseHP** _(int ≥ 1, Req.)_ — Starting HP at L1 before CON.
*   **hpPerLevel** _(Die, Req.)_ — d6|d8|d10|d12.
*   **provenance.hpModel** _(object, Req. if HP fields null/non‑standard)_ — { mode:Manual|ByTheme|Gated|BestGuess, rule:string|null, source:string|null, confidence:0.0–1.0, lastUpdated:ISO date }.

**subclasses**

*   **amount** _(int ≥ 1, Def. 3)_ — Count of subclasses.
*   **unlockLevel** _(int ≥ 1, Def. 1)_ — First subclass choice level.

**movement**

*   **baseSpeed** _(number, meters/turn, Def. 9)_ — Exporter may convert to cells.
*   **bonusJump / climbSpeed / swimSpeed** _(number, Def. 0)_ — Advisory only; grants later.
*   **conditionalSpeeds** _(array, Def. \[\])_ — { condition:string, speedDelta:number, type:"add|set" }.

**proficiencies**

*   **armour** _(object)_ — { light:boolean, medium:boolean, heavy:boolean, shields:boolean }.
*   **weapons** _(object)_ — { simple:boolean, martial:boolean, ranged:boolean, finesse:boolean }.
*   **tools** _(string\[\])_ — Tool IDs (authoring names).
*   **skills** _(object, Req.)_ — { chooseN:int≥0, list:string\[\] }.
*   **proficiencyOverridesPolicy** _(object, Def. { deltaKind:"add" })_ — { deltaKind:"add|remove|replace" }.
*   **bonusProficienciesAtLevels** _(array, Def. \[\])_ — { level:int≥1, add:{…shape of proficiencies} }.

**senses & languages**

*   **senses** _(object, Def. zeros)_ — { darkvision:int≥0, tremorsense:int≥0, blindsight:int≥0 } (meters).
*   **languages** _(string\[\], Def. \[\])_ — Language IDs.

**startingGear**

*   **enabled** _(boolean, Def. false)_ — Enables policy.
*   **baseKit** _(string\[\] handles, Def. \[\])_ — Item template handles; **granted in §14** when requireGrant=true.
*   **variantBySubclass** _(boolean, Def. false)_ — Subclasses may override.
*   **requireGrant** _(boolean, Def. true)_ — Validates presence of §14 grants.

**restRechargePolicy**

*   **shortRestFeatures** _(string\[\] handles, Def. \[\])_ — Named features **defined in §7/§14**.
*   **longRestFeatures** _(string\[\] handles, Def. \[\])_ — Same.

**casterHint**

*   **isCaster** _(boolean, Def. false)_.
*   **model** _("None"|"Full"|"Half"|"Third"|"Custom", Def. "None")_.
*   **slotTrackHint** _(object|null)_ — If model ≠ None: { table:"PHB|Custom", pactSlots:boolean, scaleBy:"Level|Tier" }.

**multiclass**

*   **multiclassPrereq** _(object)_ — { ability:Ability, min:int≥8, notes:string } (advisory).
*   **multiclassProficiencies** _(object)_ — { armor:string\[\], weapons:string\[\], tools:string\[\] }.

**ui**

*   **icon** _(string, Req.)_ — Icon asset key.
*   **colorHint** _(string HEX/RGB, optional)_ — Renderer only.
*   **iconStrategy** _("inherit"|"override", Def. "inherit")_ — Subclass icon policy.
*   **uiIconVariants** _(object, Def. {})_ — { key → icon }.
*   **badges** _(string\[\], Def. \[\])_ — Renderer badges (see §22 behavior).

**validationProfile**

*   **validationProfile** _("dev"|"strict", Def. "dev")_ — Adjusts §24 severity elevations.

**tags & notes**

*   **tags** _(string\[\], Def. \[\])_ — Must normalize to §21 registry. **Format:** UPPER\_SNAKE; domain prefixes (e.g., CLASS, MELEE).
*   **notes** _(string\[\], Def. \[\])_ — Free‑text audit notes; surfaced in §26.

**rolePresetMatrix (v1.1 feature)**

*   **rolePresetMatrix** _(object)_ — Per‑role suggestions: primaryAbility (pipe options), savingThrows (array\[2\]), skills.suggest (string\[\]). **Precedence:** explicit author values override suggestions.

**Inputs (required/optional + defaults)**

**Required:** classKey, handles.displayName, primaryAbility _(or rolePreset + matrix)_, savingThrows\[2\] _(or matrix)_, hitDie, baseHP, hpPerLevel, skills.chooseN, validationProfile.

**Optional:** secondaryAbility, languages, ui.\*, notes, bonusProficienciesAtLevels, conditionalSpeeds, rolePresetMatrix.

**Defaults:** subclasses.amount=3, subclasses.unlockLevel=1, startingGear.enabled=false, proficiencyOverridesPolicy.deltaKind="add", senses=0.

**Dependencies & Cross‑refs**

*   **§1 Preface** — Namespace & UUID v5 seed; global toggles.
*   **§2 Meta** — classKey must match.
*   **§7 Class Core Abilities** — Class‑wide passives/toggles reference this chassis.
*   **§8 Subclass Details** — Subclass specifics; must not leak into §6.
*   **§9 Catalogs** — Choice lists referenced later.
*   **§14–§18** — Grants, progression, renderer table; rely on §6 identity and policies.
*   **§21 Token Glossary** — Final tag vocabulary & validator.
*   **§22 Renderer Rules** — Badges/filters; UI hints.
*   **§23 Localization** — Realizes handles.
*   **§24 Validation** — Runs schema & policy checks.

**Handles & UUIDs — namespacing + v5 seed rules**

*   **Seed:** {§1.namespace.root}:class:{identity.classKey} for the class chassis.
*   **Derivatives:** Use :gear: and :subclass: suffixes for deterministic related IDs.
*   **Localization Handles:** LOC\_CLASS\_<SLUG>\_\* — realized in §23.

**Data Model Notes (LSX/LSF + paths)**

*   **Authoring source:** JSON/YAML here; exporter compiles to **ClassDescriptions.lsx** and contributes to **Progressions.lsx** via §14 grants.
*   **No Script Extender** logic here; keep SE usage in later sections with vanilla fallbacks.

**Validation (lint rules & severities)**

**ERRORS**

*   ID001 — classKey missing/mismatch vs §2 Meta.
*   ID002 — handles.displayName missing.
*   SUB002 — subclasses.amount < 1 or unlockLevel < 1.
*   ST002 — savingThrows not exactly two valid abilities.
*   HP003 — Invalid HP fields.
*   HPPOL001 — Wizard HP fields without provenance.hpModel.
*   HPPOL004 — Common fallback HPs w/out provenance (8/10/12) forbidden.
*   MOV001 — conditionalSpeeds\[\*\].type not in add|set or negative speedDelta.
*   PROF007 — bonusProficienciesAtLevels\[\*\].level < 1 or malformed add object.
*   CAST001 — casterHint.model ≠ None but isCaster=false.
*   UI004 — icon missing.
*   RMX001 — rolePreset set but no matching entry in rolePresetMatrix.
*   RMX002 — Matrix suggested savingThrows not exactly two legal abilities.

**WARNINGS**

*   HPPOL002 — BestGuess HP mode not yet accepted.
*   RESKIT014 — startingGear.requireGrant=true but no §14 grant present (elevates to ERROR in strict).
*   PROFDELTA010 — Subclass proficiency deltas later without deltaKind set here.
*   LANG001 — languages non‑empty but not normalized to §21.
*   TAG002 — tags not in UPPER\_SNAKE or unknown prefix.
*   RMX010 — skills.list auto‑seeded from matrix; author not pruned to chooseN.
*   RMX011 — Pipes (|) used; importer selected default; consider explicit override.

**INFO**

*   VALPROFILE000 — Active validation profile.
*   RMX100 — Matrix applied; explicit overrides detected.

**Test Cases (min/typical/stress)**

*   **Min:** Manual HP model, two saves, skills.chooseN valid → PASS.
*   **Typical:** rolePreset=Striker, empty saves/skills → importer fills DEX/CON and seed list → author trims to 2 (WARN→clear).
*   **Stress:** Strict profile; conditional speeds + subclass proficiency deltas; ensure WARN/E levelling works.
*   **Override:** Author sets savingThrows=\["STR","CON"\] despite Striker preset → INFO RMX100.

**Edge Cases & Compatibility — CL/SE flags**

*   **CL:** Optional helpers are safe; no dependency required here.
*   **SE:** **Unused** in §6. Any SE behavior belongs to later sections with vanilla fallbacks.

**Check vs Section 0 (Flavor Core / Playbook)**

*   Titles/strings must pass §0.1 tone; no §0.3 banned terms.
*   WoW proper names allowed in titles; **descriptions must read BG3‑native**.

**Pitfalls**

*   Granting gameplay here (don’t) — use §14/§16.
*   Changing classKey post‑authoring → breaks determinism.
*   Missing reciprocal policy links (e.g., starting gear policy but no §14 grant).

**Proposed Improvements (backlog — do not apply yet)**

*   Auto‑derive ui.badges from tags/role.
*   Add notes.audit timestamps to feed §26 changelog diffs.

**Localization Map (handles → strings/tooltips)**

*   LOC\_CLASS\_<SLUG>\_NAME → "TBD Class"
*   LOC\_CLASS\_<SLUG>\_SHORT → "TBD"
*   LOC\_CLASS\_<SLUG>\_FANTASY\_LINE → "A disciplined frontline champion who excels in weapon mastery."
*   LOC\_CLASS\_<SLUG>\_HELP → "TBD long help (2–3 sentences)."

**Versioning & Changelog Hooks**

*   **since:** v1.0 (initial draft), v1.1 (rolePresetMatrix + RMX lint), **v1.2 (Field‑by‑field complete)**.
*   On lock, append §26 entry covering identity/proficiency/skills/icon/subclass/multiclass changes.
*   Post‑lock policy: §6 is **add‑only** (per §1).

### §7 — Class Core Abilities

**Owner:** vorgx  
**Version:** vNext  
**Last Updated:** 13 Oct 2025 (AET)  
**Status:** Draft

**What it does (Purpose & Outcomes)**

Defines **shared, class‑wide** abilities and catalog entries that apply to **all subclasses** of the class: evergreen passives, global stance toggles + their statuses, any truly class‑wide builders/spenders, class‑wide feats (including choice‑style feats), and **skill bias** hints for UI. **No subclass‑specific content here** (that lives in §8 + §20).

Success = a self‑contained, namespaced, class‑scope catalog that validates (TOK/UI/BAND), renders cleanly, and grants correctly via §16–§18.

**Authoring (steps)**

1.  Confirm scope is **class‑wide** (not tied to a single subclass).
2.  Draft **Passives**, then **Stance Toggles** and their **Statuses** (use one toggleGroup, cross‑link exclusiveWith).
3.  Add **Builders/Spenders** **only** if all subclasses should have them.
4.  Add any **class‑wide Feats** (including choice‑style feats) and wire the **choice list** to §9 **Catalogs (Class & Subclass)**.
5.  Set **Skill Bias** (advisory only; no enforcement).
6.  Prepare **UI strings** (handles) and **Localization stubs** (mapped later in §23).
7.  Validate: TOK (namespacing), UI (no raw tokens in labels), BAND (no subclass leakage), WIN/EXP (action/cooldown sanity).
8.  Reference‑grant in §16 (authoring rows) and confirm §18 (rendered table) materializes one row per grant with clean labels.

**Authoring (drop‑in JSON) — copy‑paste starter**

{

"classCore": {

"skillBias": {

"primary": \["TIP — 1–3 skills (advisory)"\],

"secondary": \["TIP — 1–3 skills (advisory)"\],

"notes": "Guides UI suggestions; enforcement remains in §6/§16."

},

"builders": \[\],

"spenders": \[\],

"passives": \[

{

"key": "PASSIVE\_<NS>\_<CLASS>\_CORE\_ACCURACY",

"uiName": "Core Accuracy",

"grantLabel": "Passive — accuracy"

,"descriptionShort": "+1 to attack rolls with proficient weapons.",

"modifiers": \[ { "type": "AttackRollBonus", "value": 1, "condition": "ProficientWeapon" } \],

"tags": \["Passive","Core"\],

"ui": { "icon": "ICON\_<NS>\_<CLASS>\_PASSIVE\_ACCURACY" }

}

\],

"toggles": \[

{

"key": "TOGGLE\_<NS>\_<CLASS>\_STANCE\_DEFENSIVE",

"uiName": "Defensive Stance",

"grantLabel": "Stance — +AC; −Move; cancels Offensive",

"descriptionShort": "+1 AC, −2 m movement.",

"actionType": "BonusAction",

"cooldown": 0,

"toggleGroup": "STANCES\_<NS>\_<CLASS>\_CORE",

"exclusiveWith": \["TOGGLE\_<NS>\_<CLASS>\_STANCE\_OFFENSIVE"\],

"applies": \[ { "status": "STATUS\_<NS>\_<CLASS>\_STANCE\_DEF", "duration": "Toggle" } \],

"tags": \["Stance","Defense"\],

"ui": { "icon": "ICON\_<NS>\_<CLASS>\_STANCE\_DEF" }

},

{

"key": "TOGGLE\_<NS>\_<CLASS>\_STANCE\_OFFENSIVE",

"uiName": "Offensive Stance",

"grantLabel": "Stance — +Dmg; −AC; cancels Defensive",

"descriptionShort": "+1d4 weapon damage, −1 AC.",

"actionType": "BonusAction",

"cooldown": 0,

"toggleGroup": "STANCES\_<NS>\_<CLASS>\_CORE",

"exclusiveWith": \["TOGGLE\_<NS>\_<CLASS>\_STANCE\_DEFENSIVE"\],

"applies": \[ { "status": "STATUS\_<NS>\_<CLASS>\_STANCE\_OFF", "duration": "Toggle" } \],

"tags": \["Stance","Offense"\],

"ui": { "icon": "ICON\_<NS>\_<CLASS>\_STANCE\_OFF" }

}

\],

"statuses": \[

{

"key": "STATUS\_<NS>\_<CLASS>\_STANCE\_DEF",

"uiName": "Defensive Stance",

"grantLabel": "Status",

"descriptionShort": "+1 AC, −2 m movement.",

"bonuses": \[ { "type": "AC", "value": 1 }, { "type": "MoveSpeed", "value": -2 } \],

"stacking": "Replace",

"tags": \["Status","Defense"\]

},

{

"key": "STATUS\_<NS>\_<CLASS>\_STANCE\_OFF",

"uiName": "Offensive Stance",

"grantLabel": "Status",

"descriptionShort": "+1d4 weapon damage, −1 AC.",

"bonuses": \[ { "type": "DamageRollBonus", "valueDice": "1d4", "scope": "Weapon" }, { "type": "AC", "value": -1 } \],

"stacking": "Replace",

"tags": \["Status","Offense"\]

}

\],

"feats": \[

{

"key": "FEAT\_<NS>\_<CLASS>\_COMBAT\_STYLE",

"uiName": "Combat Style",

"grantLabel": "Feat — choose 1 style",

"descriptionShort": "Choice UI shows options from §9.",

"choiceListKey": "CHOICE\_<NS>\_<CLASS>\_STYLES",

"tags": \["Feat","Choice"\],

"ui": { "icon": "ICON\_<NS>\_<CLASS>\_FEAT\_STYLE" }

}

\]

}

}

**Field‑by‑field (keys & meanings)**

*   **skillBias** — advisory for UI; enforcement is elsewhere.
*   **builders / spenders** — keep empty unless truly **all subclasses** share them.
*   **toggles / statuses** — toggleGroup + reciprocal exclusiveWith; statuses define the effect while toggled.
*   **feats.choiceListKey** — must resolve to a real list in **§9 Catalogs**.

**Inputs (required/optional + defaults)**

*   **Required:** At least one of passives\[\] or toggles\[\]/statuses\[\] (class‑wide).
*   **Optional:** builders\[\], spenders\[\], feats\[\], skillBias, notesAtAcquisition\[\].
*   **Defaults:** cooldown: 0, actionType: Action unless otherwise specified.

**Dependencies & Cross‑refs (Aligned to your Index)**

*   **§6 Class Details** (labels and identity)
*   **§8 Subclass Details** (keep content out of §7 if it’s subclass‑specific)
*   **§9 Catalogs (Class & Subclass)** — lists used by choiceListKey
*   **§11 Class/Subclass Resources & Mechanics** — if adding universal builders/spenders
*   **§12 Casting Details & Settings** and **§13 Casting Resources & Mechanics** — if any spells/actions require casting hooks
*   **§16 Progression — Authoring (atomic rows)** — grants reference into §7 keys
*   **§17 Rendered Table Config** → **§18 Progression — Rendered Table (materialized)**
*   **§21 Token Glossary (+ Validator)** — token/namespace hygiene
*   **§22 Renderer Rules** — section‑wide chips/filters for UI rendering
*   **§23 Localization** — strings for the handles defined here
*   **§24 Validation** — linting profile & severities
*   **§25 Export Settings** — icon channel, packaging
*   **§26 Change Log** — versioned note when §7 is locked

**Handles & UUIDs — namespacing + v5 seed rules**

*   Prefix keys with ACTION\_/PASSIVE\_/STATUS\_/FEAT\_/TOGGLE\_.
*   Seed: "<NAMESPACE>|<CLASS>|classCore|<localKeyPath>" for UUIDv5 determinism across renders.
*   **Class scope only** — never reuse keys that belong to a specific subclass.

**Data Model Notes (LSX/LSF + paths)**

*   **Stats/Generated/**: Actions/Passives/Statuses created from this catalog.
*   **Progressions/**: §16–§18 materialize grants (not produced by §7 alone).
*   **Localization/**: §23 emits tables from handles set here.
*   **Icons/**: resolved at export per §25 channel.

**Validation (lint rules & severities)**

*   TOK-\* — namespacing & uniqueness.
*   UI-010 — no raw tokens in UI labels.
*   BAND-\* — **no subclass leakage**.
*   WIN-\* — action type/cooldown sanity.
*   EXP-\* — export readiness (icons present or placeholder allowed).

**Test Cases (min / typical / stress)**

*   **Min:** 1 passive + 1 stance pair with statuses → validate; confirm §16 grant rows and §18 render cleanly.
*   **Typical:** + one class‑wide choice feat wired to §9.
*   **Stress:** Multiple stances, exclusivity checks, long notesAtAcquisition while preserving ≤80 char descriptionShort.

**Edge Cases & Compatibility — CL/SE flags**

*   SE not required by default. If a global stance/feat needs SE, mark local requires.scriptExtender: true and provide a vanilla fallback rider.

**Check vs Section 0 (Flavor Core / Playbook)**

*   WoW names allowed by policy; adhere to BG3 tone rules from §0.1/§0.3.
*   Keep phrasing Faerûn‑consistent; avoid non‑fantasy tech terms.

**Pitfalls**

*   Putting subclass items here (move to §8 + §20).
*   Missing reciprocal exclusiveWith on stance toggles.
*   choiceListKey not defined in §9 → broken UI.
*   Overlong descriptions → truncated tooltips.

**Proposed Improvements (not applied yet)**

1.  variantsByTier for any class‑wide passive/stance to auto‑scale at **3/8/13/18** via §19 Upgrade Tracks → actually §19 is Upgrade Tracks in old map; in your Index it's **§19 Upgrade Tracks**; scaling is wired in §16/§18 with §22 renderer.
2.  Standardize tag chips for renderer filters (Passive, Stance, Status, Feat) to leverage §22.
3.  Add aiTags (e.g., "Burst", "Debuff", "Defensive") for better bar suggestions.

**Localization Map (handles → strings/tooltips)**

*   h\_PASSIVE\_<…>\_CORE\_ACCURACY → "Core Accuracy"
*   d\_PASSIVE\_<…>\_CORE\_ACCURACY → "+1 to attack rolls with proficient weapons."
*   h\_TOGGLE\_<…>\_STANCE\_DEFENSIVE → "Defensive Stance"
*   d\_STATUS\_<…>\_STANCE\_DEF → "+1 AC, −2 m movement."
*   h\_TOGGLE\_<…>\_STANCE\_OFFENSIVE → "Offensive Stance"
*   d\_STATUS\_<…>\_STANCE\_OFF → "+1d4 weapon damage, −1 AC."

**Versioning & Changelog Hooks**

When §7 is locked, append to §26 Change Log:  
{ type: "add", section: "§7", keys: \["PASSIVE\_…CORE\_ACCURACY","TOGGLE\_…DEFENSIVE","TOGGLE\_…OFFENSIVE","STATUS\_…DEF","STATUS\_…OFF","FEAT\_…COMBAT\_STYLE"\] }