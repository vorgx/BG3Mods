# Warrior Mod - ACTUAL Current Progression Status

**Date**: October 19, 2025  
**Source**: `Tests/WARRIOR_BACKUP_BEFORE_TEMPLATE_20251018_183829/Public/.../Progressions/Progressions.lsx`  
**Status**: This is the REAL Warrior progression (before Warlock template was copied over)

---

## Critical Discovery

The **current Data/Public/Warrior_Wow.../Progressions.lsx** file contains **Warlock template content** (WoWWarlock, Demonology, Destruction, Affliction).

The **actual Warrior progression** is in the backup at:
`Tests/WARRIOR_BACKUP_BEFORE_TEMPLATE_20251018_183829/Public/BG3Wow_78fe4967-4e62-5491-d981-dd781acca4d7/Progressions/Progressions.lsx`

---

## Actual Warrior Progression Structure

### Base Class Progression (L1-20)

| Level | Abilities/Features | Notes |
|-------|-------------------|-------|
| 1 | Proficiencies, Rage (100), Skill selection (2) | `WAR_UnlockRage`, `WAR_RageGeneration` passives |
| 1 | Charge, Heroic Strike | Starting abilities |
| 2 | Battle Shout | Party buff |
| 3 | Execute | Low-HP finisher |
| 4 | Feat/ASI | `AllowImprovement` |
| 5 | Extra Attack | `ExtraAttack` passive |
| 6 | Defensive Stance | Damage reduction |
| 7 | Intimidating Shout | AoE fear |
| 8 | Feat/ASI | `AllowImprovement` |
| 9 | Heroic Leap | Gap closer/AoE |
| 10 | Rallying Cry | Party heal |
| 11 | Improved Extra Attack | Replaces `ExtraAttack` with `ImprovedExtraAttack` |
| 12 | Feat/ASI | `AllowImprovement` |
| 13 | Inspiring Presence | `WAR_InspiringPresence` passive |
| 14 | Hamstring | Slow/immobilize |
| 15 | Spell Reflection | Reflect spells |
| 16 | Feat/ASI | `AllowImprovement` |
| 17 | Die by the Sword | Parry |
| 18 | Indomitable | Save advantage |
| 19 | Avatar | Ultimate transformation |
| 20 | Feat/ASI | `AllowImprovement` |

### Arms Warrior Subclass (ProgressionType="1")

**TableUUID**: `2b3c4d5e-6f7a-8b9c-0d1e-2f3a4b5c6d7e`

| Level | Abilities/Passives | Notes |
|-------|-------------------|-------|
| 1 | Weapon Mastery | `WAR_ARMS_WeaponMastery` passive (+1 attack/damage with 2H) |
| 3 | Mortal Strike, Overpower | Signature Arms abilities |
| 5 | Tactical Mastery | `WAR_ARMS_TacticalMastery` passive |
| 7 | Colossus Smash | Armor shred |
| 9 | Sweeping Strikes | Cleave |
| 11 | Warbreaker | AoE finisher |
| 13 | (Empty - hero talent choice) | |
| 15 | (Empty - hero talent choice) | |
| 17 | (Empty - hero talent choice) | |
| 19 | (Empty - hero talent choice) | |
| **20** | **Hero Talent Capstone** | `IF(HasPassive('WAR_Colossus_Keystone')):ApplyStatus(SELF,WAR_Colossus_PreciseMight);IF(HasPassive('WAR_Slayer_Keystone')):ApplyStatus(SELF,WAR_Slayer_Malice)` |

### Fury Warrior Subclass (ProgressionType="1")

**TableUUID**: `4c5d6e7f-8a9b-0c1d-2e3f-4a5b6c7d8e9f`

