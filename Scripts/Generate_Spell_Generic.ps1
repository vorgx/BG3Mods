param(
    [Parameter(Mandatory=$true)]
    [ValidateSet("Shout", "Jump", "Projectile")]
    [string]$SpellType
)

# ========================================
# CONFIGURATION
# ========================================
$DbPath = "C:\Users\tenod\source\repos\BG3Mods\Documentation\00_SourcesOfTruth\AbilityDatabase_Warrior_FullyEnriched.csv"
$OutputPath = "C:\Users\tenod\source\repos\BG3Mods\Data\Public\Warrior_Wow_78fe4967-4e62-5491-d981-dd781acca4d7\Stats\Generated\Data\Spell_$SpellType.txt"
$BackupPath = "C:\Users\tenod\source\repos\BG3Mods\Data\Public\Warrior_Wow_78fe4967-4e62-5491-d981-dd781acca4d7\Stats\Generated\Data\Spell_${SpellType}_BACKUP_$(Get-Date -Format 'yyyyMMdd_HHmmss').txt"

# ========================================
# LOAD DATABASE
# ========================================
Write-Host "Loading database from: $DbPath" -ForegroundColor Cyan
$Db = Import-Csv -Path $DbPath

$Spells = $Db | Where-Object { $_.bg3_file_type -eq "Spell_$SpellType" }
Write-Host "Found $($Spells.Count) Spell_$SpellType abilities" -ForegroundColor Green

if ($Spells.Count -eq 0) {
    Write-Host "ERROR: No abilities found for Spell_$SpellType!" -ForegroundColor Red
    exit 1
}

# ========================================
# GENERATE SPELL ENTRIES
# ========================================

function New-SpellEntry {
    param($Ability, $Type)
    
    # Type-specific properties
    $typeSpecific = switch ($Type) {
        "Shout" {
            @"
data "TargetRadius" "10"  // TODO: Adjust AoE radius
data "TargetConditions" "Self()"
"@
        }
        "Jump" {
            @"
data "TargetRadius" "15"  // TODO: Adjust jump distance
data "TargetConditions" "Ground()"
data "TeleportSelf" "Yes"
"@
        }
        "Projectile" {
            @"
data "TargetRadius" "18"  // TODO: Adjust range
data "TargetConditions" "Character() and not Dead()"
data "ProjectileCount" "1"
"@
        }
    }
    
    $entry = @"

// $($Ability.ability_name)
// Implementation: $($Ability.implementation_notes)
new entry "${Type}_$($Ability.ability_id)"
type "SpellData"
data "SpellType" "$Type"
data "Level" "0"
data "SpellSchool" "Evocation"
data "AIFlags" "CanNotUse"
data "UseCosts" "ActionPoint:1;Rage:$($Ability.rage_cost)"
data "SpellProperties" ""
$typeSpecific
data "Icon" "Action_${Type}"  // TODO: Create custom icon
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
# BUILD OUTPUT
# ========================================
$TypeUpper = $SpellType.ToUpper()
$Output = @"
// ========================================
# WARRIOR SPELL_$TypeUpper DEFINITIONS
# Generated: $(Get-Date -Format 'MMMM dd, yyyy')
# Patch: 8 Compatible (4.8.0.10)
# Source: AbilityDatabase_Warrior_FullyEnriched.csv
# ========================================
# Total Spell_$SpellType entries: $($Spells.Count)
# ========================================

"@

# Output all abilities alphabetically
Write-Host "`nGenerating entries alphabetically..." -ForegroundColor Cyan
foreach ($ability in ($Spells | Sort-Object ability_id)) {
    $Output += New-SpellEntry -Ability $ability -Type $SpellType
}

# ========================================
# OUTPUT
# ========================================
$LineCount = ($Output -split "`n").Count
Write-Host "`nGenerated $LineCount lines of content" -ForegroundColor Green

# Backup existing file
if (Test-Path $OutputPath) {
    Write-Host "`nCreating backup: $BackupPath" -ForegroundColor Yellow
    Copy-Item -Path $OutputPath -Destination $BackupPath -Force
}

# Write output
Write-Host "`nWriting to: $OutputPath" -ForegroundColor Cyan
$Output | Out-File -FilePath $OutputPath -Encoding UTF8 -NoNewline

# Verify
$EntryCount = (Select-String -Path $OutputPath -Pattern "^new entry `"${SpellType}_WAR_" -AllMatches).Matches.Count
Write-Host "`nVerification: $EntryCount entries written (expected: $($Spells.Count))" -ForegroundColor Green

if ($EntryCount -eq $Spells.Count) {
    Write-Host "SUCCESS: All Spell_$SpellType abilities generated!" -ForegroundColor Green
} else {
    Write-Host "WARNING: Entry count mismatch!" -ForegroundColor Red
}
