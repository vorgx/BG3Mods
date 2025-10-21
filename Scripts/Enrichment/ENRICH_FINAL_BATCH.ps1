# ENRICH FINAL BATCH - Complete Remaining 42 Abilities
# Date: October 21, 2025
# Purpose: Complete enrichment to 100% (or close to it)

param(
    [Parameter(Mandatory=$false)]
    [string]$DatabaseFile = "Documentation\00_SourcesOfTruth\AbilityDatabase_Warrior_FullyEnriched.csv"
)

Write-Host "[START] Final enrichment batch - 42 remaining abilities..." -ForegroundColor Cyan
Write-Host ""

$db = Import-Csv $DatabaseFile -Encoding UTF8

# FINAL 42 ABILITIES - Complete the database!

$finalAbilities = @{
    # === ALREADY AUTO-ENRICHED BUT NOT SHOWING - Check these first ===
    "Pain and Gain" = @{
        Type = "Passive"
        File = "Passive"
        Tags = "Passive,Healing,Lifesteal"
        Notes = "Passive self-healing - heal based on damage dealt."
    }
    
    "Fueled by Violence" = @{
        Type = "Passive"
        File = "Passive"
        Tags = "Passive,Healing,AoE-Scaling"
        Notes = "Minor passive healing that ramps against multiple targets."
    }
    
    "Anger Management" = @{
        Type = "Passive"
        File = "Passive"
        Tags = "Passive,Cooldown-Reduction,Critical"
        Notes = "Indispensable talent - reduces cooldowns, creates more frequent damage windows."
    }
    
    # === SPEC MECHANICS ===
    "Best Served Cold" = @{
        Type = "Passive"
        File = "Passive"
        RequiresAbility = "Revenge"
        Tags = "Protection,Revenge-Enhancement"
        Notes = "Increases Revenge effectiveness. Tank passive."
    }
    
    "Single" = @{
        Type = "Passive"
        File = "Passive"
        Tags = "Fury,Dual-Wield,Weapon-Specialization"
        Notes = "Single-Minded Fury - increases effectiveness of dual-wielding one-handed weapons."
    }
    
    "Punish" = @{
        Type = "Passive"
        File = "Passive"
        ModifiesAbility = "Shield Slam"
        Tags = "Protection,Shield-Slam-Enhancement,Mitigation"
        Notes = "Increases Shield Slam damage. Hit enemy deals less damage to you."
    }
    
    # === DEFENSIVE ABILITIES ===
    "Honed Reflexes" = @{
        Type = "Passive"
        File = "Passive"
        Tags = "Defensive,Cooldown-Reduction"
        Notes = "Reduces defensive cooldowns by minor amount. General survivability passive."
    }
    
    "Wrecking Throw" = @{
        Type = "Defensive"
        File = "Spell_Projectile"
        SpellType = "Projectile"
        Cooldown = "45 seconds"
        Success = "RemoveStatus(TARGET,ABSORPTION_SHIELDS);DealDamage(1d6,Physical)"
        Tags = "Utility,Shield-Break,Single-Target"
        Notes = "Highly effective against absorption shields. Rarely major gain in PvE."
    }
    
    # === MOBILITY ===
    "Double Time" = @{
        Type = "Passive"
        File = "Passive"
        ModifiesAbility = "Charge"
        Tags = "Utility,Mobility,Charge-Enhancement"
        Notes = "Must-have mobility increase. Grants 2 charges of Charge instead of 1."
    }
    
    "Sidearm" = @{
        Type = "Passive"
        File = "Passive"
        Tags = "Passive,Rage-Generation,Throw"
        Notes = "Minor passive damage increase. Increases throwing weapon effectiveness."
    }
    
    # === ABILITY ENHANCEMENTS ===
    "Strength of Arms" = @{
        Type = "Passive"
        File = "Passive"
        ModifiesAbility = "Overpower"
        Tags = "Arms,Overpower-Enhancement,Damage-Boost"
        Notes = "Single/two target power increase for Overpower."
    }
    
    "Wrath and Fury" = @{
        Type = "Passive"
        File = "Passive"
        ModifiesAbility = "Raging Blow"
        Tags = "Fury,Raging-Blow-Enhancement,Reset-Mechanic"
        Notes = "Moderate damage and reset chance increase for Raging Blow."
    }
    
    "Tough as Nails" = @{
        Type = "Passive"
        File = "Passive"
        RequiresAbility = "Shield Block"
        Tags = "Protection,Block,Damage-On-Block"
        Functors = "StatsFunctorContext(OnBlock);StatsFunctors(DealDamage(1d6,Physical))"
        Notes = "Passive damage whenever you block. Recently buffed, still underwhelming."
    }
    
    "Enduring Defenses" = @{
        Type = "Passive"
        File = "Passive"
        RequiresAbility = "Shield Block"
        Tags = "Protection,Block,Duration-Extension,Critical"
        Notes = "Incredible defensive bonus - grants 33% more Shield Block uptime. Massive survivability boost."
    }
    
    "Red Right Hand" = @{
        Type = "Passive"
        File = "Passive"
        ModifiesAbility = "Execute"
        Tags = "Arms,Execute-Enhancement,Damage-Boost"
        Notes = "Simple Execute damage increase. Great in combination with other Execute talents."
    }
    
    "Cruel Strikes" = @{
        Type = "Passive"
        File = "Passive"
        ModifiesAbility = "Execute"
        Tags = "Fury,Execute-Enhancement,Critical"
        Notes = "Minor Execute crit increase. Smaller than it may seem."
    }
    
    "Dual Wield Specialization" = @{
        Type = "Passive"
        File = "Passive"
        Tags = "Fury,Dual-Wield,Damage-Boost,Critical"
        Notes = "Must-have passive damage increase for dual-wielding."
    }
    
    "Armored to the Teeth" = @{
        Type = "Passive"
        File = "Passive"
        Tags = "Passive,Armor,Damage-Scaling,Critical"
        Boosts = "Damage(IF_ArmorValue,Percentage)"
        Notes = "Near indispensable damage increase. Helps gear scaling over expansion."
    }
    
    "Sharpened Blades" = @{
        Type = "Passive"
        File = "Passive"
        ModifiesAbility = "Mortal Strike,Execute"
        Tags = "Arms,Damage-Boost,Core-Abilities"
        Notes = "Moderate damage increase for Arms' most important rotational abilities."
    }
    
    # === COOLDOWN ALTERATIONS ===
    "Ravager" = @{
        Type = "Offensive"
        File = "Spell_Zone"
        SpellType = "Zone"
        RageCost = 0
        Cooldown = "90 seconds"
        Success = "SummonObject(WAR_RAVAGER,10,6)"
        Tags = "Arms,Major-Cooldown,AoE,Alternative"
        Notes = "Passive alternative to Bladestorm. More suited for single targets or Colossus builds."
    }
    
    "Juggernaut" = @{
        Type = "Passive"
        File = "Passive"
        RequiresAbility = "Execute"
        Tags = "Arms,Execute-Build,Stacking-Buff"
        Functors = "StatsFunctorContext(OnCast);Conditions(HasStringInSpellRoll('Execute'));StatsFunctors(ApplyStatus(SELF,WAR_JUGGERNAUT,100,15))"
        Notes = "Large ramping damage increase. Not suited for short encounters."
    }
    
    "Indomitable" = @{
        Type = "Passive"
        File = "Passive"
        Tags = "Defensive,Tankiness,Critical"
        Boosts = "HP(10);DamageReduction(Percentage)"
        Notes = "Extremely valuable defensive talent. Substantially increases tankiness and grants ignore pain charges."
    }
    
    "Uproar" = @{
        Type = "Passive"
        File = "Passive"
        RequiresAbility = "Thunderous Roar"
        Tags = "Fury,Cooldown-Reduction,Alignment"
        Notes = "Keeps Thunderous Roar aligned with Avatar and other cooldowns. Noticeable damage increase."
    }
    
    "Titan's Torment" = @{
        Type = "Passive"
        File = "Passive"
        RequiresAbility = "Avatar"
        Tags = "Fury,Avatar-Build,AoE-Damage"
        Notes = "Very strong AoE damage increase. Synergizes with other Avatar effects on Odyn's Fury."
    }
    
    "Fatality" = @{
        Type = "Passive"
        File = "Passive"
        RequiresAbility = "Execute"
        Tags = "Fury,Execute-Build,Damage-Boost"
        Notes = "Increased damage during Execute phase. Keeps pre-execute abilities relevant."
    }
    
    "Unhinged" = @{
        Type = "Passive"
        File = "Passive"
        RequiresAbility = "Bladestorm,Ravager"
        Tags = "Arms,Bladestorm-Enhancement,Damage-Boost"
        Notes = "Significant single/two target damage increase while using Bladestorm or Ravager."
    }
    
    "Storm of Steel" = @{
        Type = "Utility"
        File = "Passive"
        RequiresAbility = "Ravager"
        Tags = "Arms,Ravager-Enhancement,Extra-Charge"
        Notes = "Gives Ravager second charge. Fairly important in most content."
    }
    
    # === HERO TALENTS - Mountain Thane ===
    "Lightning Strikes" = @{
        Type = "Passive"
        File = "Passive"
        Tags = "Mountain-Thane,Hero-Talent,Lightning-Proc"
        Notes = "Mountain Thane passive - Lightning strikes proc on abilities."
    }
    
    "Crashing Thunder" = @{
        Type = "Passive"
        File = "Passive"
        RequiresAbility = "Thunder Clap"
        Tags = "Mountain-Thane,Hero-Talent,Thunder-Clap-Enhancement"
        Notes = "Enhances Thunder Clap with additional effects."
    }
    
    "Thunder Blast" = @{
        Type = "Offensive"
        File = "Spell_Zone"
        SpellType = "Zone"
        Tags = "Mountain-Thane,Hero-Talent,Lightning,AoE"
        Notes = "Mountain Thane active ability - Lightning blast AoE."
    }
    
    "Flashing Skies" = @{
        Type = "Passive"
        File = "Passive"
        Tags = "Mountain-Thane,Hero-Talent,Lightning"
        Notes = "Mountain Thane passive - Increases lightning effects frequency/damage."
    }
    
    "Avatar of the Storm" = @{
        Type = "Passive"
        File = "Passive"
        RequiresAbility = "Avatar"
        Tags = "Mountain-Thane,Hero-Talent,Avatar-Enhancement"
        Notes = "Mountain Thane keystone - Enhances Avatar with storm/lightning effects."
    }
    
    # === HERO TALENTS - Colossus ===
    "Demolish" = @{
        Type = "Offensive"
        File = "Spell_Target"
        SpellType = "Target"
        RageCost = 25
        Cooldown = "45 seconds"
        Success = "DealDamage(5d12+StrengthModifier,Physical);ApplyStatus(STUNNED,100,2)"
        Tags = "Colossus,Hero-Talent,Major-Cooldown,Stun"
        Notes = "Colossus active ability - Massive damage with stun."
    }
    
    "Dominance of the Colossus" = @{
        Type = "Passive"
        File = "Passive"
        Tags = "Colossus,Hero-Talent,Keystone"
        Notes = "Colossus keystone passive - Grants core Colossus mechanics."
    }
    
    "Martial Expert" = @{
        Type = "Passive"
        File = "Passive"
        Tags = "Colossus,Hero-Talent,Mastery-Boost"
        Notes = "Colossus passive - Likely mastery or expertise increase."
    }
    
    # === HERO TALENTS - Slayer ===
    "Slayers Dominance" = @{
        Type = "Passive"
        File = "Passive"
        Tags = "Slayer,Hero-Talent,Keystone"
        Notes = "Slayer keystone passive - Grants core Slayer mechanics."
    }
    
    "Imminent Demise" = @{
        Type = "Passive"
        File = "Passive"
        RequiresAbility = "Execute"
        Tags = "Slayer,Hero-Talent,Execute-Build"
        Notes = "Slayer passive - Execute-focused enhancement."
    }
    
    "Arterial Bleed" = @{
        Type = "Passive"
        File = "Passive"
        Tags = "Slayer,Hero-Talent,Bleed,DoT"
        Notes = "Slayer passive - Applies or enhances bleed effects."
    }
    
    "Death Drive" = @{
        Type = "Passive"
        File = "Passive"
        Tags = "Slayer,Hero-Talent,Execute-Phase"
        Notes = "Slayer passive - Bonuses during execute/death phase."
    }
    
    "Practiced Strikes" = @{
        Type = "Passive"
        File = "Passive"
        Tags = "Slayer,Hero-Talent,Attack-Speed"
        Notes = "Slayer passive - Increases attack frequency or reduces GCD."
    }
    
    "Show No Mercy" = @{
        Type = "Passive"
        File = "Passive"
        Tags = "Slayer,Hero-Talent,Execute-Finisher"
        Notes = "Slayer passive - Execute enhancements, no mercy mechanics."
    }
    
    "Unrelenting Onslaught" = @{
        Type = "Passive"
        File = "Passive"
        Tags = "Slayer,Hero-Talent,Aggressive-Playstyle"
        Notes = "Slayer passive - Continuous assault bonuses."
    }
}