| Level | Abilities/Passives | Notes |
|-------|-------------------|-------|
| 1 | Dual Wield Mastery | `WAR_FURY_DualWieldMastery` passive |
| 3 | Bloodthirst | Heal + damage ability |
| 5 | Rampage | Multi-hit ability |
| 6 | Enraged Regeneration | Healing ability |
| 9 | Raging Blow | Signature Fury attack |
| 11 | Bloodbath | `WAR_FURY_Bloodbath` passive |
| 13 | (Empty - hero talent choice) | |
| 15 | (Empty - hero talent choice) | |
| 17 | (Empty - hero talent choice) | |
| 19 | (Empty - hero talent choice) | |
| **20** | **Hero Talent Capstone** | `IF(HasPassive('WAR_MountainThane_Keystone')):ApplyStatus(SELF,WAR_MountainThane_GatheringStorms);IF(HasPassive('WAR_Slayer_Keystone')):ApplyStatus(SELF,WAR_Slayer_Malice)` |

### Protection Warrior Subclass (ProgressionType="1")

**TableUUID**: `6d7e8f9a-0b1c-2d3e-4f5a-6b7c8d9e0f1a`

| Level | Abilities/Passives | Notes |
|-------|-------------------|-------|
| 1 | Shield Specialization | `WAR_PROT_ShieldSpecialization` passive (+2 AC with shield) |
| 3 | Shield Slam, Shield Block, Taunt | Core tank abilities |
| 5 | Intervene | Gap closer/ally protection |
| 7 | Revenge, Last Stand | Reactive damage + defensive cooldown |
| 9 | Shield Wall | Major defensive cooldown |
| 11 | Shockwave | AoE stun |
| 13 | (Empty - hero talent choice) | |
| 15 | (Empty - hero talent choice) | |
| 17 | (Empty - hero talent choice) | |
| 19 | (Empty - hero talent choice) | |
| **20** | **Hero Talent Capstone** | `IF(HasPassive('WAR_MountainThane_Keystone')):ApplyStatus(SELF,WAR_MountainThane_GatheringStorms);IF(HasPassive('WAR_Colossus_Keystone')):ApplyStatus(SELF,WAR_Colossus_PreciseMight)` |

---

## Hero Talent Implementation (L13-L20)

### How It Works

The Warrior mod does **NOT** use separate hero talent progression tables like Warlock. Instead:

1. **L13-L19**: Empty progression nodes (placeholder for choices to be added)
2. **L20**: Conditional passive application based on keystone passive

**L20 Pattern**:
```xml
<attribute id="PassivesAdded" type="LSString" value="IF(HasPassive('WAR_Colossus_Keystone')):ApplyStatus(SELF,WAR_Colossus_PreciseMight);IF(HasPassive('WAR_Slayer_Keystone')):ApplyStatus(SELF,WAR_Slayer_Malice)"/>
```

This means:
- **IF player has Colossus keystone passive** → Apply `WAR_Colossus_PreciseMight` status
- **IF player has Slayer keystone passive** → Apply `WAR_Slayer_Malice` status

### Hero Talent Availability

| Base Subclass | Hero Option 1 | Hero Option 2 |
|---------------|---------------|---------------|
| **Arms** | Colossus (3-tier) | Slayer (3-tier) |
| **Fury** | Mountain Thane (4-tier) | Slayer (3-tier) |
| **Protection** | Mountain Thane (4-tier) | Colossus (3-tier) |

### Missing Implementation

The current Progressions.lsx has **EMPTY** nodes for L13, L15, L17, L19 for all three subclasses:

```xml
<node id="Progression">
    <attribute id="Level" type="uint8" value="13" />
    <attribute id="Name" type="LSString" value="Arms Warrior" />
    <attribute id="ProgressionType" type="uint8" value="1" />
    <attribute id="TableUUID" type="guid" value="2b3c4d5e-6f7a-8b9c-0d1e-2f3a4b5c6d7e" />
    <attribute id="UUID" type="guid" value="5d6e7f8a-9b0c-1d2e-3f4a-5b6c7d8e9f0a" />
    <children>
    </children>
</node>
```

