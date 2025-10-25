# PHASE 5: Feats + ASI Validation
# Validates BG3 core features (Extra Attack, Feats, ASI) in progression table

param(
    [string]$LinkedPath = "C:\Users\tenod\source\repos\BG3Mods\Documentation\00_SourcesOfTruth\Warrior Progression LINKED - Main.csv",
    [string]$OutputPath = "C:\Users\tenod\source\repos\BG3Mods\Documentation\00_SourcesOfTruth\ValidationReports\PHASE5_FEATS_ASI_VALIDATION.md"
)

Write-Host "[INFO] Starting PHASE 5: Feats + ASI Validation" -ForegroundColor Cyan
Write-Host ""

# Load LINKED CSV
Write-Host "[STEP 1] Loading LINKED CSV..." -ForegroundColor Yellow
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
Write-Host "[STEP 2] Extracting BG3 Core Features (Columns 2-3)" -ForegroundColor Yellow

$BG3Features = @{
    ExtraAttack = @()
    Feats = @()
}

# Process all 20 levels
foreach ($i in 0..19) {
    $Level = $i + 1
    $Row = $DataLines[$i]
    $Cells = $Row -split ','
    
    # Column 2: Extra Attack or other grants
    if ($Cells[2] -match 'Extra Attack') {
        $BG3Features.ExtraAttack += @{
            Level = $Level
            Column = 2
            Text = $Cells[2]
        }
        Write-Host "  L$Level Col2: Extra Attack granted" -ForegroundColor Green
    }
    
    # Column 3: Feats
    if ($Cells[3] -match 'Add Feat') {
        $BG3Features.Feats += @{
            Level = $Level
            Column = 3
            Text = $Cells[3]
        }
        Write-Host "  L$Level Col3: Feat milestone" -ForegroundColor Cyan
    }
}

Write-Host ""
Write-Host "[PASS] BG3 core features extracted" -ForegroundColor Green
Write-Host "  - Extra Attack grants: $($BG3Features.ExtraAttack.Count)" -ForegroundColor Cyan
Write-Host "  - Feat milestones: $($BG3Features.Feats.Count)" -ForegroundColor Cyan

Write-Host ""
Write-Host "[STEP 3] Validating Extra Attack" -ForegroundColor Yellow

$ExtraAttackExpected = 5
$ExtraAttackIssues = @()

if ($BG3Features.ExtraAttack.Count -eq 0) {
    Write-Host "[FAIL] No Extra Attack found! Expected at L5" -ForegroundColor Red
    $ExtraAttackIssues += "Missing Extra Attack grant"
} elseif ($BG3Features.ExtraAttack.Count -eq 1) {
    $ExtraAttackLevel = $BG3Features.ExtraAttack[0].Level
    if ($ExtraAttackLevel -eq $ExtraAttackExpected) {
        Write-Host "[PASS] Extra Attack granted at L$ExtraAttackLevel (correct)" -ForegroundColor Green
    } else {
        Write-Host "[WARN] Extra Attack at L$ExtraAttackLevel (expected L$ExtraAttackExpected)" -ForegroundColor Yellow
        $ExtraAttackIssues += "Extra Attack at wrong level (L$ExtraAttackLevel, expected L$ExtraAttackExpected)"
    }
} else {
    Write-Host "[WARN] Multiple Extra Attack grants found: $($BG3Features.ExtraAttack.Count)" -ForegroundColor Yellow
    $ExtraAttackIssues += "Multiple Extra Attack grants (expected 1)"
}

Write-Host ""
Write-Host "[STEP 4] Validating Feat Milestones" -ForegroundColor Yellow

$FeatExpectedLevels = @(4, 8, 12, 16, 19, 20)
$FeatIssues = @()

Write-Host "  Expected feat levels: $($FeatExpectedLevels -join ', ')" -ForegroundColor Gray
Write-Host "  Actual feat levels: $(($BG3Features.Feats | ForEach-Object { $_.Level }) -join ', ')" -ForegroundColor Gray

foreach ($ExpectedLevel in $FeatExpectedLevels) {
    $Found = $BG3Features.Feats | Where-Object { $_.Level -eq $ExpectedLevel }
    if ($Found) {
        Write-Host "  [PASS] Feat at L$ExpectedLevel" -ForegroundColor Green
    } else {
        Write-Host "  [FAIL] Missing feat at L$ExpectedLevel" -ForegroundColor Red
        $FeatIssues += "Missing feat at L$ExpectedLevel"
    }
}

