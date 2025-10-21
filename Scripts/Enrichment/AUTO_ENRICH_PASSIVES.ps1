# AUTO-ENRICH PASSIVES - Pattern-based enrichment for simple stat boosts
# Date: October 20, 2025
# Purpose: Automatically enrich passives with recognizable patterns

param(
    [Parameter(Mandatory=$false)]
    [string]$DatabaseFile = "Documentation\00_SourcesOfTruth\AbilityDatabase_Warrior_FullyEnriched.csv",
    [Parameter(Mandatory=$false)]
    [string]$OutputFile = "Documentation\00_SourcesOfTruth\AbilityDatabase_Warrior_FullyEnriched.csv"
)

Write-Host "[START] Auto-enriching passive abilities with pattern matching..." -ForegroundColor Cyan
Write-Host ""

# Load database
$db = Import-Csv $DatabaseFile -Encoding UTF8
$enrichedCount = 0

# Pattern-based enrichment rules
foreach ($ability in $db) {
    # Skip already enriched
    if ($ability.bg3_file_type -and $ability.archetype_tags) { continue }
    # Skip non-passives
    if ($ability.ability_type -ne "Passive") { continue }
    
    $name = $ability.ability_name
    $desc = $ability.description_short.ToLower()
    
    $enriched = $false
    
    # PATTERN 1: Mastery scaling (special stat)
    if ($name -match "Mastery:") {
        $ability.bg3_file_type = "Passive"
        $ability.archetype_tags = "Passive,Mastery,Stat-Scaling"
        $ability.implementation_notes = "Mastery stat - BG3 equivalent could be bonus damage scaling. Needs custom implementation."
        $enriched = $true
    }
    
    # PATTERN 2: Healing on damage ("Pain and Gain", "Fueled by Violence")
    elseif ($desc -match "healing|heal" -and $desc -match "damage") {
        $ability.bg3_file_type = "Passive"
        $ability.archetype_tags = "Passive,Healing,Lifesteal"
        $ability.bg3_boosts = "IF(DealDamage()):RegainHitPoints(Percentage)"
        $ability.implementation_notes = "Lifesteal passive - heal based on damage dealt"
        $enriched = $true
    }
    
    # PATTERN 3: Improved [Ability] - damage increase
    elseif ($name -match "Improved (.+)" -and $desc -match "damage increase") {
        $targetAbility = $Matches[1]
        $ability.bg3_file_type = "Passive"
        $ability.modified_by = $targetAbility
        $ability.archetype_tags = "Passive,$targetAbility-Enhancement,Damage-Boost"
        $ability.bg3_functors = "IF(HasPassive('WAR_$($name -replace ' ','_')',context.Source)):DealDamage(EXTRA_PERCENTAGE,DamageType)"
        $ability.implementation_notes = "Enhances $targetAbility with bonus damage"
        $enriched = $true
    }
    
    # PATTERN 4: Damage reduction passive ("Warpaint")
    elseif ($desc -match "damage reduction" -or $desc -match "reduce.*damage") {
        $ability.bg3_file_type = "Passive"
        $ability.archetype_tags = "Passive,Defensive,Mitigation"
        $ability.bg3_boosts = "DamageReduction(Percentage)"
        $ability.implementation_notes = "Passive damage mitigation"
        $enriched = $true
    }
    
    # PATTERN 5: Critical damage increase ("Impale", "Cruelty")
    elseif ($desc -match "critical.*damage" -or $desc -match "crit.*damage") {
        $ability.bg3_file_type = "Passive"
        $ability.archetype_tags = "Passive,Critical,Damage-Boost"
        $ability.bg3_boosts = "CriticalDamage(Percentage)"
        $ability.implementation_notes = "Increases critical strike damage"
        $enriched = $true
    }
    
    # PATTERN 6: While Enraged bonus ("Cruelty")
    elseif ($desc -match "while enraged" -or $desc -match "enrage") {
        $ability.bg3_file_type = "Passive"
        $ability.archetype_tags = "Passive,Enrage,Conditional-Boost"
        $ability.bg3_boosts = "IF(HasStatus('WAR_ENRAGED',context.Source)):Boost(...)"
        $ability.implementation_notes = "Conditional bonus while Enraged status active"
        $enriched = $true
    }
    
    # PATTERN 7: Leech/Lifesteal ("Brutal Vitality")
    elseif ($desc -match "leech") {
        $ability.bg3_file_type = "Passive"
        $ability.archetype_tags = "Passive,Healing,Leech"
        $ability.bg3_boosts = "Lifesteal(Percentage)"
        $ability.implementation_notes = "Leech - percentage of damage heals you"
        $enriched = $true
    }
    
    # PATTERN 8: Ability enhancement with mechanics change ("Crushing Force", "Rumbling Earth")
    elseif ($desc -match "greatly increases" -or $desc -match "major.*increase") {
        $ability.bg3_file_type = "Passive"
        $ability.archetype_tags = "Passive,Enhancement,Major-Boost"
        $ability.implementation_notes = "Major enhancement passive - research specific mechanics needed"
        $enriched = $true
    }
    
    # PATTERN 9: Rage generation increase ("Finishing Blows", "Heavy Repercussions")
    elseif ($desc -match "rage generation" -or $desc -match "generates.*rage") {
        $ability.bg3_file_type = "Passive"
        $ability.archetype_tags = "Passive,Rage-Generation"
        $ability.bg3_functors = "IF(Condition()):RestoreResource(Rage,Amount,0)"
        $ability.implementation_notes = "Increases Rage generation under specific conditions"
        $enriched = $true
    }
    
    # PATTERN 10: Cooldown reduction ("Anger Management", "Bolster")
    elseif ($desc -match "cooldown|cd" -and $desc -match "reduce") {
        $ability.bg3_file_type = "Passive"
        $ability.archetype_tags = "Passive,Cooldown-Reduction"
        $ability.implementation_notes = "Reduces cooldowns - BG3 implementation may need custom functor"
        $enriched = $true
    }
    
    # PATTERN 11: Haste buff ("Frenzy")
    elseif ($desc -match "haste") {
        $ability.bg3_file_type = "Passive"
        $ability.archetype_tags = "Passive,Haste,Attack-Speed"
        $ability.bg3_boosts = "ActionResource(BonusAction,1,0)"
        $ability.implementation_notes = "Haste passive - BG3 equivalent could be bonus action or extra attack"
        $enriched = $true
    }
    
    # PATTERN 12: DoT application ("Rend")
    elseif ($name -eq "Rend" -or $desc -match "bleed|dot|damage over time") {
        $ability.bg3_file_type = "Passive"
        $ability.archetype_tags = "Passive,DoT,Bleed"
        $ability.bg3_functors = "StatsFunctorContext(OnCast);StatsFunctors(ApplyStatus(BLEEDING,100,Duration))"
        $ability.implementation_notes = "Applies damage over time effect"
        $enriched = $true
    }
    
    if ($enriched) {
        $enrichedCount++
        Write-Host "[ENRICHED] $name" -ForegroundColor Green
    }
}

# Export
$db | Export-Csv $OutputFile -NoTypeInformation -Encoding UTF8
Write-Host ""
Write-Host "[COMPLETE] Auto-enriched $enrichedCount passive abilities" -ForegroundColor Green
Write-Host "[SAVED] $OutputFile" -ForegroundColor Cyan
Write-Host ""
