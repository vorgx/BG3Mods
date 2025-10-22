# Update AbilityDatabase with per-subclass unlock levels
# This script reads the Progression CSV and updates the AbilityDatabase with correct unlock levels

param(
    [string]$ProgressionCsvPath = "C:\Users\tenod\source\repos\BG3Mods\Documentation\00_SourcesOfTruth\Warrior Progression for all subclasses and Default hero structure.csv",
    [string]$AbilityDatabasePath = "C:\Users\tenod\source\repos\BG3Mods\Documentation\00_SourcesOfTruth\AbilityDatabase_Warrior_FullyEnriched.csv"
)

Write-Host "Reading Progression CSV..." -ForegroundColor Cyan
$progressionData = Import-Csv $ProgressionCsvPath

Write-Host "Building ability unlock lookup table..." -ForegroundColor Cyan

# Create lookup: ability_name -> {arms_unlock, fury_unlock, protection_unlock}
$unlockLookup = @{}

# Column mappings (0-indexed after Level column)
# Cols 4-5: Arms baseline
# Cols 6-8: Protection baseline  
# Cols 9-10: Fury baseline
# Cols 11 (K): Battle Stance (all)
# Cols 12 (L): Defensive Stance (all)
# Cols 13-22: Class talents (all)
# Cols 23-34: Arms spec talents
# Cols 35-45: Fury spec talents
# Cols 46-54: Protection spec talents
# Cols 55+: Hero talents

foreach ($row in $progressionData) {
    $level = [int]$row.Level
    if ($level -lt 1 -or $level -gt 20) { continue }
    
    # Get all properties (columns) for this row
    $properties = $row.PSObject.Properties
    
    foreach ($prop in $properties) {
        $columnName = $prop.Name
        $abilityText = $prop.Value
        
        # Skip empty cells and non-ability columns
        if ([string]::IsNullOrWhiteSpace($abilityText) -or $columnName -eq 'Level' -or $columnName -like 'BG3*' -or $columnName -like '*Attacks*' -or $columnName -like '*Feats*') {
            continue
        }
        
        # Extract ability name from description (text before parentheses or dash)
        # Examples: "Whirlwind (WW) - description" -> "Whirlwind"
        #           "Charge - description" -> "Charge"
        $abilityName = ""
        if ($abilityText -match '^[^\(�-]+') {
            $abilityName = $matches[0].Trim()
        }
        
        if ([string]::IsNullOrWhiteSpace($abilityName)) { continue }
        
        # Determine which subclass(es) this ability is for based on column position
        $colIndex = [array]::IndexOf($properties.Name, $columnName)
        
        # Initialize if not exists
        if (-not $unlockLookup.ContainsKey($abilityName)) {
            $unlockLookup[$abilityName] = @{
                arms = @()
                fury = @()
                protection = @()
            }
        }
        
        # Map column index to subclass
        # NOTE: This is approximate - adjust based on actual CSV structure
        if ($colIndex -ge 3 -and $colIndex -le 5) {
            # Arms baseline (cols 4-5) or Protection baseline start
            if ($colIndex -le 4) {
                $unlockLookup[$abilityName].arms += $level
            }
            if ($colIndex -ge 5) {
                $unlockLookup[$abilityName].protection += $level
            }
        }
        elseif ($colIndex -ge 6 -and $colIndex -le 8) {
            # Protection baseline
            $unlockLookup[$abilityName].protection += $level
        }
        elseif ($colIndex -ge 9 -and $colIndex -le 10) {
            # Fury baseline
            $unlockLookup[$abilityName].fury += $level
        }
        elseif ($colIndex -ge 11 -and $colIndex -le 22) {
            # Stances (K, L) or Class talents (all subclasses)
            $unlockLookup[$abilityName].arms += $level
            $unlockLookup[$abilityName].fury += $level
            $unlockLookup[$abilityName].protection += $level
        }
        elseif ($colIndex -ge 23 -and $colIndex -le 34) {
            # Arms spec talents
            $unlockLookup[$abilityName].arms += $level
        }
        elseif ($colIndex -ge 35 -and $colIndex -le 45) {
            # Fury spec talents
            $unlockLookup[$abilityName].fury += $level
        }
        elseif ($colIndex -ge 46 -and $colIndex -le 54) {
            # Protection spec talents
            $unlockLookup[$abilityName].protection += $level
        }
        elseif ($colIndex -ge 55) {
            # Hero talents - determine based on column header
            if ($columnName -like '*Mountain Thane*') {
                $unlockLookup[$abilityName].protection += $level
                $unlockLookup[$abilityName].fury += $level
            }
            elseif ($columnName -like '*Colossus*') {
                $unlockLookup[$abilityName].arms += $level
                $unlockLookup[$abilityName].protection += $level
            }
            elseif ($columnName -like '*Slayer*') {
                $unlockLookup[$abilityName].arms += $level
                $unlockLookup[$abilityName].fury += $level
            }
        }
    }
}