# Check for unexpected feat levels
$ActualLevels = $BG3Features.Feats | ForEach-Object { $_.Level }
$UnexpectedLevels = $ActualLevels | Where-Object { $FeatExpectedLevels -notcontains $_ }
if ($UnexpectedLevels.Count -gt 0) {
    Write-Host "  [WARN] Unexpected feat levels: $($UnexpectedLevels -join ', ')" -ForegroundColor Yellow
    foreach ($Level in $UnexpectedLevels) {
        $FeatIssues += "Unexpected feat at L$Level"
    }
}

Write-Host ""
Write-Host "[STEP 5] Checking for ASI (Ability Score Improvement)" -ForegroundColor Yellow

# ASI in BG3 is typically bundled with Feats (player chooses Feat OR ASI)
# Check if there's any ASI-specific notation in the CSV
$ASIFound = $false
foreach ($Row in $DataLines) {
    if ($Row -match 'ASI|Ability Score') {
        $ASIFound = $true
        Write-Host "[INFO] Found ASI notation in CSV" -ForegroundColor Cyan
        break
    }
}

if (-not $ASIFound) {
    Write-Host "[INFO] No explicit ASI notation found" -ForegroundColor Cyan
    Write-Host "  In BG3, ASI is bundled with Feat choice (player picks Feat OR +2 ASI)" -ForegroundColor Gray
}

Write-Host ""
Write-Host "[STEP 6] Generating Validation Report" -ForegroundColor Yellow

$TotalIssues = $ExtraAttackIssues.Count + $FeatIssues.Count

# Create report
$Report = @"
# PHASE 5: Feats + ASI Validation Report

**Date**: $(Get-Date -Format "MMMM d, yyyy")  
**Phase**: 5 of 7  
**Status**: Complete  
**Validation Result**: $(if ($TotalIssues -eq 0) { "PASS" } else { "FAIL" })

---

## Summary

Validated BG3 core features (Extra Attack, Feats, ASI) in the Warrior Progression LINKED CSV:
- **Extra Attack** (martial class feature at L5)
- **Feat milestones** (L4, L8, L12, L16, L19, L20 = 6 total)
- **ASI** (Ability Score Improvement - bundled with Feat choice in BG3)

**Validation Findings**:
- $(if ($ExtraAttackIssues.Count -eq 0) { "[PASS]" } else { "[FAIL]" }) Extra Attack: $(if ($ExtraAttackIssues.Count -eq 0) { "Correct (L5)" } else { "$($ExtraAttackIssues.Count) issue(s)" })
- $(if ($FeatIssues.Count -eq 0) { "[PASS]" } else { "[FAIL]" }) Feat Milestones: $(if ($FeatIssues.Count -eq 0) { "All 6 present" } else { "$($FeatIssues.Count) issue(s)" })
- [INFO] ASI: $(if ($ASIFound) { "Explicit notation found" } else { "Bundled with Feat choice (BG3 standard)" })

---

## Validation Findings

$Report += "`n### [CORRECT] Correct Elements`n`n"

**Extra Attack**:
"@

if ($BG3Features.ExtraAttack.Count -gt 0) {
    foreach ($EA in $BG3Features.ExtraAttack) {
        $Report += "`n- L$($EA.Level): $($EA.Text) (Column $($EA.Column))"
    }
} else {
    $Report += "`n- None found"
}

$Report += "`n`n**Feat Milestones**:`n"
if ($BG3Features.Feats.Count -gt 0) {
    foreach ($Feat in ($BG3Features.Feats | Sort-Object { $_.Level })) {
        $Report += "- L$($Feat.Level): $($Feat.Text) (Column $($Feat.Column))`n"
    }
} else {
    $Report += "- None found`n"
}

$Report += "`n### [DISCREPANCIES] Discrepancies Found`n`n"
if ($TotalIssues -eq 0) {
    $Report += "None - All BG3 core features are correct!`n"
} else {
    if ($ExtraAttackIssues.Count -gt 0) {
        $Report += "**Extra Attack Issues ($($ExtraAttackIssues.Count))**:`n"
        foreach ($Issue in $ExtraAttackIssues) {
            $Report += "- $Issue`n"
        }
        $Report += "`n"
    }
    
    if ($FeatIssues.Count -gt 0) {
        $Report += "**Feat Milestone Issues ($($FeatIssues.Count))**:`n"
        foreach ($Issue in $FeatIssues) {
            $Report += "- $Issue`n"
        }
    }
}

$Report += "`n### [INFO] BG3 Mechanics Note`n`n"
$Report += "**Feat vs ASI**: In Baldur's Gate 3, Ability Score Improvement (ASI) is not a separate feature. At feat levels (L4/8/12/16/19/20), players choose EITHER:`n"
$Report += "- A Feat (special ability/bonus)`n"
$Report += "- +2 to one ability score (or +1 to two different scores)`n`n"
$Report += "This is the standard D&D 5e system. The progression table correctly shows 'Add Feat' as the milestone, with ASI being an implicit alternative choice.`n"