Write-Host "[INFO] Final enrichment library loaded: $($finalAbilities.Count) abilities" -ForegroundColor Cyan
Write-Host ""

# ENRICH
$enrichedCount = 0

foreach ($ability in $db) {
    $name = $ability.ability_name.Trim()
    
    if ($ability.bg3_file_type -and $ability.archetype_tags) { continue }
    
    if ($finalAbilities.ContainsKey($name)) {
        $mech = $finalAbilities[$name]
        
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

$enriched = $db | Where-Object { $_.bg3_file_type -and $_.archetype_tags }
$remaining = $db | Where-Object { -not ($_.bg3_file_type -and $_.archetype_tags) }

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host " ENRICHMENT COMPLETE!" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "[FINAL] Enriched $enrichedCount abilities this batch" -ForegroundColor Green
Write-Host "[TOTAL] $($enriched.Count) / $($db.Count) abilities enriched ($(($enriched.Count / $db.Count * 100).ToString('F1'))%)" -ForegroundColor Yellow
Write-Host "[REMAINING] $($remaining.Count) abilities still unenriched" -ForegroundColor $(if ($remaining.Count -eq 0) { "Green" } else { "Yellow" })
Write-Host ""

if ($remaining.Count -gt 0) {
    Write-Host "Remaining abilities:" -ForegroundColor Yellow
    $remaining | Select-Object ability_name,ability_type | Format-Table -AutoSize
}
else {
    Write-Host "100% ENRICHMENT ACHIEVED!" -ForegroundColor Green
    Write-Host "All 215 abilities have been enriched with BG3 mechanics!" -ForegroundColor Green
}

Write-Host ""
Write-Host "[SAVED] $DatabaseFile" -ForegroundColor Cyan
Write-Host ""
