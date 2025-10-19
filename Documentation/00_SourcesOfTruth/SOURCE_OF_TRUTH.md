# WoW Classes for BG3 - Complete Source of Truth

**Living Document - Always Current**

## Document Metadata

**Created**: October 19, 2025  
**Last Major Update**: October 19, 2025 - Structure created  
**Project Scope**: World of Warcraft class implementations for Baldur's Gate 3  
**Current Class**: Warrior (v1.0.1.0)  
**Future Classes**: Warlock, Death Knight, Paladin, etc.  
**Game Version**: Patch 8 (BG3 v4.8.0.10)

## Change Log (Last 10 Updates)

| Date | Section | Change | Reason |
|------|---------|--------|--------|
| Oct 19, 2025 | [3] Class Details | Added Subsection 3.1: Base Class Definition with full XML structure, attribute breakdown, validation checklist | User request - build Section [3] systematically using FILE_02_TEMPLATE.md as source |
| Date | Section | Change | Reason |
|------|---------|--------|--------|
| Oct 19, 2025 | [3] Class Details | Updated Ability Score Values Reference table to show WoW classes across all 12 planned mods | User request - replace BG3 classes with WoW class mappings, show which specs use each ability |
| Oct 19, 2025 | [1] Overview | Marked Progression Structure as TBD until Section [6] complete | User request - defer detailed progression until Section [6] is built |
| Oct 19, 2025 | [1] Overview | Changed Hit Dice format from "d#" to numeric (10, 8, 12) | User request - cleaner format, matches HP per level display |
| Oct 19, 2025 | [1] Overview | Adjusted hit dice by subclass: Arms 10, Fury 8, Protection 12 | User request - match flavor (Fury glass cannon, Protection tank durability) |
| Oct 19, 2025 | [1] Overview | Added secondary abilities, adjusted Fury to medium armor only, swapped Protection primary/secondary | User request - Fury mobility focus, Protection tank identity (CON primary) |
| Oct 19, 2025 | [1] Overview | Added class attributes to each Warrior subclass with flavor-specific equipment | User request - show subclass mechanical differences |
| Oct 19, 2025 | [1] Overview | Added hero talent options for all 12 future classes | User request - show complete class design vision |
| Oct 19, 2025 | [1] Overview | Changed "Specializations" to "Subclasses" (BG3 terminology) | User correction - match game's class system terminology |
| Oct 19, 2025 | [1] Overview | Corrected subclass selection from L3 to L1 (3 locations) | User correction - spec choice happens at level 1 |
| Oct 19, 2025 | [1] Overview | Improved formatting with clear separators, Warrior-specific subheadings | User request - better readability, distinguish universal vs class-specific content |
| Oct 19, 2025 | [1] Overview | Expanded future class list to all 12 WoW classes, removed reference UUIDs | User request - show complete vision, UUIDs will be created fresh |
| Oct 19, 2025 | [1] Overview | Clarified Warlock as template source, expanded future class list with UUIDs | User request - make template source clear + complete class list |
| Oct 19, 2025 | [2] Meta Information | Section completed with comprehensive meta.lsx data | Consolidated from FILE_01 template + actual meta.lsx + comparison analysis |
| Oct 19, 2025 | [1] Overview | Updated to reflect WoW Classes project scope (not just Warrior) | User feedback - document covers entire project |
| Oct 19, 2025 | [1] Overview | Section completed with comprehensive project overview | Initial content build - Phase 3 |
| Oct 19, 2025 | [Created] | Initial SOURCE_OF_TRUTH.md structure | Establish single source of truth |

## How to Use This Document

### For AI Agents:
1. **ALWAYS read relevant section BEFORE making changes**
2. **ALWAYS update section AFTER changes + tests pass**
3. **NEVER skip cross-reference validation**
4. **NEVER use Archive/ information without user request**

### For Users:
- This is the single source of truth for the WoW Classes for BG3 project
- Currently focused on Warrior class, expandable to other WoW classes
- All information is current and validated
- Archive/ folders contain old/outdated information
- Check "Last Updated" timestamps to see freshness

