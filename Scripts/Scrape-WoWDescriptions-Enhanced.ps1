<#
.SYNOPSIS
    Enhanced: Scrapes descriptions AND populates missing fields intelligently
.DESCRIPTION
    When adding descriptions, also attempts to populate:
    - wow_mechanic_type (from description analysis)
    - bg3_mechanic_equivalent (suggested BG3 conversion)
    - resource_cost_rage (from description/WoW data)
    - damage_formula (from description)
    - bg3_target_conditions (suggested conditions)
    - implementation_notes (auto-generated guidance)
#>

param(
    [string]$DbPath = "c:\Users\tenod\source\repos\BG3Mods\Documentation\00_SourcesOfTruth\AbilityDatabase_Warrior_FullyEnriched.csv",
    [switch]$DryRun
)

Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host "ENHANCED WOW DESCRIPTION + FIELD POPULATOR" -ForegroundColor Cyan
Write-Host "========================================`n" -ForegroundColor Cyan

# Load database
$Db = Import-Csv $DbPath -Encoding UTF8
$UpdateCount = 0
$FieldsPopulated = 0

# ========================================
# ENSURE NEW COLUMNS EXIST
# ========================================
$RequiredColumns = @('wow_mechanic_type', 'bg3_mechanic_equivalent', 'resource_cost_rage', 'damage_formula')
$FirstAbility = $Db[0]
foreach ($col in $RequiredColumns) {
    if (-not ($FirstAbility.PSObject.Properties.Name -contains $col)) {
        Write-Host "  [INFO] Adding missing column: $col" -ForegroundColor Yellow
        foreach ($ability in $Db) {
            $ability | Add-Member -MemberType NoteProperty -Name $col -Value "" -Force
        }
    }
}