# Deduplicate levels (take earliest)
foreach ($ability in $unlockLookup.Keys) {
    if ($unlockLookup[$ability].arms.Count -gt 0) {
        $unlockLookup[$ability].arms = ($unlockLookup[$ability].arms | Measure-Object -Minimum).Minimum
    } else {
        $unlockLookup[$ability].arms = ""
    }
    
    if ($unlockLookup[$ability].fury.Count -gt 0) {
        $unlockLookup[$ability].fury = ($unlockLookup[$ability].fury | Measure-Object -Minimum).Minimum
    } else {
        $unlockLookup[$ability].fury = ""
    }
    
    if ($unlockLookup[$ability].protection.Count -gt 0) {
        $unlockLookup[$ability].protection = ($unlockLookup[$ability].protection | Measure-Object -Minimum).Minimum
    } else {
        $unlockLookup[$ability].protection = ""
    }
}

Write-Host "Found $($unlockLookup.Count) unique abilities in Progression CSV" -ForegroundColor Green
Write-Host ""
Write-Host "Sample lookup entries:" -ForegroundColor Yellow
$unlockLookup.GetEnumerator() | Select-Object -First 10 | ForEach-Object {
    Write-Host "  $($_.Key): Arms=$($_.Value.arms), Fury=$($_.Value.fury), Protection=$($_.Value.protection)"
}

Write-Host ""
Write-Host "Press Enter to continue with AbilityDatabase update, or Ctrl+C to cancel..."
Read-Host

Write-Host ""
Write-Host "Updating AbilityDatabase CSV..." -ForegroundColor Cyan

# Read the raw CSV content
$csvContent = Get-Content $AbilityDatabasePath -Raw

# Split into lines
$lines = $csvContent -split "`r?`n"

# Process header
$header = $lines[0]
# Remove "unlock_level" column and add new columns
$headerColumns = $header -split '","'
$headerColumns[0] = $headerColumns[0].Trim('"')
$headerColumns[$headerColumns.Count - 1] = $headerColumns[$headerColumns.Count - 1].Trim('"')

# Find unlock_level column index
$unlockLevelIndex = [array]::IndexOf($headerColumns, 'unlock_level')

if ($unlockLevelIndex -eq -1) {
    Write-Host "ERROR: unlock_level column not found!" -ForegroundColor Red
    exit 1
}

# Remove unlock_level and insert new columns
$newHeaderColumns = $headerColumns[0..($unlockLevelIndex-1)] + 
                    @('warrior_unlock', 'arms_unlock', 'fury_unlock', 'protection_unlock') + 
                    $headerColumns[($unlockLevelIndex+1)..($headerColumns.Count-1)]

$newHeader = '"' + ($newHeaderColumns -join '","') + '"'

# Process data rows
$newLines = @($newHeader)

for ($i = 1; $i -lt $lines.Count; $i++) {
    $line = $lines[$i]
    if ([string]::IsNullOrWhiteSpace($line)) {
        $newLines += $line
        continue
    }
    
    # Parse CSV line (handle quoted fields with commas)
    $columns = @()
    $inQuote = $false
    $currentField = ""
    
    for ($j = 0; $j -lt $line.Length; $j++) {
        $char = $line[$j]
        
        if ($char -eq '"') {
            $inQuote = -not $inQuote
            $currentField += $char
        }
        elseif ($char -eq ',' -and -not $inQuote) {
            $columns += $currentField
            $currentField = ""
        }
        else {
            $currentField += $char
        }
    }
    $columns += $currentField  # Add last field
    
    # Extract ability name (from column 2, strip quotes)
    $abilityName = $columns[1].Trim('"')
    
    # Lookup unlock levels
    $armsUnlock = ""
    $furyUnlock = ""
    $protectionUnlock = ""
    
    if ($unlockLookup.ContainsKey($abilityName)) {
        $armsUnlock = $unlockLookup[$abilityName].arms
        $furyUnlock = $unlockLookup[$abilityName].fury
        $protectionUnlock = $unlockLookup[$abilityName].protection
    }
    
    # Remove unlock_level column and add new columns
    $newColumns = $columns[0..($unlockLevelIndex-1)] + 
                  @("`"$armsUnlock`"", "`"$furyUnlock`"", "`"$protectionUnlock`"", '""') +  # warrior_unlock empty
                  $columns[($unlockLevelIndex+1)..($columns.Count-1)]
    
    $newLine = $newColumns -join ','
    $newLines += $newLine
}

# Write to file
$outputContent = $newLines -join "`r`n"
Set-Content -Path $AbilityDatabasePath -Value $outputContent -NoNewline

Write-Host ""
Write-Host "AbilityDatabase updated successfully!" -ForegroundColor Green
Write-Host "Backup location: $($AbilityDatabasePath -replace '\.csv$', '_BACKUP_' + (Get-Date -Format 'yyyyMMdd_HHmmss') + '.csv')" -ForegroundColor Yellow
