# Complete Level 1 Analysis - Database + Progression CSV

$dbPath = "C:\Users\tenod\source\repos\BG3Mods\Documentation\00_SourcesOfTruth\AbilityDatabase_Warrior_FullyEnriched.csv"
$progPath = "C:\Users\tenod\source\repos\BG3Mods\Documentation\00_SourcesOfTruth\Warrior Progression for all subclasses and Default hero structure.csv"

Write-Host "=== Complete Level 1 Analysis ===" -ForegroundColor Cyan
Write-Host ""

# Load database
$database = Import-Csv $dbPath -Encoding UTF8

# Load progression CSV (Level 1 is row 4 - row 1=headers, row 2=subheaders, row 3=type descriptions)
$progressionRaw = Get-Content $progPath -Raw
$progressionLines = $progressionRaw -split "`r?`n"
$level1Row = $progressionLines[3] -split ","  # Row 4 = Level 1 data

Write-Host "=== DATABASE: Level 1 Abilities (from unlock columns) ===" -ForegroundColor Yellow
Write-Host ""

# Query L1 from database
$dbLevel1 = $database | Where-Object {
    $_.arms_unlock -eq '1' -or $_.fury_unlock -eq '1' -or $_.protection_unlock -eq '1'
}

Write-Host "Found $($dbLevel1.Count) abilities in database with L1 unlock" -ForegroundColor Green
$dbLevel1 | Select-Object ability_name, arms_unlock, fury_unlock, protection_unlock, ability_type | Format-Table -AutoSize
Write-Host ""

Write-Host "=== PROGRESSION CSV: Level 1 Abilities (from CSV columns) ===" -ForegroundColor Yellow
Write-Host ""

# Parse CSV Level 1 row (row 2, index 1)
# Column ranges from instruction doc:
# Arms Baseline: Cols 3-4 (indices 2-3)
# Protection Baseline: Cols 5-7 (indices 4-6)
# Fury Baseline: Cols 8-9 (indices 7-8)
# Stances: Cols 10-11 (indices 9-10)
# Class Talents Row 1: Cols 12-22 (indices 11-21) - but checking CSV structure
# Arms Spec Row 1: Cols 23-25 (indices 22-24)
# Fury Spec Row 1: Cols 36-38 (indices 35-37)
# Protection Spec Row 1: Col 47 (index 46)

$csvAbilities = @()

# Function to extract ability name from CSV cell (removes descriptions)
function Get-AbilityName {
    param($cell)
    if ([string]::IsNullOrWhiteSpace($cell)) { return $null }
    
    # Remove leading special chars (like bullet points)
    $cell = $cell -replace '^[\s\uFEFF\u00A0\u200B-\u200D\u2060]+', ''
    
    # Extract ability name in quotes or parentheses
    if ($cell -match '"([^"]+)"') { return $matches[1].Trim() }
    if ($cell -match '\(([^)]+)\)') { 
        $name = $matches[1].Trim()
        # If it's an abbreviation (all caps, 2-3 chars), skip and use full name
        if ($name -match '^[A-Z]{2,3}$') {
            # Try to get the word before parentheses
            if ($cell -match '^([^(]+)') { return $matches[1].Trim() }
        }
        return $name
    }
    
    # Otherwise, take first word or phrase before " - "
    if ($cell -match '^([^-]+)') { return $matches[1].Trim() }
    
    return $cell.Trim()
}

# Arms Baseline (cols 3-4, indices 2-3)
Write-Host "ARMS BASELINE (Cols 3-4):" -ForegroundColor Cyan
for ($i = 2; $i -le 3; $i++) {
    $abilityName = Get-AbilityName $level1Row[$i]
    if ($abilityName) {
        Write-Host "  - $abilityName" -ForegroundColor White
        $csvAbilities += [PSCustomObject]@{
            Ability = $abilityName
            Source = "Arms Baseline"
            Column = $i + 1
            Subclass = "Arms"
        }
    }
}
Write-Host ""

# Protection Baseline (cols 5-7, indices 4-6)
Write-Host "PROTECTION BASELINE (Cols 5-7):" -ForegroundColor Cyan
for ($i = 4; $i -le 6; $i++) {
    $abilityName = Get-AbilityName $level1Row[$i]
    if ($abilityName) {
        Write-Host "  - $abilityName" -ForegroundColor White
        $csvAbilities += [PSCustomObject]@{
            Ability = $abilityName
            Source = "Protection Baseline"
            Column = $i + 1
            Subclass = "Protection"
        }
    }
}
Write-Host ""

# Fury Baseline (cols 8-9, indices 7-8)
Write-Host "FURY BASELINE (Cols 8-9):" -ForegroundColor Cyan
for ($i = 7; $i -le 8; $i++) {
    $abilityName = Get-AbilityName $level1Row[$i]
    if ($abilityName) {
        Write-Host "  - $abilityName" -ForegroundColor White
        $csvAbilities += [PSCustomObject]@{
            Ability = $abilityName
            Source = "Fury Baseline"
            Column = $i + 1
            Subclass = "Fury"
        }
    }
}
Write-Host ""

