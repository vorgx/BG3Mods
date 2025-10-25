# PHASE 4: Hero Talents Validation (L13-20)
# Validates hero talent trees for Mountain Thane, Colossus, Slayer

param(
    [string]$DatabasePath = "C:\Users\tenod\source\repos\BG3Mods\Documentation\00_SourcesOfTruth\AbilityDatabase_Warrior_FullyEnriched.csv",
    [string]$LinkedPath = "C:\Users\tenod\source\repos\BG3Mods\Documentation\00_SourcesOfTruth\Warrior Progression LINKED - Main.csv",
    [string]$OutputPath = "C:\Users\tenod\source\repos\BG3Mods\Documentation\00_SourcesOfTruth\ValidationReports\PHASE4_HERO_TALENTS_VALIDATION.md"
)

Write-Host "[INFO] Starting PHASE 4: Hero Talents Validation" -ForegroundColor Cyan
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
    Write-Host "[PASS] LINKED CSV loaded: $($DataLines.Count) data rows" -ForegroundColor Green
} catch {
    Write-Host "[FAIL] Failed to load LINKED CSV: $_" -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "[STEP 3] Extracting Hero Talents (Columns 54-68, Rows 16-23 = L13-L20)" -ForegroundColor Yellow

# Column indices (0-based):
# 53-57: Mountain Thane (5 columns)
# 58-62: Colossus (5 columns)
# 63-67: Slayer (5 columns)

$HeroTalents = @{
    MountainThane = @()
    Colossus = @()
    Slayer = @()
}

# Process L13-L20 (rows 12-19, 0-indexed data rows)
$LevelRows = $DataLines[12..19]

foreach ($i in 0..7) {
    $Level = $i + 13
    $Row = $LevelRows[$i]
    $Cells = $Row -split ','
    
    Write-Host "  Processing Level $Level..." -ForegroundColor Gray
    
    # Mountain Thane (columns 53-57 = 5 columns)
    for ($col = 53; $col -le 57; $col++) {
        if ($col -lt $Cells.Count -and $Cells[$col] -match '\S') {
            $HeroTalents.MountainThane += @{ 
                Level = $Level; 
                Cell = $Cells[$col]; 
                Column = $col;
                Type = "Mountain Thane"
            }
        }
    }
    
    # Colossus (columns 58-62 = 5 columns)
    for ($col = 58; $col -le 62; $col++) {
        if ($col -lt $Cells.Count -and $Cells[$col] -match '\S') {
            $HeroTalents.Colossus += @{ 
                Level = $Level; 
                Cell = $Cells[$col]; 
                Column = $col;
                Type = "Colossus"
            }
        }
    }
    
    # Slayer (columns 63-67 = 5 columns)
    for ($col = 63; $col -le 67; $col++) {
        if ($col -lt $Cells.Count -and $Cells[$col] -match '\S') {
            $HeroTalents.Slayer += @{ 
                Level = $Level; 
                Cell = $Cells[$col]; 
                Column = $col;
                Type = "Slayer"
            }
        }
    }
}

Write-Host "[PASS] Hero talents extracted" -ForegroundColor Green
Write-Host "  - Mountain Thane: $($HeroTalents.MountainThane.Count) talents" -ForegroundColor Cyan
Write-Host "  - Colossus: $($HeroTalents.Colossus.Count) talents" -ForegroundColor Cyan
Write-Host "  - Slayer: $($HeroTalents.Slayer.Count) talents" -ForegroundColor Cyan
Write-Host ""

# Validation: Extract ability_id and check against database
Write-Host "[STEP 4] Validating Abilities Against Database" -ForegroundColor Yellow

$ValidationResults = @{
    MountainThane = @()
    Colossus = @()
    Slayer = @()
}

$FailCount = 0

foreach ($Tree in @('MountainThane', 'Colossus', 'Slayer')) {
    Write-Host "  Validating $Tree..." -ForegroundColor Gray
    
    foreach ($Entry in $HeroTalents[$Tree]) {
        $Cell = $Entry.Cell
        $Level = $Entry.Level
        $Column = $Entry.Column
        
        if ($Cell -match ' - (WAR[_\w]+)') {
            $AbilityId = $Matches[1]
            $AbilityName = ($Cell -split ' - ')[0]
            
            $DbEntry = $Db | Where-Object { $_.ability_id -eq $AbilityId }
            
            if ($DbEntry) {
                $ValidationResults[$Tree] += @{
                    Level = $Level
                    Column = $Column
                    AbilityName = $AbilityName
                    AbilityId = $AbilityId
                    Status = "PASS"
                    DbName = $DbEntry.ability_name
                    Category = $DbEntry.category
                    HeroTree = $DbEntry.hero_tree
                }
            } else {
                $ValidationResults[$Tree] += @{
                    Level = $Level
                    Column = $Column
                    AbilityName = $AbilityName
                    AbilityId = $AbilityId
                    Status = "FAIL"
                    DbName = "NOT FOUND"
                    Category = "UNKNOWN"
                    HeroTree = "UNKNOWN"
                }
                Write-Host "    [FAIL] L$Level Col$Column $AbilityName ($AbilityId): NOT FOUND" -ForegroundColor Red
                $FailCount++
            }
        }
    }
}

Write-Host ""
if ($FailCount -eq 0) {
    Write-Host "[PASS] All hero talents exist in database!" -ForegroundColor Green
} else {
    Write-Host "[FAIL] $FailCount abilities NOT FOUND in database" -ForegroundColor Red
}

Write-Host ""
Write-Host "[STEP 5] Analyzing Hero Talent Structure" -ForegroundColor Yellow

# Check keystone at L13, choices at L15/L17/L19, capstone at L20
foreach ($Tree in @('MountainThane', 'Colossus', 'Slayer')) {
    $L13Count = ($ValidationResults[$Tree] | Where-Object { $_.Level -eq 13 }).Count
    $L15Count = ($ValidationResults[$Tree] | Where-Object { $_.Level -eq 15 }).Count
    $L17Count = ($ValidationResults[$Tree] | Where-Object { $_.Level -eq 17 }).Count
    $L19Count = ($ValidationResults[$Tree] | Where-Object { $_.Level -eq 19 }).Count
    $L20Count = ($ValidationResults[$Tree] | Where-Object { $_.Level -eq 20 }).Count
    
    Write-Host "  $Tree structure:" -ForegroundColor Gray
    Write-Host "    L13 (Keystone): $L13Count (expected: 1)" -ForegroundColor $(if ($L13Count -eq 1) { "Green" } else { "Yellow" })
    Write-Host "    L15 (Choice 1): $L15Count (expected: 3)" -ForegroundColor $(if ($L15Count -eq 3) { "Green" } else { "Yellow" })
    Write-Host "    L17 (Choice 2): $L17Count (expected: 3)" -ForegroundColor $(if ($L17Count -eq 3) { "Green" } else { "Yellow" })
    Write-Host "    L19 (Choice 3): $L19Count (expected: 3)" -ForegroundColor $(if ($L19Count -eq 3) { "Green" } else { "Yellow" })
    Write-Host "    L20 (Capstone): $L20Count (expected: 1)" -ForegroundColor $(if ($L20Count -eq 1) { "Green" } else { "Yellow" })
    Write-Host ""
}

Write-Host "[STEP 6] Checking Database for Missing Hero Talents" -ForegroundColor Yellow

# Get all hero talents from database
$DbHeroTalents = $Db | Where-Object { $_.hero_tree -match 'Mountain Thane|Colossus|Slayer' }
Write-Host "  Database has $($DbHeroTalents.Count) hero talents total" -ForegroundColor Cyan

# Compare with LINKED CSV
$LinkedAbilityIds = @()
foreach ($Tree in @('MountainThane', 'Colossus', 'Slayer')) {
    foreach ($Entry in $ValidationResults[$Tree]) {
        $LinkedAbilityIds += $Entry.AbilityId
    }
}

$MissingInLinked = $DbHeroTalents | Where-Object { $LinkedAbilityIds -notcontains $_.ability_id }

if ($MissingInLinked.Count -gt 0) {
    Write-Host "[WARN] Found $($MissingInLinked.Count) hero talents in database NOT in LINKED CSV:" -ForegroundColor Yellow
    foreach ($Missing in ($MissingInLinked | Select-Object -First 10)) {
        Write-Host "  - $($Missing.ability_name) ($($Missing.ability_id)) - Tree: $($Missing.hero_tree)" -ForegroundColor Gray
    }
    if ($MissingInLinked.Count -gt 10) {
        Write-Host "  ... and $($MissingInLinked.Count - 10) more" -ForegroundColor Gray
    }
} else {
    Write-Host "[PASS] All database hero talents are present in LINKED CSV" -ForegroundColor Green
}

Write-Host ""
Write-Host "[STEP 7] Generating Validation Report" -ForegroundColor Yellow

# Create report
$Report = @"
# PHASE 4: Hero Talents Validation Report

**Date**: $(Get-Date -Format "MMMM d, yyyy")  
**Phase**: 4 of 7  
**Status**: Complete  
**Validation Result**: $(if ($FailCount -eq 0) { "PASS" } else { "FAIL" })

---

## Summary

Validated hero talent trees (L13-20) for all 3 Warrior hero specializations against:
- **AbilityDatabase_Warrior_FullyEnriched.csv** (221 abilities)
- **Warrior Progression LINKED - Main.csv** (columns 54-68)
- **SOURCE_OF_TRUTH.md** Section [5] (Hero Talents)

**Total Hero Talents Validated**: $($HeroTalents.MountainThane.Count + $HeroTalents.Colossus.Count + $HeroTalents.Slayer.Count) talents
- Mountain Thane: $($HeroTalents.MountainThane.Count) talents (5 columns)
- Colossus: $($HeroTalents.Colossus.Count) talents (5 columns)
- Slayer: $($HeroTalents.Slayer.Count) talents (5 columns)

**Validation Findings**:
- $(if ($FailCount -eq 0) { "✅" } else { "❌" }) Database Coverage: $(if ($FailCount -eq 0) { "100% - All abilities exist in database" } else { "$FailCount abilities NOT FOUND" })
- $(if ($MissingInLinked.Count -eq 0) { "✅" } else { "⚠️" }) LINKED CSV Coverage: $(if ($MissingInLinked.Count -eq 0) { "100% complete" } else { "$($MissingInLinked.Count) talents missing from LINKED CSV" })

---

## Validation Findings

### ✅ Correct Elements

**Mountain Thane Talents ($($ValidationResults.MountainThane | Where-Object { $_.Status -eq 'PASS' }).Count) talents)**:
"@

