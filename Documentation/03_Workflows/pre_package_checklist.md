# Pre-Package Checklist

**Purpose**: Step-by-step release workflow for packaging BG3Wow mod builds. Use this checklist before every `.pak` creation to ensure mod integrity and prevent common errors.

**Last Updated**: October 17, 2025  
**Mod Version**: v1.0.1.0 (✅ 100% Feature Complete)

---

## Quick Reference

**Critical Files**:
- `Data/Mods/.../meta.lsx` - Mod metadata, UUID, version
- `Data/Public/.../Progressions.lsx` - Level progression (1292 lines)
- `Data/Public/.../Stats/Generated/Data/*.txt` - Ability definitions (7 files)
- `Data/Public/.../Localization/English/English.loca.xml` - Localization handles

**Tools Required**:
- **LSLib ConverterApp.exe** (located in `LsLib/` folder)
- **BG3 Mod Manager** (for installation testing)
- **VS Code** (XML validation, file editing)
- **PowerShell** (validation scripts)

**Target Game Version**: BG3 Patch 8 (v4.8.0.10)  
**Package Version**: v18 (LSLib 1.20.3+)

---

## Phase 1: Pre-Validation (15-20 minutes)

### Step 1.1: Run Automated Validation Script ✅

```powershell
# Run from BG3Mods root
.\validate_mod_structure.ps1 -Verbose

# If errors found, fix before continuing
# If warnings only, review but may proceed
```

**What it checks**:
- ✅ UUID consistency (meta.lsx, folder names)
- ✅ XML syntax validation (Progressions.lsx, ClassDescriptions.lsx, meta.lsx)
- ✅ Localization handle format (h[8hex][2digit])
- ✅ Stat file format (new entry, type, data lines)
- ✅ Required file existence

**Expected Result**: "VALIDATION PASSED" with 0 errors

**If validation fails**:
- Fix errors shown in red `[FAIL]` output
- Warnings `[WARN]` are informational, not blocking
- Re-run script after fixes

---

### Step 1.2: Manual UUID Consistency Check ✅

**Critical**: The UUID `78fe4967-4e62-5491-d981-dd781acca4d7` MUST match across:

1. **Folder names** (with hyphens):
   - `Data/Mods/BG3Wow_78fe4967-4e62-5491-d981-dd781acca4d7/`
   - `Data/Public/BG3Wow_78fe4967-4e62-5491-d981-dd781acca4d7/`

2. **meta.lsx** (line 34):
   ```xml
   <attribute id="UUID" type="FixedString" value="78fe4967-4e62-5491-d981-dd781acca4d7"/>
   ```

3. **meta.lsx Folder attribute** (line 25):
   ```xml
   <attribute id="Folder" type="LSString" value="BG3Wow_78fe4967-4e62-5491-d981-dd781acca4d7"/>
   ```

**Verification Command**:
```powershell
# Search for UUID inconsistencies
Get-ChildItem -Recurse -Filter "*.lsx" | Select-String "78fe4967" | Select-Object Filename, Line, LineNumber
```

**Common Issue**: Underscore vs hyphen mismatch (use hyphens in UUID, underscore after "BG3Wow_")

---

### Step 1.3: Localization Handle Verification ✅

**File**: `Data/Public/.../Localization/English/English.loca.xml`

**Check for**:
1. **Handle format**: All handles must follow `h[8hex][2digit]` pattern
   - ✅ Valid: `h125abc01`, `h125abc02`, `h7f8e9d10`
   - ❌ Invalid: `h125abc1`, `hABCDEF`, `h125abc001`

2. **No duplicate contentuid values**:
   ```powershell
   # Find duplicates
   Select-String -Path "Data\Public\BG3Wow_78fe4967-4e62-5491-d981-dd781acca4d7\Localization\English\English.loca.xml" -Pattern 'contentuid="(h[^"]+)"' -AllMatches | 
       ForEach-Object { $_.Matches.Groups[1].Value } | 
       Group-Object | 
       Where-Object { $_.Count -gt 1 }
   ```

