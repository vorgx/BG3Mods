# ENRICH BATCH - OFFENSIVE ABILITIES
# Date: October 21, 2025
# Purpose: Manual enrichment of 30 Offensive abilities based on descriptions

param(
    [Parameter(Mandatory=$false)]
    [string]$DatabaseFile = "Documentation\00_SourcesOfTruth\AbilityDatabase_Warrior_FullyEnriched.csv"
)

Write-Host "[START] Enriching Offensive abilities batch..." -ForegroundColor Cyan
Write-Host ""

# Load database
$db = Import-Csv $DatabaseFile -Encoding UTF8

# OFFENSIVE ABILITIES ENRICHMENT LIBRARY
# Based on descriptions from the database and WoW mechanics knowledge

$offensiveAbilities = @{
    # === ABILITY MODIFIERS & ENHANCEMENTS ===
    "Fervor of Battle" = @{
        Type = "Passive"
        File = "Passive"
        ModifiesAbility = "Slam,Whirlwind"
        Tags = "Arms,AoE-Enhancement,Cleave"
        Notes = "Allows Slam/Whirlwind to stack Collateral Damage. Enables single-target abilities to hit multiple targets."
    }
    
    "Invigorating Fury" = @{
        Type = "Passive"
        File = "Passive"
        Tags = "Fury,Healing,Enrage"
        Boosts = "IF(HasStatus('WAR_ENRAGED')):RegainHitPoints(Percentage)"
        Notes = "Heal when Enrage expires. PvP-focused talent, less useful in PvE."
    }
    
    "Improved Raging Blow" = @{
        Type = "Passive"
        File = "Passive"
        ModifiesAbility = "Raging Blow"
        Tags = "Fury,Raging-Blow-Enhancement,Reset-Mechanic"
        Functors = "StatsFunctorContext(OnCast);Conditions(HasStringInSpellRoll('Raging_Blow'));StatsFunctors(IF(RandomChance(20)):RestoreResource(RagingBlow_Charge,1,0))"
        Notes = "Critical talent - enables Raging Blow resets. 20% chance per cast."
    }
    
    "Improved Whirlwind" = @{
        Type = "Passive"
        File = "Passive"
        ModifiesAbility = "Whirlwind"
        Tags = "Fury,AoE,Cleave-Mechanic"
        Functors = "StatsFunctorContext(OnCast);Conditions(HasStringInSpellRoll('Whirlwind'));StatsFunctors(ApplyStatus(SELF,WAR_MEAT_CLEAVER,100,6))"
        Notes = "Enables Fury's cleave mechanics. Core Fury talent - single-target attacks hit additional targets after Whirlwind."
    }
    
    # === CROWD CONTROL & UTILITY ===
    "Disrupting Shout" = @{
        Type = "Offensive"
        File = "Spell_Shout"
        SpellType = "Shout"
        Cooldown = "90 seconds"
        Success = "ApplyStatus(NEARBY_ENEMIES,TAUNTED,100,6)"
        Tags = "Utility,AoE,Taunt,Cooldown-Reduction"
        Notes = "Converts Challenging Shout to AoE taunt with reduced cooldown (90s vs 240s)"
    }
    
    "Cacophonous Roar" = @{
        Type = "Offensive"
        File = "Spell_Shout"
        SpellType = "Shout"
        Cooldown = "OncePerShortRest"
        Success = "ApplyStatus(NEARBY_ENEMIES,INCAPACITATED,100,4)"
        Tags = "Utility,AoE,CC,Fear"
        Notes = "AoE incapacitate, easily broken. Moderately viable in PvP."
    }
    
    "Menace" = @{
        Type = "Offensive"
        File = "Spell_Target"
        SpellType = "Target"
        Cooldown = "OncePerShortRest"
        Success = "ApplyStatus(FRIGHTENED,100,6);Force(Knockback,6m)"
        Tags = "Utility,CC,Fear,Knockback"
        Notes = "Single-target fear with knockback. More useful than Cacophonous Roar due to knockback."
    }
    
    "Berserker Shout" = @{
        Type = "Offensive"
        File = "Spell_Shout"
        SpellType = "Shout"
        Cooldown = "60 seconds"
        Success = "RemoveStatus(SELF_AND_ALLIES,FRIGHTENED)"
        Tags = "Utility,AoE,CC-Break,Fear-Removal"
        Notes = "Group-wide fear breaker. Seldom used outside PvP."
    }
    
    "Piercing Howl" = @{
        Type = "Offensive"
        File = "Spell_Shout"
        SpellType = "Shout"
        Cooldown = "30 seconds"
        Success = "ApplyStatus(NEARBY_ENEMIES,SLOWED,100,6)"
        Tags = "Utility,AoE,CC,Snare"
        Notes = "Major AoE snare/slow. 30s cooldown. Good for kiting or controlling adds."
    }
    
    "Shattering Throw" = @{
        Type = "Offensive"
        File = "Spell_Projectile"
        SpellType = "Projectile"
        RageCost = 0
        Cooldown = "3 minutes"
        Success = "RemoveStatus(TARGET,IMMUNITY);DealDamage(1d8,Physical)"
        Tags = "Utility,Immunity-Break,Single-Target"
        Notes = "Immunity-breaking throw. Rarely used in PvE, more common in PvP."
    }
    
    # === PROC MECHANICS & RESETS ===
    "Strategist" = @{
        Type = "Passive"
        File = "Passive"
        Tags = "Arms,Proc,Overpower-Build,Critical"
        Functors = "StatsFunctorContext(OnCast);Conditions(RandomChance(30));StatsFunctors(RestoreResource(Overpower_Charge,1,0))"
        Notes = "Critical rotational talent - MANDATORY. 30% chance to reset Overpower charges."
    }
    
    "Hack and Slash" = @{
        Type = "Passive"
        File = "Passive"
        Tags = "Fury,Proc,Raging-Blow-Build"
        Functors = "StatsFunctorContext(OnAttack);Conditions(IsAutoAttack());StatsFunctors(IF(RandomChance(10)):RestoreResource(RagingBlow_Charge,1,0))"
        Notes = "Very important reset mechanic for Raging Blow builds. Auto-attacks have 10% chance to reset."
    }
    
    # === RAGE GENERATION ===
    "Instigate" = @{
        Type = "Passive"
        File = "Passive"
        Tags = "Protection,Rage-Generation,Auto-Attack"
        Functors = "StatsFunctorContext(OnAttack);Conditions(IsAutoAttack());StatsFunctors(RestoreResource(Rage,2,0))"
        Notes = "Increases auto-attack rage generation by 2. Performs very well for tanks."
    }
    
    "Overwhelming Rage" = @{
        Type = "Passive"
        File = "Passive"
        Tags = "Fury,Rage-Generation"
        Boosts = "RestoreResource(Rage,2,0)"
        Notes = "Increases maximum Rage by 15-20 and eases rage management burdens."
    }
    
    "Exhilarating Blows" = @{
        Type = "Passive"
        File = "Passive"
        ModifiesAbility = "Mortal Strike,Cleave"
        Tags = "Arms,Rage-Reduction,Cost-Reduction"
        Notes = "Reduces Mortal Strike and Cleave rage costs. Allows more frequent casts."
    }
    
    # === EXECUTE PHASE ENHANCEMENTS ===
    "Ashen Juggernaut" = @{
        Type = "Passive"
        File = "Passive"
        RequiresAbility = "Execute"
        Tags = "Execute-Build,Fury,Damage-Boost"
        Functors = "StatsFunctorContext(OnCast);Conditions(HasStringInSpellRoll('Execute'));StatsFunctors(ApplyStatus(SELF,WAR_ASHEN_JUGGERNAUT,100,6))"
        Notes = "Significant damage boost when using Execute regularly. Stacks up during execute phase."
    }
    
    "Vicious Contempt" = @{
        Type = "Passive"
        File = "Passive"
        ModifiesAbility = "Bloodthirst"
        Tags = "Fury,Execute-Build,Bloodthirst-Enhancement"
        Functors = "IF(HasPassive('WAR_Vicious_Contempt')):IF(HealthPercentage(context.Target) <= 35):DealDamage(EXTRA_PERCENTAGE,Physical)"
        Notes = "Greatly increases Bloodthirst damage during execute phase (<35% HP). Promotes Bloodthirst playstyles."
    }
    
    # === MULTITARGET / AoE ENHANCEMENTS ===
    "Barbaric Training" = @{
        Type = "Passive"
        File = "Passive"
        Tags = "Fury,AoE,Mountain-Thane"
        Notes = "Only useful for Mountain Thane in multitarget. Spec-specific passive."
    }
    
    "Collateral Damage" = @{
        Type = "Passive"
        File = "Passive"
        RequiresAbility = "Sweeping Strikes"
        Tags = "Arms,AoE,Cleave,Stacking-Buff"
        Functors = "StatsFunctorContext(OnCast);Conditions(HasStatus('WAR_SWEEPING_STRIKES'));StatsFunctors(ApplyStatus(SELF,WAR_COLLATERAL_DAMAGE,100,30))"
        Notes = "Gains stacks for each single-target attack cleaved by Sweeping Strikes. Increases next AoE damage."
    }
    
    "Dreadnaught" = @{
        Type = "Passive"
        File = "Passive"
        ModifiesAbility = "Overpower"
        Tags = "Arms,AoE,Overpower-Enhancement"
        Functors = "IF(HasPassive('WAR_Dreadnaught')):ApplyEffect(Overpower,MultiTarget,2)"
        Notes = "Multitarget option for Overpower. Allows hitting 2 targets instead of 1."
    }
    
    "Slaughtering Strikes" = @{
        Type = "Passive"
        File = "Passive"
        ModifiesAbility = "Rampage"
        Tags = "Fury,Damage-Boost,Rampage-Enhancement"
        Functors = "IF(HasPassive('WAR_Slaughtering_Strikes')):DealDamage(EXTRA_PERCENTAGE,Physical)"
        Notes = "Significant damage boost for Rampage. Greatly emphasizes Raging Blow usage."
    }
    
    "Seismic Reverberation" = @{
        Type = "Passive"
        File = "Passive"
        RequiresAbility = "Whirlwind"
        Tags = "Fury,AoE,Mountain-Thane,Whirlwind-Enhancement"
        Notes = "Very minor with base Whirlwind, but highly effective for Mountain Thane builds."
    }
    
    # === BLEED / DoT MECHANICS ===
    "Cold Steel, Hot Blood" = @{
        Type = "Passive"
        File = "Passive"
        Tags = "Arms,DoT,Bleed,Whirlwind-Enhancement"
        Functors = "StatsFunctorContext(OnCast);Conditions(CriticalHit());StatsFunctors(ApplyStatus(BLEEDING,100,6))"
        Notes = "Inflicts powerful bleed on critical hits. Can be applied to multiple targets via Whirlwind Meat Cleaver."
    }
    
    # === DEFENSIVE SYNERGIES (Offensive category but defensive mechanics) ===
    "Bitter Immunity" = @{
        Type = "Passive"
        File = "Passive"
        Tags = "Defensive,CC-Immunity,Situational"
        Boosts = "Resistance(Poison,Disease)"
        Notes = "Highly situational due to long cooldown. Grants immunity to specific effects."
    }
    
    "Reinforced Plates" = @{
        Type = "Passive"
        File = "Passive"
        RequiresAbility = "Armored to the Teeth"
        Tags = "Passive,Armor,Damage-Synergy"
        Boosts = "AC(1);Damage(IF_ArmoredToTheTeeth,Percentage)"
        Notes = "Synergizes with Armored to the Teeth. Provides armor and damage boost."
    }
    
    "Spiteful Serenity" = @{
        Type = "Passive"
        File = "Passive"
        Tags = "Fury,Enrage,Underwhelming"
        Notes = "Very underwhelming talent with negative bonus. Strong competition from other talents."
    }
    
    # === DUAL WIELD MECHANICS ===
    "Focus in Chaos" = @{
        Type = "Passive"
        File = "Passive"
        Tags = "Fury,Dual-Wield,Hit-Chance"
        Boosts = "HitChance(19)"
        Notes = "Removes 19% dual-wield miss penalty from auto-attacks (though they can still be dodged/parried)."
    }
    
    # === COOLDOWN REDUCTIONS ===
    "Thunderlord" = @{
        Type = "Passive"
        File = "Passive"
        ModifiesAbility = "Demoralizing Shout"
        Tags = "Protection,Cooldown-Reduction,Defensive"
        Notes = "Good cooldown reduction for Demoralizing Shout. Synergizes with other talents."
    }
    
    # === INTERRUPT ENHANCEMENTS ===
    "Concussive Blows" = @{
        Type = "Passive"
        File = "Passive"
        RequiresAbility = "Pummel"
        Tags = "Utility,Interrupt,Stun"
        Functors = "StatsFunctorContext(OnCast);Conditions(HasStringInSpellRoll('Pummel'));StatsFunctors(ApplyStatus(STUNNED,100,3))"
        Notes = "Underwhelming - only affects interrupted target, not AoE. 3s stun after successful interrupt."
    }
    
    # === PLACEHOLDER FOR UNKNOWN ABILITY ===
    "Grant Extra Attack" = @{
        Type = "Passive"
        File = "Passive"
        Tags = "Unknown,Extra-Attack"
        Notes = "NEEDS RESEARCH - No description available. Likely grants additional attack proc."
    }
}

Write-Host "[INFO] Enrichment library loaded: $($offensiveAbilities.Count) abilities" -ForegroundColor Cyan
Write-Host ""

# ENRICH DATABASE
$enrichedCount = 0

foreach ($ability in $db) {
    $name = $ability.ability_name.Trim()
    
    # Skip already enriched
    if ($ability.bg3_file_type -and $ability.archetype_tags) { continue }
    
    # Check if we have mechanics
    if ($offensiveAbilities.ContainsKey($name)) {
        $mech = $offensiveAbilities[$name]
        
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
Write-Host ""
Write-Host "[PROGRESS] $($enriched.Count) / $($db.Count) abilities enriched ($(($enriched.Count / $db.Count * 100).ToString('F1'))%)" -ForegroundColor Yellow
Write-Host ""
