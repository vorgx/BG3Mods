# PHASE 3: Subclass Talents Validation (L1-12)
# Validates subclass-specific talent trees for Arms, Fury, Protection

param(
    [string]$DatabasePath = "C:\Users\tenod\source\repos\BG3Mods\Documentation\00_SourcesOfTruth\AbilityDatabase_Warrior_FullyEnriched.csv",
    [string]$LinkedPath = "C:\Users\tenod\source\repos\BG3Mods\Documentation\00_SourcesOfTruth\Warrior Progression LINKED - Main.csv",
    [string]$OutputPath = "C:\Users\tenod\source\repos\BG3Mods\Documentation\00_SourcesOfTruth\ValidationReports\PHASE3_SUBCLASS_TALENTS_VALIDATION.md"
)

Write-Host "[INFO] Starting PHASE 3: Subclass Talents Validation" -ForegroundColor Cyan
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

# Load LINKED CSV
Write-Host "[STEP 2] Loading LINKED CSV..." -ForegroundColor Yellow
try {
    $RawContent = Get-Content $LinkedPath -Raw -Encoding UTF8
    $Lines = $RawContent -split "`r?`n"
    $DataLines = $Lines[3..($Lines.Count-1)] | Where-Object { $_ -match '\S' }
    Write-Host "[PASS] LINKED CSV loaded: $($DataLines.Count) data rows (L1-L20)" -ForegroundColor Green
} catch {
    Write-Host "[FAIL] Failed to load LINKED CSV: $_" -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "[STEP 3] Extracting Subclass Talents (Columns 22-55, Rows 4-15 = L1-L12)" -ForegroundColor Yellow

# Column indices (0-based):
# 21-33: Arms_Subclass (13 columns)
# 34-46: Fury_Subclass (13 columns) - but actually 11 columns based on handover
# 47-54: Protection_Subclass (8 columns)

$SubclassTalents = @{
    Arms = @()
    Fury = @()
    Protection = @()
}

# Process first 12 levels
$LevelRows = $DataLines[0..11]

foreach ($i in 0..11) {
    $Level = $i + 1
    $Row = $LevelRows[$i]
    $Cells = $Row -split ','
    
    Write-Host "  Processing Level $Level..." -ForegroundColor Gray
    
    # Arms (columns 21-33 = 13 columns)
    for ($col = 21; $col -le 33; $col++) {
        if ($col -lt $Cells.Count -and $Cells[$col] -match '\S') {
            $SubclassTalents.Arms += @{ 
                Level = $Level; 
                Cell = $Cells[$col]; 
                Column = $col;
                Type = "Arms Talent"
            }
        }
    }
    
    # Fury (columns 34-46 = 13 columns)
    for ($col = 34; $col -le 46; $col++) {
        if ($col -lt $Cells.Count -and $Cells[$col] -match '\S') {
            $SubclassTalents.Fury += @{ 
                Level = $Level; 
                Cell = $Cells[$col]; 
                Column = $col;
                Type = "Fury Talent"
            }
        }
    }
    
    # Protection (columns 47-54 = 8 columns)
    for ($col = 47; $col -le 54; $col++) {
        if ($col -lt $Cells.Count -and $Cells[$col] -match '\S') {
            $SubclassTalents.Protection += @{ 
                Level = $Level; 
                Cell = $Cells[$col]; 
                Column = $col;
                Type = "Protection Talent"
            }
        }
    }
}

Write-Host "[PASS] Subclass talents extracted" -ForegroundColor Green
Write-Host "  - Arms: $($SubclassTalents.Arms.Count) talents" -ForegroundColor Cyan
Write-Host "  - Fury: $($SubclassTalents.Fury.Count) talents" -ForegroundColor Cyan
Write-Host "  - Protection: $($SubclassTalents.Protection.Count) talents" -ForegroundColor Cyan
Write-Host ""

# Validation: Extract ability_id and check against database
Write-Host "[STEP 4] Validating Abilities Against Database" -ForegroundColor Yellow

$ValidationResults = @{
    Arms = @()
    Fury = @()
    Protection = @()
}

$FailCount = 0

foreach ($Spec in @('Arms', 'Fury', 'Protection')) {
    Write-Host "  Validating $Spec..." -ForegroundColor Gray
    
    foreach ($Entry in $SubclassTalents[$Spec]) {
        $Cell = $Entry.Cell
        $Level = $Entry.Level
        $Column = $Entry.Column
        
        if ($Cell -match ' - (WAR[_\w]+)') {
            $AbilityId = $Matches[1]
            $AbilityName = ($Cell -split ' - ')[0]
            
            $DbEntry = $Db | Where-Object { $_.ability_id -eq $AbilityId }
            
            if ($DbEntry) {
                $ValidationResults[$Spec] += @{
                    Level = $Level
                    Column = $Column
                    AbilityName = $AbilityName
                    AbilityId = $AbilityId
                    Status = "PASS"
                    DbName = $DbEntry.ability_name
                    Category = $DbEntry.category
                    Subclass = $DbEntry.subclass
                }
            } else {
                $ValidationResults[$Spec] += @{
                    Level = $Level
                    Column = $Column
                    AbilityName = $AbilityName
                    AbilityId = $AbilityId
                    Status = "FAIL"
                    DbName = "NOT FOUND"
                    Category = "UNKNOWN"
                    Subclass = "UNKNOWN"
                }
                Write-Host "    [FAIL] L$Level Col$Column $AbilityName ($AbilityId): NOT FOUND" -ForegroundColor Red
                $FailCount++
            }
        }
    }
}

Write-Host ""
if ($FailCount -eq 0) {
    Write-Host "[PASS] All subclass talents exist in database!" -ForegroundColor Green
} else {
    Write-Host "[FAIL] $FailCount abilities NOT FOUND in database" -ForegroundColor Red
}

Write-Host ""
Write-Host "[STEP 5] Analyzing Auto-Grant vs Choice Classification" -ForegroundColor Yellow

# Count auto-grants vs choices per spec
foreach ($Spec in @('Arms', 'Fury', 'Protection')) {
    $TalentsByLevel = $ValidationResults[$Spec] | Group-Object -Property Level
    $L1Talents = ($TalentsByLevel | Where-Object { $_.Name -eq '1' }).Count
    
    Write-Host "  $Spec L1 talents: $L1Talents (should be 3-4 auto-grants)" -ForegroundColor Gray
}

Write-Host ""
Write-Host "[STEP 6] Checking for Prerequisite Keywords" -ForegroundColor Yellow

# Look for abilities that might have prerequisites (based on ability names)
$PrereqKeywords = @('Improved', 'Enhanced', 'Advanced', 'Superior', 'Greater')
$PotentialPrereqs = @()

foreach ($Spec in @('Arms', 'Fury', 'Protection')) {
    foreach ($Entry in $ValidationResults[$Spec]) {
        foreach ($Keyword in $PrereqKeywords) {
            if ($Entry.AbilityName -like "*$Keyword*") {
                $PotentialPrereqs += @{
                    Spec = $Spec
                    Ability = $Entry.AbilityName
                    Level = $Entry.Level
                    Keyword = $Keyword
                }
            }
        }
    }
}

if ($PotentialPrereqs.Count -gt 0) {
    Write-Host "[INFO] Found $($PotentialPrereqs.Count) abilities with prerequisite keywords:" -ForegroundColor Cyan
    foreach ($Prereq in $PotentialPrereqs | Select-Object -First 10) {
        Write-Host "  $($Prereq.Spec) L$($Prereq.Level): $($Prereq.Ability) (keyword: $($Prereq.Keyword))" -ForegroundColor Gray
    }
    if ($PotentialPrereqs.Count -gt 10) {
        Write-Host "  ... and $($PotentialPrereqs.Count - 10) more" -ForegroundColor Gray
    }
} else {
    Write-Host "[INFO] No obvious prerequisite keywords found" -ForegroundColor Cyan
}

Write-Host ""
Write-Host "[STEP 7] Generating Validation Report" -ForegroundColor Yellow

# Create report
$Report = @"
# PHASE 3: Subclass Talents Validation Report

**Date**: $(Get-Date -Format "MMMM d, yyyy")  
**Phase**: 3 of 7  
**Status**: Complete  
**Validation Result**: $(if ($FailCount -eq 0) { "PASS" } else { "FAIL" })

---

## Summary

Validated subclass-specific talent trees (L1-12) for all 3 Warrior subclasses against:
- **AbilityDatabase_Warrior_FullyEnriched.csv** (221 abilities)
- **Warrior Progression LINKED - Main.csv** (columns 22-55)
- **SOURCE_OF_TRUTH.md** Section [4.1], [4.2], [4.3]

**Total Subclass Talents Validated**: $($SubclassTalents.Arms.Count + $SubclassTalents.Fury.Count + $SubclassTalents.Protection.Count) talents
- Arms: $($SubclassTalents.Arms.Count) talents (13 columns)
- Fury: $($SubclassTalents.Fury.Count) talents (13 columns)
- Protection: $($SubclassTalents.Protection.Count) talents (8 columns)

**Validation Findings**:
- $(if ($FailCount -eq 0) { "✅" } else { "❌" }) Database Coverage: $(if ($FailCount -eq 0) { "100% - All abilities exist in database" } else { "$FailCount abilities NOT FOUND" })
- ℹ️ Prerequisite Keywords: Found $($PotentialPrereqs.Count) abilities with potential prerequisites

---

## Validation Findings

### ✅ Correct Elements

**Arms Subclass Talents ($($ValidationResults.Arms | Where-Object { $_.Status -eq 'PASS' }).Count) talents)**:
"@

