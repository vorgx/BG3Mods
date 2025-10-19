# Progression System Mismatch Analysis

**Date**: October 17, 2025  
**Issue**: Design document describes a WoW-style talent tree system, but implementation is a simplified BG3 progression

---

## 🔴 CRITICAL DISCREPANCY FOUND

The design document (`Documentation/07_DesignDocuments/Talets mechanics.md`) describes a **complex 4-tier talent system** with player choices at nearly every level, but the **actual implementation** in `Progressions.lsx` is a **fixed linear progression** with only 4 choice points total.

---

## Design Document Specification

### **System Overview**
The design calls for **4 separate talent systems** that work together:

### 1️⃣ **Class Talents** (10 rows)
- **Structure**: 10 rows of talents shared by all Warriors
- **Progression**: 
  - Level 1: Get ALL talents from Row 1 automatically
  - Levels 3/5/7/9/11/13/15/17/19: Pick 1 talent from next row (every 2 levels)
- **Total Choices**: 9 choices (rows 2-10)
- **Example**: Row 1 might have "Charge + Heroic Strike", Row 2 has "Battle Shout OR Intimidating Shout OR Rallying Cry"

### 2️⃣ **SubclassSpec Talents** (10 rows)
- **Structure**: 10 rows of Arms-specific talents
- **Progression**:
  - Level 1: Get passives + ALL from Row 1 automatically
  - Levels 3/5/7/9/11/13/15/17/19: Pick 1 talent from next row (every 2 levels)
- **Total Choices**: 9 choices (rows 2-10)
- **Example**: Row 1 has "Weapon Mastery passive + Mortal Strike", Row 2 has "Overpower OR Colossus Smash OR Warbreaker"

### 3️⃣ **SubclassBase Talents** (Bucket/Pool)
- **Structure**: Pool of baseline Arms abilities (no rows, just a collection)
- **Progression**:
  - Level 1: Pick 1 Offense + 1 Utility from pool
  - Levels 2-20: Pick 1 ability per level from pool until exhausted
- **Total Choices**: ~15-20 choices (1 per level)
- **Example Pool**: Execute, Sweeping Strikes, Hamstring, Defensive Stance, etc.

### 4️⃣ **Specialization** (Hero Talents - Colossus OR Slayer)
- **Structure**: Choose 1 of 2 hero talent trees at L13
- **Components**:
  - **Key Talent**: Granted automatically at L13 (defines spec)
  - **Capstone**: Granted automatically at L13
  - **Choice Node 1**: Pick 1 of 3 at L15
  - **Choice Node 2**: Pick 1 of 3 at L17
  - **Choice Node 3**: Pick 1 of 3 at L19
  - **Passives**: 1 passive per level L13-20 (8 total) from pool
- **Total Choices**: 1 spec choice + 3 node choices + ~8 passive choices = ~12 choices

### **TOTAL CHOICES IN DESIGN**:
- Class Talents: 9 choices
- SubclassSpec Talents: 9 choices  
- SubclassBase Talents: ~18 choices
- Specialization: ~12 choices
- **GRAND TOTAL**: ~48 player choices across 20 levels

---

## Current Implementation (Progressions.lsx)

### **What's Actually Implemented**:

#### **Base Warrior Progression (Fixed)**
- L1: Charge, Heroic Strike, Rage resource (AUTOMATIC)
- L2: Battle Shout (AUTOMATIC)
- L3: Execute (AUTOMATIC)
- L4: **FEAT CHOICE** ✅
- L5: Extra Attack (AUTOMATIC)
- L6: Defensive Stance (AUTOMATIC)
- L7: Intimidating Shout (AUTOMATIC)
- L8: **FEAT CHOICE** ✅
- L9: Heroic Leap (AUTOMATIC)
- L10: Rallying Cry (AUTOMATIC)
- L11: Improved Extra Attack (AUTOMATIC)
- L12: **FEAT CHOICE** ✅
- L13: Inspiring Presence (AUTOMATIC)
- L14: Hamstring (AUTOMATIC)
- L15: Spell Reflection (AUTOMATIC)
- L16: **FEAT CHOICE** ✅
- L17: Die by the Sword (AUTOMATIC)
- L18: Indomitable (AUTOMATIC)
- L19: Avatar (AUTOMATIC)
- L20: **FEAT CHOICE** ✅

#### **Arms Subclass Progression (Fixed)**
- L1: Weapon Mastery passive (AUTOMATIC)
- L3: Mortal Strike, Overpower (AUTOMATIC)
- L5: Tactical Mastery passive (AUTOMATIC)
- L7: Colossus Smash (AUTOMATIC)
- L9: Sweeping Strikes (AUTOMATIC)
- L11: Warbreaker (AUTOMATIC)
- L13: **HERO TALENT CHOICE** (Colossus OR Slayer) ✅
- L15: **HERO TALENT TIER 1** (1 of 3 passives) ✅
- L17: **HERO TALENT TIER 2** (1 of 3 passives) ✅
- L19: **HERO TALENT TIER 3** (1 of 3 passives) ✅
- L20: Hero talent capstone (AUTOMATIC based on L13 choice)

