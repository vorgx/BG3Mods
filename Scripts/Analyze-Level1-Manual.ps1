# Manual Level 1 Complete Mapping
# Based on CSV row 4 (Level 1) - column positions verified from SECTION_6_PROGRESSION_DRAFT.md

$dbPath = "C:\Users\tenod\source\repos\BG3Mods\Documentation\00_SourcesOfTruth\AbilityDatabase_Warrior_FullyEnriched.csv"

Write-Host "=== COMPLETE LEVEL 1 ABILITY MAPPING ===" -ForegroundColor Cyan
Write-Host ""

# Load database
$database = Import-Csv $dbPath -Encoding UTF8

# Define Level 1 abilities from CSV (verified from SECTION_6_PROGRESSION_DRAFT.md and manual CSV review)
$level1Mapping = @(
    # Arms Baseline (Cols 3-4)
    @{ Ability = "Whirlwind"; Subclass = "Arms"; Source = "Arms Baseline (Col 3)"; Type = "Offensive" }
    @{ Ability = "Charge"; Subclass = "Arms"; Source = "Arms Baseline (Col 4)"; Type = "Utility" }
    
    # Protection Baseline (Cols 5-7)
    @{ Ability = "Shield Slam"; Subclass = "Protection"; Source = "Protection Baseline (Col 5)"; Type = "Offensive" }
    @{ Ability = "Taunt"; Subclass = "Protection"; Source = "Protection Baseline (Col 6)"; Type = "Utility" }
    @{ Ability = "Mastery: Critical Block"; Subclass = "Protection"; Source = "Protection Baseline (Col 7)"; Type = "Passive" }
    
    # Fury Baseline (Cols 8-9)
    @{ Ability = "Whirlwind"; Subclass = "Fury"; Source = "Fury Baseline (Col 8)"; Type = "Offensive" }
    @{ Ability = "Berserker Rage"; Subclass = "Fury"; Source = "Fury Baseline (Col 9)"; Type = "Utility" }
    
    # Stances (Cols 10-11) - All subclasses
    @{ Ability = "Battle Stance"; Subclass = "All"; Source = "Stances (Col 10)"; Type = "Offensive" }
    @{ Ability = "Defensive Stance"; Subclass = "All"; Source = "Stances (Col 11)"; Type = "Defensive" }
    
    # Arms Spec Row 1 (Cols 23-25)
    @{ Ability = "Seasoned Soldier"; Subclass = "Arms"; Source = "Arms Spec Row 1 (Col 23)"; Type = "Passive" }
    @{ Ability = "Mastery: Deep Wounds"; Subclass = "Arms"; Source = "Arms Spec Row 1 (Col 24)"; Type = "Passive" }
    @{ Ability = "Mortal Strike"; Subclass = "Arms"; Source = "Arms Spec Row 1 (Col 25)"; Type = "Offensive" }
    
    # Fury Spec Row 1 (Cols 36-38)
    @{ Ability = "Titan's Grip"; Subclass = "Fury"; Source = "Fury Spec Row 1 (Col 36)"; Type = "Passive" }
    @{ Ability = "Mastery: Unshackled Fury"; Subclass = "Fury"; Source = "Fury Spec Row 1 (Col 37)"; Type = "Passive" }
    @{ Ability = "Bloodthirst"; Subclass = "Fury"; Source = "Fury Spec Row 1 (Col 38)"; Type = "Offensive" }
    
    # Protection Spec Row 1 (Col 47)
    @{ Ability = "Ignore Pain"; Subclass = "Protection"; Source = "Protection Spec Row 1 (Col 47)"; Type = "Defensive" }
)

Write-Host "=== ARMS WARRIOR - LEVEL 1 ===" -ForegroundColor Yellow
Write-Host ""

$armsAbilities = $level1Mapping | Where-Object { $_.Subclass -eq "Arms" -or $_.Subclass -eq "All" }
foreach ($ability in $armsAbilities) {
    $dbMatch = $database | Where-Object { $_.ability_name -eq $ability.Ability } | Select-Object -First 1
    
    if ($dbMatch) {
        $status = if ($dbMatch.arms_unlock -eq '1') { "[OK]" } else { "[MISSING]" }
        $statusColor = if ($status -eq "[OK]") { "Green" } else { "Red" }
        
        Write-Host "$status $($ability.Ability)" -ForegroundColor $statusColor
        Write-Host "     Source: $($ability.Source)" -ForegroundColor Gray
        Write-Host "     Database: arms=$($dbMatch.arms_unlock), fury=$($dbMatch.fury_unlock), protection=$($dbMatch.protection_unlock)" -ForegroundColor Gray
        Write-Host "     Type: $($ability.Type) | BG3 File: $($dbMatch.bg3_file_type)" -ForegroundColor Gray
    } else {
        Write-Host "[NOT IN DB] $($ability.Ability)" -ForegroundColor Yellow
        Write-Host "     Source: $($ability.Source)" -ForegroundColor Gray
    }
    Write-Host ""
}

