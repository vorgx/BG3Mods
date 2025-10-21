# What Needs to Be Done - Comprehensive Checklist

**Date**: October 21, 2025  
**Current Status**: Documentation Phase Complete, Ready for Implementation Phase

---

## ✅ COMPLETED TODAY (October 21, 2025)

### Phase 1: Ability Database (100% Complete)
- ✅ Created ability database with 215 abilities
- ✅ Cleaned and fixed encoding issues
- ✅ Fixed classification algorithm
- ✅ Documented WoW source references
- ✅ **100% enrichment** (all abilities have BG3 mechanics)

### Phase 2: Organization (100% Complete)
- ✅ Organized 00_SourcesOfTruth folder (41 → 4 files)
- ✅ Integrated 4 critical files into all documentation
- ✅ Cleaned up root directory (40+ → 6 files)
- ✅ Created Scripts/Database/ and Scripts/Enrichment/ folders

---

## 🚧 SOURCE OF TRUTH.md - Section Status

Based on `Documentation/00_SourcesOfTruth/SOURCE_OF_TRUTH.md`:

| Section | Status | Priority | Notes |
|---------|--------|----------|-------|
| **[1] Overview** | ✅ Complete | - | Project identity, future classes |
| **[2] Meta Information** | ✅ Complete | - | UUID, version, dependencies |
| **[3] Class Details** | ✅ Complete | - | Levels 1-12, 3 subclasses |
| **[4] Subclasses** | ✅ Complete | - | Arms, Fury, Protection (L1-L12) |
| **[4.1] Arms Warrior** | ✅ Complete | - | Full spec documentation |
| **[4.2] Fury Warrior** | ✅ Complete | - | Full spec documentation |
| **[4.3] Protection Warrior** | ✅ Complete | - | Full spec documentation |
| **[4.9] Tooltip Archetype Tagging** | 📋 Parked | Low | Future UX enhancement |
| **[5] Specializations/Hero Classes L13-20** | 🚧 **TODO** | **HIGH** | Mountain Thane, Colossus, Slayer |
| **[6] Progression** | 🚧 **TODO** | **HIGH** | Level-by-level progression tables |
| **[7] Lists - Spells** | 🚧 **TODO** | **MEDIUM** | All spell abilities |
| **[8] Lists - Status** | 🚧 **TODO** | **MEDIUM** | All status effects |
| **[9] Lists - Passive** | 🚧 **TODO** | **MEDIUM** | All passive abilities |
| **[10] Action Resources** | 🚧 **TODO** | **MEDIUM** | Rage + charge systems |
| **[11] File Transformation Status** | 🚧 **TODO** | **HIGH** | Track FILES 4-15 |
| **[12] Folder Structure Inventory** | ✅ Complete | - | Updated Oct 21 |
| **[13] Master Ability Database** | ✅ Complete | - | 215 abilities, 100% enriched |

---

## 📋 TODO LIST - Prioritized

### 🔴 HIGH PRIORITY (Must Complete Before Implementation)

#### 1. Complete Section [5] - Specializations/Hero Classes L13-20
**Estimated Time**: 2-3 hours  
**Why**: Documents hero talent trees (Mountain Thane, Colossus, Slayer)  
**Data Available**:
- ✅ AbilityDatabase_Warrior_FullyEnriched.csv (all hero talents enriched)
- ✅ Excel columns 56-64 (hero talent progression)
- ✅ Preview sections in [4.1.9], [4.2.9], [4.3.9]

**What to Include**:
- Mountain Thane (Protection + Fury)
  - L13 Keystone: Avatar of the Storm
  - L15/L17/L19/L20 choice nodes
  - Build synergies
- Colossus (Arms + Protection)
  - L13 Keystone: Colossal Might
  - L15/L17/L19/L20 choice nodes
  - Build synergies
- Slayer (Arms + Fury)
  - L13 Keystone: Slayer's Strike
  - L15/L17/L19/L20 choice nodes
  - Build synergies

---

#### 2. Complete Section [6] - Progression
**Estimated Time**: 3-4 hours  
**Why**: Full level-by-level progression tables for all 3 subclasses  
**Data Available**:
- ✅ Excel file with all progression data
- ✅ Section [3] and [4] have partial progression data

