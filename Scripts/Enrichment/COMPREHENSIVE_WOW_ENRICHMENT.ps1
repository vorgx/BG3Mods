# COMPREHENSIVE WoW to BG3 Ability Database Enrichment
# Date: October 20, 2025
# Purpose: Full WoW data + BG3 conversion + resource analysis + review flags

param(
    [Parameter(Mandatory=$false)]
    [string]$InputFile = "Documentation\00_SourcesOfTruth\AbilityDatabase_Warrior.csv",
    [Parameter(Mandatory=$false)]
    [string]$OutputFile = "Documentation\00_SourcesOfTruth\AbilityDatabase_Warrior_FullyEnriched.csv",
    [Parameter(Mandatory=$false)]
    [string]$ReviewFile = "Documentation\00_SourcesOfTruth\ABILITIES_NEEDING_REVIEW.md"
)

Write-Host "========================================" -ForegroundColor Cyan
Write-Host " WoW → BG3 COMPREHENSIVE ENRICHMENT" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Import database
$db = Import-Csv $InputFile -Encoding UTF8
Write-Host "[INFO] Loaded $($db.Count) abilities" -ForegroundColor Cyan
Write-Host ""

# EXISTING RESOURCES (from SOURCE_OF_TRUTH.md)
$existingResources = @(
    "Rage",              # Primary resource (0-100)
    "MobilityCharge",    # Charge, Heroic Leap, Intervene (2 charges, short rest)
    "ShieldBlockCharge", # Shield Block (1-2 charges, short rest)
    "RiposteCharge",     # Riposte system (TBD)
    "ExecuteWindow",     # Execute phase marker (TBD)
    "EnrageState"        # Fury enrage tracking (TBD)
)

# Track findings
$stats = @{
    RageCostsAdded = 0
    WowheadAdded = 0
    ArchetypeTagsAdded = 0
    BG3ConversionsAdded = 0
    ResourcesUsed = @{}
    NewResourcesNeeded = @()
    NeedsReview = @()
    PassivesConverted = 0
    OffensiveConverted = 0
    DefensiveConverted = 0
    UtilityConverted = 0
}

# Initialize resource tracking
foreach ($res in $existingResources) {
    $stats.ResourcesUsed[$res] = 0
}

Write-Host "[PHASE 1] WoW DATA ENRICHMENT" -ForegroundColor Yellow
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Yellow
Write-Host ""