foreach ($Entry in ($ValidationResults.Arms | Where-Object { $_.Status -eq "PASS" } | Sort-Object Level, Column | Select-Object -First 20)) {
    $Report += "`n- L$($Entry.Level) Col$($Entry.Column): $($Entry.AbilityName) ($($Entry.AbilityId))"
}
if (($ValidationResults.Arms | Where-Object { $_.Status -eq "PASS" }).Count -gt 20) {
    $Report += "`n- ... and $(($ValidationResults.Arms | Where-Object { $_.Status -eq 'PASS' }).Count - 20) more"
}

$Report += "`n`n**Fury Subclass Talents ($($ValidationResults.Fury | Where-Object { $_.Status -eq 'PASS' }).Count) talents)**:`n"
foreach ($Entry in ($ValidationResults.Fury | Where-Object { $_.Status -eq "PASS" } | Sort-Object Level, Column | Select-Object -First 20)) {
    $Report += "- L$($Entry.Level) Col$($Entry.Column): $($Entry.AbilityName) ($($Entry.AbilityId))`n"
}
if (($ValidationResults.Fury | Where-Object { $_.Status -eq "PASS" }).Count -gt 20) {
    $Report += "- ... and $(($ValidationResults.Fury | Where-Object { $_.Status -eq 'PASS' }).Count - 20) more`n"
}

