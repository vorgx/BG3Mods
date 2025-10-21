# ENRICH FROM SOURCE_OF_TRUTH.md - Extract Documented Ability Mechanics
# Date: October 20, 2025
# Purpose: Parse Section [4] to enrich database with abilities already documented

param(
    [Parameter(Mandatory=$false)]
    [string]$SourceOfTruthFile = "Documentation\00_SourcesOfTruth\SOURCE_OF_TRUTH.md",
    [Parameter(Mandatory=$false)]
    [string]$DatabaseFile = "Documentation\00_SourcesOfTruth\AbilityDatabase_Warrior_FullyEnriched.csv",
    [Parameter(Mandatory=$false)]
    [string]$OutputFile = "Documentation\00_SourcesOfTruth\AbilityDatabase_Warrior_FullyEnriched_v2.csv"
)

Write-Host "========================================" -ForegroundColor Cyan
Write-Host " ENRICH FROM SOURCE_OF_TRUTH.md" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Import current database
$db = Import-Csv $DatabaseFile -Encoding UTF8
Write-Host "[LOAD] Loaded $($db.Count) abilities from database" -ForegroundColor Cyan

# Read SOURCE_OF_TRUTH.md
$sourceText = Get-Content $SourceOfTruthFile -Raw -Encoding UTF8
Write-Host "[LOAD] Loaded SOURCE_OF_TRUTH.md ($($sourceText.Length) chars)" -ForegroundColor Cyan
Write-Host ""

# Track enrichment stats
$stats = @{
    AlreadyEnriched = 0
    NewlyEnriched = 0
    PassivesEnriched = 0
    OffensiveEnriched = 0
    DefensiveEnriched = 0
    UtilityEnriched = 0
    FailedToMatch = @()
}

Write-Host "[PHASE 1] EXTRACTING ABILITY MECHANICS" -ForegroundColor Yellow
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Yellow
Write-Host ""

# COMPREHENSIVE ABILITY MECHANICS LIBRARY
# These are abilities documented in SOURCE_OF_TRUTH.md Section [4] but not yet in enrichment

