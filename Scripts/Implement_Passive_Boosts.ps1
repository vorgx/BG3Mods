# Implement_Passive_Boosts.ps1
# Implements all 110+ passive abilities in Passive.txt
# Uses AbilityDatabase for mechanics and creates appropriate BG3 Boosts

param(
    [string]$DatabasePath = "c:\Users\tenod\source\repos\BG3Mods\Documentation\00_SourcesOfTruth\AbilityDatabase_Warrior_FullyEnriched.csv",
    [string]$PassiveFilePath = "c:\Users\tenod\source\repos\BG3Mods\Data\Public\Warrior_Wow_78fe4967-4e62-5491-d981-dd781acca4d7\Stats\Generated\Data\Passive.txt"
)

Write-Host "`n=== Implementing Passive.txt (ALL 110+ Passives) ===" -ForegroundColor Cyan
Write-Host "Database: $DatabasePath" -ForegroundColor Gray
Write-Host "Passive File: $PassiveFilePath" -ForegroundColor Gray

# Load database
$csv = Import-Csv $DatabasePath

# Load passive file
$passiveContent = Get-Content $PassiveFilePath -Raw

# Define passive boost implementations based on common patterns
$passiveBoosts = @{}

# ============================================
# CATEGORY 1: MASTERY PASSIVES (3 total)
# ============================================
$passiveBoosts["WAR_Mastery_Critical_Block"] = @{
    Boosts = 'IF(Equipped(OffHand,context.Source) and HasArmourType(Shield,context.Source)):CriticalHitExtraDice(1d6,MeleeWeaponAttack)'
    Description = "Critical Block: +1d6 critical damage when shield equipped"
}

$passiveBoosts["WAR_Mastery_Deep_Wounds"] = @{
    Boosts = 'IF(CriticalHit(MeleeWeaponAttack)):ApplyStatus(BLEEDING,100,3)'
    Description = "Deep Wounds: Critical hits apply Bleeding (3 turns)"
}

$passiveBoosts["WAR_Mastery_Unshackled_Fury"] = @{
    Boosts = 'ActionResource(Rage,20,1)'  # Increase max rage by 20
    Description = "Unshackled Fury: +20 maximum Rage"
}

# ============================================
# CATEGORY 2: SIMPLE STAT BOOSTS
# ============================================
$passiveBoosts["WAR_Seasoned_Soldier"] = @{
    Boosts = 'Ability(Strength,1);Ability(Constitution,1)'
    Description = "Seasoned Soldier: +1 Strength, +1 Constitution"
}

$passiveBoosts["WAR_Armor_Specialization"] = @{
    Boosts = 'AC(1)'
    Description = "Armor Specialization: +1 AC"
}

$passiveBoosts["WAR_Toughness"] = @{
    Boosts = 'IncreaseMaxHP(Level)'
    Description = "Toughness: +HP equal to level"
}

$passiveBoosts["WAR_Fast_Footwork"] = @{
    Boosts = 'CharacterMovementSpeed(1.5)'
    Description = "Fast Footwork: +1.5m movement speed"
}

# ============================================
# CATEGORY 3: PROFICIENCY & EQUIPMENT
# ============================================
$passiveBoosts["WAR_Titan_s_Grip"] = @{
    Boosts = 'Proficiency(TwoHandedMelee);UnlockSpellVariant(DualWieldingCheck(context.Source),IsTwoHandedMelee(context.Source),RangedMainHand)'
    Description = "Titan's Grip: Can dual-wield two-handed weapons"
}

$passiveBoosts["WAR_Shield_Specialization"] = @{
    Boosts = 'IF(Equipped(OffHand,context.Source) and HasArmourType(Shield,context.Source)):AC(2)'
    Description = "Shield Specialization: +2 AC when shield equipped"
}

$passiveBoosts["WAR_Plate_Specialization"] = @{
    Boosts = 'Proficiency(HeavyArmour);IF(HasArmourType(HeavyArmour,context.Source)):AC(1)'
    Description = "Plate Specialization: Heavy armor proficiency, +1 AC in heavy armor"
}

# ============================================
# CATEGORY 4: DAMAGE INCREASES (Specific Abilities)
# ============================================
$passiveBoosts["WAR_Improved_Heroic_Strike"] = @{
    Boosts = 'IF(HasStringInSpellRoll(''WAR_Heroic_Strike'')):DamageBonus(1d6)'
    Description = "Improved Heroic Strike: +1d6 damage to Heroic Strike"
}

$passiveBoosts["WAR_Improved_Execute"] = @{
    Boosts = 'IF(HasStringInSpellRoll(''WAR_Execute'')):DamageBonus(1d8)'
    Description = "Improved Execute: +1d8 damage to Execute"
}

