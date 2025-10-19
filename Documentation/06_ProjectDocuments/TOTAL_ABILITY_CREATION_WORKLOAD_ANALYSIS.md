# Total Ability Creation Workload Analysis

**Date:** October 17, 2025  
**Purpose:** Comprehensive analysis of how many NEW abilities need to be created across all 5 pools for all 3 subclasses  
**Method:** Best-guess analysis based on existing implementation and design documents

---

## Executive Summary

**Current Status (v1.0.0.3):**
- ✅ **12 SubclassBase abilities**: ALL EXIST (Whirlwind, Slam, Shield Slam, Hamstring, Victory Rush, Execute, Heroic Throw, Charge, Pummel, Battle Shout, Berserker Rage, Taunt)
- ✅ **Base class features**: Rage system, Extra Attack, core mechanics
- ✅ **Some Pool 2/4/5 abilities**: Partial implementation (~30-40% complete)

**v2.0 Requirements:**
- **Pool 1 (Class Talents):** 24+ talents needed (10 rows × ~2-3 options per row)
- **Pool 2 (SubclassSpec):** 72+ talents needed (24 per spec × 3 specs)
- **Pool 3 (SubclassBase):** 0 new abilities (all exist, just reorder grants)
- **Pool 4/5 (Specializations):** 54+ talents needed (9 per spec × 6 specializations)

**Total NEW Abilities Needed:** ~150-180 abilities across all files

---

## Detailed Breakdown by Pool

### Pool 1: Class Talents (Shared by All Specs)

**Total Rows:** 10  
**Options per Row:** Average 2-3  
**Total Talents:** ~24-30 abilities

| Row | Level | Talents | Status | Work Needed |
|-----|-------|---------|--------|-------------|
| **Row 1** | L1 | 3 options: Charge \| Heroic Leap \| Intervene | ✅ Charge EXISTS<br>❌ Heroic Leap NEW<br>❌ Intervene NEW | 2 NEW |
| **Row 2** | L1 | 3 options: Battle Shout \| Commanding Shout \| Rallying Cry | ✅ Battle Shout EXISTS<br>❌ Commanding Shout NEW<br>❌ Rallying Cry NEW | 2 NEW |
| **Row 3** | L2 | 3 options: Berserker Rage \| Die by the Sword \| Defensive Stance | ✅ Berserker Rage EXISTS<br>❌ Die by the Sword NEW<br>❌ Defensive Stance NEW | 2 NEW |
| **Row 4** | L3 | 3 options: Enrage \| Unbridled Fury \| Focused Rage | ❌ All 3 NEW | 3 NEW |
| **Row 5** | L4 | 3 options: Victory Rush \| Impending Victory \| Second Wind | ✅ Victory Rush EXISTS<br>❌ Impending Victory NEW<br>❌ Second Wind NEW | 2 NEW |
| **Row 6** | L5 | 3 options: Pummel \| Spell Reflection \| Intimidating Shout | ✅ Pummel EXISTS<br>❌ Spell Reflection NEW<br>❌ Intimidating Shout NEW | 2 NEW |
| **Row 7** | L6 | 3 options: Whirlwind \| Thunder Clap \| Cleave | ✅ Whirlwind EXISTS<br>✅ Thunder Clap EXISTS<br>❌ Cleave NEW | 1 NEW |
| **Row 8** | L7 | 3 options: Juggernaut \| War Machine \| Bounding Stride | ❌ All 3 NEW | 3 NEW |
| **Row 9** | L8 | 3 options: Avatar \| Recklessness \| Bladestorm | ✅ Avatar EXISTS<br>❌ Recklessness NEW<br>❌ Bladestorm NEW | 2 NEW |
| **Row 10** | L9 | 3 options: Intervene \| Rallying Cry \| Commanding Presence | ❌ All 3 NEW (variants) | 3 NEW |

**Pool 1 Totals:**
- **Total Talents:** 30
- **Existing:** 8 (Charge, Battle Shout, Berserker Rage, Victory Rush, Pummel, Whirlwind, Thunder Clap, Avatar)
- **NEW Needed:** 22 abilities

**File Breakdown:**
- **Spell_Target.txt:** ~8 new entries
- **Spell_Shout.txt:** ~4 new entries
- **Spell_Zone.txt:** ~3 new entries
- **Spell_Jump.txt:** ~2 new entries
- **Status_BOOST.txt:** ~15 new entries (buffs/debuffs)
- **Passive.txt:** ~5 new entries (passive wrappers)

