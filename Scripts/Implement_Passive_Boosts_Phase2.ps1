# Implement_Passive_Boosts_Phase2.ps1
# Implements remaining 77 passives with functional boost formulas
# Uses pattern matching and WoW mechanics to generate appropriate BG3 Boosts

param(
    [string]$PassiveFilePath = "c:\Users\tenod\source\repos\BG3Mods\Data\Public\Warrior_Wow_78fe4967-4e62-5491-d981-dd781acca4d7\Stats\Generated\Data\Passive.txt"
)

Write-Host "`n=== Implementing Phase 2: Remaining 77 Passives ===" -ForegroundColor Cyan

# Load passive file
$passiveContent = Get-Content $PassiveFilePath -Raw

# Define all remaining passive implementations
$passiveBoosts = @{}

# Arms Talents
$passiveBoosts["WAR_Tactician"] = 'IF(HasStringInSpellRoll(''WAR_Overpower'')):Advantage(AttackRoll)'
$passiveBoosts["WAR_Fervor_of_Battle"] = 'IF(Attack()):ActionResource(Rage,2,0)'
$passiveBoosts["WAR_Dreadnaught"] = 'IF(HasStringInSpellRoll(''WAR_Overpower'')):ActionResource(Rage,5,0);ReduceSpellCooldown(WAR_Overpower,OncePerTurn)'
$passiveBoosts["WAR_Executioner_s_Precision"] = 'IF(HasStringInSpellRoll(''WAR_Execute'')):CriticalHitThreshold(-2,AttackRoll)'
$passiveBoosts["WAR_Impale"] = 'IF(CriticalHit(MeleeWeaponAttack)):DamageBonus(2d6)'
$passiveBoosts["WAR_Crushing_Force"] = 'IF(HasStringInSpellRoll(''WAR_Slam'')):ApplyStatus(WAR_STUNNED,25,1)'
$passiveBoosts["WAR_Valor_in_Victory"] = 'IF(Kill()):ApplyStatus(SELF,WAR_VALOR,100,4)'
$passiveBoosts["WAR_Battlelord"] = 'IF(HasStringInSpellRoll(''WAR_Overpower'')):UnlockSpell(WAR_Overpower_Extra)'
$passiveBoosts["WAR_Test_of_Might"] = 'IF(Attack()):ApplyStatus(WAR_TEST_OF_MIGHT,100,6)'
$passiveBoosts["WAR_Collateral_Damage"] = 'IF(HasStringInSpellRoll(''WAR_Whirlwind'')):ApplyStatus(NEARBY_ENEMIES,WAR_COLOSSUS_SMASH,100,3)'
$passiveBoosts["WAR_Strength_of_Arms"] = 'IF(HasStringInSpellRoll(''WAR_Overpower'')):DamageBonus(1d8)'
$passiveBoosts["WAR_Champion_s_Might"] = 'Ability(Strength,2);RollBonus(MeleeWeaponDamage,1d4)'
$passiveBoosts["WAR_Barbaric_Training"] = 'IF(Attack()):ActionResource(Rage,3,0)'
$passiveBoosts["WAR_Critical_Thinking"] = 'CriticalHitThreshold(-1,MeleeWeaponAttack);CriticalHitExtraDice(1d6,MeleeWeaponAttack)'
$passiveBoosts["WAR_Exhilarating_Blows"] = 'IF(CriticalHit()):RegainHP(1d8)'
$passiveBoosts["WAR_Blunt_Instruments"] = 'IF(IsWeaponType(Mace) or IsWeaponType(Maul)):DamageBonus(1d6)'
$passiveBoosts["WAR_Rend"] = 'UnlockSpell(WAR_Rend);IF(HasStringInSpellRoll(''WAR_Rend'')):ApplyStatus(BLEEDING,100,6)'
$passiveBoosts["WAR_Concussive_Blows"] = 'IF(Attack() and Random(30)):ApplyStatus(WAR_CONCUSSED,100,2)'
$passiveBoosts["WAR_Strategist"] = 'IF(HasStringInSpellRoll(''WAR_Colossus_Smash'')):ActionResource(Rage,10,0)'
$passiveBoosts["WAR_In_For_The_Kill"] = 'IF(HealthPercentage(context.Target) < 35):RollBonus(Attack,1d6)'
$passiveBoosts["WAR_Warpaint"] = 'IF(Attack()):ApplyStatus(SELF,WAR_WARPAINT,100,5)'

