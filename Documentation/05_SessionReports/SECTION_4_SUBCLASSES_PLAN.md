# Section [4] Subclasses - Implementation Plan

**Date**: October 20, 2025  
**Status**: 🚧 Planning Phase  
**Estimated Time**: 2-3 hours for complete section

---

## 📋 Section Overview

**Purpose**: Document all 3 Warrior subclasses with comprehensive details:
- Arms Warrior (DPS - two-handed weapons)
- Fury Warrior (DPS - dual-wielding berserker)
- Protection Warrior (Tank - sword and board)

**Scope**: 
- Subclass identity and flavor
- Unique mechanics and playstyle
- SubclassSpec Talents (Pool 2, Rows 1-10) - 10 choices per subclass
- Ability progression (L1-L12 baseline abilities)
- Cross-references to Sections [3] and [6]

---

## 🎯 Plan: Build Subsections Systematically

### Strategy: 3 Major Subsections

**[4.1] Arms Warrior**  
**[4.2] Fury Warrior**  
**[4.3] Protection Warrior**

Each subsection will follow the **same template structure** for consistency.

---

## 📐 Template Structure (Per Subclass)

### **Subsection X.1: Subclass Identity**
- **Flavor Text** (WoW fantasy adapted to BG3)
- **Core Concept** (1-2 sentences)
- **Equipment** (weapon types, armor)
- **Primary/Secondary Abilities** (from Section [1])

### **Subsection X.2: Unique Mechanics**
- **Subclass-Specific Mechanics** (e.g., Arms = Mastery: Deep Wounds, Fury = Enrage system, Protection = Block/Riposte)
- **Baseline Ability Timing** (when they get key abilities - reference Section [3.3])
- **Design Philosophy** (why this spec gets abilities in this order)

### **Subsection X.3: SubclassSpec Talents (Pool 2)**
- **Overview**: 10 rows (L3-L12), players make 10 choices
- **Row-by-Row Breakdown**:
  - Row 1 (L3 - Auto-Grant): Starting passive/stance
  - Row 2 (L4): 2-3 choice options
  - Row 3 (L5): 2-3 choice options
  - Row 4 (L6): 2-3 choice options
  - Row 5 (L7): 2-3 choice options
  - Row 6 (L8): 2-3 choice options
  - Row 7 (L9): 2-3 choice options
  - Row 8 (L10): 2-3 choice options
  - Row 9 (L11): 2-3 choice options
  - Row 10 (L12): 2-3 choice options
- **Total Options**: ~55-60 talents per subclass

### **Subsection X.4: Ability Progression Summary**
- **Baseline Abilities (L1-L12)**: Quick reference table (from Section [3.3])
- **SubclassSpec Talents**: Quick reference table (auto-grants + choice nodes)
- **Total Features**: Count of baseline + talents at each level

### **Subsection X.5: Cross-References**
- Section [3.1]: Base class definition
- Section [3.2]: Rage system, 12 baseline abilities table
- Section [3.3]: Level-by-level progression
- Section [5]: Hero talent options (Mountain Thane / Colossus / Slayer)
- Section [6]: Full progression implementation
- Excel source: Column ranges for SubclassSpec Talents

### **Subsection X.6: Validation Checklist**
- [ ] Identity and flavor documented
- [ ] Unique mechanics explained
- [ ] All 10 SubclassSpec Talent rows documented
- [ ] Ability progression table matches Section [3.3]
- [ ] Cross-references verified
- [ ] Total ability count matches Excel

---

## 📊 Excel Data Sources

### Arms Warrior (Columns 24-36)
- **Total SubclassSpec Talents**: **61 options** (3 auto-grants + 58 choice options across 9 rows)
- **Baseline Abilities**: Columns 4-5 (offensive + utility)
- **Key Document**: EXCEL_ABILITY_COUNT_SUMMARY.md lines 102-199

### Fury Warrior (Columns 37-47)
- **Total SubclassSpec Talents**: **59 options** (3 auto-grants + 56 choice options across 9 rows)
- **Baseline Abilities**: Columns 9-10 (offensive + utility)
- **Key Document**: EXCEL_ABILITY_COUNT_SUMMARY.md lines 201-284

### Protection Warrior (Columns 48-55)
- **Total SubclassSpec Talents**: **47 options** (1 auto-grant + 46 choice options across 9 rows)
- **Baseline Abilities**: Columns 6-8 (offensive + utility + passives)
- **Key Document**: EXCEL_ABILITY_COUNT_SUMMARY.md lines 286-354

---

## 🚀 Recommended Workflow

### **Option 1: Complete [4.1] Arms First** (Recommended)
**Why**: 
- Arms is the "standard" DPS spec (easiest to understand)
- Validates template structure before replicating to Fury/Protection
- Most documentation already exists for Arms (ARMS_WARRIOR_IMPLEMENTATION_ROADMAP.md)

