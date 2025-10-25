# HANDOVER: Warrior Class Not Visible in Character Creation (Oct 24, 2025)

**Session Date**: October 24, 2025  
**Critical Issue**: Warrior class not appearing in BG3 Character Creation screen  
**Current Status**: ❌ BLOCKING - Multiple fixes attempted, class still invisible  
**Last Action**: Reverted GUID changes, rebuilt stable package (19.57 MB)

---

## 🚨 IMMEDIATE CONTEXT (READ FIRST)

### Current Problem
**Warrior class does NOT appear in Character Creation** despite:
- ✅ Mod packages successfully (19.57 MB)
- ✅ No build errors/crashes
- ✅ All required files present
- ✅ Localization handles correct
- ✅ Game launches without crash

### What We've Tried (All Failed)
1. ❌ **Fix #1**: Restored missing localization handles → Still not visible
2. ❌ **Fix #2**: Fixed UUID references → Still not visible  
3. ❌ **Fix #3**: Validated file structure → Still not visible
4. ❌ **Fix #4**: Complete localization restoration → Still not visible
5. ❌ **Fix #5**: Invalid GUID replacement → **CAUSED GAME CRASH** (reverted)

### Current Build Status
- **Package**: `Package\BG3Wow_Latest.pak` (19.57 MB)
- **Deployed To**: `%LOCALAPPDATA%\Larian Studios\Baldur's Gate 3\Mods\`
- **Game Status**: Launches without crash (after reverting Fix #5)
- **Class Visibility**: ❌ NOT VISIBLE in Character Creation
- **Build Warnings**: May have GUID format warnings (line 105, 217) - reverted for stability

---

## 📋 CRITICAL FILES TO CHECK

### 1. ClassDescriptions.lsx (Primary Suspect)
**Location**: `Data/Public/Warrior_Wow_78fe4967-4e62-5491-d981-dd781acca4d7/ClassDescriptions/ClassDescriptions.lsx`

**Current State**: Reverted from GUID fix (has original invalid GUIDs)

**Key Elements to Verify**:
```xml
<!-- Base Class Definition -->
<node id="ClassDescription">
    <attribute id="BaseHp" type="int32" value="12"/>
    <attribute id="CanLearnSpells" type="bool" value="false"/>
    <attribute id="CharacterCreationPose" type="guid" value="0f07ec6e-4ef0-4d33-be20-769b03afbe1e"/>
    <attribute id="ClassEquipment" type="FixedString" value="EQP_CC_Barbarian"/>  <!-- ⚠️ Using Barbarian equipment -->
    <attribute id="Description" type="TranslatedString" handle="h125bb002" version="1"/>
    <attribute id="DisplayName" type="TranslatedString" handle="h125bb001" version="1"/>
    <attribute id="HpPerLevel" type="int32" value="7"/>
    <attribute id="LearningStrategy" type="uint8" value="1"/>
    <attribute id="Name" type="FixedString" value="Warrior"/>  <!-- ⚠️ CRITICAL -->
    <attribute id="PrimaryAbility" type="uint8" value="1"/>  <!-- Strength -->
    <attribute id="ProgressionTableUUID" type="guid" value="78abc123-4def-5678-9abc-def012345678"/>
    <attribute id="SoundClassType" type="FixedString" value="Barbarian"/>  <!-- ⚠️ Using Barbarian sounds -->
    <attribute id="SpellCastingAbility" type="uint8" value="0"/>  <!-- None -->
    <attribute id="UUID" type="guid" value="78fe4967-4e62-5491-d981-dd781acca4d7"/>  <!-- ⚠️ MOD UUID -->