**These need to be filled with**:
- **L13**: Keystone passive grant + hero talent specialization choice (SelectPassives)
- **L15**: Choice node (SelectPassives)
- **L17**: Choice node (SelectPassives)
- **L19**: Choice node (SelectPassives)

---

## Revised List Structure Requirements

Based on the ACTUAL Warrior progression:

### SpellLists.lsx Structure

**Base Class (12 entries)**: `WoW_Warrior_Class_Level_1` through `WoW_Warrior_Class_Level_12`
- Direct spell grants via `AddSpells` attribute in Progressions (NOT via SelectSpells)
- **Current implementation doesn't use SpellLists for base class**

**Subclasses (36 entries)**: 12 per subclass × 3
- Direct spell grants via `AddSpells` attribute in Progressions
- **Current implementation doesn't use SpellLists for subclasses**

**Hero Talents**: NOT IMPLEMENTED YET
- No hero talent SpellLists exist in current progression
- Would need to be added at L13 if hero talents unlock new spells

### PassiveLists.lsx Structure

**NOT PRESENT in current implementation**

Hero talents (L13-L20) would require PassiveLists for choice nodes:
- Mountain Thane: 4 choice nodes (L15, L16, L18, L19)
- Colossus: 3 choice nodes (L15, L17, L19)
- Slayer: 3 choice nodes (L15, L17, L19)

---

## Comparison: Warrior vs Warlock Structures

### Warlock Mod (WoWWarlockHeroTalents)
```xml
<!-- Base class uses SpellLists via Selectors -->
<attribute id="Selectors" value="AddSpells(9e2ec5ea-a47c-475a-b756-c0e0ca69a281)"/>

<!-- Hero talents use SelectPassives -->
<attribute id="Selectors" value="SelectPassives(6ec0fba1-0d0e-4c06-9f89-5f14d792d5c0,1,WoWWarlockDiabolistOfensive)"/>
```

### Warrior Mod (Current)
```xml
<!-- Base class uses direct AddSpells attribute -->
<attribute id="AddSpells" value="Target_WAR_Charge;WAR_HeroicStrike"/>

<!-- Hero talents NOT IMPLEMENTED (empty nodes) -->
```

---

## What This Means for Transformation

### Option A: Keep Warrior Pattern (Simpler)

**Advantages**:
- ✅ No SpellLists needed for L1-L12 (direct AddSpells)
- ✅ Only need PassiveLists for hero talents (L13-L20)
- ✅ Less complex structure
- ✅ Matches existing Warrior implementation

**What We Need**:
1. **PassiveLists.lsx**: 18-24 entries for hero talent choices
2. **Progressions.lsx updates**: Fill L13/L15/L17/L19 with SelectPassives

**Time**: 2-3 hours

### Option B: Convert to Warlock Pattern (Complex)

**Advantages**:
- ✅ More flexible (easier to change spell grants per level)
- ✅ Matches proven Warlock structure

**Disadvantages**:
- ❌ Must create 48 SpellLists for L1-L12
- ❌ Must convert all AddSpells to Selectors
- ❌ Must update all Progressions.lsx entries (48 changes)
- ❌ More complex for no functional benefit

**Time**: 5-6 hours

---

## Recommendation: Option A (Keep Warrior Pattern + Add Hero Talents)

### Why This Is Best

1. **Current Warrior implementation already works** for L1-L12
   - Direct AddSpells is simpler than SpellLists
   - No need to create 48 unnecessary SpellList entries
   - Less moving parts = fewer bugs

2. **Only hero talents need PassiveLists**
   - 18-24 PassiveList entries for choice nodes
   - Fill empty L13/L15/L17/L19 progression nodes
   - L20 already has conditional capstone logic

3. **Matches existing Warrior design**
   - Don't break what's working
   - Only add missing hero talent implementation

4. **Faster implementation**
   - 2-3 hours vs 5-6 hours
   - Focus on what's missing (hero talents) not rewriting what works (base class)

---

## Action Plan

