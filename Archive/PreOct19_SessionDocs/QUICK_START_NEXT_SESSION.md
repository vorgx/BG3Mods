# 🚀 QUICK START - Next Session

**Last Updated**: October 18, 2025

---

## 📌 ONE-LINE SUMMARY

**FILES 1-2 complete (meta.lsx + ClassDescriptions.lsx) with passing tests. Next: FILE 3 (ActionResourceDefinitions.lsx - Rage system).**

---

## ✅ CURRENT STATUS

- **Completed**: FILES 1-2 (13% done)
- **Test Coverage**: 2/2 passing (100%)
- **Next File**: FILE 3 - ActionResourceDefinitions.lsx
- **Estimated Time**: ~15 minutes (LOW complexity)

---

## 🎯 YOUR FIRST ACTION

1. **Read**: `HANDOVER_FILE_BY_FILE_START.md` (full context)
2. **Verify**: FILES 1-2 complete, tests passing
3. **Begin FILE 3**:
   - Compare Warlock Soul Shards vs Warrior Rage
   - Analyze `Data/Public/Warlock_WoW_bdb3fa73-401b-4979-f02e-485422dd8d9c/ActionResourceDefinitions/ActionResourceDefinitions.lsx`
   - Present changes to user
   - Get approval
   - Transform
   - Create `Test-ActionResourceDefinitions.ps1`
   - Run all tests (should be 3/3 passing)

---

## 📋 KNOWN ISSUES TO FIX LATER

1. **Dummy SpellList UUID** (FILE 2) - Using Warlock's `32879c22-4858-48ef-8f8d-22e6d395b396`, will replace in FILE 12
2. **Naming Mismatch** (FILE 13) - PassiveLists has "WoWWarrior_*" but should be "WAR_*"
3. **Missing Spells** (FILES 4-10, 12) - Replace 20 Warlock spells with Warrior spells
4. **L13-L20 Extension** (FILE 11) - Extend Warlock L1-12 to Warrior L1-20

---

## 🎓 KEY LEARNINGS (Apply to FILE 3+)

### Test Creation
- **ALWAYS** create test for each file before moving to next
- Strip XML comments: `$Content -replace '(?s)<!--.*?-->', ''`
- No Unicode in PowerShell: Use `[PASS]`/`[FAIL]` not ✅❌
- Show context before validation: `Write-Info "Value: $x"` then `Write-Pass "Valid"`

### PowerShell XML
- Handle both attribute AND child node patterns
- Exit code 0 for pass, 1 for fail
- Add tests to `Test-AllFiles.ps1` master runner

---

## 📁 KEY FILES

- **Handover**: `HANDOVER_FILE_BY_FILE_START.md`
- **Test Guide**: `Documentation/08_TransformationTemplates/Tests/README.md`
- **Test Examples**: `Test-MetaLsx.ps1`, `Test-ClassDescriptions.ps1`
- **Copilot Rules**: `.github/copilot-instructions.md` (Section 9: Test Creation)
- **Session Reports**: `Documentation/05_SessionReports/FILE_02_TESTS_CREATED_AND_PASSING.md`

---

## ✅ VERIFICATION

**Run this to confirm status**:
```powershell
.\Documentation\08_TransformationTemplates\Tests\Test-AllFiles.ps1 -ModPath "Data"
```

**Expected output**:
```
Total Tests:  2
Passed:       2
Failed:       0
✅ ALL TESTS PASSED!
```

---

## 🎯 SUCCESS CRITERIA FOR FILE 3

- [ ] Warlock Soul Shards analyzed
- [ ] Warrior Rage system designed
- [ ] Changes presented to user
- [ ] User approval received
- [ ] File transformed
- [ ] `Test-ActionResourceDefinitions.ps1` created
- [ ] Test added to `Test-AllFiles.ps1`
- [ ] All 3 tests passing (FILE 1, 2, 3)
- [ ] Template documentation created: `FILE_03_ActionResourceDefinitions.lsx_TEMPLATE.md`
- [ ] Session report created

---

**Ready to begin? Read `HANDOVER_FILE_BY_FILE_START.md` for full details!**
