# Session Handover: File-by-File Transformation In Progress

**📌 START HERE**: FILES 1-2 complete (meta.lsx + ClassDescriptions.lsx) with passing tests. Next: FILE 3 (ActionResourceDefinitions.lsx - Rage system).

**Date**: October 18, 2025  
**Status**: ✅ FILES 1-2 COMPLETE + TESTS PASSING | 📋 READY FOR FILE 3  
**Next Action**: Begin ActionResourceDefinitions.lsx transformation  
**Test Status**: ✅ All validation tests passing (FILE 1 & FILE 2)

---

## 🎯 Current Situation

### What We're Doing
After 32+ failed crash-fixing attempts, we've adopted a **NEW STRATEGY**: File-by-file transformation using the proven WoWWarlock mod as a template.

### Where We Are Now
✅ **Setup Complete**:
- Data folder cleaned and fresh WoWWarlock template copied
- Warrior backups preserved at:
  - `Tests\WARRIOR_BACKUP_BEFORE_TEMPLATE_20251018_183829` (full mod backup)
  - `Tests\WARRIOR_STATS_BACKUP_20251018_183829` (7 stat files, 135 entries)
- All preparation work done
- Ready to begin File 1: meta.lsx

### What We're NOT Doing Anymore
❌ Mass transformations (too error-prone)  
❌ Automated scripts (we need control)  
❌ Guesswork (we analyze before changing)

---

## 📋 The Plan: 15 Critical Files (Priority Order)

**See Full Plan**: `Reports\FILE_BY_FILE_TRANSFORMATION_PLAN.md`

### File Transformation Order:

1. **meta.lsx** ✅ **COMPLETE**
   - Mod UUID, name, version
   - Completed: January 2025
   - Template: `Transformation_Templates/FILE_01_meta.lsx_TEMPLATE.md`

2. **ClassDescriptions.lsx** ✅ **COMPLETE**
   - Class definition (HP, abilities, subclasses)
   - 2 nodes transformed, 2 nodes commented for future
   - Completed: January 2025
   - Template: `Transformation_Templates/FILE_02_ClassDescriptions.lsx_TEMPLATE.md`

3. **ActionResourceDefinitions.lsx** ⬅️ **START HERE NEXT**
   - Rage resource system
   - ~15 min, LOW complexity