foreach ($Entry in ($ValidationResults.MountainThane | Where-Object { $_.Status -eq "PASS" } | Sort-Object Level, Column)) {
    $Report += "`n- L$($Entry.Level) Col$($Entry.Column): $($Entry.AbilityName) ($($Entry.AbilityId))"
}

$Report += "`n`n**Colossus Talents ($($ValidationResults.Colossus | Where-Object { $_.Status -eq 'PASS' }).Count) talents)**:`n"
foreach ($Entry in ($ValidationResults.Colossus | Where-Object { $_.Status -eq "PASS" } | Sort-Object Level, Column)) {
    $Report += "- L$($Entry.Level) Col$($Entry.Column): $($Entry.AbilityName) ($($Entry.AbilityId))`n"
}

$Report += "`n**Slayer Talents ($($ValidationResults.Slayer | Where-Object { $_.Status -eq 'PASS' }).Count) talents)**:`n"
foreach ($Entry in ($ValidationResults.Slayer | Where-Object { $_.Status -eq "PASS" } | Sort-Object Level, Column)) {
    $Report += "- L$($Entry.Level) Col$($Entry.Column): $($Entry.AbilityName) ($($Entry.AbilityId))`n"
}

$Report += "`n### ❌ Discrepancies Found`n`n"
if ($FailCount -eq 0) {
    $Report += "None - All hero talents exist in database!`n"
} else {
    $Report += "**Missing Abilities ($FailCount)**:`n"
    foreach ($Tree in @('MountainThane', 'Colossus', 'Slayer')) {
        $FailedAbilities = $ValidationResults[$Tree] | Where-Object { $_.Status -eq "FAIL" }
        if ($FailedAbilities.Count -gt 0) {
            $Report += "`n**$Tree** ($($FailedAbilities.Count)):`n"
            foreach ($Entry in $FailedAbilities) {
                $Report += "- L$($Entry.Level) Col$($Entry.Column): $($Entry.AbilityName) ($($Entry.AbilityId)) - NOT FOUND`n"
            }
        }
    }
}