# Enhanced hero talent data with full field information
$HeroTalentData = @{
    # ========================================
    # MOUNTAIN THANE (Protection/Fury)
    # ========================================
    'Lightning Strikes' = @{
        Description = @{
            Short = 'Random lightning damage proc from rotational abilities.'
            Full = 'Random single target damage proc from most rotational abilities. The increased chance is multiplicative (25 * 1.3 = 32.5% chance), rather than additive.'
        }
        Fields = @{
            wow_mechanic_type = 'Proc-Based Damage'
            bg3_mechanic_equivalent = 'OnCast() -> Roll(25% + Bonuses) -> DealDamage(Lightning)'
            resource_cost_rage = '0'  # Passive proc
            damage_formula = '1d8+StrengthModifier,Lightning'
            bg3_target_conditions = 'N/A - Passive'
            implementation_notes = 'Passive that triggers on spell casts. Use StatsFunctor with OnCast context. 25% base chance, multiplicative with talents.'
        }
    }
    
    'Thunder Blast' = @{
        Description = @{
            Short = 'Stronger version of Thunder Clap that ignores armor.'
            Full = 'Enables Thunder Blast, a stronger version of Thunder Clap that ignores armor. Granted by Avatar casts.'
        }
        Fields = @{
            wow_mechanic_type = 'Ability Replacement/Enhancement'
            bg3_mechanic_equivalent = 'DealDamage(ignores AC) + ApplyStatus(Thunder_Blast_Buff)'
            resource_cost_rage = '30'
            damage_formula = '4d8+StrengthModifier,Thunder'
            bg3_target_conditions = 'AreaTarget() within 15ft'
            implementation_notes = 'Granted by Avatar status. Uses Thunder damage type (ignores armor = no AC check). Replaces Thunder Clap during Avatar.'
        }
    }
    
    'Avatar of the Storm' = @{
        Description = @{
            Short = 'Grants Thunder Blast charges when casting Avatar.'
            Full = 'Thunder Blast charges are only granted by natural casts of Avatar, not including procs from Berserker or Titan''s Torment.'
        }
        Fields = @{
            wow_mechanic_type = 'Charge Generation'
            bg3_mechanic_equivalent = 'IF(Spell = WAR_Avatar AND NOT HasStatus(Proc)):ApplyStatus(THUNDER_BLAST_CHARGES, 3)'
            resource_cost_rage = '0'  # Passive
            damage_formula = 'N/A'
            bg3_target_conditions = 'N/A - Passive'
            implementation_notes = 'Keystone passive. Triggers only on manual Avatar casts (exclude procs). Grant 3 Thunder Blast charges via status effect.'
        }
    }
    
    'Storm Bolts' = @{
        Description = @{
            Short = 'Splits stun effect across multiple targets.'
            Full = 'A mostly PvP talent, as being unable to dictate which two extra targets can contribute to diminishing returns.'
        }
        Fields = @{
            wow_mechanic_type = 'AoE Stun'
            bg3_mechanic_equivalent = 'DealDamage(Primary) + ApplyStatus(STUNNED,2turns) + Random(2,EnemiesWithin30ft):ApplyStatus(STUNNED,1turn)'
            resource_cost_rage = '0'  # Modifies Storm Bolt
            damage_formula = '2d6+StrengthModifier,Bludgeoning'
            bg3_target_conditions = 'Distance() <= 30'
            implementation_notes = 'Modifies Storm Bolt to stun 2 additional random enemies. Primary target: 2 turns, others: 1 turn. Use Random() target selector.'
        }
    }
    
    'Crashing Thunder' = @{
        Description = @{
            Short = 'Allows Thunder Clap to replace Whirlwind in rotation.'
            Full = 'Allows Thunder Clap to effectively replace Whirlwind within the rotation.'
        }
        Fields = @{
            wow_mechanic_type = 'Ability Enhancement'
            bg3_mechanic_equivalent = 'DealDamage(Thunder Clap) + ApplyStatus(WHIRLWIND_BUFF,6sec)'
            resource_cost_rage = '0'  # Passive modifier
            damage_formula = 'N/A - Enhancement'
            bg3_target_conditions = 'N/A - Passive'
            implementation_notes = 'Passive that makes Thunder Clap grant Whirlwind buff effects. Add to Thunder Clap SpellSuccess functor.'
        }
    }
    
    # ========================================
    # COLOSSUS (Arms/Protection)
    # ========================================
    'Demolish' = @{
        Description = @{
            Short = 'Powerful three-hit combo that slows movement by 99%.'
            Full = 'Very powerful three-hit combo, slowing movement speed by 99%. Defensive and mobility abilities do not interrupt the attack.'
        }
        Fields = @{
            wow_mechanic_type = 'Multi-Hit Attack + CC'
            bg3_mechanic_equivalent = 'DealDamage(Hit1) + DealDamage(Hit2) + DealDamage(Hit3) + ApplyStatus(SLOWED_99,3turns)'
            resource_cost_rage = '25'
            damage_formula = '5d12+StrengthModifier,Physical (total over 3 hits)'
            bg3_target_conditions = 'MeleeRange() and not Dead()'
            implementation_notes = 'Spell_Target with 3 sequential damage rolls. Apply SLOWED status (-99% movement). Uninterruptible (SpellFlags = Uninterruptible).'
        }
    }
    
    'Dominance of the Colossus' = @{
        Description = @{
            Short = 'Grants cooldown reduction and damage amplification debuff.'
            Full = 'Grants cooldown reduction and applies a debuff that increases all damage dealt, including that of the Demolish that applies it.'
        }
        Fields = @{
            wow_mechanic_type = 'Damage Amplification'
            bg3_mechanic_equivalent = 'ApplyStatus(WAR_COLOSSUS_VULNERABILITY,100,6) -> AddDamageBonus(20%,All)'
            resource_cost_rage = '0'  # Passive
            damage_formula = 'N/A'
            bg3_target_conditions = 'N/A - Passive'
            implementation_notes = 'Keystone passive. Demolish applies vulnerability status (20% increased damage taken). Also reduces Demolish CD by 20%.'
        }
    }
    
    'Colossal Might' = @{
        Description = @{
            Short = 'Effectively doubles Demolish damage.'
            Full = 'Effectively doubles the damage of Demolish when active.'
        }
        Fields = @{
            wow_mechanic_type = 'Damage Multiplier'
            bg3_mechanic_equivalent = 'IF(HasStringInSpellRoll(''WAR_Demolish'')):MultiplyDamage(2.0)'
            resource_cost_rage = '0'  # Passive
            damage_formula = 'N/A - Multiplier'
            bg3_target_conditions = 'N/A - Passive'
            implementation_notes = 'Passive.txt entry with StatsFunctorContext = OnCast + Conditions checking for Demolish. Use DamageBonus(100%).'
        }
    }
    
    # ========================================
    # SLAYER (Arms/Fury)
    # ========================================
    'Slayers Dominance' = @{
        Description = @{
            Short = 'Frequent damage proc that applies Marked for Execution.'
            Full = 'Frequent random single target damage proc that inflicts the much more important Marked for Execution debuff.'
        }
        Fields = @{
            wow_mechanic_type = 'Proc Damage + Debuff'
            bg3_mechanic_equivalent = 'OnAttack():Roll(30%) -> DealDamage(2d8,Physical) + ApplyStatus(MARKED_FOR_EXECUTION,100,12)'
            resource_cost_rage = '0'  # Passive
            damage_formula = '2d8,Physical'
            bg3_target_conditions = 'N/A - Passive Proc'
            implementation_notes = 'Keystone passive. 30% proc chance on attacks. Mark status enables Execute below 35% HP and grants 20% damage taken.'
        }
    }
    
    'Imminent Demise' = @{
        Description = @{
            Short = 'Allows consuming Marked for Execution, empowers Bladestorm.'
            Full = 'Allows the consumption of Marked for Execution, even without Sudden Death talented, while also making Bladestorm much more powerful. Has strong synergy with Unhinged.'
        }
        Fields = @{
            wow_mechanic_type = 'Buff Consumption + Enhancement'
            bg3_mechanic_equivalent = 'IF(HasStatus(MARKED_FOR_EXECUTION)):RemoveStatus() + DealDamage(Bladestorm * 1.5)'
            resource_cost_rage = '0'  # Passive
            damage_formula = 'N/A - Enhancer'
            bg3_target_conditions = 'N/A - Passive'
            implementation_notes = 'Passive that allows Execute without Sudden Death if target marked. Bladestorm deals 50% more damage to marked targets.'
        }
    }
    
    'Brutal Finish' = @{
        Description = @{
            Short = 'Slayer talent: Execute deals more damage.'
            Full = '+2d12 to Execute'
        }
        Fields = @{
            wow_mechanic_type = 'Direct Damage Increase'
            bg3_mechanic_equivalent = 'IF(HasStringInSpellRoll(''WAR_Execute'')):AddDamageBonus(2d12)'
            resource_cost_rage = '0'  # Passive
            damage_formula = '+2d12 bonus'
            bg3_target_conditions = 'N/A - Passive'
            implementation_notes = 'Simple passive damage boost. Use Conditions checking for Execute spell, then AddDamageBonus functor.'
        }
    }
    
    'Opportunist' = @{
        Description = @{
            Short = 'Slayer talent: Attacks against bleeding/stunned targets deal more.'
            Full = '+1d8 vs bleeding/stunned'
        }
        Fields = @{
            wow_mechanic_type = 'Conditional Damage'
            bg3_mechanic_equivalent = 'IF(HasStatus(''BLEEDING'',Target) OR HasStatus(''STUNNED'',Target)):AddDamageBonus(1d8)'
            resource_cost_rage = '0'  # Passive
            damage_formula = '+1d8 conditional bonus'
            bg3_target_conditions = 'HasStatus(BLEEDING or STUNNED)'
            implementation_notes = 'Passive with OnDamage context. Check target for BLEEDING or STUNNED status, then add 1d8 damage.'
        }
    }
    
    'Overwhelming Blades' = @{
        Description = @{
            Short = 'Slayer talent: Whirlwind/Bladestorm hit harder.'
            Full = '+1d10 to Whirlwind/Bladestorm'
        }
        Fields = @{
            wow_mechanic_type = 'AoE Damage Increase'
            bg3_mechanic_equivalent = 'IF(HasStringInSpellRoll(''WAR_Whirlwind'') OR HasStringInSpellRoll(''WAR_Bladestorm'')):AddDamageBonus(1d10)'
            resource_cost_rage = '0'  # Passive
            damage_formula = '+1d10 bonus'
            bg3_target_conditions = 'N/A - Passive'
            implementation_notes = 'Passive checking for Whirlwind/Bladestorm casts. Use HasStringInSpellRoll with OR condition.'
        }
    }
    
    'Relentless Pursuit' = @{
        Description = @{
            Short = 'Slayer talent: Charge CD reduced.'
            Full = 'Charge range +10ft, CDR on kills'
        }
        Fields = @{
            wow_mechanic_type = 'Cooldown Reduction'
            bg3_mechanic_equivalent = 'ModifyCooldown(WAR_Charge,-1turn) + IF(Kill()):ResetCooldown(WAR_Charge)'
            resource_cost_rage = '0'  # Passive
            damage_formula = 'N/A'
            bg3_target_conditions = 'N/A - Passive'
            implementation_notes = 'Passive that reduces Charge CD by 1 turn. OnKill functor resets Charge cooldown entirely. Range increase via SpellProperties.'
        }
    }
    
    "Slayer's Malice" = @{
        Description = @{
            Short = 'Slayer talent: Critical strikes restore Rage.'
            Full = 'Capstone: Crits restore 5 Rage (max 100/combat)'
        }
        Fields = @{
            wow_mechanic_type = 'Resource Generation'
            bg3_mechanic_equivalent = 'IF(IsCriticalHit()):RestoreResource(context.Source,Rage,5,0)'
            resource_cost_rage = '0'  # Passive
            damage_formula = 'N/A'
            bg3_target_conditions = 'N/A - Passive'
            implementation_notes = 'Capstone passive. OnDamage context, check IsCriticalHit(), restore 5 Rage. Track total (max 100) via counter status.'
        }
    }
    
    # ========================================
    # ADDITIONAL MOUNTAIN THANE TALENTS
    # ========================================
    'Ground Current' = @{
        Description = @{
            Short = 'Lightning Strikes hit multiple targets for reduced damage.'
            Full = 'Allows Lightning Strikes to hit multiple targets for significantly reduced damage. Does not hit the primary target of the lightning strike''s initial target.'
        }
        Fields = @{
            wow_mechanic_type = 'AoE Enhancement'
            bg3_mechanic_equivalent = 'IF(LightningStrike):DealDamage(Random(3,EnemiesWithin15ft),1d4,Lightning)'
            resource_cost_rage = '0'  # Passive
            damage_formula = '1d4,Lightning (reduced from main)'
            bg3_target_conditions = 'Random enemies within 15ft'
            implementation_notes = 'Modifies Lightning Strikes passive. When lightning proc triggers, hit 3 additional random enemies for reduced damage (1d4 vs 1d8).'
        }
    }
    
    'Strength of the Mountain' = @{
        Description = @{
            Short = 'General damage increase.'
            Full = 'General damage increase for Mountain Thane warriors.'
        }
        Fields = @{
            wow_mechanic_type = 'Stat Boost'
            bg3_mechanic_equivalent = 'AddDamageBonus(5%,All) + Ability(Strength,+1)'
            resource_cost_rage = '0'  # Passive
            damage_formula = 'N/A - Stat Boost'
            bg3_target_conditions = 'N/A - Passive'
            implementation_notes = 'Passive stat boost. Grants +1 Strength and 5% damage increase. Use Boosts field in Passive.txt.'
        }
    }
    
    'Burst of Power' = @{
        Description = @{
            Short = 'Random Bloodthirst damage increase.'
            Full = 'Random Bloodthirst damage increase triggered by lightning effects.'
        }
        Fields = @{
            wow_mechanic_type = 'Conditional Damage Boost'
            bg3_mechanic_equivalent = 'IF(HasStatus(LIGHTNING_BUFF)):AddDamageBonus(2d6) to Bloodthirst'
            resource_cost_rage = '0'  # Passive
            damage_formula = '+2d6 bonus damage'
            bg3_target_conditions = 'N/A - Passive'
            implementation_notes = 'Passive that enhances Bloodthirst after Lightning Strike procs. Check for LIGHTNING_BUFF status, add 2d6 damage.'
        }
    }
    
    'Flashing Skies' = @{
        Description = @{
            Short = 'Significantly boosts Thunder Blast single target damage.'
            Full = 'Significantly boosts the single target value of Thunder Blast. Triggers in addition to the normal random chance for a lightning strike, allowing two for one cast.'
        }
        Fields = @{
            wow_mechanic_type = 'Damage Enhancement + Extra Proc'
            bg3_mechanic_equivalent = 'IF(Spell=Thunder_Blast):AddDamageBonus(50%) + TriggerLightningStrike()'
            resource_cost_rage = '0'  # Passive
            damage_formula = '+50% Thunder Blast damage'
            bg3_target_conditions = 'N/A - Passive'
            implementation_notes = 'Passive that boosts Thunder Blast damage by 50% AND triggers bonus Lightning Strike. Use two separate functors in StatsFunctors.'
        }
    }
    
    'Thorims Might' = @{
        Description = @{
            Short = 'Greatly empowers lightning strikes and rotational abilities.'
            Full = 'Very powerful, giving lightning strikes and rotational abilities much more value.'
        }
        Fields = @{
            wow_mechanic_type = 'Universal Damage Boost'
            bg3_mechanic_equivalent = 'AddDamageBonus(10%,Lightning) + AddDamageBonus(5%,Physical)'
            resource_cost_rage = '0'  # Passive
            damage_formula = 'N/A - Multiplier'
            bg3_target_conditions = 'N/A - Passive'
            implementation_notes = 'Major passive boost. Increases Lightning damage by 10% and all Physical abilities by 5%. Use Boosts field with multiple entries.'
        }
    }
    
    'Keep your feet on the Ground' = @{
        Description = @{
            Short = 'Strong defensive bonus from Thunder Blast procs.'
            Full = 'Very strong passive defensive bonus due to the high frequency of Thunder Blast procs.'
        }
        Fields = @{
            wow_mechanic_type = 'CC Immunity'
            bg3_mechanic_equivalent = 'ApplyStatus(GROUNDED,100,6) -> Immune(Prone,Shove,Knockback)'
            resource_cost_rage = '0'  # Passive
            damage_formula = 'N/A'
            bg3_target_conditions = 'N/A - Passive'
            implementation_notes = 'After Thunder Blast cast, apply GROUNDED status granting immunity to forced movement. 6 second duration.'
        }
    }
    
    'Tide of Battle' = @{
        Description = @{
            Short = 'Variable Overpower damage increase.'
            Full = 'Variable Overpower damage increase based on combat conditions.'
        }
        Fields = @{
            wow_mechanic_type = 'Conditional Damage'
            bg3_mechanic_equivalent = 'IF(Overpower):AddDamageBonus(1d6 per enemy within 10ft, max 3d6)'
            resource_cost_rage = '0'  # Passive
            damage_formula = '+1d6 to +3d6 conditional'
            bg3_target_conditions = 'N/A - Passive'
            implementation_notes = 'Overpower deals extra damage based on nearby enemies. Count enemies within 10ft, add 1d6 per enemy (max 3d6).'
        }
    }
    
    'No Stranger to Pain' = @{
        Description = @{
            Short = 'Increases Ignore Pain effectiveness.'
            Full = 'Increases the value of Ignore Pain, though the ability itself is rather small.'
        }
        Fields = @{
            wow_mechanic_type = 'Damage Reduction Enhancement'
            bg3_mechanic_equivalent = 'IF(HasStatus(IGNORE_PAIN)):AddDamageReduction(25%)'
            resource_cost_rage = '0'  # Passive
            damage_formula = 'N/A'
            bg3_target_conditions = 'N/A - Passive'
            implementation_notes = 'Passive that increases Ignore Pain damage reduction from base to 25% total. Modify Ignore Pain status effect.'
        }
    }
    
    # ========================================
    # ADDITIONAL COLOSSUS TALENTS
    # ========================================
    'Earthquake' = @{
        Description = @{
            Short = 'Very useful for reduced cooldown and knock-up disruption.'
            Full = 'Very useful for its reduced cooldown, while the knock-up allows disruption in spite of diminishing returns.'
        }
        Fields = @{
            wow_mechanic_type = 'AoE Control'
            bg3_mechanic_equivalent = 'DealDamage(3d8,Bludgeoning,AOE) + ApplyStatus(PRONE,100,1)'
            resource_cost_rage = '15'
            damage_formula = '3d8,Bludgeoning'
            bg3_target_conditions = 'GroundTarget() within 30ft'
            implementation_notes = 'Spell_Zone ground-targeted AoE. Deals damage and knocks prone. 30 second cooldown (OncePerShortRest).'
        }
    }
    
    'Martial Expert' = @{
        Description = @{
            Short = 'Increases critical strike damage.'
            Full = 'One of several critical strike damage boosts for Colossus warriors.'
        }
        Fields = @{
            wow_mechanic_type = 'Critical Enhancement'
            bg3_mechanic_equivalent = 'CriticalMultiplier(+0.5)'
            resource_cost_rage = '0'  # Passive
            damage_formula = 'N/A - Multiplier'
            bg3_target_conditions = 'N/A - Passive'
            implementation_notes = 'Passive that increases critical damage multiplier. Critical hits deal 3x damage instead of 2x (BG3 default).'
        }
    }
    
    'Practiced Strikes' = @{
        Description = @{
            Short = 'General damage increase.'
            Full = 'General damage increase for Colossus warriors.'
        }
        Fields = @{
            wow_mechanic_type = 'Damage Boost'
            bg3_mechanic_equivalent = 'AddDamageBonus(5%,MeleeWeapon)'
            resource_cost_rage = '0'  # Passive
            damage_formula = 'N/A - Multiplier'
            bg3_target_conditions = 'N/A - Passive'
            implementation_notes = 'Simple passive +5% damage boost to all melee weapon attacks. Use Boosts field.'
        }
    }
    
    'Precise Might' = @{
        Description = @{
            Short = 'Emphasizes regular Mortal Strike use and critical strikes.'
            Full = 'Further emphasizes using Mortal Strike regularly and getting critical strikes.'
        }
        Fields = @{
            wow_mechanic_type = 'Critical Enhancement'
            bg3_mechanic_equivalent = 'IF(Spell=Mortal_Strike):CriticalChance(+10%)'
            resource_cost_rage = '0'  # Passive
            damage_formula = 'N/A'
            bg3_target_conditions = 'N/A - Passive'
            implementation_notes = 'Passive that increases Mortal Strike critical chance by 10%. Use StatsFunctor with OnCast context.'
        }
    }
    
    'Mountain of Muscle and Scars' = @{
        Description = @{
            Short = 'General damage/defense increase.'
            Full = 'General damage/defense, and almost unnoticeable size increase.'
        }
        Fields = @{
            wow_mechanic_type = 'Stat Boost'
            bg3_mechanic_equivalent = 'Ability(Constitution,+2) + IncreaseMaxHP(20)'
            resource_cost_rage = '0'  # Passive
            damage_formula = 'N/A'
            bg3_target_conditions = 'N/A - Passive'
            implementation_notes = 'Passive that grants +2 Constitution and +20 max HP. Use Boosts field for stat increase and HP boost.'
        }
    }
    
    'Arterial Bleed' = @{
        Description = @{
            Short = 'Enhances bleed effects.'
            Full = 'Enhances bleed effects applied by Colossus abilities.'
        }
        Fields = @{
            wow_mechanic_type = 'DoT Enhancement'
            bg3_mechanic_equivalent = 'IF(ApplyStatus(BLEEDING)):IncreaseDuration(+2turns) + IncreaseDamage(+1d4)'
            resource_cost_rage = '0'  # Passive
            damage_formula = '+1d4 bleed damage per turn'
            bg3_target_conditions = 'N/A - Passive'
            implementation_notes = 'Passive that enhances all bleed effects. Increases duration by 2 turns and damage by 1d4 per turn.'
        }
    }
    
    # ========================================
    # ADDITIONAL SLAYER TALENTS
    # ========================================
    'Unrelenting Onslaught' = @{
        Description = @{
            Short = 'Increases Bladestorm frequency at cost of cooldown sync.'
            Full = 'Typically desyncs Bladestorm from other major cooldowns, though the increased frequency is worth the tradeoff.'
        }
        Fields = @{
            wow_mechanic_type = 'Cooldown Reduction'
            bg3_mechanic_equivalent = 'ModifyCooldown(WAR_Bladestorm,-30sec)'
            resource_cost_rage = '0'  # Passive
            damage_formula = 'N/A'
            bg3_target_conditions = 'N/A - Passive'
            implementation_notes = 'Passive that reduces Bladestorm cooldown from 90 seconds to 60 seconds. Use Boosts field with Cooldown modifier.'
        }
    }
    
    'Death Drive' = @{
        Description = @{
            Short = 'Minor random healing during execute phase.'
            Full = 'Very minor and largely random, which means it will not always be effective healing.'
        }
        Fields = @{
            wow_mechanic_type = 'Conditional Healing'
            bg3_mechanic_equivalent = 'IF(Execute):Heal(1d6+Constitution)'
            resource_cost_rage = '0'  # Passive
            damage_formula = '1d6+Constitution healing'
            bg3_target_conditions = 'N/A - Passive'
            implementation_notes = 'Passive that heals warrior when Execute is used. Small heal (1d6+Con). Use OnCast functor with Heal.'
        }
    }
    
    'Show No Mercy' = @{
        Description = @{
            Short = 'Damage increase tied to Marked for Execution procs.'
            Full = 'Another damage increase tied to Marked for Execution and Sudden Death procs.'
        }
        Fields = @{
            wow_mechanic_type = 'Conditional Damage'
            bg3_mechanic_equivalent = 'IF(Target.HasStatus(MARKED_FOR_EXECUTION)):AddDamageBonus(15%)'
            resource_cost_rage = '0'  # Passive
            damage_formula = '+15% damage vs marked'
            bg3_target_conditions = 'N/A - Passive'
            implementation_notes = 'Passive that increases all damage dealt to marked targets by 15%. Use OnDamage context with target condition check.'
        }
    }
    
    'Reap the Storm' = @{
        Description = @{
            Short = 'Slayer talent: Whirlwind generates more Rage.'
            Full = 'Whirlwind generates 1 Rage per target hit'
        }
        Fields = @{
            wow_mechanic_type = 'Resource Generation'
            bg3_mechanic_equivalent = 'IF(HasStringInSpellRoll(''WAR_Whirlwind'')):RestoreResource(context.Source,Rage,10,0)'
            resource_cost_rage = '0'  # Passive
            damage_formula = 'N/A'
            bg3_target_conditions = 'N/A - Passive'
            implementation_notes = 'Passive that grants 10 Rage per Whirlwind cast (simulating 1 per target in 10ft radius). Use OnCast functor.'
        }
    }
    
    'Fierce Followthrough' = @{
        Description = @{
            Short = 'Critical strikes grant damage bonus to all targets.'
            Full = 'Only triggers off crits against the primary target, though the resulting damage bonus affects every target.'
        }
        Fields = @{
            wow_mechanic_type = 'Critical Buff'
            bg3_mechanic_equivalent = 'IF(IsCriticalHit()):ApplyStatus(FIERCE_BUFF,100,1) -> AddDamageBonus(20%,NextAttack)'
            resource_cost_rage = '0'  # Passive
            damage_formula = '+20% damage on next attack'
            bg3_target_conditions = 'N/A - Passive'
            implementation_notes = 'When critical hit lands, apply status granting 20% damage bonus to next attack. Status expires after 1 attack or 1 turn.'
        }
    }
    
    'Culling Cyclone' = @{
        Description = @{
            Short = 'Increases Bladestorm single target value.'
            Full = 'Increases the single target value of Bladestorm, but does not further increase damage by hitting multiple targets.'
        }
        Fields = @{
            wow_mechanic_type = 'Single Target Enhancement'
            bg3_mechanic_equivalent = 'IF(Bladestorm AND SingleTarget):AddDamageBonus(50%)'
            resource_cost_rage = '0'  # Passive
            damage_formula = '+50% when only 1 target'
            bg3_target_conditions = 'N/A - Passive'
            implementation_notes = 'Passive that boosts Bladestorm damage by 50% when only one enemy is in range. Check enemy count before applying.'
        }
    }
    
    'Vicious Agility' = @{
        Description = @{
            Short = 'Movement speed bonus after kills.'
            Full = 'Less regularly useful outside of specific encounter timing, though minorly better for open world content.'
        }
        Fields = @{
            wow_mechanic_type = 'Movement Buff'
            bg3_mechanic_equivalent = 'OnKill():ApplyStatus(AGILITY_BUFF,100,2) -> Movement(+15ft)'
            resource_cost_rage = '0'  # Passive
            damage_formula = 'N/A'
            bg3_target_conditions = 'N/A - Passive'
            implementation_notes = 'Passive that grants +15ft movement for 2 turns after killing an enemy. Use OnKill functor with status application.'
        }
    }
    
    'Grant Extra Attack' = @{
        Description = @{
            Short = 'Grants additional attack action.'
            Full = 'Provides an extra attack action during combat, allowing for additional offensive capabilities.'
        }
        Fields = @{
            wow_mechanic_type = 'Action Economy'
            bg3_mechanic_equivalent = 'ExtraAttack(1)'
            resource_cost_rage = '0'  # Passive
            damage_formula = 'N/A'
            bg3_target_conditions = 'N/A - Passive'
            implementation_notes = 'Core passive granting Extra Attack feature (similar to Fighter level 5). Use Boosts field: ActionResource(BonusAttack,1,0).'
        }
    }
}

