# Build-AbilityDatabase.ps1
# Parses the Warrior progression CSV and creates comprehensive ability database

param(
    [string]$CsvPath = "Documentation\00_SourcesOfTruth\Warrior Progression for all subclasses.csv",
    [string]$OutputPath = "Documentation\00_SourcesOfTruth\AbilityDatabase_Warrior.csv"
)

$ErrorActionPreference = "Stop"

Write-Host "[INFO] Building Warrior Ability Database (Phase 2 - Full Feature Set)" -ForegroundColor Cyan
Write-Host "[INFO] Source: $CsvPath" -ForegroundColor Gray
Write-Host ""

# Import the CSV
Write-Host "[LOAD] Importing progression CSV..." -ForegroundColor Yellow
$csv = Import-Csv -Path $CsvPath

Write-Host "[INFO] Found $($csv.Count) rows" -ForegroundColor Gray
Write-Host ""

# Initialize ability collection
$abilities = @()
$abilityIdCounter = 1

# Helper function to extract ability name from description
function Get-AbilityName {
    param([string]$Text)
    
    if ([string]::IsNullOrWhiteSpace($Text)) {
        return $null
    }
    
    # Pattern: "Name (Abbr) - description" or "Name - description"
    if ($Text -match '^([^(]+?)\s*(?:\([^)]+\))?\s*-') {
        return $matches[1].Trim()
    }
    
    # Pattern: "Name" only
    if ($Text -match '^([^-]+)$') {
        return $Text.Trim()
    }
    
    return $null
}

# Helper function to create ability ID
function Get-AbilityID {
    param([string]$Name)
    
    if ([string]::IsNullOrWhiteSpace($Name)) {
        return $null
    }
    
    # Remove special characters and convert to PascalCase
    $cleanName = $Name -replace '[():]', '' -replace '\s+', '_'
    return "WAR_$cleanName"
}

# Helper function to extract abbreviation
function Get-Abbreviation {
    param([string]$Text)
    
    if ($Text -match '\(([^)]+)\)') {
        return $matches[1]
    }
    return ""
}

# Helper function to extract description
function Get-Description {
    param([string]$Text)
    
    if ([string]::IsNullOrWhiteSpace($Text)) {
        return ""
    }
    
    # Remove name and abbreviation, keep description
    $desc = $Text -replace '^[^-]+-\s*', ''
    return $desc.Trim()
}

Write-Host "[PARSE] Extracting abilities from progression table..." -ForegroundColor Yellow
Write-Host ""

# Column mappings (based on CSV structure)
$columnMappings = @{
    # Baseline columns (Auto-granted at specific levels)
    BaselineArms_Offensive = 3
    BaselineArms_Utility = 4
    BaselineProt_Offensive = 5
    BaselineProt_Utility = 6
    BaselineProt_Passive = 7
    BaselineFury_Offensive = 8
    BaselineFury_Utility = 9
    Stance1 = 10
    Stance2 = 11
    
    # Class Talents (columns 12-21 approximately)
    ClassTalent_Start = 12
    ClassTalent_End = 21
    
    # Spec Talents
    ArmsSpec_Passive = 23
    ArmsSpec_Start = 24
    ArmsSpec_End = 35
    
    FurySpec_Passive = 37
    FurySpec_Start = 38
    FurySpec_End = 48
    
    ProtSpec_Ability = 50
    ProtSpec_Start = 51
    ProtSpec_End = 57
    
    # Hero Talents (L13-L20)
    MountainThane_Start = 59
    MountainThane_End = 61
    
    Colossus_Start = 62
    Colossus_End = 64
    
    Slayer_Start = 65
    Slayer_End = 67
}