# Fury Talents
$passiveBoosts["WAR_Fresh_Meat"] = 'IF(Kill()):ActionResource(Rage,15,0)'
$passiveBoosts["WAR_War_Machine"] = 'IF(Kill()):ApplyStatus(WAR_WAR_MACHINE,100,2)'
$passiveBoosts["WAR_Meat_Cleaver"] = 'IF(HasStringInSpellRoll(''WAR_Whirlwind'')):DamageBonus(1d8)'
$passiveBoosts["WAR_Wrath_and_Fury"] = 'IF(ActionResource(Rage,50)):DamageBonus(2d6)'
$passiveBoosts["WAR_Improved_Raging_Blow"] = 'IF(HasStringInSpellRoll(''WAR_Raging_Blow'')):DamageBonus(1d8);ReduceSpellCooldown(WAR_Raging_Blow,OncePerTurn)'
$passiveBoosts["WAR_Dancing_Blades"] = 'IF(DualWielding()):Advantage(AttackRoll)'
$passiveBoosts["WAR_Dual_Wield_Specialization"] = 'IF(DualWielding()):DamageBonus(1d6)'
$passiveBoosts["WAR_Cruelty"] = 'IF(HasStringInSpellRoll(''WAR_Bloodthirst'')):CriticalHitThreshold(-2,AttackRoll)'
$passiveBoosts["WAR_Bloodcraze"] = 'IF(HasStringInSpellRoll(''WAR_Bloodthirst'')):RegainHP(1d8)'
$passiveBoosts["WAR_Cold_Steel_Hot_Blood"] = 'IF(DualWielding()):CriticalHitThreshold(-1,AttackRoll)'
$passiveBoosts["WAR_Frothing_Berserker"] = 'IF(ActionResource(Rage,85)):Advantage(AttackRoll);DamageBonus(1d8)'
$passiveBoosts["WAR_Swift_Strikes"] = 'IF(Attack()):ApplyStatus(SELF,HASTE,10,1)'
$passiveBoosts["WAR_Massacre"] = 'IF(HealthPercentage(context.Target) < 35):UnlockSpell(WAR_Execute)'
$passiveBoosts["WAR_Overwhelming_Rage"] = 'ActionResource(Rage,30,1);IF(ActionResource(Rage,100)):DamageBonus(2d8)'
$passiveBoosts["WAR_Raging_Armaments"] = 'IF(Attack() and ActionResource(Rage,30)):DealDamage(1d6,Magical)'
$passiveBoosts["WAR_Unhinged"] = 'IF(HasStatus(''WAR_ENRAGED'')):Advantage(AttackRoll);DamageBonus(1d10)'
$passiveBoosts["WAR_Depths_of_Insanity"] = 'IF(ActionResource(Rage,100)):Advantage(AttackRoll);CriticalHit(AttackRoll)'
$passiveBoosts["WAR_Bloodborne"] = 'IF(HasStringInSpellRoll(''WAR_Bloodthirst'')):ApplyStatus(SELF,WAR_BLOODBORNE,100,8)'
$passiveBoosts["WAR_Slaughtering_Strikes"] = 'IF(Attack()):ActionResource(Rage,1,0);DamageBonus(1d4)'
$passiveBoosts["WAR_Wild_Strikes"] = 'IF(Attack() and Random(10)):ApplyStatus(SELF,WAR_WILD_STRIKES,100,3)'
$passiveBoosts["WAR_Bloodletting"] = 'IF(HasStatus(''BLEEDING'',context.Target)):DamageBonus(1d8)'
$passiveBoosts["WAR_Anger_Management"] = 'IF(TurnBased()):ActionResource(Rage,5,0)'
$passiveBoosts["WAR_Best_Served_Cold"] = 'IF(TakeDamage()):ActionResource(Rage,10,0)'
$passiveBoosts["WAR_Tenderize"] = 'IF(CriticalHit()):ApplyStatus(WAR_TENDERIZED,100,4)'
$passiveBoosts["WAR_Storm_of_Steel"] = 'IF(DualWielding()):RollBonus(Attack,1d4)'
$passiveBoosts["WAR_Titan_s_Torment"] = 'IF(IsWeaponType(TwoHandedMelee)):DamageBonus(2d6)'
$passiveBoosts["WAR_Unbridled_Ferocity"] = 'IF(Attack() and ActionResource(Rage,60)):Advantage(AttackRoll)'
$passiveBoosts["WAR_Overwhelming_Blades"] = 'IF(DualWielding() and Attack()):ApplyStatus(NEARBY_ENEMIES,WAR_OVERWHELMED,100,2)'
$passiveBoosts["WAR_Violent_Outburst"] = 'IF(CriticalHit()):DealDamage(1d10,MainMeleeWeaponDamageType)'