# COMPREHENSIVE WOW DATA (from Icy-Veins + SOURCE_OF_TRUTH.md)
$wowData = @{
    # === CORE ATTACKS ===
    "Mortal Strike" = @{
        Rage = 30
        Cooldown = "None"
        SpellID = 12294
        Mechanics = "Primary Arms attack, applies Deep Wounds bleed"
        BG3Type = "Target"
        BG3File = "Spell_Target"
        BG3Formula = "2d6+StrengthModifier,Slashing"
        BG3Success = "DealDamage(2d6+StrengthModifier,Slashing);ApplyStatus(WAR_DEEP_WOUNDS,100,3)"
        Tags = "Arms,Single-Target,Bleed"
        Resource = "Rage"
    }
    
    "Execute" = @{
        Rage = 20
        Cooldown = "None"
        SpellID = 5308
        Mechanics = "Finisher, only usable below 20% HP, scales with extra rage spent"
        BG3Type = "Target"
        BG3File = "Spell_Target"
        BG3Formula = "4d12+StrengthModifier,Slashing"
        BG3Success = "DealDamage(4d12+StrengthModifier,Slashing)"
        BG3Conditions = "HealthPercentage(context.Target) <= 20"
        Tags = "Execute,Burst,Finisher"
        Resource = "Rage;ExecuteWindow"
        Notes = "Requires custom ExecuteWindow resource or target HP condition"
    }
    
    "Bloodthirst" = @{
        Rage = 20
        Cooldown = "None"
        SpellID = 23881
        Mechanics = "Fury core attack, heals for 3% max HP, triggers Enrage on crit"
        BG3Type = "Target"
        BG3File = "Spell_Target"
        BG3Formula = "2d8+StrengthModifier,Physical"
        BG3Success = "DealDamage(2d8+StrengthModifier,Physical);IF(CriticalHit()):ApplyStatus(WAR_ENRAGED,100,4);RegainHitPoints(3% MaxHP)"
        Tags = "Fury,Healing,Enrage"
        Resource = "Rage;EnrageState"
        Notes = "Needs EnrageState resource for tracking Enrage buff"
    }
    
    "Rampage" = @{
        Rage = 80
        Cooldown = "None"
        SpellID = 184367
        Mechanics = "Main Fury rage spender, 4-hit combo, triggers Enrage"
        BG3Type = "Target"
        BG3File = "Spell_Target"
        BG3Formula = "4*(1d6+StrengthModifier),Slashing"
        BG3Success = "DealDamage(1d6+StrengthModifier,Slashing);DealDamage(1d6+StrengthModifier,Slashing);DealDamage(1d6+StrengthModifier,Slashing);DealDamage(1d6+StrengthModifier,Slashing);ApplyStatus(WAR_ENRAGED,100,4)"
        Tags = "Fury,Burst,Enrage"
        Resource = "Rage;EnrageState"
    }
    
    "Raging Blow" = @{
        Rage = 0
        Cooldown = "None"
        SpellID = 85288
        Mechanics = "Free attack while Enraged, 2 charges, resets randomly"
        BG3Type = "Target"
        BG3File = "Spell_Target"
        BG3Formula = "2d8+StrengthModifier,Physical"
        BG3Success = "DealDamage(2d8+StrengthModifier,Physical)"
        BG3Conditions = "HasStatus('WAR_ENRAGED',context.Source)"
        Tags = "Fury,Free-Attack,Enrage"
        Resource = "EnrageState"
        Notes = "Requires Enrage status, may need charge resource"
    }
    
    "Whirlwind" = @{
        Rage = 0
        Cooldown = "None"
        SpellID = 1680
        Mechanics = "AoE spin attack, generates 10 rage, enables Meat Cleaver buff for Fury"
        BG3Type = "Zone"
        BG3File = "Spell_Zone"
        BG3Formula = "1d8+StrengthModifier,Slashing"
        BG3Success = "DealDamage(1d8+StrengthModifier,Slashing);RestoreResource(context.Source,Rage,10,0)"
        Tags = "AoE,Cleave,Rage-Generation"
        Resource = "Rage"
    }
    
    "Charge" = @{
        Rage = 0
        Cooldown = "Short Rest (2 charges)"
        SpellID = 100
        Mechanics = "Gap closer, generates 20 rage, shares charges with other mobility"
        BG3Type = "Target"
        BG3File = "Spell_Jump"
        BG3Formula = "None"
        BG3Success = "TeleportSource();RestoreResource(context.Source,Rage,20,0)"
        Tags = "Mobility,Rage-Generation"
        Resource = "Rage;MobilityCharge"
    }
    
    # === PROTECTION CORE ===
    "Shield Slam" = @{
        Rage = 0
        Cooldown = "None"
        SpellID = 23922
        Mechanics = "Main threat attack, generates 15 rage, enhanced by Shield Block"
        BG3Type = "Target"
        BG3File = "Spell_Target"
        BG3Formula = "2d6+StrengthModifier+ShieldAC,Bludgeoning"
        BG3Success = "DealDamage(2d6+StrengthModifier+ShieldAC,Bludgeoning);RestoreResource(context.Source,Rage,15,0)"
        Tags = "Protection,Tank,Rage-Generation"
        Resource = "Rage"
    }
    
    "Revenge" = @{
        Rage = 30
        Cooldown = "None"
        SpellID = 6572
        Mechanics = "AoE rage spender, procs from taking damage"
        BG3Type = "Zone"
        BG3File = "Spell_Zone"
        BG3Formula = "2d8+StrengthModifier,Physical"
        BG3Success = "DealDamage(2d8+StrengthModifier,Physical)"
        Tags = "Protection,AoE,Reactive"
        Resource = "Rage"
    }
    
    "Shield Block" = @{
        Rage = 0
        Cooldown = "Short Rest (1-2 charges)"
        SpellID = 2565
        Mechanics = "Active mitigation, blocks X% damage for 6 seconds"
        BG3Type = "Shout"
        BG3File = "Spell_Shout"
        BG3Formula = "None"
        BG3Success = "ApplyStatus(SELF,WAR_SHIELD_BLOCK,100,2)"
        Tags = "Protection,Defensive,Mitigation"
        Resource = "ShieldBlockCharge"
    }
    
    "Ignore Pain" = @{
        Rage = 40
        Cooldown = "None"
        SpellID = 190456
        Mechanics = "Absorb shield, core defensive ability"
        BG3Type = "Shout"
        BG3File = "Spell_Shout"
        BG3Formula = "None"
        BG3Success = "ApplyStatus(SELF,WAR_IGNORE_PAIN,100,6)"
        Tags = "Protection,Defensive,Absorb"
        Resource = "Rage"
    }
    
    # === COOLDOWNS ===
    "Avatar" = @{
        Rage = 0
        Cooldown = "3 minutes (OncePerCombat)"
        SpellID = 107574
        Mechanics = "Major offensive cooldown, +20% damage for 20 seconds"
        BG3Type = "Shout"
        BG3File = "Spell_Shout"
        BG3Formula = "None"
        BG3Success = "ApplyStatus(SELF,WAR_AVATAR,100,10)"
        Tags = "Cooldown,Burst,Offensive"
        Resource = "None"
    }
    
    "Bladestorm" = @{
        Rage = 0
        Cooldown = "90 seconds (OncePerCombat)"
        SpellID = 227847
        Mechanics = "Arms AoE channel, immune while active"
        BG3Type = "Zone"
        BG3File = "Spell_Zone"
        BG3Formula = "8*(1d6+StrengthModifier),Slashing"
        BG3Success = "DealDamage(1d6+StrengthModifier,Slashing);ApplyStatus(SELF,WAR_BLADESTORMING,100,4)"
        Tags = "Arms,AoE,Cooldown,Immunity"
        Resource = "None"
        Notes = "Channel effect may need special handling"
    }
    
    "Recklessness" = @{
        Rage = 0
        Cooldown = "90 seconds (OncePerCombat)"
        SpellID = 1719
        Mechanics = "Fury burst cooldown, auto-crits for 12 seconds"
        BG3Type = "Shout"
        BG3File = "Spell_Shout"
        BG3Formula = "None"
        BG3Success = "ApplyStatus(SELF,WAR_RECKLESSNESS,100,6)"
        Tags = "Fury,Cooldown,Burst"
        Resource = "None"
    }
    
    "Shield Wall" = @{
        Rage = 0
        Cooldown = "5 minutes (OncePerCombat)"
        SpellID = 871
        Mechanics = "Major defensive cooldown, 40% damage reduction"
        BG3Type = "Shout"
        BG3File = "Spell_Shout"
        BG3Formula = "None"
        BG3Success = "ApplyStatus(SELF,WAR_SHIELD_WALL,100,8)"
        Tags = "Protection,Defensive,Cooldown"
        Resource = "None"
    }
    
    "Last Stand" = @{
        Rage = 0
        Cooldown = "3 minutes (OncePerCombat)"
        SpellID = 12975
        Mechanics = "Emergency defensive, +30% max HP for 15 seconds"
        BG3Type = "Shout"
        BG3File = "Spell_Shout"
        BG3Formula = "None"
        BG3Success = "ApplyStatus(SELF,WAR_LAST_STAND,100,10)"
        Tags = "Protection,Defensive,Cooldown"
        Resource = "None"
    }
    
    # === MOBILITY ===
    "Heroic Leap" = @{
        Rage = 0
        Cooldown = "Short Rest (shares MobilityCharge)"
        SpellID = 6544
        Mechanics = "Jump to location, minor AoE damage"
        BG3Type = "Zone"
        BG3File = "Spell_Jump"
        BG3Formula = "1d6,Bludgeoning"
        BG3Success = "TeleportSource();DealDamage(1d6,Bludgeoning)"
        Tags = "Mobility,AoE"
        Resource = "MobilityCharge"
    }
    
    "Heroic Throw" = @{
        Rage = 0
        Cooldown = "None"
        SpellID = 57755
        Mechanics = "Weak ranged attack for pulling"
        BG3Type = "Projectile"
        BG3File = "Spell_Projectile"
        BG3Formula = "1d4+StrengthModifier,Physical"
        BG3Success = "DealDamage(1d4+StrengthModifier,Physical)"
        Tags = "Utility,Ranged"
        Resource = "None"
    }
    
    "Intervene" = @{
        Rage = 0
        Cooldown = "Short Rest (shares MobilityCharge)"
        SpellID = 3411
        Mechanics = "Charge to ally, reduce their damage taken"
        BG3Type = "Target"
        BG3File = "Spell_Jump"
        BG3Formula = "None"
        BG3Success = "TeleportSource();ApplyStatus(context.Target,WAR_INTERVENED,100,3)"
        Tags = "Utility,Defensive,Mobility"
        Resource = "MobilityCharge"
    }
    
    # === UTILITIES ===
    "Battle Shout" = @{
        Rage = 0
        Cooldown = "OncePerShortRest"
        SpellID = 6673
        Mechanics = "Raid buff, +5% attack power"
        BG3Type = "Shout"
        BG3File = "Spell_Shout"
        BG3Formula = "None"
        BG3Success = "ApplyStatus(SELF,WAR_BATTLE_SHOUT,100,600)"
        Tags = "Buff,Raid-Utility"
        Resource = "None"
    }
    
    "Rallying Cry" = @{
        Rage = 0
        Cooldown = "3 minutes (OncePerCombat)"
        SpellID = 97462
        Mechanics = "Raid-wide temporary HP"
        BG3Type = "Shout"
        BG3File = "Spell_Shout"
        BG3Formula = "None"
        BG3Success = "ApplyStatus(SELF,WAR_RALLYING_CRY,100,10)"
        Tags = "Defensive,Raid-Utility,Temporary-HP"
        Resource = "None"
    }
    
    "Pummel" = @{
        Rage = 0
        Cooldown = "OncePerTurn"
        SpellID = 6552
        Mechanics = "Interrupt, locks out school for 4 seconds"
        BG3Type = "Target"
        BG3File = "Spell_Target"
        BG3Formula = "None"
        BG3Success = "Interrupt()"
        Tags = "Utility,Interrupt"
        Resource = "None"
    }
    
    "Berserker Rage" = @{
        Rage = 0
        Cooldown = "OncePerShortRest"
        SpellID = 18499
        Mechanics = "CC removal + Enrage trigger for Fury"
        BG3Type = "Shout"
        BG3File = "Spell_Shout"
        BG3Formula = "None"
        BG3Success = "RemoveStatus('SG_Incapacitated');RemoveStatus('SG_Controlled');ApplyStatus(SELF,WAR_ENRAGED,100,4)"
        Tags = "Fury,Utility,Enrage,CC-Break"
        Resource = "EnrageState"
    }
    
    # === PASSIVES ===
    "Mastery: Deep Wounds" = @{
        Rage = 0
        Cooldown = "Passive"
        SpellID = 262111
        Mechanics = "Arms mastery, bleed damage scaling"
        BG3Type = "N/A"
        BG3File = "Passive"
        BG3Formula = "None"
        BG3Success = "Passive boost"
        Tags = "Arms,Passive,Bleed"
        Resource = "None"
    }
    
    "Titan's Grip" = @{
        Rage = 0
        Cooldown = "Passive"
        SpellID = 46917
        Mechanics = "Fury passive, allows dual-wielding 2H weapons"
        BG3Type = "N/A"
        BG3File = "Passive"
        BG3Formula = "None"
        BG3Success = "Equipment proficiency unlock"
        Tags = "Fury,Passive,Dual-Wield"
        Resource = "None"
        Notes = "May need custom proficiency system"
    }
    
    "Mastery: Critical Block" = @{
        Rage = 0
        Cooldown = "Passive"
        SpellID = 76857
        Mechanics = "Protection mastery, reduces blocked damage"
        BG3Type = "N/A"
        BG3File = "Passive"
        BG3Formula = "None"
        BG3Success = "Passive mitigation boost"
        Tags = "Protection,Passive,Block"
        Resource = "None"
    }
    
    # === STANCES ===
    "Battle Stance" = @{
        Rage = 0
        Cooldown = "None"
        SpellID = 2457
        Mechanics = "Offensive stance, +10% damage"
        BG3Type = "Shout"
        BG3File = "Spell_Shout"
        BG3Formula = "None"
        BG3Success = "ApplyStatus(SELF,WAR_BATTLE_STANCE,100,-1)"
        Tags = "Stance,Offensive"
        Resource = "None"
    }
    
    "Defensive Stance" = @{
        Rage = 0
        Cooldown = "None"
        SpellID = 71
        Mechanics = "Defensive stance, -10% damage taken"
        BG3Type = "Shout"
        BG3File = "Spell_Shout"
        BG3Formula = "None"
        BG3Success = "ApplyStatus(SELF,WAR_DEFENSIVE_STANCE,100,-1)"
        Tags = "Stance,Defensive"
        Resource = "None"
    }
    
    # === ADDITIONAL CORE ABILITIES ===
    "Overpower" = @{
        Rage = 0
        Cooldown = "None"
        SpellID = 7384
        Mechanics = "Free Arms attack, resets from Tactician procs"
        BG3Type = "Target"
        BG3File = "Spell_Target"
        BG3Formula = "2d6+StrengthModifier,Physical"
        BG3Success = "DealDamage(2d6+StrengthModifier,Physical)"
        Tags = "Arms,Free-Attack"
        Resource = "None"
    }
    
    "Slam" = @{
        Rage = 20
        Cooldown = "None"
        SpellID = 1464
        Mechanics = "Basic rage spender"
        BG3Type = "Target"
        BG3File = "Spell_Target"
        BG3Formula = "1d8+StrengthModifier,Bludgeoning"
        BG3Success = "DealDamage(1d8+StrengthModifier,Bludgeoning)"
        Tags = "Offensive"
        Resource = "Rage"
    }
    
    "Cleave" = @{
        Rage = 20
        Cooldown = "None"
        SpellID = 845
        Mechanics = "Arms AoE attack, applies Deep Wounds"
        BG3Type = "Zone"
        BG3File = "Spell_Zone"
        BG3Formula = "2d6+StrengthModifier,Slashing"
        BG3Success = "DealDamage(2d6+StrengthModifier,Slashing);ApplyStatus(WAR_DEEP_WOUNDS,100,3)"
        Tags = "Arms,AoE,Bleed"
        Resource = "Rage"
    }
    
    "Devastate" = @{
        Rage = 0
        Cooldown = "None"
        SpellID = 20243
        Mechanics = "Protection filler, generates rage"
        BG3Type = "Target"
        BG3File = "Spell_Target"
        BG3Formula = "1d6+StrengthModifier+ShieldAC,Physical"
        BG3Success = "DealDamage(1d6+StrengthModifier+ShieldAC,Physical);RestoreResource(context.Source,Rage,10,0)"
        Tags = "Protection,Rage-Generation"
        Resource = "Rage"
    }
    
    "Thunder Clap" = @{
        Rage = 20
        Cooldown = "None"
        SpellID = 6343
        Mechanics = "AoE slow + damage"
        BG3Type = "Zone"
        BG3File = "Spell_Zone"
        BG3Formula = "1d8+StrengthModifier,Thunder"
        BG3Success = "DealDamage(1d8+StrengthModifier,Thunder);ApplyStatus(WAR_SLOWED,100,3)"
        Tags = "AoE,Slow"
        Resource = "Rage"
    }
    
    "Shockwave" = @{
        Rage = 20
        Cooldown = "OncePerShortRest"
        SpellID = 46968
        Mechanics = "AoE stun"
        BG3Type = "Zone"
        BG3File = "Spell_Zone"
        BG3Formula = "1d6+StrengthModifier,Force"
        BG3Success = "DealDamage(1d6+StrengthModifier,Force);ApplyStatus(WAR_STUNNED,100,2)"
        Tags = "AoE,Stun,CC"
        Resource = "Rage"
    }
    
    "Taunt" = @{
        Rage = 0
        Cooldown = "OncePerTurn"
        SpellID = 355
        Mechanics = "Single-target taunt, forces attack on caster"
        BG3Type = "Target"
        BG3File = "Spell_Target"
        BG3Formula = "None"
        BG3Success = "ApplyStatus(context.Target,WAR_TAUNTED,100,1)"
        Tags = "Protection,Tank,Taunt"
        Resource = "None"
    }
    
    "Storm Bolt" = @{
        Rage = 0
        Cooldown = "OncePerShortRest"
        SpellID = 107570
        Mechanics = "Ranged stun"
        BG3Type = "Projectile"
        BG3File = "Spell_Projectile"
        BG3Formula = "1d6+StrengthModifier,Thunder"
        BG3Success = "DealDamage(1d6+StrengthModifier,Thunder);ApplyStatus(WAR_STUNNED,100,2)"
        Tags = "Utility,Stun,Ranged"
        Resource = "None"
    }
    
    "Die by the Sword" = @{
        Rage = 0
        Cooldown = "3 minutes (OncePerCombat)"
        SpellID = 118038
        Mechanics = "Arms defensive, parry all attacks for 8 seconds"
        BG3Type = "Shout"
        BG3File = "Spell_Shout"
        BG3Formula = "None"
        BG3Success = "ApplyStatus(SELF,WAR_DIE_BY_SWORD,100,4)"
        Tags = "Arms,Defensive,Cooldown"
        Resource = "None"
    }
    
    "Enraged Regeneration" = @{
        Rage = 0
        Cooldown = "OncePerShortRest"
        SpellID = 184364
        Mechanics = "Fury defensive, heal over time"
        BG3Type = "Shout"
        BG3File = "Spell_Shout"
        BG3Formula = "None"
        BG3Success = "ApplyStatus(SELF,WAR_ENRAGED_REGEN,100,5)"
        Tags = "Fury,Defensive,Healing"
        Resource = "None"
    }
    
    "Spell Reflection" = @{
        Rage = 0
        Cooldown = "OncePerShortRest"
        SpellID = 23920
        Mechanics = "Reflect next spell"
        BG3Type = "Shout"
        BG3File = "Spell_Shout"
        BG3Formula = "None"
        BG3Success = "ApplyStatus(SELF,WAR_SPELL_REFLECT,100,3)"
        Tags = "Defensive,Magic-Defense"
        Resource = "None"
    }
    
    "Onslaught" = @{
        Rage = 30
        Cooldown = "None"
        SpellID = 315720
        Mechanics = "Fury filler attack"
        BG3Type = "Target"
        BG3File = "Spell_Target"
        BG3Formula = "2d8+StrengthModifier,Physical"
        BG3Success = "DealDamage(2d8+StrengthModifier,Physical)"
        Tags = "Fury,Offensive"
        Resource = "Rage"
    }
    
    "Colossus Smash" = @{
        Rage = 0
        Cooldown = "45 seconds (OncePerShortRest)"
        SpellID = 167105
        Mechanics = "Arms burst window, +25% damage taken debuff"
        BG3Type = "Target"
        BG3File = "Spell_Target"
        BG3Formula = "2d10+StrengthModifier,Physical"
        BG3Success = "DealDamage(2d10+StrengthModifier,Physical);ApplyStatus(WAR_COLOSSUS_SMASH,100,5)"
        Tags = "Arms,Debuff,Burst"
        Resource = "None"
    }
    
    "Thunderous Roar" = @{
        Rage = 0
        Cooldown = "90 seconds (OncePerCombat)"
        SpellID = 384318
        Mechanics = "AoE bleed, uncapped targets"
        BG3Type = "Zone"
        BG3File = "Spell_Zone"
        BG3Formula = "2d8+StrengthModifier,Thunder"
        BG3Success = "DealDamage(2d8+StrengthModifier,Thunder);ApplyStatus(WAR_THUNDEROUS_BLEED,100,5)"
        Tags = "Arms,AoE,Bleed,Cooldown"
        Resource = "None"
    }
    
    "Odyn's Fury" = @{
        Rage = 0
        Cooldown = "45 seconds (OncePerShortRest)"
        SpellID = 385059
        Mechanics = "Fury AoE burst + bleed"
        BG3Type = "Zone"
        BG3File = "Spell_Zone"
        BG3Formula = "3d10+StrengthModifier,Physical"
        BG3Success = "DealDamage(3d10+StrengthModifier,Physical);ApplyStatus(WAR_ODYNS_BLEED,100,3)"
        Tags = "Fury,AoE,Burst,Cooldown"
        Resource = "None"
    }
    
    "Victory Rush" = @{
        Rage = 0
        Cooldown = "None (requires kill trigger)"
        SpellID = 34428
        Mechanics = "Free heal after killing blow"
        BG3Type = "Target"
        BG3File = "Spell_Target"
        BG3Formula = "None"
        BG3Success = "RegainHitPoints(20% MaxHP)"
        BG3Conditions = "HasStatus('WAR_VICTORIOUS',context.Source)"
        Tags = "Defensive,Healing,Reactive"
        Resource = "None"
        Notes = "Needs custom 'Victorious' status applied on kills"
    }
    
    "Hamstring" = @{
        Rage = 0
        Cooldown = "None"
        SpellID = 1715
        Mechanics = "Snare enemy movement"
        BG3Type = "Target"
        BG3File = "Spell_Target"
        BG3Formula = "None"
        BG3Success = "ApplyStatus(WAR_HAMSTRUNG,100,3)"
        Tags = "Utility,Slow"
        Resource = "None"
    }
    
    "Riposte" = @{
        Rage = 0
        Cooldown = "Passive"
        SpellID = 0
        Mechanics = "Protection passive, converts crit to parry"
        BG3Type = "N/A"
        BG3File = "Passive"
        BG3Formula = "None"
        BG3Success = "Passive conversion"
        Tags = "Protection,Passive,Mitigation"
        Resource = "None"
    }
}