### Step 1: Restore Warrior Progressions.lsx (30 minutes)
Copy from backup, replacing current Warlock template:
```powershell
Copy-Item "Tests\WARRIOR_BACKUP_BEFORE_TEMPLATE_20251018_183829\Public\BG3Wow_78fe4967-4e62-5491-d981-dd781acca4d7\Progressions\Progressions.lsx" `
    -Destination "Data\Public\Warrior_Wow_78fe4967-4e62-5491-d981-dd781acca4d7\Progressions\Progressions.lsx" `
    -Force
```

### Step 2: Create PassiveLists.lsx (90 minutes)
Create 18-24 PassiveList entries for hero talent choices:

**Example**:
```xml
<node id="PassiveList">
    <attribute id="Name" value="WAR_Colossus_Arms_Choice_L15"/>
    <attribute id="Passives" value="WAR_Colossus_MountainOfMuscle;WAR_Colossus_OneAgainstMany;WAR_Colossus_VeteranVitality"/>
    <attribute id="UUID" value="NEW-UUID"/>
</node>
```

### Step 3: Fill Hero Talent Progressions (60 minutes)
Update L13/L15/L17/L19 nodes for each subclass:

**L13 Example (Arms - Colossus or Slayer choice)**:
```xml
<node id="Progression">
    <attribute id="Level" value="13"/>
    <attribute id="Name" value="Arms Warrior"/>
    <attribute id="ProgressionType" value="1"/>
    <attribute id="Selectors" value="SelectPassives(UUID-FOR-COLOSSUS-OR-SLAYER-KEYSTONE,1,WarriorHeroTalentKeystone)"/>
    <attribute id="TableUUID" value="2b3c4d5e-6f7a-8b9c-0d1e-2f3a4b5c6d7e"/>
    <attribute id="UUID" value="5d6e7f8a-9b0c-1d2e-3f4a-5b6c7d8e9f0a"/>
</node>
```

**L15 Example (Arms - Colossus choice node)**:
```xml
<node id="Progression">
    <attribute id="Level" value="15"/>
    <attribute id="Name" value="Arms Warrior"/>
    <attribute id="ProgressionType" value="1"/>
    <attribute id="Selectors" value="SelectPassives(UUID-FOR-COLOSSUS-L15-CHOICES,1,WarriorColossusChoice)"/>
    <attribute id="TableUUID" value="2b3c4d5e-6f7a-8b9c-0d1e-2f3a4b5c6d7e"/>
    <attribute id="UUID" value="9b0c1d2e-3f4a-5b6c-7d8e-9f0a1b2c3d4e"/>
</node>
```

### Step 4: Validate (15 minutes)
- Check XML syntax
- Verify UUID references
- Ensure passive names match Passive.txt

---

## Total Time Estimate: 2-3 hours

**MUCH SIMPLER** than creating 48 SpellLists + 20-32 PassiveLists (4-5 hours)

---

## FILES 4-10 Transformation (No Change)

The spell file transformation (FILES 4-10) remains the same:
1. Copy Warrior stat files from backup
2. Update abilities to use charges
3. Create validation tests

**This is independent of Progressions.lsx structure** - abilities are defined in Spell_*.txt files regardless of how they're granted in progressions.

---

## Summary

**Current Status**:
- ✅ Base class L1-L12: Fully implemented (direct AddSpells)
- ✅ Subclasses L1-L12: Fully implemented (direct AddSpells)
- ❌ Hero talents L13-L20: Empty progression nodes, need SelectPassives
- ❌ PassiveLists.lsx: Doesn't exist, need to create

**Next Steps**:
1. Restore Warrior Progressions.lsx from backup
2. Create PassiveLists.lsx with hero talent choices
3. Fill L13/L15/L17/L19 progression nodes
4. Proceed with FILES 4-10 (spell file transformation)

**Estimated Time**: 2-3 hours for hero talent implementation, then continue with spell files

---

**End of Document**
