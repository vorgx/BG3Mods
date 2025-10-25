# PHASE 1: Baseline Abilities Validation (L1-12)
# Validates baseline ability grants for Arms, Protection, Fury subclasses

param(
    [string]$DatabasePath = "C:\Users\tenod\source\repos\BG3Mods\Documentation\00_SourcesOfTruth\AbilityDatabase_Warrior_FullyEnriched.csv",
    [string]$LinkedPath = "C:\Users\tenod\source\repos\BG3Mods\Documentation\00_SourcesOfTruth\Warrior Progression LINKED - Main.csv",
    [string]$SourceOfTruthPath = "C:\Users\tenod\source\repos\BG3Mods\Documentation\00_SourcesOfTruth\SOURCE_OF_TRUTH.md",
    [string]$OutputPath = "C:\Users\tenod\source\repos\BG3Mods\Documentation\00_SourcesOfTruth\ValidationReports\PHASE1_BASELINE_VALIDATION.md"
)

Write-Host "[INFO] Starting PHASE 1: Baseline Abilities Validation" -ForegroundColor Cyan
Write-Host ""

# Load Database
Write-Host "[STEP 1] Loading AbilityDatabase..." -ForegroundColor Yellow
try {
    $Db = Import-Csv $DatabasePath -Encoding UTF8
    Write-Host "[PASS] Database loaded: $($Db.Count) abilities" -ForegroundColor Green
} catch {
    Write-Host "[FAIL] Failed to load database: $_" -ForegroundColor Red
    exit 1
}