# Process each row
foreach ($row in $csv) {
    $level = $row.Level
    
    if ([string]::IsNullOrWhiteSpace($level) -or $level -notmatch '^\d+$') {
        continue
    }
    
    $levelNum = [int]$level
    
    Write-Host "[L$levelNum] Processing level $levelNum..." -ForegroundColor Cyan
    
    # Get all columns for this row
    $rowProps = $row.PSObject.Properties
    
    # Process each column
    for ($i = 0; $i -lt $rowProps.Count; $i++) {
        $colValue = $rowProps[$i].Value
        
        if ([string]::IsNullOrWhiteSpace($colValue)) {
            continue
        }
        
        $abilityName = Get-AbilityName -Text $colValue
        
        if ([string]::IsNullOrWhiteSpace($abilityName)) {
            continue
        }
        
        # Skip generic headers
        if ($abilityName -match '^(Row|Notes|Auto Grant|Choose one|Pick one|Attacks|Feats)') {
            continue
        }
        
        $abilityID = Get-AbilityID -Name $abilityName
        $abbr = Get-Abbreviation -Text $colValue
        $description = Get-Description -Text $colValue
        
        # Determine unlock source and subclass filter based on column index
        $unlockSource = "Baseline"
        $subclassFilter = "All"
        $abilityType = "Offensive"
        $bg3FileType = "Spell_Target"
        $implementationStatus = "Not Started"
        $archetypeTags = ""
        
        # Baseline abilities
        if ($i -eq 3) { 
            $unlockSource = "Baseline"; $subclassFilter = "Arms"; $abilityType = "Offensive"
        }
        elseif ($i -eq 4) { 
            $unlockSource = "Baseline"; $subclassFilter = "Arms"; $abilityType = "Utility"
        }
        elseif ($i -eq 5) { 
            $unlockSource = "Baseline"; $subclassFilter = "Protection"; $abilityType = "Offensive"
        }
        elseif ($i -eq 6) { 
            $unlockSource = "Baseline"; $subclassFilter = "Protection"; $abilityType = "Utility"
        }
        elseif ($i -eq 7) { 
            $unlockSource = "Baseline"; $subclassFilter = "Protection"; $abilityType = "Passive"; $bg3FileType = "Passive"
        }
        elseif ($i -eq 8) { 
            $unlockSource = "Baseline"; $subclassFilter = "Fury"; $abilityType = "Offensive"
        }
        elseif ($i -eq 9) { 
            $unlockSource = "Baseline"; $subclassFilter = "Fury"; $abilityType = "Utility"
        }
        elseif ($i -eq 10 -or $i -eq 11) { 
            $unlockSource = "Baseline"; $subclassFilter = "All"; $abilityType = "Passive"; $bg3FileType = "Passive"
        }
        # Class Talents (shared by all)
        elseif ($i -ge 12 -and $i -le 21) {
            $unlockSource = "Class Talent"; $subclassFilter = "All"
            if ($colValue -match '(passive|mastery|increase|grant)') {
                $abilityType = "Passive"; $bg3FileType = "Passive"
            }
        }
        # Arms Spec Talents
        elseif ($i -ge 23 -and $i -le 35) {
            $unlockSource = "Spec Talent"; $subclassFilter = "Arms"
            if ($i -eq 23 -or $colValue -match '(passive|mastery)') {
                $abilityType = "Passive"; $bg3FileType = "Passive"
            }
        }
        # Fury Spec Talents
        elseif ($i -ge 37 -and $i -le 48) {
            $unlockSource = "Spec Talent"; $subclassFilter = "Fury"
            if ($i -eq 37 -or $colValue -match '(passive|mastery)') {
                $abilityType = "Passive"; $bg3FileType = "Passive"
            }
        }
        # Protection Spec Talents
        elseif ($i -ge 50 -and $i -le 57) {
            $unlockSource = "Spec Talent"; $subclassFilter = "Protection"
            if ($colValue -match '(passive|mastery)') {
                $abilityType = "Passive"; $bg3FileType = "Passive"
            }
        }
        # Hero Talents (L13-L20 only)
        elseif ($levelNum -ge 13 -and $levelNum -le 20) {
            if ($i -ge 59 -and $i -le 61) {
                $unlockSource = "Hero Talent"; $subclassFilter = "Protection,Fury"; $abilityType = "Passive"; $bg3FileType = "Passive"
                $archetypeTags = "Mountain Thane"
            }
            elseif ($i -ge 62 -and $i -le 64) {
                $unlockSource = "Hero Talent"; $subclassFilter = "Arms,Protection"; $abilityType = "Passive"; $bg3FileType = "Passive"
                $archetypeTags = "Colossus"
            }
            elseif ($i -ge 65 -and $i -le 67) {
                $unlockSource = "Hero Talent"; $subclassFilter = "Arms,Fury"; $abilityType = "Passive"; $bg3FileType = "Passive"
                $archetypeTags = "Slayer"
            }
        }
        
        # Check for duplicates
        $existing = $abilities | Where-Object { $_.ability_id -eq $abilityID }
        
        if ($existing) {
            Write-Host "   [SKIP] Duplicate: $abilityName" -ForegroundColor DarkGray
            continue
        }
        
        # Create ability entry
        $ability = [PSCustomObject]@{
            # Core Identification
            ability_id = $abilityID
            ability_name = $abilityName
            ability_abbreviation = $abbr
            description_short = if ($description.Length -gt 100) { $description.Substring(0, 97) + "..." } else { $description }
            description_full = $description
            
            # Classification
            ability_type = $abilityType
            ability_subtype = ""
            archetype_tags = $archetypeTags
            
            # Progression
            unlock_level = $levelNum
            unlock_source = $unlockSource
            subclass_filter = $subclassFilter
            
            # Dependencies (to be filled later)
            requires_ability = ""
            unlocks_ability = ""
            replaces_ability = ""
            modified_by = ""
            
            # Resources & Costs
            wow_cost_rage = ""
            bg3_action_cost = if ($abilityType -eq "Passive") { "None" } else { "Action" }
            bg3_resource_cost = ""
            bg3_cooldown = ""
            
            # BG3 Implementation
            bg3_file_type = $bg3FileType
            bg3_spell_type = if ($bg3FileType -eq "Passive") { "N/A" } else { "Target" }
            bg3_spell_success = ""
            bg3_target_conditions = ""
            damage_formula_bg3 = ""
            status_applied = ""
            
            # Tracking
            implementation_status = $implementationStatus
            implementation_priority = ""
            implementation_notes = ""
        }
        
        $abilities += $ability
        Write-Host "   [ADD] $abilityName (ID: $abilityID) [$subclassFilter]" -ForegroundColor Green
    }
    
    Write-Host ""
}

