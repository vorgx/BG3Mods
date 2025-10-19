# Documentation Correction Session Summary
**Date**: October 17, 2025  
**Session Focus**: Critical documentation audit and corrections  
**Trigger**: User clarification on Keystone/Capstone timing and Extra Attack

---

## User Clarifications Received

### 1. Keystone/Capstone Timing ⚠️ CRITICAL
**User Statement**: "CAPSTONE IS ONLY at lvl 20 and keystone ONLY at lvl 13, auto unlocks"

**Impact**: Multiple documents incorrectly showed both at L13

**Correct Structure**:
- **L13**: Keystone Talent (auto-granted) - Defines specialization theme
- **L20**: Capstone Talent (auto-granted) - Ultimate specialization power

**Examples**:
- Colossus: Demolish (L13 Keystone), Dominance of the Colossus (L20 Capstone)
- Slayer: Slayer's Dominance (L13 Keystone), Slayer's Malice (L20 Capstone)
- Mountain Thane: Avatar of the Storm (L13 Keystone), Gathering Storms (L20 Capstone)

---

### 2. Extra Attack at Level 5 ⚠️ CRITICAL
**User Statement**: "also remember the bg3, extra attacks, remember to also follow bg3 style for extra attacks, warrior will get a extra attack at lvl 5"

**Impact**: BG3 Global Rules mentions this, but not enforced in Warrior-specific documents

**BG3 Extra Attack**:
- Granted at Level 5 for ALL martial classes (Fighter, Ranger, Paladin, Barbarian, Monk, Warrior)
- When you take the Attack action, you can attack twice instead of once
- Does NOT apply to bonus action attacks or spells
- Stacks with: Haste (temporary third attack), certain class features
- Does NOT stack with: Multi-attack from different sources

**Warrior Implementation**:
- Auto-granted passive at L5
- Works with: Basic melee attacks, Mortal Strike (if coded as Attack action)
- Separate from: Sweeping Strikes (cleave mechanic), Whirlwind (AoE mechanic)

---

### 3. WoW → BG3 Ability Conversions
**User Statement**: "we probably also have to convert or WOW > BG3 all these new abilites and effects / statusses, all mechanics to match what we have"

**Scope**: ~40+ new abilities need full BG3 stat file implementations

**Reference Folders**:
- Existing implementations: `Data/Public/.../Stats/Generated/Data/*.txt`
- Design documents: `Documentation/06_ProjectDocuments/`, `Documentation/07_DesignDocuments/`

**Conversion Needs**:
1. **Class Talents** (10 rows × 2-6 options = ~24 abilities): Heroic Leap, Storm Bolt, Avatar, Champion's Spear, etc.
2. **SubclassSpec Talents** (10 rows × 2-4 options = ~24 Arms abilities): Mortal Strike, Overpower, Rend, Warbreaker, Bladestorm, etc.
3. **Specialization Talents** (~30 abilities across Colossus/Slayer/Mountain Thane)

---

## Documentation Audit Findings

### Critical Errors Discovered

#### Error 1: Capstone Timing (WIDESPREAD)
**Affected Files** (15+ files):
- ARMS_WARRIOR_5_POOL_TALENT_SYSTEM.md
- SPECIALIZATION_TIER_STRUCTURES.md
- SPECIALIZATION_PROGRESSION_VISUAL_GUIDE.md
- SPECIALIZATION_TIER_DECISION.md
- Arms_Warrior_Talents_Extracted.md (partially correct)
- Protection_Warrior_Talents_Extracted.md (needs verification)
- Fury_Warrior_Talents_Extracted.md (needs verification)

**Error**: Showed "Keystone + Capstone" both granted at L13  
**Correction**: Keystone at L13, Capstone at L20

---

#### Error 2: Missing Extra Attack (ALL DOCS)
**Affected**: ALL progression charts and level breakdowns

**Error**: No mention of L5 Extra Attack milestone  
**Correction**: Added Extra Attack to L5 progression entries