$Report += @"

---

## Evidence: BG3 Core Features Summary

| Feature | Expected | Found | Levels | Status |
|---------|----------|-------|--------|--------|
| Extra Attack | L5 (1x) | $($BG3Features.ExtraAttack.Count)x | $(if ($BG3Features.ExtraAttack.Count -gt 0) { ($BG3Features.ExtraAttack | ForEach-Object { "L$($_.Level)" }) -join ', ' } else { "None" }) | $(if ($ExtraAttackIssues.Count -eq 0) { "[PASS]" } else { "[FAIL]" }) |
| Feat Milestones | L4,8,12,16,19,20 (6x) | $($BG3Features.Feats.Count)x | $(if ($BG3Features.Feats.Count -gt 0) { ($BG3Features.Feats | Sort-Object { $_.Level } | ForEach-Object { "L$($_.Level)" }) -join ', ' } else { "None" }) | $(if ($FeatIssues.Count -eq 0) { "[PASS]" } else { "[FAIL]" }) |
| ASI (explicit) | Bundled with Feats | $(if ($ASIFound) { "Found" } else { "Not shown" }) | N/A | [INFO] |

---

## Analysis: Level-by-Level Breakdown

| Level | Extra Attack | Feat | Warrior Abilities | Notes |
|-------|--------------|------|-------------------|-------|
"@

for ($i = 0; $i -lt 20; $i++) {
    $Level = $i + 1
    $Row = $DataLines[$i]
    $Cells = $Row -split ','
    
    $EA = if ($BG3Features.ExtraAttack | Where-Object { $_.Level -eq $Level }) { "[YES]" } else { "" }
    $Feat = if ($BG3Features.Feats | Where-Object { $_.Level -eq $Level }) { "[YES] Feat" } else { "" }
    
    # Count Warrior abilities in this row
    $WarriorCount = ([regex]::Matches($Row, "WAR_")).Count
    
    $Notes = ""
    if ($Level -eq 5) { $Notes = "Martial class feature" }
    if ($Level -eq 13) { $Notes = "Hero talent keystone" }
    if ($Level -eq 20) { $Notes = "Max level + capstone" }
    
    $Report += "`n| L$Level | $EA | $Feat | $WarriorCount abilities | $Notes |"
}

$Report += @"


---

## Recommendations

$(if ($TotalIssues -eq 0) {
    "**No corrections needed!** All BG3 core features validated successfully."
} else {
    "**Action Required**: Fix the following issues:"
})

$(if ($ExtraAttackIssues.Count -gt 0) {
    "`n**Extra Attack**:`n" + ($ExtraAttackIssues | ForEach-Object { "- $_`n" }) -join ""
} else {
    ""
})

$(if ($FeatIssues.Count -gt 0) {
    "`n**Feat Milestones**:`n" + ($FeatIssues | ForEach-Object { "- $_`n" }) -join ""
} else {
    ""
})

---

## Next Steps

$(if ($TotalIssues -eq 0) {
    "[PASS] **Phase 5 Complete** - Ready for PHASE 6: Choice Count Validation"
} else {
    "[ACTION REQUIRED] **Action Required**: Fix discrepancies before proceeding to Phase 6"
})

---

## Validation Statistics

- **Extra Attack Issues**: $($ExtraAttackIssues.Count)
- **Feat Milestone Issues**: $($FeatIssues.Count)
- **Total Issues**: $TotalIssues
- **Success**: $(if ($TotalIssues -eq 0) { "100%" } else { "Partial" })

---

**Generated**: $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")  
**Script**: Phase5_Feats_ASI_Validation.ps1
"@

# Write report
$Report | Out-File $OutputPath -Encoding UTF8
Write-Host "[PASS] Report generated: $OutputPath" -ForegroundColor Green

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "PHASE 5 VALIDATION COMPLETE" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Result: $(if ($TotalIssues -eq 0) { "PASS ✅" } else { "FAIL ❌" })" -ForegroundColor $(if ($TotalIssues -eq 0) { "Green" } else { "Red" })
Write-Host "Report: $OutputPath" -ForegroundColor Cyan
Write-Host ""

if ($TotalIssues -eq 0) {
    Write-Host "[SUMMARY] All BG3 core features validated:" -ForegroundColor Green
    Write-Host "  - Extra Attack: $($BG3Features.ExtraAttack.Count) grant(s)" -ForegroundColor Cyan
    Write-Host "  - Feat milestones: $($BG3Features.Feats.Count) total" -ForegroundColor Cyan
    exit 0
} else {
    Write-Host "[SUMMARY] Found $TotalIssues issue(s) with BG3 core features" -ForegroundColor Red
    exit 1
}
