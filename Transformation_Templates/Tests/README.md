# Template Validation Tests

This folder contains automated tests to validate that file transformations follow the established template patterns. Run these tests **before making custom tweaks** to ensure your base transformation is correct.

## Naming Convention

All tests follow the pattern: `FILE_##_Test-{FileName}.ps1`

**Examples**:
- `FILE_01_Test-MetaLsx.ps1`
- `FILE_02_Test-ClassDescriptions.ps1`
- `FILE_03_Test-ActionResourceDefinitions.ps1`

This matches the template documentation naming in `Transformation_Templates/FILE_##_{FileName}_TEMPLATE.md`

## Test Status

**Last Updated**: October 19, 2025  
**Tests Created**: 3 (FILES 1-3)  
**Test Status**: ✅ ALL PASSING (3/3)

## Available Tests

### ✅ FILE 1: meta.lsx Validation
**Script**: `FILE_01_Test-MetaLsx.ps1`  
**Status**: ✅ PASSING  
**Purpose**: Validates mod metadata, UUIDs, folder naming, dependencies

**Checks**:
- UUID consistency across file and folder names
- Version64 and PublishVersion match (supports both attribute and child node patterns)
- All 13 dependencies present (including Gustav)
- Author, Name, Description not empty
- Folder attribute matches physical folder names
- Mods/ and Public/ folder structures correct

**Usage**:
```powershell
.\Test-MetaLsx.ps1 -ModPath "C:\Path\To\Your\Mod\Data"
```

**Critical Lessons**:
- Warlock template uses **child node** for PublishVersion: `<node id="PublishVersion"><attribute id="Version64".../>` 
- NOT an attribute like: `<attribute id="PublishVersion".../>`
- Test must check both patterns for template compatibility

---

### ✅ FILE 2: ClassDescriptions.lsx Validation
**Script**: `FILE_02_Test-ClassDescriptions.ps1`  
**Status**: ✅ PASSING  
**Purpose**: Validates class attributes, HP values, UUIDs, subclass relationships

**Checks**:
- XML well-formed (balanced tags, properly closed comments)
- Base class UUID matches mod UUID
- Subclass ParentGuid links to base class
- HP values correct (BaseHp, HpPerLevel in valid range)
- PrimaryAbility and SpellCastingAbility set (1-6)
- ClassEquipment and SoundClassType not empty
- SpellList UUID present (dummy or real)
- All ClassDescription nodes have Tags child
- All UUIDs unique (no duplicates)
- Warrior-specific validation (if detected): HP 10/10, Strength, Barbarian equipment

**Usage**:
```powershell
.\Test-ClassDescriptions.ps1 -FilePath "C:\Path\To\ClassDescriptions.lsx" -ExpectedBaseUUID "your-mod-uuid"
```

**Critical Lessons**:
- **Multi-line XML comments MUST be properly closed** with `-->`
- PowerShell `[xml]` type accelerator fails on unclosed comments with cryptic "Unexpected end of file" error
- Use regex `(?s)<!--.*?-->` to strip comments before parsing (non-greedy, dotall mode `(?s)`)
- Always count stripped comment blocks to verify regex worked: `([regex]::Matches($RawContent, '<!--')).Count`
- Missing closing `-->` was caught at line 125 in ClassDescriptions.lsx (ProtectionWarrior comment block)

---

### ✅ FILE 3: ActionResourceDefinitions.lsx Validation
**Script**: `FILE_03_Test-ActionResourceDefinitions.ps1`  
**Status**: ✅ PASSING  
**Purpose**: Validates action resource definitions (Rage, charges, etc.)

**Checks**:
- XML well-formed (balanced tags, no unclosed comments)
- Expected 6 resources present: Rage, DefensiveCharge, TankCooldown, MobilityCharge, OverpowerCharge, ThunderCharge
- All resources have required attributes: Name, DisplayName, Description, MaxLevel, ReplenishType
- MaxLevel values correct (Rage: 100, Charges: 1-3)
- ReplenishType valid (Rest, ShortRest, Default)
- All UUIDs unique (no duplicates)
- All DisplayName/Description handles follow format: `h[8hex][2digit]`

