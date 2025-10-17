# Baseline Abilities - Cooldown Verification Report
**Date**: October 16, 2025  
**Purpose**: Verify all baseline warrior ability cooldowns against implementation

---

## COOLDOWN DISCREPANCIES FOUND ⚠️

### 1. Heroic Leap - WRONG COOLDOWN ❌
**WoW Source**: 45 seconds → Should be **Long Rest**  
**Implementation**: `data "Cooldown" "OncePerShortRest"` ❌  
**Location**: Spell_Jump.txt line ~27  
**Fix Needed**: Change to `"OncePerLongRest"`

---

### 2. Battle Shout - WRONG COOLDOWN ❌
**WoW Source**: 60 seconds, long duration → Should be **No cooldown** (duration gates it)  
**Implementation**: `data "Cooldown" "OncePerShortRest"` ❌  
**Location**: Spell_Shout.txt line ~47  
**Fix Needed**: Remove cooldown (duration is 5 turns, Bonus Action cost sufficient)

---

### 3. Rallying Cry - WRONG COOLDOWN ❌
**WoW Source**: 3 minutes → Should be **No cooldown** (Action cost sufficient)  
**Implementation**: `data "Cooldown" "OncePerShortRest"` ❌  
**Location**: Spell_Shout.txt line ~81  
**Fix Needed**: Remove cooldown (Action cost is significant)

---

### 4. Intimidating Shout - WRONG COOLDOWN ❌
**WoW Source**: 90 seconds → Should be **No cooldown** (Rage cost + Action gates it)  
**Implementation**: `data "Cooldown" "OncePerShortRest"` ❌  
**Location**: Spell_Shout.txt line ~114  
**Fix Needed**: Remove cooldown (costs 10 Rage + Action, sufficient gating)

---

## CORRECT COOLDOWNS ✅

### Heroic Throw ✅
**Implementation**: `data "Cooldown" "OncePerTurn"` ✅  
**WoW**: 6 seconds → Once per Turn (correct)

### Storm Bolt ✅
**Implementation**: `data "Cooldown" "OncePerShortRest"` ✅  
**WoW**: 30 seconds → Short Rest (correct)

---

## SUMMARY

**Total Cooldown Issues**: 4 out of 19 baseline abilities (21%)

| Ability | Current | Should Be | Reason |
|---------|---------|-----------|--------|
| **Heroic Leap** | Short Rest | **Long Rest** | WoW 45s = major mobility CD |
| **Battle Shout** | Short Rest | **None** | 5-turn duration + Bonus Action sufficient |
| **Rallying Cry** | Short Rest | **None** | Action cost significant enough |
| **Intimidating Shout** | Short Rest | **None** | 10 Rage + Action sufficient |

---

## RECOMMENDED FIXES

### Priority: HIGH - These affect gameplay balance

#### Fix 1: Heroic Leap
```diff
File: Spell_Jump.txt (line ~27)

- data "Cooldown" "OncePerShortRest"
+ data "Cooldown" "OncePerLongRest"
```

**Reason**: 45-second cooldown in WoW = major mobility cooldown, should be Long Rest not Short Rest

#### Fix 2: Battle Shout
```diff
File: Spell_Shout.txt (line ~47)

- data "Cooldown" "OncePerShortRest"
+ // No cooldown - duration and Bonus Action cost sufficient
```

**Reason**: 
- Duration: 5 turns (long enough that you'd rarely recast)
- Cost: Bonus Action (opportunity cost)
- WoW: 60s CD but 1 hour duration, effectively no CD in practice

#### Fix 3: Rallying Cry  
```diff
File: Spell_Shout.txt (line ~81)

- data "Cooldown" "OncePerShortRest"
+ // No cooldown - Action cost sufficient
```

**Reason**:
- Cost: Bonus Action (significant in combat)
- Effect: 2d8+level temp HP (good but not OP)
- Can't spam because Bonus Action is valuable
- WoW: 3 min CD but in BG3 Action economy prevents abuse

#### Fix 4: Intimidating Shout
```diff
File: Spell_Shout.txt (line ~114)

- data "Cooldown" "OncePerShortRest"
+ // No cooldown - Rage cost and Action sufficient
```

**Reason**:
- Cost: 10 Rage + Action (double gating)
- WIS save: Can be resisted
- Fear breaks on damage: Easy to break
- WoW: 90s CD but BG3 has Rage cost which didn't exist in WoW

---

## VALIDATION NOTES

**Why these had Short Rest cooldowns?**
- Likely conservative balancing during initial implementation
- WoW cooldowns were added without considering BG3 resource systems
- Rage economy and Action economy weren't factored into cooldown decisions

**Why remove cooldowns now?**
- **Battle Shout**: 5-turn duration means it won't stack, Bonus Action prevents spam
- **Rallying Cry**: Bonus Action cost is significant, temp HP doesn't stack
- **Intimidating Shout**: 10 Rage + Action + easy to break = already heavily gated
- **Heroic Leap**: Keep cooldown but make it Long Rest (major mobility tool)

**Balance Check**:
- Warriors need resources for rotation (Rage system working well)
- Cooldowns should be for major abilities, not everything
- Let resource costs do the gating for most abilities
- Reserve cooldowns for true "ultimate" moments

---

## NEXT STEPS

1. ✅ Document discrepancies (THIS FILE)
2. ⏳ Implement fixes in spell files
3. ⏳ Update validation report
4. ⏳ Test in-game to verify balance
5. ⏳ Update ability design framework with findings

---

**Validation Status**: Issues Found - Ready for Fixes
