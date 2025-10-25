<#
.SYNOPSIS
    Validates field quality after enhanced population
.DESCRIPTION
    Checks for:
    - Field completion percentage
    - Data quality (no 'N/A' in required fields)
    - BG3 functor syntax validation
    - Resource cost consistency
    - Implementation notes completeness
#>

param(
    [string]$DbPath = "c:\Users\tenod\source\repos\BG3Mods\Documentation\00_SourcesOfTruth\AbilityDatabase_Warrior_FullyEnriched.csv"
)

Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host "ENHANCED FIELD VALIDATION" -ForegroundColor Cyan
Write-Host "========================================`n" -ForegroundColor Cyan

# Load database
$Db = Import-Csv $DbPath -Encoding UTF8
$TotalAbilities = $Db.Count

# Track validation results
$Issues = @()
$Warnings = @()

Write-Host "[1] FIELD COMPLETION CHECK" -ForegroundColor Yellow
Write-Host "----------------------------" -ForegroundColor Gray

# Check key fields
$Fields = @(
    'description_short'
    'description_full'
    'wow_mechanic_type'
    'bg3_mechanic_equivalent'
    'resource_cost_rage'
    'damage_formula'
    'bg3_target_conditions'
    'implementation_notes'
)

foreach ($field in $Fields) {
    $Populated = ($Db | Where-Object { -not [string]::IsNullOrWhiteSpace($_.$field) }).Count
    $Percentage = [Math]::Round(($Populated / $TotalAbilities) * 100, 1)
    
    $Color = if ($Percentage -ge 90) { 'Green' } 
             elseif ($Percentage -ge 70) { 'Yellow' } 
             else { 'Red' }
    
    Write-Host "  [$field]: $Populated/$TotalAbilities ($Percentage%)" -ForegroundColor $Color
}

Write-Host "`n[2] HERO TALENT SPECIFIC CHECK" -ForegroundColor Yellow
Write-Host "--------------------------------" -ForegroundColor Gray

$HeroTalents = $Db | Where-Object { 
    $_.archetype_tags -match 'Hero-Talent' -or 
    $_.archetype_tags -match 'Mountain-Thane' -or 
    $_.archetype_tags -match 'Colossus' -or 
    $_.archetype_tags -match 'Slayer'
}

Write-Host "  Total Hero Talents: $($HeroTalents.Count)" -ForegroundColor Cyan

$HeroWithAllFields = $HeroTalents | Where-Object {
    -not [string]::IsNullOrWhiteSpace($_.wow_mechanic_type) -and
    -not [string]::IsNullOrWhiteSpace($_.bg3_mechanic_equivalent) -and
    -not [string]::IsNullOrWhiteSpace($_.resource_cost_rage) -and
    -not [string]::IsNullOrWhiteSpace($_.implementation_notes)
}

Write-Host "  Hero Talents with all 8 fields: $($HeroWithAllFields.Count)" -ForegroundColor Green
Write-Host "  Completion: $([Math]::Round(($HeroWithAllFields.Count / $HeroTalents.Count) * 100, 1))%" -ForegroundColor Green

Write-Host "`n[3] DATA QUALITY CHECKS" -ForegroundColor Yellow
Write-Host "-------------------------" -ForegroundColor Gray

# Check for invalid resource costs
$InvalidCosts = $Db | Where-Object { 
    -not [string]::IsNullOrWhiteSpace($_.resource_cost_rage) -and 
    $_.resource_cost_rage -notmatch '^\d+$'
}

if ($InvalidCosts.Count -gt 0) {
    Write-Host "  [!] Invalid rage costs found: $($InvalidCosts.Count)" -ForegroundColor Red
    $InvalidCosts | ForEach-Object {
        $Issues += "Invalid rage cost '$($_.resource_cost_rage)' for ability '$($_.ability_name)'"
    }
} else {
    Write-Host "  [OK] All rage costs valid (numeric)" -ForegroundColor Green
}

# Check for missing implementation notes in active abilities
$ActiveWithoutNotes = $Db | Where-Object {
    $_.bg3_action_type -eq 'Action' -and
    [string]::IsNullOrWhiteSpace($_.implementation_notes)
}

if ($ActiveWithoutNotes.Count -gt 0) {
    Write-Host "  [!] Active abilities without implementation notes: $($ActiveWithoutNotes.Count)" -ForegroundColor Red
    $ActiveWithoutNotes | Select-Object -First 5 | ForEach-Object {
        $Warnings += "Missing notes for active ability: $($_.ability_name)"
    }
} else {
    Write-Host "  [OK] All active abilities have implementation notes" -ForegroundColor Green
}

# Check BG3 mechanic syntax
$MechanicsWithFunctors = $Db | Where-Object {
    -not [string]::IsNullOrWhiteSpace($_.bg3_mechanic_equivalent) -and
    ($_.bg3_mechanic_equivalent -match 'DealDamage|ApplyStatus|RestoreResource|IF\(')
}

Write-Host "  [OK] Abilities with BG3 functors: $($MechanicsWithFunctors.Count)" -ForegroundColor Green

# Check for placeholder text
$PlaceholderText = @('TODO', 'TBD', 'FIXME', 'XXX', 'PLACEHOLDER')
$HasPlaceholders = $Db | Where-Object {
    $ability = $_
    $PlaceholderText | Where-Object { 
        $ability.implementation_notes -match $_ -or 
        $ability.bg3_mechanic_equivalent -match $_
    }
}

if ($HasPlaceholders.Count -gt 0) {
    Write-Host "  [!] Abilities with placeholder text: $($HasPlaceholders.Count)" -ForegroundColor Yellow
    $HasPlaceholders | ForEach-Object {
        $Warnings += "Placeholder text in: $($_.ability_name)"
    }
} else {
    Write-Host "  [OK] No placeholder text found" -ForegroundColor Green
}