### Sections:
1. [Overview](#1-overview)
2. [Meta Information](#2-meta-information)
3. [Class Details](#3-class-details)
4. [Subclasses](#4-subclasses)
5. [Specializations/Hero Classes](#5-specializationshero-classes-l13-20)
6. [Progression](#6-progression)
7. [Lists - Spells](#7-lists---spells)
8. [Lists - Status](#8-lists---status)
9. [Lists - Passive](#9-lists---passive)
10. [Action Resources](#10-action-resources)
11. [File Transformation Status](#11-file-transformation-status)
12. [Folder Structure Inventory](#12-folder-structure-inventory)

---

## [1] Overview

**Status**: ✅ Complete  
**Last Updated**: October 19, 2025

---

### Project Identity

**Project Name**: WoW Classes for Baldur's Gate 3  
**Repository**: BG3Mods  
**Game Version**: Patch 8 (BG3 v4.8.0.10)

---

### Project Description

A modding project bringing World of Warcraft's iconic classes to Baldur's Gate 3 with full BG3 integration. Each class will feature authentic WoW specializations, resource systems, and ability progressions adapted to BG3's D&D 5e-based mechanics.

---

### Template Source Mod

**WoWWarlock** (UUID: `bdb3fa73-401b-4979-f02e-485422dd8d9c`)
- **Downloads**: 13K+ (proven working structure)
- **Location**: `Tests/02_ExampleMods/ExampleMod_WoWWarlock/`
- **Purpose**: Foundation template for ALL WoW class transformations
- **Features**: 3 subclasses, Soul Shards resource, comprehensive file structure

---

### Current Focus

**Warrior Class** - First implementation using Warlock template approach

---

### Future Class Mods

All classes will use the Warlock template transformation methodology:

1. **Warlock** - Affliction/Demonology/Destruction
   - Hero Talents: Diabolist, Hellcaller, Soul Harvester

2. **Death Knight** - Blood/Frost/Unholy
   - Hero Talents: Deathbringer, Rider of the Apocalypse, San'layn

3. **Priest** - Discipline/Holy/Shadow
   - Hero Talents: Archon, Oracle, Voidweaver

4. **Paladin** - Holy/Protection/Retribution
   - Hero Talents: Herald of the Sun, Lightsmith, Templar

5. **Druid** - Balance/Feral/Guardian/Restoration
   - Hero Talents: Elune's Chosen, Keeper of the Grove, Wildstalker

6. **Demon Hunter** - Havoc/Vengeance
   - Hero Talents: Aldrachi Reaver, Fel-Scarred, Felstalker

7. **Hunter** - Beast Mastery/Marksmanship/Survival
   - Hero Talents: Dark Ranger, Pack Leader, Sentinel

8. **Mage** - Arcane/Fire/Frost
   - Hero Talents: Frostfire, Spellslinger, Sunfury

9. **Monk** - Brewmaster/Mistweaver/Windwalker
   - Hero Talents: Conduit of the Celestials, Master of Harmony, Shado-Pan

10. **Rogue** - Assassination/Outlaw/Subtlety
    - Hero Talents: Deathstalker, Fatebound, Trickster

11. **Shaman** - Elemental/Enhancement/Restoration
    - Hero Talents: Farseer, Stormbringer, Totemic

12. **Evoker** - Devastation/Preservation/Augmentation
    - Hero Talents: Chronowarden, Flameshaper, Scalecommander

---

### Warrior - Current Implementation

#### Warrior Mod Metadata

| Property | Value |
|----------|-------|
| **Mod Name** | BG3Wow - World of Warcraft Warrior Class for Baldur's Gate 3 |
| **Internal Name** | WoWWarrior |
| **UUID** | `78fe4967-4e62-5491-d981-dd781acca4d7` |
| **Current Version** | v1.0.1.0 |
| **Version64** | `36028797018963968` |
| **Game Compatibility** | Baldur's Gate 3 Patch 8 (v4.8.0.10) |
| **Publish Handle** | `4763361` |

#### Warrior Features Summary

- **Three Subclasses**: Arms, Fury, Protection (chosen at L1)
- **Resource System**: Rage (0-100)
- **Abilities**: 135+ abilities spanning levels 1-20
- **Hero Talents**: Mountain Thane, Colossus, Slayer (L13-L20)

---

### Current Development Status

**Transformation Strategy**: File-by-file transformation using proven WoWWarlock mod as template  
**Method**: Systematic analyze → review → approve → transform → test workflow  
**Progress**: FILES 1-3 COMPLETE  
**Next Priority**: FILES 4-15 (Stats, Progressions, Lists, Localization, Script Extender)

#### Completed Transformations

- ✅ **FILE 1**: meta.lsx - Mod metadata, 13 dependencies, version tracking
- ✅ **FILE 2**: ClassDescriptions.lsx - Base Warrior + 3 subclasses (Arms, Fury, Protection)
- ✅ **FILE 3**: ActionResourceDefinitions.lsx - 6 custom resources (Rage + 5 charge systems)

#### Test Status

All transformed files have passing validation tests in `Transformation_Templates/Tests/`

---

### Universal Architecture Patterns

**Shared across all WoW class mods:**

- **File-by-File Transformation**: Systematic methodology using Warlock template
- **Test Coverage**: Every transformed file gets validation test script
- **BG3 Framework**: `.lsx` (XML-like) files + `.txt` stat files
- **Localization System**: Handle-based text references
- **Action Resources**: Class-specific resource definitions

---

### Warrior - Architecture Details

#### Naming Convention

- **Ability Prefix**: `WAR_*` (e.g., `WAR_Charge`, `WAR_Execute`)
- **Status Prefix**: `WAR_STATUS_*` or `WAR_*` (e.g., `WAR_RAGE_ACTIVE`)
- **Passive Prefix**: `WAR_*` (e.g., `WAR_Colossus_Keystone`)

#### Resource Systems

- **Primary**: Rage (0-100 meter)
- **Secondary**: 5 charge-based systems (DefensiveCharge, TankCooldown, MobilityCharge, OverpowerCharge, ThunderCharge)

#### Progression Structure

🚧 **To Be Completed**: Detailed progression breakdown will be added when Section [6] Progression is complete.

---

### Warrior - Key Features

#### Base Class

- **Hit Dice**: 10 (10 HP per level)
- **Primary Ability**: Strength
- **Secondary Ability**: Constitution
- **Equipment**: Heavy armor, shields, all weapons (Barbarian equipment table)
- **Starting Abilities**: Rage system unlocked at L1

#### Three Subclasses (L1 Choice)

1. **Arms** - Two-handed weapon master
   - **Hit Dice**: 10 (10 HP per level)
   - **Primary Ability**: Strength
   - **Secondary Ability**: Constitution
   - **Equipment**: Heavy armor, two-handed weapons (greatswords, greataxes, polearms)
   - **Signature Abilities**: Mortal Strike, Colossus Smash, Execute
   - **Playstyle**: Burst damage, execute mechanics, tactical strikes

2. **Fury** - Dual-wield berserker
   - **Hit Dice**: 8 (8 HP per level)
   - **Primary Ability**: Strength
   - **Secondary Ability**: Dexterity
   - **Equipment**: Medium armor, dual-wielding any one-handed weapons
   - **Signature Abilities**: Bloodthirst, Rampage, Raging Blow
   - **Playstyle**: High mobility, sustained damage, relentless offense

3. **Protection** - Sword and shield tank
   - **Hit Dice**: 12 (12 HP per level)
   - **Primary Ability**: Constitution
   - **Secondary Ability**: Strength
   - **Equipment**: Heavy armor, shields, one-handed weapons (swords, axes, maces)
   - **Signature Abilities**: Shield Slam, Shield Block, Revenge
   - **Playstyle**: Defensive mastery, high survivability, battlefield control

#### Hero Talents (L13-L20)

- **Mountain Thane** (Fury + Protection)
  - Theme: Thunder-themed abilities
  - Structure: 4-tier talent tree
  - Signature: Lightning Strikes, Crash of Thunder

- **Colossus** (Arms + Protection)
  - Theme: Titan-themed strength
  - Structure: 3-tier talent tree
  - Signature: Colossal Might, Demolish

- **Slayer** (Arms + Fury)
  - Theme: Execution specialist
  - Structure: 3-tier talent tree
  - Signature: Brutal Finish, Culling Strike

---

### Warrior - File Structure

**Mod Files Location**: `Data/Mods/Warrior_Wow_78fe4967-4e62-5491-d981-dd781acca4d7/`  
**Public Files Location**: `Data/Public/Warrior_Wow_78fe4967-4e62-5491-d981-dd781acca4d7/`

#### Critical Files

| File | Location | Purpose |
|------|----------|---------|
| `meta.lsx` | Mods/ | Mod metadata, 13 dependencies |
| `ClassDescriptions.lsx` | Public/ClassDescriptions/ | Class and subclass definitions |
| `ActionResourceDefinitions.lsx` | Public/ActionResourceDefinitions/ | Rage + 5 charge resources |
| `Progressions.lsx` | Public/Progressions/ | Level-by-level ability grants |
| `SpellLists.lsx` | Public/Lists/ | 62 spell lists (base + subclasses + hero talents) |
| `PassiveLists.lsx` | Public/Lists/ | Passive ability organization (to be created) |
| `Spell_*.txt` | Public/Stats/Generated/Data/ | Spell definitions |
| `Status_BOOST.txt` | Public/Stats/Generated/Data/ | Status effects |
| `Passive.txt` | Public/Stats/Generated/Data/ | Passive abilities |
| `English.loca.xml` | Mods/Localization/English/ | All user-facing text |

---

### Warrior - Backups

**Full Mod Backup**: `Tests/04_Backups/WARRIOR_BACKUP_BEFORE_TEMPLATE_20251018_183829/`

- **Purpose**: Original Warrior implementation before Warlock template applied
- **Contains**: All original files including Progressions.lsx with L1-L20 data
- **Use Case**: Rollback point if transformation issues arise

---

### Documentation Structure

**Living Document**: `Documentation/00_SourcesOfTruth/SOURCE_OF_TRUTH.md` (this file)  
**Scope**: Covers entire WoW Classes for BG3 project (currently Warrior-focused, expandable)

#### Documentation Folders

| Folder | Purpose | Examples |
|--------|---------|----------|
| **00_SourcesOfTruth/** | Authoritative living documents | SOURCE_OF_TRUTH.md |
| **01_Reference-Guides/** | Project navigation, indexes | PROJECT_INDEX.md |
| **06_ProjectDocuments/** | Cross-class implementation guides | PASSIVES_MASTER.md |
| **07_DesignDocuments/** | Class blueprints | Warrior_Class_Blueprint.md |
| **Transformation_Templates/** | FILE_##_*.md templates | FILE_01_meta.lsx_TEMPLATE.md |
| **Reports/02_Transformation/** | File-by-file methodology | FILE_BY_FILE_TRANSFORMATION_PLAN.md |

---

### Active Development Protocols

**Universal Protocols** (apply to all WoW class mods):

1. **SOURCE_OF_TRUTH Protocol**: Always read this document before changes, update after changes
2. **File-by-File Transformation**: Complete each file fully before moving to next
3. **Test-Driven**: Every transformed file gets validation test script
4. **User Approval**: No changes without explicit user approval
5. **Change Tracking**: All updates logged with timestamps and reasons

**Note**: Sections [1]-[12] currently contain Warrior-specific data but structure is reusable for future classes

---

## [2] Meta Information

**Status**: ✅ Complete  
**Last Updated**: October 19, 2025

### File Location

**Actual File**: `Data/Mods/Warrior_Wow_78fe4967-4e62-5491-d981-dd781acca4d7/meta.lsx`  
**Template Reference**: `Transformation_Templates/FILE_01_meta.lsx_TEMPLATE.md`

### Core Metadata

| Property | Value | Purpose |
|----------|-------|---------|
| **Author** | `vorgx` | Mod creator identification |
| **Name** | `WoWWarrior` | Internal mod name (displayed in mod manager) |
| **Description** | `Implementing Warrior class from World of Warcraft.` | User-facing mod description |
| **UUID** | `78fe4967-4e62-5491-d981-dd781acca4d7` | **CRITICAL**: Unique mod identifier |
| **Folder** | `Warrior_Wow_78fe4967-4e62-5491-d981-dd781acca4d7` | Folder name (must match UUID) |
| **Version64** | `36028797018963968` | Mod version (v1.0.0.0 in BG3 format) |
| **PublishVersion** | `36028797018963968` | Published version (matches Version64) |
| **PublishHandle** | `4763361` | Nexus Mods/mod.io handle |
| **FileSize** | `21033609` | Package size in bytes (~21 MB) |

### XML Version

```xml
<version major="4" minor="8" revision="0" build="500"/>
```

**Game Compatibility**: Patch 8 (BG3 v4.8.0.10+)

### Folder Naming Convention

**Pattern**: `{ClassIdentifier}_Wow_{UUID}`

**Warrior Implementation**:
- **Mods folder**: `Data/Mods/Warrior_Wow_78fe4967-4e62-5491-d981-dd781acca4d7/`
- **Public folder**: `Data/Public/Warrior_Wow_78fe4967-4e62-5491-d981-dd781acca4d7/`

**⚠️ CRITICAL**: Both folder names MUST match the UUID exactly. Mismatch causes mod loading failure.

### Dependencies (13 Total)

All dependencies inherited from WoWWarlock template (proven working pattern):

#### Base Game Dependencies (3)

| Name | UUID | Version64 | Purpose |
|------|------|-----------|---------|
| **Gustav** | `991c9c7a-fb80-40cb-8f0d-b92d4e80e9b1` | `36029301684370529` | Base game core |
| **GustavDev** | `28ac9ce2-2aba-8cda-b3b5-6e922f71b6b8` | `145100393449790344` | Development tools |
| **GustavX** | `cb555efe-2d9e-131f-8195-a89329d218ea` | `145241302737902957` | Patch 8 expansion |

#### UI Dependencies (4)

| Name | UUID | Version64 | Purpose |
|------|------|-----------|---------|
| **MainUI** | `630daa32-70f8-3da5-41b9-154fe8410236` | `36028797018963968` | Main user interface |
| **ModBrowser** | `ee5a55ff-eb38-0b27-c5b0-f358dc306d34` | `36028797018963968` | Mod management UI |
| **PhotoMode** | `55ef175c-59e3-b44b-3fb2-8f86acc5d550` | `36028797018963968` | Photo mode UI |
| **CrossplayUI** | `e1ce736b-52e6-e713-e9e7-e6abbb15a198` | `36028797018963968` | Crossplay interface |

#### Dice Set Dependencies (4)

| Name | UUID | Version64 | Purpose |
|------|------|-----------|---------|
| **DiceSet_01** | `e842840a-2449-588c-b0c4-22122cfce31b` | `36028797018963968` | Dice cosmetics |
| **DiceSet_02** | `b176a0ac-d79f-ed9d-5a87-5c2c80874e10` | `36028797018963968` | Dice cosmetics |
| **DiceSet_03** | `e0a4d990-7b9b-8fa9-d7c6-04017c6cf5b1` | `36028797018963968` | Dice cosmetics |
| **DiceSet_06** | `ee4989eb-aab8-968f-8674-812ea2f4bfd7` | `36028797018963968` | Dice cosmetics |

#### Community Mod Dependencies (2)

| Name | UUID | PublishHandle | Version64 | Purpose |
|------|------|---------------|-----------|---------|
| **ImpUI (ImprovedUI)** | `26922ba9-6018-5252-075d-7ff2ba6ed879` | `4138213` | `72198331526283346` | UI enhancements |
| **VFX_Library_VladsCodex** | `fd03819b-cec2-c351-1680-81f1f1e52c76` | `0` | `36028797018963971` | Visual effects library |

**Note**: These dependencies are from the Warlock template. They ensure compatibility with common mods and DLCs.

### Script Extender Integration

**Scripts Node**: Contains 2 Script entries for Script Extender integration

```xml
<node id="Scripts">
    <children>
        <node id="Script">
            <attribute id="UUID" type="FixedString" value="1953f77d-a201-45d7-a194-9b84c34b8461"/>
            <children>
                <node id="Parameters">
                    <children>
                        <node id="Parameter">
                            <attribute id="MapKey" type="FixedString" value="HardcoreOnly"/>
                            <attribute id="Type" type="int32" value="1"/>
                            <attribute id="Value" type="LSString" value="0"/>
                        </node>
                    </children>
                </node>
            </children>
        </node>
        <node id="Script">
            <attribute id="UUID" type="FixedString" value="0d6510f5-50a3-4ecd-83d8-134c9a640324"/>
            <children>
                <node id="Parameters">
                    <children>
                        <node id="Parameter">
                            <attribute id="MapKey" type="FixedString" value="HardcodeOnly"/>
                            <attribute id="Type" type="int32" value="1"/>
                            <attribute id="Value" type="LSString" value="0"/>
                        </node>
                    </children>
                </node>
            </children>
        </node>
    </children>
</node>
```

**Script UUIDs**:
- `1953f77d-a201-45d7-a194-9b84c34b8461` - Primary Script Extender hook
- `0d6510f5-50a3-4ecd-83d8-134c9a640324` - Secondary Script Extender hook

**Parameters**: Both scripts have `HardcoreOnly=0` (mod works in all game modes)

### Version Management Strategy

**Current Version**: v1.0.0.0 (`Version64` = `36028797018963968`)

**Version Format**: BG3 uses `Version64` (int64) encoding semantic versions:
- Major version in high bits
- Minor/patch/build in lower bits
- Example: `36028797018963968` = v1.0.0.0

**Versioning Protocol**:
1. Increment version for each release
2. Update both `Version64` and `PublishVersion` attributes
3. Update `PublishVersion` child node to match
4. Document changes in `CHANGELOG.md`

**Version History**:
- v1.0.0.0 (`36028797018963968`) - Initial release with FILES 1-3 complete

### UUID Consistency Rules

**CRITICAL**: The following MUST all match `78fe4967-4e62-5491-d981-dd781acca4d7`:

1. ✅ `meta.lsx` → `<attribute id="UUID" value="78fe4967-4e62-5491-d981-dd781acca4d7"/>`
2. ✅ `meta.lsx` → `<attribute id="Folder" value="Warrior_Wow_78fe4967-4e62-5491-d981-dd781acca4d7"/>`
3. ✅ Folder name: `Data/Mods/Warrior_Wow_78fe4967-4e62-5491-d981-dd781acca4d7/`
4. ✅ Folder name: `Data/Public/Warrior_Wow_78fe4967-4e62-5491-d981-dd781acca4d7/`
5. ✅ `ClassDescriptions.lsx` → Base class UUID
6. ✅ All documentation references

**Validation**: Run `Test-MetaLsx.ps1` to verify UUID consistency across all files.

### Historical Context

**Design Source**: `Documentation/07_DesignDocuments/Warrior_Class_Blueprint.md`  
**Comparison Analysis**: `Tests/05_Troubleshooting/COMPREHENSIVE_MOD_COMPARISON.md`

**Key Findings from Analysis**:
- WoWWarlock (working mod) has 13 dependencies → We inherited all 13
- WoWWarlock has 2 Script entries → We inherited structure
- DemonHunter (working mod) has 0 dependencies → Proves dependencies are optional but we kept them for compatibility
- Empty Scripts node caused crashes in testing → Populated structure resolved issues

### Cross-References

- **Actual File**: `Data/Mods/Warrior_Wow_78fe4967-4e62-5491-d981-dd781acca4d7/meta.lsx`
- **Template**: `Transformation_Templates/FILE_01_meta.lsx_TEMPLATE.md`
- **Test Script**: `Transformation_Templates/Tests/FILE_01_Test-MetaLsx.ps1`
- **Test Results**: Run `Test-AllFiles.ps1` (FILE 1 should pass with all validations)

---

## [3] Class Details

**Status**: ✅ Complete  
**Last Updated**: October 19, 2025

---

### Base Class Definition

#### Overview

The **Warrior** class is a custom implementation of World of Warcraft's iconic melee combatant, adapted to Baldur's Gate 3's D&D 5e-based mechanics. Warriors excel at close-quarters combat, wearing heavy armor and wielding any weapon with devastating proficiency. They harness **Rage** (a custom resource system) to fuel powerful abilities across three distinct specializations.

**Class Identity**: Martial combat masters who generate Rage through dealing and taking damage, then expend it to unleash devastating attacks, defensive maneuvers, or tactical strikes.

---

#### Core Attributes

**File Location**: `Data/Public/Warrior_Wow_78fe4967-4e62-5491-d981-dd781acca4d7/ClassDescriptions/ClassDescriptions.lsx`

```xml
<node id="ClassDescription">
    <attribute id="BaseHp" type="int32" value="10"/>
    <attribute id="CanLearnSpells" type="bool" value="false"/>
    <attribute id="CharacterCreationPose" type="guid" value="0f07ec6e-4ef0-434e-9a51-1353260ccff8"/>
    <attribute id="ClassEquipment" type="FixedString" value="EQP_CC_Barbarian"/>
    <attribute id="ClassHotbarColumns" type="int32" value="5"/>
    <attribute id="CommonHotbarColumns" type="int32" value="9"/>
    <attribute id="Description" type="TranslatedString" handle="hec9f49b2g20fbg427bgb437gfd4041ffd5ec" version="2"/>
    <attribute id="DisplayName" type="TranslatedString" handle="h2192a15fgd3c6g47c8g8f2ag887078521591" version="1"/>
    <attribute id="HpPerLevel" type="int32" value="10"/>
    <attribute id="ItemsHotbarColumns" type="int32" value="2"/>
    <attribute id="LearningStrategy" type="uint8" value="1"/>
    <attribute id="MustPrepareSpells" type="bool" value="false"/>
    <attribute id="Name" type="FixedString" value="WoWWarrior"/>
    <attribute id="PrimaryAbility" type="uint8" value="1"/>
    <attribute id="ProgressionTableUUID" type="guid" value="a1b2c3d4-e5f6-7a8b-9c0d-1e2f3a4b5c6d"/>
    <attribute id="ShortName" type="TranslatedString" handle="h8a85b937g0dd5g280bge335gb8acaf364077" version="1"/>
    <attribute id="SoundClassType" type="FixedString" value="Barbarian"/>
    <attribute id="SpellCastingAbility" type="uint8" value="1"/>
    <attribute id="SpellList" type="guid" value="32879c22-4858-48ef-8f8d-22e6d395b396"/>
    <attribute id="UUID" type="guid" value="78fe4967-4e62-5491-d981-dd781acca4d7"/>
    <children>
        <node id="Tags">
            <attribute id="Object" type="guid" value="5804f55a-93f7-4281-9512-8d548a9e2a22"/>
        </node>
    </children>
</node>
```

---

#### Attribute Breakdown

| Attribute | Value | Purpose | Source | Status |
|-----------|-------|---------|--------|--------|
| **UUID** | `78fe4967-4e62-5491-d981-dd781acca4d7` | Unique class identifier | FILE_02_TEMPLATE.md (line 68), SOURCE_OF_TRUTH.md [2] | Changed from Warlock (`a417135a...`) |
| **Name** | `WoWWarrior` | Internal class name | FILE_02_TEMPLATE.md (line 61) | Changed from `WoWWarlock` |
| **DisplayName** | `h2192a15f...` | Localization handle ("Warrior") | FILE_02_TEMPLATE.md (line 59) | Changed from Warlock handle (`h95e35621...`) |
| **Description** | `hec9f49b2...` | Localization handle (class description) | FILE_02_TEMPLATE.md (line 58) | Changed from Warlock handle (`h45282db9...`) |
| **ShortName** | `h8a85b937...` | Localization handle (abbreviation "WAR") | FILE_02_TEMPLATE.md (line 78) | Unchanged from template |
| **BaseHp** | `10` | Starting HP at L1 | FILE_02_TEMPLATE.md (line 56), Warrior_Class_Blueprint.md | Changed from `8` (d10 vs d8 hit die) |
| **HpPerLevel** | `10` | HP gained per level | FILE_02_TEMPLATE.md (line 60) | Changed from `5` (d10 scaling) |
| **PrimaryAbility** | `1` (Strength) | Primary ability score | FILE_02_TEMPLATE.md (line 62) | Changed from `6` (Charisma) |
| **SpellCastingAbility** | `1` (Strength) | Ability for ability damage scaling | FILE_02_TEMPLATE.md (line 67) | Changed from `6` (Charisma) |
| **ClassEquipment** | `EQP_CC_Barbarian` | Starting gear table | FILE_02_TEMPLATE.md (line 57) | Changed from `EQP_CC_Warlock` |
| **SoundClassType** | `Barbarian` | Combat sound effects | FILE_02_TEMPLATE.md (line 64) | Changed from `Warlock` |
| **ProgressionTableUUID** | `a1b2c3d4...` | Links to Progressions.lsx | FILE_02_TEMPLATE.md (line 63) | Changed (placeholder, will be replaced in FILE 4) |
| **SpellList** | `32879c22...` | Spell list reference | FILE_02_TEMPLATE.md (line 79) | Unchanged (dummy UUID, see note below) |
| **CanLearnSpells** | `false` | Spell learning system | FILE_02_TEMPLATE.md (line 71) | Unchanged from template |
| **MustPrepareSpells** | `false` | Spell preparation | FILE_02_TEMPLATE.md (line 76) | Unchanged from template |
| **LearningStrategy** | `1` | BG3 class system | FILE_02_TEMPLATE.md (line 75) | Unchanged from template |
| **ClassHotbarColumns** | `5` | Hotbar layout | FILE_02_TEMPLATE.md (line 73) | Unchanged from template |
| **CommonHotbarColumns** | `9` | Common actions bar | FILE_02_TEMPLATE.md (line 74) | Unchanged from template |
| **ItemsHotbarColumns** | `2` | Item quickbar | FILE_02_TEMPLATE.md (line 74) | Unchanged from template |
| **CharacterCreationPose** | `0f07ec6e...` | Character creation pose | FILE_02_TEMPLATE.md (line 72) | Unchanged from template |
| **Tags** | `5804f55a...` | CLASS tag | FILE_02_TEMPLATE.md (line 80) | Unchanged from template |

---

#### Ability Score Values Reference

| Ability | Value | BG3 Classes | WoW Classes |
|---------|-------|-------------|-------------|
| Strength | `1` | Fighter, Barbarian | **Warrior** (Arms, Fury, Protection*), **Death Knight** (all specs), **Paladin** (Retribution, Protection*) |
| Dexterity | `2` | Rogue, Ranger, Monk | **Rogue** (all specs), **Hunter** (Survival), **Demon Hunter** (Havoc, Vengeance*), **Monk** (Windwalker) |
| Constitution | `3` | - (secondary for tanks) | **Protection Warrior***, **Protection Paladin***, **Vengeance DH***, **Guardian Druid***, **Brewmaster Monk*** (swapped to primary for tank specs) |
| Intelligence | `4` | Wizard | **Mage** (all specs), **Evoker** (all specs) |
| Wisdom | `5` | Cleric, Druid | **Druid** (Balance, Feral, Guardian, Restoration), **Monk** (Brewmaster, Mistweaver), **Shaman** (all specs), **Hunter** (Beast Mastery, Marksmanship), **Priest** (Discipline, Holy) |
| Charisma | `6` | Warlock, Sorcerer, Bard, Paladin | **Warlock** (all specs), **Paladin** (Holy), **Priest** (Shadow) |

**Note**: * indicates tank specs that swap Constitution to primary ability for survivability

**Source**: FILE_02_TEMPLATE.md (lines 83-90), Section [1] Overview (Future Class Mods)

---

#### SpellList UUID Note

**UUID**: `32879c22-4858-48ef-8f8d-22e6d395b396`

**Status**: ⚠️ **Placeholder from Warlock Template**

**Discovery** (FILE_02_TEMPLATE.md lines 28-42):
- Referenced in all ClassDescription nodes in Warlock template
- **NEVER defined** in SpellLists.lsx
- NOT used in Progressions.lsx (different UUIDs there)
- Appears to be "dummy/ghost reference" ignored by BG3 engine

**Decision**: **KEEP unchanged** until FILE 12 (SpellLists.lsx) is transformed
- Proven working pattern (WoWWarlock mod with 13K+ downloads)
- Changing it may break unknown game systems
- Abilities are granted via Progressions.lsx, not this SpellList reference

**Future**: When FILE 12 is complete, this will be updated to the real Warrior SpellList UUID that organizes our 135+ abilities.

---

#### ProgressionTableUUID Note

**UUID**: `a1b2c3d4-e5f6-7a8b-9c0d-1e2f3a4b5c6d`

**Status**: ⚠️ **Placeholder**

**Purpose**: Links this ClassDescription to the base Warrior progression table in Progressions.lsx (FILE 4).

**Source**: FILE_02_TEMPLATE.md (line 63)

**Current State**: Placeholder UUID from initial transformation.

**Future**: When FILE 4 (Progressions.lsx) is transformed, this will be replaced with the actual ProgressionTableUUID for the base Warrior L1-L20 progression.

---

#### Validation Checklist

Use this checklist to verify the base Warrior ClassDescription is correct:

**UUID Consistency**:
- [ ] Base class UUID is `78fe4967-4e62-5491-d981-dd781acca4d7`
- [ ] UUID matches Section [2] Meta Information
- [ ] UUID matches folder names (`Warrior_Wow_78fe4967-4e62-5491-d981-dd781acca4d7`)
- [ ] UUID matches `Data/Mods/.../meta.lsx` file

**Hit Dice & HP**:
- [ ] `BaseHp` = `10` (d10 starting HP)
- [ ] `HpPerLevel` = `10` (d10 HP per level)
- [ ] Values match SOURCE_OF_TRUTH.md [1] (Base Class: Hit Dice 10)

**Ability Scores**:
- [ ] `PrimaryAbility` = `1` (Strength)
- [ ] `SpellCastingAbility` = `1` (Strength)
- [ ] Values match SOURCE_OF_TRUTH.md [1] (Primary Ability: Strength)

**Equipment & Sounds**:
- [ ] `ClassEquipment` = `EQP_CC_Barbarian` (heavy armor starter gear)
- [ ] `SoundClassType` = `Barbarian` (grunt/combat sounds)

**Localization**:
- [ ] `DisplayName` handle exists in English.loca.xml (resolves to "Warrior")
- [ ] `Description` handle exists in English.loca.xml (class description)
- [ ] `ShortName` handle exists in English.loca.xml (resolves to "WAR")

**Preserved Template Values**:
- [ ] `CanLearnSpells` = `false` (Warrior doesn't learn spells)
- [ ] `MustPrepareSpells` = `false` (abilities always available)
- [ ] `ClassHotbarColumns` = `5`, `CommonHotbarColumns` = `9`, `ItemsHotbarColumns` = `2`
- [ ] `LearningStrategy` = `1`
- [ ] `CharacterCreationPose` = `0f07ec6e-4ef0-434e-9a51-1353260ccff8`

**Critical Dummy Values (Keep Unchanged)**:
- [ ] `SpellList` = `32879c22-4858-48ef-8f8d-22e6d395b396` (dummy UUID from Warlock template)
- [ ] Do NOT change SpellList UUID until FILE 12 is complete

**Placeholder Values (Will Be Replaced)**:
- [ ] `ProgressionTableUUID` = `a1b2c3d4-e5f6-7a8b-9c0d-1e2f3a4b5c6d` (placeholder for FILE 4)

**Tags**:
- [ ] `<node id="Tags">` child node exists
- [ ] Tag value = `5804f55a-93f7-4281-9512-8d548a9e2a22` (standard CLASS tag)

**XML Structure**:
- [ ] `<node id="ClassDescription">` opening tag present
- [ ] All 20 attributes present (see Attribute Breakdown table)
- [ ] `<children>` node contains `<node id="Tags">`
- [ ] All tags properly closed (`</node>`, `</children>`)

**File Validation**:
- [ ] File opens without errors in VS Code
- [ ] No XML syntax errors reported
- [ ] `get_errors` tool returns no errors for ClassDescriptions.lsx

**Test Validation**:
- [ ] Run `Test-ClassDescriptions.ps1` (FILE 2 test script)
- [ ] Base class UUID validation passes
- [ ] Hit dice values validation passes
- [ ] All required attributes validation passes

**Source Consistency**:
- [ ] Values match FILE_02_TEMPLATE.md transformation mapping (lines 56-68)
- [ ] Values match SOURCE_OF_TRUTH.md [1] Overview (Base Class section)
- [ ] Values match actual ClassDescriptions.lsx file (NODE 1)

---

#### Cross-References

- **Section [2] Meta Information**: UUID consistency validation
- **Section [4] Subclasses**: Arms/Fury/Protection ClassDescription nodes (NODE 2/3/4)
- **Section [6] Progression**: ProgressionTableUUID links to level-by-level progression
- **Section [10] Action Resources**: Rage resource system details
- **FILE 2 Template**: `Transformation_Templates/FILE_02_ClassDescriptions.lsx_TEMPLATE.md`
- **FILE 2 Test**: `Transformation_Templates/Tests/Test-ClassDescriptions.ps1`
- **FILE 4 (Future)**: Progressions.lsx will replace placeholder ProgressionTableUUID
- **FILE 12 (Future)**: SpellLists.lsx will replace dummy SpellList UUID
- **FILE 15 (Future)**: English.loca.xml contains localization handles

---

## [4] Subclasses

**Status**: 🚧 Under Construction  
**Last Updated**: TBD

*Content will be added in Phase 3 with feedback loops active*

---

## [5] Specializations/Hero Classes L13-20

**Status**: 🚧 Under Construction  
**Last Updated**: TBD

*Content will be added in Phase 3 with feedback loops active*

---

## [6] Progression

**Status**: 🚧 Under Construction  
**Last Updated**: TBD

**📋 EXCEL REFERENCE REQUIRED**: When building this section, use `Warrior Progression for all subclasses.xlsx` as primary source.

**Key Data to Extract**:
- Baseline abilities unlock levels (L1-12, different order per subclass)
- Class Talents (Pool 1, Rows 1-10) - shared by all Warriors
- SubclassSpec Talents (Pool 2, Rows 1-10) - unique per subclass
- Specialization talents (L13-20) - auto-granted per specialization choice
- Total player choices per level (see EXCEL_WARRIOR_PROGRESSION_ANALYSIS.md for breakdown)

**Excel Columns**:
- Arms Baseline: Cols 4-5
- Protection Baseline: Cols 6-8
- Fury Baseline: Cols 9-10
- Class Talents: Cols 11-23
- Arms Spec Talents: Cols 24-36
- Fury Spec Talents: Cols 37-47
- Protection Spec Talents: Cols 48-55
- Mountain Thane: Cols 56-58 (Protection + Fury)
- Colossus: Cols 59-61 (Arms + Protection)
- Slayer: Cols 62-64 (Arms + Fury)

**Analysis Document**: `EXCEL_WARRIOR_PROGRESSION_ANALYSIS.md` (571 lines, complete breakdown)  
**Ability Count**: `EXCEL_ABILITY_COUNT_SUMMARY.md` (200+ abilities/passives/talents total)

*Content will be added in Phase 3 with feedback loops active*

---

## [7] Lists - Spells

**Status**: 🚧 Under Construction  
**Last Updated**: TBD

**📋 EXCEL REFERENCE REQUIRED**: When building this section, use `Warrior Progression for all subclasses.xlsx` to identify all spell abilities.

**Ability Categories from Excel**:
- **Baseline Abilities (12)**: Whirlwind, Charge, Execute, Pummel, Hamstring, Battle Shout, Slam, Berserker Rage, Victory Rush, Taunt, Heroic Throw, Shield Slam
- **Class Talent Abilities (~15)**: Heroic Leap, Storm Bolt, Intervene, Thunder Clap, Shockwave, Spell Reflection, Champion's Spear, Thunderous Roar, Avatar, etc.
- **Arms Spec Abilities (~10)**: Mortal Strike, Overpower, Colossus Smash, Warbreaker, Bladestorm, etc.
- **Fury Spec Abilities (~10)**: Bloodthirst, Raging Blow, Rampage, Recklessness, Onslaught, Odyn's Fury, etc.
- **Protection Spec Abilities (~8)**: Ignore Pain, Revenge, Demoralizing Shout, Last Stand, Shield Wall, Indomitable, Shield Charge, etc.
- **Specialization Abilities (~10)**: Lightning Strikes, Demolish, Thunder Blast, Arterial Blows, Death Drive, etc.

**Total Active Abilities**: ~65 spell entries across all stat files

**Analysis Document**: `EXCEL_ABILITY_COUNT_SUMMARY.md` (complete inventory with row breakdowns)

*Content will be added in Phase 3 with feedback loops active*

---

## [8] Lists - Status

**Status**: 🚧 Under Construction  
**Last Updated**: TBD

*Content will be added in Phase 3 with feedback loops active*

---

## [9] Lists - Passive

**Status**: 🚧 Under Construction  
**Last Updated**: TBD

**📋 EXCEL REFERENCE REQUIRED**: When building this section, use `Warrior Progression for all subclasses.xlsx` to identify all passive abilities.

**Passive Categories from Excel**:
- **Baseline Passives (3, Protection-only)**: Mastery: Critical Block, Riposte, Vanguard
- **Auto-Granted Spec Passives (~6)**: Mastery: Deep Wounds (Arms), Titan's Grip (Fury), Mastery: Unshackled Fury (Fury), Seasoned Soldier (Arms), etc.
- **Class Talent Passives (~20)**: War Machine, Leeching Strikes, Frothing Berserker, Bitter Immunity, Reinforced Plates, etc.
- **Arms Spec Passives (~25)**: Martial Prowess, Improved Overpower, Improved Execute, Tactician, Anger Management, Dreadnaught, Critical Thinking, etc.
- **Fury Spec Passives (~25)**: Frenzied Enrage, Powerful Enrage, Fresh Meat, Warpaint, Single-Minded Fury, Bloodcraze, Swift Strikes, Titanic Rage, etc.
- **Protection Spec Passives (~20)**: Brace For Impact, Armor Specialization, Devastator, Best Served Cold, Tough as Nails, Defender's Aegis, Shield Specialization, etc.
- **Specialization Passives (~20)**: All Mountain Thane/Colossus/Slayer talents that modify existing abilities

**Total Passive Abilities**: ~130+ passive entries

**Analysis Document**: `EXCEL_ABILITY_COUNT_SUMMARY.md` (complete inventory with row breakdowns)

*Content will be added in Phase 3 with feedback loops active*

---

## [10] Action Resources

**Status**: 🚧 Under Construction  
**Last Updated**: TBD

*Content will be added in Phase 3 with feedback loops active*

---

## [11] File Transformation Status

**Status**: 🚧 Under Construction  
**Last Updated**: TBD

*Content will be added in Phase 3 with feedback loops active*

---

## [12] Folder Structure Inventory

**Status**: 🚧 Under Construction  
**Last Updated**: TBD

*Content will be added in Phase 3 with feedback loops active*
