# ============================================================================
# Warrior Progression CSV Re-Linking Script
# ============================================================================
# Purpose: Re-links Warrior Progression CSV with AbilityDatabase after fixes
# Last Updated: October 23, 2025
# ============================================================================

param(
    [string]$OutputFormat = "v2", # "v1" = ID only, "v2" = Name - ID format
    [switch]$Verbose
)

Write-Host "========================================" -ForegroundColor Cyan
Write-Host " Warrior Progression Re-Linking Script" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Paths
$ProgressionPath = "C:\Users\tenod\source\repos\BG3Mods\Documentation\00_SourcesOfTruth\Warrior Progression for all subclasses and Default hero structure.csv"
$DatabasePath = "C:\Users\tenod\source\repos\BG3Mods\Documentation\00_SourcesOfTruth\AbilityDatabase_Warrior_FullyEnriched.csv"
$OutputPath = "C:\Users\tenod\source\repos\BG3Mods\Documentation\00_SourcesOfTruth\Warrior Progression LINKED.csv"
$ReportPath = "C:\Users\tenod\source\repos\BG3Mods\Documentation\00_SourcesOfTruth\Linking_Report.txt"

# Load database
Write-Host "[INFO] Loading AbilityDatabase..." -ForegroundColor Cyan
$Database = Import-Csv $DatabasePath -Encoding UTF8
Write-Host "[SUCCESS] Loaded $($Database.Count) abilities from database" -ForegroundColor Green
Write-Host ""

# Build ability map
Write-Host "[INFO] Building ability lookup map..." -ForegroundColor Cyan
$AbilityMap = @{}
foreach ($row in $Database) {
    $name = $row.ability_name.Trim()
    $id = $row.ability_id.Trim()
    
    if ($name -and $id) {
        if ($OutputFormat -eq "v2") {
            $AbilityMap[$name.ToLower()] = @{Name=$name; Id=$id}
        } else {
            $AbilityMap[$name.ToLower()] = $id
        }
        
        # Add variants for fuzzy matching
        $AbilityMap[$name.ToLower().Replace("'", "'")] = if ($OutputFormat -eq "v2") { @{Name=$name; Id=$id} } else { $id }
        $AbilityMap[$name.ToLower().Replace("'", "'")] = if ($OutputFormat -eq "v2") { @{Name=$name; Id=$id} } else { $id }
        $AbilityMap[$name.ToLower().Replace(' ', '')] = if ($OutputFormat -eq "v2") { @{Name=$name; Id=$id} } else { $id }
        $AbilityMap[$name.ToLower().Replace('-', ' ')] = if ($OutputFormat -eq "v2") { @{Name=$name; Id=$id} } else { $id }
    }
}
Write-Host "[SUCCESS] Created lookup map with $($AbilityMap.Count) entries" -ForegroundColor Green
Write-Host ""

# Process progression CSV
Write-Host "[INFO] Processing Warrior Progression CSV..." -ForegroundColor Cyan
$Unmapped = @()
$Mapped = @()

$Content = Get-Content $ProgressionPath -Raw -Encoding UTF8
$Content = $Content -replace '�', ''  # Clean any remaining Unicode issues
$Lines = $Content -split "`r?`n"
$OutputLines = @()

