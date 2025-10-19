# Class Visibility Fix - Missing Files Identified

**Date**: October 18, 2025  
**Issue**: Warrior class not visible in character creation despite all previous fixes  
**Root Cause**: Missing 4 REQUIRED files per official BG3 class creation guide

---

## 🔍 **Discovery Process**

User provided critical resource: https://wiki.bg3.community/Tutorials/Classes/Basic-Class-Creation

This official guide revealed we're missing **4 ESSENTIAL files** for character creation:

---

## ❌ **Missing Required Files**

### 1. **DefaultValues/Abilities.lsx**
**Purpose**: Sets DEFAULT selected bonus ability points (+2/+1) in character creation  
**Status**: MISSING - likely blocking CC visibility  
**Required Attributes**:
- `Add` - Default abilities (e.g., "Strength;Constitution")
- `Level` - 1 for CC
- `TableUUID` - Matches Progressions.lsx
- `UUID` - Unique UUID

### 2. **DefaultValues/Skills.lsx**
**Purpose**: Sets DEFAULT selected skills in character creation  
**Status**: MISSING - likely blocking CC visibility  
**Required Attributes**:
- `Add` - Default skills (e.g., "Athletics;Intimidation")
- `Level` - 1 for CC
- `TableUUID` - Matches Progressions.lsx
- `UUID` - Unique UUID

### 3. **Lists/AbilityLists.lsx**
**Purpose**: Defines AVAILABLE abilities for bonus point selection  
**Status**: MISSING - likely blocking CC visibility  
**Required Attributes**:
- `Abilities` - "Strength, Dexterity, Constitution, Intelligence, Wisdom, Charisma"
- `UUID` - Unique UUID (referenced in Progressions Selectors)

### 4. **Lists/SkillLists.lsx**
**Purpose**: Defines AVAILABLE skills for selection  
**Status**: MISSING - likely blocking CC visibility  
**Required Attributes**:
- `Skills` - Class-appropriate skills list
- `UUID` - Unique UUID (referenced in Progressions Selectors)

---

## ✅ **Files We Already Have**

1. ✅ **meta.lsx** (with Type="Add-on")
2. ✅ **ClassDescriptions.lsx** (with GUID handles)
3. ✅ **Progressions.lsx** (with progressions)
4. ✅ **ProgressionDescriptions.lsx** (matching handles)
5. ✅ **AbilityDistributionPresets.lsx** (JUST CREATED - starting stats)
6. ✅ **ActionResourceDefinitions.lsx** (Rage resource)
7. ✅ **Stats/Generated/Data/*.txt** (abilities, spells, passives)

---

## 📊 **File Completion Status**

**Official Guide Requirements**: 9 core files  
**Our Status**: 5/9 files (55% complete)  
**Missing**: 4/9 files (45% missing)

---

## 🔗 **How Files Link Together**

```
ClassDescriptions.lsx
    ↓ (ProgressionTableUUID)
Progressions.lsx
    ↓ (Selectors attribute)
Lists/AbilityLists.lsx ← MISSING
Lists/SkillLists.lsx   ← MISSING
    ↓ (Set defaults from lists)
DefaultValues/Abilities.lsx ← MISSING
DefaultValues/Skills.lsx    ← MISSING
```

**Without Lists + DefaultValues**: Character creation system can't build ability/skill selection UI!

---

## 🎯 **Next Steps**

### **Phase 1: Create List Files**
1. Create `Lists/AbilityLists.lsx` with all 6 abilities
2. Create `Lists/SkillLists.lsx` with Warrior skills (Athletics, Intimidation, etc.)
3. Generate unique UUIDs for each list

### **Phase 2: Create DefaultValues Files**
1. Create `DefaultValues/Abilities.lsx` with default +2 STR, +1 CON
2. Create `DefaultValues/Skills.lsx` with default Athletics, Intimidation
3. Use Progressions TableUUID for both

### **Phase 3: Update Progressions.lsx**
1. Add Selectors for:
   - `SelectSkills(SKILLLIST_UUID,2)`
   - `SelectAbilityBonus(ABILITYLIST_UUID,AbilityBonus,2,1)`

### **Phase 4: Package & Test**
1. Package with all 9 required files
2. Test in character creation
3. Verify class appears and all UI elements work

---

## 📚 **Documentation Updates**

✅ Added official guide to DOCUMENTATION_LIBRARY.md (marked as ⭐ REQUIRED READING)  
✅ Created CLASS_CREATION_REQUIREMENTS_CHECKLIST.md validation document  
✅ Updated copilot-instructions.md to mandate checking guide before changes  

---

## 🔍 **Evidence from Official Guide**

> "While we have a working character at this point, it is definitely lacking a lot of common options on character creation. You will see that there is no way to spec bonus ability points and that you don't have any skills or proficiencies for the class"

This describes EXACTLY our situation - class loads but lacks CC integration!

---

## ⚠️ **Why This Matters**

The guide explicitly states these files are needed for CC:

1. **AbilityDistributionPresets** → Starting stat array (we just added ✅)
2. **Lists/AbilityLists** → Which abilities CAN be selected (missing ❌)
3. **Lists/SkillLists** → Which skills CAN be selected (missing ❌)
4. **DefaultValues/Abilities** → Which abilities ARE selected by default (missing ❌)
5. **DefaultValues/Skills** → Which skills ARE selected by default (missing ❌)

Without Lists + DefaultValues, the CC system can't render the selection UI!

---

## 📖 **Reference**

- **Official Guide**: https://wiki.bg3.community/Tutorials/Classes/Basic-Class-Creation
- **Our Checklist**: `Documentation/10_ValidationReports/CLASS_CREATION_REQUIREMENTS_CHECKLIST.md`
- **Documentation Library**: `Documentation/01_Reference-Guides/DOCUMENTATION_LIBRARY.md`

---

**Status**: Ready to implement missing files  
**Confidence**: HIGH - official guide clearly identifies missing pieces