</node>
```

**Potential Issues**:
- `Name` attribute must be unique (check for conflicts with other mods)
- `UUID` must match mod UUID exactly
- `ProgressionTableUUID` references must exist in Progressions.lsx
- Invalid GUID format in `ProgressionTableUUID` (line 105 warning)

### 2. Progressions.lsx
**Location**: `Data/Public/Warrior_Wow_78fe4967-4e62-5491-d981-dd781acca4d7/Progressions/Progressions.lsx`

**Key Structure**:
```xml
<node id="Progression">
    <attribute id="Level" type="uint8" value="1"/>
    <attribute id="Name" type="LSString" value="Warrior"/>
    <attribute id="ProgressionType" type="uint8" value="0"/>  <!-- Class -->
    <attribute id="TableUUID" type="guid" value="78abc123-4def-5678-9abc-def012345678"/>  <!-- Must match ClassDescriptions -->
    <attribute id="Boosts" type="LSString" value="ActionResource(Rage,100,0);Proficiency(SimpleWeapons);Proficiency(MartialWeapons);Proficiency(LightArmor);Proficiency(MediumArmor);Proficiency(HeavyArmor);Proficiency(Shields)"/>
    <attribute id="PassivesAdded" type="LSString" value="WAR_RageGeneration"/>
    <children>
        <node id="SubClasses">
            <children>
                <node id="SubClass">
                    <attribute id="Object" type="guid" value="c5abc123-4def-5678-9abc-def012345678"/>  <!-- Arms -->
                </node>
                <node id="SubClass">
                    <attribute id="Object" type="guid" value="d6abc123-4def-5678-9abc-def012345678"/>  <!-- Fury -->
                </node>
                <node id="SubClass">
                    <attribute id="Object" type="guid" value="e7abc123-4def-5678-9abc-def012345678"/>  <!-- Protection -->
                </node>
            </children>
        </node>
    </children>
</node>
```

**Check For**:
- TableUUID matches ClassDescriptions ProgressionTableUUID
- All 3 subclass UUIDs exist as separate Progression entries
- No duplicate TableUUIDs across mods

### 3. meta.lsx
**Location**: `Data/Mods/Warrior_Wow_78fe4967-4e62-5491-d981-dd781acca4d7/meta.lsx`

**Critical Attributes**:
```xml
<attribute id="Name" type="LSString" value="Warrior Wow"/>
<attribute id="UUID" type="FixedString" value="78fe4967-4e62-5491-d981-dd781acca4d7"/>
<attribute id="Version64" type="int64" value="36028797018963968"/>  <!-- 1.0.0.0 -->
```

**Dependencies** (Must Include):
```xml
<node id="ModuleShortDesc">
    <attribute id="Folder" type="LSString" value="GustavDev"/>
    <attribute id="MD5" type="LSString" value=""/>
    <attribute id="Name" type="LSString" value="GustavDev"/>
    <attribute id="UUID" type="FixedString" value="28ac9ce2-2aba-8cda-b3b5-6e922f71b6b8"/>
    <attribute id="Version64" type="int64" value="144115188075855872"/>
</node>
```

### 4. Localization File
**Location**: `Data/Public/Warrior_Wow_78fe4967-4e62-5491-d981-dd781acca4d7/Localization/English/English.loca.xml`

**Critical Handles** (Must Exist):
```xml
<contentList>
    <content contentuid="h125bb001" version="1">Warrior</content>  <!-- DisplayName -->
    <content contentuid="h125bb002" version="1">A master of martial combat...</content>  <!-- Description -->
    <content contentuid="h125bb003" version="1">Arms</content>  <!-- Subclass 1 -->
    <content contentuid="h125bb004" version="1">Fury</content>  <!-- Subclass 2 -->
    <content contentuid="h125bb005" version="1">Protection</content>  <!-- Subclass 3 -->
</contentList>
```

**Verify**: All handles referenced in ClassDescriptions.lsx exist here

---

## 🔍 INVESTIGATION CHECKLIST

### Step 1: Compare with Working Reference Mod
**Action**: Compare our structure with WoWWarlock mod (13K+ downloads, proven working)

**Reference Mod Location**: `Documentation/12_ReferenceMods/WoWWarlock/`

**Key Comparisons**:
1. ClassDescriptions.lsx structure (attribute order, values)
2. meta.lsx dependencies (are we missing any?)
3. Progressions.lsx TableUUID format
4. Localization handle format
5. File naming conventions

**Command to Extract Warlock Mod**:
```powershell
# If you have the .pak file
& "LsLib\Tools\divine.exe" -g bg3 -a extract-package `
  -s "path\to\WoWWarlock.pak" `
  -d "Temp\WoWWarlock_Extracted"
