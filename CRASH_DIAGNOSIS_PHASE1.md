# Crash Diagnosis - Phase 1 Test Build

**Date:** October 17, 2025  
**Build:** BG3Wow_v2.0.0_ARMS_PHASE1_TEST.pak  
**Status:** ❌ Game crashes on launch

---

## Validation Results

### ✅ XML Files (All Valid)
- ✅ meta.lsx - Valid XML
- ✅ ClassDescriptions.lsx - Valid XML
- ✅ Progressions.lsx - Valid XML
- ✅ ActionResourceDefinitions.lsx - Valid XML
- ✅ English.loca.xml - Valid XML (191 content nodes)

### ✅ Stat File Syntax
- ✅ No unclosed quotes
- ✅ No duplicate entry names (135 unique entries)
- ✅ All 8 localization handles exist (h8a7f2b01-08)

---

## 🔍 Potential Issues Found

### 1. ⚠️ RemoveStatus Syntax (HIGH PRIORITY)

**File:** `Spell_Target.txt` line 1108  
**Entry:** Target_WAR_Overpower

**Current Code:**
```
data "SpellSuccess" "DealDamage(2d10+StrengthModifier,MainMeleeWeaponDamageType,Magical);RemoveStatus(WAR_OVERPOWER_PROC)"
```

**Problem:** RemoveStatus might need explicit target specification

**Possible Fix:**
```
data "SpellSuccess" "DealDamage(2d10+StrengthModifier,MainMeleeWeaponDamageType,Magical);RemoveStatus(SELF,WAR_OVERPOWER_PROC)"
```

OR rely on the status's own RemoveEvents:
```
data "SpellSuccess" "DealDamage(2d10+StrengthModifier,MainMeleeWeaponDamageType,Magical)"
```
(Status already has `RemoveEvents: OnSpellCast` + `RemoveConditions: HasStringInSpellRoll('Target_WAR_Overpower')`)

### 2. ⚠️ Status RemoveConditions Complexity

**File:** `Status_BOOST.txt` line 809  
**Entry:** WAR_OVERPOWER_PROC

**Current Code:**
```
data "RemoveEvents" "OnSpellCast"
data "RemoveConditions" "HasStringInSpellRoll('Target_WAR_Overpower')"
```

**Concern:** The combination of RemoveEvents + RemoveConditions might be too complex. BG3 might not handle conditional removal well on SpellCast events.

**Possible Fix:**
- Option A: Remove the condition, just use `OnSpellCast` (removes on ANY spell cast)
- Option B: Use `OnStatusApplied` with a self-targeting status application
- Option C: Remove status manually in SpellSuccess functor

### 3. ⚠️ OnApplyFunctors in Rend Bleed

**File:** `Status_BOOST.txt` line 833  
**Entry:** WAR_REND_BLEED

**Current Code:**
```
data "OnApplyFunctors" "ApplyStatus(SELF,SG_Debuff,100,-1)"
```

**Concern:** `SG_Debuff` is a status group, not a status. This might cause issues.

**Possible Fix:**
- Remove this line entirely (not critical for DoT functionality)
- Or use a real debuff status instead of status group

---

## 🛠️ Recommended Fixes (Priority Order)

### Fix #1: Simplify Overpower Status Removal
**Why:** Most likely crash culprit - complex conditional removal

**Change in Spell_Target.txt (line 1108):**
```
// OLD:
data "SpellSuccess" "DealDamage(2d10+StrengthModifier,MainMeleeWeaponDamageType,Magical);RemoveStatus(WAR_OVERPOWER_PROC)"

// NEW:
data "SpellSuccess" "DealDamage(2d10+StrengthModifier,MainMeleeWeaponDamageType,Magical);RemoveStatus(SELF,WAR_OVERPOWER_PROC)"
```

**Change in Status_BOOST.txt (line 809-810):**
```
// OLD:
data "RemoveEvents" "OnSpellCast"
data "RemoveConditions" "HasStringInSpellRoll('Target_WAR_Overpower')"

// NEW (simpler):
data "RemoveEvents" "OnSpellCast"
// Remove RemoveConditions entirely - let SpellSuccess handle removal
```

### Fix #2: Remove SG_Debuff Application
**Why:** Status groups shouldn't be applied as statuses

**Change in Status_BOOST.txt (line 833):**
```
// DELETE THIS LINE:
data "OnApplyFunctors" "ApplyStatus(SELF,SG_Debuff,100,-1)"
```

### Fix #3: Verify StatusPropertyFlags
**Why:** `DisableCombatlog` might not be a valid flag

**Check in Status_BOOST.txt (lines 808, 831):**
```
// If crashes continue, try removing this:
data "StatusPropertyFlags" "DisableCombatlog"
```

---

## 📋 Testing Protocol After Fixes

1. **Apply fixes** (3 changes above)
2. **Re-package** using Divine.exe
3. **Copy to Mods folder** (overwrite existing)
4. **Launch game** (from Mod Manager)
5. **Check crash point:**
   - Crashes on launch? → XML/package structure issue
   - Crashes on character creation? → ClassDescriptions issue
   - Crashes on selecting Warrior? → Progressions issue
   - Crashes on selecting Arms? → Subclass definition issue
   - Crashes on talent selection? → Passive definition issue
   - Crashes on ability use? → Spell/Status functor issue

---

## 🔍 Additional Diagnostics

### Check Script Extender Logs
**Location:** `%LOCALAPPDATA%\Larian Studios\Baldur's Gate 3\ScriptExtender\Logs\`

**Look for:**
- `[ERROR]` lines related to BG3Wow
- Status application failures
- Functor errors
- Missing reference warnings

### Check Game Logs
**Location:** `%LOCALAPPDATA%\Larian Studios\Baldur's Gate 3\PlayerProfiles\*/Crashes/`

**Look for:**
- Crash dumps with stack traces
- References to mod UUID (78fe4967-4e62-5491-d981-dd781acca4d7)
- Status/spell/passive names

### Disable Conflicting Mods
Check for other Warrior class mods in Mods folder that might conflict.

---

## 🎯 Most Likely Cause

Based on previous crash history and current code review:

**#1 Suspect:** `RemoveStatus(WAR_OVERPOWER_PROC)` without SELF target  
**#2 Suspect:** `RemoveConditions` with `HasStringInSpellRoll` on status  
**#3 Suspect:** `ApplyStatus(SELF,SG_Debuff,100,-1)` applying status group as status

**Recommendation:** Apply all 3 fixes and re-test. If crash persists, check SE logs for specific error messages.

---

## ✅ Next Steps

1. **Apply fixes below**
2. Re-package mod
3. Re-install and test
4. Report: Crash point (launch/char creation/ability use) OR success!

---

**Last Updated:** October 17, 2025  
**Status:** Awaiting fixes and re-test
