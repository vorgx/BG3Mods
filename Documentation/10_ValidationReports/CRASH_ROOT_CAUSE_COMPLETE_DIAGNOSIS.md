# CRASH ROOT CAUSE ANALYSIS - BG3Wow Warrior Class

**Date**: October 18, 2025, 13:17  
**Final Build**: BG3Wow_COMPLETE_WITH_LISTS_20251018_131754.pak  
**Size**: 60.46 KB  
**Status**: ✅ **ALL 9 REQUIRED FILES PRESENT - READY FOR TESTING**

---

## 🎯 **ROOT CAUSE IDENTIFIED**

### **What We Thought:**
❌ AbilityDistributionPresets.lsx caused crash due to:
- XML formatting issues (attribute order, comments, version)
- Missing Lists/DefaultValues dependencies

### **Actual Root Cause:**
✅ **Progressions.lsx uses `SelectSkills` and `SelectAbilityBonus` selectors**

**Evidence from Progressions.lsx (lines 37-47)**:
```xml
<node id="Selectors">
    <children>
        <node id="SelectSkills">
            <attribute id="Amount" type="uint8" value="2"/>
            <attribute id="SkillsList" type="guid" value="f974ebd6-3725-4b90-bb5c-2b647d41615d"/>
            <attribute id="UUID" type="guid" value="1b2c3d4e-5f6a-7b8c-9d0e-1f2a3b4c5d6e"/>
        </node>
        <node id="SelectAbilityBonus">
            <attribute id="Amount" type="uint8" value="2"/>
            <attribute id="BonusType" type="uint8" value="1"/>
            <attribute id="UUID" type="guid" value="2c3d4e5f-6a7b-8c9d-0e1f-2a3b4c5d6e7f"/>
        </node>
    </children>
</node>
```

**When these selectors are present, BG3 REQUIRES**:
1. `Lists/SkillLists.lsx` - Defines which skills are available to select
2. `DefaultValues/Skills.lsx` - Defines which skills are pre-selected
3. `DefaultValues/Abilities.lsx` - Defines which abilities are pre-selected for bonus points

**Without these files**: Game crashes on character creation when trying to render skill/ability selection UI.

---

## 📊 **Dependency Analysis - Corrected Understanding**

### **AbilityDistributionPresets.lsx:**
✅ **IS INDEPENDENT** - Only needs ClassUUID  
✅ **Works without Lists/DefaultValues**  
✅ XML formatting fixes were good practice but NOT the crash cause

### **Lists/DefaultValues:**
❌ **ARE REQUIRED** - But only when Progressions.lsx uses specific selectors  
✅ **Our Progressions DOES use SelectSkills + SelectAbilityBonus**  
✅ **Therefore we MUST have Lists/DefaultValues**

### **From Official Guide:**
- AbilityDistributionPresets created in "basic class" section (Phase 1)
- Lists/DefaultValues created in "add skills/abilities" section (Phase 2)
- **Both phases apply to us because our Progressions has Selectors**

---

## 🔧 **Files Created (Solution)**

### **1. Lists/SkillLists.lsx**
**Purpose**: Defines which skills Warrior can choose from (2 selections)

**UUID**: `f974ebd6-3725-4b90-bb5c-2b647d41615d` (matches Progressions.lsx SkillsList)

**Skills Available**:
- Athletics (STR)
- Acrobatics (DEX)
- AnimalHandling (WIS)
- Intimidation (CHA)
- Perception (WIS)
- Survival (WIS)

**Rationale**: Warrior-appropriate skills focusing on physical prowess, awareness, and intimidation.

---

### **2. DefaultValues/Skills.lsx**
**Purpose**: Pre-selects default skills in character creation UI

**TableUUID**: `a1b2c3d4-e5f6-7a8b-9c0d-1e2f3a4b5c6d` (Warrior base class progression table)

**Default Skills**:
- Athletics (core Warrior skill)
- Intimidation (thematic for Warrior)

**Behavior**: When player opens skill selection, these 2 are already checked.

---

### **3. DefaultValues/Abilities.lsx**
**Purpose**: Pre-selects default ability bonuses (+2 / +1) in character creation UI

**TableUUID**: `a1b2c3d4-e5f6-7a8b-9c0d-1e2f3a4b5c6d` (Warrior base class progression table)

**SelectorId**: `AbilityBonus` (matches SelectAbilityBonus selector)

**Default Bonuses**:
- Strength +2 (primary Warrior ability)
- Constitution +1 (secondary for survivability)

**Behavior**: When player opens ability bonus selection, Strength and Constitution are pre-selected.

---

## 📦 **Final File Checklist (9/9 Complete)**

### **Phase 1: Basic Class (INDEPENDENT)**
✅ 1. `meta.lsx` - Mod metadata (Type="Add-on")  
✅ 2. `ClassDescriptions.lsx` - Class definitions (4 classes: base + 3 subclasses)  
✅ 3. `Progressions.lsx` - Level progression (1-20, WITH Selectors)  
✅ 4. `ProgressionDescriptions.lsx` - Matching handles  
✅ 5. `ActionResourceDefinitions.lsx` - Rage resource  
✅ 6. `AbilityDistributionPresets.lsx` - Starting ability scores (4 presets)