---

### Pool 2: SubclassSpec Talents (Spec-Specific)

**Total Rows per Spec:** 10  
**Options per Row:** Average 2-3  
**Total Talents per Spec:** ~24-30 abilities  
**Total for 3 Specs:** ~72-90 abilities

#### Arms SubclassSpec (10 Rows)

| Row | Level | Talents | Status | Work Needed |
|-----|-------|---------|--------|-------------|
| **Row 1** | L3 | Mortal Strike \| Overpower \| Rend | ❌ Mortal Strike NEW<br>❌ Overpower NEW<br>❌ Rend NEW | 3 NEW |
| **Row 2** | L4 | Colossus Smash \| Warbreaker \| Cleave | ✅ Colossus Smash EXISTS<br>❌ Warbreaker NEW<br>❌ Cleave NEW | 2 NEW |
| **Row 3** | L5 | Sweeping Strikes \| Cleave Enh \| Rend Mastery | ❌ All 3 NEW | 3 NEW |
| **Row 4** | L6 | Deep Wounds \| Sudden Death \| Massacre | ❌ All 3 NEW | 3 NEW |
| **Row 5** | L7 | Shockwave \| Storm Bolt \| Demoralizing Shout | ✅ Shockwave EXISTS<br>❌ Storm Bolt NEW<br>❌ Demoralizing Shout NEW | 2 NEW |
| **Row 6** | L8 | Executioner \| Sudden Death Exe \| Execute Mastery | ❌ All 3 NEW (Execute variants) | 3 NEW |
| **Row 7** | L9 | Sunder Armor \| Mortal Wounds \| Trauma | ✅ Sunder Armor EXISTS<br>❌ Mortal Wounds NEW<br>❌ Trauma NEW | 2 NEW |
| **Row 8** | L10 | Bladestorm \| Ravager \| Warbreaker Enh | ❌ All 3 NEW | 3 NEW |
| **Row 9** | L11 | Strength of Arms \| Test of Might \| Titanic Might | ❌ All 3 NEW | 3 NEW |
| **Row 10** | L12 | Avatar Enh \| Colossal Might \| Unbreakable Will | ❌ All 3 NEW | 3 NEW |

**Arms Total:** 27 new abilities

#### Fury SubclassSpec (10 Rows)

| Row | Level | Talents | Status | Work Needed |
|-----|-------|---------|--------|-------------|
| **Row 1** | L3 | Bloodthirst \| Raging Blow \| Rampage | ✅ Bloodthirst EXISTS<br>✅ Raging Blow EXISTS<br>❌ Rampage NEW | 1 NEW |
| **Row 2** | L4 | Enrage \| Bloodbath \| Frenzy | ❌ All 3 NEW | 3 NEW |
| **Row 3** | L5 | Onslaught \| Siegebreaker \| Bladestorm | ❌ All 3 NEW | 3 NEW |
| **Row 4** | L6 | Fresh Meat \| Meat Cleaver \| Warpaint | ❌ All 3 NEW | 3 NEW |
| **Row 5** | L7 | Cruelty \| Sudden Death \| Cold Steel Hot Blood | ❌ All 3 NEW | 3 NEW |
| **Row 6** | L8 | Hack and Slash \| Improved Whirlwind \| Dragon Roar | ❌ All 3 NEW | 3 NEW |
| **Row 7** | L9 | Reckless Abandon \| Anger Management \| Tenderize | ❌ All 3 NEW | 3 NEW |
| **Row 8** | L10 | Crushing Blow \| Seethe \| Frothing Berserker | ❌ All 3 NEW | 3 NEW |
| **Row 9** | L11 | Slaughterhouse \| Odyn's Fury \| Titanic Rage | ❌ All 3 NEW | 3 NEW |
| **Row 10** | L12 | Recklessness Enh \| Anger Mgmt+ \| Bloodcraze | ❌ All 3 NEW | 3 NEW |

**Fury Total:** 28 new abilities

#### Protection SubclassSpec (10 Rows)