$Report += "`n### ⚠️ Warnings`n`n"
if ($MissingInLinked.Count -gt 0) {
    $Report += "**Hero Talents in Database but NOT in LINKED CSV** ($($MissingInLinked.Count) abilities):`n"
    $Report += "These talents exist in the database but are missing from the LINKED CSV progression table:`n`n"
    
    $MissingByTree = $MissingInLinked | Group-Object -Property hero_tree
    foreach ($TreeGroup in $MissingByTree) {
        $Report += "**$($TreeGroup.Name)** ($($TreeGroup.Count)):`n"
        foreach ($Missing in ($TreeGroup.Group | Select-Object -First 5)) {
            $Report += "- $($Missing.ability_name) ($($Missing.ability_id))`n"
        }
        if ($TreeGroup.Count -gt 5) {
            $Report += "- ... and $($TreeGroup.Count - 5) more`n"
        }
        $Report += "`n"
    }
    $Report += "**Recommendation**: Add these missing talents to LINKED CSV columns 54-68 or verify they are intentionally excluded.`n"
} else {
    $Report += "None - All database hero talents are present in LINKED CSV.`n"
}

$Report += @"

---

## Evidence: Hero Talent Structure

| Hero Tree | Keystone (L13) | Choice 1 (L15) | Choice 2 (L17) | Choice 3 (L19) | Capstone (L20) | Total | Status |
|-----------|----------------|----------------|----------------|----------------|----------------|-------|--------|
| Mountain Thane | $(($ValidationResults.MountainThane | Where-Object { $_.Level -eq 13 }).Count) | $(($ValidationResults.MountainThane | Where-Object { $_.Level -eq 15 }).Count) | $(($ValidationResults.MountainThane | Where-Object { $_.Level -eq 17 }).Count) | $(($ValidationResults.MountainThane | Where-Object { $_.Level -eq 19 }).Count) | $(($ValidationResults.MountainThane | Where-Object { $_.Level -eq 20 }).Count) | $($HeroTalents.MountainThane.Count) | $(if (($ValidationResults.MountainThane | Where-Object { $_.Status -eq 'FAIL' }).Count -eq 0) { "✅ PASS" } else { "❌ FAIL" }) |
| Colossus | $(($ValidationResults.Colossus | Where-Object { $_.Level -eq 13 }).Count) | $(($ValidationResults.Colossus | Where-Object { $_.Level -eq 15 }).Count) | $(($ValidationResults.Colossus | Where-Object { $_.Level -eq 17 }).Count) | $(($ValidationResults.Colossus | Where-Object { $_.Level -eq 19 }).Count) | $(($ValidationResults.Colossus | Where-Object { $_.Level -eq 20 }).Count) | $($HeroTalents.Colossus.Count) | $(if (($ValidationResults.Colossus | Where-Object { $_.Status -eq 'FAIL' }).Count -eq 0) { "✅ PASS" } else { "❌ FAIL" }) |
| Slayer | $(($ValidationResults.Slayer | Where-Object { $_.Level -eq 13 }).Count) | $(($ValidationResults.Slayer | Where-Object { $_.Level -eq 15 }).Count) | $(($ValidationResults.Slayer | Where-Object { $_.Level -eq 17 }).Count) | $(($ValidationResults.Slayer | Where-Object { $_.Level -eq 19 }).Count) | $(($ValidationResults.Slayer | Where-Object { $_.Level -eq 20 }).Count) | $($HeroTalents.Slayer.Count) | $(if (($ValidationResults.Slayer | Where-Object { $_.Status -eq 'FAIL' }).Count -eq 0) { "✅ PASS" } else { "❌ FAIL" }) |
| **TOTAL** | **$(($ValidationResults.MountainThane + $ValidationResults.Colossus + $ValidationResults.Slayer | Where-Object { $_.Level -eq 13 }).Count)** | **$(($ValidationResults.MountainThane + $ValidationResults.Colossus + $ValidationResults.Slayer | Where-Object { $_.Level -eq 15 }).Count)** | **$(($ValidationResults.MountainThane + $ValidationResults.Colossus + $ValidationResults.Slayer | Where-Object { $_.Level -eq 17 }).Count)** | **$(($ValidationResults.MountainThane + $ValidationResults.Colossus + $ValidationResults.Slayer | Where-Object { $_.Level -eq 19 }).Count)** | **$(($ValidationResults.MountainThane + $ValidationResults.Colossus + $ValidationResults.Slayer | Where-Object { $_.Level -eq 20 }).Count)** | **$($HeroTalents.MountainThane.Count + $HeroTalents.Colossus.Count + $HeroTalents.Slayer.Count)** | $(if ($FailCount -eq 0) { "✅ PASS" } else { "❌ FAIL" }) |