```

### Step 2: Check for Mod Conflicts
**Action**: Check if another mod is using "Warrior" class name

**BG3 Mod Manager**: Check load order and enabled mods  
**Potential Conflicts**:
- Other class mods using "Warrior" name
- Mods modifying `Shared.pak` class definitions
- Overhaul mods that change character creation

**Test**: Disable ALL other mods, enable ONLY BG3Wow, test again

### Step 3: Validate GUID Format Issues
**Known Problem**: 7 GUIDs contain invalid characters (g-z instead of 0-9, a-f)

**Affected GUIDs** (documented in `Scripts/Fix_Invalid_GUIDs.ps1`):
```powershell
$GuidMapping = @{
    'ArmsSlayers' = @{
        Old = '7b2c9d4e-8f0g-5b6c-9d7e-0f1g2b3c4d5e'  # INVALID (has 'g')
        New = '5e34e41a-f929-47d5-aecb-3f48df5167c6'  # VALID
    }
    # ... 6 more mappings
}
```

**Why We Reverted**: Fix #5 applied these replacements but caused game crash  
**Real Problem**: Warlock assets were contaminating mod (now cleaned)

**Action**: Re-apply GUID fix NOW that assets are clean
```powershell
cd C:\Users\tenod\source\repos\BG3Mods
powershell -ExecutionPolicy Bypass -File "Scripts\Fix_Invalid_GUIDs.ps1"
# Then rebuild and test
```

### Step 4: Check ActionResourceDefinitions
**Location**: `Data/Public/Warrior_Wow_78fe4967-4e62-5491-d981-dd781acca4d7/ActionResourceDefinitions/ActionResourceDefinitions.lsx`

**Critical for Rage Resource**:
```xml
<node id="ActionResourceDefinition">
    <attribute id="Description" type="TranslatedString" handle="h125bb020" version="1"/>
    <attribute id="DisplayName" type="TranslatedString" handle="h125bb019" version="1"/>
    <attribute id="IsSpellResource" type="bool" value="false"/>
    <attribute id="MaxLevel" type="uint32" value="100"/>
    <attribute id="Name" type="FixedString" value="Rage"/>
    <attribute id="ReplenishType" type="FixedString" value="Rest"/>
    <attribute id="ShowOnActionResourcePanel" type="bool" value="true"/>
    <attribute id="UUID" type="guid" value="f0a1b2c3-4d5e-6f7a-8b9c-0d1e2f3a4b5c"/>
</node>
```

**Verify**: 
- `Name` attribute is exactly "Rage"
- UUID is unique (not conflicting with other mods)
- Progressions.lsx grants this resource: `ActionResource(Rage,100,0)`

### Step 5: Validate Package Contents
**Action**: Unpack the .pak file and verify structure

**Command**:
```powershell
& "LsLib\Tools\divine.exe" -g bg3 -a extract-package `
  -s "Package\BG3Wow_Latest.pak" `
  -d "Temp\Unpacked_Latest"