3. **All DisplayName/Description references in Spell_*.txt have corresponding handles**

**Expected Result**: No duplicates, all handles valid format

---

### Step 1.4: XML Syntax Validation ✅

**Files to validate**:
1. `Data/Mods/.../meta.lsx`
2. `Data/Public/.../ClassDescriptions/ClassDescriptions.lsx`
3. `Data/Public/.../Progressions.lsx` (most common error source)
4. `Data/Public/.../ActionResourceDefinitions/ActionResourceDefinitions.lsx`

**VS Code Method**:
- Open each file in VS Code
- Check for red error squiggles (XML syntax errors)
- Verify balanced `<node>` tags (opening/closing pairs)

**PowerShell Method**:
```powershell
# Validate XML syntax
$XmlPath = "Data\Public\BG3Wow_78fe4967-4e62-5491-d981-dd781acca4d7\Progressions.lsx"
try {
    [xml](Get-Content -Path $XmlPath -Raw)
    Write-Host "XML valid" -ForegroundColor Green
} catch {
    Write-Host "XML error: $_" -ForegroundColor Red
}
```

**Common Issues**:
- Orphaned `<attribute>` tags (outside `<node>`)
- Unclosed `<node>` tags (missing `</node>`)
- Special characters not escaped (use `&lt;` `&gt;` `&amp;`)

---

### Step 1.5: Spell_*.txt Format Validation ✅

**Files**: `Data/Public/.../Stats/Generated/Data/Spell_*.txt`

**Check for**:
1. **Entry structure**:
   ```
   new entry "EntryName"
   type "SpellData"
   data "key" "value"
   ```

2. **No missing quotes** in data lines
3. **UseCosts format**: `ActionPoint:1;Rage:20` (semicolon-separated)
4. **Cooldown syntax**: Use `OncePerTurn`, `OncePerShortRest`, `OncePerCombat` (NOT numeric values like `"1Turn"`)

**Verification**: Run `validate_mod_structure.ps1` (checks entry/type counts, malformed data lines)

---

## Phase 2: Cross-Reference Validation (10-15 minutes)

### Step 2.1: Ability Cross-Reference Check ✅

**Verify**: All spells referenced in `Progressions.lsx` exist in `Spell_*.txt` files

**Method**:
1. Open `Progressions.lsx`
2. Search for `<node id="AddSpells">`
3. For each ability in `Spells` attribute (e.g., `WAR_Charge;WAR_HeroicStrike`):
   - Search in `Spell_Target.txt`, `Spell_Shout.txt`, etc. for `new entry "AbilityName"`
   - If not found, either remove from Progressions or implement in Spell_*.txt

**✅ All Core Abilities Implemented** (as of v1.0.1.0):
- ✅ Execute, Shield Slam, Mortal Strike, Raging Blow, Avatar (Spell_Target.txt)
- ✅ Revenge, Shockwave, Thunder Clap, Whirlwind (Spell_Zone.txt)
- ✅ All 9 critical dependency abilities complete

**Decision**: Mod is feature-complete for base class + 3 specializations

---

### Step 2.2: Status/Passive Cross-Reference Check ✅

**Verify**: All statuses/passives referenced exist

1. **Status references** (in Spell_*.txt `SpellSuccess` or `SpellFail`):
   - Search `Status_BOOST.txt` for `new entry "StatusName"`

2. **Passive references** (in Progressions.lsx `PassivesAdded`):
   - Search `Passive.txt` for `new entry "PassiveName"`

**Common Issue**: Passive references specialization abilities that don't exist yet (non-breaking, but log warnings)

---

### Step 2.3: Version Number Update ✅

**Files to update**:

1. **meta.lsx** (line 35):
   ```xml
   <attribute id="Version64" type="int64" value="36028797018963968"/>
   ```
   - Increment value for each new version
   - Current: `36028797018963968` (v1.0.0.3)
   - Next: `36028797018963969` (v1.0.0.4) or higher

