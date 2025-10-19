# Comprehensive Mod Comparison Analysis
**Date**: 2025-10-18 02:58 AM
**Purpose**: Identify ALL differences between our BG3Wow mod and three working reference mods

## Mods Being Compared

1. **Our Mod**: BG3Wow (Warrior class, 3 subclasses, crashes/doesn't appear)
2. **Reference 1**: WoWWarlock (Working, 1 base + 3 subclasses)
3. **Reference 2**: WoWDemonHunter (Working, custom class)
4. **Reference 3**: WoWDemonHunterFix (Working, same class)

---

## SECTION 1: FOLDER STRUCTURE ANALYSIS

### 1.1 Our Mod Structure (BG3Wow)
```
Data/
├── Mods/BG3Wow_78fe4967-4e62-5491-d981-dd781acca4d7/
│   └── meta.lsx
└── Public/BG3Wow_78fe4967-4e62-5491-d981-dd781acca4d7/
    ├── ActionResourceDefinitions/
    │   └── ActionResourceDefinitions.lsx
    ├── ClassDescriptions/
    │   └── ClassDescriptions.lsx
    ├── Progressions/
    │   └── Progressions.lsx
    └── Stats/
        └── Generated/
            └── Data/
                ├── Passive.txt
                ├── Spell_Jump.txt
                ├── Spell_Projectile.txt
                ├── Spell_Shout.txt
                ├── Spell_Target.txt
                ├── Spell_Zone.txt
                └── Status_BOOST.txt
```

### 1.2 WoWDemonHunter Structure
```
WoWDemonHunterClass/
├── Generated/          ⚠️ EXTRA FOLDER (contains Public/Shared/Assets/)
├── Localization/       ⚠️ AT ROOT LEVEL (not in Mods/)
│   ├── English/
│   │   ├── WoWDemonHunterClass.xml
│   │   └── WoWDemonHunterClass.loca.xml
│   └── Chinese/
├── Mods/
│   └── WoWDemonHunterClass/
│       └── meta.lsx
├── Public/
│   ├── Game/           ⚠️ EXTRA FOLDER (GUI/Assets/)
│   ├── Shared/         ⚠️ EXTRA FOLDER (MultiEffectInfos/)
│   └── WoWDemonHunterClass/
│       ├── ActionResourceDefinitions/
│       │   └── ActionResourceDefinitions.lsx
│       ├── ActionResourceGroupDefinitions/  ⚠️ EXTRA FILE
│       │   └── ActionResourceGroupDefinitions.lsx
│       ├── Assets/     ⚠️ EXTRA FOLDER
│       ├── CharacterCreationPresets/
│       ├── ClassDescriptions/
│       ├── Content/    ⚠️ EXTRA FOLDER
│       ├── DefaultValues/
│       ├── GUI/        ⚠️ EXTRA FOLDER
│       ├── Levelmaps/
│       ├── Lists/
│       ├── Progressions/
│       │   ├── ProgressionDescriptions.lsx  ⚠️ EXTRA FILE
│       │   └── Progressions.lsx
│       ├── RootTemplates/
│       ├── Shapeshift/
│       ├── Stats/
│       │   └── Generated/
│       │       ├── Data/
│       │       ├── Equipment.txt  ⚠️ EXTRA FILE
│       │       └── TreasureTable.txt
│       └── TooltipExtras/
└── Scripts/            ⚠️ EXTRA FOLDER (thoth/helpers/)
```

### 1.3 WoWWarlock Structure
```
ExampleMod_WoWWarlock/
├── Mods/
│   └── Warlock_WoW_bdb3fa73-401b-4979-f02e-485422dd8d9c/
│       ├── meta.lsx
│       └── Localization/  ⚠️ IN Mods/ SUBFOLDER
│           └── English/
│               └── english.xml
└── Public/
    └── Warlock_WoW_bdb3fa73-401b-4979-f02e-485422dd8d9c/
        ├── ActionResourceDefinitions/
        ├── Assets/
        ├── CharacterCreationPresets/
        ├── ClassDescriptions/
        ├── Content/
        ├── GUI/
        ├── Levelmaps/
        ├── Lists/
        ├── MultiEffectInfos/
        ├── Progressions/
        ├── RootTemplates/
        └── Stats/
            └── Generated/
                └── Data/
                    ├── Character.txt
                    ├── Interrupt.txt
                    ├── Object.txt
                    ├── Passive.txt
                    ├── Spell_Projectile.txt
                    ├── Spell_Shout.txt
                    ├── Spell_Target.txt
                    ├── Spell_Zone.txt
                    ├── Status_BOOST.txt
                    └── Status_EFFECT.txt
```

---

## SECTION 2: CRITICAL MISSING FILES/FOLDERS

### 2.1 **LOCALIZATION LOCATION** ⚠️⚠️⚠️
**DemonHunter**: Localization/ at ROOT level (sibling to Mods/ and Public/)
**Warlock**: Localization/ INSIDE Mods/ModName/ folder
**Our mod**: NONE (we removed it after crashes)

**Both working patterns**:
- DemonHunter: Has TWO files - `WoWDemonHunterClass.xml` AND `WoWDemonHunterClass.loca.xml`
- Warlock: Has ONE file - `english.xml` (lowercase)

### 2.2 **ProgressionDescriptions.lsx** ⚠️
**DemonHunter has this file**: `Public/WoWDemonHunterClass/Progressions/ProgressionDescriptions.lsx`
- Contains nodes linking class names to progression table UUIDs
- Has `Type` attribute matching class `Name` (e.g., "WoWDemonHunter")
- **Our mod**: MISSING THIS FILE

### 2.3 **ActionResourceGroupDefinitions** ⚠️
**DemonHunter has this**: `Public/WoWDemonHunterClass/ActionResourceGroupDefinitions/ActionResourceGroupDefinitions.lsx`
- Groups action resources together
- References the ActionResourceDefinition UUID
- **Our mod**: MISSING THIS FILE

### 2.4 **Equipment.txt**
**DemonHunter has this**: `Stats/Generated/Equipment.txt`
- Defines `EQP_CC_DemonHunter` with weapon and armor sets
- References specific weapons and armor pieces
- **Our mod**: MISSING - We reference `EQP_CC_Barbarian` (vanilla)

---

## SECTION 3: meta.lsx COMPARISON

### 3.1 Our Meta (BG3Wow)
```xml
- Dependencies: ONLY GustavX
- Scripts node: EMPTY <node id="Scripts"/>
- Version: major="4" minor="8" revision="0" build="500"
```

### 3.2 DemonHunter Meta
```xml
- Dependencies: NONE (empty Dependencies node)
- Scripts node: EMPTY
- Version: major="4" minor="0" revision="9" build="331"  (OLDER VERSION)
- Has TargetModes node with "Story" target
```

### 3.3 Warlock Meta
```xml
- Dependencies: 13 MODS!
  - DiceSet_01, DiceSet_02, DiceSet_03, DiceSet_06
  - MainUI, ModBrowser, PhotoMode, CrossplayUI
  - Gustav, GustavDev, GustavX
  - ImpUI (ImprovedUI) - PublishHandle: 4138213
  - VFX_Library_VladsCodex
- Scripts node: HAS 2 SCRIPT ENTRIES with UUID and Parameters
- Version: major="4" minor="8" revision="0" build="500" (SAME AS OURS)
```

**⚠️ KEY FINDING**: Warlock has extensive dependencies and populated Scripts node. DemonHunter has NEITHER.

---

## SECTION 4: ClassDescriptions.lsx COMPARISON

### 4.1 Our Current ClassDescriptions (SIMPLIFIED - CRASHES)
**Base Class Attributes**:
- BaseHp, CharacterCreationPose, ClassEquipment, Description, DisplayName
- HasGod, HpPerLevel, LearningStrategy, MustPrepareSpells, Name
- PrimaryAbility, ProgressionTableUUID, SoundClassType, SpellCastingAbility, UUID
- Tags node

**MISSING**: ClassHotbarColumns, CommonHotbarColumns, ItemsHotbarColumns, ShortName, CanLearnSpells, SpellList, Icon, MulticlassSpellcasterModifier

**Subclasses**:
- CharacterCreationPose, ClassEquipment, Description, DisplayName
- LearningStrategy, MustPrepareSpells, Name, ParentGuid
- PrimaryAbility, ProgressionTableUUID, SoundClassType, SpellCastingAbility
- SubclassTitle (⚠️ BUT NOT ON DEMON HUNTER!), UUID, Tags

### 4.2 DemonHunter ClassDescriptions
**Base Class Attributes**:
- BaseHp, CharacterCreationPose, ClassEquipment, Description, DisplayName
- HasGod, HpPerLevel, LearningStrategy, **MulticlassSpellcasterModifier** ⚠️
- MustPrepareSpells, Name, PrimaryAbility, ProgressionTableUUID
- SoundClassType, SpellCastingAbility, **Icon** ⚠️, UUID, Tags

**HAS**: Icon, MulticlassSpellcasterModifier
**MISSING**: ClassHotbarColumns, ShortName, CanLearnSpells, SpellList, SubclassTitle

**Subclasses**: SAME attributes as base EXCEPT:
- Removes: BaseHp, HasGod, HpPerLevel, MulticlassSpellcasterModifier
- Adds: ParentGuid
- Still has: Icon attribute

### 4.3 Warlock ClassDescriptions
**Base Class Attributes**:
- BaseHp, **CanLearnSpells**, CharacterCreationPose, ClassEquipment
- **ClassHotbarColumns=5, CommonHotbarColumns=9, ItemsHotbarColumns=2** ⚠️
- Description, DisplayName, HpPerLevel, LearningStrategy, MustPrepareSpells
- Name, PrimaryAbility, ProgressionTableUUID, **ShortName**
- SoundClassType, SpellCastingAbility, **SpellList (REAL GUID)** ⚠️, UUID, Tags

**Subclasses**: ALL SAME ATTRIBUTES AS BASE CLASS (including hotbar columns, ShortName, SpellList)

**⚠️ CRITICAL DIFFERENCE**: Warlock uses FULL attributes on ALL classes. DemonHunter uses MINIMAL attributes.

---

## SECTION 5: ActionResourceDefinitions COMPARISON

### 5.1 Our Rage Resource
```xml
<attribute id="MaxLevel" type="uint32" value="0"/>
<attribute id="MaxValue" type="uint32" value="100"/>
<attribute id="Name" type="FixedString" value="Rage"/>
<attribute id="ReplenishType" type="FixedString" value="Never"/>
<attribute id="ShowOnActionResourcePanel" type="bool" value="true"/>
<attribute id="UUID" ...
```

### 5.2 DemonHunter DemonicFury Resource
```xml
<attribute id="MaxLevel" type="uint32" value="0"/>
<attribute id="Name" type="FixedString" value="DemonicFury"/>
<attribute id="ReplenishType" type="FixedString" value="ShortRest"/>  ⚠️ DIFFERENT
<attribute id="ShowOnActionResourcePanel" type="bool" value="true"/>
<attribute id="UUID" ...
```
**⚠️ NOTE**: DemonHunter MISSING `MaxValue` attribute!

---

## SECTION 6: Progressions.lsx COMPARISON

### 6.1 Our Structure
- Uses `<children><node id="Selectors"><children>` structure
- Has `SubClasses` node at Level 1 listing all subclass UUIDs
- Uses `AddSpells` inside Selectors with `Spells` attribute
- Has both regular and multiclass Level 1 entries

### 6.2 DemonHunter Structure  
- Uses `Selectors` attribute="..." (INLINE STRING, not nested nodes) ⚠️⚠️⚠️
- Has `SubClasses` node at Level 1
- Example: `<attribute id="Selectors" type="LSString" value="SelectSkills(...),SelectAbilityBonus(...)"/>`
- Has both regular and multiclass Level 1 entries

**⚠️ MAJOR DIFFERENCE**: DemonHunter uses STRING-BASED selectors, we use NESTED XML nodes!

### 6.3 Both Have
- SubClasses node listing subclass UUIDs
- Boosts, PassivesAdded, TableUUID, UUID
- Multiclass variants at Level 1

---

## SECTION 7: LOCALIZATION FORMATS

### 7.1 DemonHunter Localization (WoWDemonHunterClass.xml)
```xml
<?xml version="1.0" encoding="utf-8"?>
<contentList>
  <content contentuid="h113ba9cbgebe3g4971ga06ag961e06c51d52" version="1">Demon Hunter</content>
  ...
```
- Encoding: `utf-8`
- NO xmlns attributes
- Handle format: `h[8hex]g[4hex]g[4hex]g[4hex]g[12hex]` (WITH 'g' SEPARATORS) ⚠️

### 7.2 Warlock Localization (english.xml)
```xml
<?xml version="1.0"?>
<contentList xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
  <content contentuid="h95e35621g226eg9e0dgda9bg4abc636f1d06" version="3">Warlock</content>
  ...
```
- NO encoding attribute
- HAS xmlns:xsd and xmlns:xsi attributes
- Handle format: SAME as DemonHunter (with 'g' separators)

### 7.3 Our Handles (WRONG FORMAT)
- Our handles: `h5a8b9c0d1e2f3a4b5c6d7e8f9a0b1c2d` (continuous hex, NO 'g' separators) ⚠️⚠️⚠️
- Should be: `h5a8b9c0dg1e2fg3a4bg5c6dg7e8f9a0b1c2d`

---

## SECTION 8: KEY FINDINGS SUMMARY

### 8.1 CRITICAL ISSUES (Likely Causing Crashes/Invisibility)

1. **❌ LOCALIZATION HANDLES FORMAT WRONG**
   - Our handles: `h5a8b9c0d1e2f...` (no separators)
   - Should be: `h5a8b9c0dg1e2fg3a4b...` (with 'g' separators)
   - **All working mods use 'g' separator format**

2. **❌ MISSING ProgressionDescriptions.lsx**
   - DemonHunter has this file linking class Type to ProgressionTableUUID
   - Links DisplayName/Description handles to progression table
   - **Our mod completely lacks this file**

3. **❌ MISSING ActionResourceGroupDefinitions.lsx**
   - DemonHunter has this grouping resources
   - May be required for custom resource to display correctly

4. **❌ LOCALIZATION LOCATION UNCLEAR**
   - DemonHunter: Root level (sibling to Mods/)
   - Warlock: Inside Mods/ModName/
   - We removed it entirely after crashes

5. **❌ PROGRESSIONS SELECTOR FORMAT DIFFERENT**
   - DemonHunter uses: `<attribute id="Selectors" type="LSString" value="...">`
   - We use: `<children><node id="Selectors"><children><node id="AddSpells">...</node>...`
   - **Nested XML vs inline string - major structural difference**

### 8.2 MODERATE CONCERNS

6. **⚠️ MISSING Equipment.txt**
   - We reference `EQP_CC_Barbarian` (vanilla)
   - DemonHunter defines custom `EQP_CC_DemonHunter`
   - May not matter if vanilla equipment works

7. **⚠️ MISSING Icon Attribute**
   - DemonHunter has `Icon` on all class descriptions
   - We don't have this at all

8. **⚠️ MISSING SubclassTitle on Subclasses**
   - We have this attribute on our subclasses
   - DemonHunter does NOT
   - Inconsistent with working mod

### 8.3 PROBABLY FINE

9. **✅ Dependencies in meta.lsx**
   - DemonHunter works with ZERO dependencies
   - Our single GustavX dependency should be fine

10. **✅ Scripts Node**
    - DemonHunter works with empty Scripts
    - Warlock has populated Scripts but for different features

---

## SECTION 9: RECOMMENDED FIXES (Priority Order)

### **PRIORITY 1: FIX LOCALIZATION HANDLES** ⚠️⚠️⚠️
All handles must use format: `h[8hex]g[4hex]g[4hex]g[4hex]g[12hex]`

Example conversions:
- ❌ `h5a8b9c0d1e2f3a4b5c6d7e8f9a0b1c2d`
- ✅ `h5a8b9c0dg1e2fg3a4bg5c6dg7e8f9a0b1c2d`

**Files to fix**:
- ClassDescriptions.lsx (all DisplayName/Description handles)
- ActionResourceDefinitions.lsx (resource handles)
- Progressions.lsx (any description handles)

### **PRIORITY 2: ADD ProgressionDescriptions.lsx**
Create file: `Public/BG3Wow_.../Progressions/ProgressionDescriptions.lsx`

Structure:
```xml
<node id="ProgressionDescription">
    <attribute id="Description" handle="..." />
    <attribute id="DisplayName" handle="..." />
    <attribute id="ProgressionTableId" value="a1b2c3d4-e5f6-7a8b-9c0d-1e2f3a4b5c6d"/>
    <attribute id="Type" type="FixedString" value="WoWWarrior"/>
    <attribute id="UUID" type="guid" value="NEW-UUID"/>
</node>
```

### **PRIORITY 3: ADD Icon Attribute to ClassDescriptions**
Add to all class descriptions (base + subclasses):
```xml
<attribute id="Icon" type="FixedString" value="Icon_Barbarian" />
```

### **PRIORITY 4: CONSIDER Progressions Selector Format**
Test if nested XML `<node id="Selectors">` vs inline `attribute id="Selectors"` matters.
DemonHunter uses inline format successfully.

### **PRIORITY 5: ADD ActionResourceGroupDefinitions** (if needed)
May be required for Rage to display properly.

### **PRIORITY 6: ADD LOCALIZATION BACK**
Once handles are fixed, add localization folder.
**Test both locations**:
1. Root level (like DemonHunter)
2. Inside Mods/ModName/ (like Warlock)

---

## SECTION 10: TESTING PROTOCOL

After implementing fixes, test in this order:

1. **Fix handles only** → Package → Test (does it load without crash?)
2. **Add ProgressionDescriptions** → Package → Test (does class appear?)
3. **Add Icon attribute** → Package → Test (visual improvements?)
4. **Add localization** → Package → Test (handles resolve to text?)
5. **Add Equipment.txt** → Package → Test (custom starting gear?)

**DO NOT change multiple things at once** - we need to know which fix works!