Write-Host "[INFO] Loaded $($HeroTalentData.Count) hero talents with enhanced field data" -ForegroundColor Cyan

# Update database
foreach ($ability in $Db) {
    $name = $ability.ability_name
    
    if ($HeroTalentData.ContainsKey($name)) {
        $needsUpdate = $false
        $data = $HeroTalentData[$name]
        $fieldsUpdated = @()
        
        # ========================================
        # UPDATE DESCRIPTIONS
        # ========================================
        if ([string]::IsNullOrWhiteSpace($ability.description_short)) {
            if (-not $DryRun) {
                $ability.description_short = $data.Description.Short
            }
            $fieldsUpdated += "description_short"
            $needsUpdate = $true
        }
        
        if ([string]::IsNullOrWhiteSpace($ability.description_full)) {
            if (-not $DryRun) {
                $ability.description_full = $data.Description.Full
            }
            $fieldsUpdated += "description_full"
            $needsUpdate = $true
        }
        
        # ========================================
        # UPDATE WOW MECHANICS
        # ========================================
        if ([string]::IsNullOrWhiteSpace($ability.wow_mechanic_type)) {
            if (-not $DryRun) {
                $ability.wow_mechanic_type = $data.Fields.wow_mechanic_type
            }
            $fieldsUpdated += "wow_mechanic_type"
            $needsUpdate = $true
        }
        
        # ========================================
        # UPDATE BG3 MECHANICS
        # ========================================
        if ([string]::IsNullOrWhiteSpace($ability.bg3_mechanic_equivalent)) {
            if (-not $DryRun) {
                $ability.bg3_mechanic_equivalent = $data.Fields.bg3_mechanic_equivalent
            }
            $fieldsUpdated += "bg3_mechanic_equivalent"
            $needsUpdate = $true
        }
        
        # ========================================
        # UPDATE RESOURCE COSTS
        # ========================================
        if ([string]::IsNullOrWhiteSpace($ability.resource_cost_rage)) {
            if (-not $DryRun) {
                $ability.resource_cost_rage = $data.Fields.resource_cost_rage
            }
            $fieldsUpdated += "resource_cost_rage"
            $needsUpdate = $true
        }
        
        # ========================================
        # UPDATE DAMAGE FORMULAS
        # ========================================
        if ([string]::IsNullOrWhiteSpace($ability.damage_formula)) {
            if (-not $DryRun) {
                $ability.damage_formula = $data.Fields.damage_formula
            }
            $fieldsUpdated += "damage_formula"
            $needsUpdate = $true
        }
        
        # ========================================
        # UPDATE TARGET CONDITIONS
        # ========================================
        if ([string]::IsNullOrWhiteSpace($ability.bg3_target_conditions)) {
            if (-not $DryRun) {
                $ability.bg3_target_conditions = $data.Fields.bg3_target_conditions
            }
            $fieldsUpdated += "bg3_target_conditions"
            $needsUpdate = $true
        }
        
        # ========================================
        # UPDATE IMPLEMENTATION NOTES
        # ========================================
        if ([string]::IsNullOrWhiteSpace($ability.implementation_notes)) {
            if (-not $DryRun) {
                $ability.implementation_notes = $data.Fields.implementation_notes
            }
            $fieldsUpdated += "implementation_notes"
            $needsUpdate = $true
        }
        
        # Report updates
        if ($needsUpdate) {
            Write-Host "  [UPDATED] $name" -ForegroundColor Green
            Write-Host "    Fields: $($fieldsUpdated -join ', ')" -ForegroundColor Gray
            $UpdateCount++
            $FieldsPopulated += $fieldsUpdated.Count
            
            if ($DryRun) {
                Write-Host "    Sample: $($data.Description.Short)" -ForegroundColor DarkGray
            }
        }
    }
}

