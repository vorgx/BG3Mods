# 🔮 WoWWarlock Mod - Complete Reverse Engineering Report

**Date**: 2025-10-18  
**Mod UUID**: `bdb3fa73-401b-4979-f02e-485422dd8d9c`  
**Status**: ✅ **WORKING** - Successfully loads in BG3

---

## 📂 File Structure

### Core Files (13 LSX files total)

```
Public/Warlock_WoW_bdb3fa73-401b-4979-f02e-485422dd8d9c/
├── ActionResourceDefinitions/
│   └── ActionResourceDefinitions.lsx (Soul Shards resource)
├── ClassDescriptions/
│   └── ClassDescriptions.lsx (Base + 3 subclasses)
├── GUI/
│   ├── ActionResources.lsx
│   ├── Icons_Items.lsx
│   └── TooltipUpcastDescriptions.lsx
├── Lists/
│   ├── AbilityLists.lsx ✅
│   ├── PassiveLists.lsx ✅ (52 entries)
│   ├── SkillLists.lsx ✅
│   └── SpellLists.lsx ✅ (53 entries)
├── Levelmaps/
│   └── LevelMapValues.lsx
├── Progressions/
│   ├── ProgressionDescriptions.lsx
│   └── Progressions.lsx (486 lines)
└── Stats/Generated/Data/
    └── 10 stat files (644 KB total)
```

---

## 🎯 Key Architecture Patterns

### 1. **Heavy Talent System**

Warlock uses extensive talent choices at every level:
- **52 PassiveLists** (talent pools)
- **53 SpellLists** (spell pools)
- **1-4 talent choices per level** using `SelectPassives`

### 2. **Selector Format (CORRECT)**

```xml
<attribute id="Selectors" type="LSString" value="SelectSkills(UUID,2);SelectAbilityBonus(UUID,AbilityBonus,2,1);AddSpells(UUID)"/>
```

**NOT** nested XML nodes - uses semicolon-separated LSString format.

### 3. **Progression Pattern**

- **Level 1**: Character creation (skills, ability scores, starting spells)
- **Level 1 Multiclass**: Separate entry with `IsMulticlass="true"`
- **Level 2-12**: Progressive talent unlocks with SelectPassives

### 4. **SpellLists Usage**

Level 1 uses `AddSpells(UUID)` pointing to SpellLists.lsx:
```xml
<attribute id="Selectors" value="AddSpells(9e2ec5ea-a47c-475a-b756-c0e0ca69a281)"/>
```

SpellLists.lsx entry:
```xml
<node id="SpellList">
    <attribute id="Spells" type="LSString" value="Projectile_WoWWarlock_ShadowBolt;Projectile_WoWWarlock_Incinerate"/>
    <attribute id="UUID" type="guid" value="9e2ec5ea-a47c-475a-b756-c0e0ca69a281"/>
</node>
```

---

## 📊 Level-by-Level Progression (Base Class)

### **Level 1** - Character Creation
```xml
Boosts: 
  - ActionResource(SpellSlot,1,0)
  - Proficiency(LightArmor)
  - ProficiencyBonus(SavingThrow,Wisdom)
  - ProficiencyBonus(SavingThrow,Charisma)
  - Proficiency(SimpleWeapons)

PassivesAdded: 
  - WoWWarlock_Unlock_SoulShard
  - WoWWarlock_BlackHarvest

Selectors:
  - SelectSkills(6f3122fa-de19-4512-a307-49cba0369bf0, 2) → 2 skills from list
  - SelectAbilityBonus(d94c3eda-bdd9-4aaf-9372-7fccde528781, AbilityBonus, 2, 1)
  - AddSpells(9e2ec5ea-a47c-475a-b756-c0e0ca69a281) → Starting spells

SubClasses: 3 subclass UUIDs (Demonology, Destruction, Affliction)
```

### **Level 1 Multiclass**
```xml
IsMulticlass: true
Same boosts/passives as L1
Selectors: Only AddSpells (no skills/ability scores)
```

### **Level 2** - First Talents
```xml
PassivesAdded:
  - WoWWarlock_SouLeech_Description
  - WoWWarlock_SouLeech_DrainLife
  - WoWWarlock_MortalCoil_Heal

Selectors:
  - AddSpells(7e7c204e-0bcb-4ddb-9dd5-78a2f85cdfb2)
  - SelectPassives(ebd12d3f-5232-43e0-bb52-dc7b98f4041e, 1, WarlockClassTalentRow1)
    → Choose 1 talent from Row 1
```

### **Level 3** - Expand Talent Choices
```xml
Selectors:
  - AddSpells(59be68b9-a2e2-400a-9a2f-daae17f0c40a)
  - SelectPassives(ebd12d3f, 1, WarlockClassTalentRow1) → Still choose from Row 1
  - SelectPassives(bf5b693e, 1, WarlockClassTalentRow2) → NEW: Row 2 choice
```

