# 🧪 Minimal Test Deployed

**Date:** October 18, 2025  
**Package:** BG3Wow_MINIMAL_TEST.pak  
**Status:** ⏳ Ready for testing

---

## What Was Removed

### Completely Removed from Stat Files:
1. ❌ **Target_WAR_Overpower** (Spell_Target.txt)
2. ❌ **Target_WAR_Rend** (Spell_Target.txt)
3. ❌ **WAR_OVERPOWER_PROC** (Status_BOOST.txt)
4. ❌ **WAR_REND_BLEED** (Status_BOOST.txt)
5. ❌ **WAR_ARMS_ROW1_OVERPOWER** (Passive.txt)
6. ❌ **WAR_ARMS_ROW1_REND** (Passive.txt)

### What Remains:
- ✅ All XML files (meta.lsx, ClassDescriptions.lsx, Progressions.lsx, etc.)
- ✅ All localization (English.loca.xml)
- ✅ All base class stat entries (Execute, Charge, Heroic Strike, etc.)
- ✅ ActionResourceDefinitions (Rage system)
- ✅ All other passives and abilities

---

## Test Instructions

1. **Disable** `BG3Wow_v2.0.0_ARMS_PHASE1_STRUCTURE_FIXED.pak` in Mod Manager
2. **Enable** `BG3Wow_MINIMAL_TEST.pak`
3. **Export** load order
4. **Launch** game

---

## Expected Results

### If Game Launches Successfully ✅
**Conclusion:** Problem is in our new abilities (Overpower/Rend implementation)

**Next Steps:**
- Add back ONLY Overpower entries
- Test again
- If crashes → Overpower has the bug
- If works → Add Rend and test
- If crashes → Rend has the bug

### If Game Still Crashes ❌
**Conclusion:** Problem is in base mod structure (not our new abilities)

**Next Steps:**
- Check existing spell entries for issues
- Verify Progressions.lsx content
- Check ClassDescriptions.lsx for malformed data
- Compare more carefully with WoWWarlock example

---

## Backup Info

**Original stat files backed up to:**  
`Tests\04_Tools\StatFiles_Backup_20251018_000807\`

**To restore:**
```powershell
Copy-Item "Tests\04_Tools\StatFiles_Backup_20251018_000807\*.txt" `
          -Destination "Data\Public\BG3Wow_78fe4967-4e62-5491-d981-dd781acca4d7\Stats\Generated\Data\" `
          -Force
```

---

## Report Back

**Does the game launch with the minimal test mod?**
- ✅ YES → Problem isolated to new abilities
- ❌ NO → Problem is in base structure

This will tell us exactly where to look next!

---

**Status:** ⏳ Awaiting test results