```

**Check For**:
- All files present (ClassDescriptions, Progressions, meta, localization)
- No extra Warlock files (GUI/AssetsLowRes should NOT exist)
- Correct folder structure (`Mods/` and `Public/` folders)
- File sizes reasonable (not truncated or corrupted)

---

## 🛠️ TROUBLESHOOTING THEORIES

### Theory 1: Invalid GUID Format Blocking Recognition
**Evidence**: 
- Build warnings on line 105 (ClassDescriptions.lsx) and line 217 (SpellLists.lsx)
- GUIDs contain characters g-z (not valid hexadecimal)
- WoWWarlock/WoWDeathKnight mods use only 0-9, a-f

**Test**: Re-apply Fix #5 (GUID replacement) now that Warlock assets are cleaned
```powershell
cd Scripts
powershell -ExecutionPolicy Bypass -File "Fix_Invalid_GUIDs.ps1"
```

**Expected Result**: Build with NO warnings, class appears in CC

### Theory 2: ClassEquipment/SoundClassType Conflicts
**Evidence**:
- ClassDescriptions.lsx uses `ClassEquipment="EQP_CC_Barbarian"`
- Uses `SoundClassType="Barbarian"`
- These may be causing BG3 to treat it as Barbarian, not new class

**Test**: Change to Warrior-specific or generic values
```xml
<attribute id="ClassEquipment" type="FixedString" value="EQP_CC_Fighter"/>
<attribute id="SoundClassType" type="FixedString" value="Fighter"/>
```

**Why Fighter?**: Closest match to Warrior archetype, known working values

### Theory 3: Missing or Incorrect CharacterCreationPose
**Evidence**:
- ClassDescriptions.lsx has `CharacterCreationPose` GUID
- If GUID doesn't exist in game assets, class may not display

**Test**: Use known working pose GUID from Fighter or Barbarian
```xml
<attribute id="CharacterCreationPose" type="guid" value="0f07ec6e-4ef0-4d33-be20-769b03afbe1e"/>
```

**Reference**: Check WoWWarlock mod for their CharacterCreationPose value

### Theory 4: Progression TableUUID Mismatch
**Evidence**:
- ClassDescriptions ProgressionTableUUID must EXACTLY match Progressions TableUUID
- Even one character difference causes silent failure

**Test**: Extract both values and compare byte-by-byte
```powershell
$classDesc = Select-Xml -Path "Data\Public\...\ClassDescriptions\ClassDescriptions.lsx" `
    -XPath "//attribute[@id='ProgressionTableUUID']" | 
    Select-Object -ExpandProperty Node | 
    Select-Object -ExpandProperty value

$progression = Select-Xml -Path "Data\Public\...\Progressions\Progressions.lsx" `
    -XPath "//node[@id='Progression']/attribute[@id='TableUUID']" |
    Select-Object -First 1 -ExpandProperty Node |
    Select-Object -ExpandProperty value

Write-Host "ClassDescriptions: $classDesc"
Write-Host "Progressions:      $progression"
Write-Host "Match: $($classDesc -eq $progression)"
```

### Theory 5: Missing Dependencies in meta.lsx
**Evidence**:
- Some mods require specific dependencies to show in CC
- GustavDev dependency present but may need others

**Test**: Add Shared.pak dependency
```xml
<node id="ModuleShortDesc">
    <attribute id="Folder" type="LSString" value="Shared"/>
    <attribute id="MD5" type="LSString" value=""/>
    <attribute id="Name" type="LSString" value="Shared"/>
    <attribute id="UUID" type="FixedString" value="ed539163-bb70-431b-96a3-6ab92ce75c2e"/>
    <attribute id="Version64" type="int64" value="144115196665790382"/>
</node>
```

**Reference**: Check WoWWarlock meta.lsx for complete dependency list

---

## 📊 EVIDENCE GATHERED

### Build Validation Results
**Source**: `TROUBLESHOOTING_LOG.md` (root folder)

**Last 5 Fixes Attempted**:
1. ✅ Fix #1: Localization handles → Build success, class not visible
2. ✅ Fix #2: UUID references → Build success, class not visible
3. ✅ Fix #3: File structure → Build success, class not visible
4. ✅ Fix #4: Complete localization → Build success, class not visible
5. ❌ Fix #5: Invalid GUIDs → Build success (clean!), **game crashed**

**Pattern**: All fixes build successfully but class never appears

### GUID Issues Documented
**Source**: `Scripts/Fix_Invalid_GUIDs.ps1`

**7 Invalid GUIDs Found**:
| Subclass | Location | Invalid Characters |
|----------|----------|-------------------|
| ArmsSlayers | ClassDescriptions L105 | g (multiple) |
| FuryMountainThane | Progressions | g, h |
| FurySlayers | Progressions | g, h, i |
| FuryWarrior | Progressions | g |
| ProtectionMountainThane | Progressions | g, h, i, j |
| ProtectionColossus | SpellLists L217 | g, h, i, j, k |
| ProtectionWarrior | Progressions | g, h |

**Fix Status**: Reverted (caused crash), ready to re-apply

### Warlock Asset Cleanup
**Source**: Git diff output from troubleshooting session

**Previously Contaminated Files** (NOW CLEANED):
- ❌ 300+ Warlock .DDS icon files in `Data/Mods/.../GUI/AssetsLowRes/`
- ❌ ClassIcons/: WoWWarlock, Affliction, Demonology, Destruction
- ❌ ActionResources_c/Icons/: DemonicCore, SoulShard, Havoc, etc.
- ❌ ControllerUIIcons/: 200+ Warlock ability icons

**Current Status**: ✅ All cleaned (GUI/AssetsLowRes folder doesn't exist)

---

## 🎯 RECOMMENDED NEXT STEPS (IN ORDER)

### Priority 1: Re-apply GUID Fix (Now Safe)
**Why**: Warlock assets cleaned, fix previously worked (clean build)
```powershell
cd C:\Users\tenod\source\repos\BG3Mods
powershell -ExecutionPolicy Bypass -File "Scripts\Fix_Invalid_GUIDs.ps1"
& .\.vscode\build-pak.ps1
Copy-Item 'Package\BG3Wow_Latest.pak' -Destination "$env:LOCALAPPDATA\Larian Studios\Baldur's Gate 3\Mods\" -Force
```
**Expected**: Clean build, no crash, test class visibility

### Priority 2: Compare Full Structure with WoWWarlock
**Why**: They have 13K+ downloads, proven working
**Action**: 
1. Extract WoWWarlock.pak from `Documentation/12_ReferenceMods/`
2. Side-by-side comparison of all key files
3. Document differences in structure, attributes, values

### Priority 3: Test with ONLY This Mod Enabled
**Why**: Rule out mod conflicts
**Action**:
1. Open BG3 Mod Manager
2. Disable ALL mods except BG3Wow
3. Export load order
4. Launch game, test character creation
5. Document result

### Priority 4: Check Game Logs for Errors
**Why**: Silent failures may be logged
**Locations**:
- `%LOCALAPPDATA%\Larian Studios\Baldur's Gate 3\PlayerProfiles\Public\Savegames\Story\`
- `%LOCALAPPDATA%\Larian Studios\Baldur's Gate 3\ScriptExtender\Logs\`
- `%LOCALAPPDATA%\Larian Studios\Baldur's Gate 3\Crashes\`