# Protection Talents
$passiveBoosts["WAR_Shield_Specialization"] = 'IF(Equipped(OffHand,context.Source) and HasArmourType(Shield,context.Source)):AC(2)'
$passiveBoosts["WAR_Brace_For_Impact"] = 'IF(Equipped(OffHand,context.Source) and HasArmourType(Shield,context.Source)):ReduceDamage(SELF,Flat,1d6)'
$passiveBoosts["WAR_Tough_As_Nails"] = 'IncreaseMaxHP(Level);AC(1)'
$passiveBoosts["WAR_Bolster"] = 'IF(HasStatus(''WAR_LAST_STAND'')):IncreaseMaxHP(Level*3)'
$passiveBoosts["WAR_Heavy_Handed"] = 'IF(Equipped(OffHand,context.Source) and HasArmourType(Shield,context.Source)):DamageBonus(1d6)'
$passiveBoosts["WAR_Impenetrable_Wall"] = 'AC(5);ReduceDamage(SELF,Percentage,30);Resistance(Force,Resistant)'
$passiveBoosts["WAR_Punish"] = 'IF(HasStringInSpellRoll(''WAR_Shield_Slam'')):ApplyStatus(WAR_PUNISHED,100,4)'
$passiveBoosts["WAR_Indomitable"] = 'IF(HealthPercentage(context.Source) < 40):AC(3);ReduceDamage(SELF,Percentage,20)'
$passiveBoosts["WAR_Focused_Vigor"] = 'IF(Equipped(OffHand,context.Source) and HasArmourType(Shield,context.Source)):Advantage(ConcentrationSavingThrow)'
$passiveBoosts["WAR_Battle_Scarred_Veteran"] = 'AC(2);Resistance(All,Bludgeoning;Piercing;Slashing,Resistant)'
$passiveBoosts["WAR_Defender_s_Aegis"] = 'IF(Equipped(OffHand,context.Source) and HasArmourType(Shield,context.Source)):ReduceDamage(NEARBY_ALLIES,Flat,1d4)'
$passiveBoosts["WAR_Reinforced_Plates"] = 'IF(HasArmourType(HeavyArmour,context.Source)):AC(2);ReduceDamage(SELF,Flat,3)'
$passiveBoosts["WAR_Unyielding_Stance"] = 'IF(HealthPercentage(context.Source) > 50):AC(2)'
$passiveBoosts["WAR_No_Stranger_to_Pain"] = 'IF(TakeDamage()):ActionResource(Rage,5,0)'
$passiveBoosts["WAR_Bitter_Immunity"] = 'StatusImmunity(SG_Poisoned);StatusImmunity(SG_Diseased)'
$passiveBoosts["WAR_Booming_Voice"] = 'IF(HasStringInSpellRoll(''WAR_Taunt'')):ApplyStatus(NEARBY_ENEMIES,WAR_TAUNTED,100,2)'
$passiveBoosts["WAR_Instigate"] = 'IF(HasStringInSpellRoll(''WAR_Revenge'')):ActionResource(Rage,10,0)'
$passiveBoosts["WAR_Unrelenting_Onslaught"] = 'IF(Attack()):ApplyStatus(WAR_UNRELENTING,100,4)'
$passiveBoosts["WAR_Storm_of_Swords"] = 'IF(HasStringInSpellRoll(''WAR_Thunder_Clap'')):DamageBonus(1d8)'
$passiveBoosts["WAR_Opportunist"] = 'IF(AttackTarget(Prone) or AttackTarget(Stunned)):Advantage(AttackRoll);DamageBonus(1d8)'
$passiveBoosts["WAR_Relentless_Pursuit"] = 'IF(HasStringInSpellRoll(''WAR_Charge'')):UnlockSpell(WAR_Charge);ReduceSpellCooldown(WAR_Charge,OncePerTurn)'