---

#### Error 3: Incorrect Specialization Availability (Arms)
**Affected**: Arms_Warrior_Talents_Extracted.md

**Error**: Showed Mountain Thane as option for Arms  
**Correction**: Arms chooses **Colossus OR Slayer** (not Mountain Thane)

**Correct Matrix**:
| Base Spec | Option 1 | Option 2 |
|-----------|----------|----------|
| Arms | Colossus | Slayer |
| Fury | Mountain Thane | Slayer |
| Protection | Mountain Thane | Colossus |

---

#### Error 4: Choice Node Levels Inconsistent
**Affected**: Arms_Warrior_Talents_Extracted.md Slayer section

**Error**: Showed choice nodes at L13, L15, L18 (inconsistent with 3-tier structure)  
**Correction**: 3-tier = L15, L17, L19 (not L13, not L18)

---

## Corrections Applied

### ✅ Completed (Session 1)

#### 1. ARMS_WARRIOR_5_POOL_TALENT_SYSTEM.md
**File**: `Documentation/07_DesignDocuments/ARMS_WARRIOR_5_POOL_TALENT_SYSTEM.md`

**Changes**:
- [x] Line ~873: Colossus Capstone header "Granted at L13" → "Granted at L20"
- [x] Line ~1004: Slayer Capstone header "Granted at L13" → "Granted at L20"
- [x] Progression chart L5 entry: Added "Extra Attack" column
- [x] Progression chart L13 entry: "Keystone + Capstone" → "Keystone ONLY"
- [x] Progression chart L20 entry: "Passive" → "Passive + Capstone"

**Status**: ✅ **COMPLETE AND ACCURATE**

---

#### 2. SPECIALIZATION_TIER_STRUCTURES.md
**File**: `Documentation/07_DesignDocuments/SPECIALIZATION_TIER_STRUCTURES.md`

**Changes**:
- [x] 3-Tier progression: Split L13 into "Keystone (auto-granted)" only
- [x] 3-Tier progression: Added L20 "Passive 4 + Capstone (auto-granted)"
- [x] 4-Tier progression: Split L13 into "Keystone (auto-granted)" only
- [x] 4-Tier progression: Added L20 "Passive 3 + Capstone (auto-granted)"
- [x] Updated Total Talents calculation (7 auto-granted for 3-tier, 6 auto-granted for 4-tier, including L20 Capstone)

**Status**: ✅ **COMPLETE AND ACCURATE**

---

### ⏸️ Pending (Remaining Work)

#### 3. SPECIALIZATION_PROGRESSION_VISUAL_GUIDE.md
**File**: `Documentation/07_DesignDocuments/SPECIALIZATION_PROGRESSION_VISUAL_GUIDE.md`

**Required Changes**:
- [ ] All 6 specialization charts need rewrite:
  - Colossus (Arms version) - Lines ~12-20
  - Slayer (Arms version) - Lines ~29-37
  - Mountain Thane (Fury version) - Lines ~48-59
  - Slayer (Fury version) - Lines ~67-75
  - Mountain Thane (Protection version) - Lines ~86-97
  - Colossus (Protection version) - Lines ~103-111
- [ ] Pattern: L13 shows Keystone only, L20 shows Passive + Capstone
- [ ] Update side-by-side comparison tables (Lines ~123, ~140)

**Status**: ⏸️ **READY FOR MANUAL UPDATE** (too complex for automated replacement)

---

#### 4. SPECIALIZATION_TIER_DECISION.md
**File**: `Documentation/06_SessionSummaries/SPECIALIZATION_TIER_DECISION.md`

**Required Changes**:
- [ ] Line ~31: 3-tier example "L13: Keystone + Capstone" → "L13: Keystone"
- [ ] Line ~31: Add "L20: Passive 4 + Capstone"
- [ ] Line ~47: 4-tier example "L13: Keystone + Capstone" → "L13: Keystone"
- [ ] Line ~47: Add "L20: Passive 3 + Capstone"

