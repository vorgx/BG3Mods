# Complete Crash Analysis - BG3Wow Mod

## Test Results Summary

### Build History
1. **43.14 KB** (no SE, no localization) → ✅ LOADED but class didn't appear
2. **53.94 KB** (with English.loca.xml) → ❌ CRASHED
3. **55.3 KB** (with lowercase english.xml) → ❌ CRASHED
4. **55.4 KB** (with corrected XML format) → ❌ CRASHED
5. **44.2 KB** (no localization, with Tags added) → ⏳ TESTING

## Key Findings from Working Mod Comparisons

### 1. WoWWarlock (WORKING - 3 subclasses)
**Location**: `Tests\02_ExampleMods\ExampleMod_WoWWarlock`

**Localization Format**:
```xml
<?xml version="1.0"?>
<contentList xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
```
- NO `encoding="utf-8"` attribute
- Has xmlns namespace declarations
- File: `Localization/English/english.xml` (lowercase)

**ClassDescriptions Structure**:
- All 4 classes (base + 3 subclasses) have Tags with GUID `5804f55a-93f7-4281-9512-8d548a9e2a22`
- All have SpellList GUID (real one, not null)
- All subclasses have full attributes (BaseHp, CanLearnSpells, etc.)

**meta.lsx Dependencies**:
- Has many dependencies (DiceSets, UI mods, Gustav, GustavDev, VladsCodex)
- Has Scripts node with UUIDs
- Version: build="500"

### 2. Witcher Class (WORKING - NO subclasses)
**Location**: `Tests\02_ExampleMods\Witcher Class`

**Localization Format**:
```xml
<?xml version="1.0"?>
<contentList xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
```
- Same format as WoWWarlock
- File: `Localization/English/english.xml` (lowercase)
- Location: `Mods/Witcher_.../Localization/English/`

**ClassDescriptions Structure**:
- Base class has Tags with different GUID: `1ae7017c-4884-4a43-bc4a-742fa0d201c0`
- Subclasses have NO Tags nodes (but Witcher has 5 subclasses)
- Base class has NO SpellList attribute
- Missing: CanLearnSpells, MustPrepareSpells, ShortName

### 3. WoWDemonHunter (Source Files)
**Location**: `Tests\02_ExampleMods\WoWDemonHunterClass`

**Note**: This appears to be an extracted/source folder structure, not a packaged mod

**Localization Location**: 
- At ROOT level: `WoWDemonHunterClass/Localization/English/`
- NOT inside `Mods/` folder
- Has BOTH `WoWDemonHunterClass.xml` AND `WoWDemonHunterClass.loca.xml`

## Our Mod Structure

### Current Files (44.2 KB build)
```
Data/
  Mods/
    BG3Wow_78fe4967-4e62-5491-d981-dd781acca4d7/
      meta.lsx  (only GustavX dependency, empty Scripts)
      [NO Localization - removed for testing]
  Public/
    BG3Wow_78fe4967-4e62-5491-d981-dd781acca4d7/
      ClassDescriptions/ClassDescriptions.lsx  (4 classes, all with Tags)
      Progressions/Progressions.lsx  (1301 lines, levels 1-20)
      ActionResourceDefinitions/ActionResourceDefinitions.lsx  (Rage)
      Stats/Generated/Data/*.txt  (all abilities)
```

### ClassDescriptions Attributes
**Base Class**:
- BaseHp: 10 ✅
- CanLearnSpells: false ✅
- CharacterCreationPose: 0f07ec6e-4ef0-434e-9a51-1353260ccff8 ✅
- ClassEquipment: EQP_CC_Barbarian ✅
- ClassHotbarColumns: 5 ✅
- CommonHotbarColumns: 9 ✅
- ItemsHotbarColumns: 2 ✅
- DisplayName: handle ✅
- Description: handle ✅
- HasGod: false ✅
- HpPerLevel: 10 ✅
- LearningStrategy: 1 ✅
- MustPrepareSpells: false ✅
- Name: WoWWarrior ✅
- PrimaryAbility: 1 (Strength) ✅
- ProgressionTableUUID: matches Progressions ✅
- ShortName: handle ✅
- SoundClassType: Barbarian ✅
- SpellCastingAbility: 0 ✅
- SpellList: 00000000-0000-0000-0000-000000000000 (null GUID) ✅
- UUID: 78fe4967-4e62-5491-d981-dd781acca4d7 ✅
- Tags: 5804f55a-93f7-4281-9512-8d548a9e2a22 ✅

