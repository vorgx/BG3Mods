# Generate Passive.txt from AbilityDatabase
# Date: October 24, 2025
# Purpose: Create all 160 passive entries for Warrior mod

param(
    [string]$DatabasePath = "C:\Users\tenod\source\repos\BG3Mods\Documentation\00_SourcesOfTruth\AbilityDatabase_Warrior_FullyEnriched.csv",
    [string]$OutputPath = "C:\Users\tenod\source\repos\BG3Mods\Data\Public\Warrior_Wow_78fe4967-4e62-5491-d981-dd781acca4d7\Stats\Generated\Data\Passive.txt",
    [switch]$DryRun
)

Write-Host "=== Warrior Passive.txt Generator ===" -ForegroundColor Cyan
Write-Host ""

# Load database
Write-Host "[1/5] Loading AbilityDatabase..." -ForegroundColor Yellow
$Db = Import-Csv $DatabasePath -Encoding UTF8

# Filter passives
$Passives = $Db | Where-Object { $_.bg3_file_type -eq "Passive" }
Write-Host "Found: $($Passives.Count) passives" -ForegroundColor Green
Write-Host ""

# Group by category for organization
Write-Host "[2/5] Organizing passives by category..." -ForegroundColor Yellow
$HeroTalents = $Passives | Where-Object { $_.unlock_source -eq "Hero Talent" }
$SpecTalents = $Passives | Where-Object { $_.unlock_source -eq "Spec Talent" }
$Baseline = $Passives | Where-Object { $_.unlock_source -eq "Baseline" }
$Other = $Passives | Where-Object { $_.unlock_source -notin @("Hero Talent", "Spec Talent", "Baseline") }

Write-Host "  Hero Talents: $($HeroTalents.Count)" -ForegroundColor Cyan
Write-Host "  Spec Talents: $($SpecTalents.Count)" -ForegroundColor Cyan
Write-Host "  Baseline: $($Baseline.Count)" -ForegroundColor Cyan
Write-Host "  Other: $($Other.Count)" -ForegroundColor Cyan
Write-Host ""

# Generate file content
Write-Host "[3/5] Generating Passive.txt content..." -ForegroundColor Yellow

$Content = @()

# Header
$Content += "// ========================================"
$Content += "// WARRIOR PASSIVE DEFINITIONS"
$Content += "// Generated: $(Get-Date -Format 'MMMM dd, yyyy')"
$Content += "// Patch: 8 Compatible (4.8.0.10)"
$Content += "// Source: AbilityDatabase_Warrior_FullyEnriched.csv"
$Content += "// ========================================"
$Content += "// Total Passives: $($Passives.Count)"
$Content += "// - Hero Talents: $($HeroTalents.Count)"
$Content += "// - Spec Talents: $($SpecTalents.Count)"
$Content += "// - Baseline: $($Baseline.Count)"
$Content += "// - Other: $($Other.Count)"
$Content += "// ========================================"
$Content += ""

# Function to generate passive entry
function New-PassiveEntry {
    param($Ability)
    
    $Entry = @()
    $Entry += "// $($Ability.ability_name)"
    if ($Ability.implementation_notes) {
        $Entry += "// Implementation: $($Ability.implementation_notes)"
    }
    $Entry += "new entry `"$($Ability.ability_id)`""
    $Entry += "type `"PassiveData`""
    
    # DisplayName and Description (placeholder handles)
    $Entry += "data `"DisplayName`" `"h123abc01;1`"  // TODO: Generate proper localization handle"
    $Entry += "data `"Description`" `"h123abc02;1`"  // TODO: Generate proper localization handle"
    
    # Icon (use generic placeholder for now)
    $IconName = "PassiveFeature_Generic_Damage"
    if ($Ability.ability_name -match "Lightning|Thunder|Storm") { $IconName = "PassiveFeature_Generic_Lightning" }
    elseif ($Ability.ability_name -match "Shield|Block|Defense") { $IconName = "PassiveFeature_Generic_Shield" }
    elseif ($Ability.ability_name -match "Bleed|Blood") { $IconName = "PassiveFeature_Generic_Blood" }
    elseif ($Ability.ability_name -match "Armor|Plate") { $IconName = "PassiveFeature_Generic_Armor" }
    
    $Entry += "data `"Icon`" `"$IconName`"  // TODO: Create custom icon"
    $Entry += "data `"Properties`" `"Highlighted`""
    
    # Add implementation notes as comment if available
    if ($Ability.bg3_mechanic_equivalent -and $Ability.bg3_mechanic_equivalent -ne "N/A") {
        $Entry += "// BG3 Mechanic: $($Ability.bg3_mechanic_equivalent)"
    }
    
    # Add boosts/functors based on implementation notes
    if ($Ability.implementation_notes) {
        $Notes = $Ability.implementation_notes
        
        # Parse implementation notes for common patterns
        if ($Notes -match "UnlockSpell") {
            $Entry += "data `"Boosts`" `"UnlockSpell(WAR_PLACEHOLDER);`"  // TODO: Specify spell to unlock"
        }
        elseif ($Notes -match "DealDamage|Damage") {
            $Entry += "data `"StatsFunctorContext`" `"OnDamage`""
            $Entry += "data `"Conditions`" `"HasPassive('$($Ability.ability_id)',context.Source)`"  // TODO: Add specific conditions"
            $Entry += "data `"StatsFunctors`" `"DealDamage(1d6,Physical,Magical)`"  // TODO: Use correct damage formula"
        }
        elseif ($Notes -match "ApplyStatus") {
            $Entry += "data `"StatsFunctorContext`" `"OnCast`""
            $Entry += "data `"Conditions`" `"HasPassive('$($Ability.ability_id)',context.Source)`"  // TODO: Add specific conditions"
            $Entry += "data `"StatsFunctors`" `"ApplyStatus(SELF,WAR_STATUS_PLACEHOLDER,100,6)`"  // TODO: Specify status"
        }
        elseif ($Notes -match "Proficiency|Advantage") {
            $Entry += "data `"Boosts`" `"Advantage(AttackRoll,1)`"  // TODO: Specify correct boost"
        }
        else {
            # Generic template
            $Entry += "// TODO: Implement passive mechanics based on:"
            $Entry += "// $Notes"
            $Entry += "data `"Boosts`" `"Placeholder();`"  // TODO: Replace with actual boosts"
        }
    }
    else {
        # No implementation notes - add generic template
        $Entry += "// TODO: No implementation notes available"
        $Entry += "data `"Boosts`" `"Placeholder();`"  // TODO: Implement passive effect"
    }
    
    $Entry += ""
    return $Entry
}