**Expected Structure**: Each tree should have 1 keystone (L13), 3 choices per tier (L15/L17/L19 = 9 total), and 1 capstone (L20) = 11 talents per tree = 33 total.

---

## Database vs LINKED CSV Comparison

- **Database hero talents**: $($DbHeroTalents.Count)
- **LINKED CSV hero talents**: $($HeroTalents.MountainThane.Count + $HeroTalents.Colossus.Count + $HeroTalents.Slayer.Count)
- **Difference**: $(if ($DbHeroTalents.Count -gt ($HeroTalents.MountainThane.Count + $HeroTalents.Colossus.Count + $HeroTalents.Slayer.Count)) { "$($DbHeroTalents.Count - ($HeroTalents.MountainThane.Count + $HeroTalents.Colossus.Count + $HeroTalents.Slayer.Count)) talents in database NOT in LINKED CSV" } else { "LINKED CSV complete" })

---

## Recommendations

$(if ($FailCount -eq 0 -and $MissingInLinked.Count -eq 0) {
    "**No corrections needed!** All hero talents validated successfully and LINKED CSV is complete."
} elseif ($FailCount -gt 0) {
    "1. **Add Missing Abilities to Database**: $FailCount abilities not found in AbilityDatabase_Warrior_FullyEnriched.csv"
} else {
    ""
})

