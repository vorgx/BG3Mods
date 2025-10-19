# Phase 1 - Report 01: WoWWarlock Complete File Inventory

**Date:** October 18, 2024  
**Mod:** WoWWarlock (UUID: bdb3fa73-401b-4979-f02e-485422dd8d9c)  
**Analysis:** Step 1 of 20

---

## 📊 Executive Summary

**Total Files:** 186  
**Total Folders:** 12  
**Mod Status:** WORKING (13,000+ downloads on Nexus)

### File Distribution by Type

| File Type | Count | Purpose |
|-----------|-------|---------|
| `.lsf` | 158 | RootTemplates (140), Content (16), MultiEffectInfos (2) |
| `.lsx` | 13 | Class definitions, progressions, lists, GUI |
| `.txt` | 10 | Spell/ability/passive stats definitions |
| `.dds` | 3 | Custom texture assets (icons) |
| `.lsfx` | 1 | Visual effects |
| `.ini` | 1 | GUI configuration |

---

## 📁 Folder Structure Analysis

### 1. **ActionResourceDefinitions/** (1 file)
- `ActionResourceDefinitions.lsx` - Defines all 10 Soul Shard resources
- **Critical:** This is where custom resources are defined

### 2. **Assets/** (4 files)
```
Assets/
├── Effects/Effects_Banks/Spells/Prepare/Wizard/VFX_Spells_*.lsfx  (1 file)
└── Textures/Icons/
    ├── newAtlas.dds
    ├── WoWWarlock.dds
    └── WoWWarlock3.dds
```
- **Purpose:** Custom visual effects and class icons
- **Note:** Custom textures for UI elements

### 3. **CharacterCreationPresets/** (1 file)
- `AbilityDistributionPresets.lsx` - Ability score presets for character creation
- **Critical:** Required for character creation to work

### 4. **ClassDescriptions/** (1 file)
- `ClassDescriptions.lsx` - Defines base Warlock class + 3 subclasses
- **Critical:** MUST EXIST - Main class definition file