$Report += "`n**Protection Subclass Talents ($($ValidationResults.Protection | Where-Object { $_.Status -eq 'PASS' }).Count) talents)**:`n"
foreach ($Entry in ($ValidationResults.Protection | Where-Object { $_.Status -eq "PASS" } | Sort-Object Level, Column | Select-Object -First 20)) {
    $Report += "- L$($Entry.Level) Col$($Entry.Column): $($Entry.AbilityName) ($($Entry.AbilityId))`n"
}
if (($ValidationResults.Protection | Where-Object { $_.Status -eq "PASS" }).Count -gt 20) {
    $Report += "- ... and $(($ValidationResults.Protection | Where-Object { $_.Status -eq 'PASS' }).Count - 20) more`n"
}

$Report += "`n### ❌ Discrepancies Found`n`n"
if ($FailCount -eq 0) {
    $Report += "None - All subclass talents exist in database!`n"
} else {
    $Report += "**Missing Abilities ($FailCount)**:`n"
    foreach ($Spec in @('Arms', 'Fury', 'Protection')) {
        $FailedAbilities = $ValidationResults[$Spec] | Where-Object { $_.Status -eq "FAIL" }
        if ($FailedAbilities.Count -gt 0) {
            $Report += "`n**$Spec** ($($FailedAbilities.Count)):`n"
            foreach ($Entry in $FailedAbilities) {
                $Report += "- L$($Entry.Level) Col$($Entry.Column): $($Entry.AbilityName) ($($Entry.AbilityId)) - NOT FOUND`n"
            }
        }
    }
}

$Report += "`n### ⚠️ Warnings`n`n"
if ($PotentialPrereqs.Count -gt 0) {
    $Report += "**Potential Prerequisites Detected** ($($PotentialPrereqs.Count) abilities):`n"
    $Report += "These abilities have keywords suggesting they may require prerequisites (Improved, Enhanced, etc.):`n`n"
    foreach ($Prereq in ($PotentialPrereqs | Sort-Object Spec, Level | Select-Object -First 15)) {
        $Report += "- $($Prereq.Spec) L$($Prereq.Level): $($Prereq.Ability)`n"
    }
    if ($PotentialPrereqs.Count -gt 15) {
        $Report += "- ... and $($PotentialPrereqs.Count - 15) more`n"
    }
    $Report += "`n**Note**: Prerequisite chains should be validated against Section [4] documentation.`n"
} else {
    $Report += "None - Standard talent validation complete.`n"
}

$Report += @"

---

## Evidence: Talent Counts by Subclass