Write-Host "[INFO] WoW data library loaded: $($wowData.Count) abilities" -ForegroundColor Cyan
Write-Host ""

# ENRICH DATABASE
Write-Host "[PHASE 2] ENRICHING DATABASE" -ForegroundColor Yellow
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Yellow
Write-Host ""

foreach ($ability in $db) {
    $name = $ability.ability_name.Trim()
    
    # Check if we have WoW data
    if ($wowData.ContainsKey($name)) {
        $data = $wowData[$name]
        
        # Add WoW rage cost
        if ($data.Rage) {
            $ability.wow_cost_rage = $data.Rage
            $stats.RageCostsAdded++
        }
        
        # Add Wowhead URL to implementation notes
        if ($data.SpellID) {
            $wowheadURL = "https://www.wowhead.com/spell=$($data.SpellID)"
            if ([string]::IsNullOrWhiteSpace($ability.implementation_notes)) {
                $ability.implementation_notes = "Wowhead: $wowheadURL"
            }
            else {
                $ability.implementation_notes += " | Wowhead: $wowheadURL"
            }
            $stats.WowheadAdded++
        }
        
        # Add archetype tags
        if ($data.Tags) {
            $ability.archetype_tags = $data.Tags
            $stats.ArchetypeTagsAdded++
        }
        
        # Add BG3 conversions
        if ($data.BG3File) {
            $ability.bg3_file_type = $data.BG3File
        }
        if ($data.BG3Type) {
            $ability.bg3_spell_type = $data.BG3Type
        }
        if ($data.BG3Success) {
            $ability.bg3_spell_success = $data.BG3Success
        }
        if ($data.BG3Conditions) {
            $ability.bg3_target_conditions = $data.BG3Conditions
        }
        if ($data.BG3Formula) {
            $ability.damage_formula_bg3 = $data.BG3Formula
        }
        if ($data.Cooldown -ne "None" -and $data.Cooldown -ne "Passive") {
            $ability.bg3_cooldown = $data.Cooldown
        }
        
        # Track resource usage
        if ($data.Resource) {
            $resources = $data.Resource -split ';'
            foreach ($res in $resources) {
                $res = $res.Trim()
                if ($existingResources -contains $res) {
                    $stats.ResourcesUsed[$res]++
                }
                else {
                    if ($stats.NewResourcesNeeded -notcontains $res) {
                        $stats.NewResourcesNeeded += $res
                    }
                }
            }
        }
        
        # Flag for review if has notes
        if ($data.Notes) {
            $stats.NeedsReview += @{
                Ability = $name
                Reason = $data.Notes
                Type = $ability.ability_type
            }
        }
        
        $stats.BG3ConversionsAdded++
        
        # Count by type
        switch ($ability.ability_type) {
            "Passive" { $stats.PassivesConverted++ }
            "Offensive" { $stats.OffensiveConverted++ }
            "Defensive" { $stats.DefensiveConverted++ }
            "Utility" { $stats.UtilityConverted++ }
        }
        
        Write-Host "[CONVERTED] $name ($($ability.ability_type)) → $($data.BG3File)" -ForegroundColor Green
    }
    else {
        # Ability not in WoW data library - add to review list
        if ($ability.ability_type -ne "Passive") {
            $stats.NeedsReview += @{
                Ability = $name
                Reason = "No WoW data found - needs manual research"
                Type = $ability.ability_type
            }
        }
    }
}