**What to Include**:
- Level-by-level tables (L1-L20) for each subclass
- Ability unlocks per level
- Class Talent choices (Rows 1-10)
- SubclassSpec Talent choices (Rows 1-10)
- Hero Talent choices (L13-L20)
- Total player choices per level

---

#### 3. Add Dependency Chains to Ability Database
**Estimated Time**: 3-4 hours  
**Why**: Populate requires_ability, unlocks_ability, modified_by columns  
**Data Available**:
- ✅ SOURCE_OF_TRUTH.md Section [4] (bidirectional callouts)
- ✅ Excel progression table

**What to Do**:
- Parse talent prerequisites from Section [4]
- Extract "Requires:" and "Unlocks:" relationships
- Parse passive modifications (e.g., Improved Execute → Execute)
- Update database columns:
  - requires_ability (comma-separated list)
  - unlocks_ability (comma-separated list)
  - modified_by (comma-separated list of passives)

---

#### 4. Update Section [11] - File Transformation Status
**Estimated Time**: 1 hour  
**Why**: Track transformation progress for FILES 4-15  
**Currently**: Shows FILES 1-3 complete  
**Need**: Add status tracking for remaining files

**Files to Track**:
- FILE 4: Spell_Target.txt (19 abilities)
- FILE 5: Spell_Shout.txt (21 abilities)
- FILE 6: Spell_Zone.txt (12 abilities)
- FILE 7: Spell_Projectile.txt (6 abilities)
- FILE 8: Spell_Jump.txt (3 abilities)
- FILE 9: Status_BOOST.txt (status effects)
- FILE 10: Passive.txt (154 passives)
- FILE 11: Progressions.lsx (level progression)
- FILE 12: Lists/SpellLists.lsx (spell list assignments)
- FILE 13: Lists/PassiveLists.lsx (passive list assignments)
- FILE 14: Localization/English.loca.xml (all text)
- FILE 15: ScriptExtender/Lua/* (SE scripts)

---

### 🟡 MEDIUM PRIORITY (Documentation Enhancement)

#### 5. Complete Section [7] - Lists - Spells
**Estimated Time**: 2 hours  
**Why**: Document all spell abilities by category  
**Data Available**: AbilityDatabase_Warrior_FullyEnriched.csv

**What to Include**:
- Baseline abilities (12)
- Class Talents
- SubclassSpec Talents (Arms, Fury, Protection)
- Hero Talents (Mountain Thane, Colossus, Slayer)
- Organized by bg3_file_type

---

#### 6. Complete Section [8] - Lists - Status
**Estimated Time**: 1-2 hours  
**Why**: Document all status effects (buffs/debuffs)  
**Data Available**: AbilityDatabase_Warrior_FullyEnriched.csv

**What to Include**:
- All status effects used by abilities
- Duration, stacks, effects
- Visual effects
- Removal conditions

---

#### 7. Complete Section [9] - Lists - Passive
**Estimated Time**: 2-3 hours  
**Why**: Document all 154 passive abilities  
**Data Available**: AbilityDatabase_Warrior_FullyEnriched.csv

**What to Include**:
- All passive abilities organized by category
- Class passives
- SubclassSpec passives
- Hero talent passives
- Triggers and effects

---

#### 8. Complete Section [10] - Action Resources
**Estimated Time**: 1 hour  
**Why**: Document Rage + 5 charge systems  
**Data Available**: ActionResourceDefinitions.lsx (FILE 3 - already transformed)

**What to Include**:
- Rage (0-100, main resource)
- Shield Block Charges (Protection)
- Overpower Charges (Arms)
- Rage Charges (Fury)
- Execute Charges (All specs)
- Thunder Clap Charges (Protection)

---

### 🟢 LOW PRIORITY (Optional Enhancement)

#### 9. Create Validation Script
**Estimated Time**: 2 hours  
**Why**: Validate database integrity  
**Location**: Scripts/Database/Validate-AbilityDatabase.ps1

**What to Check**:
- Duplicate ability IDs
- Foreign key references (requires_ability, etc.)
- Required fields populated
- Resource usage validation

---

#### 10. Map Implementation Status from Stat Files
**Estimated Time**: 1 hour  
**Why**: Track which abilities are implemented  
**Note**: Defer until transformation begins (currently Warlock template)

**What to Do**:
- Scan stat files for implemented abilities
- Update implementation_status column in database
- Mark tested_in_game when validated

---

#### 11. Tooltip Archetype Tagging (Section [4.9])
**Estimated Time**: 2-3 hours  
**Why**: In-game UX enhancement  
**Status**: Parked for future

**What to Do**:
- Add build archetype tags to talent tooltips
- Format: "Execute Build", "Bleed Build", etc.
- Implement in English.loca.xml

---

## 🎯 RECOMMENDED ORDER OF COMPLETION

### Phase 1: Documentation Completion (Before Implementation)
```
1. Section [5] - Hero Classes (2-3 hours)          ← HIGH PRIORITY
   ↓
2. Section [6] - Progression (3-4 hours)           ← HIGH PRIORITY
   ↓
3. Section [11] - File Transformation Status (1 hour) ← HIGH PRIORITY
   ↓
4. Add Dependency Chains to Database (3-4 hours)   ← HIGH PRIORITY
   ↓
Total: 9-12 hours
```

### Phase 2: Implementation Preparation (Optional)
```
5. Section [7] - Lists - Spells (2 hours)          ← MEDIUM PRIORITY
   ↓
6. Section [8] - Lists - Status (1-2 hours)        ← MEDIUM PRIORITY
   ↓
7. Section [9] - Lists - Passive (2-3 hours)       ← MEDIUM PRIORITY
   ↓
8. Section [10] - Action Resources (1 hour)        ← MEDIUM PRIORITY
   ↓
Total: 6-8 hours
```

### Phase 3: File-by-File Transformation (Main Work)
```
9. FILE 4: Spell_Target.txt (19 abilities)
   ↓
10. FILE 5: Spell_Shout.txt (21 abilities)
   ↓
11. FILE 6: Spell_Zone.txt (12 abilities)
   ↓
... (continue through FILE 15)
   ↓
Total: 40-60 hours (estimated)
```

---

## 📊 Progress Tracking

### Documentation Status:
- ✅ Sections [1-4, 12-13] Complete (8/13)
- 🚧 Sections [5-11] TODO (5/13)
- **Overall**: 61.5% complete

### Implementation Status:
- ✅ FILES 1-3 Transformed (3/15)
- 🚧 FILES 4-15 TODO (12/15)
- **Overall**: 20% complete

### Database Status:
- ✅ 215 abilities created (100%)
- ✅ 215 abilities enriched (100%)
- 🚧 Dependency chains TODO (0%)
- 🚧 Implementation status TODO (0%)
- **Overall**: 80% complete

---

## 🚀 Next Session Recommendations

### Option A: Complete Documentation First (Recommended)
**Why**: Finish all planning before implementation  
**Time**: 9-12 hours (Sections 5, 6, 11 + dependencies)  
**Benefit**: Have complete reference before coding

### Option B: Start Implementation Now
**Why**: Begin transformation work  
**Time**: Start with FILE 4 (Spell_Target.txt)  
**Risk**: May need to backfill documentation later

### Option C: Hybrid Approach
**Why**: Complete Section 5 (hero talents) + start FILE 4  
**Time**: 2-3 hours documentation + begin implementation  
**Benefit**: Balanced progress on both fronts

---

## 📝 User Decision Points

**Question 1**: Complete all documentation first, or start implementation?  
**Question 2**: Which section to tackle first (5, 6, or 11)?  
**Question 3**: Add dependency chains before or after implementation?

---

**Summary**: 
- **Documentation**: 5 sections remaining (Sections 5-11)
- **Database**: 2 enhancements needed (dependencies, implementation status)
- **Implementation**: 12 files remaining (FILES 4-15)
- **Total Estimated Time**: 55-80 hours remaining

**Recommended Next Step**: Complete Section [5] - Hero Classes (2-3 hours)