### 5. **Content/** (16 files - all .lsf)
- **[PAK]_CharacterVisuals/** - 7 .lsf files
  - Visual presets for character creation
- **[PAK]_Warlock_WoW/** - 9 .lsf files
  - Mod-specific content packages
- **Purpose:** Pre-packaged content for character visuals

### 6. **GUI/** (4 files)
```
GUI/
├── imgui.ini             - GUI configuration
├── WoWWarlock.lsx        - Main GUI definition
├── WoWWarlock2.lsx       - Secondary GUI element
└── WoWWarlock3.lsx       - Tertiary GUI element
```
- **Purpose:** Custom UI elements for Soul Shard display/class UI
- **Note:** Multiple GUI files suggest complex UI system

### 7. **Levelmaps/** (1 file)
- `LevelMapValues.lsx` - Level progression mappings
- **Purpose:** Maps level values for various systems

### 8. **Lists/** (4 files) ⭐
```
Lists/
├── AbilityLists.lsx      - Ability score selection lists
├── PassiveLists.lsx      - Passive ability pools (52 lists!)
├── SkillLists.lsx        - Skill selection lists
└── SpellLists.lsx        - Spell pools (53 lists!)
```
- **Critical:** These define what abilities/spells can be selected
- **Note:** HUGE number of lists (105 total entries)

### 9. **MultiEffectInfos/** (2 files)
- `21283ede-ce72-4d5a-8c49-d0426a5a0d65.lsf`
- `25936a49-2a5f-446d-b593-4cba640c0c14.lsf`
- **Purpose:** Complex multi-effect ability definitions

### 10. **Progressions/** (2 files) ⭐
```
Progressions/
├── ProgressionDescriptions.lsx  - UI descriptions for progressions
└── Progressions.lsx              - Level-based ability grants (50+ progressions!)
```
- **Critical:** Defines what you get at each level 1-20
- **Note:** This is the "backbone" of the class

### 11. **RootTemplates/** (140 files - all .lsf) 🔥
- **Purpose:** Template definitions for items/characters/objects
- **Note:** This is HUGE - 140 template files!
- **Impact:** Extensive item/object system

### 12. **Stats/Generated/Data/** (10 files) ⭐⭐⭐
```
Stats/Generated/Data/
├── Character.txt          - Character-specific stats
├── Interrupt.txt          - Interrupt abilities
├── Object.txt             - Object interactions
├── Passive.txt            - Passive abilities ⭐
├── Spell_Projectile.txt   - Ranged spell attacks ⭐
├── Spell_Shout.txt        - AoE/buff abilities ⭐
├── Spell_Target.txt       - Single-target spells ⭐
├── Spell_Zone.txt         - Ground-targeted AoE ⭐
├── Status_BOOST.txt       - Buff effects ⭐
└── Status_EFFECT.txt      - Debuff/status effects ⭐
```
- **CRITICAL:** This is where ALL abilities are implemented
- **Note:** These are the "meat" of the mod - all spell logic lives here

---

## 🔍 Key Findings

### Critical Files (MUST EXIST):
1. ✅ `ActionResourceDefinitions.lsx` - Defines Soul Shards
2. ✅ `ClassDescriptions.lsx` - Defines class
3. ✅ `Progressions.lsx` - Grants abilities by level
4. ✅ `Lists/` folder - All 4 files present
5. ✅ `Stats/Generated/Data/` - All 10 ability stat files

### Optional But Present:
- `ProgressionDescriptions.lsx` - UI descriptions (our mod has this empty)
- `AbilityDistributionPresets.lsx` - Presets (our mod has this)
- `RootTemplates/` - 140 item templates (we don't have any)
- `Content/` - Character visuals (we don't have)
- `GUI/` - Custom UI (we don't have)
- `Levelmaps/` - Level mappings (we don't have)
- `MultiEffectInfos/` - Complex effects (we don't have)
- `Assets/` - Custom textures/VFX (we don't have)

---

## 📈 Comparison with Our Warrior Mod

### Files We Have:
- ✅ ActionResourceDefinitions.lsx
- ✅ ClassDescriptions.lsx
- ✅ Progressions.lsx
- ✅ ProgressionDescriptions.lsx (empty)
- ✅ Lists/ (all 4 files)
- ✅ Stats/Generated/Data/ (spell files)
- ✅ AbilityDistributionPresets.lsx
- ✅ DefaultValues/ (2 files - Warlock doesn't have this)

### Files We DON'T Have:
- ❌ RootTemplates/ (140 files - but may not be critical)
- ❌ Content/ (16 files - visual presets, optional)
- ❌ GUI/ (4 files - custom UI, optional)
- ❌ Levelmaps/ (1 file - unknown purpose)
- ❌ MultiEffectInfos/ (2 files - advanced, optional)
- ❌ Assets/ (4 files - custom textures, optional)

---

## 🎯 Priority Analysis

### Must Have (For Basic Functionality):
1. ✅ ActionResourceDefinitions.lsx - **WE HAVE IT** (now fixed)
2. ✅ ClassDescriptions.lsx - **WE HAVE IT**
3. ✅ Progressions.lsx - **WE HAVE IT** (restructured)
4. ✅ Lists/ folder - **WE HAVE IT** (now fixed)
5. ✅ Stats/Generated/Data/ - **WE HAVE IT**

### Nice to Have (For Polish):
- ⏳ RootTemplates/ - Item templates (not critical for class)
- ⏳ Content/ - Character visuals (optional)
- ⏳ GUI/ - Custom UI (optional)
- ⏳ Assets/ - Custom icons (optional)

---

## 🔬 Next Steps (Steps 2-4)

**Step 2:** Map Warlock's website features to these files  
**Step 3:** Extract ALL UUIDs and create cross-reference  
**Step 4:** Document version numbers and dependencies  

Then we'll dive DEEP into each critical file!

---

**Status:** STEP 1 COMPLETE ✅  
**Files Inventoried:** 186  
**Critical Files Identified:** 9  
**Missing Files in Our Mod:** 6 (all optional)