Write-Host ""
Write-Host "[DONE] Database enrichment complete!" -ForegroundColor Green
Write-Host ""

# EXPORT RESULTS
Write-Host "[PHASE 3] EXPORTING RESULTS" -ForegroundColor Yellow
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Yellow
Write-Host ""

$db | Export-Csv $OutputFile -NoTypeInformation -Encoding UTF8
Write-Host "[EXPORT] Enriched database: $OutputFile" -ForegroundColor Cyan

# CREATE REVIEW DOCUMENT
$reviewDoc = @"
# Abilities Needing Review - WoW to BG3 Conversion

**Generated**: $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")  
**Total Abilities Flagged**: $($stats.NeedsReview.Count)

---

## Summary

This document lists all abilities that require manual review during WoW → BG3 conversion due to:
- Missing WoW data (not in enrichment library)
- Complex mechanics requiring custom solutions
- Resource system dependencies
- BG3 engine limitations

---

## Resource Analysis

### Existing Resources (6 total)

"@

foreach ($res in $existingResources) {
    $count = $stats.ResourcesUsed[$res]
    $reviewDoc += "`n- **$res**: $count abilities use this resource"
}

$reviewDoc += @"


### New Resources Needed

"@

if ($stats.NewResourcesNeeded.Count -gt 0) {
    foreach ($newRes in $stats.NewResourcesNeeded) {
        $reviewDoc += "`n- **$newRes**: Required by multiple abilities"
    }
}
else {
    $reviewDoc += "`n- ✅ No new resources needed - all abilities work with existing 6 resources!"
}

