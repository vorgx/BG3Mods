# POPULATE_UNLOCK_LEVELS_CORRECTED.ps1
# Populates warrior_unlock, arms_unlock, fury_unlock, protection_unlock columns
# from progression CSV into ability database
#
# Date: October 22, 2025
# Logic: Map CSV column headers to database columns, process rows 5-24 (levels 1-20)

param(
    [string]$ProgressionCsv = "C:\Users\tenod\source\repos\BG3Mods\Documentation\00_SourcesOfTruth\Warrior Progression for all subclasses and Default hero structure.csv",
    [string]$DatabaseCsv = "C:\Users\tenod\source\repos\BG3Mods\Documentation\00_SourcesOfTruth\AbilityDatabase_Warrior_FullyEnriched.csv",
    [switch]$WhatIf
)

Write-Host "`n=== POPULATE UNLOCK LEVELS - CORRECTED LOGIC ===" -ForegroundColor Cyan
Write-Host "Progression CSV: $ProgressionCsv" -ForegroundColor Gray
Write-Host "Database CSV: $DatabaseCsv" -ForegroundColor Gray
Write-Host "WhatIf Mode: $WhatIf`n" -ForegroundColor Gray

# Backup database
$BackupPath = $DatabaseCsv -replace '\.csv$', "_BACKUP_$(Get-Date -Format 'yyyyMMdd_HHmmss').csv"
Copy-Item $DatabaseCsv $BackupPath -Force
Write-Host "[BACKUP] Created: $BackupPath" -ForegroundColor Green

# Load files
Write-Host "`n[LOAD] Reading progression CSV..." -ForegroundColor Cyan
# Skip first 3 header rows, start from row 4 (Level 1)
$ProgressionData = Get-Content $ProgressionCsv | Select-Object -Skip 3 | ConvertFrom-Csv -Header (Get-Content $ProgressionCsv | Select-Object -First 1)

Write-Host "[LOAD] Reading database CSV..." -ForegroundColor Cyan
$Database = Import-Csv $DatabaseCsv

Write-Host "[INFO] Database has $($Database.Count) abilities" -ForegroundColor Cyan
Write-Host "[INFO] Progression CSV has $($ProgressionData.Count) rows`n" -ForegroundColor Cyan

# Extract ability name from CSV cell format: "·AbilityName·(Abbr) - description" or " AbilityName (Abbr) -"
function Extract-AbilityName {
    param([string]$CellValue)
    
    if ([string]::IsNullOrWhiteSpace($CellValue)) {
        return $null
    }
    
    # Remove leading/trailing spaces and special chars
    $clean = $CellValue.Trim()
    
    # Pattern 1: ·AbilityName·(Abbr) or  AbilityName (Abbr)
    if ($clean -match '^\s*[·\s]*([^·(]+?)\s*[·\s]*\(') {
        $name = $matches[1].Trim()
        # Clean up extra spaces and special characters
        $name = $name -replace '\s+', ' '
        return $name
    }
    
    # Pattern 2: Just text before " - " (for entries without abbreviations)
    if ($clean -match '^([^-]+?)\s*-') {
        $name = $matches[1].Trim()
        $name = $name -replace '[·\s]+$', ''
        $name = $name -replace '^\s*[·\s]+', ''
        $name = $name -replace '\s+', ' '
        return $name
    }
    
    return $null
}

# Map column index to unlock column name based on header
function Get-UnlockColumns {
    param([string]$HeaderText)
    
    $columns = @()
    
    # Check header text patterns
    if ($HeaderText -match 'Baseline Arms') {
        $columns += 'arms_unlock'
    }
    elseif ($HeaderText -match 'Baseline Protection') {
        $columns += 'protection_unlock'
    }
    elseif ($HeaderText -match 'Baseline Fury') {
        $columns += 'fury_unlock'
    }
    elseif ($HeaderText -match 'Warrior Class Talents.*All subclasses') {
        $columns += 'warrior_unlock'
    }
    elseif ($HeaderText -match 'Arms Spec Talents') {
        $columns += 'arms_unlock'
    }
    elseif ($HeaderText -match 'Fury Spec Talents') {
        $columns += 'fury_unlock'
    }
    elseif ($HeaderText -match 'Protection.*Spec Talents') {
        $columns += 'protection_unlock'
    }
    elseif ($HeaderText -match 'Mountain Thane') {
        $columns += 'protection_unlock'
        $columns += 'fury_unlock'
    }
    elseif ($HeaderText -match 'Colossus') {
        $columns += 'arms_unlock'
        $columns += 'protection_unlock'
    }
    elseif ($HeaderText -match 'Slayers') {
        $columns += 'arms_unlock'
        $columns += 'fury_unlock'
    }
    
    return $columns
}