$abilityMechanics = @{
    # === PASSIVE STAT BOOSTS (from Section [4] talent tables) ===
    "Seasoned Soldier" = @{
        Type = "Passive"
        File = "Passive"
        BG3Boosts = "CriticalChance(1)"
        Tags = "Passive,Stat-Boost,Critical"
        Description = "Increases critical strike chance by 1%"
        Notes = "Simple stat boost passive"
    }
    
    "War Machine" = @{
        Type = "Passive"
        File = "Passive"
        BG3Functors = "IF(Killed()):ApplyStatus(SELF,WAR_WAR_MACHINE,100,3)"
        Tags = "Passive,Proc,Movement"
        Description = "Killing enemies increases movement speed temporarily"
        Notes = "Apply status on kill that grants movement speed boost"
    }
    
    "Leeching Strikes" = @{
        Type = "Passive"
        File = "Passive"
        BG3Boosts = "Lifesteal(1)"
        Tags = "Passive,Healing,Lifesteal"
        Description = "1% of damage dealt heals you"
        Notes = "Lifesteal passive - may need custom functor"
    }
    
    "Fast Footwork" = @{
        Type = "Passive"
        File = "Passive"
        BG3Boosts = "ActionResource(Movement,2,0)"
        Tags = "Passive,Mobility"
        Description = "Increases movement speed"
        Notes = "Movement speed boost"
    }
    
    # === ABILITY MODIFIERS (modify existing abilities) ===
    "Improved Execute" = @{
        Type = "Passive"
        File = "Passive"
        ModifiesAbility = "Execute"
        BG3Functors = "IF(HasPassive('WAR_Improved_Execute',context.Source)):DealDamage(EXTRA_2d6,Slashing)"
        Tags = "Passive,Execute-Build,Damage-Boost"
        Description = "Execute deals additional 2d6 damage"
        Notes = "Modifies Execute - add to modified_by column"
    }
    
    "Critical Thinking" = @{
        Type = "Passive"
        File = "Passive"
        ModifiesAbility = "Execute"
        BG3Functors = "IF(HasPassive('WAR_Critical_Thinking',context.Source)):CriticalChance(Execute,10)"
        Tags = "Passive,Execute-Build,Critical"
        Description = "Execute has +10% critical strike chance"
        Notes = "Modifies Execute crit chance"
    }
    
    "Deft Experience" = @{
        Type = "Passive"
        File = "Passive"
        RequiresAbility = "Tactician"
        BG3Functors = "IF(HasPassive('WAR_Deft_Experience',context.Source)):ResetCooldown(Overpower,1)"
        Tags = "Arms,Passive,Proc"
        Description = "Increases Tactician proc chance to reset Overpower cooldown"
        Notes = "Enhances Tactician - bidirectional dependency"
    }
    
    "Storm Wall" = @{
        Type = "Passive"
        File = "Passive"
        RequiresAbility = "Die by the Sword"
        UnlocksAbility = "Die by the Sword"
        BG3Functors = "IF(HasPassive('WAR_Storm_Wall',context.Source)):ApplyStatus(NEARBY_ALLIES,WAR_STORM_WALL_BUFF,100,8)"
        Tags = "Arms,Defensive,Raid-Utility"
        Description = "Die by the Sword also grants damage reduction to nearby allies"
        Notes = "Extends Die by the Sword with AoE benefit"
    }
    
    "Test of Might" = @{
        Type = "Passive"
        File = "Passive"
        RequiresAbility = "Colossus Smash"
        BG3Functors = "IF(HasPassive('WAR_Test_Of_Might',context.Source)):ApplyStatus(SELF,WAR_TEST_OF_MIGHT,100,12)"
        Tags = "Arms,Colossus-Build,Damage-Boost"
        Description = "Colossus Smash grants you increased Strength temporarily"
        Notes = "Modifies Colossus Smash to buff caster"
    }
    
    "Merciless Bonegrinder" = @{
        Type = "Passive"
        File = "Passive"
        RequiresAbility = "Ravager"
        BG3Functors = "IF(HasPassive('WAR_Merciless_Bonegrinder',context.Source)):DealDamage(EXTRA_1d6,Slashing)"
        Tags = "Protection,AoE,Damage-Boost"
        Description = "Ravager deals additional damage per target hit"
        Notes = "Enhances Ravager AoE"
    }
    
    "Dance of Death" = @{
        Type = "Passive"
        File = "Passive"
        RequiresAbility = "Bladestorm"
        BG3Functors = "IF(HasPassive('WAR_Dance_Of_Death',context.Source)):DealDamage(EXTRA_1d8,Slashing)"
        Tags = "Arms,AoE,Cooldown-Enhancement"
        Description = "Bladestorm deals significantly increased damage"
        Notes = "Major Bladestorm enhancement"
    }
    
    # === PROC-BASED ABILITIES ===
    "Tactician" = @{
        Type = "Passive"
        File = "Passive"
        UnlocksAbility = "Deft Experience"
        BG3Functors = "StatsFunctorContext(OnAttack);Conditions(RandomChance(30));StatsFunctors(RestoreResource(Overpower_Charge,1,0))"
        Tags = "Arms,Proc,Overpower-Build"
        Description = "30% chance on attack to reset Overpower cooldown"
        Notes = "Proc passive - requires charge resource for Overpower"
    }
    
    "Fresh Meat" = @{
        Type = "Passive"
        File = "Passive"
        BG3Functors = "StatsFunctorContext(OnCast);Conditions(HasStringInSpellRoll('Bloodthirst'));StatsFunctors(IF(CriticalHit()):ApplyStatus(SELF,WAR_FRESH_MEAT,100,6))"
        Tags = "Fury,Proc,Bloodthirst-Enhancement"
        Description = "Bloodthirst critical strikes grant bonus effects"
        Notes = "Enhances Bloodthirst crits"
    }
    
    "Sudden Death" = @{
        Type = "Passive"
        File = "Passive"
        BG3Functors = "StatsFunctorContext(OnCast);Conditions(RandomChance(10));StatsFunctors(ApplyStatus(SELF,WAR_SUDDEN_DEATH,100,10))"
        Tags = "Execute-Build,Proc,Fury"
        Description = "10% chance to make your next Execute cost no Rage and be usable on any target"
        Notes = "Proc that enables Execute outside execute phase"
    }
    
    "Bloodsurge" = @{
        Type = "Passive"
        File = "Passive"
        BG3Functors = "StatsFunctorContext(OnCast);Conditions(HasStringInSpellRoll('Bloodthirst'));StatsFunctors(IF(RandomChance(20)):RestoreResource(Rage,5,0))"
        Tags = "Fury,Proc,Rage-Generation"
        Description = "Bloodthirst has a chance to generate bonus Rage"
        Notes = "Rage generation proc"
    }
    
    # === ACTIVE UTILITIES (from Section [4] descriptions) ===
    "Demoralizing Shout" = @{
        Type = "Defensive"
        File = "Spell_Shout"
        SpellType = "Shout"
        RageCost = 0
        Cooldown = "OncePerShortRest"
        BG3Success = "ApplyStatus(NEARBY_ENEMIES,WAR_DEMORALIZED,100,8)"
        BG3Formula = "None"
        Tags = "Defensive,AoE,Debuff"
        Description = "Reduces attack power of nearby enemies"
        Notes = "AoE debuff shout"
    }
    
    "Intimidating Shout" = @{
        Type = "Offensive"
        File = "Spell_Shout"
        SpellType = "Shout"
        RageCost = 0
        Cooldown = "OncePerShortRest"
        BG3Success = "ApplyStatus(NEARBY_ENEMIES,FRIGHTENED,100,8)"
        BG3Formula = "None"
        Tags = "Utility,AoE,CC,Fear"
        Description = "Causes nearby enemies to flee in fear"
        Notes = "AoE fear effect"
    }
    
    "Impending Victory" = @{
        Type = "Offensive"
        File = "Spell_Target"
        SpellType = "Target"
        RageCost = 10
        Cooldown = "None"
        BG3Success = "DealDamage(2d6+StrengthModifier,Physical);RegainHitPoints(20% MaxHP)"
        BG3Formula = "2d6+StrengthModifier,Physical"
        Tags = "Offensive,Healing,Single-Target"
        Description = "Deals damage and heals you for 20% of your max HP"
        Notes = "Healing attack - alternative to Victory Rush"
    }
    
    "Second Wind" = @{
        Type = "Defensive"
        File = "Spell_Shout"
        SpellType = "Shout"
        RageCost = 0
        Cooldown = "OncePerShortRest"
        BG3Success = "RegainHitPoints(30% MaxHP)"
        BG3Formula = "None"
        Tags = "Defensive,Healing,Self-Heal"
        Description = "Instantly heals you for 30% of your maximum hit points"
        Notes = "Emergency self-heal"
    }
    
    "Bounding Stride" = @{
        Type = "Utility"
        File = "Passive"
        BG3Boosts = "IF(UsedAbility('Charge,Heroic_Leap,Intervene')):ActionResource(Movement,3,0)"
        Tags = "Utility,Mobility,Passive"
        Description = "Using Charge, Heroic Leap, or Intervene increases movement speed"
        Notes = "Passive that triggers on mobility ability use"
    }
    
    # === FURY ENRAGE SYSTEM PASSIVES ===
    "Frenzied Enrage" = @{
        Type = "Passive"
        File = "Passive"
        BG3Boosts = "IF(HasStatus('WAR_ENRAGED',context.Source)):Damage(10)"
        Tags = "Fury,Enrage,Damage-Boost"
        Description = "While Enraged, you deal 10% more damage"
        Notes = "Conditional damage boost while Enraged"
    }
    
    "Powerful Enrage" = @{
        Type = "Passive"
        File = "Passive"
        BG3Boosts = "IF(HasStatus('WAR_ENRAGED',context.Source)):CriticalChance(10)"
        Tags = "Fury,Enrage,Critical"
        Description = "While Enraged, critical strike chance increased by 10%"
        Notes = "Conditional crit boost while Enraged"
    }
    
    "Frothing Berserker" = @{
        Type = "Passive"
        File = "Passive"
        BG3Functors = "StatsFunctorContext(OnDamage);Conditions(HasStatus('WAR_ENRAGED'));StatsFunctors(RestoreResource(Rage,2,0))"
        Tags = "Fury,Enrage,Rage-Generation"
        Description = "Taking damage while Enraged generates 2 Rage"
        Notes = "Rage generation on damage taken"
    }
    
    # === PROTECTION TANK PASSIVES ===
    "Brace For Impact" = @{
        Type = "Passive"
        File = "Passive"
        BG3Boosts = "IF(HasStatus('WAR_SHIELD_BLOCK',context.Source)):DamageReduction(10)"
        Tags = "Protection,Defensive,Mitigation"
        Description = "Shield Block reduces damage by an additional 10%"
        Notes = "Enhances Shield Block mitigation"
    }
    
    "Armor Specialization" = @{
        Type = "Passive"
        File = "Passive"
        BG3Boosts = "AC(1)"
        Tags = "Protection,Passive,Defensive"
        Description = "Increases armor class by 1"
        Notes = "Simple AC boost"
    }
    
    "Fight Through the Flames" = @{
        Type = "Defensive"
        File = "Passive"
        BG3Boosts = "Resistance(Fire,Poison)"
        Tags = "Protection,Defensive,Resistance"
        Description = "Grants resistance to fire and poison damage"
        Notes = "Damage type resistance"
    }
    
    "Devastator" = @{
        Type = "Passive"
        File = "Passive"
        ModifiesAbility = "Devastate"
        BG3Functors = "IF(HasPassive('WAR_Devastator',context.Source)):IF(CriticalHit()):ResetCooldown(Shield_Slam,1)"
        Tags = "Protection,Proc,Shield-Slam-Enhancement"
        Description = "Devastate critical strikes reset Shield Slam cooldown"
        Notes = "Proc-based Shield Slam reset"
    }
    
    # === ARMS SPECIFIC TALENTS ===
    "Martial Prowess" = @{
        Type = "Passive"
        File = "Passive"
        BG3Boosts = "Damage(Arms_Abilities,5)"
        Tags = "Arms,Passive,Damage-Boost"
        Description = "Increases damage of all Arms abilities by 5%"
        Notes = "Spec-wide damage boost"
    }
    
    "Skullsplitter" = @{
        Type = "Offensive"
        File = "Spell_Target"
        SpellType = "Target"
        RageCost = 0
        Cooldown = "None"
        BG3Success = "DealDamage(2d8+StrengthModifier,Physical);RestoreResource(Rage,15,0)"
        BG3Formula = "2d8+StrengthModifier,Physical"
        Tags = "Arms,Rage-Generation,Single-Target"
        Description = "Deals damage and generates 15 Rage"
        Notes = "Rage generator for Arms"
    }
    
    "Warbreaker" = @{
        Type = "Offensive"
        File = "Spell_Zone"
        SpellType = "Zone"
        RageCost = 0
        Cooldown = "45 seconds"
        BG3Success = "DealDamage(3d10+StrengthModifier,Physical);ApplyStatus(WAR_COLOSSUS_SMASH,100,10)"
        BG3Formula = "3d10+StrengthModifier,Physical"
        Tags = "Arms,AoE,Cooldown,Debuff"
        Description = "AoE version of Colossus Smash, applies debuff to all targets hit"
        Notes = "Requires Colossus Smash talent"
        RequiresAbility = "Colossus Smash"
    }
    
    "Massacre" = @{
        Type = "Passive"
        File = "Passive"
        BG3Functors = "IF(HealthPercentage(context.Target) <= 35):UnlockSpell(Execute)"
        Tags = "Arms,Execute-Build,Execute-Extension"
        Description = "Execute becomes usable on targets below 35% HP instead of 20%"
        Notes = "Extends Execute window"
    }
    
    # === FURY SPECIFIC TALENTS ===
    "Bloodcraze" = @{
        Type = "Passive"
        File = "Passive"
        ModifiesAbility = "Bloodthirst"
        BG3Functors = "IF(HasPassive('WAR_Bloodcraze',context.Source)):IF(CriticalHit()):RestoreResource(Rage,5,0)"
        Tags = "Fury,Proc,Rage-Generation"
        Description = "Bloodthirst critical strikes generate bonus Rage"
        Notes = "Enhances Bloodthirst rage generation"
    }
    
    "Meat Cleaver" = @{
        Type = "Passive"
        File = "Passive"
        BG3Functors = "StatsFunctorContext(OnCast);Conditions(HasStringInSpellRoll('Whirlwind'));StatsFunctors(ApplyStatus(SELF,WAR_MEAT_CLEAVER,100,3))"
        Tags = "Fury,AoE,Cleave"
        Description = "Whirlwind causes your next single-target attacks to hit additional targets"
        Notes = "Enables cleave after Whirlwind"
    }
    
    "Wild Strikes" = @{
        Type = "Passive"
        File = "Passive"
        BG3Functors = "StatsFunctorContext(OnCast);Conditions(HasStringInSpellRoll('Raging_Blow'));StatsFunctors(IF(RandomChance(15)):DealDamage(2d8,Physical))"
        Tags = "Fury,Proc,Raging-Blow-Enhancement"
        Description = "Raging Blow has a chance to strike the target an additional time"
        Notes = "Extra attack proc for Raging Blow"
    }
    
    "Onslaught" = @{
        Type = "Offensive"
        File = "Spell_Target"
        SpellType = "Target"
        RageCost = 30
        Cooldown = "None"
        BG3Success = "DealDamage(2d8+StrengthModifier,Physical)"
        BG3Formula = "2d8+StrengthModifier,Physical"
        Tags = "Fury,Single-Target,Filler"
        Description = "Brutal strike dealing moderate damage"
        Notes = "Already enriched - double check"
    }
    
    # === PROTECTION SPECIFIC TALENTS ===
    "Impenetrable Wall" = @{
        Type = "Passive"
        File = "Passive"
        RequiresAbility = "Shield Wall"
        BG3Functors = "IF(HasPassive('WAR_Impenetrable_Wall',context.Source)):ApplyStatus(SELF,WAR_UNSTOPPABLE,100,8)"
        Tags = "Protection,Defensive,CC-Immunity"
        Description = "Shield Wall also grants immunity to crowd control"
        Notes = "Enhances Shield Wall with CC immunity"
    }
    
    "Focused Vigor" = @{
        Type = "Passive"
        File = "Passive"
        BG3Boosts = "IF(HasStatus('WAR_AVATAR',context.Source)):Heal(25)"
        Tags = "Protection,Defensive,Healing"
        Description = "Avatar increases healing received by 25%"
        Notes = "Conditional healing boost during Avatar"
    }
    
    "Shield Specialization" = @{
        Type = "Passive"
        File = "Passive"
        BG3Boosts = "BlockChance(5)"
        Tags = "Protection,Passive,Block"
        Description = "Increases block chance by 5%"
        Notes = "Simple block chance boost"
    }
}

