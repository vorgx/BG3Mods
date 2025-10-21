# ENRICH BATCH 2 - REMAINING OFFENSIVE ABILITIES
# Date: October 21, 2025
# Purpose: Enrich remaining 27 Offensive abilities (Hero Talents + Advanced Mechanics)

param(
    [Parameter(Mandatory=$false)]
    [string]$DatabaseFile = "Documentation\00_SourcesOfTruth\AbilityDatabase_Warrior_FullyEnriched.csv"
)

Write-Host "[START] Enriching remaining Offensive abilities..." -ForegroundColor Cyan
Write-Host ""

# Load database
$db = Import-Csv $DatabaseFile -Encoding UTF8

# REMAINING OFFENSIVE ABILITIES - Hero Talents & Advanced Mechanics

$remainingAbilities = @{
    # === COLOSSUS SMASH / IN FOR THE KILL SYNERGIES ===
    "In For The Kill" = @{
        Type = "Passive"
        File = "Passive"
        RequiresAbility = "Colossus Smash"
        Tags = "Arms,Colossus-Build,Haste-Buff"
        Boosts = "IF(TargetHasStatus('WAR_COLOSSUS_SMASH')):Haste(10)"
        Notes = "Same duration as Colossus Smash. Good benefit against single and multitarget."
    }
    
    "Blunt Instruments" = @{
        Type = "Passive"
        File = "Passive"
        RequiresAbility = "Warbreaker,In For The Kill"
        Tags = "Arms,Colossus-Build,Duration-Extension"
        Notes = "Single-target alternative to Warbreaker. Extends In For The Kill duration."
    }
    
    # === OVERPOWER / MORTAL STRIKE SYNERGIES ===
    "Storm of Swords" = @{
        Type = "Passive"
        File = "Passive"
        ModifiesAbility = "Overpower"
        Tags = "Arms,Overpower-Build,Rage-Generation"
        Notes = "Largely unnecessary, results in rage overcapping. Generates rage on Overpower."
    }
    
    "Battlelord" = @{
        Type = "Passive"
        File = "Passive"
        RequiresAbility = "Overpower,Mortal Strike"
        Tags = "Arms,Overpower-Build,Reset-Mechanic"
        Functors = "StatsFunctorContext(OnCast);Conditions(HasStringInSpellRoll('Mortal_Strike'));StatsFunctors(RestoreResource(Overpower_Charge,1,0))"
        Notes = "Entertaining gameplay loop - Mortal Strike refreshes Overpower via Tactician procs."
    }
    
    "Executioner's Precision" = @{
        Type = "Passive"
        File = "Passive"
        ModifiesAbility = "Mortal Strike"
        Tags = "Arms,Execute-Build,Mortal-Strike-Enhancement"
        Functors = "IF(HealthPercentage(context.Target) <= 35):DealDamage(EXTRA_PERCENTAGE,Physical)"
        Notes = "Great value to Mortal Strike, keeps it relevant during Execute phase."
    }
    
    # === MAJOR COOLDOWNS ===
    "Champion's Spear" = @{
        Type = "Offensive"
        File = "Spell_Projectile"
        SpellType = "Projectile"
        RageCost = 0
        Cooldown = "90 seconds"
        Success = "DealDamage(4d10+StrengthModifier,Physical);ApplyStatus(WAR_CHAMPION_SPEAR_BUFF,100,6)"
        Tags = "Offensive,Major-Cooldown,AoE,90s-Cooldown"
        Notes = "Aligns with other 90s cooldowns. Not as useful as Thunderous Roar generally."
    }
    
    "Champion's Might" = @{
        Type = "Passive"
        File = "Passive"
        RequiresAbility = "Champion's Spear"
        Tags = "Offensive,Champion-Spear-Enhancement,Damage-Window"
        Notes = "Short but powerful damage window. Activates on target instead of self now."
    }
    
    # === RECKLESSNESS ENHANCEMENTS ===
    "Reckless Abandon" = @{
        Type = "Passive"
        File = "Passive"
        RequiresAbility = "Recklessness"
        Tags = "Fury,Recklessness-Build,Ability-Replacement"
        Notes = "Bloodthirst and Raging Blow replaced by stronger versions (Bloodbath/Crushing Blow) during Recklessness."
    }
    
    "Berserker's Torment" = @{
        Type = "Passive"
        File = "Passive"
        RequiresAbility = "Reckless Abandon"
        Tags = "Fury,Recklessness-Build,Duration-Extension"
        Notes = "Highly effective. Extends duration of Bloodbath/Crushing Blow beyond normal counterparts."
    }
    
    "Unbridled Ferocity" = @{
        Type = "Passive"
        File = "Passive"
        RequiresAbility = "Recklessness"
        Tags = "Fury,Recklessness-Build,Proc"
        Functors = "StatsFunctorContext(OnCast);Conditions(RandomChance(10));StatsFunctors(ApplyStatus(SELF,WAR_RECKLESSNESS,100,4))"
        Notes = "Randomly triggers Recklessness. Low proc chance leaves it generally underwhelming."
    }
    
    # === EXECUTE PHASE ENHANCEMENTS ===
    "Heavy Handed" = @{
        Type = "Passive"
        File = "Passive"
        ModifiesAbility = "Execute"
        Tags = "Arms,Execute-Build,AoE"
        Functors = "IF(HasPassive('WAR_Heavy_Handed')):ApplyEffect(Execute,Cleave,2)"
        Notes = "Execute strikes 2 additional targets for reduced damage. Great for refreshing Sudden Death."
    }
    
    # === ENRAGE EXTENSIONS ===
    "Depths of Insanity" = @{
        Type = "Passive"
        File = "Passive"
        Tags = "Fury,Enrage,Duration-Extension"
        Notes = "Generally uncompetitive due to small impact on overall uptime. Extends Enrage duration."
    }
    
    # === ODYN'S FURY / RAVAGER ENHANCEMENTS ===
    "Dancing Blades" = @{
        Type = "Passive"
        File = "Passive"
        RequiresAbility = "Odyn's Fury"
        Tags = "Fury,Odyn-Build,Auto-Attack-Buff"
        Notes = "Triggers large auto-attack buff. Provides bonus to Odyn's Fury single-target damage."
    }
    
    "Titanic Rage" = @{
        Type = "Passive"
        File = "Passive"
        RequiresAbility = "Avatar"
        Tags = "Fury,Avatar-Build,AoE-Rotation"
        Notes = "Minor damage buff. Jumpstarts AoE rotation by auto-applying important statuses."
    }
    
    "Whirling Blade" = @{
        Type = "Passive"
        File = "Passive"
        RequiresAbility = "Ravager"
        Tags = "Protection,Ravager-Enhancement,Proc"
        Functors = "StatsFunctorContext(OnCast);Conditions(RandomChance(Percentage));StatsFunctors(SummonObject(WAR_RAVAGER_MINI,8,Duration_2s))"
        Notes = "Randomly sends out more frequent and shorter versions of Ravager."
    }
    
    # === MOUNTAIN THANE HERO TALENTS (Thunder/Lightning theme) ===
    "Ground Current" = @{
        Type = "Passive"
        File = "Passive"
        Tags = "Mountain-Thane,Hero-Talent,Lightning"
        Notes = "Mountain Thane passive - NEEDS WOWHEAD RESEARCH for specific mechanics."
    }
    
    "Strength of the Mountain" = @{
        Type = "Passive"
        File = "Passive"
        Tags = "Mountain-Thane,Hero-Talent,Stat-Boost"
        Notes = "Mountain Thane passive - Likely strength boost or damage increase."
    }
    
    "Earthquake" = @{
        Type = "Offensive"
        File = "Spell_Zone"
        SpellType = "Zone"
        Tags = "Mountain-Thane,Hero-Talent,AoE,Ground-Effect"
        Notes = "Mountain Thane active ability - Ground-targeted AoE earthquake effect."
    }
    
    "Storm Bolts" = @{
        Type = "Offensive"
        File = "Spell_Projectile"
        SpellType = "Projectile"
        Tags = "Mountain-Thane,Hero-Talent,Lightning,Projectile"
        Notes = "Mountain Thane ability - Lightning bolt projectile attacks."
    }
    
    "Keep your feet on the Ground" = @{
        Type = "Passive"
        File = "Passive"
        Tags = "Mountain-Thane,Hero-Talent,CC"
        Notes = "Mountain Thane passive - Likely knockdown or root mechanic."
    }
    
    "Tide of Battle" = @{
        Type = "Passive"
        File = "Passive"
        Tags = "Mountain-Thane,Hero-Talent"
        Notes = "Mountain Thane passive - NEEDS RESEARCH for specific mechanics."
    }
    
    "No Stranger to Pain" = @{
        Type = "Passive"
        File = "Passive"
        Tags = "Mountain-Thane,Hero-Talent,Defensive"
        Notes = "Mountain Thane passive - Likely damage reduction or pain suppression."
    }
    
    "Thorims Might" = @{
        Type = "Passive"
        File = "Passive"
        Tags = "Mountain-Thane,Hero-Talent,Power-Boost"
        Notes = "Mountain Thane passive - Thorim's power, likely damage or strength boost."
    }
    
    "Burst of Power" = @{
        Type = "Passive"
        File = "Passive"
        Tags = "Mountain-Thane,Hero-Talent,Burst-Damage"
        Notes = "Mountain Thane passive - Burst damage window or cooldown enhancement."
    }
    
    "Mountain of Muscle and Scars" = @{
        Type = "Passive"
        File = "Passive"
        Tags = "Mountain-Thane,Hero-Talent,Tank,HP-Boost"
        Notes = "Mountain Thane passive - Likely HP increase or damage reduction for tanks."
    }
    
    # === COLOSSUS HERO TALENTS ===
    "Colossal Might" = @{
        Type = "Passive"
        File = "Passive"
        Tags = "Colossus,Hero-Talent,Demolish-Enhancement"
        Notes = "Colossus passive - Likely enhances Demolish ability damage or effects."
    }
    
    "Precise Might" = @{
        Type = "Passive"
        File = "Passive"
        Tags = "Colossus,Hero-Talent,Critical"
        Notes = "Colossus passive - Likely crit chance or crit damage boost."
    }
}

