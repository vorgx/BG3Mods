# VERIFY_DATABASE_SECTION13.ps1
# Verifies that AbilityDatabase_Warrior_FullyEnriched.csv matches claims in SOURCE_OF_TRUTH.md Section [13]

param(
    [string]$DatabasePath = "Documentation\00_SourcesOfTruth\AbilityDatabase_Warrior_FullyEnriched.csv",
    [string]$OutputPath = "Documentation\11_ValidationReports\DATABASE_VERIFICATION_SECTION13.md"
)

Write-Host "`n=== DATABASE VERIFICATION vs SOURCE_OF_TRUTH.md Section [13] ===" -ForegroundColor Magenta
Write-Host "Date: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')`n" -ForegroundColor Cyan

# Import database
$db = Import-Csv $DatabasePath
$totalRows = $db.Count
$totalCols = $db[0].PSObject.Properties.Name.Count

# Initialize report
$report = @"
# Database Verification Report - Section [13]

**Generated**: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')  
**Database**: ``$DatabasePath``  
**Verification Against**: SOURCE_OF_TRUTH.md Section [13]

---

## Summary

"@

# Track issues
$issues = @()
$passes = @()

# === VERIFICATION 1: Total Rows ===
Write-Host "1. Verifying Total Rows..." -ForegroundColor Yellow
if ($totalRows -eq 215) {
    $passes += "✅ **Total Rows**: $totalRows (matches claim: 215)"
    Write-Host "   ✅ PASS: $totalRows rows" -ForegroundColor Green
} else {
    $issues += "❌ **Total Rows**: $totalRows (Section [13] claims: 215)"
    Write-Host "   ❌ FAIL: $totalRows rows (expected 215)" -ForegroundColor Red
}

# === VERIFICATION 2: Total Columns ===
Write-Host "2. Verifying Total Columns..." -ForegroundColor Yellow
if ($totalCols -eq 28) {
    $passes += "✅ **Total Columns**: $totalCols (matches claim: 28)"
    Write-Host "   ✅ PASS: $totalCols columns" -ForegroundColor Green
} else {
    $issues += "❌ **Total Columns**: $totalCols (Section [13] claims: 28)"
    Write-Host "   ❌ FAIL: $totalCols columns (expected 28)" -ForegroundColor Red
}

# === VERIFICATION 3: Enrichment Statistics ===
Write-Host "3. Verifying Enrichment Statistics..." -ForegroundColor Yellow
$enriched = $db | Where-Object { 
    $_.bg3_file_type -ne "" -and $_.bg3_spell_success -ne "" 
}
$enrichedCount = $enriched.Count
$enrichedPercent = [Math]::Round(($enrichedCount / $totalRows) * 100, 1)

if ($enrichedCount -eq 46) {
    $passes += "✅ **Fully Enriched**: $enrichedCount abilities (matches claim: 46, $enrichedPercent%)"
    Write-Host "   ✅ PASS: $enrichedCount enriched" -ForegroundColor Green
} else {
    $issues += "❌ **Fully Enriched**: $enrichedCount abilities (Section [13] claims: 46, $enrichedPercent%)"
    Write-Host "   ❌ FAIL: $enrichedCount enriched (expected 46)" -ForegroundColor Red
}

# === VERIFICATION 4: BG3 File Type Distribution ===
Write-Host "4. Verifying BG3 File Type Distribution..." -ForegroundColor Yellow
$fileTypes = $db | Where-Object { $_.bg3_file_type -ne "" } | Group-Object bg3_file_type

$fileTypeClaims = @{
    "Spell_Target" = 18
    "Spell_Zone" = 11
    "Spell_Shout" = 13
    "Spell_Jump" = 3
    "Spell_Projectile" = 2
    "Passive" = 4
}