2. **Package/CHANGELOG.md**:
   - Add new version entry at top
   - Document changes, fixes, known issues
   - Update archive date if archiving previous version

3. **This checklist**:
   - Update "Mod Version" in header
   - ✅ No incomplete abilities - all 9 core abilities implemented

---

## Phase 3: Packaging (5 minutes)

### Step 3.1: Clean Previous Build ✅

```powershell
# Remove old .pak from Package/ root (if exists)
Remove-Item -Path "Package\BG3Wow_Latest.pak" -ErrorAction SilentlyContinue
```

**Purpose**: Ensure fresh package, avoid confusion with old versions

---

### Step 3.2: Package with LSLib ✅

**Command** (run from BG3Mods root):
```powershell
& ".\LsLib\ConverterApp.exe" `
  --source "Data" `
  --destination "Package\BG3Wow_v1.0.1.0.pak" `
  --action "create-package" `
  --package-version "v18" `
  --compression-method "lz4"
```

**Parameters**:
- `--source "Data"`: Input folder (BG3 mod structure)
- `--destination "Package\BG3Wow_vX.X.X.X.pak"`: Output .pak file (update version!)
- `--package-version "v18"`: BG3 Patch 8 compatibility
- `--compression-method "lz4"`: Required for Patch 8

**Expected Output**:
```
PAK packaged successfully.
Elapsed: X.XXs
```

**If packaging fails**:
- Check LSLib console output for errors
- Common causes: Invalid XML, missing files, incorrect Data/ structure
- Re-run validation scripts after fixing

---

### Step 3.3: Create Latest Symlink ✅

```powershell
# Copy to BG3Wow_Latest.pak for easy reference
Copy-Item -Path "Package\BG3Wow_v1.0.1.0.pak" -Destination "Package\BG3Wow_Latest.pak"
```

**Purpose**: Always have a "latest" version for quick testing without tracking version numbers

---

## Phase 4: Installation & Testing (10-15 minutes)

### Step 4.1: Install to Game Mods Folder ✅

**Target Location**:
```
%LOCALAPPDATA%\Larian Studios\Baldur's Gate 3\Mods\
```

**Command**:
```powershell
$GameModsFolder = "$env:LOCALAPPDATA\Larian Studios\Baldur's Gate 3\Mods"
Copy-Item -Path "Package\BG3Wow_Latest.pak" -Destination "$GameModsFolder\BG3Wow.pak" -Force
```

**Note**: Rename to `BG3Wow.pak` (without version suffix) for game compatibility

---

### Step 4.2: Enable in BG3 Mod Manager ✅

1. Open **BG3 Mod Manager** (external tool)
2. Click **Refresh** to detect new .pak
3. **Drag** BG3Wow from "Inactive Mods" to "Active Mods"
4. **Export Load Order** (required for game to recognize mod)
5. Verify `modsettings.lsx` updated in `%LOCALAPPDATA%\Larian Studios\Baldur's Gate 3\PlayerProfiles\<profile>\`

**Expected Result**: BG3Wow appears in active mods list with correct version

---

### Step 4.3: In-Game Testing ✅

**Launch Method**: Use BG3 Mod Manager "Play" button (or launch via Script Extender if installed)

**Testing Steps**:

1. **Character Creation Screen**:
   - [ ] Warrior class appears in class list
   - [ ] Class description displays correctly (not blank or handle references)
   - [ ] Clicking "Warrior" shows level 1 abilities

2. **Level 1 Abilities**:
   - [ ] Rage bar visible in character sheet (0/100)
   - [ ] Starting abilities present: Charge, Heroic Strike, Battle Shout (or equivalent L1 kit)
   - [ ] Tooltips display correctly (no missing text, no handle references like "h125abc01")

3. **Level 3 Subclass Selection**:
   - [ ] Arms, Fury, Protection subclasses appear
   - [ ] Subclass descriptions display correctly
   - [ ] Selecting subclass grants appropriate abilities

4. **Combat Testing** (optional but recommended):
   - [ ] Cast Charge ability (gap closer): Verify jump animation, damage, cooldown
   - [ ] Cast Heroic Strike: Verify damage, rage cost (if any)
   - [ ] Verify Rage generation on damage dealt
   - [ ] Check cooldown reset behavior (OncePerTurn abilities)

**If errors occur**:
- Check Script Extender logs: `%LOCALAPPDATA%\Larian Studios\Baldur's Gate 3\ScriptExtender\Logs\`
- Search for `[BG3WOW]` prefix for mod-specific messages
- Look for errors related to missing abilities, invalid statuses, or malformed data
- Return to Phase 1 validation and fix errors

