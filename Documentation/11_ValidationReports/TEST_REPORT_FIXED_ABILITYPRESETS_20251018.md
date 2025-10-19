# BG3Wow Mod - FIXED AbilityDistributionPresets Test Report

**Date**: October 18, 2025, 13:14  
**Build**: BG3Wow_FIXED_ABILITYPRESETS_20251018_131405.pak  
**Size**: 59.12 KB  
**Status**: 🎮 **READY FOR TESTING**

---

## 🔧 **What Was Fixed**

### **Problem Identified:**
- Game was crashing after adding AbilityDistributionPresets.lsx
- Initial hypothesis: Missing Lists/DefaultValues files
- **Actual cause**: XML formatting issues

### **Fixes Applied:**

1. **✅ Attribute Order Corrected**
   - **Before**: Charisma first, ClassUUID second, UUID in middle
   - **After**: ClassUUID first → abilities (alphabetical) → UUID last
   - **Source**: Matched DemonHunter working mod structure

2. **✅ Removed XML Comments**
   - **Before**: Extensive block comments `<!-- ====== -->`
   - **After**: Clean XML with no comment blocks
   - **Reason**: BG3 parser may not handle extensive comments

3. **✅ Version Number Updated**
   - **Before**: `build="10"`
   - **After**: `build="60"`
   - **Reason**: Matches working DemonHunter mod version

---

## 📚 **Official Guide Verification**

**Source**: https://wiki.bg3.community/Tutorials/Classes/Basic-Class-Creation

### **Key Discovery:**
✅ **AbilityDistributionPresets.lsx is INDEPENDENT** of Lists/DefaultValues files

**Evidence from Guide:**
- AbilityDistributionPresets created in "Create the most basic class possible" section
- Lists/DefaultValues created LATER in "Add class skills/proficiencies" section
- AbilityDistributionPresets only requires `ClassUUID` from ClassDescriptions.lsx
- No dependencies on other character creation files

### **File Implementation Order (from official guide):**

**Phase 1: Basic Class (INDEPENDENT)**
1. meta.lsx
2. ClassDescriptions.lsx
3. Progressions.lsx (basic, no Selectors)
4. AbilityDistributionPresets.lsx ✅ **Works independently**

**Phase 2: Advanced Selectors (DEPENDENT)**
5. Lists/AbilityLists.lsx (only if using SelectAbilityBonus)
6. Lists/SkillLists.lsx (only if using SelectSkills)
7. DefaultValues/Abilities.lsx (only if using SelectAbilityBonus)
8. DefaultValues/Skills.lsx (only if using SelectSkills)

---

## 📦 **Current Build Status**

**Phase 1 Files** (✅ All Present - 6/9 total files):
- ✅ meta.lsx (Type="Add-on")
- ✅ ClassDescriptions.lsx (4 classes: base + 3 subclasses)
- ✅ Progressions.lsx (level 1-20 progressions)
- ✅ ProgressionDescriptions.lsx (matching handles)
- ✅ ActionResourceDefinitions.lsx (Rage resource)
- ✅ AbilityDistributionPresets.lsx (FIXED - 4 presets)

**Phase 2 Files** (❌ Not Yet Created - Optional):
- ❌ Lists/AbilityLists.lsx (only if Progressions uses SelectAbilityBonus)
- ❌ Lists/SkillLists.lsx (only if Progressions uses SelectSkills)
- ❌ DefaultValues/Abilities.lsx (only if using selectors)
- ❌ DefaultValues/Skills.lsx (only if using selectors)

---

## 🧪 **Testing Instructions**

### **Installation Steps:**

