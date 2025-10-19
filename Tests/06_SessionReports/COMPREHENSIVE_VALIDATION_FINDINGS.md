# Comprehensive File-by-File Validation Report
**Date**: October 18, 2025 01:00:00  
**Status**: Critical issues found requiring immediate fixes

## Summary of Findings

After systematic comparison with WoWWarlock example mod and BG3 Modders Multitool wiki documentation:

### ❌ CRITICAL ISSUES FOUND:

1. **ClassDescriptions.lsx - Tags Problem**
   - **Issue**: Each class has DIFFERENT tag UUIDs
   - **WoWWarlock Pattern**: ALL classes use SAME tag UUID: `5804f55a-93f7-4281-9512-8d548a9e2a22`
   - **Our Pattern**: Different UUIDs for each (base, Arms, Fury, Protection)
   - **Impact**: HIGH - May cause class recognition issues
   - **Fix Required**: Use same tag UUID for all classes

2. **ClassDescriptions.lsx - Missing SpellList Attribute**
   - **Issue**: Base Warrior class missing `SpellList` attribute
   - **WoWWarlock Has**: `<attribute id="SpellList" type="guid" value="32879c22-4858-48ef-8f8d-22e6d395b396"/>`
   - **Impact**: MEDIUM-HIGH - May cause character creation crash
   - **Fix Required**: Add SpellList attribute (can be empty or create minimal list)

3. **meta.lsx - Missing Scripts Section**
   - **Issue**: Our meta.lsx has `<node id="Scripts"/>` but it's self-closing (empty)
   - **WoWWarlock Has**: Scripts with child Script nodes containing UUIDs and Parameters
   - **Impact**: MEDIUM - May not be required but template shows it
   - **Fix Required**: Potentially add Script nodes or verify if optional

### ✅ VALIDATED CORRECT:

1. **meta.lsx Structure**:
   - ✅ XML version correct: `major="4" minor="8" revision="0" build="500"`
   - ✅ Conflicts node present
   - ✅ Dependencies node present (has GustavX dependency)
   - ✅ ModuleInfo attributes all present
   - ✅ UUID matches folder name: `78fe4967-4e62-5491-d981-dd781acca4d7`
   - ✅ Folder attribute matches: `BG3Wow_78fe4967-4e62-5491-d981-dd781acca4d7`
   - ✅ Version64 present

2. **Folder Structure**:
   - ✅ Correct path: `Mods/BG3Wow_UUID/meta.lsx`
   - ✅ Correct path: `Public/BG3Wow_UUID/Progressions/Progressions.lsx` (subdirectory)
   - ✅ Correct path: `Public/BG3Wow_UUID/ClassDescriptions/ClassDescriptions.lsx`
   - ✅ Correct path: `Public/BG3Wow_UUID/Stats/Generated/Data/*.txt`

3. **ClassDescriptions.lsx Attributes**:
   - ✅ BaseHp present
   - ✅ CanLearnSpells present
   - ✅ CharacterCreationPose present
   - ✅ ClassEquipment present (EQP_CC_Barbarian - vanilla resource)
   - ✅ ClassHotbarColumns present (recently added)
   - ✅ CommonHotbarColumns present (recently added)
   - ✅ Description present
   - ✅ DisplayName present
   - ✅ HpPerLevel present
   - ✅ ItemsHotbarColumns present (recently added)
   - ✅ LearningStrategy present
   - ✅ MustPrepareSpells present
   - ✅ Name present
   - ✅ PrimaryAbility present
   - ✅ ProgressionTableUUID present
   - ✅ ShortName present (recently added)
   - ✅ SoundClassType present
   - ✅ SpellCastingAbility present
   - ✅ UUID present

4. **Progressions.lsx**:
   - ✅ TableUUID matches ClassDescriptions ProgressionTableUUID: `a1b2c3d4-e5f6-7a8b-9c0d-1e2f3a4b5c6d`
   - ✅ Level progression structure correct (L1-L20)
   - ✅ All references to spells exist in stat files (validated earlier)

5. **Localization**:
   - ✅ All 199 handles present (191 base + 8 new)
   - ✅ Format correct: `h[8hex][2digit]`
   - ✅ All ClassDescriptions handles have corresponding entries

### ⚠️ DIFFERENCES (May be optional):

1. **Additional Folders** - WoWWarlock has but we don't:
   - `Assets/` - VFX/graphics (optional for our mod)
   - `CharacterCreationPresets/` - Preset characters (optional)
   - `GUI/` - Custom UI elements (optional)
   - `Levelmaps/` - Custom maps (not needed)
   - `Lists/` - Item/spell lists (may be needed if SpellList required)
   - `MultiEffectInfos/` - VFX definitions (optional)