# Generate Hero Talents section
if ($HeroTalents.Count -gt 0) {
    $Content += "// ========================================"
    $Content += "// HERO TALENTS"
    $Content += "// ========================================"
    $Content += ""
    
    # Group by hero tree
    $MountainThane = $HeroTalents | Where-Object { $_.ability_name -match "Mountain|Thunder|Lightning|Storm" }
    $Colossus = $HeroTalents | Where-Object { $_.ability_name -match "Colossus|Titan|Immovable|Dominance" }
    $Slayer = $HeroTalents | Where-Object { $_.ability_name -match "Slayer|Execute|Finish|Brutal" }
    
    if ($MountainThane.Count -gt 0) {
        $Content += "// --- MOUNTAIN THANE (Fury + Protection) ---"
        $Content += ""
        foreach ($Ability in $MountainThane) {
            $Content += New-PassiveEntry $Ability
        }
    }
    
    if ($Colossus.Count -gt 0) {
        $Content += "// --- COLOSSUS (Arms + Protection) ---"
        $Content += ""
        foreach ($Ability in $Colossus) {
            $Content += New-PassiveEntry $Ability
        }
    }
    
    if ($Slayer.Count -gt 0) {
        $Content += "// --- SLAYER (Arms + Fury) ---"
        $Content += ""
        foreach ($Ability in $Slayer) {
            $Content += New-PassiveEntry $Ability
        }
    }
}

# Generate Spec Talents section
if ($SpecTalents.Count -gt 0) {
    $Content += "// ========================================"
    $Content += "// SPEC TALENTS"
    $Content += "// ========================================"
    $Content += ""
    
    foreach ($Ability in $SpecTalents) {
        $Content += New-PassiveEntry $Ability
    }
}

# Generate Baseline section (Class + Subclass Talents)
if ($Baseline.Count -gt 0) {
    $Content += "// ========================================"
    $Content += "// BASELINE PASSIVES (Class + Subclass Talents)"
    $Content += "// ========================================"
    $Content += ""
    
    foreach ($Ability in $Baseline) {
        $Content += New-PassiveEntry $Ability
    }
}

Write-Host "Generated: $($Content.Count) lines" -ForegroundColor Green
Write-Host ""

# Write to file or display dry run
if ($DryRun) {
    Write-Host "[4/5] DRY RUN - Displaying first 50 lines..." -ForegroundColor Yellow
    $Content[0..50] | ForEach-Object { Write-Host $_ -ForegroundColor Gray }
    Write-Host "..." -ForegroundColor Gray
    Write-Host ""
    Write-Host "[5/5] DRY RUN COMPLETE - No files written" -ForegroundColor Green
    Write-Host "Run without -DryRun to write to: $OutputPath" -ForegroundColor Cyan
}
else {
    Write-Host "[4/5] Writing to: $OutputPath" -ForegroundColor Yellow
    
    # Create backup of existing file if it exists
    if (Test-Path $OutputPath) {
        $BackupPath = $OutputPath -replace '\.txt$', "_BACKUP_$(Get-Date -Format 'yyyyMMdd_HHmmss').txt"
        Copy-Item $OutputPath $BackupPath -Force
        Write-Host "Backup created: $BackupPath" -ForegroundColor Cyan
    }
    
    # Write new file
    $Content | Out-File $OutputPath -Encoding UTF8 -Force
    Write-Host "File written successfully!" -ForegroundColor Green
    Write-Host ""
    
    Write-Host "[5/5] Validation..." -ForegroundColor Yellow
    $WrittenLines = (Get-Content $OutputPath).Count
    $WrittenEntries = (Get-Content $OutputPath | Select-String "^new entry").Count
    Write-Host "Lines written: $WrittenLines" -ForegroundColor Cyan
    Write-Host "Entries written: $WrittenEntries" -ForegroundColor Cyan
    Write-Host ""
    
    if ($WrittenEntries -eq $Passives.Count) {
        Write-Host "✅ SUCCESS: All $($Passives.Count) passives generated!" -ForegroundColor Green
    }
    else {
        Write-Host "⚠️  WARNING: Expected $($Passives.Count) entries, but wrote $WrittenEntries" -ForegroundColor Yellow
    }
}

Write-Host ""
Write-Host "=== Generation Complete ===" -ForegroundColor Cyan