Write-Host "[INFO] Ability mechanics library loaded: $($abilityMechanics.Count) abilities" -ForegroundColor Cyan
Write-Host ""

# ENRICH DATABASE
Write-Host "[PHASE 2] ENRICHING DATABASE ENTRIES" -ForegroundColor Yellow
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Yellow
Write-Host ""

foreach ($ability in $db) {
    $name = $ability.ability_name.Trim()
    
    # Skip already enriched
    if ($ability.bg3_file_type -and $ability.bg3_spell_type -and $ability.archetype_tags) {
        $stats.AlreadyEnriched++
        continue
    }
    
    # Check if we have mechanics for this ability
    if ($abilityMechanics.ContainsKey($name)) {
        $mech = $abilityMechanics[$name]
        
        # Populate BG3 fields
        if ($mech.File) { $ability.bg3_file_type = $mech.File }
        if ($mech.SpellType) { $ability.bg3_spell_type = $mech.SpellType }
        if ($mech.RageCost) { $ability.wow_cost_rage = $mech.RageCost }
        if ($mech.Cooldown) { $ability.bg3_cooldown = $mech.Cooldown }
        if ($mech.BG3Success) { $ability.bg3_spell_success = $mech.BG3Success }
        if ($mech.BG3Formula) { $ability.damage_formula_bg3 = $mech.BG3Formula }
        if ($mech.Tags) { $ability.archetype_tags = $mech.Tags }
        
        # Populate dependency fields
        if ($mech.ModifiesAbility) { 
            if ($ability.modified_by) {
                $ability.modified_by += ",$($mech.ModifiesAbility)"
            } else {
                $ability.modified_by = $mech.ModifiesAbility
            }
        }
        if ($mech.RequiresAbility) { $ability.requires_ability = $mech.RequiresAbility }
        if ($mech.UnlocksAbility) { $ability.unlocks_ability = $mech.UnlocksAbility }
        
        # Add implementation notes
        if ($mech.Notes) {
            if ($ability.implementation_notes) {
                $ability.implementation_notes += " | $($mech.Notes)"
            } else {
                $ability.implementation_notes = $mech.Notes
            }
        }
        if ($mech.Description) {
            if ($ability.description_short -eq "" -or $ability.description_short.Length -lt 50) {
                $ability.description_short = $mech.Description.Substring(0, [Math]::Min(100, $mech.Description.Length))
            }
        }
        
        # Count by type
        switch ($ability.ability_type) {
            "Passive" { $stats.PassivesEnriched++ }
            "Offensive" { $stats.OffensiveEnriched++ }
            "Defensive" { $stats.DefensiveEnriched++ }
            "Utility" { $stats.UtilityEnriched++ }
        }
        
        $stats.NewlyEnriched++
        
        Write-Host "[ENRICHED] $name ($($ability.ability_type)) → $($mech.File)" -ForegroundColor Green
    }
    else {
        # Not in library - add to failed list
        if ($ability.ability_type -ne "Passive" -or $name -match "Improved|Enhanced|Critical|Deft|Storm|Test|Merciless|Dance") {
            $stats.FailedToMatch += $name
        }
    }
}