Write-Host "=== FURY WARRIOR - LEVEL 1 ===" -ForegroundColor Yellow
Write-Host ""

$furyAbilities = $level1Mapping | Where-Object { $_.Subclass -eq "Fury" -or $_.Subclass -eq "All" }
foreach ($ability in $furyAbilities) {
    $dbMatch = $database | Where-Object { $_.ability_name -eq $ability.Ability } | Select-Object -First 1
    
    if ($dbMatch) {
        $status = if ($dbMatch.fury_unlock -eq '1') { "[OK]" } else { "[MISSING]" }
        $statusColor = if ($status -eq "[OK]") { "Green" } else { "Red" }
        
        Write-Host "$status $($ability.Ability)" -ForegroundColor $statusColor
        Write-Host "     Source: $($ability.Source)" -ForegroundColor Gray
        Write-Host "     Database: arms=$($dbMatch.arms_unlock), fury=$($dbMatch.fury_unlock), protection=$($dbMatch.protection_unlock)" -ForegroundColor Gray
        Write-Host "     Type: $($ability.Type) | BG3 File: $($dbMatch.bg3_file_type)" -ForegroundColor Gray
    } else {
        Write-Host "[NOT IN DB] $($ability.Ability)" -ForegroundColor Yellow
        Write-Host "     Source: $($ability.Source)" -ForegroundColor Gray
    }
    Write-Host ""
}

Write-Host "=== PROTECTION WARRIOR - LEVEL 1 ===" -ForegroundColor Yellow
Write-Host ""

$protAbilities = $level1Mapping | Where-Object { $_.Subclass -eq "Protection" -or $_.Subclass -eq "All" }
foreach ($ability in $protAbilities) {
    $dbMatch = $database | Where-Object { $_.ability_name -eq $ability.Ability } | Select-Object -First 1
    
    if ($dbMatch) {
        $status = if ($dbMatch.protection_unlock -eq '1') { "[OK]" } else { "[MISSING]" }
        $statusColor = if ($status -eq "[OK]") { "Green" } else { "Red" }
        
        Write-Host "$status $($ability.Ability)" -ForegroundColor $statusColor
        Write-Host "     Source: $($ability.Source)" -ForegroundColor Gray
        Write-Host "     Database: arms=$($dbMatch.arms_unlock), fury=$($dbMatch.fury_unlock), protection=$($dbMatch.protection_unlock)" -ForegroundColor Gray
        Write-Host "     Type: $($ability.Type) | BG3 File: $($dbMatch.bg3_file_type)" -ForegroundColor Gray
    } else {
        Write-Host "[NOT IN DB] $($ability.Ability)" -ForegroundColor Yellow
        Write-Host "     Source: $($ability.Source)" -ForegroundColor Gray
    }
    Write-Host ""
}

Write-Host "=== SUMMARY ===" -ForegroundColor Cyan
Write-Host ""

$totalAbilities = $level1Mapping.Count
$uniqueAbilities = ($level1Mapping | Select-Object -Property Ability -Unique).Count

Write-Host "Total L1 Ability Grants (including duplicates for 'All'): $totalAbilities" -ForegroundColor White
Write-Host "Unique Abilities: $uniqueAbilities" -ForegroundColor White
Write-Host ""

$armsCount = $armsAbilities.Count
$furyCount = $furyAbilities.Count
$protCount = $protAbilities.Count

Write-Host "Arms Total: $armsCount abilities" -ForegroundColor White
Write-Host "Fury Total: $furyCount abilities" -ForegroundColor White
Write-Host "Protection Total: $protCount abilities" -ForegroundColor White
Write-Host ""

# Count database matches
$dbLevel1 = $database | Where-Object {
    $_.arms_unlock -eq '1' -or $_.fury_unlock -eq '1' -or $_.protection_unlock -eq '1'
}

Write-Host "Database L1 Abilities with unlock=1: $($dbLevel1.Count)" -ForegroundColor White

# Count mismatches
$missingUnlocks = 0
foreach ($ability in $level1Mapping) {
    $dbMatch = $database | Where-Object { $_.ability_name -eq $ability.Ability } | Select-Object -First 1
    if ($dbMatch) {
        $hasUnlock = $false
        if ($ability.Subclass -eq "Arms" -and $dbMatch.arms_unlock -eq '1') { $hasUnlock = $true }
        if ($ability.Subclass -eq "Fury" -and $dbMatch.fury_unlock -eq '1') { $hasUnlock = $true }
        if ($ability.Subclass -eq "Protection" -and $dbMatch.protection_unlock -eq '1') { $hasUnlock = $true }
        if ($ability.Subclass -eq "All" -and ($dbMatch.arms_unlock -eq '1' -or $dbMatch.fury_unlock -eq '1' -or $dbMatch.protection_unlock -eq '1')) { $hasUnlock = $true }
        
        if (-not $hasUnlock) { $missingUnlocks++ }
    }
}

Write-Host ""
Write-Host "Missing Unlock Entries: $missingUnlocks abilities" -ForegroundColor $(if ($missingUnlocks -gt 0) { "Red" } else { "Green" })