| Row | Level | Talents | Status | Work Needed |
|-----|-------|---------|--------|-------------|
| **Row 1** | L3 | Shield Slam \| Revenge \| Ignore Pain | ✅ Shield Slam EXISTS<br>✅ Revenge EXISTS<br>❌ Ignore Pain NEW | 1 NEW |
| **Row 2** | L4 | Shield Block \| Last Stand \| Devastate | ❌ All 3 NEW | 3 NEW |
| **Row 3** | L5 | Ravager \| Shockwave \| Thunder Clap | ✅ All 3 EXIST | 0 NEW |
| **Row 4** | L6 | Into the Fray \| Heavy Repercussions \| Punish | ❌ All 3 NEW | 3 NEW |
| **Row 5** | L7 | Anger Management \| Booming Voice \| Juggernaut | ❌ All 3 NEW | 3 NEW |
| **Row 6** | L8 | Indomitable \| Shield Wall \| Demoralizing Shout | ❌ All 3 NEW | 3 NEW |
| **Row 7** | L9 | Revenge+ \| Devastate+ \| Shield Charge | ❌ All 3 NEW | 3 NEW |
| **Row 8** | L10 | Bastion of Defense \| Best Served Cold \| Unstoppable Force | ❌ All 3 NEW | 3 NEW |
| **Row 9** | L11 | Bolster \| Neverending Rage \| Endurance Training | ❌ All 3 NEW | 3 NEW |
| **Row 10** | L12 | Unbreakable Will \| Immovable Object \| Colossus | ❌ All 3 NEW | 3 NEW |

**Protection Total:** 25 new abilities

**Pool 2 Totals (All 3 Specs):**
- **Total Talents:** 80
- **Existing:** 7 (Colossus Smash, Shockwave, Sunder Armor, Bloodthirst, Raging Blow, Shield Slam, Revenge, Ravager, Thunder Clap)
- **NEW Needed:** 73 abilities

**File Breakdown:**
- **Spell_Target.txt:** ~35 new entries
- **Spell_Shout.txt:** ~10 new entries
- **Spell_Zone.txt:** ~15 new entries
- **Status_BOOST.txt:** ~40 new entries (buffs/debuffs)
- **Passive.txt:** ~20 new entries

---

### Pool 3: SubclassBase (Baseline Abilities)

**Total Abilities:** 12 (same for all specs, just different unlock order)

| Ability | Status | Work Needed |
|---------|--------|-------------|
| Whirlwind | ✅ EXISTS (`Zone_WAR_Whirlwind`) | 0 NEW |
| Slam | ✅ EXISTS (`Target_WAR_Slam`) | 0 NEW |
| Shield Slam | ✅ EXISTS (`Target_WAR_ShieldSlam`) | 0 NEW |
| Hamstring | ✅ EXISTS (`Target_WAR_Hamstring`) | 0 NEW |
| Victory Rush | ✅ EXISTS (`Target_WAR_VictoryRush`) | 0 NEW |
| Execute | ✅ EXISTS (`Target_WAR_Execute`) | 0 NEW |
| Heroic Throw | ✅ EXISTS (`Projectile_WAR_HeroicThrow`) | 0 NEW |
| Charge | ✅ EXISTS (`Target_WAR_Charge`) | 0 NEW |
| Pummel | ✅ EXISTS (`Target_WAR_Pummel`) | 0 NEW |
| Battle Shout | ✅ EXISTS (`Shout_WAR_BattleShout`) | 0 NEW |
| Berserker Rage | ✅ EXISTS (`Target_WAR_BerserkerRage`) | 0 NEW |
| Taunt | ✅ EXISTS (`Target_WAR_Taunt`) | 0 NEW |

**Pool 3 Totals:**
- **Total Abilities:** 12
- **Existing:** 12 (100%)
- **NEW Needed:** 0 abilities ✅

**Implementation Work:** Only Progressions.lsx updates (different unlock levels per spec)

---

### Pool 4/5: Specializations (Hero Talents L13-20)

**Total Specializations:** 6 (Mountain Thane ×2, Colossus ×2, Slayer ×2)  
**Talents per Specialization:** 9 (1 Keystone + 3 Choice Nodes × 3 options + 3 Passives + 1 Capstone)  
**Total Talents:** ~54 abilities

#### Mountain Thane (Arms + Fury variants)

| Tier | Talents | Status | Work Needed |
|------|---------|--------|-------------|
| **Keystone (L13)** | Avatar of the Storm + Thunder Blast | ❌ Thunder Blast NEW | 1 NEW |
| **Passive 1 (L14)** | Steadfast as the Peaks | ❌ NEW | 1 NEW |
| **Choice 1 (L15)** | Storm Strike \| Avatar's Thunderbolt \| Lightning Rod | ❌ All 3 NEW | 3 NEW |
| **Passive 2 (L16)** | Thorim's Might | ❌ NEW | 1 NEW |
| **Choice 2 (L17)** | Burst of Power \| Storm Bolts \| Thunder Surge | ❌ All 3 NEW | 3 NEW |
| **Passive 3 (L18)** | Lightning Strikes | ❌ NEW | 1 NEW |
| **Choice 3 (L19)** | Flashing Skies \| Stormbreaker \| Avatar of Thunder | ❌ All 3 NEW | 3 NEW |
| **Capstone (L20)** | Gathering Storms | ❌ NEW | 1 NEW |