**Subclasses** (3 total):
- All have CharacterCreationPose ✅
- All have ClassEquipment ✅
- All have DisplayName, Description handles ✅
- All have LearningStrategy: 1 ✅
- All have MustPrepareSpells: false ✅
- All have ParentGuid pointing to base class ✅
- All have PrimaryAbility: 1 ✅
- All have ProgressionTableUUID (unique per subclass) ✅
- All have SoundClassType: Barbarian ✅
- All have SpellCastingAbility: 0 ✅
- All have SpellList: null GUID ✅
- All have SubclassTitle handle ✅
- All have UUID (unique) ✅
- All have Tags: 5804f55a-93f7-4281-9512-8d548a9e2a22 ✅

## Hypotheses for Crash with Localization

### Theory 1: Localization File Content Issue
- **Status**: Still investigating
- **Evidence**: Same XML format as WoWWarlock, still crashes
- **Possible cause**: Content of handles themselves (special characters, length, formatting)

### Theory 2: Localization + ClassDescriptions Interaction
- **Status**: Needs testing
- **Evidence**: Mod loads without localization, crashes with it
- **Possible cause**: Invalid handle references, mismatch between handles and contentuid values

### Theory 3: File Size/Complexity Threshold
- **Status**: Unlikely
- **Evidence**: WoWWarlock is much larger (21MB FileSize in meta.lsx)
- **Our mod**: ~55KB with localization

### Theory 4: Missing Dependencies in meta.lsx
- **Status**: Unlikely
- **Evidence**: WoWWarlock has many dependencies, but they're from user's mod list
- **Our mod**: Only GustavX (minimal, should work)

### Theory 5: Build Version Mismatch
- **Status**: Investigating
- **Our meta.lsx**: version major="4" minor="8" revision="0" build="500"
- **WoWWarlock**: version major="4" minor="8" revision="0" build="500"
- **Match**: ✅

## Next Steps

1. **Test 44.2 KB build** (no localization) - If loads, problem is localization content
2. **If still crashes**: Problem is in ClassDescriptions/Progressions structure
3. **If loads successfully**: 
   - Try minimal localization (only base class name)
   - Compare handle format character-by-character with WoWWarlock
   - Check for special characters or formatting issues in XML content

## Critical Questions

1. **Does base mod work without localization?**
   - YES → Localization file is the problem
   - NO → Core structure (ClassDescriptions/Progressions) is the problem

2. **If localization is the problem:**
   - Is it the XML format? (Already tested - doesn't seem to be)
   - Is it the handle format? (h[32chars] vs h[UUID format]?)
   - Is it specific content/characters in descriptions?
   - Is it the file size of the localization?

3. **If core structure is the problem:**
   - Are the ProgressionTableUUIDs properly linked?
   - Are the Tags GUIDs correct?
   - Is the null SpellList GUID causing issues?
   - Are there required attributes we're missing?

## Comparison: Handle Format

**Our handles**:
```
h5a8b9c0d1e2f3a4b5c6d7e8f9a0b1c2d
hd78e30ba1c9e4f9bb0c9aa1f8e9c7d2a
```

**WoWWarlock handles**:
```
h95e35621g226eg9e0dgda9bg4abc636f1d06
h45282db9gf46egaf5cg5494g4132cfcb4a47
```

**DIFFERENCE**: WoWWarlock uses 'g' as separator, we use continuous hex. This might be the GUID format issue!

## ACTION REQUIRED

Test the 44.2 KB build first to isolate the problem area.