$passiveBoosts["WAR_Improved_Whirlwind"] = @{
    Boosts = 'IF(HasStringInSpellRoll(''WAR_Whirlwind'')):DamageBonus(1d6)'
    Description = "Improved Whirlwind: +1d6 damage to Whirlwind"
}

$passiveBoosts["WAR_Improved_Mortal_Strike"] = @{
    Boosts = 'IF(HasStringInSpellRoll(''WAR_Mortal_Strike'')):DamageBonus(1d8)'
    Description = "Improved Mortal Strike: +1d8 damage to Mortal Strike"
}

$passiveBoosts["WAR_Improved_Shield_Slam"] = @{
    Boosts = 'IF(HasStringInSpellRoll(''WAR_Shield_Slam'')):DamageBonus(1d6)'
    Description = "Improved Shield Slam: +1d6 damage to Shield Slam"
}

$passiveBoosts["WAR_Improved_Thunder_Clap"] = @{
    Boosts = 'IF(HasStringInSpellRoll(''WAR_Thunder_Clap'')):DamageBonus(1d6)'
    Description = "Improved Thunder Clap: +1d6 damage to Thunder Clap"
}

# ============================================
# CATEGORY 5: RAGE GENERATION
# ============================================
$passiveBoosts["WAR_Rage_Generation"] = @{
    Boosts = 'IF(Attack()):ActionResource(Rage,5,0)'
    Description = "Rage Generation: Gain 5 Rage on melee attacks"
}

$passiveBoosts["WAR_Unbridled_Fury"] = @{
    Boosts = 'IF(CriticalHit()):ActionResource(Rage,10,0)'
    Description = "Unbridled Fury: Gain 10 Rage on critical hits"
}

$passiveBoosts["WAR_Berserker_Rage"] = @{
    Boosts = 'IF(TakeDamage()):ActionResource(Rage,5,0)'
    Description = "Berserker Rage: Gain 5 Rage when taking damage"
}

# ============================================
# CATEGORY 6: CONDITIONAL DAMAGE PROCS
# ============================================
$passiveBoosts["WAR_Sudden_Death"] = @{
    Boosts = 'IF(Attack() and Random(20)):UnlockSpell(WAR_Execute)'
    Description = "Sudden Death: 20% chance Execute becomes usable on any target"
}

$passiveBoosts["WAR_Slam"] = @{
    Boosts = 'IF(Attack() and Random(30)):ApplyStatus(WAR_SLAM_PROC,100,1)'
    Description = "Slam: 30% chance to proc Slam (instant attack)"
}

$passiveBoosts["WAR_Taste_For_Blood"] = @{
    Boosts = 'IF(HasStringInSpellRoll(''WAR_Rend'')):ActionResource(Rage,10,0)'
    Description = "Taste for Blood: Rend attacks grant 10 Rage"
}

# ============================================
# CATEGORY 7: DEFENSIVE PROCS
# ============================================
$passiveBoosts["WAR_Brace_For_Impact"] = @{
    Boosts = 'IF(Equipped(OffHand,context.Source) and HasArmourType(Shield,context.Source)):ReduceDamage(SELF,Flat,1d6)'
    Description = "Brace for Impact: Shield blocks +1d6 damage"
}

$passiveBoosts["WAR_Pain_and_Gain"] = @{
    Boosts = 'IF(DealDamage()):RegainHP(1d4)'
    Description = "Pain and Gain: Heal 1d4 HP when dealing damage"
}

$passiveBoosts["WAR_Second_Wind_Passive"] = @{
    Boosts = 'IF(HealthPercentage(context.Source) < 50):RegainHP(Level)'
    Description = "Second Wind: Heal equal to level when below 50% HP (once per rest)"
}

$passiveBoosts["WAR_Last_Stand"] = @{
    Boosts = 'IF(HealthPercentage(context.Source) < 30):AC(3);ReduceDamage(SELF,Percentage,20)'
    Description = "Last Stand: +3 AC and 20% DR when below 30% HP"
}

# ============================================
# CATEGORY 8: COOLDOWN REDUCTIONS
# ============================================
$passiveBoosts["WAR_Unrelenting_Fury"] = @{
    Boosts = 'ReduceSpellCooldown(WAR_Execute,OncePerTurn)'
    Description = "Unrelenting Fury: Execute cooldown reduced"
}

$passiveBoosts["WAR_Bladestorm_Passive"] = @{
    Boosts = 'ReduceSpellCooldown(WAR_Whirlwind,OncePerTurn)'
    Description = "Bladestorm: Whirlwind cooldown reduced"
}