### **TOTAL CHOICES IN IMPLEMENTATION**:
- Base Warrior: 5 feat choices
- Arms Subclass: 1 hero talent choice + 3 tier choices
- **GRAND TOTAL**: 9 player choices across 20 levels

---

## Side-by-Side Comparison

| System Component | Design Document | Current Implementation | Match? |
|------------------|-----------------|------------------------|--------|
| **Class Talents** | 10 rows, 9 choices | Fixed progression, 0 choices | ❌ NO |
| **SubclassSpec Talents** | 10 rows, 9 choices | Fixed progression, 0 choices | ❌ NO |
| **SubclassBase Talents** | Bucket pool, ~18 choices | Fixed progression, 0 choices | ❌ NO |
| **Specialization** | Key + Capstone + 3 nodes + passives | Key at L13 + 3 nodes + capstone | ⚠️ PARTIAL |
| **Feats** | Not mentioned | 5 feat choices (L4/8/12/16/20) | ➕ EXTRA |
| **Total Choices** | ~48 choices | 9 choices | ❌ NO |

---

## Detailed Analysis

### ❌ **Missing: Class Talents System (10 rows)**

**Design Intention**:
```
Level 1: Get ALL from Row 1 (e.g., Charge + Heroic Strike)
Level 3: Pick 1 from Row 2 (e.g., Battle Shout OR Intimidating Shout OR Execute)
Level 5: Pick 1 from Row 3 (e.g., Defensive Stance OR Rallying Cry OR Hamstring)
...and so on
```

**Current Reality**:
```
Level 1: Charge + Heroic Strike (automatic, no choice)
Level 2: Battle Shout (automatic, no choice)
Level 3: Execute (automatic, no choice)
Level 5: Extra Attack (automatic, no choice)
...all abilities granted automatically
```

**What's Missing**:
- No player choice between different abilities
- All class abilities are granted automatically at fixed levels
- No concept of "rows" of talents to choose from

---

### ❌ **Missing: SubclassSpec Talents System (10 rows)**

**Design Intention**:
```
Level 1: Get Weapon Mastery + ALL from Row 1 (e.g., Mortal Strike)
Level 3: Pick 1 from Row 2 (e.g., Overpower OR Colossus Smash OR Slam)
Level 5: Pick 1 from Row 3 (e.g., Tactical Mastery OR Sweeping Strikes OR Warbreaker)
...and so on
```

**Current Reality**:
```
Level 1: Weapon Mastery (automatic)
Level 3: Mortal Strike + Overpower (automatic, no choice)
Level 5: Tactical Mastery (automatic, no choice)
Level 7: Colossus Smash (automatic, no choice)
...all subclass abilities granted automatically
```

**What's Missing**:
- No player choice between different Arms abilities
- All Arms-specific abilities are granted automatically
- No concept of "rows" of subclass talents

---

### ❌ **Missing: SubclassBase Talents System (Bucket)**

**Design Intention**:
```
Level 1: Pick 1 Offense + 1 Utility from pool
  Offense Pool: Execute, Mortal Strike, Slam, Rend, etc.
  Utility Pool: Hamstring, Defensive Stance, Spell Reflection, etc.

Levels 2-20: Pick 1 ability per level from combined pool until exhausted
  Combined Pool: All baseline Arms abilities available as choices
```

**Current Reality**:
- This system doesn't exist at all
- All abilities are granted automatically at fixed levels
- No concept of "offense vs utility" categorization
- No ability pool to choose from

**What's Missing**:
- Entire ability selection system
- Player agency in building their character's toolkit
- Customization of ability loadout

---

### ⚠️ **Partial: Specialization System**

**Design Intention**:
```
Level 13: 
  - Choose Colossus OR Slayer (KEY TALENT)
  - Automatically grant CAPSTONE
  - Automatically grant PASSIVE #1

Level 15:
  - Pick 1 of 3 from Choice Node 1
  - Automatically grant PASSIVE #2

Level 17:
  - Pick 1 of 3 from Choice Node 2
  - Automatically grant PASSIVE #3

Level 19:
  - Pick 1 of 3 from Choice Node 3
  - Automatically grant PASSIVE #4

Level 20:
  - Automatically grant PASSIVE #5

Total: 8 passives (1 per level 13-20) + 3 choice nodes + 1 capstone
```

**Current Reality**:
```
Level 13: 
  - Choose Colossus OR Slayer (KEY TALENT) ✅
  - Keystone passive granted ✅

Level 15:
  - Pick 1 of 3 passives ✅

Level 17:
  - Pick 1 of 3 passives ✅

Level 19:
  - Pick 1 of 3 passives ✅

Level 20:
  - Capstone status granted automatically ✅

Total: 1 keystone + 3 chosen passives + 1 capstone = 5 elements
```

**What's Missing**:
- Design calls for capstone at L13, implementation at L20
- Design calls for 8 passives (1 per level 13-20), implementation has 5 total
- No "passive pool" to draw from each level