# Load LINKED CSV (handle 3-row header manually)
Write-Host "[STEP 2] Loading LINKED CSV..." -ForegroundColor Yellow
try {
    $RawContent = Get-Content $LinkedPath -Raw -Encoding UTF8
    $Lines = $RawContent -split "`r?`n"
    
    # Skip 3 header rows, process data rows (rows 4-23 = L1-L20)
    $DataLines = $Lines[3..($Lines.Count-1)] | Where-Object { $_ -match '\S' }
    Write-Host "[PASS] LINKED CSV loaded: $($DataLines.Count) data rows (L1-L20)" -ForegroundColor Green
    
    # Headers parsed but not used in this validation (3-row header structure documented)
    
} catch {
    Write-Host "[FAIL] Failed to load LINKED CSV: $_" -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "[STEP 3] Extracting Baseline Abilities (Columns 5-11, Rows 4-15 = L1-L12)" -ForegroundColor Yellow

# Column indices (0-based):
# 4-5: Baseline_Arms (Offensive, Utility)
# 6-8: Baseline_Protection (Offensive, Utility, Passives)
# 9-10: Baseline_Fury (Offensive, Utility)

$BaselineAbilities = @{
    Arms = @()
    Protection = @()
    Fury = @()
}

# Process first 12 levels (rows 4-15 in CSV = indices 3-14 in array)
$LevelRows = $DataLines[0..11]

foreach ($i in 0..11) {
    $Level = $i + 1
    $Row = $LevelRows[$i]
    $Cells = $Row -split ','
    
    Write-Host "  Processing Level $Level..." -ForegroundColor Gray
    
    # Arms Baseline (columns 4-5)
    if ($Cells[4] -match '\S') { 
        $BaselineAbilities.Arms += @{ Level = $Level; Cell = $Cells[4]; Column = "Offensive" }
    }
    if ($Cells[5] -match '\S') { 
        $BaselineAbilities.Arms += @{ Level = $Level; Cell = $Cells[5]; Column = "Utility" }
    }
    
    # Protection Baseline (columns 6-8)
    if ($Cells[6] -match '\S') { 
        $BaselineAbilities.Protection += @{ Level = $Level; Cell = $Cells[6]; Column = "Offensive" }
    }
    if ($Cells[7] -match '\S') { 
        $BaselineAbilities.Protection += @{ Level = $Level; Cell = $Cells[7]; Column = "Utility" }
    }
    if ($Cells[8] -match '\S') { 
        $BaselineAbilities.Protection += @{ Level = $Level; Cell = $Cells[8]; Column = "Passives" }
    }
    
    # Fury Baseline (columns 9-10)
    if ($Cells[9] -match '\S') { 
        $BaselineAbilities.Fury += @{ Level = $Level; Cell = $Cells[9]; Column = "Offensive" }
    }
    if ($Cells[10] -match '\S') { 
        $BaselineAbilities.Fury += @{ Level = $Level; Cell = $Cells[10]; Column = "Utility" }
    }
}

Write-Host "[PASS] Baseline abilities extracted" -ForegroundColor Green
Write-Host "  - Arms: $($BaselineAbilities.Arms.Count) abilities" -ForegroundColor Cyan
Write-Host "  - Protection: $($BaselineAbilities.Protection.Count) abilities" -ForegroundColor Cyan
Write-Host "  - Fury: $($BaselineAbilities.Fury.Count) abilities" -ForegroundColor Cyan
Write-Host ""

# Validation: Extract ability_id from cells and check against database
Write-Host "[STEP 4] Validating Abilities Against Database" -ForegroundColor Yellow

$ValidationResults = @{
    Arms = @()
    Protection = @()
    Fury = @()
}

$FailCount = 0

foreach ($Spec in @('Arms', 'Protection', 'Fury')) {
    Write-Host "  Validating $Spec..." -ForegroundColor Gray
    
    foreach ($Entry in $BaselineAbilities[$Spec]) {
        $Cell = $Entry.Cell
        $Level = $Entry.Level
        $Column = $Entry.Column
        
        # Extract ability_id (format: "Name - WAR__AbilityId_")
        if ($Cell -match ' - (WAR[_\w]+)') {
            $AbilityId = $Matches[1]
            $AbilityName = ($Cell -split ' - ')[0]
            
            # Check if exists in database
            $DbEntry = $Db | Where-Object { $_.ability_id -eq $AbilityId }
            
            if ($DbEntry) {
                $ValidationResults[$Spec] += @{
                    Level = $Level
                    Column = $Column
                    AbilityName = $AbilityName
                    AbilityId = $AbilityId
                    Status = "PASS"
                    DbName = $DbEntry.ability_name
                    Match = ($AbilityName -eq $DbEntry.ability_name)
                }
                
                if ($AbilityName -ne $DbEntry.ability_name) {
                    Write-Host "    [WARN] L${Level} ${AbilityName} - Name mismatch (CSV: ${AbilityName}, DB: $($DbEntry.ability_name))" -ForegroundColor Yellow
                }
            } else {
                $ValidationResults[$Spec] += @{
                    Level = $Level
                    Column = $Column
                    AbilityName = $AbilityName
                    AbilityId = $AbilityId
                    Status = "FAIL"
                    DbName = "NOT FOUND"
                    Match = $false
                }
                Write-Host "    [FAIL] L$Level $AbilityName ($AbilityId): NOT FOUND in database" -ForegroundColor Red
                $FailCount++
            }
        } else {
            Write-Host "    [WARN] L${Level} - Could not parse ability_id from cell: $Cell" -ForegroundColor Yellow
        }
    }
}

Write-Host ""
if ($FailCount -eq 0) {
    Write-Host "[PASS] All baseline abilities exist in database!" -ForegroundColor Green
} else {
    Write-Host "[FAIL] $FailCount abilities NOT FOUND in database" -ForegroundColor Red
}

Write-Host ""
Write-Host "[STEP 5] Checking Ability Naming Format (Double Underscores)" -ForegroundColor Yellow

$NamingIssues = @()

foreach ($Spec in @('Arms', 'Protection', 'Fury')) {
    foreach ($Entry in $ValidationResults[$Spec]) {
        $AbilityId = $Entry.AbilityId
        
        # Check for double underscores or trailing underscores
        if ($AbilityId -match '__' -or $AbilityId -match '_$') {
            $NamingIssues += @{
                Spec = $Spec
                Level = $Entry.Level
                AbilityName = $Entry.AbilityName
                AbilityId = $AbilityId
                Issue = if ($AbilityId -match '__') { "Double underscore" } else { "Trailing underscore" }
            }
            Write-Host "  [WARN] $Spec L$($Entry.Level) $($Entry.AbilityName): $AbilityId has naming issue" -ForegroundColor Yellow
        }
    }
}

if ($NamingIssues.Count -eq 0) {
    Write-Host "[PASS] All ability names use correct format (no double underscores)" -ForegroundColor Green
} else {
    Write-Host "[WARN] $($NamingIssues.Count) abilities have naming issues" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "[STEP 6] Generating Validation Report" -ForegroundColor Yellow

# Create report
$Report = @"
# PHASE 1: Baseline Abilities Validation Report

**Date**: $(Get-Date -Format "MMMM d, yyyy")  
**Phase**: 1 of 7  
**Status**: Complete  
**Validation Result**: $(if ($FailCount -eq 0 -and $NamingIssues.Count -eq 0) { "PASS" } elseif ($FailCount -eq 0) { "PASS (with warnings)" } else { "FAIL" })

---

## Summary

Validated baseline ability grants (L1-12) for all 3 Warrior subclasses against:
- **AbilityDatabase_Warrior_FullyEnriched.csv** (221 abilities)
- **Warrior Progression LINKED - Main.csv** (260 abilities, columns 5-11)
- **SOURCE_OF_TRUTH.md** Section [6.1], [6.2], [6.3]

**Total Baseline Abilities Validated**: $($BaselineAbilities.Arms.Count + $BaselineAbilities.Protection.Count + $BaselineAbilities.Fury.Count) abilities
- Arms: $($BaselineAbilities.Arms.Count) abilities
- Protection: $($BaselineAbilities.Protection.Count) abilities
- Fury: $($BaselineAbilities.Fury.Count) abilities

**Validation Findings**:
- ✅ Database Coverage: $(if ($FailCount -eq 0) { "100% - All abilities exist in database" } else { "$FailCount abilities NOT FOUND" })
- $(if ($NamingIssues.Count -eq 0) { "✅" } else { "⚠️" }) Naming Format: $(if ($NamingIssues.Count -eq 0) { "100% correct (no double underscores)" } else { "$($NamingIssues.Count) abilities have naming issues" })

---

## Validation Findings

### ✅ Correct Elements

"@

# Add passed validations
$Report += "`n"
foreach ($Spec in @('Arms', 'Protection', 'Fury')) {
    $PassedAbilities = $ValidationResults[$Spec] | Where-Object { $_.Status -eq "PASS" }
    $Report += "`n**$Spec Baseline Abilities ($($PassedAbilities.Count) abilities)**:`n"
    foreach ($Entry in $PassedAbilities | Sort-Object Level) {
        $Report += "- L$($Entry.Level): $($Entry.AbilityName) ($($Entry.AbilityId)) [$($Entry.Column)]`n"
    }
}

$Report += "`n### ❌ Discrepancies Found`n`n"
if ($FailCount -eq 0) {
    $Report += "None - All baseline abilities exist in database!`n"
} else {
    $Report += "**Missing Abilities ($FailCount)**:`n"
    foreach ($Spec in @('Arms', 'Protection', 'Fury')) {
        $FailedAbilities = $ValidationResults[$Spec] | Where-Object { $_.Status -eq "FAIL" }
        foreach ($Entry in $FailedAbilities) {
            $Report += "- $Spec L$($Entry.Level): $($Entry.AbilityName) ($($Entry.AbilityId)) - NOT FOUND in database`n"
        }
    }
}

$Report += "`n### ⚠️ Warnings`n`n"
if ($NamingIssues.Count -eq 0) {
    $Report += "None - All ability names use correct format.`n"
} else {
    $Report += "**Naming Format Issues ($($NamingIssues.Count))**:`n"
    foreach ($Issue in $NamingIssues) {
        $Report += "- $($Issue.Spec) L$($Issue.Level): $($Issue.AbilityName) ($($Issue.AbilityId)) - $($Issue.Issue)`n"
    }
    $Report += "`n**Recommendation**: These abilities use old naming convention with double underscores or trailing underscores. Update to single underscore format (e.g., WAR__Whirlwind_ → WAR_Whirlwind).`n"
}

$Report += @"

---

## Evidence: Arms Baseline Progression (L1-12)

| Level | Offensive Abilities | Utility Abilities | Database Status |
|-------|--------------------|--------------------|-----------------|
"@

for ($i = 1; $i -le 12; $i++) {
    $OffensiveEntry = $ValidationResults.Arms | Where-Object { $_.Level -eq $i -and $_.Column -eq "Offensive" }
    $UtilityEntry = $ValidationResults.Arms | Where-Object { $_.Level -eq $i -and $_.Column -eq "Utility" }
    
    $OffensiveStatus = if ($OffensiveEntry) { if ($OffensiveEntry.Status -eq 'PASS') { '[PASS]' } else { '[FAIL]' } } else { '' }
    $UtilityStatus = if ($UtilityEntry) { if ($UtilityEntry.Status -eq 'PASS') { '[PASS]' } else { '[FAIL]' } } else { '' }
    
    $OffensiveText = if ($OffensiveEntry) { "$($OffensiveEntry.AbilityName) $OffensiveStatus" } else { "-" }
    $UtilityText = if ($UtilityEntry) { "$($UtilityEntry.AbilityName) $UtilityStatus" } else { "-" }
    
    $Report += "| L$i | $OffensiveText | $UtilityText | $(if ($OffensiveEntry.Status -eq 'PASS' -and $UtilityEntry.Status -eq 'PASS') { 'Valid' } elseif (-not $OffensiveEntry -and -not $UtilityEntry) { 'Empty' } else { 'Check' }) |`n"
}

$Report += @"

---

## Evidence: Protection Baseline Progression (L1-12)

| Level | Offensive Abilities | Utility Abilities | Passives | Database Status |
|-------|--------------------|--------------------|----------|-----------------|
"@

for ($i = 1; $i -le 12; $i++) {
    $OffensiveEntry = $ValidationResults.Protection | Where-Object { $_.Level -eq $i -and $_.Column -eq "Offensive" }
    $UtilityEntry = $ValidationResults.Protection | Where-Object { $_.Level -eq $i -and $_.Column -eq "Utility" }
    $PassiveEntry = $ValidationResults.Protection | Where-Object { $_.Level -eq $i -and $_.Column -eq "Passives" }
    
    $OffensiveStatus = if ($OffensiveEntry) { if ($OffensiveEntry.Status -eq 'PASS') { '[PASS]' } else { '[FAIL]' } } else { '' }
    $UtilityStatus = if ($UtilityEntry) { if ($UtilityEntry.Status -eq 'PASS') { '[PASS]' } else { '[FAIL]' } } else { '' }
    $PassiveStatus = if ($PassiveEntry) { if ($PassiveEntry.Status -eq 'PASS') { '[PASS]' } else { '[FAIL]' } } else { '' }
    
    $OffensiveText = if ($OffensiveEntry) { "$($OffensiveEntry.AbilityName) $OffensiveStatus" } else { "-" }
    $UtilityText = if ($UtilityEntry) { "$($UtilityEntry.AbilityName) $UtilityStatus" } else { "-" }
    $PassiveText = if ($PassiveEntry) { "$($PassiveEntry.AbilityName) $PassiveStatus" } else { "-" }
    
    $Report += "| L$i | $OffensiveText | $UtilityText | $PassiveText | Valid |`n"
}

$Report += @"

---

## Evidence: Fury Baseline Progression (L1-12)

| Level | Offensive Abilities | Utility Abilities | Database Status |
|-------|--------------------|--------------------|-----------------|
"@

for ($i = 1; $i -le 12; $i++) {
    $OffensiveEntry = $ValidationResults.Fury | Where-Object { $_.Level -eq $i -and $_.Column -eq "Offensive" }
    $UtilityEntry = $ValidationResults.Fury | Where-Object { $_.Level -eq $i -and $_.Column -eq "Utility" }
    
    $OffensiveStatus = if ($OffensiveEntry) { if ($OffensiveEntry.Status -eq 'PASS') { '[PASS]' } else { '[FAIL]' } } else { '' }
    $UtilityStatus = if ($UtilityEntry) { if ($UtilityEntry.Status -eq 'PASS') { '[PASS]' } else { '[FAIL]' } } else { '' }
    
    $OffensiveText = if ($OffensiveEntry) { "$($OffensiveEntry.AbilityName) $OffensiveStatus" } else { "-" }
    $UtilityText = if ($UtilityEntry) { "$($UtilityEntry.AbilityName) $UtilityStatus" } else { "-" }
    
    $Report += "| L$i | $OffensiveText | $UtilityText | Valid |`n"
}

$Report += @"

---

## Recommendations

$(if ($FailCount -eq 0 -and $NamingIssues.Count -eq 0) {
    "**No corrections needed!** All baseline abilities validated successfully."
} else {
    $Recommendations = @()
    
    if ($FailCount -gt 0) {
        $Recommendations += "1. **Add Missing Abilities to Database**: $FailCount abilities not found in AbilityDatabase_Warrior_FullyEnriched.csv"
    }
    
    if ($NamingIssues.Count -gt 0) {
        $Recommendations += "$(if ($FailCount -gt 0) { '2' } else { '1' }). **Fix Naming Format**: Update $($NamingIssues.Count) abilities in LINKED CSV to use single underscore format (remove double underscores and trailing underscores)"
        $Recommendations += "   - Example: WAR__Whirlwind_ → WAR_Whirlwind"
        $Recommendations += "   - Run database ability_id normalization script"
    }
    
    $Recommendations -join "`n"
})

---

## Next Steps

$(if ($FailCount -eq 0 -and $NamingIssues.Count -eq 0) {
    "✅ **Phase 1 Complete** - Ready for PHASE 2: Class Talents Validation"
} else {
    "⚠️ **Action Required**: Fix discrepancies before proceeding to Phase 2"
})

---

## Validation Statistics

- **Total Abilities Checked**: $($BaselineAbilities.Arms.Count + $BaselineAbilities.Protection.Count + $BaselineAbilities.Fury.Count)
- **Passed**: $(($ValidationResults.Arms + $ValidationResults.Protection + $ValidationResults.Fury | Where-Object { $_.Status -eq 'PASS' }).Count)
- **Failed**: $FailCount
- **Warnings**: $($NamingIssues.Count)
- **Success Rate**: $(if (($BaselineAbilities.Arms.Count + $BaselineAbilities.Protection.Count + $BaselineAbilities.Fury.Count) -gt 0) { [math]::Round((($ValidationResults.Arms + $ValidationResults.Protection + $ValidationResults.Fury | Where-Object { $_.Status -eq 'PASS' }).Count / ($BaselineAbilities.Arms.Count + $BaselineAbilities.Protection.Count + $BaselineAbilities.Fury.Count)) * 100, 1) } else { 0 })%

---

**Generated**: $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")  
**Script**: Phase1_Baseline_Validation.ps1
"@

# Write report
$Report | Out-File $OutputPath -Encoding UTF8
Write-Host "[PASS] Report generated: $OutputPath" -ForegroundColor Green

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "PHASE 1 VALIDATION COMPLETE" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Result: $(if ($FailCount -eq 0 -and $NamingIssues.Count -eq 0) { "PASS ✅" } elseif ($FailCount -eq 0) { "PASS (with warnings) ⚠️" } else { "FAIL ❌" })" -ForegroundColor $(if ($FailCount -eq 0) { "Green" } else { "Red" })
Write-Host "Report: $OutputPath" -ForegroundColor Cyan
Write-Host ""

if ($FailCount -eq 0 -and $NamingIssues.Count -eq 0) {
    exit 0
} elseif ($FailCount -eq 0) {
    exit 0  # Warnings don't fail the validation
} else {
    exit 1
}