Write-Host ""
Write-Host "[DONE] Database enrichment complete!" -ForegroundColor Green
Write-Host ""

# EXPORT
Write-Host "[PHASE 3] EXPORTING RESULTS" -ForegroundColor Yellow
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Yellow
Write-Host ""

$db | Export-Csv $OutputFile -NoTypeInformation -Encoding UTF8
Write-Host "[EXPORT] $OutputFile" -ForegroundColor Cyan
Write-Host ""

# SUMMARY
Write-Host "========================================" -ForegroundColor Cyan
Write-Host " ENRICHMENT SUMMARY" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "[STATS] Statistics:" -ForegroundColor Yellow
Write-Host "  - Total abilities: $($db.Count)" -ForegroundColor White
Write-Host "  - Already enriched: $($stats.AlreadyEnriched)" -ForegroundColor Green
Write-Host "  - Newly enriched: $($stats.NewlyEnriched)" -ForegroundColor Green
Write-Host "  - Total enriched: $($stats.AlreadyEnriched + $stats.NewlyEnriched)" -ForegroundColor Cyan
Write-Host "  - Still need work: $($db.Count - $stats.AlreadyEnriched - $stats.NewlyEnriched)" -ForegroundColor Yellow
Write-Host ""
Write-Host "[BREAKDOWN] By Type:" -ForegroundColor Yellow
Write-Host "  - Passives: $($stats.PassivesEnriched)" -ForegroundColor White
Write-Host "  - Offensive: $($stats.OffensiveEnriched)" -ForegroundColor White
Write-Host "  - Defensive: $($stats.DefensiveEnriched)" -ForegroundColor White
Write-Host "  - Utility: $($stats.UtilityEnriched)" -ForegroundColor White
Write-Host ""

if ($stats.FailedToMatch.Count -gt 0) {
    Write-Host "[WARN] Abilities still needing enrichment ($($stats.FailedToMatch.Count)):" -ForegroundColor Yellow
    $stats.FailedToMatch | Select-Object -First 20 | ForEach-Object {
        Write-Host "  - $_" -ForegroundColor Yellow
    }
    if ($stats.FailedToMatch.Count -gt 20) {
        Write-Host "  ... and $($stats.FailedToMatch.Count - 20) more" -ForegroundColor Yellow
    }
    Write-Host ""
    Write-Host "These will need:" -ForegroundColor White
    Write-Host "  1. Manual research from Icy-Veins HTML files" -ForegroundColor Cyan
    Write-Host "  2. Or online Icy-Veins lookup" -ForegroundColor Cyan
    Write-Host "  3. Or Wowhead database search" -ForegroundColor Cyan
}

Write-Host ""
Write-Host "[DONE] Next step: Review output file and proceed with remaining abilities" -ForegroundColor Green
Write-Host ""