# Save if not dry run
if (-not $DryRun) {
    $Db | Export-Csv $DbPath -NoTypeInformation -Encoding UTF8
    Write-Host "`n[SAVED] Database updated: $DbPath" -ForegroundColor Green
}

# Final summary
Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host "ENHANCED SCRAPING SUMMARY" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Abilities Updated: $UpdateCount" -ForegroundColor $(if ($UpdateCount -gt 0) { 'Green' } else { 'Yellow' })
Write-Host "  Total Fields Populated: $FieldsPopulated" -ForegroundColor Green
if ($DryRun) {
    Write-Host "  Mode: DRY RUN (no changes saved)" -ForegroundColor Yellow
}

# Check remaining missing
$Remaining = $Db | Where-Object { 
    ([string]::IsNullOrWhiteSpace($_.description_short) -or [string]::IsNullOrWhiteSpace($_.description_full)) 
}
Write-Host "  Remaining Missing Descriptions: $($Remaining.Count)" -ForegroundColor $(if ($Remaining.Count -eq 0) { 'Green' } else { 'Yellow' })

# Calculate database completion for updated abilities
if ($UpdateCount -gt 0) {
    Write-Host "`n[FIELD COMPLETION IMPROVEMENT]:" -ForegroundColor Cyan
    Write-Host "  Average fields populated per ability: $([Math]::Round($FieldsPopulated / $UpdateCount, 1))" -ForegroundColor Green
}

Write-Host "`n========================================`n" -ForegroundColor Cyan