**Steps**:
1. Create [4.1] Arms Warrior using template structure
2. Extract SubclassSpec Talent data from Excel (columns 24-36)
3. Document all 10 rows with choice options
4. Add ability progression summary
5. Validate against Section [3.3]
6. **User Review & Approval** ← Critical checkpoint
7. Use approved Arms structure as template for Fury/Protection

**Time Estimate**: 45-60 minutes for Arms alone

---

### **Option 2: Build All 3 Subclasses in Parallel** (Faster, Higher Risk)
**Why**:
- Completes Section [4] in one session
- Ensures consistency across all 3 subclasses
- Identifies patterns/discrepancies early

**Risks**:
- If template structure needs changes, must update all 3
- Larger scope = more potential for errors
- Harder to validate incrementally

**Steps**:
1. Create [4.1], [4.2], [4.3] subsection structures
2. Extract ALL SubclassSpec Talent data from Excel (cols 24-55)
3. Document all 30 talent rows (10 per subclass)
4. Add ability progression summaries for all 3
5. Validate all 3 against Section [3.3]
6. **User Review & Approval** ← Single big checkpoint

**Time Estimate**: 2-3 hours for all 3 subclasses

---

### **Option 3: High-Level Overview First** (Fastest, Least Detail)
**Why**:
- Quickly establishes Section [4] structure
- Placeholder for future detailed work
- Moves to other priorities (Section [5], [6], file transformations)

**Content**:
- Subclass identity paragraphs (3-5 sentences each)
- Unique mechanics summary (1-2 paragraphs)
- "SubclassSpec Talents: See Excel columns X-Y" references
- Quick ability progression table (reference Section [3.3])

**Steps**:
1. Write 3 identity/flavor paragraphs
2. Write 3 unique mechanics summaries
3. Add Excel column references for SubclassSpec Talents
4. Link to Section [3.3] for ability progression
5. Add "Detailed talent breakdowns TBD" placeholders

**Time Estimate**: 20-30 minutes for all 3 subclasses

---

## 💡 Recommendation: **Option 1 - Arms First**

**Rationale**:
1. ✅ **Incremental validation** - Catch template issues early
2. ✅ **User feedback loop** - Get approval before scaling to 3 subclasses
3. ✅ **Quality over speed** - Ensure accuracy before replication
4. ✅ **Existing documentation** - ARMS_WARRIOR_IMPLEMENTATION_ROADMAP.md provides foundation
5. ✅ **Natural progression** - Section [3] → Arms → Fury/Protection

**Next Steps After Arms Complete**:
- User reviews Arms subsection
- Approve template structure
- Replicate template to Fury (45 min)
- Replicate template to Protection (45 min)
- **Total time**: ~2.5 hours for complete Section [4]

---

## 📚 Reference Materials

### Existing Documentation:
- ✅ **EXCEL_ABILITY_COUNT_SUMMARY.md** - Complete talent inventory (517 lines)
- ✅ **EXCEL_WARRIOR_PROGRESSION_ANALYSIS.md** - Level-by-level breakdown (571 lines)
- ✅ **ARMS_WARRIOR_IMPLEMENTATION_ROADMAP.md** - Arms-specific implementation guide
- ✅ **Section [3.3]** - Baseline ability progression (L1-L12)
- ✅ **Section [3.2]** - Core mechanics, 12 baseline abilities table
- ✅ **Warrior Progression for all subclasses.xlsx** - Primary source

### Data Extraction Steps:
1. Open Excel file
2. Navigate to columns 24-55 (SubclassSpec Talents)
3. Rows 4-16 = Levels 1-12, Rows 1-10 for Pool 2 talents
4. Extract talent names, descriptions, auto-grants vs. choices
5. Cross-reference with EXCEL_ABILITY_COUNT_SUMMARY.md

---

## ✅ Success Criteria

**Section [4] is complete when**:
- [x] All 3 subclasses have subsections ([4.1], [4.2], [4.3])
- [x] Each subsection follows consistent template structure
- [x] All SubclassSpec Talent rows (1-10) documented per subclass
- [x] Ability progression summaries match Section [3.3]
- [x] Cross-references validated
- [x] Excel data accuracy verified
- [x] User approval received

---

## 🎯 Decision Point: Which Option?

**Option 1**: Arms first (45-60 min) → User approval → Fury/Protection (90 min) = **2.5 hours total**  
**Option 2**: All 3 subclasses (2-3 hours) → Single user approval  
**Option 3**: High-level overview only (20-30 min) → Defer details

**What would you like to do?**

1. **Option 1** - Build [4.1] Arms Warrior completely, get approval, then replicate ✅ **RECOMMENDED**
2. **Option 2** - Build all 3 subclasses in one session (full detail)
3. **Option 3** - Create high-level placeholders, move to next priority

---

**Status**: ⏸️ Awaiting user decision on approach