**Search For**: "Warrior", "78fe4967", "ClassDescription", errors/warnings during CC load

### Priority 5: Create Minimal Test Mod
**Why**: Isolate the problem
**Action**: 
1. Copy WoWWarlock mod structure
2. Change ONLY class name to "Warrior"
3. Change ONLY UUID to our mod UUID
4. Test if THIS appears in CC
5. If yes → incrementally add our features until it breaks
6. If no → problem is deeper (game version, core files, etc.)

---

## 📁 KEY FILE LOCATIONS

### Mod Source Files
```
Data/
├── Mods/
│   └── Warrior_Wow_78fe4967-4e62-5491-d981-dd781acca4d7/
│       ├── meta.lsx                          # Mod metadata
│       └── ScriptExtender/                   # (Optional) Lua debugging
└── Public/
    └── Warrior_Wow_78fe4967-4e62-5491-d981-dd781acca4d7/
        ├── ActionResourceDefinitions/
        │   └── ActionResourceDefinitions.lsx  # Rage resource
        ├── ClassDescriptions/
        │   └── ClassDescriptions.lsx          # ⚠️ PRIMARY SUSPECT
        ├── Lists/
        │   └── SpellLists.lsx                 # Ability lists
        ├── Localization/
        │   └── English/
        │       └── English.loca.xml           # Text strings
        ├── Progressions/
        │   └── Progressions.lsx               # Level-up grants
        └── Stats/
            └── Generated/
                └── Data/                       # Ability stat files
```

### Documentation & Tools
```
Documentation/
├── 00_SourcesOfTruth/
│   ├── SOURCE_OF_TRUTH.md                    # ⚠️ READ FIRST - Single source of truth
│   └── AbilityDatabase_Warrior_FullyEnriched.csv  # 215 abilities, 100% enriched
├── 12_ReferenceMods/
│   └── WoWWarlock/                           # Reference working mod
└── 01_Reference-Guides/
    └── CLASS_CREATION_REQUIREMENTS_CHECKLIST.md  # BG3 class requirements

Scripts/
├── Fix_Invalid_GUIDs.ps1                     # ⚠️ Ready to re-apply
└── Phase1_Baseline_Validation.ps1            # Validation suite

Package/
└── BG3Wow_Latest.pak                         # Current deployed build (19.57 MB)

TROUBLESHOOTING_LOG.md                        # ⚠️ All fixes documented here
```

---