# Hero Talents (Additional)
$passiveBoosts["WAR_Storm_Wall"] = 'ReduceDamage(SELF,Flat,1d10);IF(AttackTarget()):DealDamage(1d6,Lightning,Magical)'
$passiveBoosts["WAR_Ground_Current"] = 'IF(DealDamage(Lightning)):ApplyStatus(NEARBY_ENEMIES,WAR_GROUND_CURRENT,100,2)'
$passiveBoosts["WAR_Lightning_Strikes"] = 'IF(Attack() and Random(30)):DealDamage(1d6,Lightning)'
$passiveBoosts["WAR_Thunderlord"] = 'IF(DealDamage(Lightning)):DealDamage(1d8,Lightning)'
$passiveBoosts["WAR_Seismic_Reverberation"] = 'IF(HasStringInSpellRoll(''WAR_Thunder_Clap'')):ApplyStatus(NEARBY_ENEMIES,WAR_SEISMIC,100,3)'
$passiveBoosts["WAR_Rumbling_Earth"] = 'IF(HasStringInSpellRoll(''WAR_Shockwave'')):DamageBonus(2d6,Force)'
$passiveBoosts["WAR_Vicious_Contempt"] = 'IF(HealthPercentage(context.Target) < 50):Advantage(AttackRoll)'

# Additional commonly named talents
$passiveBoosts["WAR_Sudden_Death"] = 'IF(Attack() and Random(20)):UnlockSpell(WAR_Execute)'
$passiveBoosts["WAR_Pain_and_Gain"] = 'IF(DealDamage()):RegainHP(1d4)'
$passiveBoosts["WAR_Grant_Extra_Attack"] = 'ExtraAttack()'

Write-Host "Defined $($passiveBoosts.Count) passive implementations" -ForegroundColor Cyan

# Apply replacements
$replacementCount = 0
$notFoundCount = 0

foreach ($passiveName in $passiveBoosts.Keys) {
    if ($passiveContent -match "new entry `"$passiveName`"[\s\S]*?data `"Boosts`" `"Placeholder\(\);`"") {
        Write-Host "[REPLACE] $passiveName" -ForegroundColor Green
        
        # Replace Placeholder with actual boost
        $passiveContent = $passiveContent -replace "(\bnew entry `"$passiveName`"[\s\S]*?data `"Boosts`" `")Placeholder\(\);", "`$1$($passiveBoosts[$passiveName])`""
        $replacementCount++
    } else {
        $notFoundCount++
        Write-Host "[SKIP] $passiveName (not found or already implemented)" -ForegroundColor DarkGray
    }
}

# Write updated content
Set-Content $PassiveFilePath -Value $passiveContent -Encoding UTF8 -NoNewline

Write-Host "`n=== PHASE 2 PASSIVE IMPLEMENTATION COMPLETE ===" -ForegroundColor Green
Write-Host "Replaced: $replacementCount" -ForegroundColor Cyan
Write-Host "Not Found/Already Done: $notFoundCount" -ForegroundColor Gray

# Final verification
$verifyContent = Get-Content $PassiveFilePath -Raw
$remainingPlaceholders = ($verifyContent | Select-String -Pattern 'Placeholder\(\)' -AllMatches).Matches.Count
$totalPassives = ($verifyContent | Select-String -Pattern 'new entry "WAR_' -AllMatches).Matches.Count

Write-Host "`n=== FINAL STATUS ===" -ForegroundColor Cyan
Write-Host "Total Passives: $totalPassives" -ForegroundColor Gray
Write-Host "Remaining Placeholders: $remainingPlaceholders" -ForegroundColor $(if ($remainingPlaceholders -eq 0) { 'Green' } else { 'Yellow' })
Write-Host "Fully Implemented: $($totalPassives - $remainingPlaceholders)" -ForegroundColor Green

if ($remainingPlaceholders -eq 0) {
    Write-Host "`n✅ ALL PASSIVES FULLY IMPLEMENTED!" -ForegroundColor Green
} else {
    Write-Host "`n⚠️ $remainingPlaceholders passives still need implementation" -ForegroundColor Yellow
    Write-Host "Run again or add missing implementations to the script" -ForegroundColor Gray
}
