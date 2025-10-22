# POPULATE_UNLOCK_LEVELS_V2.ps1
# Populates warrior_unlock, arms_unlock, fury_unlock, protection_unlock columns
# Manual CSV parsing to handle complex header structure
#
# Date: October 22, 2025

param(
    [string]$ProgressionCsv = "C:\Users\tenod\source\repos\BG3Mods\Documentation\00_SourcesOfTruth\Warrior Progression for all subclasses and Default hero structure.csv",
    [string]$DatabaseCsv = "C:\Users\tenod\source\repos\BG3Mods\Documentation\00_SourcesOfTruth\AbilityDatabase_Warrior_FullyEnriched.csv",
    [switch]$WhatIf
)

Write-Host "`n=== POPULATE UNLOCK LEVELS V2 - MANUAL CSV PARSING ===" -ForegroundColor Cyan

# Backup database
$BackupPath = $DatabaseCsv -replace '\.csv$', "_BACKUP_$(Get-Date -Format 'yyyyMMdd_HHmmss').csv"
Copy-Item $DatabaseCsv $BackupPath -Force
Write-Host "[BACKUP] Created: $BackupPath`n" -ForegroundColor Green

# Load database
$Database = Import-Csv $DatabaseCsv
Write-Host "[LOAD] Database has $($Database.Count) abilities`n" -ForegroundColor Cyan

# Read CSV as raw lines
$AllLines = Get-Content $ProgressionCsv

# Parse header row (row 1) to identify column types
$HeaderLine = $AllLines[0]
$Headers = $HeaderLine -split ','

# Build column mapping
Write-Host "[MAPPING] Building column mappings..." -ForegroundColor Cyan
$ColumnMap = @{}

for ($i = 0; $i -lt $Headers.Count; $i++) {
    $header = $Headers[$i]
    $unlockCols = @()
    
    if ($header -match 'Baseline Arms') {
        $unlockCols += 'arms_unlock'
    }
    elseif ($header -match 'Baseline Protection') {
        $unlockCols += 'protection_unlock'
    }
    elseif ($header -match 'Baseline Fury') {
        $unlockCols += 'fury_unlock'
    }
    elseif ($header -match 'Warrior Class Talents.*All subclasses') {
        $unlockCols += 'warrior_unlock'
    }
    elseif ($header -match 'Arms Spec Talents') {
        $unlockCols += 'arms_unlock'
    }
    elseif ($header -match 'Fury Spec Talents' -or $header -match '�Fury Spec Talents') {
        $unlockCols += 'fury_unlock'
    }
    elseif ($header -match 'Protection.*Spec Talents') {
        $unlockCols += 'protection_unlock'
    }
    elseif ($header -match 'Mountain Thane') {
        $unlockCols += 'protection_unlock'
        $unlockCols += 'fury_unlock'
    }
    elseif ($header -match 'Colossus') {
        $unlockCols += 'arms_unlock'
        $unlockCols += 'protection_unlock'
    }
    elseif ($header -match 'Slayers') {
        $unlockCols += 'arms_unlock'
        $unlockCols += 'fury_unlock'
    }
    
    if ($unlockCols.Count -gt 0) {
        $ColumnMap[$i] = $unlockCols
        $displayHeader = if ($header.Length -gt 50) { $header.Substring(0, 47) + "..." } else { $header }
        Write-Host "  Column $i`: $displayHeader -> $($unlockCols -join ', ')" -ForegroundColor Gray
    }
}

Write-Host "`n[PROCESS] Processing levels 1-20...`n" -ForegroundColor Cyan

# Process data rows (rows 4-23, indices 3-22)
$UpdateCount = 0
$SkipCount = 0
$NotFoundCount = 0

for ($rowIdx = 3; $rowIdx -lt 23 -and $rowIdx -lt $AllLines.Count; $rowIdx++) {
    $level = $rowIdx - 2  # Row 3 = Level 1, Row 4 = Level 2, etc.
    $line = $AllLines[$rowIdx]
    
    # Split by comma (naive, but should work for most cells)
    $cells = $line -split ','
    
    Write-Host "--- Level $level ---" -ForegroundColor Yellow
    
    foreach ($colIdx in $ColumnMap.Keys) {
        if ($colIdx -ge $cells.Count) {
            continue
        }
        
        $cellValue = $cells[$colIdx].Trim()
        
        if ([string]::IsNullOrWhiteSpace($cellValue)) {
            continue
        }
        
        # Extract ability name
        $abilityName = $null
        
        # Pattern: ·Name· or  Name (Abbr)
        if ($cellValue -match '^\s*[·\s]*([^·(]+?)\s*[·\s]*\(') {
            $abilityName = $matches[1].Trim() -replace '\s+', ' '
        }
        elseif ($cellValue -match '^"?([^"(]+?)\s*\(') {
            $abilityName = $matches[1].Trim() -replace '\s+', ' '
        }
        elseif ($cellValue -match '^([^-]+?)\s*-' -and $cellValue -notmatch '^(Auto Grant|AutoGrant|Offensive|Defensive|Utility|Stance|Passive|Pick one|Choose one)') {
            $abilityName = $matches[1].Trim() -replace '[·\s]+$', '' -replace '^\s*[·\s]+', '' -replace '\s+', ' '
        }
        
        if (-not $abilityName -or $abilityName.Length -lt 3) {
            continue
        }
        
        # Find in database
        $dbAbility = $Database | Where-Object { $_.ability_name -eq $abilityName }
        
        if (-not $dbAbility) {
            Write-Host "  [NOT FOUND] '$abilityName'" -ForegroundColor DarkYellow
            $NotFoundCount++
            continue
        }
        
        # Update unlock columns
        $unlockCols = $ColumnMap[$colIdx]
        foreach ($unlockCol in $unlockCols) {
            $currentValue = $dbAbility.$unlockCol
            
            if ([string]::IsNullOrWhiteSpace($currentValue)) {
                Write-Host "  [UPDATE] $abilityName -> $unlockCol = $level" -ForegroundColor Green
                if (-not $WhatIf) {
                    $dbAbility.$unlockCol = $level
                }
                $UpdateCount++
            }
            else {
                Write-Host "  [SKIP] $abilityName -> $unlockCol already = $currentValue" -ForegroundColor Gray
                $SkipCount++
            }
        }
    }
}

# Save
if (-not $WhatIf) {
    Write-Host "`n[SAVE] Writing updated database..." -ForegroundColor Cyan
    $Database | Export-Csv $DatabaseCsv -NoTypeInformation -Force
    Write-Host "[SUCCESS] Database updated!`n" -ForegroundColor Green
}

# Summary
Write-Host "=== SUMMARY ===" -ForegroundColor Cyan
Write-Host "Updates applied: $UpdateCount" -ForegroundColor Green
Write-Host "Already set (skipped): $SkipCount" -ForegroundColor Yellow
Write-Host "Not found in database: $NotFoundCount" -ForegroundColor DarkYellow
Write-Host "Backup: $BackupPath" -ForegroundColor Gray