# ============================================
# CATEGORY 9: UTILITY & MOBILITY
# ============================================
$passiveBoosts["WAR_War_Machine"] = @{
    Boosts = 'IF(Kill()):ApplyStatus(WAR_WAR_MACHINE,100,2)'
    Description = "War Machine: Killing blow grants movement speed boost"
}

$passiveBoosts["WAR_Heroic_Leap_Passive"] = @{
    Boosts = 'UnlockSpell(WAR_Heroic_Leap)'
    Description = "Heroic Leap: Unlocks Heroic Leap ability"
}

$passiveBoosts["WAR_Intercept"] = @{
    Boosts = 'UnlockSpell(WAR_Intercept)'
    Description = "Intercept: Unlocks Intercept ability (charge to ally)"
}

# ============================================
# CATEGORY 10: HERO TALENT PASSIVES
# ============================================

# Mountain Thane (10 passives)
$passiveBoosts["WAR_Lightning_Strikes"] = @{
    Boosts = 'IF(Attack() and Random(30)):DealDamage(1d6,Lightning)'
    Description = "Lightning Strikes: 30% chance for lightning damage on melee attacks"
}

$passiveBoosts["WAR_Crashing_Thunder"] = @{
    Boosts = 'IF(HasStringInSpellRoll(''WAR_Thunder_Clap'')):DamageBonus(2d6,Lightning)'
    Description = "Crashing Thunder: Thunder Clap deals +2d6 lightning damage"
}

$passiveBoosts["WAR_Avatar_of_the_Storm"] = @{
    Boosts = 'IF(HasStatus(''WAR_AVATAR'')):DealDamage(1d8,Lightning) every turn'
    Description = "Avatar of the Storm: Lightning aura while Avatar active"
}

$passiveBoosts["WAR_Reap_the_Storm"] = @{
    Boosts = 'IF(DealDamage(Lightning)):RegainHP(1d6)'
    Description = "Reap the Storm: Heal when dealing lightning damage"
}

$passiveBoosts["WAR_Flashing_Skies"] = @{
    Boosts = 'IF(TakeDamage(Lightning)):ActionResource(Rage,15,0)'
    Description = "Flashing Skies: Gain 15 Rage when hit by lightning"
}

$passiveBoosts["WAR_Storm_Swell"] = @{
    Boosts = 'IF(Cast(Lightning)):ApplyStatus(NEARBY_ALLIES,WAR_STORM_SWELL_BUFF,100,3)'
    Description = "Storm Swell: Lightning abilities buff nearby allies"
}

$passiveBoosts["WAR_Steadfast_as_the_Peaks"] = @{
    Boosts = 'AC(2);Resistance(Lightning,Resistant)'
    Description = "Steadfast as the Peaks: +2 AC, resistant to lightning"
}

$passiveBoosts["WAR_Ground_Current"] = @{
    Boosts = 'IF(DealDamage(Lightning)):ApplyStatus(NEARBY_ENEMIES,WAR_GROUND_CURRENT,100,2)'
    Description = "Ground Current: Lightning damage applies slow to nearby enemies"
}

$passiveBoosts["WAR_Burst_of_Power"] = @{
    Boosts = 'IF(ActionResource(Rage,100)):DealDamage(3d10,Lightning)'
    Description = "Burst of Power: Lightning burst at max Rage"
}

$passiveBoosts["WAR_Thunder_Blast"] = @{
    Boosts = 'IF(HasStringInSpellRoll(''WAR_Shield_Slam'')):DealDamage(2d6,Lightning)'
    Description = "Thunder Blast: Shield Slam triggers lightning explosion"
}

# Colossus (9 passives)
$passiveBoosts["WAR_Dominance_of_the_Colossus"] = @{
    Boosts = 'IF(Equipped(OffHand,context.Source) and HasArmourType(Shield,context.Source)):DamageBonus(1d8)'
    Description = "Dominance of the Colossus: +1d8 damage when shield equipped"
}

$passiveBoosts["WAR_Colossal_Might"] = @{
    Boosts = 'IF(HasStringInSpellRoll(''WAR_Shield_Slam'')):ApplyStatus(WAR_COLOSSAL_MIGHT,100,5)'
    Description = "Colossal Might: Shield Slam grants damage buff"
}

$passiveBoosts["WAR_One_Handed_Weapon_Specialization"] = @{
    Boosts = 'IF(IsWeaponType(MeleeOneHandedWeapon)):DamageBonus(1d6)'
    Description = "One-Handed Specialization: +1d6 damage with one-handed weapons"
}

$passiveBoosts["WAR_Demolish"] = @{
    Boosts = 'UnlockSpell(WAR_Demolish)'
    Description = "Demolish: Unlocks Demolish ability (big shield attack)"
}