# Read header row (row 1) to build column mapping
Write-Host "[MAPPING] Building column header mapping..." -ForegroundColor Cyan
$HeaderRow = Get-Content $ProgressionCsv | Select-Object -First 1
$HeaderColumns = $HeaderRow -split ','

# Build map: column index -> unlock column names
$ColumnMap = @{}
for ($i = 0; $i -lt $HeaderColumns.Count; $i++) {
    $unlockCols = Get-UnlockColumns -HeaderText $HeaderColumns[$i]
    if ($unlockCols.Count -gt 0) {
        $ColumnMap[$i] = $unlockCols
        Write-Host "  Column $i ($($HeaderColumns[$i].Substring(0, [Math]::Min(40, $HeaderColumns[$i].Length)))...) -> $($unlockCols -join ', ')" -ForegroundColor Gray
    }
}

Write-Host "[INFO] Mapped $($ColumnMap.Count) columns to unlock fields`n" -ForegroundColor Cyan

# Process each level (rows 5-24 in CSV, which are indices 4-23 after header)
$UpdateCount = 0
$SkipCount = 0

Write-Host "[PROCESS] Processing levels 1-20..." -ForegroundColor Cyan

for ($levelIndex = 0; $levelIndex -lt $ProgressionData.Count; $levelIndex++) {
    $row = $ProgressionData[$levelIndex]
    $currentLevel = $levelIndex + 1  # Level 1-20
    
    Write-Host "`n--- Level $currentLevel ---" -ForegroundColor Yellow
    
    # Get all properties (columns) from this row
    $properties = $row.PSObject.Properties
    
    foreach ($prop in $properties) {
        $columnName = $prop.Name
        $cellValue = $prop.Value
        
        # Skip Level column and empty cells
        if ($columnName -eq 'Level' -or [string]::IsNullOrWhiteSpace($cellValue)) {
            continue
        }
        
        # Extract ability name
        $abilityName = Extract-AbilityName -CellValue $cellValue
        if (-not $abilityName) {
            continue
        }
        
        # Find which column index this is (need to map property name back to index)
        # PowerShell converts CSV headers to property names, so we need to find the index
        $columnIndex = -1
        for ($i = 0; $i -lt $HeaderColumns.Count; $i++) {
            # Clean header text to match property name conversion
            $cleanHeader = $HeaderColumns[$i] -replace '[^\w\s]', '' -replace '\s+', ' '
            $cleanPropName = $columnName -replace '[^\w\s]', '' -replace '\s+', ' '
            
            if ($cleanHeader -eq $cleanPropName -or $HeaderColumns[$i] -eq $columnName) {
                $columnIndex = $i
                break
            }
        }
        
        if ($columnIndex -eq -1 -or -not $ColumnMap.ContainsKey($columnIndex)) {
            continue
        }
        
        # Get unlock columns for this CSV column
        $unlockColumns = $ColumnMap[$columnIndex]
        
        # Find ability in database
        $dbAbility = $Database | Where-Object { $_.ability_name -eq $abilityName }
        
        if (-not $dbAbility) {
            Write-Host "  [SKIP] Ability '$abilityName' not found in database" -ForegroundColor Yellow
            $SkipCount++
            continue
        }
        
        # Update unlock columns
        foreach ($unlockCol in $unlockColumns) {
            $currentValue = $dbAbility.$unlockCol
            
            if ([string]::IsNullOrWhiteSpace($currentValue)) {
                Write-Host "  [UPDATE] $abilityName -> $unlockCol = $currentLevel" -ForegroundColor Green
                if (-not $WhatIf) {
                    $dbAbility.$unlockCol = $currentLevel
                }
                $UpdateCount++
            }
            else {
                Write-Host "  [SKIP] $abilityName -> $unlockCol already set to '$currentValue'" -ForegroundColor Gray
            }
        }
    }
}

# Save updated database
if (-not $WhatIf) {
    Write-Host "`n[SAVE] Writing updated database..." -ForegroundColor Cyan
    $Database | Export-Csv $DatabaseCsv -NoTypeInformation -Force
    Write-Host "[SUCCESS] Database updated!" -ForegroundColor Green
}
else {
    Write-Host "`n[WHATIF] No changes made (WhatIf mode)" -ForegroundColor Yellow
}

# Summary
Write-Host "`n=== SUMMARY ===" -ForegroundColor Cyan
Write-Host "Updates applied: $UpdateCount" -ForegroundColor Green
Write-Host "Abilities skipped: $SkipCount" -ForegroundColor Yellow
Write-Host "Backup location: $BackupPath" -ForegroundColor Gray

if (-not $WhatIf) {
    Write-Host "`n[NEXT] Run validation to verify unlock levels are correct!" -ForegroundColor Cyan
}
