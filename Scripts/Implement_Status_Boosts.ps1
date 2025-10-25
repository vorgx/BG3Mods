# Implement_Status_Boosts.ps1
# Replaces Placeholder() boosts in Status_BOOST.txt with actual BG3 mechanics
# Based on WoW ability mechanics and BG3 Boosts system

param(
    [string]$StatusFilePath = "c:\Users\tenod\source\repos\BG3Mods\Data\Public\Warrior_Wow_78fe4967-4e62-5491-d981-dd781acca4d7\Stats\Generated\Data\Status_BOOST.txt"
)

Write-Host "`n=== Implementing Status_BOOST.txt ===" -ForegroundColor Cyan
Write-Host "File: $StatusFilePath" -ForegroundColor Gray

# Define all 25 status boost implementations based on WoW mechanics
$statusBoosts = @{
    # Phase 1: Simple Buffs (Combat Enhancement)
    "WAR_BATTLE_SHOUT" = @{
        Boosts = 'AC(2);RollBonus(Attack,1d4)'
        Description = "Party-wide buff: +2 AC, +1d4 attack rolls (WoW: ~5% damage increase)"
    }
    
    "WAR_RECKLESSNESS" = @{
        Boosts = 'Advantage(AttackRoll);CriticalHit(AttackRoll)'
        Description = "Advantage on attacks, critical hits more likely (WoW: +20% crit chance)"
    }
    
    "WAR_BERSERKER_SHOUT" = @{
        Boosts = 'RemoveStatus(FRIGHTENED);RemoveStatus(CHARMED);ActionResource(Rage,10,0)'
        Description = "Remove fear/charm, grant 10 Rage (WoW: Fear breaker)"
    }
    
    "WAR_DEFENSIVE_STANCE" = @{
        Boosts = 'AC(3);Resistance(Slashing,Resistant);Resistance(Piercing,Resistant);Resistance(Bludgeoning,Resistant)'
        Description = "Tank stance: +3 AC, resistant to physical damage (WoW: +20% damage reduction)"
    }
    
    "WAR_BATTLE_STANCE" = @{
        Boosts = 'RollBonus(MeleeWeaponAttack,1d6);RollBonus(MeleeWeaponDamage,1d4)'
        Description = "Offensive stance: +1d6 to hit, +1d4 damage (WoW: +10% damage)"
    }
    
    # Phase 2: Simple Debuffs (Enemy Penalties)
    "WAR_HAMSTRING" = @{
        Boosts = 'Disadvantage(SavingThrow,Dexterity);StatusImmunity(SG_Dash);AC(-1)'
        Description = "Movement impaired: Dex save disadvantage, cannot Dash, -1 AC (WoW: 50% slow)"
    }
    
    "WAR_TAUNTED" = @{
        Boosts = 'Disadvantage(AttackRoll);IF(not(Tagged(''TAUNTED_SOURCE'',context.Source))):Disadvantage(AttackRoll)'
        Description = "Forced to attack taunter with disadvantage (WoW: Forced target + threat)"
    }
    
    "WAR_DEMORALIZING_SHOUT" = @{
        Boosts = 'RollBonus(Attack,-1d4);RollBonus(Damage,-1d4)'
        Description = "Enemy damage output reduced: -1d4 attack, -1d4 damage (WoW: -20% damage dealt)"
    }
    
    "WAR_DISRUPTING_SHOUT" = @{
        Boosts = 'Disadvantage(SavingThrow,Concentration);RollBonus(SpellAttack,-2)'
        Description = "Spellcasting disrupted: Concentration disadvantage, -2 spell attacks (WoW: Interrupt)"
    }
    
    # Phase 3: Armor Debuffs (Armor Reduction)
    "WAR_COLOSSUS_SMASH" = @{
        Boosts = 'AC(-5);Resistance(Slashing,Vulnerable);Resistance(Piercing,Vulnerable);Resistance(Bludgeoning,Vulnerable)'
        Description = "Major armor break: -5 AC, vulnerable to physical damage (WoW: -30% armor)"
    }
    
    "WAR_WARBREAKER" = @{
        Boosts = 'AC(-3);Resistance(Slashing,Vulnerable);Resistance(Piercing,Vulnerable);Resistance(Bludgeoning,Vulnerable)'
        Description = "AoE armor break: -3 AC, vulnerable to physical damage (WoW: -20% armor, AoE)"
    }
    
    # Phase 4: Crowd Control (Hard CC)
    "WAR_PUMMEL" = @{
        Boosts = 'Silenced();Incapacitated()'
        Description = "Interrupt and silence: Cannot cast spells or take actions (WoW: 4s interrupt + 6s silence)"
    }
    
    "WAR_SHOCKWAVE" = @{
        Boosts = 'ApplyStatus(PRONE,100,1)'
        Description = "Knockdown: Target falls prone for 1 turn (WoW: 4s stun, AoE)"
    }
    
    "WAR_INTIMIDATING_SHOUT" = @{
        Boosts = 'ApplyStatus(FRIGHTENED,100,2)'
        Description = "Fear effect: Target is frightened for 2 turns (WoW: 8s fear, AoE)"
    }
    
    # Phase 5: Defensive Buffs (Mitigation)
    "WAR_DIE_BY_THE_SWORD" = @{
        Boosts = 'AC(10);Dodge();IF(AttackTarget()):DealDamage(1d6+StrengthModifier,MainMeleeWeaponDamageType,Magical)'
        Description = "Parry stance: Massive AC boost, dodge, riposte on attack (WoW: Parry all attacks)"
    }
    
    "WAR_SHIELD_BLOCK" = @{
        Boosts = 'ReduceDamage(SELF,Flat,2d6+ConstitutionModifier)'
        Description = "Block damage: Reduce incoming by 2d6+Con (WoW: Block 30% damage)"
    }
    
    "WAR_SHIELD_WALL" = @{
        Boosts = 'ReduceDamage(SELF,Percentage,40);AC(2)'
        Description = "Defensive cooldown: 40% damage reduction, +2 AC (WoW: 40% DR)"
    }
    
    "WAR_IGNORE_PAIN" = @{
        Boosts = 'TemporaryHP(Level*2+ConstitutionModifier)'
        Description = "Damage absorption: Gain temp HP equal to level*2+Con (WoW: Absorb 50% max HP)"
    }
    
    "WAR_SPELL_REFLECTION" = @{
        Boosts = 'Resistance(Force,Immune);Resistance(Lightning,Immune);Resistance(Fire,Immune);Resistance(Cold,Immune);Resistance(Acid,Immune)'
        Description = "Magic immunity: Immune to all spell damage types (WoW: Reflect spells)"
    }
    
    "WAR_IMPENETRABLE_WALL" = @{
        Boosts = 'AC(5);ReduceDamage(SELF,Percentage,30);Resistance(Force,Resistant)'
        Description = "Tanking capstone: +5 AC, 30% DR, resistant to Force (WoW: Protection mastery)"
    }
    
    "WAR_ENRAGED_REGENERATION" = @{
        Boosts = 'IF(TurnBased()):RegainHP(Level+ConstitutionModifier*2)'
        Description = "Healing over time: Regain HP each turn (WoW: 20% HP over 5s)"
    }
    
    # Phase 6: Complex Procs (Hero Talents - Mountain Thane)
    "WAR_STORM_BOLT" = @{
        Boosts = 'IF(TurnBased()):DealDamage(2d6,Lightning,Magical)'
        Description = "Lightning proc: 2d6 lightning damage each turn (Mountain Thane keystone)"
    }
    
    "WAR_STORM_BOLTS" = @{
        Boosts = 'IF(TurnBased()):DealDamage(1d8,Lightning,Magical);IF(TurnBased()):DealDamage(1d8,Lightning,Magical);IF(TurnBased()):DealDamage(1d8,Lightning,Magical)'
        Description = "Multi-lightning proc: 3x 1d8 lightning damage to nearby enemies (Mountain Thane AoE)"
    }
    
    "WAR_STORM_WALL" = @{
        Boosts = 'ReduceDamage(SELF,Flat,1d10);IF(AttackTarget()):DealDamage(1d6,Lightning,Magical)'
        Description = "Lightning shield: Block 1d10 damage, riposte with 1d6 lightning (Mountain Thane defensive)"
    }
    
    # Phase 7: Ultimate Transformation
    "WAR_AVATAR" = @{
        Boosts = 'Advantage(AttackRoll);AC(3);StatusImmunity(SG_Frightened);StatusImmunity(SG_Charmed);RollBonus(Damage,1d8);Size(Increase)'
        Description = "Ultimate form: Advantage attacks, +3 AC, immune fear/charm, +1d8 damage, larger size (WoW: All cooldowns reset, massive buffs)"
    }
}

