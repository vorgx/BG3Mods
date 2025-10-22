# POPULATE_UNLOCK_LEVELS_V3.ps1
# Populates warrior_unlock, arms_unlock, fury_unlock, protection_unlock columns
# Uses TextFieldParser for proper CSV handling
#
# Date: October 22, 2025

param(
    [string]$ProgressionCsv = "C:\Users\tenod\source\repos\BG3Mods\Documentation\00_SourcesOfTruth\Warrior Progression for all subclasses and Default hero structure.csv",
    [string]$DatabaseCsv = "C:\Users\tenod\source\repos\BG3Mods\Documentation\00_SourcesOfTruth\AbilityDatabase_Warrior_FullyEnriched.csv",
    [switch]$WhatIf
)

Write-Host "`n=== POPULATE UNLOCK LEVELS V3 - PROPER CSV PARSING ===" -ForegroundColor Cyan

# Backup database
$BackupPath = $DatabaseCsv -replace '\.csv$', "_BACKUP_$(Get-Date -Format 'yyyyMMdd_HHmmss').csv"
Copy-Item $DatabaseCsv $BackupPath -Force
Write-Host "[BACKUP] Created: $BackupPath`n" -ForegroundColor Green

# Load database
$Database = Import-Csv $DatabaseCsv
Write-Host "[LOAD] Database has $($Database.Count) abilities`n" -ForegroundColor Cyan

# Use TextFieldParser for proper CSV parsing
Add-Type -AssemblyName Microsoft.VisualBasic
$parser = New-Object Microsoft.VisualBasic.FileIO.TextFieldParser($ProgressionCsv)
$parser.TextFieldType = [Microsoft.VisualBasic.FileIO.FieldType]::Delimited
$parser.SetDelimiters(",")
$parser.HasFieldsEnclosedInQuotes = $true

# Read header row
$headers = $parser.ReadFields()

# Build column mapping
Write-Host "[MAPPING] Building column mappings..." -ForegroundColor Cyan
$ColumnMap = @{}

for ($i = 0; $i -lt $headers.Count; $i++) {
    $header = $headers[$i]
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
    elseif ($header -match 'Fury Spec Talents') {
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

# Skip rows 2 and 3 (subheaders)
$parser.ReadFields() | Out-Null
$parser.ReadFields() | Out-Null

Write-Host "`n[PROCESS] Processing levels 1-20...`n" -ForegroundColor Cyan

$UpdateCount = 0
$SkipCount = 0
$NotFoundCount = 0
$level = 1

while (-not $parser.EndOfData) {
    $fields = $parser.ReadFields()
    
    Write-Host "--- Level $level ---" -ForegroundColor Yellow
    
    foreach ($colIdx in $ColumnMap.Keys) {
        if ($colIdx -ge $fields.Count) {
            continue
        }
        
        $cellValue = $fields[$colIdx].Trim()
        
        if ([string]::IsNullOrWhiteSpace($cellValue)) {
            continue
        }
        
        # Extract ability name - improved regex
        $abilityName = $null
        
        # Remove leading special chars and spaces
        $clean = $cellValue -replace '^[\s·"]+', ''
        
        # Pattern 1: Name (Abbr) - description
        if ($clean -match '^([^(]+?)\s*\([^)]+\)\s*-') {
            $abilityName = $matches[1].Trim()
        }
        # Pattern 2: Name - description (no abbr)
        elseif ($clean -match '^([^-]+?)\s*-' -and $clean -notmatch '^(Auto Grant|AutoGrant|Offensive|Defensive|Utility|Stance|Passive|Pick one|Choose one|Row \d+)') {
            $abilityName = $matches[1].Trim()
        }
        # Pattern 3: Just Name (Abbr) with no description
        elseif ($clean -match '^([^(]+?)\s*\([^)]+\)$') {
            $abilityName = $matches[1].Trim()
        }
        
        if (-not $abilityName -or $abilityName.Length -lt 3) {
            continue
        }
        
        # Clean up ability name
        $abilityName = $abilityName -replace '\s+', ' ' -replace '[·"]+$', ''
        
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
                # Don't print every skip - too verbose
                $SkipCount++
            }
        }
    }
    
    $level++
}

$parser.Close()

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
