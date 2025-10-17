# BG3 Mod Framework – Global Rules & Class Template (v1.3, Consolidated)

**Purpose:** Single source of truth for class imports (WoW, Diablo, GW2, etc.) into BG3. Defines global mechanics, scaling, resources, tiers, upcasting, stacking, file skeletons, INIT payloads, balance guardrails and QA.

---
# 1) Core Global Assumptions
- **Subclass Timing:** Choose subclass/spec at **Level 1**. Level 3 becomes the **first power spike** (unlock stances/aspects/attunements or a second core button).
- **Level Cap:** **20**.  
- **Feats:** **Every 4th level** (**4/8/12/16/20**). Ability Improvement offered via feat.  
- **Tiered Scaling:** Opt‑in abilities gain tier upgrades at **character levels 5/10/15/20**.  
- **Add‑Only Modding:** Never overwrite vanilla rows. New classes are isolated; vanilla subclass inserts use **SCF** (requires **BG3SE**).  
- **Power Target:** “Vanilla‑like” baseline unless specified. % windows are **additive** only.

---
# 2) Universal Scaling Rules
- **Primary Stat:** Each class declares a **Primary** (e.g., STR for Warrior, CHA for Paladin).
- **Save DCs (class abilities):** `8 + Proficiency + Primary Stat Mod`.
- **Rider Damage/Healing:** Add **Primary Stat Mod** (or ½ mod as noted). Weapon dice remain gear‑driven.
- **Temporary HP:** Always **`Proficiency + CON mod`** (+flat where an ability states). **Replace**, don’t stack, on refresh.
- **Armor Class:** Use **flat integers** for AC changes (e.g., +1/+2/+3). Never % AC.
- **Movement:** Flat **metres** (e.g., +3 m / −3 m).  
- **% Damage Modifiers:** Only for stances/aspects or short signature windows. **Additive** with other %; never multiply flats.  
- **Crit:** Prefer **crit range** changes (e.g., 19–20) or granting a **Bonus Attack** rather than % crit chance.  
- **Summons/Pets:** Base stat blocks per family; scale by **level**/**Proficiency**; **command DCs** use **Primary**.

---
# 3) Stacking & Priority
- **Additive % Stacking:** Sum all damage multipliers, apply once.  
- **Flats Before %:** Apply flat riders (e.g., +STR mod, +1d6) **before** % windows.  
- **One Stance/Aspect Rule:** Only **one** stance/aspect/attunement active; **1‑turn lockout** on swapping.  
- **No Hidden Multipliers:** Avoid nesting %×% (e.g., Vulnerable × Berserk). Convert one side to flat (−AC, +flat damage) if needed.

---
# 4) Tiered Power System (5/10/15/20)
Any ability can opt in. If not bespoke, use a **category default**:

## 4.1 Default Tier Tables
**A) Stances / Aspects (examples)**
- **Battle‑type (reliable):** Base **+10% dmg, +1 atk, +1 AC** → L5 **+15%** → L10 **+20% dmg, +2 atk, +1 AC** → L15 **+22% dmg, +2 atk, +2 AC** → L20 **+25% dmg, +3 atk, +3 AC**.
- **Defensive‑type (turtle):** Base **+3 AC, −25% dmg** → L5 **+3/−30%** → L10 **+4/−35%** → L15 **+4/−40%** → L20 **+5 AC, −50% dmg**.
- **Glass‑cannon (berserker‑type):** Base **−3 AC, +25% dmg** → L5 **−3/+30%** → L10 **−4/+35%** → L15 **−4/+40%** → L20 **−5/+50%**.

**B) Shouts/Auras**  
- Base: party buff; **Temp HP = Prof + CON** where relevant.  
- **L10:** +1 flat to main bonus or **+3 m** radius.  
- **L15:** Temp HP uses **2×Prof + CON**.  
- **L20:** Add **+2** flat Temp HP or extend duration by +1 turn.

**C) Finishers (Execute/Smite/Verdict/Detonation)**  
- **L10:** +**1d6** rider (or +1 die step).  
- **L20:** +**2d6** rider total (either replaces L10 or stacks—be consistent per ability).

**D) Signature Windows (Recklessness/Trueshot/Crusade)**  
- Base: **2 turns** of signature benefit.  
- **L15:** Add small rider (e.g., +Primary on hit).  
- **L20:** **+1 Bonus Attack** on the first turn or extend to 3 turns.

**E) DoTs/Marks/Zones**  
- **L10:** +Primary to initial tick or secondary effect.  
- **L20:** +1 turn duration or +1d4 on first tick.

**F) Summon/Pet Commands**  
- **L10:** DC +1 (flat), rider +Primary/2.  
- **L20:** DC +1 again (cumulative), rider +1d6.

---
# 5) Resource Systems (Global v1.3)
- **Pip Pool Cap:** **11** for all point‑based classes (Rage, Holy Power, Focus, etc.).  
- **Upcasting:** Actions may spend **up to +9 extra pips** beyond base cost (or up to cap if lower).  
- **Short‑Rest Floor:** Default **2** pips (class may override).  
- **Overflow:** Generation above cap is **lost** (no conversion).  
- **Class Uniqueness:** Each class defines **how** it gains pips (e.g., Warrior on hit/taking damage; Paladin via Judgement + on‑hit; Hunter gains **+1 at the start of turn** plus builders/crit/pet hooks).

**INIT template (resource block):**
```json
"resource": {
  "type": "pips",
  "name": "Rage/Focus/HolyPower/etc.",
  "max": 11,
  "shortRestFloor": 2
}
```

---
# 6) Upcasting (Base → +9 extra pips)
**Principles:** Upcasting adds **flat riders** (dice, DC, radius, duration, Temp HP). It **never** multiplies % windows or change action economy unless explicitly stated. Tooltips show **Base / +1 … +9** rows.

## 6.1 Default Per‑Pip Gains
| Category | +1 | +2 | +3 | +4 | +5 | +6 | +7 | +8 | +9 | Cap / Fallback |
|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---|
| **Weapon Rider / Smite / Strike** | +1d6 | +2d6 | +3d6 | +4d6 | +5d6 | +6d6 | +7d6 | +8d6 | +9d6 | — |
| **Finisher (Execute/Verdict/Detonate)** | +1d6 | +2d6 | +3d6 | +4d6 | +5d6 | +6d6 | +7d6 | +8d6 | +9d6 | — |
| **Cone/Line/AoE Radius/Length** | +1 m | +2 m | +3 m | +4 m | +5 m | +6 m | +7 m | +8 m | +9 m | **9 m max**; extra pips → **+1d6 dmg** each |
| **DoT/Mark/Zone Duration** | +1 turn | +2 turns | +2 +1d4 | +2 +2d4 | +2 +3d4 | +2 +4d4 | +2 +5d4 | +2 +6d4 | +2 +7d4 | **+2 turns max**; surplus pips add **first‑tick +1d4** each |
| **Defense/Guard (Temp HP)** | +2 THP | +4 THP | +6 THP | +8 THP | +10 THP | +12 THP | +14 THP | +16 THP | +18 THP | THP still = `Prof + CON + flat`; **replace**, don’t stack |
| **Control Save DC** | +1 DC | +2 DC | +3 DC | **+4 DC** | +4 DC +1d4 | +4 DC +2d4 | +4 DC +3d4 | +4 DC +4d4 | +4 DC +5d4 | **+4 DC max**; surplus adds minor damage |

**Spend limit formula:** `extra_pips_allowed = min(9, maxResource − BaseCost)` (with **maxResource = 11**).

---
# 7) Class Progression Template (1–20)
Use as a starting point. Swap EA beats for spell beats on casters.

| Lv | Template Beat |
|---|---|
| **1** | **Select Subclass**, grant Core Resource, 1–2 starter features (e.g., mark/shout/heal) |
| **2** | Style/Form specialisation (Fighting Style, Archetype passive) |
| **3** | **First Power Spike** (stances/aspects/attunement or 2nd core button) |
| **4** | **Feat** |
| **5** | **Extra Attack** (martial) or **Signature Spell Empower** (casters); triggers **Tier‑5** |
| **6** | Defensive sustain or class reroll |
| **7** | Upgrade to base feature (e.g., shouts add THP) |
| **8** | **Feat** |
| **9** | **Finisher** (class hallmark) |
| **10** | Engine/utility upgrade; **Tier‑10** gates |
| **11** | **Extra Attack (2)** (if supported) |
| **12** | **Feat** |
| **13** | **Mastery Node** (stance/aspect/attunement rider) |
| **14** | Encounter pacing perk (start with resource, refresh on crit, etc.) |
| **15** | **Subclass Keystone**; **Tier‑15** gates |
| **16** | **Feat** |
| **17** | Late utility/cooldown (party rally, capstone prep) |
| **18** | **Subclass Elite Upgrade** (signature 2‑turn window or big augment) |
| **19** | — (reserved for houserule feats; off by default) |
| **20** | **Class Capstone + Feat**; **Tier‑20** gates |

**Caster note:** Replace EA beats with slot/known progressions and a **signature empowerment** at 5/11.

---
# 8) Implementation Cookbook
## 8.1 File & Folder Skeleton
```
Mods/<mod.id>/meta.lsx
Public/<mod.id>/Localization/English/<mod.id>.xml
Public/<mod.id>/ClassDescriptions/ClassDescriptions.lsx
Public/<mod.id>/Progressions/Progressions.lsx
Public/<mod.id>/Lists/PassiveLists.lsx
Public/<mod.id>/Stats/Generated/Data/Status_<mod.id>_<Class>.txt
Public/<mod.id>/Stats/Generated/Data/Passive_<mod.id>_<Class>.txt
Public/<mod.id>/Stats/Generated/Data/Action_<mod.id>_<Class>.txt
Public/<mod.id>/Assets/Textures/Icons/Classes/<mod.id>.dds
README.md
```
**If subclassing a vanilla class:** add SCF injection script  
`Scripts/<mod.id>/SCF/<SUBCLASS_KEY>.lua` (register & inject at **Level 1**).

## 8.2 Progressions.lsx Nodes (common)
- **Level 1:** `SelectSubclass`, Core Resource, starter feature(s).  
- **Level 3:** Power Spike node.  
- **Feats:** Nodes at **4/8/12/16/20**.  
- **Tier Upgrades:** Hidden passives at **5/10/15/20** for opted‑in abilities.  
- **EA/Spell Empower:** 5 and 11 (martial) or caster beats.

## 8.3 Stats Authoring
- **SaveFormula:** `8 + Proficiency + Attribute(<Primary>)`.  
- **RiderDamage/Heal:** `Base + AttributeMod(<Primary>)` (or ½ mod as noted).  
- **TempHP:** `Proficiency + AttributeMod(Constitution)` (+flat by tier).  
- **AC:** flat `+X/−X`.  
- **Damage %:** single additive modifier applied once.  
- **Crit Range:** `CriticalRangeReduction(1)` etc.  
- **Upcasting:** Implement with sub‑actions or `ChoiceData` + `CostModifier` and per‑pip riders; cap at **11 total**.  
- **Tier Hooks:** Passive stacks that activate at level gates; ensure they toggle with stance/aspect swaps.

## 8.4 Localisation
- Handle format: `h;CLASS_<KEY>_FEATURE_<NAME>`.
- Tooltips must list **current scaling** and **next tier** (e.g., “At Lv15 → +2 attack, +2 AC”).  
- Upcast‑enabled actions show a mini **Base / +1 … +9** table with exact deltas.

---
# 9) Balance Guardrails
- **Action Budget:** Aim ≤ **9** combat actives per spec at cap (excl. basic attacks/stances).  
- **Burst Windows:** Max **two** big windows per spec; keep to **2–3 turns**; additive with other %; no nested multipliers.  
- **Defence vs Offence:** Defensive T20 mirrors Berserker T20 (e.g., **+5 AC/−50%** vs **−5 AC/+50%**).  
- **Heals & Temp HP:** Always CON‑based; refresh/replace instead of stacking.  
- **Control:** Saves use **8+Prof+Primary**; honour condition immunities.

---
# 10) QA Checklist (per class)
1. **Progressions:** L1 subclass selector present; feat nodes at 4/8/12/16/20.  
2. **Tiers:** Abilities that opt in gain/lose bonuses correctly at 5/10/15/20.  
3. **Stance/Aspect Lockout:** 1‑turn swap lockout; only one active.  
4. **Scaling:** DCs use Primary; Temp HP uses CON; AC changes are flat; % mods additive; flats applied before %.  
5. **Upcasting:** Picker caps at 11 total; radius ≤ 9 m; DoT duration ≤ +2; DC bonus ≤ +4 then converts to damage.  
6. **Tooltips:** Show current tier, next tier, and upcast rows.  
7. **Withers Flow:** Level through 1→3→5→10→15→20 checkpoints without errors.  
8. **Load Order:** New classes isolated; SCF only when subclassing vanilla.  
9. **Performance:** Prefer Stats passives over heavy OnHit scripts.

---
# 11) INIT Payload Template
```json
{
  "mod": {
    "id": "Author_ClassKey",
    "displayName": "Class Name",
    "author": "YourName",
    "version": "0.1.0",
    "languages": ["en"],
    "distribute": ["modio"],
    "power": "Vanilla-like",
    "rest": "Short",
    "bg3se": false,
    "icon": "placeholder",
    "repo": {"git": true, "packToMods": true}
  },
  "class": {
    "key": "CLASS_AUTHOR_KEY",
    "primary": "STR",
    "offstat": "CON",
    "resource": {
      "type": "pips",
      "name": "Rage/Focus/etc.",
      "max": 11,
      "shortRestFloor": 2
    },
    "stanceModel": "Battle/Defensive/Berserker or Aspects/Attunements",
    "caster": {"enabled": false}
  },
  "tiers": {
    "enabled": true,
    "levels": [5,10,15,20]
  }
}
```

---
# 12) Optional Systems (when applicable)
- **Pet/Companion Framework:** Family base blocks + level/proficiency scaling layered on top; command DC = 8+Prof+Primary. Tame/Stable/Codex flows can be enabled per class (e.g., Hunter).  
- **Vendor/Debug Pack:** For testing—level boosts, consumables, debug passives.

---
**This v1.3 document supersedes v1.0–v1.2.** Use it as the baseline for all new class blueprints; call out any deviations in the class’s “Global Deviations” box so QA can verify explicitly.
