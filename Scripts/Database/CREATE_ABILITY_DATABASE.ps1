# CREATE_ABILITY_DATABASE.ps1
# One-shot script to create the comprehensive ability database
# Run this once to generate the complete Phase 2 database

$outputPath = "Documentation\00_SourcesOfTruth\AbilityDatabase_Warrior.csv"

Write-Host "Creating Warrior Ability Database..." -ForegroundColor Cyan
Write-Host ""

# Load progression CSV
$csv = Import-Csv "Documentation\00_SourcesOfTruth\Warrior Progression for all subclasses.csv" -WarningAction SilentlyContinue

$abilities = @()
$processedIds = @{}

# Process each level
for ($i = 0; $i -lt $csv.Count; $i++) {
    $row = $csv[$i]
    $level = $row.Level
    
    if ($level -match '^\d+$') {
        $lvl = [int]$level
        
        # Get all columns
        $props = $row.PSObject.Properties
        
        foreach ($prop in $props) {
            $colName = $prop.Name
            $value = $prop.Value
            
            if ([string]::IsNullOrWhiteSpace($value) -or $value -match '^(Auto|Choose|Pick|Row |Notes)') {
                continue
            }
            
            # Clean text
            $cleanValue = $value.Trim()
            
            # Extract name (before first parenthesis or dash)
            $name = ""
            $abbr = ""
            $desc = ""
            
            if ($cleanValue -match '^(.+?)\s*\(([^)]+)\)\s*-\s*(.+)$') {
                $name = $matches[1].Trim()
                $abbr = $matches[2].Trim()
                $desc = $matches[3].Trim()
            }
            elseif ($cleanValue -match '^(.+?)\s*-\s*(.+)$') {
                $name = $matches[1].Trim()
                $desc = $matches[2].Trim()
            }
            else {
                $name = $cleanValue
            }
            
            if ($name.Length -eq 0) { continue }
            
            # Create ID
            $id = "WAR_" + ($name -replace '[^a-zA-Z0-9]', '_' -replace '_+', '_')
            
            # Skip duplicates
            if ($processedIds.ContainsKey($id)) { continue }
            $processedIds[$id] = $true
            
            # Determine metadata based on column name
            $source = "Baseline"
            $subclass = "All"
            $type = "Offensive"
            $fileType = "Spell_Target"
            
            if ($colName -like "*Baseline*Arms*") {
                $source = "Baseline"; $subclass = "Arms"
            }
            elseif ($colName -like "*Baseline*Protection*") {
                $source = "Baseline"; $subclass = "Protection"
            }
            elseif ($colName -like "*Baseline*Fury*") {
                $source = "Baseline"; $subclass = "Fury"
            }
            elseif ($colName -like "*Class Talents*") {
                $source = "Class Talent"; $subclass = "All"
            }
            elseif ($colName -like "*Arms Spec*") {
                $source = "Spec Talent"; $subclass = "Arms"
            }
            elseif ($colName -like "*Fury Spec*") {
                $source = "Spec Talent"; $subclass = "Fury"
            }
            elseif ($colName -like "*Protection*Spec*") {
                $source = "Spec Talent"; $subclass = "Protection"
            }
            elseif ($colName -like "*Mountain Thane*") {
                $source = "Hero Talent"; $subclass = "Protection,Fury"; $type = "Passive"; $fileType = "Passive"
            }
            elseif ($colName -like "*Colossus*") {
                $source = "Hero Talent"; $subclass = "Arms,Protection"; $type = "Passive"; $fileType = "Passive"
            }
            elseif ($colName -like "*Slayer*") {
                $source = "Hero Talent"; $subclass = "Arms,Fury"; $type = "Passive"; $fileType = "Passive"
            }
            
            # Determine type from description
            if ($desc -match 'passive|mastery|increase|grant') {
                $type = "Passive"; $fileType = "Passive"
            }
            elseif ($desc -match 'heal|defensive|reduce damage|shield|block') {
                $type = "Defensive"
            }
            elseif ($desc -match 'charge|leap|mobility|sprint') {
                $type = "Utility"
            }
            
            # Create ability object
            $abilities += [PSCustomObject]@{
                ability_id = $id
                ability_name = $name
                ability_abbreviation = $abbr
                description_short = if ($desc.Length -gt 100) { $desc.Substring(0, 97) + "..." } else { $desc }
                description_full = $desc
                ability_type = $type
                ability_subtype = ""
                archetype_tags = ""
                unlock_level = $lvl
                unlock_source = $source
                subclass_filter = $subclass
                requires_ability = ""
                unlocks_ability = ""
                replaces_ability = ""
                modified_by = ""
                wow_cost_rage = ""
                bg3_action_cost = if ($type -eq "Passive") { "None" } else { "Action" }
                bg3_resource_cost = ""
                bg3_cooldown = ""
                bg3_file_type = $fileType
                bg3_spell_type = if ($type -eq "Passive") { "N/A" } else { "Target" }
                bg3_spell_success = ""
                bg3_target_conditions = ""
                damage_formula_bg3 = ""
                status_applied = ""
                implementation_status = "Not Started"
                implementation_priority = ""
                implementation_notes = ""
            }
        }
    }
}

Write-Host "Extracted $($abilities.Count) abilities" -ForegroundColor Green
Write-Host ""

# Export
$abilities | Export-Csv -Path $outputPath -NoTypeInformation -Encoding UTF8

Write-Host "Database saved to: $outputPath" -ForegroundColor Cyan
Write-Host "Total abilities: $($abilities.Count)" -ForegroundColor Green
Write-Host "Columns: $($abilities[0].PSObject.Properties.Count)" -ForegroundColor Green
