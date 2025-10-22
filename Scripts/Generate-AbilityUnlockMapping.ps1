# Generate Ability Unlock Mapping CSV
# This script parses the Progression CSV and creates a mapping table

$ErrorActionPreference = "Stop"

$ProgressionCsvPath = "C:\Users\tenod\source\repos\BG3Mods\Documentation\00_SourcesOfTruth\Warrior Progression for all subclasses and Default hero structure.csv"
$OutputPath = "C:\Users\tenod\source\repos\BG3Mods\Documentation\00_SourcesOfTruth\AbilityUnlockMapping.csv"

Write-Host "Generating Ability Unlock Mapping..." -ForegroundColor Cyan
Write-Host ""

# Read CSV with proper header handling
$progressionData = Import-Csv $ProgressionCsvPath

# Get column names
$columnNames = ($progressionData | Get-Member -MemberType NoteProperty).Name

Write-Host "Total columns found: $($columnNames.Count)" -ForegroundColor Yellow
Write-Host "First 20 columns: $($columnNames[0..19] -join ', ')" -ForegroundColor Gray
Write-Host ""

# Create mapping dictionary
$abilityMap = @{}

# Column index mapping (based on header analysis)
# We'll determine subclass by column position
$armsBaselineStart = 3  # Column 4 (0-indexed = 3)
$armsBaselineEnd = 4    # Column 5
$protectionBaselineStart = 5  # Column 6
$protectionBaselineEnd = 7    # Column 8
$furyBaselineStart = 8   # Column 9
$furyBaselineEnd = 9     # Column 10
$stanceStart = 10        # Column K (11th column, 0-indexed = 10)
$stanceEnd = 11          # Column L
$classTalentStart = 12   # Column M onwards
$classTalentEnd = 21     # Approximate end of class talents

# Process each row (level)
foreach ($row in $progressionData) {
    $level = $row.Level
    
    # Skip invalid levels
    if ([string]::IsNullOrWhiteSpace($level) -or $level -eq "Level" -or $level -notmatch '^\d+$') {
        continue
    }
    
    $levelNum = [int]$level
    if ($levelNum -lt 1 -or $levelNum -gt 20) {
        continue
    }
    
    Write-Host "Processing Level $levelNum..." -ForegroundColor Gray
    
    # Process each column
    for ($colIdx = 0; $colIdx -lt $columnNames.Count; $colIdx++) {
        $colName = $columnNames[$colIdx]
        $cellValue = $row.$colName
        
        # Skip empty cells
        if ([string]::IsNullOrWhiteSpace($cellValue)) {
            continue
        }
        
        # Extract ability name from cell text
        # Format: "Ability Name (Abbr) - description" or "Ability Name - description"
        $abilityName = ""
        
        # Try to extract text before parentheses or first dash
        if ($cellValue -match '^([^(�]+)[\(�]') {
            $abilityName = $matches[1].Trim()
        }
        elseif ($cellValue -match '^([^-]+)-') {
            $abilityName = $matches[1].Trim()
        }
        else {
            # Just take first 30 chars if no pattern match
            $abilityName = $cellValue.Substring(0, [Math]::Min(30, $cellValue.Length)).Trim()
        }
        
        # Skip if we couldn't extract a name
        if ([string]::IsNullOrWhiteSpace($abilityName) -or $abilityName.Length -lt 3) {
            continue
        }
        
        # Initialize entry if doesn't exist
        if (-not $abilityMap.ContainsKey($abilityName)) {
            $abilityMap[$abilityName] = @{
                arms = $null
                fury = $null
                protection = $null
                notes = ""
            }
        }
        
        # Determine which subclass(es) based on column index
        $subclasses = @()
        $columnType = ""
        
        if ($colIdx -ge $armsBaselineStart -and $colIdx -le $armsBaselineEnd) {
            $subclasses += "arms"
            $columnType = "Arms Baseline"
        }
        if ($colIdx -ge $protectionBaselineStart -and $colIdx -le $protectionBaselineEnd) {
            $subclasses += "protection"
            $columnType = "Protection Baseline"
        }
        if ($colIdx -ge $furyBaselineStart -and $colIdx -le $furyBaselineEnd) {
            $subclasses += "fury"
            $columnType = "Fury Baseline"
        }
        if ($colIdx -ge $stanceStart -and $colIdx -le $stanceEnd) {
            $subclasses += @("arms", "fury", "protection")
            $columnType = "Stance (All)"
        }
        if ($colIdx -ge $classTalentStart -and $colIdx -le $classTalentEnd) {
            $subclasses += @("arms", "fury", "protection")
            $columnType = "Class Talent (All)"
        }
        
        # Check column header for spec talents
        if ($colName -like '*Arms*' -and $colIdx -gt $classTalentEnd) {
            $subclasses += "arms"
            $columnType = "Arms Spec Talent"
        }
        if ($colName -like '*Fury*' -and $colIdx -gt $classTalentEnd) {
            $subclasses += "fury"
            $columnType = "Fury Spec Talent"
        }
        if ($colName -like '*Protection*' -and $colIdx -gt $classTalentEnd) {
            $subclasses += "protection"
            $columnType = "Protection Spec Talent"
        }
        
        # Check for hero talents
        if ($colName -like '*Mountain Thane*') {
            $subclasses += @("protection", "fury")
            $columnType = "Hero: Mountain Thane (Protection, Fury)"
        }
        if ($colName -like '*Colossus*') {
            $subclasses += @("arms", "protection")
            $columnType = "Hero: Colossus (Arms, Protection)"
        }
        if ($colName -like '*Slayer*') {
            $subclasses += @("arms", "fury")
            $columnType = "Hero: Slayer (Arms, Fury)"
        }
        
        # Update earliest unlock level for each subclass
        foreach ($subclass in $subclasses) {
            if ($null -eq $abilityMap[$abilityName][$subclass] -or $levelNum -lt $abilityMap[$abilityName][$subclass]) {
                $abilityMap[$abilityName][$subclass] = $levelNum
                $abilityMap[$abilityName].notes += "[$subclass L$levelNum from $columnType]; "
            }
        }
    }
}

Write-Host ""
Write-Host "Found $($abilityMap.Count) unique abilities" -ForegroundColor Green
Write-Host ""

# Convert to CSV format
$mappingObjects = @()

foreach ($abilityName in ($abilityMap.Keys | Sort-Object)) {
    $entry = $abilityMap[$abilityName]
    
    $mappingObjects += [PSCustomObject]@{
        ability_name = $abilityName
        warrior_unlock = ""  # Always empty for now
        arms_unlock = if ($null -eq $entry.arms) { "" } else { $entry.arms }
        fury_unlock = if ($null -eq $entry.fury) { "" } else { $entry.fury }
        protection_unlock = if ($null -eq $entry.protection) { "" } else { $entry.protection }
        notes = $entry.notes.TrimEnd('; ')
    }
}

# Export to CSV
$mappingObjects | Export-Csv -Path $OutputPath -NoTypeInformation -Encoding UTF8

Write-Host "Mapping CSV created: $OutputPath" -ForegroundColor Green
Write-Host ""
Write-Host "Sample entries (first 20):" -ForegroundColor Yellow
$mappingObjects | Select-Object -First 20 | Format-Table ability_name, arms_unlock, fury_unlock, protection_unlock -AutoSize

Write-Host ""
Write-Host "REVIEW THIS FILE BEFORE PROCEEDING!" -ForegroundColor Red
Write-Host "Open: $OutputPath" -ForegroundColor Cyan