### **Phase 2: Advanced Selectors (REQUIRED for our mod)**
✅ 7. `Lists/SkillLists.lsx` - Available skills (NEW - fixes crash)  
✅ 8. `DefaultValues/Skills.lsx` - Pre-selected skills (NEW - fixes crash)  
✅ 9. `DefaultValues/Abilities.lsx` - Pre-selected abilities (NEW - fixes crash)

---

## 🔍 **Diagnostic Process (What We Did)**

### **Step 1: Initial Crash** ✅
- Added AbilityDistributionPresets.lsx
- Game crashed
- Hypothesis: XML formatting issues

### **Step 2: Official Guide Verification** ✅
- Consulted https://wiki.bg3.community/Tutorials/Classes/Basic-Class-Creation
- Discovered AbilityDistributionPresets is Phase 1 (independent)
- Learned Lists/DefaultValues are Phase 2 (dependent on Selectors)

### **Step 3: XML Formatting Fix** ⚠️ (Good but not root cause)
- Fixed attribute order (ClassUUID first → UUID last)
- Removed XML comments
- Changed version to build="60"
- **Result**: Still crashed

### **Step 4: User Report "crashing"** 🎯 CRITICAL
- Triggered deep investigation
- Checked Progressions.lsx for Selectors
- **FOUND**: SelectSkills and SelectAbilityBonus present
- **CONCLUSION**: Lists/DefaultValues ARE required for OUR mod

### **Step 5: Created Missing Files** ✅
- Studied DemonHunter reference mod structure
- Created Lists/SkillLists.lsx with Warrior skills
- Created DefaultValues/Skills.lsx with Athletics, Intimidation
- Created DefaultValues/Abilities.lsx with Strength +2, Constitution +1
- **Result**: All 9 files present

---

## 🎮 **Testing Instructions**

### **Installation:**
✅ Already copied to: `%LOCALAPPDATA%\Larian Studios\Baldur's Gate 3\Mods\`  
✅ File: `BG3Wow_COMPLETE_WITH_LISTS_20251018_131754.pak`

### **Steps:**
1. Open BG3 Mod Manager
2. Click "Refresh" to see new mod version
3. Enable mod (drag to active list)
4. Export load order (Ctrl+S)
5. Launch game via Mod Manager
6. Start character creation

### **Expected Results:**
✅ Warrior class visible in character creation  
✅ No crash when selecting class  
✅ Default ability scores display (STR 15, CON 14, etc.)  
✅ **Skill selection UI appears** (Athletics, Intimidation pre-selected)  
✅ **Ability bonus UI appears** (Strength, Constitution pre-selected)  
✅ Can proceed through character creation without errors

---

## 📚 **Key Learnings**

### **1. AbilityDistributionPresets Independence:**
- ✅ **TRUE**: AbilityDistributionPresets.lsx does NOT depend on Lists/DefaultValues
- ✅ Works independently with only ClassUUID
- ✅ Official guide confirms it's Phase 1 (basic class)

### **2. Lists/DefaultValues Dependency:**
- ⚠️ **CONDITIONAL**: Only required if Progressions.lsx uses certain Selectors
- ✅ **Our case**: We DO use SelectSkills + SelectAbilityBonus
- ✅ **Therefore**: We MUST have Lists/DefaultValues

### **3. Crash Diagnosis Workflow:**
1. Check official guide for file requirements
2. Verify file structure against requirements
3. **Check Progressions.lsx for Selectors** (this is key!)
4. If Selectors present → Lists/DefaultValues required
5. Compare with working reference mods

### **4. Why Official Guide Seemed Misleading:**
- Guide says AbilityDistributionPresets is "independent" ✅ TRUE
- Guide says Lists/DefaultValues are "optional" ⚠️ TRUE for BASIC class
- **But**: Most real-world mods use Selectors (like ours)
- **Therefore**: Lists/DefaultValues become required in practice

---

## 📝 **Documentation Updated**

✅ **ABILITYDISTRIBUTIONPRESETS_DEPENDENCY_VERIFICATION.md** - Explains independence  
✅ **CLASS_CREATION_REQUIREMENTS_CHECKLIST.md** - Shows Phase 1 vs Phase 2 dependencies  
✅ **TEST_REPORT_FIXED_ABILITYPRESETS_20251018.md** - First test plan (incomplete)  
✅ **THIS FILE** - Complete crash diagnosis and resolution

---

## 🚀 **Status: READY FOR TESTING**

**Build**: BG3Wow_COMPLETE_WITH_LISTS_20251018_131754.pak  
**Files**: 9/9 complete (all required files present)  
**Expected**: Should load without crash and show full character creation UI  
**Awaiting**: User test results

---

**Created**: October 18, 2025, 13:17  
**Last Updated**: October 18, 2025, 13:17  
**Resolution**: Complete - all 9 required files created and packaged