# Read current file
$content = Get-Content $StatusFilePath -Raw

# Track replacements
$replacementCount = 0

# Replace each status boost
foreach ($statusName in $statusBoosts.Keys) {
    $boostInfo = $statusBoosts[$statusName]
    $oldPattern = "new entry `"$statusName`"[\s\S]*?data `"Boosts`" `"Placeholder\(\);`""
    $newBoosts = "data `"Boosts`" `"$($boostInfo.Boosts)`""
    
    if ($content -match $oldPattern) {
        Write-Host "[REPLACE] $statusName" -ForegroundColor Green
        Write-Host "  Formula: $($boostInfo.Boosts)" -ForegroundColor Gray
        Write-Host "  Note: $($boostInfo.Description)" -ForegroundColor DarkGray
        
        # Replace the Placeholder line with actual boosts
        $content = $content -replace "(\bnew entry `"$statusName`"[\s\S]*?data `"Boosts`" `")Placeholder\(\);", "`$1$($boostInfo.Boosts)`""
        $replacementCount++
    } else {
        Write-Host "[SKIP] $statusName (not found or already implemented)" -ForegroundColor Yellow
    }
}

# Write updated content
Set-Content $StatusFilePath -Value $content -Encoding UTF8 -NoNewline

Write-Host "`n=== STATUS BOOST IMPLEMENTATION COMPLETE ===" -ForegroundColor Green
Write-Host "Total Replacements: $replacementCount / $($statusBoosts.Count)" -ForegroundColor Cyan
Write-Host "File Updated: $StatusFilePath" -ForegroundColor Gray
Write-Host "`nNext Step: Test in-game to verify status effects work correctly" -ForegroundColor Yellow
