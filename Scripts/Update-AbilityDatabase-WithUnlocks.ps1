# Update AbilityDatabase with per-subclass unlock columns
# Reads from Warrior Progression CSV and AbilityDatabase, outputs updated database

param(
    [string]$ProgressionCsvPath = "C:\Users\tenod\source\repos\BG3Mods\Documentation\00_SourcesOfTruth\Warrior Progression for all subclasses and Default hero structure.csv",
    [string]$DatabaseCsvPath = "C:\Users\tenod\source\repos\BG3Mods\Documentation\00_SourcesOfTruth\AbilityDatabase_Warrior_FullyEnriched.csv",
    [string]$OutputCsvPath = "C:\Users\tenod\source\repos\BG3Mods\Documentation\00_SourcesOfTruth\AbilityDatabase_Warrior_FullyEnriched.csv"
)

Write-Host "=== Updating AbilityDatabase with per-subclass unlock columns ===" -ForegroundColor Cyan

# Import CSVs
Write-Host "Reading Progression CSV..." -ForegroundColor Yellow
$progressionData = Import-Csv $ProgressionCsvPath -Encoding UTF8

Write-Host "Reading AbilityDatabase..." -ForegroundColor Yellow
$databaseData = Import-Csv $DatabaseCsvPath -Encoding UTF8

Write-Host "Found $($progressionData.Count) progression rows" -ForegroundColor Green
Write-Host "Found $($databaseData.Count) ability rows" -ForegroundColor Green

# Build ability unlock mapping from Progression CSV
Write-Host "`nBuilding unlock level mapping..." -ForegroundColor Yellow

$abilityUnlocks = @{}

# Process each level (rows in Progression CSV)
foreach ($row in $progressionData) {
    $level = $row.Level
    if (-not $level -or $level -eq "Level") { continue }
    
    Write-Host "Processing Level $level..." -ForegroundColor Gray
    
    # Get all properties (columns) for this row
    $properties = $row.PSObject.Properties
    
    foreach ($prop in $properties) {
        $colName = $prop.Name
        $cellValue = $prop.Value
        
        if (-not $cellValue -or $cellValue.Trim() -eq "") { continue }
        
        # Determine subclass from column index
        $colIndex = [array]::IndexOf([array]($properties.Name), $colName)
        
        # Extract ability name from cell (format: "AbilityName(abbreviation) - description")
        if ($cellValue -match '^([^(�]+)[\(�]') {
            $abilityName = $matches[1].Trim()
            
            # Determine which subclass this column belongs to
            $subclass = ""
            if ($colIndex -ge 3 -and $colIndex -le 4) { $subclass = "arms" }
            elseif ($colIndex -ge 5 -and $colIndex -le 7) { $subclass = "protection" }
            elseif ($colIndex -ge 8 -and $colIndex -le 9) { $subclass = "fury" }
            elseif ($colIndex -ge 10 -and $colIndex -le 11) { $subclass = "all" } # Stances
            elseif ($colIndex -ge 11 -and $colIndex -le 22) { $subclass = "all" } # Class Talents
            elseif ($colIndex -ge 23 -and $colIndex -le 35) { $subclass = "arms" } # Arms Spec
            elseif ($colIndex -ge 36 -and $colIndex -le 46) { $subclass = "fury" } # Fury Spec
            elseif ($colIndex -ge 47 -and $colIndex -le 54) { $subclass = "protection" } # Protection Spec
            elseif ($colIndex -ge 55 -and $colIndex -le 57) { $subclass = "hero_mt" } # Mountain Thane
            elseif ($colIndex -ge 58 -and $colIndex -le 60) { $subclass = "hero_colossus" } # Colossus
            elseif ($colIndex -ge 61 -and $colIndex -le 63) { $subclass = "hero_slayer" } # Slayer
            
            if (-not $abilityUnlocks.ContainsKey($abilityName)) {
                $abilityUnlocks[$abilityName] = @{
                    arms = ""
                    fury = ""
                    protection = ""
                }
            }
            
            # Store the earliest unlock level for each subclass
            if ($subclass -eq "all") {
                # Class talents/stances - available to all subclasses
                foreach ($sc in @("arms", "fury", "protection")) {
                    if (-not $abilityUnlocks[$abilityName][$sc] -or [int]$level -lt [int]$abilityUnlocks[$abilityName][$sc]) {
                        $abilityUnlocks[$abilityName][$sc] = $level
                    }
                }
            }
            elseif ($subclass -eq "hero_mt") {
                # Mountain Thane - Fury + Protection
                foreach ($sc in @("fury", "protection")) {
                    if (-not $abilityUnlocks[$abilityName][$sc] -or [int]$level -lt [int]$abilityUnlocks[$abilityName][$sc]) {
                        $abilityUnlocks[$abilityName][$sc] = $level
                    }
                }
            }
            elseif ($subclass -eq "hero_colossus") {
                # Colossus - Arms + Protection
                foreach ($sc in @("arms", "protection")) {
                    if (-not $abilityUnlocks[$abilityName][$sc] -or [int]$level -lt [int]$abilityUnlocks[$abilityName][$sc]) {
                        $abilityUnlocks[$abilityName][$sc] = $level
                    }
                }
            }
            elseif ($subclass -eq "hero_slayer") {
                # Slayer - Arms + Fury
                foreach ($sc in @("arms", "fury")) {
                    if (-not $abilityUnlocks[$abilityName][$sc] -or [int]$level -lt [int]$abilityUnlocks[$abilityName][$sc]) {
                        $abilityUnlocks[$abilityName][$sc] = $level
                    }
                }
            }
            else {
                # Subclass-specific
                if (-not $abilityUnlocks[$abilityName][$subclass] -or [int]$level -lt [int]$abilityUnlocks[$abilityName][$subclass]) {
                    $abilityUnlocks[$abilityName][$subclass] = $level
                }
            }
        }
    }
}

