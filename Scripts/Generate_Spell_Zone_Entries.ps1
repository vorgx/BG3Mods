param(
    [switch]$DryRun
)

# ========================================
# CONFIGURATION
# ========================================
$DbPath = "C:\Users\tenod\source\repos\BG3Mods\Documentation\00_SourcesOfTruth\AbilityDatabase_Warrior_FullyEnriched.csv"
$OutputPath = "C:\Users\tenod\source\repos\BG3Mods\Data\Public\Warrior_Wow_78fe4967-4e62-5491-d981-dd781acca4d7\Stats\Generated\Data\Spell_Zone.txt"
$BackupPath = "C:\Users\tenod\source\repos\BG3Mods\Data\Public\Warrior_Wow_78fe4967-4e62-5491-d981-dd781acca4d7\Stats\Generated\Data\Spell_Zone_BACKUP_$(Get-Date -Format 'yyyyMMdd_HHmmss').txt"

# ========================================
# LOAD DATABASE
# ========================================
Write-Host "Loading database from: $DbPath" -ForegroundColor Cyan
$Db = Import-Csv -Path $DbPath

$SpellZones = $Db | Where-Object { $_.bg3_file_type -eq "Spell_Zone" }
Write-Host "Found $($SpellZones.Count) Spell_Zone abilities" -ForegroundColor Green

# ========================================
# GENERATE SPELL ENTRIES
# ========================================

function New-SpellZoneEntry {
    param($Ability)
    
    $entry = @"

// $($Ability.ability_name)
// Implementation: $($Ability.implementation_notes)
new entry "Zone_$($Ability.ability_id)"
type "SpellData"
data "SpellType" "Zone"
data "Level" "0"
data "SpellSchool" "Evocation"
data "AIFlags" "CanNotUse"
data "UseCosts" "ActionPoint:1;Rage:$($Ability.rage_cost)"
data "SpellProperties" ""
data "TargetConditions" "Character() and not Dead()"
data "AreaRadius" "3"  // TODO: Adjust radius based on ability
data "Icon" "Action_Whirlwind"  // TODO: Create custom icon
data "DisplayName" "h123abc01;1"  // TODO: Generate proper localization handle
data "Description" "h123abc02;1"  // TODO: Generate proper localization handle
data "TooltipDamageList" "DealDamage(1d6,Physical)"  // TODO: Use correct damage formula
data "TooltipAttackSave" "MeleeWeaponAttack"
data "PrepareEffect" "VFX_Barbarian_Rage_Prepare:Dummy_BodyFX;VFX_Weapons_Fire_Glow_01:Dummy_MainHandFX"  // TODO: Replace with Warrior VFX
data "CastEffect" "RS3_Impact_Blood_Celestial_01:TargetPosition:attach"  // TODO: Replace with Warrior VFX
data "TargetEffect" "RS3_Explosion_Blood_01"  // TODO: Replace with Warrior VFX
data "PositionEffect" "RS3_Explosion_Blood_01:TargetPosition"  // TODO: Replace with Warrior VFX
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
# BUILD OUTPUT (alphabetically, no duplicates)
# ========================================
$Output = @"
// ========================================
// WARRIOR SPELL_ZONE DEFINITIONS
// Generated: $(Get-Date -Format 'MMMM dd, yyyy')
// Patch: 8 Compatible (4.8.0.10)
// Source: AbilityDatabase_Warrior_FullyEnriched.csv
// ========================================
// Total Spell_Zone: $($SpellZones.Count)
// Note: AoE ground-targeted abilities
// ========================================

"@

# Output all abilities alphabetically
Write-Host "`nGenerating entries alphabetically..." -ForegroundColor Cyan
foreach ($ability in ($SpellZones | Sort-Object ability_id)) {
    $Output += New-SpellZoneEntry -Ability $ability
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
    $EntryCount = (Select-String -Path $OutputPath -Pattern '^new entry "Zone_WAR_' -AllMatches).Matches.Count
    Write-Host "`nVerification: $EntryCount entries written (expected: $($SpellZones.Count))" -ForegroundColor Green
    
    if ($EntryCount -eq $SpellZones.Count) {
        Write-Host "SUCCESS: All Spell_Zone abilities generated!" -ForegroundColor Green
    } else {
        Write-Host "WARNING: Entry count mismatch!" -ForegroundColor Red
    }
}