### **Level 4** - Ability Score Improvement
```xml
AllowImprovement: true (ASI/Feat choice)

Selectors:
  - AddSpells(874b3746-8d60-4a90-aab0-bd656d1342d5)
  - SelectPassives from Rows 1, 2, 3 (3 total talent choices)
```

### **Level 5** - More Talents
```xml
Selectors:
  - AddSpells(dd824bd4-3afa-41e1-9120-4410f6b31e7c)
  - SelectPassives from Rows 2, 4 (2 talent choices)
```

### **Level 6** - Expanded Talent Tree
```xml
Selectors:
  - AddSpells(6ed5c46a-61bc-431a-a3fd-16acf9081476)
  - SelectPassives from Rows 3, 4, 5 (3 talent choices)
```

### **Level 7** - Continue Progression
```xml
Selectors:
  - AddSpells(99b1fb40-47da-4131-a804-16ecea4e5085)
  - SelectPassives from Rows 4, 5, 6 (3 talent choices)
```

### **Level 8** - Second ASI
```xml
AllowImprovement: true (ASI/Feat choice)

Selectors:
  - AddSpells(368968fd-270d-4c05-b9c8-1495d3222a2b)
  - SelectPassives from Rows 5, 6, 7 (3 talent choices)
```

### **Level 9** - Advanced Abilities
```xml
PassivesAdded: WoWWarlock_Improved_DrainLife

Selectors:
  - AddSpells(fe643b97-0c09-46ee-a3c6-98da8ba94ec3)
  - SelectPassives from Rows 6, 7 (2 talent choices)
```

### **Level 10** - Upgraded Healthstone
```xml
PassivesAdded: WoWWarlock_Unlock_Healthstone_2
PassivesRemoved: WoWWarlock_Unlock_Healthstone_1

Selectors:
  - AddSpells(f93816a0-3639-452b-959e-e3b63ec82257)
  - SelectPassives from Rows 7, 9 (2 talent choices)
```

### **Level 11** - Soul Conduit
```xml
PassivesAdded: WoWWarlock_SoulConduit_Description

Selectors:
  - AddSpells(1cc306ed-4f58-4d00-aad8-82b8520bd6d6)
  - SelectPassives from Row 9 (1 talent choice)
```

### **Level 12** - Final ASI
```xml
AllowImprovement: true (ASI/Feat choice)

Selectors:
  - AddSpells(b9bec33f-fd30-4498-921c-6821529a66ba)
```

---

## 🔑 Critical Requirements

### **1. Four Lists Files (ALL REQUIRED)**
- ✅ AbilityLists.lsx
- ✅ PassiveLists.lsx (52 entries - extensive talent system)
- ✅ SkillLists.lsx
- ✅ SpellLists.lsx (53 entries - spell pools)

### **2. Selector Format**
```xml
<!-- CORRECT (LSString) -->
<attribute id="Selectors" type="LSString" value="SelectSkills(UUID,2);AddSpells(UUID)"/>

<!-- WRONG (Nested XML) -->
<children>
    <node id="Selectors">
        <node id="SelectSkills">...</node>
    </node>
</children>
```

### **3. Multiclass Entry**
Separate Level 1 progression with `IsMulticlass="true"` - no skill/ability selection, only spells.

### **4. SelectPassives Pattern**
```xml
SelectPassives(PassiveListUUID, amount, tag)
```
- UUID points to PassiveLists.lsx entry
- Amount = number of choices (usually 1)
- Tag = categorization (e.g., "WarlockClassTalentRow1")

---

## 📦 Stats Files (10 files, 644 KB)

```
Passive.txt
Spell_Projectile.txt
Spell_Shout.txt
Spell_Target.txt
Spell_Teleportation.txt
Spell_Zone.txt
Status_BOOST.txt
(additional stat files)
```

---

## 🎨 GUI Files

- **ActionResources.lsx**: Soul Shard display
- **Icons_Items.lsx**: Item icons
- **TooltipUpcastDescriptions.lsx**: Spell scaling descriptions

---

## ✅ Success Factors

1. **All 4 Lists files present**
2. **Correct LSString Selector format**
3. **Multiclass variant included**
4. **Extensive PassiveLists for talent system**
5. **SpellLists UUIDs match AddSpells references**
6. **SkillLists UUID matches SelectSkills reference**

---

## 🔍 Comparison with Our Warrior Mod

| Feature | Warlock | Our Warrior | Status |
|---------|---------|-------------|--------|
| SkillLists.lsx | ✅ | ✅ | MATCH |
| SpellLists.lsx | ✅ | ❌ | **MISSING** |
| PassiveLists.lsx | ✅ (52) | ❌ | **MISSING** |
| AbilityLists.lsx | ✅ | ✅ | MATCH |
| Selector format | LSString | LSString | MATCH |
| Multiclass entry | ✅ | ✅ | MATCH |
| SelectPassives usage | Heavy (every level) | Removed | DIFFERENT |

**Root Cause**: Missing SpellLists.lsx and PassiveLists.lsx files.

---

**Recommendation**: Create the 2 missing files (even with minimal/empty content) to match Warlock's structure.