**Mountain Thane Total:** 14 new abilities (some shared between variants)

#### Colossus (Arms + Protection variants)

| Tier | Talents | Status | Work Needed |
|------|---------|--------|-------------|
| **Keystone (L13)** | Demolish + Colossal Might | ❌ Demolish NEW | 1 NEW |
| **Passive 1 (L14)** | Unshakable | ❌ NEW | 1 NEW |
| **Choice 1 (L15)** | One-Handed Spec \| Practiced Strikes \| Shield Mastery | ❌ All 3 NEW | 3 NEW |
| **Passive 2 (L16)** | Unyielding | ❌ NEW | 1 NEW |
| **Choice 2 (L17)** | Crashing Chaos \| Impassable Wall \| Bulwark | ❌ All 3 NEW | 3 NEW |
| **Passive 3 (L18)** | Concussive Blows | ❌ NEW | 1 NEW |
| **Choice 3 (L19)** | No Quarter \| Mountain of Steel \| Fortress | ❌ All 3 NEW | 3 NEW |
| **Capstone (L20)** | Dominance of the Colossus | ❌ NEW | 1 NEW |

**Colossus Total:** 14 new abilities

#### Slayer (Arms + Fury variants)

| Tier | Talents | Status | Work Needed |
|------|---------|--------|-------------|
| **Keystone (L13)** | Slayer's Dominance | ❌ NEW | 1 NEW |
| **Passive 1 (L14)** | Imminent Demise | ❌ NEW | 1 NEW |
| **Choice 1 (L15)** | Culling Cyclone \| Opportunist \| Execute Enh | ❌ All 3 NEW | 3 NEW |
| **Passive 2 (L16)** | Brutal Finish | ❌ NEW | 1 NEW |
| **Choice 2 (L17)** | Unrelenting Onslaught \| Death Blow \| Merciless | ❌ All 3 NEW | 3 NEW |
| **Passive 3 (L18)** | Fierce Followthrough | ❌ NEW | 1 NEW |
| **Choice 3 (L19)** | Vicious Agility \| Stunning Assault \| Reaper | ❌ All 3 NEW | 3 NEW |
| **Capstone (L20)** | Slayer's Malice | ❌ NEW | 1 NEW |

**Slayer Total:** 14 new abilities

**Pool 4/5 Totals:**
- **Total Talents:** 42 unique abilities (some variants share mechanics)
- **Existing:** 2 (Avatar exists, some Execute variants exist)
- **NEW Needed:** 40 abilities

**File Breakdown:**
- **Spell_Target.txt:** ~10 new entries
- **Spell_Zone.txt:** ~8 new entries
- **Status_BOOST.txt:** ~25 new entries (specialization buffs)
- **Passive.txt:** ~30 new entries (keystones, passives, capstones)

---

## Grand Totals: All Pools Combined

### Summary by Pool

| Pool | Description | Total Talents | Existing | NEW Needed | % Complete |
|------|-------------|---------------|----------|------------|------------|
| **Pool 1** | Class Talents | 30 | 8 | 22 | 27% |
| **Pool 2** | SubclassSpec (All 3) | 80 | 7 | 73 | 9% |
| **Pool 3** | SubclassBase | 12 | 12 | 0 | 100% ✅ |
| **Pool 4/5** | Specializations (All 6) | 42 | 2 | 40 | 5% |
| **TOTAL** | **All Pools** | **164** | **29** | **135** | **18%** |

### Summary by File Type

| File Type | Current Entries | NEW Needed | Total After v2.0 | Estimated Time |
|-----------|----------------|------------|------------------|----------------|
| **Spell_Target.txt** | ~40 | +53 | ~93 | 40 hours |
| **Spell_Shout.txt** | ~5 | +14 | ~19 | 10 hours |
| **Spell_Zone.txt** | ~10 | +26 | ~36 | 20 hours |
| **Spell_Jump.txt** | ~2 | +2 | ~4 | 2 hours |
| **Spell_Projectile.txt** | ~2 | +5 | ~7 | 4 hours |
| **Status_BOOST.txt** | ~30 | +80 | ~110 | 60 hours |
| **Passive.txt** | ~20 | +55 | ~75 | 40 hours |
| **Progressions.lsx** | ~200 lines | +2000 lines | ~2200 lines | 50 hours |
| **English.loca.xml** | ~100 handles | +270 handles | ~370 handles | 20 hours |
| **TOTAL** | | | | **~246 hours** |