Write-Host "Built unlock mapping for $($abilityUnlocks.Count) abilities" -ForegroundColor Green

# Update database with new columns
Write-Host "`nUpdating AbilityDatabase..." -ForegroundColor Yellow

$updatedRows = @()
$matchCount = 0
$noMatchCount = 0

foreach ($ability in $databaseData) {
    $abilityName = $ability.ability_name
    
    # Create new row with updated structure
    $newRow = [ordered]@{}
    
    # Copy all existing columns except unlock_level
    foreach ($prop in $ability.PSObject.Properties) {
        if ($prop.Name -ne "unlock_level") {
            $newRow[$prop.Name] = $prop.Value
        }
        
        # Insert new columns after "archetype_tags"
        if ($prop.Name -eq "archetype_tags") {
            # Try to find matching ability (handle special characters)
            $cleanName = $abilityName -replace '�', '' -replace '["""'']', '' -replace '\s+', ' '
            
            $matchedUnlock = $null
            foreach ($key in $abilityUnlocks.Keys) {
                $cleanKey = $key -replace '�', '' -replace '["""'']', '' -replace '\s+', ' '
                if ($cleanKey -eq $cleanName -or $key -eq $abilityName) {
                    $matchedUnlock = $abilityUnlocks[$key]
                    $matchCount++
                    break
                }
            }
            
            if (-not $matchedUnlock) {
                $noMatchCount++
            }
            
            $newRow["warrior_unlock"] = "" # Always empty (not used)
            $newRow["arms_unlock"] = if ($matchedUnlock) { $matchedUnlock.arms } else { "" }
            $newRow["fury_unlock"] = if ($matchedUnlock) { $matchedUnlock.fury } else { "" }
            $newRow["protection_unlock"] = if ($matchedUnlock) { $matchedUnlock.protection } else { "" }
        }
    }
    
    $updatedRows += [PSCustomObject]$newRow
}

Write-Host "Matched $matchCount abilities" -ForegroundColor Green
Write-Host "No match found for $noMatchCount abilities" -ForegroundColor Yellow

# Export updated database
Write-Host "`nExporting updated database..." -ForegroundColor Yellow
$updatedRows | Export-Csv -Path $OutputCsvPath -NoTypeInformation -Encoding UTF8

Write-Host "=== Database updated successfully! ===" -ForegroundColor Green
Write-Host "Output: $OutputCsvPath" -ForegroundColor Cyan