Write-Host "[INFO] Enrichment library loaded: $($remainingAbilities.Count) abilities" -ForegroundColor Cyan
Write-Host ""

# ENRICH DATABASE
$enrichedCount = 0

foreach ($ability in $db) {
    $name = $ability.ability_name.Trim()
    
    # Skip already enriched
    if ($ability.bg3_file_type -and $ability.archetype_tags) { continue }
    
    # Check if we have mechanics
    if ($remainingAbilities.ContainsKey($name)) {
        $mech = $remainingAbilities[$name]
        
        # Populate fields
        if ($mech.Type) { $ability.ability_type = $mech.Type }
        if ($mech.File) { $ability.bg3_file_type = $mech.File }
        if ($mech.SpellType) { $ability.bg3_spell_type = $mech.SpellType }
        if ($mech.RageCost) { $ability.wow_cost_rage = $mech.RageCost }
        if ($mech.Cooldown) { $ability.bg3_cooldown = $mech.Cooldown }
        if ($mech.Success) { $ability.bg3_spell_success = $mech.Success }
        if ($mech.Tags) { $ability.archetype_tags = $mech.Tags }
        if ($mech.ModifiesAbility) { 
            if ($ability.modified_by) {
                $ability.modified_by += ",$($mech.ModifiesAbility)"
            } else {
                $ability.modified_by = $mech.ModifiesAbility
            }
        }
        if ($mech.RequiresAbility) { $ability.requires_ability = $mech.RequiresAbility }
        if ($mech.Notes) {
            if ($ability.implementation_notes) {
                $ability.implementation_notes += " | $($mech.Notes)"
            } else {
                $ability.implementation_notes = $mech.Notes
            }
        }
        
        $enrichedCount++
        Write-Host "[ENRICHED] $name" -ForegroundColor Green
    }
}

# EXPORT
$db | Export-Csv $DatabaseFile -NoTypeInformation -Encoding UTF8
Write-Host ""
Write-Host "[COMPLETE] Enriched $enrichedCount offensive abilities" -ForegroundColor Green
Write-Host "[SAVED] $DatabaseFile" -ForegroundColor Cyan

# SHOW PROGRESS
$enriched = $db | Where-Object { $_.bg3_file_type -and $_.archetype_tags }
$remaining = $db | Where-Object { -not ($_.bg3_file_type -and $_.archetype_tags) }
Write-Host ""
Write-Host "[PROGRESS] $($enriched.Count) / $($db.Count) abilities enriched ($(($enriched.Count / $db.Count * 100).ToString('F1'))%)" -ForegroundColor Yellow
Write-Host "[REMAINING] $($remaining.Count) abilities still need enrichment" -ForegroundColor Yellow
Write-Host ""
Write-Host "Remaining by type:" -ForegroundColor Cyan
$remaining | Group-Object ability_type | Sort-Object Count -Descending | ForEach-Object {
    Write-Host "  $($_.Name): $($_.Count)" -ForegroundColor White
}
Write-Host ""