1. **Mod Already Copied** ✅
   - Location: `%LOCALAPPDATA%\Larian Studios\Baldur's Gate 3\Mods\`
   - File: `BG3Wow_FIXED_ABILITYPRESETS_20251018_131405.pak`

2. **BG3 Mod Manager Setup:**
   - Open BG3 Mod Manager
   - Click "Refresh" to see new mod version
   - Drag mod to active list (enable it)
   - Export load order (Ctrl+S or "Export Order to Game" button)

3. **Launch Game:**
   - Launch BG3 via Mod Manager (don't use Steam directly)
   - Select "New Game" or test character creation

### **Expected Results:**

**✅ If XML Formatting Was the Issue:**
- Warrior class visible in character creation screen
- No crash when selecting Warrior class
- Default ability scores display correctly:
  - Base Warrior: STR 15, CON 14, DEX 13, INT 8, WIS 12, CHA 10
  - Arms: STR 15, CON 14, DEX 13, INT 8, WIS 12, CHA 10
  - Fury: STR 15, CON 14, DEX 14, INT 8, WIS 12, CHA 10
  - Protection: STR 15, CON 15, DEX 13, INT 8, WIS 12, CHA 10
- Can proceed through character creation without errors

**❌ If Other Issues Exist:**
- Game still crashes on character creation
- Warrior class still invisible
- Error messages in Script Extender logs

---

## 🔍 **Diagnostic Steps (If Issues Persist)**

### **1. Check Script Extender Logs:**
```
Location: %LOCALAPPDATA%\Larian Studios\Baldur's Gate 3\ScriptExtender\Logs\
Files: Look for newest .log files
Search for: [BG3WOW] or error messages
```

### **2. Verify Mod Load Order:**
- Open BG3 Mod Manager
- Ensure BG3Wow is enabled (left side)
- Check for conflicts with other class mods
- Verify load order exported to game

### **3. Check Game Logs:**
```
Location: %LOCALAPPDATA%\Larian Studios\Baldur's Gate 3\PlayerProfiles\Public\
File: GustavDev\Crashes\
```

### **4. If Still Crashing:**
Possible remaining issues:
- Progressions.lsx may require Selectors for Lists/DefaultValues
- Other XML formatting issues in different files
- UUID conflicts with other mods
- Version incompatibility with BG3 Patch 8

---

## 📊 **Test Results Template**

**Please report back with:**

1. **Did the game crash?** (Yes/No)
2. **Was Warrior class visible?** (Yes/No)
3. **If visible, can you select it?** (Yes/No)
4. **Do ability scores display?** (Yes/No)
5. **Any error messages?** (Text or screenshot)
6. **Script Extender log messages?** (if applicable)

---

## 📝 **Next Steps Based on Results**

### **If Test SUCCEEDS** ✅
1. Mark AbilityDistributionPresets as working
2. Check if Progressions.lsx uses SelectAbilityBonus/SelectSkills selectors
3. Create Lists/DefaultValues ONLY if selectors exist
4. Test full character creation flow (ability points, skills, etc.)

### **If Test FAILS** ❌
**Scenario A: Still Crashing**
- Review Script Extender logs for specific error
- Compare our Progressions.lsx with official guide examples
- Check if our mod has Selectors requiring Lists/DefaultValues

**Scenario B: Class Invisible**
- Verify meta.lsx Type="Add-on"
- Check ClassDescriptions GUID handles
- Compare with 9-file requirements from official guide

**Scenario C: Other Issues**
- Extract .pak and validate all LSX files
- Check for XML syntax errors
- Verify all UUIDs are unique

---

## 📚 **References**

- **Official Guide**: https://wiki.bg3.community/Tutorials/Classes/Basic-Class-Creation
- **Dependency Verification**: `ABILITYDISTRIBUTIONPRESETS_DEPENDENCY_VERIFICATION.md`
- **Requirements Checklist**: `CLASS_CREATION_REQUIREMENTS_CHECKLIST.md`
- **Working Reference**: DemonHunter mod structure

---

**Status**: ⏳ **AWAITING TEST RESULTS FROM USER**  
**Build**: BG3Wow_FIXED_ABILITYPRESETS_20251018_131405.pak  
**Expected**: Should load without crash (XML formatting fixed)