---

## Implementation Priorities

### Phase 1: Core Rotation (HIGH PRIORITY - 60 hours)

**Goal:** Make each spec playable with basic rotation

**Pool 1 (Class):**
- Row 1: Heroic Leap, Intervene (2)
- Row 2: Commanding Shout, Rallying Cry (2)
- Row 3: Die by the Sword, Defensive Stance (2)
- **Subtotal:** 6 abilities

**Pool 2 (SubclassSpec):**
- **Arms:** Mortal Strike, Overpower, Rend, Colossus Smash variants (8)
- **Fury:** Rampage, Enrage, Onslaught, Bloodbath (8)
- **Protection:** Ignore Pain, Shield Block, Last Stand, Devastate (8)
- **Subtotal:** 24 abilities

**Pool 4/5 (Specializations):**
- All 6 Keystones (Thunder Blast, Demolish, Slayer's Dominance ×2 variants) (6)
- **Subtotal:** 6 abilities

**Phase 1 Total:** 36 abilities, ~60 hours

---

### Phase 2: Major Cooldowns (MEDIUM PRIORITY - 80 hours)

**Goal:** Add impactful talents and major cooldowns

**Pool 1 (Class):**
- Row 4: Enrage, Unbridled Fury, Focused Rage (3)
- Row 6: Spell Reflection, Intimidating Shout (2)
- Row 8: Juggernaut, War Machine, Bounding Stride (3)
- Row 9: Recklessness, Bladestorm (2)
- **Subtotal:** 10 abilities

**Pool 2 (SubclassSpec):**
- **Arms:** Sweeping Strikes, Deep Wounds, Shockwave variants, Bladestorm (10)
- **Fury:** Siegebreaker, Meat Cleaver, Hack and Slash, Odyn's Fury (10)
- **Protection:** Into the Fray, Heavy Repercussions, Shield Wall, Indomitable (10)
- **Subtotal:** 30 abilities

**Pool 4/5 (Specializations):**
- All Choice Node 1 talents (3 per spec × 6 specs = 18)
- **Subtotal:** 18 abilities

**Phase 2 Total:** 58 abilities, ~80 hours

---

### Phase 3: Polish & Variants (LOW PRIORITY - 106 hours)

**Goal:** Complete all remaining talents

**Pool 1 (Class):**
- Remaining Row 5, 7, 10 variants (6)
- **Subtotal:** 6 abilities

**Pool 2 (SubclassSpec):**
- All remaining row variants (19)
- **Subtotal:** 19 abilities

**Pool 4/5 (Specializations):**
- All passives (3 per spec × 6 = 18)
- All Choice Node 2 & 3 talents (6 per spec × 6 = 36)
- All Capstones (6)
- **Subtotal:** 60 abilities

**Phase 3 Total:** 85 abilities, ~106 hours

---

## Detailed Time Estimates by Task Type

### Ability Creation (Per Ability Type)

| Ability Type | Avg Time | Count | Total Time |
|--------------|----------|-------|------------|
| **Simple Spell** (damage only) | 20 min | 40 | 13 hours |
| **Complex Spell** (damage + status) | 45 min | 30 | 23 hours |
| **AoE Spell** (Zone/Shout) | 30 min | 26 | 13 hours |
| **Status Effect** (buff/debuff) | 30 min | 80 | 40 hours |
| **Passive** (wrapper or mechanic) | 45 min | 55 | 41 hours |
| **Progression Entry** | 15 min | 135 | 34 hours |
| **Localization** (2 handles per ability) | 5 min | 270 | 23 hours |
| **Testing & Balance** | 1 hour | 135 | 135 hours |
| **Bug Fixes** | 20% of total | - | 60 hours |
| **GRAND TOTAL** | | | **~382 hours** |

**Realistic with efficiency gains:** ~**300-350 hours** (copy-paste, templates, batch operations)

---

## Risk Assessment

### High Risk Areas

**1. Progressions.lsx Complexity**
- **Risk:** 20 levels × 3 subclasses × 5 pools = complex nesting
- **Mitigation:** Create template per level, test incrementally
- **Time Buffer:** +20 hours

**2. Status Effect Interactions**
- **Risk:** 80+ statuses, potential conflicts/bugs
- **Mitigation:** Unique StatusIds, careful RemoveEvents
- **Time Buffer:** +30 hours

**3. Passive Dependencies**
- **Risk:** Talents that modify other abilities need proper conditions
- **Mitigation:** Use HasPassive() checks, test all combinations
- **Time Buffer:** +25 hours

**4. Specialization Choice System**
- **Risk:** L13 choice between 2 trees, must lock out other tree
- **Mitigation:** Use Progressions with Requirements
- **Time Buffer:** +15 hours

**Total Risk Buffer:** +90 hours

---

## BG3 Engine Constraints (Best Guess Analysis)

### Known Constraints

**1. SelectPassives Amount Limit**
- **Constraint:** Likely max 12-15 options per SelectPassives node
- **Impact:** Class/Spec rows with 3 options = safe ✅
- **Workaround:** If needed, split into multiple choice nodes

**2. Progression Node Nesting**
- **Constraint:** Deep nesting (5+ levels) may cause issues
- **Impact:** Each level has multiple pools = complex structure
- **Workaround:** Flatten structure, use separate Progression nodes per pool

**3. Passive Wrapper Requirement**
- **Constraint:** Talents must be Passives (not direct spell unlocks in SelectPassives)
- **Impact:** Need 135 passive wrappers
- **Workaround:** Create `WAR_Talent_AbilityName` → `UnlockSpell(Spell_AbilityName)`

**4. UI Display Limits**
- **Constraint:** Character sheet may not display 45+ abilities cleanly
- **Impact:** Visual clutter, hard to find abilities
- **Workaround:** Use categories, hide baseline abilities from "Talents" view

**5. Status Effect Cap**
- **Constraint:** Unknown limit on simultaneous statuses
- **Impact:** Warriors may have 10+ buffs active (Rage, Colossal Might, etc.)
- **Workaround:** Use StackTypes wisely, avoid permanent buffs

### Confidence Levels

| Constraint | Confidence | Evidence |
|------------|-----------|----------|
| SelectPassives ≤12 options | 🟢 High | Standard BG3 pattern |
| Passive wrapper required | 🟢 High | BG3 modding best practice |
| Deep nesting issues | 🟡 Medium | Speculation based on XML complexity |
| UI display limits | 🟡 Medium | Observed in vanilla classes |
| Status effect cap | 🔴 Low | No evidence, pure speculation |

---

## Recommended Implementation Strategy

### Approach: Iterative Development

**Iteration 1: Single Spec Prototype (80 hours)**
- Implement Arms only
- Pool 1: 6 talents (core)
- Pool 2: 10 talents (Arms core)
- Pool 3: 12 abilities (already exist)
- Pool 4: 1 specialization (Colossus - 9 talents)
- **Goal:** Prove 5-pool system works in BG3

**Iteration 2: Expand to All Specs (100 hours)**
- Add Fury and Protection
- Complete Pool 1 for all specs (30 talents)
- Complete Pool 2 for Fury + Protection (50 talents)
- Add remaining 5 specializations (42 talents)
- **Goal:** All 3 specs playable L1-L20

**Iteration 3: Polish & Balance (120 hours)**
- Add remaining variants (all remaining talents)
- Balance testing
- Bug fixes
- Documentation
- **Goal:** v2.0 release quality

**Total Time (Iterative):** 300 hours (~7-8 weeks full-time or ~15 weeks part-time)

---

## Conclusion

**Total NEW Abilities Needed:** 135 across all files  
**Estimated Implementation Time:** 300-350 hours  
**Current Completion:** 18% (29 of 164 abilities exist)

**Key Insights:**
- ✅ **Pool 3 is 100% complete** - No new baseline abilities needed!
- ❌ **Pool 2 needs the most work** - 73 new spec-specific talents
- ⚠️ **Pool 4/5 is unknown territory** - Specialization system untested in BG3

**Recommended Next Steps:**
1. Create Arms prototype (Pool 1 core + Pool 2 Arms + 1 Specialization) - 80 hours
2. Test in-game to validate 5-pool system feasibility
3. If successful, expand to all specs - 220 hours
4. If issues, revise design and iterate

**Status:** Ready for prototype phase

---

**Last Updated:** October 17, 2025  
**Analysis Method:** Best-guess based on existing implementation + design docs  
**Confidence Level:** 🟢 High for ability counts, 🟡 Medium for time estimates, 🟡 Medium for BG3 constraints