$fileTypeIssues = @()
foreach ($type in $fileTypes) {
    $claimed = $fileTypeClaims[$type.Name]
    if ($claimed) {
        if ($type.Count -eq $claimed) {
            $passes += "✅ **$($type.Name)**: $($type.Count) abilities (matches claim: $claimed)"
            Write-Host "   ✅ $($type.Name): $($type.Count)" -ForegroundColor Green
        } else {
            $fileTypeIssues += "❌ **$($type.Name)**: $($type.Count) abilities (Section [13] claims: $claimed)"
            Write-Host "   ❌ $($type.Name): $($type.Count) (expected $claimed)" -ForegroundColor Red
        }
    } else {
        $fileTypeIssues += "⚠️ **$($type.Name)**: $($type.Count) abilities (not mentioned in Section [13])"
        Write-Host "   ⚠️ $($type.Name): $($type.Count) (NOT mentioned in Section [13])" -ForegroundColor Yellow
    }
}

if ($fileTypeIssues.Count -gt 0) {
    $issues += $fileTypeIssues
}

# === VERIFICATION 5: Example Abilities ===
Write-Host "5. Verifying Example Abilities..." -ForegroundColor Yellow
$examples = @{
    "Execute" = @{
        "bg3_file_type" = "Spell_Target"
        "wow_cost_rage" = "20"
        "bg3_target_conditions" = "HealthPercentage(context.Target) <= 20"
    }
    "Mortal Strike" = @{
        "bg3_file_type" = "Spell_Target"
        "wow_cost_rage" = "30"
        "bg3_spell_success" = "DealDamage(2d6+StrengthModifier,Slashing);ApplyStatus(WAR_DEEP_WOUNDS,100,3)"
    }
    "Charge" = @{
        "bg3_file_type" = "Spell_Jump"
        "bg3_spell_success" = "TeleportSource();RestoreResource(context.Source,Rage,20,0)"
    }
}

foreach ($exampleName in $examples.Keys) {
    $ability = $db | Where-Object { $_.ability_name -eq $exampleName }
    if ($ability) {
        $examplePasses = $true
        foreach ($field in $examples[$exampleName].Keys) {
            $expected = $examples[$exampleName][$field]
            $actual = $ability.$field
            if ($actual -eq $expected) {
                Write-Host "   ✅ $exampleName.$field matches" -ForegroundColor Green
            } else {
                $examplePasses = $false
                Write-Host "   ❌ $exampleName.$field mismatch" -ForegroundColor Red
                Write-Host "      Expected: $expected" -ForegroundColor Gray
                Write-Host "      Actual: $actual" -ForegroundColor Gray
            }
        }
        if ($examplePasses) {
            $passes += "✅ **Example: $exampleName** - All fields match Section [13] examples"
        } else {
            $issues += "❌ **Example: $exampleName** - Some fields don't match Section [13] examples"
        }
    } else {
        $issues += "❌ **Example: $exampleName** - NOT FOUND in database!"
        Write-Host "   ❌ $exampleName NOT FOUND" -ForegroundColor Red
    }
}

# === VERIFICATION 6: Wowhead URLs ===
Write-Host "6. Verifying Wowhead URLs..." -ForegroundColor Yellow
$wowheadCount = ($db | Where-Object { $_.implementation_notes -like "*Wowhead:*" }).Count
$wowheadPercent = [Math]::Round(($wowheadCount / $totalRows) * 100, 1)

Write-Host "   Found $wowheadCount abilities with Wowhead URLs ($wowheadPercent%)" -ForegroundColor Cyan
$passes += "ℹ️ **Wowhead URLs**: $wowheadCount abilities ($wowheadPercent%) - Section [13] claims: 45"

# === BUILD REPORT ===
Write-Host "`n=== BUILDING REPORT ===" -ForegroundColor Magenta

$report += @"

| Category | Status |
|----------|--------|
| **Total Abilities** | $totalRows |
| **Total Columns** | $totalCols |
| **Fully Enriched** | $enrichedCount ($enrichedPercent%) |
| **Wowhead URLs** | $wowheadCount ($wowheadPercent%) |
| **Issues Found** | $($issues.Count) |
| **Checks Passed** | $($passes.Count) |

---

## ✅ Checks Passed ($($passes.Count))

$($passes | ForEach-Object { "- $_`n" })

---

## ❌ Issues Found ($($issues.Count))

"@