# Stances (cols 10-11, indices 9-10)
Write-Host "STANCES - ALL SUBCLASSES (Cols 10-11):" -ForegroundColor Cyan
for ($i = 9; $i -le 10; $i++) {
    $abilityName = Get-AbilityName $level1Row[$i]
    if ($abilityName) {
        Write-Host "  - $abilityName" -ForegroundColor White
        $csvAbilities += [PSCustomObject]@{
            Ability = $abilityName
            Source = "Stances (All)"
            Column = $i + 1
            Subclass = "All"
        }
    }
}
Write-Host ""

# Arms Spec Row 1 (cols 23-25, indices 22-24)
Write-Host "ARMS SPEC ROW 1 (Cols 23-25):" -ForegroundColor Cyan
for ($i = 22; $i -le 24; $i++) {
    $abilityName = Get-AbilityName $level1Row[$i]
    if ($abilityName) {
        Write-Host "  - $abilityName" -ForegroundColor White
        $csvAbilities += [PSCustomObject]@{
            Ability = $abilityName
            Source = "Arms Spec Row 1"
            Column = $i + 1
            Subclass = "Arms"
        }
    }
}
Write-Host ""

# Fury Spec Row 1 (cols 36-38, indices 35-37)
Write-Host "FURY SPEC ROW 1 (Cols 36-38):" -ForegroundColor Cyan
for ($i = 35; $i -le 37; $i++) {
    $abilityName = Get-AbilityName $level1Row[$i]
    if ($abilityName) {
        Write-Host "  - $abilityName" -ForegroundColor White
        $csvAbilities += [PSCustomObject]@{
            Ability = $abilityName
            Source = "Fury Spec Row 1"
            Column = $i + 1
            Subclass = "Fury"
        }
    }
}
Write-Host ""

# Protection Spec Row 1 (col 47, index 46)
Write-Host "PROTECTION SPEC ROW 1 (Col 47):" -ForegroundColor Cyan
$abilityName = Get-AbilityName $level1Row[46]
if ($abilityName) {
    Write-Host "  - $abilityName" -ForegroundColor White
    $csvAbilities += [PSCustomObject]@{
        Ability = $abilityName
        Source = "Protection Spec Row 1"
        Column = 47
        Subclass = "Protection"
    }
}
Write-Host ""

Write-Host "=== CROSS-REFERENCE: CSV vs DATABASE ===" -ForegroundColor Yellow
Write-Host ""

# Match CSV abilities with database
foreach ($csvAbility in $csvAbilities) {
    $dbMatch = $database | Where-Object { $_.ability_name -like "*$($csvAbility.Ability)*" } | Select-Object -First 1
    
    if ($dbMatch) {
        $status = if ($dbMatch.arms_unlock -eq '1' -or $dbMatch.fury_unlock -eq '1' -or $dbMatch.protection_unlock -eq '1') {
            "[OK]"
        } else {
            "[MISSING UNLOCK]"
        }
        Write-Host "$status $($csvAbility.Ability) (Col $($csvAbility.Column) - $($csvAbility.Source))" -ForegroundColor $(if ($status -eq "[OK]") { "Green" } else { "Red" })
        Write-Host "     Database: arms=$($dbMatch.arms_unlock), fury=$($dbMatch.fury_unlock), protection=$($dbMatch.protection_unlock)" -ForegroundColor Gray
    } else {
        Write-Host "[NOT IN DB] $($csvAbility.Ability) (Col $($csvAbility.Column) - $($csvAbility.Source))" -ForegroundColor Yellow
    }
}

Write-Host ""
Write-Host "=== SUMMARY ===" -ForegroundColor Cyan
Write-Host "CSV Total L1 Abilities: $($csvAbilities.Count)" -ForegroundColor White
Write-Host "Database L1 Abilities: $($dbLevel1.Count)" -ForegroundColor White

# Count by subclass
$armsCSV = ($csvAbilities | Where-Object { $_.Subclass -eq "Arms" -or $_.Subclass -eq "All" }).Count
$furyCSV = ($csvAbilities | Where-Object { $_.Subclass -eq "Fury" -or $_.Subclass -eq "All" }).Count
$protCSV = ($csvAbilities | Where-Object { $_.Subclass -eq "Protection" -or $_.Subclass -eq "All" }).Count

$armsDB = ($dbLevel1 | Where-Object { $_.arms_unlock -eq '1' }).Count
$furyDB = ($dbLevel1 | Where-Object { $_.fury_unlock -eq '1' }).Count
$protDB = ($dbLevel1 | Where-Object { $_.protection_unlock -eq '1' }).Count

Write-Host ""
Write-Host "Arms: CSV=$armsCSV, Database=$armsDB" -ForegroundColor $(if ($armsCSV -eq $armsDB) { "Green" } else { "Red" })
Write-Host "Fury: CSV=$furyCSV, Database=$furyDB" -ForegroundColor $(if ($furyCSV -eq $furyDB) { "Green" } else { "Red" })
Write-Host "Protection: CSV=$protCSV, Database=$protDB" -ForegroundColor $(if ($protCSV -eq $protDB) { "Green" } else { "Red" })