---

### Step 4.4: Validation Success Criteria ✅

**Mod is ready for release if**:
- ✅ No crash at character creation
- ✅ Warrior class displays with correct name/description
- ✅ Rage bar visible in character sheet
- ✅ All level 1-3 abilities cast successfully
- ✅ Subclass selection works at L3
- ✅ No missing localization text (no handle references visible)
- ✅ No Script Extender errors in logs

**If any criterion fails**: Do NOT release. Return to Phase 1 and fix issues.

---

## Phase 5: Archival & Documentation (5 minutes)

### Step 5.1: Archive Previous Version ✅

**If releasing new version** (e.g., v1.0.1.0 replaces v1.0.0.3):

```powershell
# Option 1: Run automated script (dry-run first)
.\Package\ARCHIVE_PACKAGES.ps1 -WhatIf

# Review output, then execute
.\Package\ARCHIVE_PACKAGES.ps1

# Option 2: Manual archival
Move-Item -Path "Package\BG3Wow_v1.0.0.3_LOCFIX.pak" -Destination "Package\Archive\v1.0.0.3\"
```

**Purpose**: Follow retention policy (keep last 2 in root, archive older versions)

---

### Step 5.2: Update CHANGELOG.md ✅

**Add new version entry** at top of `Package/CHANGELOG.md`:

```markdown
## [X.X.X.X] - October 2025 - CURRENT STABLE 🟢

**Build**: `BG3Wow_vX.X.X.X.pak`  
**Status**: ✅ Stable  
**Archive Date**: Active (Package/ root)

### Added
- New abilities: [list here]
- New features: [list here]

### Fixed
- Bug fixes: [list here]

### Known Issues
- [Updated list of incomplete features]
```

**Update previous version status**: Change from "CURRENT STABLE" to archived status

---

### Step 5.3: Git Commit Strategy ✅

**Recommended commit structure**:

1. **Before packaging**:
   ```powershell
   git add Data/
   git commit -m "feat: Implement [feature name] for v1.0.1.0"
   ```

2. **After successful testing**:
   ```powershell
   git add Package/
   git add Tests/
   git commit -m "release: v1.0.1.0 - [brief description]"
   git tag v1.0.1.0
   git push origin main --tags
   ```

3. **Update documentation**:
   ```powershell
   git add Package/CHANGELOG.md
   git add Package/RETENTION_POLICY.md
   git commit -m "docs: Update CHANGELOG for v1.0.1.0"
   ```

**Purpose**: Separate code changes from release artifacts, tag versions for easy rollback

---

## Phase 6: Distribution (Optional)

### Step 6.1: Upload to Nexus Mods / ModDB ✅

**Files to upload**:
- `Package/BG3Wow_vX.X.X.X.pak` (main mod file)
- `Package/INSTALL_GUIDE.md` (user instructions)
- `Package/CHANGELOG.md` (version history)

**Nexus Mods Requirements**:
- Mod name: "BG3Wow - World of Warcraft Warrior Class"
- Category: Classes & Races
- Game version: Baldur's Gate 3 (Patch 8)
- Requirements: BG3 Script Extender (optional but recommended)

---

### Step 6.2: Update Mod Page Description ✅