**Status**: ⏸️ **MINOR CORRECTIONS NEEDED**

---

#### 5. Arms_Warrior_Talents_Extracted.md ⚠️ CRITICAL
**File**: `Documentation/08_WoWSourceMaterial/Arms_Warrior_Talents_Extracted.md`

**Required Changes**:
- [ ] **REMOVE** entire Mountain Thane section (Lines ~330-395)
  - Replace with note: "Mountain Thane is NOT available to Arms (only Fury/Protection)"
- [ ] **FIX** Slayer choice node levels (Lines ~424-453):
  - Current: L13, L15, L18
  - Correct: L15, L17, L19 (3-tier structure)
- [ ] **ADD** complete Colossus specialization section (currently missing)
  - Keystone: Demolish (L13)
  - Capstone: Dominance of the Colossus (L20)
  - 3 choice nodes (L15, L17, L19)
  - 4 passives (L14, L16, L18, L20)

**Status**: ⏸️ **HIGH PRIORITY - MAJOR REWRITE NEEDED**

---

#### 6. Protection_Warrior_Talents_Extracted.md
**File**: `Documentation/08_WoWSourceMaterial/Protection_Warrior_Talents_Extracted.md`

**Required Changes**:
- [ ] Verify Keystone/Capstone timing (L13/L20)
- [ ] Verify specialization matrix: Mountain Thane OR Colossus (not Slayer)
- [ ] Verify choice node levels:
  - Mountain Thane: 4 tiers (L15, L16, L18, L19)
  - Colossus: 3 tiers (L15, L17, L19)
- [ ] Add full Mountain Thane spec (if missing)
- [ ] Add full Colossus spec (if missing)

**Status**: ⏸️ **NEEDS FULL REVIEW**

---

#### 7. Fury_Warrior_Talents_Extracted.md
**File**: `Documentation/08_WoWSourceMaterial/Fury_Warrior_Talents_Extracted.md`

**Required Changes**:
- [ ] Verify Keystone/Capstone timing (L13/L20)
- [ ] Verify specialization matrix: Mountain Thane OR Slayer (not Colossus)
- [ ] Verify choice node levels:
  - Mountain Thane: 4 tiers (L15, L16, L18, L19)
  - Slayer: 3 tiers (L15, L17, L19)
- [ ] Add full Mountain Thane spec (if missing)
- [ ] Add Slayer spec adapted for Fury (Bloodthirst instead of Overpower)

**Status**: ⏸️ **NEEDS FULL REVIEW**

---

#### 8. Warrior_Class_Blueprint.md
**File**: `Documentation/07_DesignDocuments/Warrior_Class_Blueprint.md`

**Required Changes**:
- [ ] Add Level 5 Extra Attack section
- [ ] Add 5-pool talent system overview (or link to ARMS_WARRIOR_5_POOL_TALENT_SYSTEM.md)
- [ ] Add specialization matrix (which specs get which specializations)
- [ ] Clarify Keystone L13 / Capstone L20 timing

**Status**: ⏸️ **NEEDS COMPREHENSIVE UPDATE**

---

## New Documents Created

### 1. DOCUMENTATION_AUDIT_CORRECTIONS_REQUIRED.md ⭐
**File**: `Documentation/DOCUMENTATION_AUDIT_CORRECTIONS_REQUIRED.md`  
**Size**: ~25KB  
**Purpose**: Master audit document listing ALL errors found and corrections needed

**Contents**:
- Critical errors breakdown (4 major issues)
- Required corrections by file (8 files)
- New documents needed (5 documents)
- Implementation priority (4 phases)
- Correction templates (3 templates)
- Verification checklist

**Status**: ✅ Complete reference document

---

### 2. DOCUMENTATION_MASS_UPDATE_SCRIPT.md
**File**: `Documentation/DOCUMENTATION_MASS_UPDATE_SCRIPT.md`  
**Size**: ~3KB  
**Purpose**: Progress tracking for ongoing correction work