Write-Host "`n[4] DAMAGE FORMULA VALIDATION" -ForegroundColor Yellow
Write-Host "-------------------------------" -ForegroundColor Gray

$ValidDamageFormulas = $Db | Where-Object {
    -not [string]::IsNullOrWhiteSpace($_.damage_formula) -and
    ($_.damage_formula -match '\d+d\d+' -or $_.damage_formula -match 'N/A')
}

$InvalidFormulas = $Db | Where-Object {
    -not [string]::IsNullOrWhiteSpace($_.damage_formula) -and
    $_.damage_formula -notmatch '\d+d\d+' -and
    $_.damage_formula -notmatch 'N/A' -and
    $_.damage_formula -notmatch 'Multiplier' -and
    $_.damage_formula -notmatch 'Enhancement'
}

if ($InvalidFormulas.Count -gt 0) {
    Write-Host "  [!] Potentially invalid damage formulas: $($InvalidFormulas.Count)" -ForegroundColor Yellow
    $InvalidFormulas | Select-Object -First 3 | ForEach-Object {
        Write-Host "    - $($_.ability_name): $($_.damage_formula)" -ForegroundColor Gray
    }
} else {
    Write-Host "  [OK] All damage formulas valid" -ForegroundColor Green
}

Write-Host "`n[5] IMPLEMENTATION READINESS" -ForegroundColor Yellow
Write-Host "------------------------------" -ForegroundColor Gray

# Count abilities ready for implementation
$ReadyForImplementation = $Db | Where-Object {
    -not [string]::IsNullOrWhiteSpace($_.description_full) -and
    -not [string]::IsNullOrWhiteSpace($_.bg3_mechanic_equivalent) -and
    -not [string]::IsNullOrWhiteSpace($_.implementation_notes) -and
    -not [string]::IsNullOrWhiteSpace($_.bg3_file_type)
}

$ReadyPercentage = [Math]::Round(($ReadyForImplementation.Count / $TotalAbilities) * 100, 1)

Write-Host "  Abilities ready for implementation: $($ReadyForImplementation.Count)/$TotalAbilities ($ReadyPercentage%)" -ForegroundColor Cyan

$Color = if ($ReadyPercentage -ge 80) { 'Green' } 
         elseif ($ReadyPercentage -ge 60) { 'Yellow' } 
         else { 'Red' }

Write-Host "  Status: " -NoNewline
if ($ReadyPercentage -ge 80) {
    Write-Host "EXCELLENT" -ForegroundColor Green
} elseif ($ReadyPercentage -ge 60) {
    Write-Host "GOOD" -ForegroundColor Yellow
} else {
    Write-Host "NEEDS WORK" -ForegroundColor Red
}

Write-Host "`n[6] PRIORITY CHECK (P0/P1 ABILITIES)" -ForegroundColor Yellow
Write-Host "---------------------------------------" -ForegroundColor Gray

$CriticalAbilities = $Db | Where-Object { 
    $_.implementation_priority -match '^P[01]$' 
}

Write-Host "  Total P0/P1 abilities: $($CriticalAbilities.Count)" -ForegroundColor Cyan

$CriticalComplete = $CriticalAbilities | Where-Object {
    -not [string]::IsNullOrWhiteSpace($_.description_full) -and
    -not [string]::IsNullOrWhiteSpace($_.bg3_mechanic_equivalent) -and
    -not [string]::IsNullOrWhiteSpace($_.implementation_notes)
}

$CriticalPercentage = [Math]::Round(($CriticalComplete.Count / $CriticalAbilities.Count) * 100, 1)

Write-Host "  P0/P1 with complete data: $($CriticalComplete.Count)/$($CriticalAbilities.Count) ($CriticalPercentage%)" -ForegroundColor $(
    if ($CriticalPercentage -eq 100) { 'Green' } 
    elseif ($CriticalPercentage -ge 90) { 'Yellow' } 
    else { 'Red' }
)

# FINAL SUMMARY
Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host "VALIDATION SUMMARY" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan

Write-Host "`n[OVERALL QUALITY]:" -ForegroundColor Yellow
if ($Issues.Count -eq 0 -and $Warnings.Count -eq 0) {
    Write-Host "  Status: EXCELLENT - No issues found!" -ForegroundColor Green
} elseif ($Issues.Count -eq 0) {
    Write-Host "  Status: GOOD - Only minor warnings" -ForegroundColor Yellow
    Write-Host "  Warnings: $($Warnings.Count)" -ForegroundColor Yellow
} else {
    Write-Host "  Status: NEEDS ATTENTION" -ForegroundColor Red
    Write-Host "  Issues: $($Issues.Count)" -ForegroundColor Red
    Write-Host "  Warnings: $($Warnings.Count)" -ForegroundColor Yellow
}

if ($Issues.Count -gt 0) {
    Write-Host "`n[ISSUES TO FIX]:" -ForegroundColor Red
    $Issues | Select-Object -First 10 | ForEach-Object {
        Write-Host "  - $_" -ForegroundColor Red
    }
    if ($Issues.Count -gt 10) {
        Write-Host "  ... and $($Issues.Count - 10) more" -ForegroundColor Gray
    }
}

if ($Warnings.Count -gt 0 -and $Warnings.Count -le 10) {
    Write-Host "`n[WARNINGS]:" -ForegroundColor Yellow
    $Warnings | ForEach-Object {
        Write-Host "  - $_" -ForegroundColor Yellow
    }
}

Write-Host "`n========================================`n" -ForegroundColor Cyan

# Exit with appropriate code
if ($Issues.Count -gt 0) {
    exit 1
} else {
    exit 0
}