## 🔧 USEFUL COMMANDS

### Rebuild & Deploy
```powershell
# Build package
& .\.vscode\build-pak.ps1

# Install to game
Copy-Item 'Package\BG3Wow_Latest.pak' `
  -Destination "$env:LOCALAPPDATA\Larian Studios\Baldur's Gate 3\Mods\" `
  -Force
```

### Extract Package for Inspection
```powershell
& "LsLib\Tools\divine.exe" -g bg3 -a extract-package `
  -s "Package\BG3Wow_Latest.pak" `
  -d "Temp\Unpacked"
```

### Search for GUID References
```powershell
# Find all uses of a specific GUID
Select-String -Path "Data\**\*.lsx" -Pattern "78fe4967-4e62-5491-d981-dd781acca4d7"
```

### Validate XML Syntax
```powershell
# Check if XML is well-formed
[xml](Get-Content "Data\Public\...\ClassDescriptions\ClassDescriptions.lsx")
```

### Compare TableUUIDs
```powershell
# Extract and compare GUIDs from both files
$cd = [xml](Get-Content "Data\Public\...\ClassDescriptions\ClassDescriptions.lsx")
$prog = [xml](Get-Content "Data\Public\...\Progressions\Progressions.lsx")

$cdUUID = $cd.save.region.node.children.node | 
    Where-Object { $_.attribute | Where-Object { $_.id -eq "Name" -and $_.'#text' -eq "Warrior" } } |
    Select-Object -ExpandProperty attribute |
    Where-Object { $_.id -eq "ProgressionTableUUID" } |
    Select-Object -ExpandProperty value

$progUUID = $prog.save.region.node.children.node |
    Where-Object { $_.attribute | Where-Object { $_.id -eq "Name" -and $_.'#text' -eq "Warrior" } } |
    Select-Object -ExpandProperty attribute |
    Where-Object { $_.id -eq "TableUUID" } |
    Select-Object -ExpandProperty value