if ($issues.Count -gt 0) {
    $report += $issues | ForEach-Object { "- $_`n" }
} else {
    $report += "**No issues found! Database matches Section [13] claims perfectly.** ✅`n"
}

# === DETAILED BREAKDOWN ===
$report += @"

---

## Detailed Breakdown

### BG3 File Type Distribution

| File Type | Count | Section [13] Claim | Status |
|-----------|-------|-------------------|--------|
"@

foreach ($type in $fileTypes | Sort-Object Count -Descending) {
    $claimed = $fileTypeClaims[$type.Name]
    if ($claimed) {
        $status = if ($type.Count -eq $claimed) { "✅ Match" } else { "❌ Mismatch" }
    } else {
        $claimed = "Not mentioned"
        $status = "⚠️ Extra"
    }
    $report += "| $($type.Name) | $($type.Count) | $claimed | $status |`n"
}

# === ENRICHMENT ANALYSIS ===
$report += @"

---

### Enrichment Analysis

**Definition of "Fully Enriched"**: Ability has both `bg3_file_type` AND `bg3_spell_success` populated.

- **Total Abilities**: $totalRows
- **Fully Enriched**: $enrichedCount ($enrichedPercent%)
- **Has bg3_file_type**: $(($db | Where-Object { $_.bg3_file_type -ne "" }).Count)
- **Has bg3_spell_success**: $(($db | Where-Object { $_.bg3_spell_success -ne "" }).Count)
- **Has Wowhead URLs**: $wowheadCount ($wowheadPercent%)

---

### Column Verification

**Expected (Section [13])**: 28 columns  
**Actual**: $totalCols columns

"@

if ($totalCols -ne 28) {
    $report += "**Column Names Found** ($totalCols total):`n`n"
    $db[0].PSObject.Properties.Name | ForEach-Object {
        $report += "- $_`n"
    }
}

# === RECOMMENDATIONS ===
$report += @"

---

## Recommendations

"@

if ($issues.Count -eq 0) {
    $report += "✅ **No action needed!** Database is consistent with Section [13] claims.`n"
} else {
    $report += "⚠️ **Action Required**: Section [13] in SOURCE_OF_TRUTH.md needs updates to match actual database state:`n`n"
    
    if ($totalCols -ne 28) {
        $report += "1. **Update Column Count**: Change from 28 to $totalCols columns`n"
    }
    
    if ($enrichedCount -ne 46) {
        $report += "2. **Update Enrichment Statistics**: Change from 46 to $enrichedCount fully enriched abilities ($enrichedPercent%)`n"
    }
    
    if ($fileTypeIssues.Count -gt 0) {
        $report += "3. **Update BG3 File Type Distribution Table**: Correct counts for:`n"
        $fileTypeIssues | ForEach-Object { $report += "   - $_`n" }
    }
}

$report += @"

---

## Conclusion

"@

if ($issues.Count -eq 0) {
    $report += "✅ **DATABASE VERIFICATION: PASS**`n`n"
    $report += "The database matches all claims in SOURCE_OF_TRUTH.md Section [13].`n"
    Write-Host "`n✅ VERIFICATION PASSED - No issues found!" -ForegroundColor Green
} else {
    $report += "❌ **DATABASE VERIFICATION: FAIL**`n`n"
    $report += "Found $($issues.Count) discrepancies between database and Section [13] documentation.`n`n"
    $report += "**Next Steps**: Update SOURCE_OF_TRUTH.md Section [13] to reflect actual database state.`n"
    Write-Host "`n❌ VERIFICATION FAILED - $($issues.Count) issues found" -ForegroundColor Red
}

$report += @"

---

**Report Generated**: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')  
**Script**: Scripts/Database/VERIFY_DATABASE_SECTION13.ps1
"@

# Save report
$report | Out-File -FilePath $OutputPath -Encoding UTF8
Write-Host "`nReport saved to: $OutputPath" -ForegroundColor Cyan
Write-Host "Verification complete!`n" -ForegroundColor Magenta

# Return exit code
if ($issues.Count -eq 0) { exit 0 } else { exit 1 }