4-10. **Stats/Generated/Data/*.txt** (7 files)
   - Passive.txt (36 entries)
   - Spell_Target.txt (30 entries)
   - Spell_Zone.txt (6 entries)
   - Spell_Shout.txt (3 entries)
   - Spell_Jump.txt (2 entries)
   - Spell_Projectile.txt (2 entries)
   - Status_BOOST.txt (56 entries)
   - ~2 hours, MEDIUM complexity

11. **Progressions.lsx** ⚠️
    - L1-20 progression for base + 3 subclasses
    - ~3 hours, **HIGH** complexity
    - Most critical and complex file

12. **Lists/SpellLists.lsx**
    - Spell grant lists (53 entries to transform)
    - ~45 min, MEDIUM complexity

13. **Lists/PassiveLists.lsx**
    - Passive grant lists (52 entries to transform)
    - **CRITICAL FIX**: Has "WoWWarrior_*" prefixes but our Passive.txt has "WAR_*"
    - ~45 min, MEDIUM complexity

14. **CharacterCreationPresets.lsx**
    - Starting equipment, character creation
    - ~15 min, LOW complexity

15. **Localization/English/English.loca.xml**
    - All user-facing text
    - ~30 min, LOW complexity

**Total Estimated Time**: ~8 hours (spread across sessions)

---

## 🔄 Workflow (Per File)

### Step 1: ANALYZE
- Read Warlock version from `Data/` folder
- Read Warrior version from backup (if exists)
- Compare side-by-side
- Document all differences
- Identify what needs to change

### Step 2: REVIEW & APPROVE
- Present analysis to user
- Show proposed changes clearly
- User reviews and approves
- Clarify any questions

### Step 3: TRANSFORM
- Apply approved changes
- Verify XML syntax
- Check references
- Create checkpoint

### Step 4: VERIFY & NEXT
- Validate file
- Document changes
- Move to next file

**CRITICAL**: Never skip to next file without user approval!

---

## 🗂️ File Locations

### Current Working Template (Warlock)
```
Data/
├── Mods/
│   └── Warlock_WoW_bdb3fa73-401b-4979-f02e-485422dd8d9c/
│       └── meta.lsx  ← FILE 1 IS HERE
└── Public/
    └── Warlock_WoW_bdb3fa73-401b-4979-f02e-485422dd8d9c/
        ├── ClassDescriptions/ClassDescriptions.lsx
        ├── Progressions/Progressions.lsx
        ├── ActionResourceDefinitions/ActionResourceDefinitions.lsx
        ├── Stats/Generated/Data/*.txt
        ├── Lists/SpellLists.lsx
        ├── Lists/PassiveLists.lsx
        ├── CharacterCreationPresets/CharacterCreationPresets.lsx
        └── Localization/English/English.loca.xml
```

### Warrior Backups (Reference)
```
Tests/
├── WARRIOR_BACKUP_BEFORE_TEMPLATE_20251018_183829/
│   └── (Complete mod backup)
└── WARRIOR_STATS_BACKUP_20251018_183829/
    ├── Passive.txt
    ├── Spell_Target.txt
    ├── Spell_Zone.txt
    ├── Spell_Shout.txt
    ├── Spell_Jump.txt
    ├── Spell_Projectile.txt
    └── Status_BOOST.txt
```

---

## 🔑 Critical UUIDs

**Warlock Mod UUID** (in template): `bdb3fa73-401b-4979-f02e-485422dd8d9c`  
**Warrior Mod UUID** (ours): `78fe4967-4e62-5491-d981-dd781acca4d7`

**MUST REPLACE**:
- All folder names
- All UUID references in files
- Meta.lsx UUID attribute

---

## 📊 Warrior Mod Stats (135 Entries)

**Abilities by Type**:
- Passives: 36 (33 hero talents L13-L20 + 3 Arms talents)
- Single-target: 30 (Execute, Shield Slam, Mortal Strike, etc.)
- AoE zones: 6 (Whirlwind, Shockwave, Thunder Clap, etc.)
- Shouts: 3 (Battle Shout, Rallying Cry, Intimidating Shout)
- Gap closers: 2 (Heroic Leap, Intervene)
- Ranged: 2 (Heroic Throw, Storm Bolt)
- Status effects: 56 (buffs, debuffs, DoTs)

**Naming Convention**: `WAR_*` prefix (e.g., `WAR_Charge`, `WAR_MountainThane_Keystone`)

---

## ⚠️ Critical Issues Discovered & Fixes Needed

### Issue 1: Dummy SpellList UUID (FILE 2 Discovery)
**Problem**: ClassDescriptions.lsx uses Warlock's dummy SpellList UUID `32879c22-4858-48ef-8f8d-22e6d395b396`  
**Impact**: This is a placeholder - Warrior needs actual SpellList when FILE 12 is implemented  
**When**: Will fix in FILE 12 (Lists/SpellLists.lsx)  
**How**: Create real Warrior SpellList UUID and update ClassDescriptions.lsx  
**Current Status**: Tests accept dummy UUID (matches Warlock template pattern), non-critical

### Issue 2: Naming Mismatch
**Problem**: PassiveLists.lsx has "WoWWarrior_*" but Passive.txt has "WAR_*"  
**When**: Will fix in FILE 13 (PassiveLists.lsx)  
**How**: Replace all passive references with correct WAR_* names

### Issue 3: Missing Spell References
**Problem**: Warlock mod references 20 spells we don't have  
**When**: Will fix in FILES 4-10 (Stats files) and FILE 12 (SpellLists)  
**How**: Replace Warlock spells with Warrior spells

### Issue 4: L13-L20 Extension
**Problem**: Warlock only goes to L12, we need L1-L20  
**When**: Will fix in FILE 11 (Progressions.lsx)  
**How**: Extend progressions with hero talents L13-L20

---

## 🎓 Lessons from Autopsy (Apply to Stat Files)

From analyzing working WoWWarlock mod, we learned stat entries should have:

**Visual Effects**:
- `data "PrepareEffect"` - Casting animation start
- `data "CastEffect"` - Spell launch visual
- `data "TargetEffect"` - Impact on target

**Tooltips**:
- `data "TooltipDamageList"` - Damage display
- `data "TooltipAttackSave"` - Save DC display

**Animations**:
- `data "SpellAnimation"` - Character animation

**Flags**:
- `data "SpellFlags"` - Spell behavior flags
- `data "VerbalIntent"` - AI behavior hints

Our stat files may be missing some of these fields.

---

## 🚀 Session Status Summary

### ✅ COMPLETED (FILES 1-2)

**FILE 1: meta.lsx** (October 18, 2025)
- ✅ Warlock → Warrior UUID transformation complete
- ✅ Folder references updated
- ✅ Dependencies verified (13 total)
- ✅ Version handling fixed (child node pattern)
- ✅ Test created and passing: `Test-MetaLsx.ps1`
- 📄 Template: `Transformation_Templates/FILE_01_meta.lsx_TEMPLATE.md`

**FILE 2: ClassDescriptions.lsx** (October 18, 2025)
- ✅ Base class (WoWWarrior) transformed
- ✅ Subclass 1 (ArmsWarrior) transformed
- ✅ Subclass 2 (FuryWarrior) transformed & commented (ready to activate)
- ✅ Subclass 3 (ProtectionWarrior) transformed & commented (ready to activate)
- ✅ All HP values, abilities, equipment corrected (Warrior d10, Strength, Barbarian)
- ✅ XML comments properly closed
- ✅ Test created and passing: `Test-ClassDescriptions.ps1`
- 📄 Template: `Transformation_Templates/FILE_02_ClassDescriptions.lsx_TEMPLATE.md`

**Test Suite Created**:
- ✅ `Transformation_Templates/Tests/README.md` - Test documentation
- ✅ `Test-MetaLsx.ps1` - FILE 1 validation (UUID, folders, dependencies, versions)
- ✅ `Test-ClassDescriptions.ps1` - FILE 2 validation (class attributes, HP, ParentGuid)
- ✅ `Test-AllFiles.ps1` - Master test runner
- ✅ **ALL TESTS PASSING** (2/2 files validated)

### 🎓 Key Lessons Learned from Testing

**PowerShell XML Parsing**:
- Multi-line XML comments must be properly closed with `-->`
- Use regex `(?s)<!--.*?-->` to strip comments before parsing (non-greedy, dotall mode)
- PowerShell `[xml]` type accelerator is strict - validate syntax carefully

**Version Checking**:
- Warlock template uses child node for PublishVersion: `<node id="PublishVersion"><attribute id="Version64".../></node>`
- NOT an attribute: `<attribute id="PublishVersion".../>`
- Tests must handle both patterns for template compatibility

**Test Design Patterns**:
- Color helpers: `Write-Pass` (green), `Write-Fail` (red), `Write-Warn` (yellow), `Write-Info` (cyan)
- Exit codes: 0 for pass, 1 for fail
- Strip comments before validation to test only active nodes
- Count comment blocks to verify regex worked
- Show informative context (UUID values, HP values, node counts)

**Critical File Issues Found**:
- Missing closing `-->` on ProtectionWarrior comment block (line 125)
- Fixed immediately - tests now pass

---

## 🚀 Next Immediate Steps

### When New Chat Starts:

1. **Acknowledge this handover**: Confirm you've read and understood the situation

2. **Begin FILE 3 Analysis** (ActionResourceDefinitions.lsx):
   ```
   Read: Data/Public/Warlock_WoW_bdb3fa73-401b-4979-f02e-485422dd8d9c/ActionResourceDefinitions/ActionResourceDefinitions.lsx
   Compare: Warlock Soul Shards vs Warrior Rage system
   Present analysis
   ```

3. **Present Changes**:
   - Show exactly what needs to change
   - Explain why each change is necessary
   - List all modifications clearly

4. **Wait for Approval**: Don't change anything until user says "proceed" or "approved"

5. **Transform File**: Apply changes carefully

6. **Create Test**: Build `Test-ActionResourceDefinitions.ps1` following established pattern

7. **Verify**: Run test, ensure it passes, add to `Test-AllFiles.ps1`

8. **Move to FILES 4-10**: Repeat process for stat files

---

## 📝 Key Documents

**Main Plan**: `Reports\FILE_BY_FILE_TRANSFORMATION_PLAN.md` (full detailed plan)  
**Copilot Instructions**: `.github\copilot-instructions.md` (updated with lessons)  
**Warrior Mod Info**: See copilot instructions for full Warrior class structure  

**Previous Session Reports** (context if needed):
- `Reports\DELETED_WARLOCK_CONTENT_REFERENCE.md` - What we removed (Phase 2)
- `Reports\PHASE3_LISTS_STRATEGIC_DECISION.md` - Why we restarted
- `Reports\COMPLETE_HERO_TALENTS_ANALYSIS.md` - Warlock hero talents research

---

## ✅ Success Criteria

After all 15 files transformed:
- ✅ Mod packages without errors
- ✅ Class appears in character creation as "Warrior"
- ✅ No missing UUID references
- ✅ No crashes on character creation
- ✅ Abilities display correct names/descriptions
- ✅ Level 1-20 progression works
- ✅ 3 subclasses selectable (Arms full, Fury/Protection placeholders)
- ✅ Rage resource displays correctly (0-100)

---

## 💡 Remember

- **Patience**: One file at a time, no rushing
- **Verify**: Check each change before moving on
- **Ask**: If unsure, ask user before proceeding
- **Document**: Note what was changed and why
- **Test**: Create checkpoints after priority groups

---

## 🎯 Ready Status

✅ Data folder prepared  
✅ Warlock template in place  
✅ Warrior backups preserved  
✅ Plan documented  
✅ Next file identified: **meta.lsx**

**ACTION REQUIRED**: Begin FILE 1 transformation

---

**Good luck with the transformation! Stay methodical, one file at a time. You've got this! 🚀**