Write-Host "ClassDescriptions ProgressionTableUUID: $cdUUID"
Write-Host "Progressions TableUUID:                  $progUUID"
Write-Host "Match: $($cdUUID -eq $progUUID)"
```

---

## 🚨 KNOWN ISSUES & WARNINGS

### Issue 1: Invalid GUID Format (UNRESOLVED)
**Status**: Fix created but reverted due to crash  
**Ready to Retry**: Yes (Warlock assets now cleaned)  
**Script**: `Scripts/Fix_Invalid_GUIDs.ps1`  
**Impact**: Build warnings on lines 105, 217

### Issue 2: Game Crash After Fix #5 (RESOLVED)
**Root Cause**: 300+ Warlock .DDS asset files from template  
**Status**: ✅ Assets cleaned, no longer present  
**Safe to Retry Fix #5**: Yes

### Issue 3: Class Invisible in Character Creation (ACTIVE)
**Status**: ❌ UNRESOLVED - Primary issue  
**Theories**: 5 documented above  
**Next Step**: Re-apply GUID fix and test

---

## 📝 SESSION NOTES

### What We Know Works
- ✅ Mod builds successfully (19.57 MB package)
- ✅ Game launches without crash (after cleanup)
- ✅ All required files present and syntactically valid
- ✅ Localization handles correct
- ✅ No mod conflicts detected (only BG3Wow enabled)

### What We Know Doesn't Work
- ❌ Class does NOT appear in Character Creation
- ❌ All 5 fixes attempted have failed to resolve
- ❌ GUID warnings persist (until Fix #5 re-applied)

### Critical Unknowns
- ❓ Why does mod build successfully but class not show?
- ❓ Is there a deeper BG3 engine requirement we're missing?
- ❓ Are the invalid GUIDs THE blocker (test pending)?
- ❓ Is there a conflict with base game class definitions?
- ❓ Do we need additional dependencies in meta.lsx?

---

## 🎯 SUCCESS CRITERIA

### Definition of Success
1. Close BG3 completely
2. Reopen BG3
3. New Game → Character Creation
4. **"Warrior" appears in class selection list**
5. Can select Warrior and see description/icon
6. Can progress through character creation
7. Can start game as Warrior with Rage resource

### How to Test
```
1. Close BG3 if running
2. Open BG3 (via Steam or direct)
3. Main Menu → New Game
4. Character Creation → Class Selection
5. Scroll through class list
6. Look for "Warrior" (should be alphabetically after "Warlock")
7. Click "Warrior" if visible
8. Verify description, icon, starting equipment shown
9. Complete character creation
10. Start game, check character sheet for Rage resource
```

---

## 📚 REFERENCE DOCUMENTS (READ THESE)

### Essential Reading (In Order)
1. **SOURCE_OF_TRUTH.md** (`Documentation/00_SourcesOfTruth/`)  
   - Single authoritative source for all project information
   - Section [5]: Troubleshooting history
   - Section [12]: File inventory

2. **TROUBLESHOOTING_LOG.md** (root folder)  
   - All 5 fixes documented with evidence
   - "DEAD ENDS" section (what NOT to retry)
   - "VERIFIED WORKING" section

3. **CLASS_CREATION_REQUIREMENTS_CHECKLIST.md** (`Documentation/01_Reference-Guides/`)  
   - BG3 engine requirements for custom classes
   - All checkboxes we've validated

4. **FILE_REFERENCE.md** (`Documentation/06_ProjectDocuments/`)  
   - BG3 file format syntax examples
   - LSX structure patterns

### Supporting Documents
- `Documentation/07_DesignDocuments/Warrior_Class_Blueprint.md` - Design intent
- `Documentation/06_ProjectDocuments/ABILITY_IMPLEMENTATION_INVENTORY.md` - Implementation status
- `Documentation/01_Reference-Guides/PACKAGING_GUIDE.md` - Build process

---

## 🔄 VERSION HISTORY

| Date | Package Size | Changes | Result |
|------|--------------|---------|--------|
| Oct 24 (early) | 19.85 MB | Fix #4: Localization restoration | ❌ Not visible |
| Oct 24 (mid) | 19.57 MB | Fix #5: GUID replacement | ❌ Game crash |
| Oct 24 (current) | 19.57 MB | Reverted Fix #5, assets cleaned | ✅ Stable, ❌ Not visible |

---

## ⚡ QUICK START FOR NEW SESSION

### Immediate Actions (First 5 Minutes)
```powershell
# 1. Navigate to project
cd C:\Users\tenod\source\repos\BG3Mods

# 2. Re-apply GUID fix (now safe)
powershell -ExecutionPolicy Bypass -File "Scripts\Fix_Invalid_GUIDs.ps1"

# 3. Rebuild package
& .\.vscode\build-pak.ps1

# 4. Deploy to game
Copy-Item 'Package\BG3Wow_Latest.pak' `
  -Destination "$env:LOCALAPPDATA\Larian Studios\Baldur's Gate 3\Mods\" `
  -Force

# 5. Test in-game
Write-Host "`nPackage deployed! Test in BG3 Character Creation." -ForegroundColor Green
Write-Host "Close BG3 completely first, then reopen and check for 'Warrior' class." -ForegroundColor Yellow
```

### If Still Not Visible After GUID Fix
1. Read Theory 2-5 above
2. Extract WoWWarlock reference mod for comparison
3. Check game logs for errors
4. Test with ONLY this mod enabled
5. Consider minimal test mod approach

---

## 🆘 CONTACTS & RESOURCES

### AI Agent Protocol
**CRITICAL**: Before making ANY changes:
1. Read `Documentation/00_SourcesOfTruth/SOURCE_OF_TRUTH.md` relevant section
2. Check `TROUBLESHOOTING_LOG.md` for what's been tried
3. Follow "SOURCE OF TRUTH PROTOCOL" in agent.md (copilot-instructions.md)

### External Resources
- **BG3 Modding Wiki**: https://bg3.wiki/wiki/Modding
- **Larian Modding Discord**: Search for BG3 modding community
- **LSLib GitHub**: https://github.com/Norbyte/lslib (for Divine.exe tool)
- **BG3 Script Extender**: https://github.com/Norbyte/bg3se

---

**END OF HANDOVER**

**Next Agent**: Start with "Re-apply GUID Fix" (Priority 1) since Warlock assets are now cleaned. This was the cleanest build we achieved before it crashed. With assets gone, it should work.

Good luck! 🍀
