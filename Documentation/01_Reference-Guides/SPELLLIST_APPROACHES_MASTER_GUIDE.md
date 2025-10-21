# SpellList Approaches: Master Reference Guide

**Created**: October 20, 2025  
**Purpose**: Comprehensive guide to all three SpellList implementation approaches with migration paths  
**Status**: Reference document for potential future migrations  

---

## 📋 Table of Contents

1. [Overview: Three Valid Approaches](#overview-three-valid-approaches)
2. [Approach 1: Zero SpellLists (Warrior - Current)](#approach-1-zero-spelllists-warrior---current)
3. [Approach 2: Hybrid SpellLists (DemonHunter)](#approach-2-hybrid-spelllists-demonhunter)
4. [Approach 3: Full SpellLists (Warlock)](#approach-3-full-spelllists-warlock)
5. [Side-by-Side Comparison](#side-by-side-comparison)
6. [Migration Paths](#migration-paths)
7. [Decision Matrix](#decision-matrix)
8. [Implementation Templates](#implementation-templates)

---

## Overview: Three Valid Approaches

All three approaches are **functionally equivalent** and proven to work in BG3 mods with 10K+ downloads:

| Approach | Example Mod | Downloads | SpellList Count | Complexity |
|----------|-------------|-----------|-----------------|------------|
| **Zero SpellLists** | Warrior (current) | In development | 0 | Low |
| **Hybrid SpellLists** | WoWDemonHunter | Active | 19 | Medium |
| **Full SpellLists** | WoWWarlock | 13,000+ | 53 | High |

**Key Insight**: The SpellList attribute in ClassDescriptions.lsx is **optional** (DemonHunter proves this by omitting it entirely).

---

## Approach 1: Zero SpellLists (Warrior - Current)

### Philosophy
**"All grants via PassivesAdded"** - Use unlock passives for every ability, no SpellLists.lsx file.

### File Structure

```
Data/Public/BG3Wow_[UUID]/
├── ClassDescriptions/
│   └── ClassDescriptions.lsx  # SpellList attribute = dummy UUID (optional)
├── Progressions/
│   └── Progressions.lsx        # Uses PassivesAdded only
├── Stats/Generated/Data/
│   └── Passive.txt             # Contains all unlock passives
└── Lists/
    └── PassiveLists.lsx        # For choice nodes only
```

**NO SpellLists.lsx file created!**

### Implementation Pattern

#### ClassDescriptions.lsx
```xml
<node id="ClassDescription">
    <attribute id="Name" type="FixedString" value="WoWWarrior"/>
    <attribute id="SpellList" type="guid" value="32879c22-4858-48ef-8f8d-22e6d395b396"/> <!-- Dummy, optional -->
    <attribute id="ProgressionTableUUID" type="guid" value="[BASE_WARRIOR_PROGRESSION_UUID]"/>
    <attribute id="UUID" type="guid" value="78fe4967-4e62-5491-d981-dd781acca4d7"/>
</node>
```

**Alternative** (DemonHunter style): Omit SpellList attribute entirely
```xml
<node id="ClassDescription">
    <attribute id="Name" type="FixedString" value="WoWWarrior"/>
    <!-- NO SpellList attribute -->
    <attribute id="ProgressionTableUUID" type="guid" value="[BASE_WARRIOR_PROGRESSION_UUID]"/>
    <attribute id="UUID" type="guid" value="78fe4967-4e62-5491-d981-dd781acca4d7"/>
</node>
```

#### Progressions.lsx (Baseline Abilities)
```xml
<!-- Arms Level 3: Grant Execute + Pummel -->
<node id="Progression">
    <attribute id="Level" type="uint8" value="3"/>
    <attribute id="Name" type="LSString" value="ArmsWarrior"/>
    <attribute id="PassivesAdded" type="LSString" value="WAR_Arms_Execute_Unlock;WAR_Arms_Pummel_Unlock"/>
    <attribute id="TableUUID" type="guid" value="[ARMS_PROGRESSION_UUID]"/>
</node>
```

#### Passive.txt (Unlock Passives)
```
new entry "WAR_Arms_Execute_Unlock"
type "PassiveData"
data "DisplayName" "h125abc01;1"
data "Description" "h125abc02;1"
data "Icon" "Action_Execute"
data "Properties" "IsHidden"
data "Boosts" "UnlockSpell(WAR_Execute)"

new entry "WAR_Arms_Pummel_Unlock"
type "PassiveData"
data "DisplayName" "h125abc03;1"
data "Description" "h125abc04;1"
data "Icon" "Action_Pummel"
data "Properties" "IsHidden"
data "Boosts" "UnlockSpell(WAR_Pummel)"
```

### Pros & Cons

✅ **Advantages**:
- Simplest approach (fewer files, one system)
- No UUID management for SpellLists (just 1 dummy)
- All grants in one place (Progressions.lsx + Passive.txt)
- Easy to understand (linear progression)
- Passives can have conditions (e.g., `IF(HasPassive('Keystone'))`)
- Works with talent trees (choice nodes via PassiveLists.lsx)

❌ **Disadvantages**:
- Requires one unlock passive per ability (~135 passives for Warrior)
- Can't easily see "which spells at which level" without reading Progressions
- Larger Passive.txt file
- No organizational grouping of abilities by level/spec

### When to Use
- Talent-based unlocks (WoW-style class design)
- Mods with conditional ability unlocks
- Simpler file structure preferred
- Fewer than 200 total abilities

---

## Approach 2: Hybrid SpellLists (DemonHunter)

### Philosophy
**"SpellLists for baseline, PassivesAdded for upgrades"** - Use both systems for clean separation of concerns.

### File Structure

```
Data/Public/WoWDemonHunterClass_[UUID]/
├── ClassDescriptions/
│   └── ClassDescriptions.lsx  # NO SpellList attribute!
├── Progressions/
│   └── Progressions.lsx        # Uses AddSpells([UUID]) + PassivesAdded
├── Lists/
│   ├── SpellLists.lsx          # 19 nodes (shared + subclass abilities)
│   └── PassiveLists.lsx        # For choice nodes
└── Stats/Generated/Data/
    └── Passive.txt             # Upgrade passives, resource mechanics
```

### Implementation Pattern

#### ClassDescriptions.lsx
```xml
<node id="ClassDescription">
    <attribute id="Name" type="FixedString" value="WoWDemonHunter"/>
    <!-- NO SpellList attribute - DemonHunter omits it! -->
    <attribute id="ProgressionTableUUID" type="guid" value="[BASE_DH_PROGRESSION_UUID]"/>
    <attribute id="UUID" type="guid" value="[DH_CLASS_UUID]"/>
</node>
```

#### SpellLists.lsx (Baseline Abilities)
```xml
<node id="SpellList">
    <attribute id="Comment" type="LSString" value="Havoc DH Level 2"/>
    <attribute id="Spells" type="LSString" value="Target_DH_DemonsBite;Target_DH_ChaosStrike"/>
    <attribute id="UUID" type="guid" value="7e456407-36da-4600-8b67-574f5744480a"/>
</node>
```

#### Progressions.lsx (HYBRID Method)
```xml
<!-- Havoc Level 2: Grant baseline abilities + upgrade passive -->
<node id="Progression">
    <attribute id="Level" type="uint8" value="2"/>
    <attribute id="Name" type="LSString" value="HavocDemonHunter"/>
    <attribute id="PassivesAdded" type="LSString" value="DH_Havoc_UnlockChaosStrike"/>
    <attribute id="Selectors" type="LSString" value="AddSpells(7e456407-36da-4600-8b67-574f5744480a,,,,AlwaysPrepared)"/>
    <attribute id="TableUUID" type="guid" value="[HAVOC_PROGRESSION_UUID]"/>
</node>
```

#### Passive.txt (Upgrade Passives Only)
```
new entry "DH_Havoc_UnlockChaosStrike"
type "PassiveData"
data "DisplayName" "h789def01;1"
data "Description" "h789def02;1"
data "Properties" "IsHidden"
data "Boosts" "IF(HasStatus('DH_DEMONIC_FURY')):UnlockSpell(DH_ChaosStrike_Upgraded)"
```

### Pros & Cons

✅ **Advantages**:
- Clean separation: SpellLists = baseline, Passives = upgrades
- Easy to see baseline rotation in SpellLists.lsx
- Can grant 3+ spells at once without multiple unlock passives
- Passives handle special mechanics (resource systems, upgrades)
- Medium complexity (19 SpellLists vs Warlock's 53)

❌ **Disadvantages**:
- Two systems to maintain (SpellLists + Passives)
- Need to manage SpellList UUIDs (~19-30)
- Must coordinate between files (SpellLists.lsx + Progressions.lsx)
- Harder to understand for new contributors

### When to Use
- Clear baseline rotation + upgrade system (WoW-style design)
- Many abilities granted at same level (3+ spells)
- Want organizational benefits without full per-level SpellLists
- 100-300 total abilities

---

## Approach 3: Full SpellLists (Warlock)

### Philosophy
**"One SpellList per level per category"** - Highly organized, maximum structure.

### File Structure

```
Data/Public/WoWWarlock_[UUID]/
├── ClassDescriptions/
│   └── ClassDescriptions.lsx  # SpellList attribute = dummy UUID
├── Progressions/
│   └── Progressions.lsx        # Uses AddSpells([UUID]) only
├── Lists/
│   ├── SpellLists.lsx          # 53 nodes (per-level per spec)
│   └── PassiveLists.lsx        # For choice nodes
└── Stats/Generated/Data/
    └── Passive.txt             # Talent passives, no unlock passives
```

### Implementation Pattern

#### ClassDescriptions.lsx
```xml
<node id="ClassDescription">
    <attribute id="Name" type="FixedString" value="WoWWarlock"/>
    <attribute id="SpellList" type="guid" value="32879c22-4858-48ef-8f8d-22e6d395b396"/> <!-- Dummy -->
    <attribute id="ProgressionTableUUID" type="guid" value="[BASE_WARLOCK_PROGRESSION_UUID]"/>
    <attribute id="UUID" type="guid" value="[WARLOCK_CLASS_UUID]"/>
</node>
```

#### SpellLists.lsx (Per-Level Organization)
```xml
<!-- Base Class L1 -->
<node id="SpellList">
    <attribute id="Comment" type="LSString" value="Warlock Level 1"/>
    <attribute id="Spells" type="LSString" value="Target_SummonDemon"/>
    <attribute id="UUID" type="guid" value="9e2ec5ea-a47c-475a-b756-c0e0ca69a281"/>
</node>

<!-- Demonology L2 -->
<node id="SpellList">
    <attribute id="Comment" type="LSString" value="Demonology Warlock Level 2"/>
    <attribute id="Spells" type="LSString" value="Target_SummonDemon_Felguard_1;Projectile_Demo_HandOfGuldan_1"/>
    <attribute id="UUID" type="guid" value="92355092-ac2f-48dc-8658-6ff1efa72685"/>
</node>

<!-- Empty placeholder for organizational consistency -->
<node id="SpellList">
    <attribute id="Comment" type="LSString" value="Warlock Level 2"/>
    <attribute id="Spells" type="LSString" value=""/>
    <attribute id="UUID" type="guid" value="7e7c204e-0bcb-4ddb-9dd5-78a2f85cdfb2"/>
</node>
```

#### Progressions.lsx (AddSpells Only)
```xml
<!-- Demonology Level 2: Grant spells via SpellList -->
<node id="Progression">
    <attribute id="Level" type="uint8" value="2"/>
    <attribute id="Name" type="LSString" value="DemonologyWarlock"/>
    <attribute id="Selectors" type="LSString" value="AddSpells(92355092-ac2f-48dc-8658-6ff1efa72685)"/>
    <attribute id="TableUUID" type="guid" value="[DEMONOLOGY_PROGRESSION_UUID]"/>
</node>
```

#### Passive.txt (Talents Only, No Unlock Passives)
```
new entry "Warlock_Talent_Choice"
type "PassiveData"
data "DisplayName" "h456ghi01;1"
data "Description" "h456ghi02;1"
data "Boosts" "ActionResource(SoulShards,5,0)"
```

### Pros & Cons

✅ **Advantages**:
- Highly organized (one SpellList per level per spec)
- Easy to find which spells grant at which level
- Clean separation of class vs spec spells
- Can update L3 spells without touching L4 code
- Good for mods with many variants (demon summons, pets)
- Comments in SpellLists.lsx act as documentation

❌ **Disadvantages**:
- Most complex (53+ UUIDs to manage)
- Larger SpellLists.lsx file (~250 lines)
- Many empty placeholder nodes (organizational overhead)
- More files to maintain
- Harder to understand for new contributors
- Can't easily add conditional unlocks

### When to Use
- Many variants per level (summons, demons, pets, forms)
- Want maximum organization and documentation
- Large mod with 300+ abilities
- Multiple contributors need clear file organization
- Mod design benefits from per-level grouping

---

## Side-by-Side Comparison

### File Count & Complexity

| Aspect | Zero SpellLists | Hybrid SpellLists | Full SpellLists |
|--------|----------------|-------------------|-----------------|
| **SpellLists.lsx** | ❌ Not created | ✅ ~150 lines | ✅ ~250 lines |
| **SpellList Nodes** | 0 | 19 | 53 |
| **Unlock Passives** | ~135 | ~20 | 0 |
| **UUID Management** | 1 dummy | 19 SpellLists + 1 dummy | 53 SpellLists + 1 dummy |
| **Files to Maintain** | 2 (Progressions, Passive.txt) | 3 (Progressions, SpellLists, Passive.txt) | 3 (Progressions, SpellLists, Passive.txt) |
| **Total Lines of Code** | ~2000 | ~2200 | ~2400 |

### Grant Methods

| Method | Zero SpellLists | Hybrid SpellLists | Full SpellLists |
|--------|----------------|-------------------|-----------------|
| **Baseline Abilities** | PassivesAdded | AddSpells([UUID]) | AddSpells([UUID]) |
| **Upgrades** | PassivesAdded | PassivesAdded | Not used |
| **Conditional Unlocks** | PassivesAdded + conditions | PassivesAdded + conditions | Difficult |
| **Multiple Spells at Once** | Multiple PassivesAdded | Single AddSpells([UUID]) | Single AddSpells([UUID]) |
| **Choice Nodes** | SelectPassives() | SelectPassives() | SelectPassives() |

### Migration Difficulty

| From → To | Difficulty | Estimated Time | Notes |
|-----------|-----------|----------------|-------|
| **Zero → Hybrid** | Medium | 8-12 hours | Create SpellLists.lsx, convert baseline ability grants |
| **Zero → Full** | High | 16-24 hours | Create 53+ SpellList nodes, reorganize all grants |
| **Hybrid → Zero** | Easy | 4-6 hours | Delete SpellLists.lsx, convert AddSpells() to PassivesAdded |
| **Hybrid → Full** | Medium | 8-12 hours | Expand SpellLists to per-level nodes |
| **Full → Hybrid** | Easy | 4-6 hours | Consolidate SpellLists, add upgrade passives |
| **Full → Zero** | Medium | 8-12 hours | Delete SpellLists.lsx, create unlock passives |

---

## Migration Paths

### Path 1: Zero → Hybrid (Warrior to DemonHunter Style)

**When**: If you want organizational benefits and have many spells per level

**Steps**:
1. **Create SpellLists.lsx**
   ```xml
   <?xml version="1.0" encoding="UTF-8"?>
   <save>
       <version major="4" minor="0" revision="7" build="406"/>
       <region id="SpellLists">
           <node id="root">
               <children>
                   <!-- Add SpellList nodes here -->
               </children>
           </node>
       </region>
   </save>
   ```

2. **Identify Baseline Abilities** (from Excel)
   - Arms L1-L12: 12 abilities → 12 SpellList nodes
   - Fury L1-L12: 12 abilities → 12 SpellList nodes
   - Protection L1-L12: 12 abilities → 12 SpellList nodes
   - **Total**: ~30-40 SpellList nodes

3. **Create SpellList Nodes** (group by level)
   ```xml
   <node id="SpellList">
       <attribute id="Comment" type="LSString" value="Arms Warrior Level 3"/>
       <attribute id="Spells" type="LSString" value="WAR_Execute;WAR_Pummel"/>
       <attribute id="UUID" type="guid" value="[GENERATE_NEW_UUID]"/>
   </node>
   ```

4. **Update Progressions.lsx** (change PassivesAdded to AddSpells)
   ```xml
   <!-- BEFORE (Zero SpellLists) -->
   <attribute id="PassivesAdded" type="LSString" value="WAR_Arms_Execute_Unlock;WAR_Arms_Pummel_Unlock"/>

   <!-- AFTER (Hybrid SpellLists) -->
   <attribute id="Selectors" type="LSString" value="AddSpells([ARMS_L3_UUID],,,,AlwaysPrepared)"/>
   <attribute id="PassivesAdded" type="LSString" value="WAR_Arms_ExecuteMastery"/> <!-- Keep upgrades as passives -->
   ```

5. **Keep Upgrade Passives** (hero talents, keystones)
   - Hero talent keystones: Keep as PassivesAdded
   - Ability upgrades: Keep as PassivesAdded
   - Only baseline abilities move to SpellLists

6. **Test Migration**
   - Create new character
   - Check L1-L12 progression (baseline abilities grant correctly)
   - Check L13-L20 progression (hero talents still work)
   - Verify no duplicate spell grants

**Estimated Time**: 8-12 hours  
**Risk Level**: Medium (need to track all ability grants)

---

### Path 2: Zero → Full (Warrior to Warlock Style)

**When**: If you want maximum organization (NOT recommended for Warrior)

**Steps**:
1. **Create SpellLists.lsx** with per-level nodes
   - Base class: 20 levels → 20 SpellList nodes
   - Arms: 20 levels → 20 SpellList nodes
   - Fury: 20 levels → 20 SpellList nodes
   - Protection: 20 levels → 20 SpellList nodes
   - Mountain Thane: 8 levels → 8 SpellList nodes
   - Colossus: 8 levels → 8 SpellList nodes
   - Slayer: 8 levels → 8 SpellList nodes
   - **Total**: ~140 SpellList nodes (many empty!)

2. **Convert ALL PassivesAdded to AddSpells([UUID])**
   - Including hero talents
   - Including keystones
   - No more unlock passives

3. **Update Passive.txt** (remove all unlock passives)
   - Delete `WAR_Arms_Execute_Unlock` etc.
   - Keep only talent passives (not unlock passives)

**Estimated Time**: 16-24 hours  
**Risk Level**: High (major restructure)  
**Recommendation**: ❌ **DO NOT USE** - overkill for Warrior design

---

### Path 3: Hybrid → Zero (DemonHunter to Warrior Style)

**When**: If SpellLists.lsx becomes maintenance burden

**Steps**:
1. **Create Unlock Passives** for all SpellList abilities
   ```
   new entry "WAR_Execute_Unlock"
   type "PassiveData"
   data "Properties" "IsHidden"
   data "Boosts" "UnlockSpell(WAR_Execute)"
   ```

2. **Update Progressions.lsx** (convert AddSpells to PassivesAdded)
   ```xml
   <!-- BEFORE (Hybrid) -->
   <attribute id="Selectors" type="LSString" value="AddSpells([UUID],,,,AlwaysPrepared)"/>

   <!-- AFTER (Zero) -->
   <attribute id="PassivesAdded" type="LSString" value="WAR_Execute_Unlock"/>
   ```

3. **Delete SpellLists.lsx**

4. **Test Migration**
   - Verify all spells still grant at correct levels

**Estimated Time**: 4-6 hours  
**Risk Level**: Low (simplification, hard to break)

---

## Decision Matrix

### Choose Zero SpellLists If...

✅ You have talent-based unlocks (WoW-style class design)  
✅ You want simplest possible structure  
✅ You have fewer than 200 total abilities  
✅ You want conditional ability unlocks (IF statements in passives)  
✅ You're the solo developer (no coordination needed)  
✅ You prioritize ease of maintenance over organization  

**Example Mods**: Warrior (current), most homebrew class mods

---

### Choose Hybrid SpellLists If...

✅ You have clear baseline rotation + upgrade system  
✅ You grant 3+ spells at same level frequently  
✅ You want organizational benefits without full complexity  
✅ You have 100-300 total abilities  
✅ You want clean separation: baseline vs upgrades  
✅ You have 2-3 contributors who need clear file organization  

**Example Mods**: WoWDemonHunter, WoWMonk (uses hybrid)

---

### Choose Full SpellLists If...

✅ You have many variants per level (summons, demons, pets)  
✅ You want maximum organization and documentation  
✅ You have 300+ abilities  
✅ You have multiple contributors needing clear structure  
✅ Your mod design benefits from per-level grouping  
✅ You want to easily update one level without touching others  

**Example Mods**: WoWWarlock, WoWDruid (forms), summoner-focused classes

---

## Implementation Templates

### Template 1: Zero SpellLists Progression Node

```xml
<!-- Level 3: Grant 2 baseline abilities -->
<node id="Progression">
    <attribute id="Level" type="uint8" value="3"/>
    <attribute id="Name" type="LSString" value="ArmsWarrior"/>
    <attribute id="Boosts" type="LSString" value=""/>
    <attribute id="PassivesAdded" type="LSString" value="WAR_Arms_Execute_Unlock;WAR_Arms_Pummel_Unlock"/>
    <attribute id="PassivesRemoved" type="LSString" value=""/>
    <attribute id="ProgressionType" type="uint8" value="1"/>
    <attribute id="TableUUID" type="guid" value="[ARMS_PROGRESSION_UUID]"/>
    <attribute id="UUID" type="guid" value="[GENERATE_UNIQUE_UUID]"/>
</node>
```

### Template 2: Hybrid SpellLists Progression Node

```xml
<!-- Level 3: Grant baseline abilities via SpellList + upgrade via passive -->
<node id="Progression">
    <attribute id="Level" type="uint8" value="3"/>
    <attribute id="Name" type="LSString" value="ArmsWarrior"/>
    <attribute id="Boosts" type="LSString" value=""/>
    <attribute id="PassivesAdded" type="LSString" value="WAR_Arms_ExecuteMastery"/>
    <attribute id="PassivesRemoved" type="LSString" value=""/>
    <attribute id="Selectors" type="LSString" value="AddSpells(b562c1d8-1f1e-4f05-ae0b-574f5744480a,,,,AlwaysPrepared)"/>
    <attribute id="ProgressionType" type="uint8" value="1"/>
    <attribute id="TableUUID" type="guid" value="[ARMS_PROGRESSION_UUID]"/>
    <attribute id="UUID" type="guid" value="[GENERATE_UNIQUE_UUID]"/>
</node>
```

### Template 3: Full SpellLists Progression Node

```xml
<!-- Level 3: Grant abilities via SpellList only -->
<node id="Progression">
    <attribute id="Level" type="uint8" value="3"/>
    <attribute id="Name" type="LSString" value="ArmsWarrior"/>
    <attribute id="Boosts" type="LSString" value=""/>
    <attribute id="PassivesAdded" type="LSString" value=""/>
    <attribute id="PassivesRemoved" type="LSString" value=""/>
    <attribute id="Selectors" type="LSString" value="AddSpells(b562c1d8-1f1e-4f05-ae0b-574f5744480a)"/>
    <attribute id="ProgressionType" type="uint8" value="1"/>
    <attribute id="TableUUID" type="guid" value="[ARMS_PROGRESSION_UUID]"/>
    <attribute id="UUID" type="guid" value="[GENERATE_UNIQUE_UUID]"/>
</node>
```

---

## Quick Reference: Selector Syntax

### AddSpells() Syntax
```xml
<!-- Basic: Grant spells from SpellList -->
<attribute id="Selectors" type="LSString" value="AddSpells([SPELLLIST_UUID])"/>

<!-- With AlwaysPrepared flag (no need to prepare) -->
<attribute id="Selectors" type="LSString" value="AddSpells([UUID],,,,AlwaysPrepared)"/>

<!-- Multiple SpellLists at once -->
<attribute id="Selectors" type="LSString" value="AddSpells([UUID1]);AddSpells([UUID2])"/>

<!-- Direct spell names (no SpellList) - rarely used -->
<attribute id="Selectors" type="LSString" value="AddSpells(WAR_Execute;WAR_Pummel,,,,AlwaysPrepared)"/>
```

### PassivesAdded Syntax
```xml
<!-- Single passive -->
<attribute id="PassivesAdded" type="LSString" value="WAR_Execute_Unlock"/>

<!-- Multiple passives (semicolon-separated) -->
<attribute id="PassivesAdded" type="LSString" value="WAR_Execute_Unlock;WAR_Pummel_Unlock;WAR_Keystone"/>

<!-- Empty (no passives this level) -->
<attribute id="PassivesAdded" type="LSString" value=""/>
```

---

## Troubleshooting: Common Issues

### Issue 1: Spells Not Granting (Zero SpellLists)

**Symptoms**: Passive shows in character sheet, but spell doesn't appear in hotbar

**Causes**:
- Typo in spell name in `Boosts="UnlockSpell(SpellName)"`
- Spell not defined in Spell_*.txt files
- Passive is visible (missing `Properties="IsHidden"`)

**Fix**:
```
new entry "WAR_Execute_Unlock"
type "PassiveData"
data "Properties" "IsHidden"  # Add this line!
data "Boosts" "UnlockSpell(WAR_Execute)"  # Verify spell name matches Spell_Target.txt
```

---

### Issue 2: Spells Not Granting (Hybrid/Full SpellLists)

**Symptoms**: No spells appear at level up

**Causes**:
- Wrong UUID in `AddSpells([UUID])`
- SpellList node not defined in SpellLists.lsx
- Typo in spell names in SpellList

**Fix**:
```xml
<!-- Progressions.lsx -->
<attribute id="Selectors" type="LSString" value="AddSpells(b562c1d8-1f1e-4f05-ae0b-574f5744480a,,,,AlwaysPrepared)"/>

<!-- SpellLists.lsx - verify UUID matches -->
<node id="SpellList">
    <attribute id="UUID" type="guid" value="b562c1d8-1f1e-4f05-ae0b-574f5744480a"/>
    <attribute id="Spells" type="LSString" value="WAR_Execute;WAR_Pummel"/>  <!-- Verify spell names -->
</node>
```

---

### Issue 3: Duplicate Spells Granted

**Symptoms**: Same spell appears twice in hotbar

**Causes**:
- Using BOTH AddSpells([UUID]) AND PassivesAdded for same spell
- SpellList contains spell that's also unlocked by passive

**Fix**: Choose ONE grant method per ability
```xml
<!-- WRONG: Both methods grant same spell -->
<attribute id="PassivesAdded" type="LSString" value="WAR_Execute_Unlock"/>
<attribute id="Selectors" type="LSString" value="AddSpells([UUID_CONTAINING_EXECUTE])"/>

<!-- RIGHT: One method only -->
<attribute id="Selectors" type="LSString" value="AddSpells([UUID_CONTAINING_EXECUTE])"/>
```

---

## Appendix: UUID Generation

### PowerShell Script (Recommended)
```powershell
# Generate single UUID
[guid]::NewGuid().ToString()

# Generate 10 UUIDs
1..10 | ForEach-Object { [guid]::NewGuid().ToString() }

# Generate UUIDs with labels (for migration)
$labels = @("Arms_L1", "Arms_L2", "Arms_L3")
foreach ($label in $labels) {
    $uuid = [guid]::NewGuid().ToString()
    Write-Host "$label : $uuid"
}
```

### Online Tools
- [UUID Generator](https://www.uuidgenerator.net/) - Version 4 (random)
- [GUID Generator](https://guidgenerator.com/) - Bulk generation

---

## Conclusion

**Current Warrior Recommendation**: **Zero SpellLists** ✅

**Reasons**:
1. ✅ Already implemented and working
2. ✅ Simplest approach (fewer files)
3. ✅ Perfect for talent-based design
4. ✅ Easy to maintain (one system)
5. ✅ Passives provide flexibility (conditions, hero talents)

**If you need to migrate later**:
- **Zero → Hybrid**: Medium difficulty, 8-12 hours (if organizational benefits needed)
- **Zero → Full**: High difficulty, NOT recommended (overkill for Warrior)

**This document provides**:
- ✅ All three approaches documented
- ✅ Migration paths with estimated time
- ✅ Templates for future conversion
- ✅ Decision matrix for future evaluation
- ✅ Troubleshooting guide

---

**Last Updated**: October 20, 2025  
**Status**: Master reference - ready for future migrations  
**Related Documents**:
- `WARLOCK_SPELLLIST_ANALYSIS.md` - Full SpellLists approach (53 nodes)
- `DEMONHUNTER_SPELLLIST_ANALYSIS.md` - Hybrid approach (19 nodes)
- `WARRIOR_COMPLETE_STRUCTURE_L1-L20.md` - Zero SpellLists approach (current)