**Contents**:
- Files corrected so far (2 complete: ARMS_5POOL, SPEC_TIER_STRUCTURES)
- Remaining manual corrections (8 files)
- Priority levels (High/Medium/Low)
- Next AI agent session instructions

**Status**: ✅ Living document - update as work progresses

---

## Next Steps

### Immediate Actions (User/AI)

1. **Review Completed Work**:
   - Verify `ARMS_WARRIOR_5_POOL_TALENT_SYSTEM.md` corrections
   - Verify `SPECIALIZATION_TIER_STRUCTURES.md` corrections

2. **Manual Updates** (Complex, requires careful rewriting):
   - `SPECIALIZATION_PROGRESSION_VISUAL_GUIDE.md` - All 6 charts
   - `Arms_Warrior_Talents_Extracted.md` - Remove Mountain Thane, add Colossus, fix Slayer

3. **Automated Updates** (Simple find/replace):
   - `SPECIALIZATION_TIER_DECISION.md` - 4 line changes

4. **Full Reviews** (Need to read and verify):
   - `Protection_Warrior_Talents_Extracted.md`
   - `Fury_Warrior_Talents_Extracted.md`
   - `Warrior_Class_Blueprint.md`

---

### Phase 2: New Documentation (After Corrections)

Once all existing docs are corrected, create:

1. **WOW_TO_BG3_ABILITY_CONVERSION_GUIDE.md**
   - Damage formula conversions
   - Status effect mappings
   - Cooldown conversions
   - Examples from existing abilities

2. **WARRIOR_LEVEL_5_EXTRA_ATTACK.md**
   - BG3 Extra Attack mechanics
   - Interaction with Warrior abilities
   - Implementation details

3. **CLASS_TALENTS_BG3_IMPLEMENTATIONS.md**
   - All 24+ Class Talents with full BG3 stat file specs
   - Row-by-row breakdown

4. **SUBCLASSSPEC_TALENTS_ARMS_BG3_IMPLEMENTATIONS.md**
   - All 24+ Arms SubclassSpec Talents with full BG3 stat file specs
   - Mortal Strike, Overpower, Warbreaker, Bladestorm, etc.

5. **SPECIALIZATION_BG3_IMPLEMENTATIONS.md**
   - All specialization abilities with full BG3 stat file specs
   - Colossus, Slayer, Mountain Thane complete implementations

---

## Key Takeaways

### What We Learned
1. **Keystone ≠ Capstone**: Keystone at L13 (theme-defining), Capstone at L20 (ultimate power)
2. **Extra Attack is mandatory**: BG3 core mechanic for martial classes at L5
3. **WoW → BG3 conversion is substantial work**: ~40+ abilities need full stat file implementations
4. **Documentation drift is real**: Multiple documents had same error, shows need for single source of truth

### Process Improvements
1. **Created audit system**: DOCUMENTATION_AUDIT_CORRECTIONS_REQUIRED.md as master reference
2. **Created tracking system**: DOCUMENTATION_MASS_UPDATE_SCRIPT.md for progress
3. **Established templates**: Standardized correction patterns for consistency
4. **Prioritized work**: High/Medium/Low priority helps focus efforts

---

## Statistics

- **Files Audited**: 15+ documentation files
- **Critical Errors Found**: 4 major categories
- **Files Corrected**: 2 complete, 8 remaining
- **New Documents Created**: 2 (audit + tracking)
- **Estimated Remaining Work**: 
  - High Priority: ~4 hours (visual guide, Arms extracted, tier decision)
  - Medium Priority: ~6 hours (Protection/Fury extracted, Blueprint)
  - Low Priority: ~20 hours (5 new implementation guides)

---

**Session Status**: ✅ **CRITICAL AUDIT COMPLETE - CORRECTIONS IN PROGRESS**

**Next Session**: Continue with SPECIALIZATION_PROGRESSION_VISUAL_GUIDE.md rewrite

---

**END OF SESSION SUMMARY**
