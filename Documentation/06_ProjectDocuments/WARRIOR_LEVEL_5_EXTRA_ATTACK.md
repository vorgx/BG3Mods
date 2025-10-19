# Warrior Level 5: Extra Attack - Complete Implementation Guide

**Date:** October 17, 2025  
**BG3 Version:** Patch 8 (v4.8.0.10+)  
**Implementation Status:** ✅ Core BG3 Feature (Auto-Granted)

---

## Table of Contents

- [Overview](#overview)
- [BG3 Core Mechanic](#bg3-core-mechanic)
- [Implementation Details](#implementation-details)
- [Warrior-Specific Interactions](#warrior-specific-interactions)
- [Testing Checklist](#testing-checklist)
- [Compatibility](#compatibility)

---

## Overview

**Extra Attack** is a core BG3/D&D 5e mechanic granted to all martial classes at **Level 5**. When a Warrior takes the **Attack** action, they can attack **twice** instead of once.

### Key Facts

- **Granted At:** Level 5 (all Warriors - Arms, Fury, Protection)
- **Type:** Passive Feature (auto-granted, no player choice required)
- **Effect:** Double attacks when using Attack action
- **Standard:** Shared with Fighter, Barbarian, Ranger, Paladin, Monk
- **Balance:** Matches casters' Level 3 spell power spike (Fireball, etc.)

---

## BG3 Core Mechanic

### What Is Extra Attack?

**Extra Attack** allows martial characters to make **2 weapon attacks** instead of 1 when they take the **Attack** action on their turn.

### How It Works

1. **Player selects "Attack" action** in combat UI
2. **First attack executes** using weapon + Strength modifier + proficiency bonus
3. **Second attack automatically available** immediately after first attack
4. **Both attacks use same modifiers** (to-hit and damage)
5. **Both attacks can hit same or different targets**
6. **Both attacks can trigger on-hit effects** (Rage generation, status effects, weapon enchantments)

### What It Does NOT Do

❌ **Does NOT apply to:**
- Bonus Action attacks (separate action economy)
- Reaction attacks (Opportunity Attacks)
- Special ability attacks (Heroic Strike, Mortal Strike, Execute)
- Spell attacks (Spell casting is not "Attack" action)
- Unarmed strikes using Ki (Monk-specific)

❌ **Does NOT stack with:**
- Additional Extra Attack features (Fighter gets 3rd attack at L11, Warriors do not)
- Dual-wielding bonus action attacks (separate mechanic)
- Haste spell (grants separate bonus action attack)

---

## Implementation Details

### Progressions.lsx Entry

**File:** `Data/Public/BG3Wow_.../Progressions.lsx`  
**Location:** Level 5 progression node

```xml
<node id="Progression">
    <attribute id="Level" type="uint8" value="5"/>
    <attribute id="Name" type="LSString" value="Warrior"/>
    <attribute id="ProgressionType" type="uint8" value="0"/>
    <attribute id="TableUUID" type="guid" value="[WARRIOR_PROGRESSION_TABLE_UUID]"/>
    <attribute id="UUID" type="guid" value="[LEVEL_5_PROGRESSION_UUID]"/>
    
    <!-- Extra Attack Feature -->
    <attribute id="PassivesAdded" type="LSString" value="ExtraAttack"/>
    
    <!-- Optional: Additional Level 5 features -->
    <attribute id="Boosts" type="LSString" value="ActionResource(ActionPoint,1,0)"/>
</node>
```

### Key Attributes

| Attribute | Value | Purpose |
|-----------|-------|---------|
| `PassivesAdded` | `"ExtraAttack"` | Grants the Extra Attack passive feature |
| `Level` | `5` | Level at which feature is granted |
| `Boosts` | `ActionResource(...)` | Optional: Additional resources/bonuses |

### BG3 Built-In Passive

**Passive ID:** `ExtraAttack`  
**Type:** Built-in BG3 passive (defined in GustavDev, not mod)  
**Implementation:** Automatically doubles Attack action attacks

**You do NOT need to create:**
- ❌ Custom passive definition
- ❌ Custom spell entry
- ❌ Custom status effect

**You ONLY need to:**
- ✅ Add `PassivesAdded="ExtraAttack"` to Level 5 progression

---

## Warrior-Specific Interactions

### Compatible Warrior Abilities

#### ✅ Works With (Attack Action)

**Weapon Attacks:**
- Basic melee attacks (greatsword, dual-wield, sword+board)
- Basic ranged attacks (thrown weapons, Heroic Throw if basic attack)
- Charge → Attack (gap closer, then 2 attacks)
- Thunder Clap → Attack (AoE, then 2 attacks)

**Interactions:**
- **Rage Generation:** Both attacks generate Rage (+10 per hit = +20 total)
- **On-Hit Effects:** Weapon enchantments, status effects apply on both attacks
- **Critical Hits:** Each attack rolls separately (2 chances to crit)
- **Bleeding Effects:** Rend/Deep Wounds can apply on either attack

#### ❌ Does NOT Affect (Special Abilities)

**Warrior Special Abilities:**
- Heroic Strike (20 Rage, single attack)
- Mortal Strike (30 Rage, single attack)
- Execute (20 Rage, single attack)
- Bloodthirst (25 Rage, single attack + heal)
- Shield Slam (single attack)
- Overpower (single attack)
- Rampage (Fury multi-hit, separate mechanic)

**Why?** These are **special ability actions**, not the base "Attack" action. Extra Attack only applies to the standard Attack action button.

### Subclass-Specific Notes

#### Arms Warrior

**Synergies:**
- ✅ Extra Attack → Mortal Strike (2 attacks build Rage, then spend on Mortal Strike)
- ✅ Extra Attack → Overpower (same Rage economy loop)
- ✅ Rend application (apply bleed on first attack, stack on second)
- ✅ Colossus Smash (debuff on first attack, exploit on second)

**Rotation Example:**
1. Attack (1st) → +10 Rage, apply Rend
2. Attack (2nd) → +10 Rage, Rend ticking
3. Mortal Strike (30 Rage) → Big damage with Rend active

#### Fury Warrior

**Synergies:**
- ✅ Extra Attack → Bloodthirst (2 attacks build Rage, then heal+damage)
- ✅ Enrage triggers (more chances to Enrage on crit)
- ✅ Rampage setup (build Rage for Rampage finisher)
- ✅ Dual-wield builds (2 main-hand attacks + bonus action off-hand)

**Rotation Example:**
1. Attack (1st) → +10 Rage
2. Attack (2nd) → +10 Rage, Enrage on crit
3. Bloodthirst (25 Rage) → Heal + damage

#### Protection Warrior

**Synergies:**
- ✅ Extra Attack → Shield Slam (2 attacks generate Rage for Shield Slam)
- ✅ Revenge procs (more attacks = more dodge/parry chances for free Revenge)
- ✅ Brace for Impact (2 blocks = 2 stacks)
- ✅ Shield Block uptime (Rage generation for Ignore Pain)

**Rotation Example:**
1. Attack (1st) → +10 Rage
2. Attack (2nd) → +10 Rage, trigger Revenge proc
3. Revenge (0 Rage from proc) → AoE damage

---

## Testing Checklist

### Pre-Implementation

- [ ] Verify `ExtraAttack` passive exists in GustavDev (BG3 base game)
- [ ] Confirm Level 5 progression node exists in Progressions.lsx
- [ ] Check no conflicting mods modify Level 5 progression

### Post-Implementation

#### Basic Functionality

- [ ] Level 4 Warrior: Attack action = 1 attack ✅
- [ ] Level 5 Warrior: Attack action = 2 attacks ✅
- [ ] Both attacks use same modifiers (to-hit, damage) ✅
- [ ] Both attacks can target different enemies ✅
- [ ] Both attacks generate Rage (+10 each = +20 total) ✅

#### Ability Interactions

- [ ] Mortal Strike: Still 1 attack (not doubled) ✅
- [ ] Execute: Still 1 attack (not doubled) ✅
- [ ] Heroic Strike: Still 1 attack (not doubled) ✅
- [ ] Charge → Attack: Charge + 2 attacks ✅
- [ ] Weapon enchantments: Apply on both attacks ✅

#### Edge Cases

- [ ] Dual-wielding: 2 main-hand + 1 bonus action off-hand ✅
- [ ] Haste spell: Extra Attack + Haste bonus action attack ✅
- [ ] Stunning Strike/Disarm: Can trigger on either attack ✅
- [ ] Miss/Hit split: First attack misses, second can hit ✅
- [ ] Critical hit: Each attack rolls independently ✅

#### UI/UX

- [ ] Tooltip shows "Extra Attack" in character sheet ✅
- [ ] Combat log shows 2 separate attack rolls ✅
- [ ] Animation plays for both attacks ✅
- [ ] Camera follows both attacks correctly ✅

---

## Compatibility

### Vanilla BG3 Classes with Extra Attack

| Class | Level Granted | Notes |
|-------|---------------|-------|
| **Fighter** | 5 (11 for 3rd attack) | Standard |
| **Barbarian** | 5 | Standard |
| **Ranger** | 5 | Standard |
| **Paladin** | 5 | Standard |
| **Monk** | 5 | Standard |
| **Warrior (Mod)** | 5 | ✅ Same as vanilla |

### Mod Compatibility

**✅ Compatible With:**
- Weapon mods (extra damage, enchantments)
- Feat mods (Great Weapon Master, etc.)
- Multiclass mods (if Warrior/Fighter multiclass, no stacking)
- UI mods (action bar, tooltips)

**⚠️ Potential Conflicts:**
- Other Warrior class mods (duplicate Level 5 progression)
- Mods that modify base Attack action
- Mods that grant additional Extra Attack features (stacking issues)

**Resolution:** Mod load order - ensure BG3Wow Warrior loads last

---

## Troubleshooting

### Issue: Extra Attack Not Working

**Symptoms:** Still only 1 attack at Level 5+

**Causes:**
1. `PassivesAdded="ExtraAttack"` missing from Level 5 progression
2. Typo in passive name (case-sensitive: `ExtraAttack` not `extraattack`)
3. Progressions.lsx not loaded (mod not active)
4. Conflicting mod overrides Level 5 progression

**Fix:**
1. Verify Progressions.lsx entry
2. Check mod load order in BG3 Mod Manager
3. Disable conflicting mods
4. Reload save (progression changes require reload)

### Issue: Special Abilities Doubled

**Symptoms:** Mortal Strike, Execute, etc. hitting twice

**Cause:** Incorrect implementation (Extra Attack should ONLY affect Attack action, not special abilities)

**Fix:** 
- Extra Attack is passive feature, does not modify spell entries
- Ensure special abilities are defined as `SpellData` type, not weapon attacks
- Check Spell_Target.txt entries have correct `SpellType`

### Issue: Rage Generation Too High

**Symptoms:** Gaining 40+ Rage per Attack action

**Cause:** Rage generation stacking incorrectly

**Expected Behavior:** 
- 1 Attack action with Extra Attack = 2 attacks = +20 Rage total (+10 per hit)
- If gaining more, check for duplicate Rage generation boosts

**Fix:** Verify only one `RageGeneration` boost per attack in Status_BOOST.txt

---

## Implementation Summary

### Required Changes

**File:** `Progressions.lsx`  
**Location:** Level 5 progression node  
**Change:** Add `<attribute id="PassivesAdded" type="LSString" value="ExtraAttack"/>`

**That's it!** No other files need modification. Extra Attack is a built-in BG3 feature.

### Verification Command

```xml
<!-- Search Progressions.lsx for Level 5 node -->
<node id="Progression">
    <attribute id="Level" type="uint8" value="5"/>
    <!-- Should contain: -->
    <attribute id="PassivesAdded" type="LSString" value="ExtraAttack"/>
</node>
```

### Expected In-Game Behavior

1. **Level 1-4:** Attack action = 1 attack
2. **Level 5+:** Attack action = 2 attacks
3. **Special abilities:** Still 1 attack each (not affected)
4. **Rage generation:** +20 per Attack action (2 hits × +10)
5. **Character sheet:** "Extra Attack" listed in Features

---

## Additional Resources

### BG3 Documentation

- **Larian Modding Wiki:** Extra Attack implementation
- **GustavDev Passives:** `ExtraAttack` definition
- **D&D 5e SRD:** Extra Attack rules

### Related Warrior Documentation

- **`ARMS_WARRIOR_5_POOL_TALENT_SYSTEM.md`** - Full talent system with Level 5 milestone
- **`Warrior_Class_Blueprint.md`** - Complete class design
- **`Progressions.lsx`** - Full level progression table

---

## Conclusion

**Extra Attack at Level 5** is a **mandatory martial class feature** that doubles attack output to match caster power spikes. Implementation is **simple** (one line in Progressions.lsx) and **standard** (shared with all BG3 martial classes).

Warriors gain Extra Attack at Level 5 alongside:
- Subclass abilities
- Increased Rage generation
- Enhanced combat effectiveness

This feature is **critical** for maintaining balance with other classes and should **not be modified or removed**.

**Status:** ✅ **READY FOR IMPLEMENTATION**

---

**Last Updated:** October 17, 2025  
**Implementation Priority:** HIGH (Core Class Feature)  
**Estimated Implementation Time:** 5 minutes (one XML attribute)