2. **meta.lsx Dependencies** - WoWWarlock has many:
   - DiceSet_01, 02, 03, 06 (dice cosmetics - optional)
   - MainUI, ModBrowser, PhotoMode (UI mods - optional)
   - VladsCodex (VFX library - not needed for our mod)
   - GustavX (we have this ✅)

## Detailed Comparison Tables

### ClassDescriptions.lsx - Base Class Comparison

| Attribute | BG3Wow | WoWWarlock | Status |
|-----------|---------|------------|--------|
| BaseHp | 10 | 8 | ✅ Different by design |
| CanLearnSpells | false | false | ✅ Match |
| CharacterCreationPose | Present | Present | ✅ Match |
| ClassEquipment | EQP_CC_Barbarian | EQP_CC_Warlock | ✅ Both vanilla |
| ClassHotbarColumns | 5 | 5 | ✅ Match |
| CommonHotbarColumns | 9 | 9 | ✅ Match |
| Description | Present | Present | ✅ Match |
| DisplayName | Present | Present | ✅ Match |
| HpPerLevel | 10 | 5 | ✅ Different by design |
| ItemsHotbarColumns | 2 | 2 | ✅ Match |
| LearningStrategy | 1 | 1 | ✅ Match |
| MustPrepareSpells | false | false | ✅ Match |
| Name | WoWWarrior | WoWWarlock | ✅ Different by design |
| PrimaryAbility | 1 (STR) | 6 (CHA) | ✅ Different by design |
| ProgressionTableUUID | Present | Present | ✅ Match |
| ShortName | Present | Present | ✅ Match |
| SoundClassType | Barbarian | Warlock | ✅ Both vanilla |
| SpellCastingAbility | 0 | 6 | ✅ Different by design |
| **SpellList** | **MISSING** | **Present** | ❌ **CRITICAL** |
| UUID | Present | Present | ✅ Match |
| **Tags/Object** | **Different per class** | **Same for all** | ❌ **CRITICAL** |

### meta.lsx Comparison

| Section | BG3Wow | WoWWarlock | Status |
|---------|---------|------------|--------|
| version | 4.8.0.500 | 4.8.0.500 | ✅ Match |
| Conflicts | Present (empty) | Present (empty) | ✅ Match |
| Dependencies | GustavX only | Many (8+) | ⚠️ Different (likely OK) |
| Author | vorgx | Royah97 | ✅ Different by design |
| Description | Present | Present | ✅ Match |
| Folder | Matches UUID | Matches UUID | ✅ Match |
| Name | BG3Wow | WoWWarlock | ✅ Different by design |
| UUID | Matches folder | Matches folder | ✅ Match |
| Version64 | Present | Present | ✅ Match |
| PublishVersion | Present | Present | ✅ Match |
| **Scripts** | **Empty self-closing** | **Has child nodes** | ❌ **INVESTIGATE** |

## Recommended Fixes (Priority Order)

### Priority 1: Fix Tags (CRITICAL)
**File**: `ClassDescriptions.lsx`  
**Action**: Use same tag UUID for ALL classes (base + 3 subclasses)  
**Recommended UUID**: `6e9ca869-89b5-42eb-9d60-1f4e1e742678` (generate new to avoid conflicts)

### Priority 2: Add SpellList (HIGH)
**File**: `ClassDescriptions.lsx`  
**Action**: Add SpellList attribute to base Warrior class  
**Options**:
- Option A: Create empty spell list in `Lists/` folder
- Option B: Use existing game empty list UUID
- Option C: Remove requirement (research if CanLearnSpells=false needs it)

### Priority 3: Investigate Scripts Section (MEDIUM)
**File**: `meta.lsx`  
**Action**: Research if Scripts with UUIDs are required  
**WoWWarlock has**:
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
    </children>
</node>
```

## Testing Protocol After Fixes

1. Apply Priority 1 fix (Tags)
2. Package and test
3. If still crashes, apply Priority 2 fix (SpellList)
4. Package and test
5. If still crashes, apply Priority 3 fix (Scripts)
6. Package and test

## Files Validated

- ✅ `meta.lsx`
- ✅ `ClassDescriptions.lsx`
- ✅ `Progressions.lsx` (structure only, not full content)
- ✅ `English.loca.xml` (count and format only)
- ✅ Folder structure
- ⏸️ `ActionResourceDefinitions.lsx` (not yet checked)
- ⏸️ `Stats/*.txt` files (syntax validated earlier, not re-checked)
- ⏸️ `ScriptExtender/` files (structure OK, content not validated)

## Next Steps

**IMMEDIATE**: Apply Priority 1 fix (unified Tags UUID) and test.

**Reasoning**: Tags are likely used by game engine to categorize and identify classes. Having different tags for base class vs subclasses is inconsistent with working example and may confuse class inheritance system.