**Include**:
- Current version number
- Feature list (base class, 3 specs, Rage system)
- Known issues / incomplete features
- Installation instructions (via BG3 Mod Manager)
- Compatibility notes (conflicts with other Warrior class mods)
- Link to GitHub repository (if public)

---

## Troubleshooting

### Common Issues & Fixes

| **Issue** | **Cause** | **Fix** |
|-----------|-----------|---------|
| Crash at character creation | Malformed Progressions.lsx XML | Run `validate_mod_structure.ps1`, check for unbalanced `<node>` tags |
| Warrior class not visible | UUID mismatch or meta.lsx error | Verify UUID consistency (Step 1.2) |
| Missing ability text | Localization handle missing/duplicate | Check English.loca.xml for duplicates (Step 1.3) |
| Rage bar not showing | ActionResourceDefinitions.lsx syntax error | Validate XML syntax (Step 1.4) |
| Ability won't cast | Invalid cooldown syntax or missing stat entry | Check Spell_*.txt format (Step 1.5) |
| SE logs show errors | Reference to non-existent ability/status | Cross-reference validation (Step 2.1, 2.2) |

### Emergency Rollback Procedure

**If new version causes critical errors**:

1. **Restore previous version**:
   ```powershell
   Copy-Item -Path "Package\Archive\v1.0.0.3\BG3Wow_v1.0.0.3_LOCFIX.pak" -Destination "$env:LOCALAPPDATA\Larian Studios\Baldur's Gate 3\Mods\BG3Wow.pak" -Force
   ```

2. **Refresh BG3 Mod Manager**: Verify old version active

3. **Document issue**: Add to `Tests/CRASH_DIAGNOSIS_SUMMARY.md`

4. **Fix in dev environment**: Do NOT push broken version to Nexus

---

## Quick Command Reference

```powershell
# Validate mod structure
.\validate_mod_structure.ps1 -Verbose

# Package mod (update version number!)
& ".\LsLib\ConverterApp.exe" --source "Data" --destination "Package\BG3Wow_v1.0.1.0.pak" --action "create-package" --package-version "v18" --compression-method "lz4"

# Install to game
Copy-Item -Path "Package\BG3Wow_Latest.pak" -Destination "$env:LOCALAPPDATA\Larian Studios\Baldur's Gate 3\Mods\BG3Wow.pak" -Force

# Archive old version
.\Package\ARCHIVE_PACKAGES.ps1 -WhatIf  # Dry-run
.\Package\ARCHIVE_PACKAGES.ps1           # Execute

# Find duplicate localization handles
Select-String -Path "Data\Public\BG3Wow_78fe4967-4e62-5491-d981-dd781acca4d7\Localization\English\English.loca.xml" -Pattern 'contentuid="(h[^"]+)"' -AllMatches | ForEach-Object { $_.Matches.Groups[1].Value } | Group-Object | Where-Object { $_.Count -gt 1 }

# Check SE logs for errors
Get-Content "$env:LOCALAPPDATA\Larian Studios\Baldur's Gate 3\ScriptExtender\Logs\*" | Select-String "ERROR" | Select-String "BG3WOW"
```

---

## Related Documentation

- **validate_mod_structure.ps1**: Automated validation script (run first!)
- **.github/copilot-instructions.md**: Full pre-packaging validation checklist (basis for this checklist)
- **Package/RETENTION_POLICY.md**: Version archival rules
- **Package/CHANGELOG.md**: Complete version history
- **PACKAGING_GUIDE.md**: Detailed LSLib usage instructions
- **SE_DEBUGGING_GUIDE.md**: Script Extender log interpretation
- **Tests/01_ValidationReports/VALIDATION_STATUS_FINAL.md**: Current mod readiness assessment

---

**Checklist Maintained By**: BG3Wow Development Team  
**Last Updated**: October 17, 2025  
**Checklist Version**: 1.0  
**Target Mod Version**: v1.0.1.0+