for ($i = 0; $i -lt $Lines.Count; $i++) {
    $line = $Lines[$i]
    
    # Keep header rows unchanged
    if ($i -lt 3) {
        $OutputLines += $line
        continue
    }
    
    # Parse CSV line (handle quoted fields)
    $cells = $line -split ',(?=(?:[^"]*"[^"]*")*[^"]*$)'
    $newCells = @()
    
    foreach ($cell in $cells) {
        $cleanCell = $cell.Trim()
        
        # Skip special cells
        if ($cleanCell -eq '' -or $cleanCell -match '^Level \d+$' -or $cleanCell -eq 'Add Feat' -or $cleanCell -eq 'Grant Extra Attack') {
            $newCells += $cell
            continue
        }
        
        $originalCell = $cleanCell
        $cleanCell = $cleanCell -replace '^[\s]+', '' -replace '[\s]+$', ''
        
        # Check if cell already has ability_id format (from previous linking)
        if ($cleanCell -match '^(.+?)\s*\(WAR__[\w_]+\)$') {
            $abilityName = $Matches[1].Trim()
            $lookupKey = $abilityName.ToLower()
            
            if ($AbilityMap.ContainsKey($lookupKey)) {
                if ($OutputFormat -eq "v2") {
                    $newCells += "$($AbilityMap[$lookupKey].Name) - $($AbilityMap[$lookupKey].Id)"
                    $Mapped += "$abilityName -> $($AbilityMap[$lookupKey].Name) - $($AbilityMap[$lookupKey].Id)"
                } else {
                    $newCells += $AbilityMap[$lookupKey]
                    $Mapped += "$abilityName -> $($AbilityMap[$lookupKey])"
                }
            } else {
                $newCells += $originalCell
                $Unmapped += "EXACT: $abilityName (in cell: $originalCell)"
            }
        }
        # Process clean ability names
        elseif ($cleanCell) {
            $lookupKey = $cleanCell.ToLower()
            $found = $false
            
            # Try exact match
            if ($AbilityMap.ContainsKey($lookupKey)) {
                if ($OutputFormat -eq "v2") {
                    $newCells += "$($AbilityMap[$lookupKey].Name) - $($AbilityMap[$lookupKey].Id)"
                    $Mapped += "$cleanCell -> $($AbilityMap[$lookupKey].Name) - $($AbilityMap[$lookupKey].Id)"
                } else {
                    $newCells += $AbilityMap[$lookupKey]
                    $Mapped += "$cleanCell -> $($AbilityMap[$lookupKey])"
                }
                $found = $true
            }
            # Try fuzzy match
            else {
                foreach ($key in $AbilityMap.Keys) {
                    if ($key -like "*$lookupKey*" -or $lookupKey -like "*$key*") {
                        if ($OutputFormat -eq "v2") {
                            $newCells += "$($AbilityMap[$key].Name) - $($AbilityMap[$key].Id)"
                            $Mapped += "FUZZY: $cleanCell -> $($AbilityMap[$key].Name) - $($AbilityMap[$key].Id)"
                        } else {
                            $newCells += $AbilityMap[$key]
                            $Mapped += "FUZZY: $cleanCell -> $($AbilityMap[$key])"
                        }
                        $found = $true
                        break
                    }
                }
                
                if (-not $found) {
                    $newCells += $originalCell
                    $Unmapped += "NO MATCH: $cleanCell (in cell: $originalCell)"
                }
            }
        }
        else {
            $newCells += $cell
        }
    }
    
    $OutputLines += ($newCells -join ',')
}

# Write output
Write-Host "[INFO] Writing output file..." -ForegroundColor Cyan
$OutputLines -join "`r`n" | Set-Content $OutputPath -Encoding UTF8
Write-Host "[SUCCESS] Created: $OutputPath" -ForegroundColor Green
Write-Host ""

# Generate report
Write-Host "[INFO] Generating linking report..." -ForegroundColor Cyan
$ReportContent = @"
=== ABILITY LINKING REPORT ===
Date: $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")
Format: $(if ($OutputFormat -eq "v2") { "Ability Name - ability_id" } else { "ability_id only" })

Source: Warrior Progression for all subclasses and Default hero structure.csv
Database: AbilityDatabase_Warrior_FullyEnriched.csv
Output: Warrior Progression LINKED.csv

STATISTICS:
- Total abilities mapped: $($Mapped.Count)
- Total abilities unmapped: $($Unmapped.Count)

=== UNMAPPED ABILITIES (REQUIRES REVIEW) ===

$($Unmapped -join "`n")

=== MAPPED ABILITIES (SUCCESSFUL) ===

$($Mapped | Select-Object -First 50 -join "`n")
... and $($Mapped.Count - 50) more

"@

$ReportContent | Set-Content $ReportPath -Encoding UTF8
Write-Host "[SUCCESS] Created: $ReportPath" -ForegroundColor Green
Write-Host ""

# Summary
Write-Host "========================================" -ForegroundColor Green
Write-Host " LINKING COMPLETE!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host "Format: $(if ($OutputFormat -eq "v2") { "Ability Name - ability_id" } else { "ability_id only" })" -ForegroundColor Cyan
Write-Host "- Mapped: $($Mapped.Count) abilities" -ForegroundColor Cyan
Write-Host "- Unmapped: $($Unmapped.Count) abilities" -ForegroundColor $(if ($Unmapped.Count -eq 0) { "Green" } else { "Yellow" })
Write-Host ""
Write-Host "Output: Warrior Progression LINKED.csv" -ForegroundColor White
Write-Host "Report: Linking_Report.txt" -ForegroundColor White
Write-Host ""

if ($Unmapped.Count -eq 0) {
    Write-Host "[SUCCESS] 100% MAPPING ACHIEVED! Ready for FILE 12 transformation!" -ForegroundColor Green
} else {
    Write-Host "[WARN] $($Unmapped.Count) abilities still unmapped. Review Linking_Report.txt" -ForegroundColor Yellow
}