**Usage**:
```powershell
.\FILE_03_Test-ActionResourceDefinitions.ps1 -FilePath "C:\Path\To\ActionResourceDefinitions.lsx"
```

**Critical Lessons**:
- Action resources define custom resources (not spell slots or default resources)
- Warrior uses 6 resources: 1 main (Rage) + 5 charge-based (for cooldown tracking)
- ReplenishType "Default" = doesn't auto-replenish (manual via abilities)
- MaxLevel for charges should be low (1-3) to prevent UI clutter
- Template approach: ability-tied charges (not generic per-spec pools)

---

## Quick Test All

**Script**: `Test-AllFiles.ps1`  
**Status**: ✅ PASSING (3/3 files)

Run all available tests in sequence:
```powershell
.\Test-AllFiles.ps1 -ModPath "C:\Path\To\Your\Mod\Data"
```

**Output Example**:
```
========================================
   MOD VALIDATION TEST SUITE
========================================

TEST  FILE 1: meta.lsx
[PASS] UUID valid: 78fe4967-4e62-5491-d981-dd781acca4d7
[PASS] Dependencies found: 13
[SUCCESS] ALL TESTS PASSED

TEST  FILE 2: ClassDescriptions.lsx
[INFO] Stripped 2 comment block(s) from XML
[PASS] Found 2 ClassDescription node(s)
[PASS] Warrior HP correct (d10: 10/10)
[SUCCESS] ALL TESTS PASSED

========================================
   FINAL RESULTS
========================================
Total Tests:  2
Passed:       2
Failed:       0

✅ ALL TESTS PASSED!
```

## Test Output Format

Each test script outputs:
- `[PASS]` - Green text, check passed
- `[FAIL]` - Red text, issue found with details
- `[WARN]` - Yellow text, non-critical issue or recommendation
- `[INFO]` - Cyan text, contextual information

**Exit codes**:
- `0`: All tests passed
- `1`: One or more tests failed

**NOTE**: Avoid Unicode characters (✅❌⚠️ℹ️) in PowerShell scripts - they cause parse errors. Use plain ASCII `[PASS]`, `[FAIL]`, `[WARN]`, `[INFO]` instead.

---

## Example Workflow

### Starting a New Class Mod:
1. Transform FILE 1 (meta.lsx) using template
2. Run `.\Test-MetaLsx.ps1` to validate
3. Fix any failures before proceeding
4. Transform FILE 2 (ClassDescriptions.lsx)
5. Run `.\Test-ClassDescriptions.ps1` to validate
6. Fix any failures before proceeding
7. Continue with FILES 3-15...
8. **After ALL transformations complete**, make custom tweaks
9. Re-run tests to ensure tweaks didn't break critical patterns

### Troubleshooting Failed Mods:
1. Run `.\Test-AllFiles.ps1` to get comprehensive validation
2. Review failure messages (shows exact issue + context)
3. Compare failing values against template documentation
4. Fix issues and re-run tests
5. Repeat until all tests pass

---

## 🎓 Test Design Best Practices

Based on successful creation of FILES 1-2 tests:

### PowerShell XML Handling
```powershell
# ALWAYS strip multi-line comments before parsing
$RawContent = Get-Content $FilePath -Raw
$CleanedContent = $RawContent -replace '(?s)<!--.*?-->', ''

# Verify stripping worked
$CommentCount = ([regex]::Matches($RawContent, '<!--')).Count
if ($CommentCount -gt 0) {
    Write-Info "Stripped $CommentCount comment block(s) from XML"
}

# NOW parse
[xml]$ParsedXml = $CleanedContent
```

**Why**: PowerShell's `[xml]` type accelerator is very strict. Multi-line comments spanning large blocks of XML can cause "Unexpected end of file while parsing Comment" errors, even if syntax is valid.