$reviewDoc += @"


---

## Abilities Requiring Manual Review

"@

# Group by reason
$grouped = $stats.NeedsReview | Group-Object -Property Reason

foreach ($group in $grouped) {
    $reviewDoc += "`n### $($group.Name)`n"
    $reviewDoc += "`n**Count**: $($group.Count) abilities`n"
    $reviewDoc += "`n| Ability | Type |`n"
    $reviewDoc += "|---------|------|`n"
    
    foreach ($item in $group.Group) {
        $reviewDoc += "| $($item.Ability) | $($item.Type) |`n"
    }
    $reviewDoc += "`n"
}

$reviewDoc += @"

---

## Conversion Statistics

| Metric | Count |
|--------|-------|
| **Total Abilities in Database** | $($db.Count) |
| **Abilities with WoW Data Added** | $($stats.BG3ConversionsAdded) |
| **Rage Costs Added** | $($stats.RageCostsAdded) |
| **Wowhead URLs Added** | $($stats.WowheadAdded) |
| **Archetype Tags Added** | $($stats.ArchetypeTagsAdded) |
| **Passives Converted** | $($stats.PassivesConverted) |
| **Offensive Abilities Converted** | $($stats.OffensiveConverted) |
| **Defensive Abilities Converted** | $($stats.DefensiveConverted) |
| **Utility Abilities Converted** | $($stats.UtilityConverted) |
| **Abilities Needing Review** | $($stats.NeedsReview.Count) |