**What Matches**:
- Hero talent choice at L13 ✅
- 3 choice node tiers at L15/17/19 ✅
- Automatic capstone grant ✅

---

## Why This Matters

### **Design Philosophy Mismatch**

**Design Document Vision**:
- **WoW-style talent trees** with meaningful choices at almost every level
- Players customize their character by selecting from pools of abilities
- Similar characters can have very different ability loadouts
- High replay value through different build paths

**Current Implementation**:
- **D&D 5e-style fixed progression** with minimal customization
- Players get the same abilities at the same levels every time
- Only customization is feats (standard D&D) and hero talents (unique to mod)
- Lower complexity, easier to balance, but less player agency

### **Player Experience Impact**

**With Design Document System**:
- ✅ High customization - every Arms Warrior can be different
- ✅ Many build paths - Colossus tank vs Slayer burst vs hybrid builds
- ✅ Replayability - try different talent combinations
- ❌ Complex - 48 choices might overwhelm players
- ❌ Balance nightmare - combinatorial explosion of talent synergies

**With Current Implementation**:
- ✅ Simple & clear - everyone gets core abilities automatically
- ✅ Easier to balance - fewer variables to test
- ✅ Still has meaningful choices (hero talents + feats)
- ❌ Less customization - all Arms Warriors similar until L13
- ❌ Lower replay value - less reason to try multiple builds

---

## Recommendations

### **Option 1: Keep Current System (Recommended for v1.0)**
**Rationale**: 
- Current system works and is fully implemented
- Easier for players to understand (familiar D&D progression)
- Much easier to balance and test
- Hero talent system already provides meaningful customization
- Can always add more choice in v2.0

**Action Items**:
- ✅ Update design document to match implementation
- ✅ Document the "simplified BG3 progression" philosophy
- ✅ Rename `Talets mechanics.md` to `Talets mechanics (WoW Vision - Not Implemented).md`
- ✅ Create new `BG3_Progression_System.md` documenting actual implementation

### **Option 2: Implement Design Document (Major Overhaul)**
**Rationale**:
- Provides the WoW-style experience you originally envisioned
- Much higher customization and replayability
- Closer to source material (WoW)

**Action Items**:
- ❌ Redesign entire progression system (200+ hours of work)
- ❌ Create talent selection UI (requires Script Extender expertise)
- ❌ Rebalance all 46+ abilities for combinatorial interactions
- ❌ Test thousands of talent combinations
- ❌ Document all talent trees comprehensively
- ❌ **NOT RECOMMENDED for v1.0** - save for major expansion

### **Option 3: Hybrid Approach (Compromise)**
**Rationale**:
- Add some choice without full overhaul
- Implement parts of design gradually

**Action Items**:
- ⚠️ Add 1-2 choice nodes to base progression (e.g., L7: Intimidating Shout OR Rallying Cry)
- ⚠️ Add 1-2 choice nodes to Arms progression (e.g., L9: Sweeping Strikes OR Warbreaker)
- ⚠️ Keep hero talents as-is (already good)
- ⚠️ **Medium effort** - could be done for v1.1

---

## Current Status Assessment

### **What's Actually Shipped (v1.0.1.0)**:
✅ **Simplified D&D-style progression** with:
- 13 core Warrior abilities (automatic)
- 5 Arms-specific abilities (automatic)
- 5 feat choices (L4/8/12/16/20)
- 1 hero talent choice at L13 (Colossus vs Slayer)
- 3 hero talent tier choices (L15/17/19)
- 1 automatic hero talent capstone (L20)

**Total customization**: 9 meaningful choices across 20 levels

### **What Was Originally Designed**:
❌ **Complex WoW-style talent system** with:
- 10 rows of Class Talents (9 choices)
- 10 rows of SubclassSpec Talents (9 choices)
- Bucket pool of SubclassBase Talents (~18 choices)
- Full Specialization system (~12 choices)

**Total customization**: ~48 choices across 20 levels

---

## Conclusion

**The design document describes a system that was NEVER implemented.**

The current implementation is:
- ✅ Fully functional
- ✅ Well-balanced
- ✅ Easy for players to understand
- ✅ Has meaningful hero talent choices
- ❌ NOT what the design document specifies
- ❌ Much simpler than originally planned

**Recommendation**: Update documentation to match implementation, not the other way around. Ship v1.0 as-is, consider talent trees for v2.0 if there's demand.

---

## Action Items

1. ✅ **Update `Talets mechanics.md`** - Rename to indicate this is aspirational/future vision
2. ✅ **Create `ACTUAL_PROGRESSION_SYSTEM.md`** - Document what's really implemented
3. ✅ **Update `Warrior_Class_Blueprint.md`** - Ensure it matches reality
4. ✅ **Update `ARMS_WARRIOR_FULL_PROGRESSION.md`** - Add note about design vs reality
5. ⏸️ **Decide**: Keep simple system (v1.0) or plan talent overhaul (v2.0)

---

**Date Created**: October 17, 2025  
**Analysis By**: AI Agent (following AI Agent Protocol)  
**Status**: 🔴 **CRITICAL DOCUMENTATION DRIFT DETECTED**