### Version Checking Pattern
```powershell
# Handle both attribute AND child node patterns
$VersionAttr = $Node.Attributes["PublishVersion"]
if ($VersionAttr) {
    $PublishVersion = $VersionAttr.Value
} else {
    # Warlock template uses child node pattern
    $PubVerNode = $Node.children.node | Where-Object { $_.id -eq "PublishVersion" }
    if ($PubVerNode) {
        $PublishVersion = $PubVerNode.Attributes["Version64"].Value
    }
}
```

**Why**: Different templates use different XML structures. Tests must be flexible to work across multiple working mods.

### Color Output Helpers
```powershell
# Simple, reliable, no Unicode
function Write-Pass { param($Message) Write-Host "[PASS] $Message" -ForegroundColor Green }
function Write-Fail { param($Message) Write-Host "[FAIL] $Message" -ForegroundColor Red; $script:FailCount++ }
function Write-Warn { param($Message) Write-Host "[WARN] $Message" -ForegroundColor Yellow }
function Write-Info { param($Message) Write-Host "[INFO] $Message" -ForegroundColor Cyan }
```

**Why**: Consistent formatting, automatic fail counting, no Unicode parse errors.

### Show Context, Not Just Pass/Fail
```powershell
# Good: Shows what was found
Write-Info "UUID: $UuidValue"
Write-Info "HP: $BaseHp / $HpPerLevel per level"
Write-Pass "UUID valid"

# Bad: Just passes without context
Write-Pass "UUID check passed"
```

**Why**: Helps user understand what's actually in their files, easier debugging.

---

## Adding New Tests

When creating tests for FILES 3-15, follow this pattern:

```powershell
# Test-YourFile.ps1
param(
    [Parameter(Mandatory=$true)]
    [string]$FilePath,
    
    [Parameter(Mandatory=$false)]
    [string]$ExpectedValue
)

# Color output helpers
function Write-Pass { param($Message) Write-Host "✅ PASS: $Message" -ForegroundColor Green }
function Write-Fail { param($Message) Write-Host "❌ FAIL: $Message" -ForegroundColor Red }
function Write-Warn { param($Message) Write-Host "⚠️  WARN: $Message" -ForegroundColor Yellow }

$FailCount = 0

# Test 1: File exists
if (-not (Test-Path $FilePath)) {
    Write-Fail "File not found: $FilePath"
    exit 1
}
Write-Pass "File exists"

# Test 2: Your validation logic here
# ...

# Final result
if ($FailCount -eq 0) {
    Write-Host "`n✅ ALL TESTS PASSED" -ForegroundColor Green
    exit 0
} else {
    Write-Host "`n❌ $FailCount TEST(S) FAILED" -ForegroundColor Red
    exit 1
}
```

## Test Coverage Roadmap

| File # | Test Script | Status | Priority |
|--------|-------------|--------|----------|
| 1 | Test-MetaLsx.ps1 | ✅ CREATED | HIGH |
| 2 | Test-ClassDescriptions.ps1 | ✅ CREATED | HIGH |
| 3 | Test-ActionResourceDefinitions.ps1 | 📋 PENDING | HIGH |
| 4-10 | Test-StatsFiles.ps1 | 📋 PENDING | MEDIUM |
| 11 | Test-Progressions.ps1 | 📋 PENDING | CRITICAL |
| 12 | Test-Localization.ps1 | 📋 PENDING | MEDIUM |
| 13-14 | Test-Lists.ps1 | 📋 PENDING | LOW |
| 15 | Test-ScriptExtender.ps1 | 📋 PENDING | LOW |

## CI/CD Integration (Future)

These tests can be integrated into:
- **Pre-commit hooks**: Run before committing changes
- **GitHub Actions**: Validate on push
- **Pre-packaging validation**: Run before creating .pak file

---

**Created**: January 2025  
**Purpose**: Ensure transformations follow proven template patterns  
**Benefit**: Catch errors early, before in-game testing