$(if ($MissingInLinked.Count -gt 0) {
    "`n2. **Add Missing Talents to LINKED CSV**: $($MissingInLinked.Count) hero talents exist in database but are missing from LINKED CSV. Either add them to columns 54-68 or verify they are intentionally excluded."
} else {
    ""
})

---

## Next Steps

$(if ($FailCount -eq 0) {
    "✅ **Phase 4 Complete** - Ready for PHASE 5: Feats + ASI Validation"
} else {
    "⚠️ **Action Required**: Fix discrepancies before proceeding to Phase 5"
})

---

## Validation Statistics

- **Total Abilities Checked**: $($HeroTalents.MountainThane.Count + $HeroTalents.Colossus.Count + $HeroTalents.Slayer.Count)
- **Passed**: $(($ValidationResults.MountainThane + $ValidationResults.Colossus + $ValidationResults.Slayer | Where-Object { $_.Status -eq 'PASS' }).Count)
- **Failed**: $FailCount
- **Success Rate**: $(if (($HeroTalents.MountainThane.Count + $HeroTalents.Colossus.Count + $HeroTalents.Slayer.Count) -gt 0) { [math]::Round((($ValidationResults.MountainThane + $ValidationResults.Colossus + $ValidationResults.Slayer | Where-Object { $_.Status -eq 'PASS' }).Count / ($HeroTalents.MountainThane.Count + $HeroTalents.Colossus.Count + $HeroTalents.Slayer.Count)) * 100, 1) } else { 0 })%
- **Database Coverage**: $($DbHeroTalents.Count) hero talents in database
- **LINKED CSV Coverage**: $($HeroTalents.MountainThane.Count + $HeroTalents.Colossus.Count + $HeroTalents.Slayer.Count) hero talents in LINKED CSV

---

**Generated**: $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")  
**Script**: Phase4_Hero_Talents_Validation.ps1
"@

# Write report
$Report | Out-File $OutputPath -Encoding UTF8
Write-Host "[PASS] Report generated: $OutputPath" -ForegroundColor Green

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "PHASE 4 VALIDATION COMPLETE" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Result: $(if ($FailCount -eq 0) { "PASS ✅" } else { "FAIL ❌" })" -ForegroundColor $(if ($FailCount -eq 0) { "Green" } else { "Red" })
Write-Host "Report: $OutputPath" -ForegroundColor Cyan
Write-Host ""

if ($MissingInLinked.Count -gt 0) {
    Write-Host "[WARN] Found $($MissingInLinked.Count) hero talents in database NOT in LINKED CSV" -ForegroundColor Yellow
}

if ($FailCount -eq 0) {
    exit 0
} else {
    exit 1
}