| Subclass | Columns | Talents Found | Auto-Grants (L1) | Choice Nodes | Status |
|----------|---------|---------------|------------------|--------------|--------|
| Arms | 13 (21-33) | $($SubclassTalents.Arms.Count) | $(($ValidationResults.Arms | Where-Object { $_.Level -eq 1 }).Count) | $(($ValidationResults.Arms | Where-Object { $_.Level -gt 1 }).Count) | $(if (($ValidationResults.Arms | Where-Object { $_.Status -eq 'FAIL' }).Count -eq 0) { "✅ PASS" } else { "❌ FAIL" }) |
| Fury | 13 (34-46) | $($SubclassTalents.Fury.Count) | $(($ValidationResults.Fury | Where-Object { $_.Level -eq 1 }).Count) | $(($ValidationResults.Fury | Where-Object { $_.Level -gt 1 }).Count) | $(if (($ValidationResults.Fury | Where-Object { $_.Status -eq 'FAIL' }).Count -eq 0) { "✅ PASS" } else { "❌ FAIL" }) |
| Protection | 8 (47-54) | $($SubclassTalents.Protection.Count) | $(($ValidationResults.Protection | Where-Object { $_.Level -eq 1 }).Count) | $(($ValidationResults.Protection | Where-Object { $_.Level -gt 1 }).Count) | $(if (($ValidationResults.Protection | Where-Object { $_.Status -eq 'FAIL' }).Count -eq 0) { "✅ PASS" } else { "❌ FAIL" }) |
| **TOTAL** | **34** | **$($SubclassTalents.Arms.Count + $SubclassTalents.Fury.Count + $SubclassTalents.Protection.Count)** | **$(($ValidationResults.Arms + $ValidationResults.Fury + $ValidationResults.Protection | Where-Object { $_.Level -eq 1 }).Count)** | **$(($ValidationResults.Arms + $ValidationResults.Fury + $ValidationResults.Protection | Where-Object { $_.Level -gt 1 }).Count)** | $(if ($FailCount -eq 0) { "✅ PASS" } else { "❌ FAIL" }) |

---

## Analysis: Talent Distribution by Level

### Arms Subclass
"@

$ArmsByLevel = $ValidationResults.Arms | Group-Object -Property Level | Sort-Object { [int]$_.Name }
foreach ($LevelGroup in $ArmsByLevel) {
    $Report += "`n- **L$($LevelGroup.Name)**: $($LevelGroup.Count) talents"
}

$Report += "`n`n### Fury Subclass`n"
$FuryByLevel = $ValidationResults.Fury | Group-Object -Property Level | Sort-Object { [int]$_.Name }
foreach ($LevelGroup in $FuryByLevel) {
    $Report += "`n- **L$($LevelGroup.Name)**: $($LevelGroup.Count) talents"
}

$Report += "`n`n### Protection Subclass`n"
$ProtectionByLevel = $ValidationResults.Protection | Group-Object -Property Level | Sort-Object { [int]$_.Name }
foreach ($LevelGroup in $ProtectionByLevel) {
    $Report += "`n- **L$($LevelGroup.Name)**: $($LevelGroup.Count) talents"
}

$Report += @"


---

## Recommendations

$(if ($FailCount -eq 0) {
    "**No corrections needed!** All subclass talents validated successfully."
} else {
    "1. **Add Missing Abilities to Database**: $FailCount abilities not found in AbilityDatabase_Warrior_FullyEnriched.csv"
})

$(if ($PotentialPrereqs.Count -gt 0) {
    "`n2. **Validate Prerequisite Chains**: $($PotentialPrereqs.Count) abilities with prerequisite keywords detected. Cross-reference with Section [4] documentation to ensure prerequisite chains are correct."
} else {
    ""
})

---

## Next Steps

$(if ($FailCount -eq 0) {
    "✅ **Phase 3 Complete** - Ready for PHASE 4: Hero Talents Validation"
} else {
    "⚠️ **Action Required**: Fix discrepancies before proceeding to Phase 4"
})

---

## Validation Statistics

- **Total Abilities Checked**: $($SubclassTalents.Arms.Count + $SubclassTalents.Fury.Count + $SubclassTalents.Protection.Count)
- **Passed**: $(($ValidationResults.Arms + $ValidationResults.Fury + $ValidationResults.Protection | Where-Object { $_.Status -eq 'PASS' }).Count)
- **Failed**: $FailCount
- **Success Rate**: $(if (($SubclassTalents.Arms.Count + $SubclassTalents.Fury.Count + $SubclassTalents.Protection.Count) -gt 0) { [math]::Round((($ValidationResults.Arms + $ValidationResults.Fury + $ValidationResults.Protection | Where-Object { $_.Status -eq 'PASS' }).Count / ($SubclassTalents.Arms.Count + $SubclassTalents.Fury.Count + $SubclassTalents.Protection.Count)) * 100, 1) } else { 0 })%

---

**Generated**: $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")  
**Script**: Phase3_Subclass_Talents_Validation.ps1
"@

# Write report
$Report | Out-File $OutputPath -Encoding UTF8
Write-Host "[PASS] Report generated: $OutputPath" -ForegroundColor Green

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "PHASE 3 VALIDATION COMPLETE" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Result: $(if ($FailCount -eq 0) { "PASS ✅" } else { "FAIL ❌" })" -ForegroundColor $(if ($FailCount -eq 0) { "Green" } else { "Red" })
Write-Host "Report: $OutputPath" -ForegroundColor Cyan
Write-Host ""

if ($FailCount -eq 0) {
    exit 0
} else {
    exit 1
}