---

## Next Steps

1. **Review flagged abilities** - Research missing WoW data from Icy-Veins
2. **Design new resources** - If needed beyond our 6 existing resources
3. **Test complex mechanics** - Validate channel effects, reactive procs, kill triggers
4. **Validate formulas** - Ensure damage formulas balanced for BG3

---

**Generated by**: COMPREHENSIVE_WOW_ENRICHMENT.ps1
"@

$reviewDoc | Out-File $ReviewFile -Encoding UTF8
Write-Host "[EXPORT] Review document: $ReviewFile" -ForegroundColor Cyan
Write-Host ""

# FINAL SUMMARY
Write-Host "========================================" -ForegroundColor Cyan
Write-Host " ENRICHMENT COMPLETE - SUMMARY" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "📊 Conversion Statistics:" -ForegroundColor Yellow
Write-Host "  • Total abilities: $($db.Count)" -ForegroundColor White
Write-Host "  • Abilities enriched: $($stats.BG3ConversionsAdded)" -ForegroundColor Green
Write-Host "  • Rage costs added: $($stats.RageCostsAdded)" -ForegroundColor Green
Write-Host "  • Wowhead URLs added: $($stats.WowheadAdded)" -ForegroundColor Green
Write-Host "  • Archetype tags added: $($stats.ArchetypeTagsAdded)" -ForegroundColor Green
Write-Host ""
Write-Host "🎮 BG3 Conversions by Type:" -ForegroundColor Yellow
Write-Host "  • Offensive: $($stats.OffensiveConverted)" -ForegroundColor White
Write-Host "  • Defensive: $($stats.DefensiveConverted)" -ForegroundColor White
Write-Host "  • Utility: $($stats.UtilityConverted)" -ForegroundColor White
Write-Host "  • Passive: $($stats.PassivesConverted)" -ForegroundColor White
Write-Host ""
Write-Host "⚡ Resource Usage:" -ForegroundColor Yellow
foreach ($res in $existingResources) {
    $count = $stats.ResourcesUsed[$res]
    if ($count -gt 0) {
        Write-Host "  • $res : $count abilities" -ForegroundColor Cyan
    }
}
Write-Host ""
if ($stats.NewResourcesNeeded.Count -gt 0) {
    Write-Host "🆕 New Resources Needed:" -ForegroundColor Red
    foreach ($newRes in $stats.NewResourcesNeeded) {
        Write-Host "  • $newRes" -ForegroundColor Yellow
    }
}
else {
    Write-Host "✅ No new resources needed!" -ForegroundColor Green
}
Write-Host ""
Write-Host "⚠️  Abilities Needing Review: $($stats.NeedsReview.Count)" -ForegroundColor $(if ($stats.NeedsReview.Count -gt 0) { "Yellow" } else { "Green" })
Write-Host ""
Write-Host "📁 Output Files:" -ForegroundColor Yellow
Write-Host "  • Database: $OutputFile" -ForegroundColor Cyan
Write-Host "  • Review List: $ReviewFile" -ForegroundColor Cyan
Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host " ✅ ENRICHMENT SUCCESSFUL" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
