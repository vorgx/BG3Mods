param(
    [switch]$DryRun
)

# ========================================
# CONFIGURATION
# ========================================
$DbPath = "C:\Users\tenod\source\repos\BG3Mods\Documentation\00_SourcesOfTruth\AbilityDatabase_Warrior_FullyEnriched.csv"
$OutputPath = "C:\Users\tenod\source\repos\BG3Mods\Data\Public\Warrior_Wow_78fe4967-4e62-5491-d981-dd781acca4d7\Stats\Generated\Data\Spell_Target.txt"
$BackupPath = "C:\Users\tenod\source\repos\BG3Mods\Data\Public\Warrior_Wow_78fe4967-4e62-5491-d981-dd781acca4d7\Stats\Generated\Data\Spell_Target_BACKUP_$(Get-Date -Format 'yyyyMMdd_HHmmss').txt"

# ========================================
# LOAD DATABASE
# ========================================
Write-Host "Loading database from: $DbPath" -ForegroundColor Cyan
$Db = Import-Csv -Path $DbPath

$SpellTargets = $Db | Where-Object { $_.bg3_file_type -eq "Spell_Target" }
Write-Host "Found $($SpellTargets.Count) Spell_Target abilities" -ForegroundColor Green

# ========================================
# GENERATE SPELL ENTRIES
# ========================================

function New-SpellTargetEntry {
    param($Ability)
    
    $entry = @"

// $($Ability.ability_name)
// Implementation: $($Ability.implementation_notes)
new entry "Target_$($Ability.ability_id)"
type "SpellData"
data "SpellType" "Target"
data "Level" "0"
data "SpellSchool" "Evocation"
data "AIFlags" "CanNotUse"
data "UseCosts" "ActionPoint:1;Rage:$($Ability.rage_cost)"
data "SpellProperties" ""
data "TargetConditions" "Character() and not Dead()"
data "Icon" "Action_Attack"  // TODO: Create custom icon
data "DisplayName" "h123abc01;1"  // TODO: Generate proper localization handle
data "Description" "h123abc02;1"  // TODO: Generate proper localization handle
data "TooltipDamageList" "DealDamage(1d6,Physical)"  // TODO: Use correct damage formula
data "TooltipAttackSave" "MeleeWeaponAttack"
data "PrepareEffect" "VFX_Barbarian_Rage_Prepare:Dummy_BodyFX;VFX_Weapons_Fire_Glow_01:Dummy_MainHandFX"  // TODO: Replace with Warrior VFX
data "CastEffect" "RS3_Impact_Blood_Celestial_01:TargetPosition:attach"  // TODO: Replace with Warrior VFX
data "TargetEffect" "RS3_Explosion_Blood_01"  // TODO: Replace with Warrior VFX
data "SpellAnimation" "Action_Attack;::;8f46d84d-6bce-4e89-8c32-01f0dc0d72ce;;Sitting;Self;true;0b07883a-08b8-43b6-ac18-84dc9e84ff50,,"  // TODO: Use Barbarian/Fighter martial animation
data "VerbalIntent" "Damage"
data "SpellFlags" "HasVerbalComponent;IsSpell;HasHighGroundRangeExtension"
data "SpellSuccess" "DealDamage(MainMeleeWeapon,MainMeleeWeaponDamageType,Magical)"  // TODO: Replace with actual mechanics
// BG3 Mechanic: $($Ability.bg3_mechanic_equivalent)
// TODO: Implement spell mechanics based on:
// $($Ability.implementation_notes)

"@
    return $entry
}

# ========================================
# CATEGORIZE ABILITIES (mutually exclusive)
# ========================================
# First, identify shared/baseline abilities (available to all specs)
$SharedAbilities = $SpellTargets | Where-Object { $_.subclass_filter -eq "All" }

# Then categorize spec-specific abilities (not in shared list)
$ArmsAbilities = $SpellTargets | Where-Object { 
    $_.subclass_filter -ne "All" -and 
    ($_.subclass_filter -like "*Arms*" -or $_.arms_unlock -ne "") 
}
$FuryAbilities = $SpellTargets | Where-Object { 
    $_.subclass_filter -ne "All" -and 
    ($_.subclass_filter -like "*Fury*" -or $_.fury_unlock -ne "") 
}
$ProtAbilities = $SpellTargets | Where-Object { 
    $_.subclass_filter -ne "All" -and 
    ($_.subclass_filter -like "*Protection*" -or $_.protection_unlock -ne "") 
}

Write-Host "`nCategorization (mutually exclusive):" -ForegroundColor Yellow
Write-Host "  Shared/Baseline: $($SharedAbilities.Count)" -ForegroundColor Cyan
Write-Host "  Arms-only: $($ArmsAbilities.Count)" -ForegroundColor Cyan
Write-Host "  Fury-only: $($FuryAbilities.Count)" -ForegroundColor Cyan
Write-Host "  Protection-only: $($ProtAbilities.Count)" -ForegroundColor Cyan
Write-Host "  TOTAL: $(($SharedAbilities.Count + $ArmsAbilities.Count + $FuryAbilities.Count + $ProtAbilities.Count))" -ForegroundColor Green

# ========================================
# BUILD OUTPUT
# ========================================
$Output = @"
// ========================================
// WARRIOR SPELL_TARGET DEFINITIONS
// Generated: $(Get-Date -Format 'MMMM dd, yyyy')
// Patch: 8 Compatible (4.8.0.10)
// Source: AbilityDatabase_Warrior_FullyEnriched.csv
// ========================================
// Total Spell_Target: $($SpellTargets.Count)
// ========================================

"@

# Output all abilities alphabetically (no categorization to avoid duplicates)
Write-Host "`nGenerating entries alphabetically..." -ForegroundColor Cyan
foreach ($ability in ($SpellTargets | Sort-Object ability_id)) {
    $Output += New-SpellTargetEntry -Ability $ability
}

# ========================================
# OUTPUT
# ========================================
$LineCount = ($Output -split "`n").Count
Write-Host "`nGenerated $LineCount lines of content" -ForegroundColor Green

if ($DryRun) {
    Write-Host "`n=== DRY RUN MODE ===" -ForegroundColor Yellow
    Write-Host "Output preview (first 50 lines):" -ForegroundColor Cyan
    ($Output -split "`n")[0..49] | ForEach-Object { Write-Host $_ }
    Write-Host "`n... (truncated) ..." -ForegroundColor Gray
    Write-Host "`nDry run complete. Use without -DryRun to write file." -ForegroundColor Yellow
} else {
    # Backup existing file
    if (Test-Path $OutputPath) {
        Write-Host "`nCreating backup: $BackupPath" -ForegroundColor Yellow
        Copy-Item -Path $OutputPath -Destination $BackupPath -Force
    }
    
    # Write output
    Write-Host "`nWriting to: $OutputPath" -ForegroundColor Cyan
    $Output | Out-File -FilePath $OutputPath -Encoding UTF8 -NoNewline
    
    # Verify
    $EntryCount = (Select-String -Path $OutputPath -Pattern '^new entry "Target_WAR_' -AllMatches).Matches.Count
    Write-Host "`nVerification: $EntryCount entries written (expected: $($SpellTargets.Count))" -ForegroundColor Green
    
    if ($EntryCount -eq $SpellTargets.Count) {
        Write-Host "SUCCESS: All Spell_Target abilities generated!" -ForegroundColor Green
    } else {
        Write-Host "WARNING: Entry count mismatch!" -ForegroundColor Red
    }
}
