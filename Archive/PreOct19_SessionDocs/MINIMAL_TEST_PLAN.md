# Minimal Test Plan - Isolate Crash Cause

**Date:** October 18, 2025  
**Status:** 🔴 Still crashing after fixes

---

## Problem

Game crashes on launch even after:
1. ✅ Fixed Progressions.lsx location (now in subdirectory)
2. ✅ Fixed RemoveStatus syntax
3. ✅ Removed conflicting WoWWarrior mod
4. ✅ Verified pak structure is correct
5. ✅ Verified localization is valid

---

## Hypothesis

The crash might be caused by something in our **stat files** that BG3 doesn't like, even though syntax is valid.

---

## Test Strategy

Create progressively minimal versions to isolate the problem:

### Test 1: Empty Stat Files (Baseline)
- Keep all XML files intact
- **Empty** all .txt stat files (but keep the files)
- This tests if XML structure alone causes crash

### Test 2: Only Base Spells (No New Abilities)
- Restore original stat files WITHOUT Overpower/Rend
- Tests if the new abilities cause the crash

### Test 3: Only Overpower
- Add back ONLY Overpower (spell + status + passive)
- Tests if Rend specifically causes issues

### Test 4: Only Rend
- Add back ONLY Rend (spell + status + passive)
- Tests if Overpower specifically causes issues

---

## Quick Test: Check for Syntax Issues Divine Might Have Missed

Let me check our stat files for common crash causes:

### Common BG3 Crash Causes in Stat Files:
1. **Invalid spell properties** (e.g., wrong SpellType)
2. **Malformed conditions** (e.g., wrong context object)
3. **Invalid status properties** (e.g., wrong StackType)
4. **Missing data lines** (e.g., no "type" line after "new entry")
5. **Invalid boost syntax**
6. **Circular references** (spell references status that references spell)

---

## Recommended Next Step

**Option A: Start from working example**
- Extract the WoWWarlock .pak
- Copy our UUID into their structure
- Replace their class data with ours gradually
- Find exactly where it breaks

**Option B: Minimal test**
- Remove Overpower and Rend entries entirely from stat files
- Re-package and test if base mod loads
- If it loads → problem is in our new abilities
- If it crashes → problem is in base mod structure

**Option C: Check logs more carefully**
- Look for Windows Event Viewer crash logs
- Check %temp% for BG3 crash dumps
- Enable more verbose logging

---

## My Recommendation

Let's try **Option B (Minimal Test)** first since it's fastest:

1. Comment out or remove Overpower/Rend from stat files
2. Re-package
3. Test if game launches
4. This tells us if the problem is:
   - In our new code (abilities) → Fix ability implementation
   - In base mod structure → Need to examine XML files more carefully

---

**Next Action:** Remove new abilities and test if base mod works