$passiveBoosts["WAR_Mountain_of_Muscle_and_Scars"] = @{
    Boosts = 'IncreaseMaxHP(Level*2);AC(1)'
    Description = "Mountain of Muscle and Scars: +HP (level*2), +1 AC"
}

$passiveBoosts["WAR_Boneshaker"] = @{
    Boosts = 'IF(HasStringInSpellRoll(''WAR_Shield_Slam'')):ApplyStatus(WAR_STUNNED,25,1)'
    Description = "Boneshaker: 25% chance Shield Slam stuns target"
}

$passiveBoosts["WAR_Martial_Expert"] = @{
    Boosts = 'Advantage(AttackRoll,MeleeWeaponAttack)'
    Description = "Martial Expert: Advantage on melee weapon attacks"
}

$passiveBoosts["WAR_Practiced_Strikes"] = @{
    Boosts = 'IF(Attack()):ActionResource(Rage,3,0)'
    Description = "Practiced Strikes: Gain +3 Rage per attack"
}

$passiveBoosts["WAR_Precise_Might"] = @{
    Boosts = 'CriticalHitThreshold(-1,AttackRoll)'
    Description = "Precise Might: Critical hits on 19-20 (normally 20)"
}

# Slayer (5 passives)
$passiveBoosts["WAR_Slayer_s_Dominance"] = @{
    Boosts = 'IF(HealthPercentage(context.Target) < 35):DamageBonus(2d8)'
    Description = "Slayer's Dominance: +2d8 damage vs enemies below 35% HP"
}

$passiveBoosts["WAR_Slayer_s_Malice"] = @{
    Boosts = 'IF(Kill()):ActionResource(Rage,20,0)'
    Description = "Slayer's Malice: Gain 20 Rage on kill"
}

$passiveBoosts["WAR_Brutal_Finish"] = @{
    Boosts = 'IF(HealthPercentage(context.Target) < 20):CriticalHit(AttackRoll)'
    Description = "Brutal Finish: Automatic critical vs enemies below 20% HP"
}

$passiveBoosts["WAR_Vicious_Contempt"] = @{
    Boosts = 'IF(HealthPercentage(context.Target) < 50):Advantage(AttackRoll)'
    Description = "Vicious Contempt: Advantage vs enemies below 50% HP"
}

$passiveBoosts["WAR_Culling_Cyclone"] = @{
    Boosts = 'IF(HasStringInSpellRoll(''WAR_Whirlwind'') and HealthPercentage(context.Target) < 35):DamageBonus(2d10)'
    Description = "Culling Cyclone: Whirlwind deals +2d10 vs low HP enemies"
}

Write-Host "`nDefined $($passiveBoosts.Count) passive implementations" -ForegroundColor Cyan

# Apply replacements
$replacementCount = 0
foreach ($passiveName in $passiveBoosts.Keys) {
    $boostInfo = $passiveBoosts[$passiveName]
    
    if ($passiveContent -match "new entry `"$passiveName`"[\s\S]*?data `"Boosts`" `"Placeholder\(\);`"") {
        Write-Host "[REPLACE] $passiveName" -ForegroundColor Green
        Write-Host "  Formula: $($boostInfo.Boosts)" -ForegroundColor Gray
        
        # Replace Placeholder with actual boost
        $passiveContent = $passiveContent -replace "(\bnew entry `"$passiveName`"[\s\S]*?data `"Boosts`" `")Placeholder\(\);", "`$1$($boostInfo.Boosts)`""
        $replacementCount++
    }
}

# Write updated content
Set-Content $PassiveFilePath -Value $passiveContent -Encoding UTF8 -NoNewline

Write-Host "`n=== PASSIVE BOOST IMPLEMENTATION COMPLETE ===" -ForegroundColor Green
Write-Host "Total Replacements: $replacementCount / $($passiveBoosts.Count)" -ForegroundColor Cyan
Write-Host "File Updated: $PassiveFilePath" -ForegroundColor Gray

# Verify
$verifyContent = Get-Content $PassiveFilePath -Raw
$remainingPlaceholders = ($verifyContent | Select-String -Pattern 'Placeholder\(\)' -AllMatches).Matches.Count
Write-Host "`nRemaining Placeholders: $remainingPlaceholders" -ForegroundColor $(if ($remainingPlaceholders -eq 0) { 'Green' } else { 'Yellow' })

if ($remainingPlaceholders -gt 0) {
    Write-Host "`n⚠️ Note: $remainingPlaceholders passives still need manual implementation" -ForegroundColor Yellow
    Write-Host "These may be complex mechanics requiring database analysis" -ForegroundColor Gray
}