Write-Host ""
Write-Host "[STATS] Total abilities extracted: $($abilities.Count)" -ForegroundColor Green
Write-Host ""

# Show breakdown
Write-Host "[BREAKDOWN] By unlock source:" -ForegroundColor Cyan
$abilities | Group-Object unlock_source | ForEach-Object {
    Write-Host "   $($_.Name): $($_.Count)" -ForegroundColor Gray
}

Write-Host ""
Write-Host "[BREAKDOWN] By subclass:" -ForegroundColor Cyan
$abilities | Group-Object subclass_filter | ForEach-Object {
    Write-Host "   $($_.Name): $($_.Count)" -ForegroundColor Gray
}

Write-Host ""
Write-Host "[BREAKDOWN] By ability type:" -ForegroundColor Cyan
$abilities | Group-Object ability_type | ForEach-Object {
    Write-Host "   $($_.Name): $($_.Count)" -ForegroundColor Gray
}

Write-Host ""

# Export to CSV
Write-Host "[SAVE] Exporting to CSV..." -ForegroundColor Yellow
$abilities | Export-Csv -Path $OutputPath -NoTypeInformation -Encoding UTF8

Write-Host "[DONE] Database saved to: $OutputPath" -ForegroundColor Green
Write-Host ""
Write-Host "[INFO] Total columns: $($abilities[0].PSObject.Properties.Count)" -ForegroundColor Cyan
Write-Host "[INFO] Total abilities: $($abilities.Count)" -ForegroundColor Cyan
Write-Host ""
Write-Host "[COMPLETE] Ability database creation complete!" -ForegroundColor Green
