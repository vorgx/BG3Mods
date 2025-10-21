# WoW Data Enrichment - Add rage costs, Wowhead URLs, archetype tags
# Date: October 20, 2025

param(
    [Parameter(Mandatory=$false)]
    [string]$InputFile = "Documentation\00_SourcesOfTruth\AbilityDatabase_Warrior.csv",
    [Parameter(Mandatory=$false)]
    [string]$OutputFile = "Documentation\00_SourcesOfTruth\AbilityDatabase_Warrior_Enriched.csv"
)

Write-Host "[INFO] Starting WoW data enrichment..." -ForegroundColor Cyan

# Import database
$db = Import-Csv $InputFile -Encoding UTF8
Write-Host "[INFO] Loaded $($db.Count) abilities" -ForegroundColor Cyan

# Define rage cost mappings (from SOURCE_OF_TRUTH.md)
$rageCosts = @{
    # L1-5 Core Abilities
    "Heroic Strike" = "30"
    "Mortal Strike" = "30"
    "Bloodthirst" = "20"
    "Execute" = "20"  # Variable 20-40, using base
    "Shield Slam" = "0"  # Generates rage instead
    "Revenge" = "30"
    "Whirlwind" = "0"  # Generates 10 rage
    "Charge" = "0"  # Generates 20 rage
    "Slam" = "20"
    
    # Additional spenders
    "Rampage" = "80"
    "Onslaught" = "30"
    "Raging Blow" = "0"  # Free attack
    "Overpower" = "0"  # Free attack
    "Thunder Clap" = "20"
    "Shockwave" = "20"
    "Devastate" = "0"  # Generates rage
    "Shield Block" = "0"  # Uses charges
    "Ignore Pain" = "40"
    
    # Cooldowns
    "Avatar" = "0"
    "Bladestorm" = "0"
    "Thunderous Roar" = "0"
    "Colossus Smash" = "0"
    "Recklessness" = "0"
    "Odyn's Fury" = "0"
}

# Define Wowhead spell IDs (common Warrior abilities)
$wowheadIDs = @{
    "Mortal Strike" = "12294"
    "Execute" = "5308"
    "Bloodthirst" = "23881"
    "Rampage" = "184367"
    "Raging Blow" = "85288"
    "Whirlwind" = "1680"
    "Charge" = "100"
    "Heroic Throw" = "57755"
    "Shield Slam" = "23922"
    "Revenge" = "6572"
    "Ignore Pain" = "190456"
    "Thunder Clap" = "6343"
    "Shockwave" = "46968"
    "Avatar" = "107574"
    "Bladestorm" = "227847"
    "Thunderous Roar" = "384318"
    "Colossus Smash" = "167105"
    "Recklessness" = "1719"
    "Berserker Rage" = "18499"
    "Overpower" = "7384"
    "Slam" = "1464"
    "Cleave" = "845"
    "Devastate" = "20243"
    "Shield Block" = "2565"
    "Last Stand" = "12975"
    "Shield Wall" = "871"
    "Rallying Cry" = "97462"
    "Spell Reflection" = "23920"
    "Die by the Sword" = "118038"
}

# Define archetype tags based on build relevance
$archetypeTags = @{
    "Execute" = "Execute,Burst"
    "Mortal Strike" = "Arms,Single-Target"
    "Bloodthirst" = "Fury,Healing"
    "Rampage" = "Fury,Burst"
    "Whirlwind" = "AoE,Cleave"
    "Shield Slam" = "Protection,Tank"
    "Revenge" = "Protection,AoE"
    "Thunder Clap" = "AoE,Slow"
    "Bladestorm" = "AoE,Cooldown"
    "Thunderous Roar" = "AoE,Bleed"
    "Avatar" = "Cooldown,Burst"
    "Colossus Smash" = "Arms,Debuff"
    "Recklessness" = "Fury,Cooldown"
    "Charge" = "Mobility,Rage-Generation"
    "Heroic Leap" = "Mobility,AoE"
    "Shield Wall" = "Protection,Defensive"
    "Last Stand" = "Protection,Defensive"
    "Die by the Sword" = "Arms,Defensive"
    "Enraged Regeneration" = "Fury,Defensive"
    "Rallying Cry" = "Defensive,Raid-Utility"
    "Battle Shout" = "Buff,Raid-Utility"
    "Ignore Pain" = "Protection,Absorb"
}

# Track statistics
$rageAdded = 0
$wowheadAdded = 0
$tagsAdded = 0

# Enrich each ability
foreach ($ability in $db) {
    $name = $ability.ability_name.Trim()
    
    # Add rage cost
    if ($rageCosts.ContainsKey($name)) {
        $ability.wow_cost_rage = $rageCosts[$name]
        $rageAdded++
        Write-Host "[RAGE] $name : $($rageCosts[$name]) rage" -ForegroundColor Green
    }
    
    # Add Wowhead URL
    if ($wowheadIDs.ContainsKey($name)) {
        $spellID = $wowheadIDs[$name]
        # Store in implementation_notes for now (can add wow_url_wowhead column later)
        if ([string]::IsNullOrWhiteSpace($ability.implementation_notes)) {
            $ability.implementation_notes = "Wowhead: https://www.wowhead.com/spell=$spellID"
        }
        else {
            $ability.implementation_notes += " | Wowhead: https://www.wowhead.com/spell=$spellID"
        }
        $wowheadAdded++
        Write-Host "[WOWHEAD] $name : spell/$spellID" -ForegroundColor Cyan
    }
    
    # Add archetype tags
    if ($archetypeTags.ContainsKey($name)) {
        $ability.archetype_tags = $archetypeTags[$name]
        $tagsAdded++
        Write-Host "[TAGS] $name : $($archetypeTags[$name])" -ForegroundColor Yellow
    }
}

Write-Host "" -ForegroundColor White
Write-Host "[DONE] WoW enrichment complete!" -ForegroundColor Green
Write-Host "[INFO] Rage costs added: $rageAdded abilities" -ForegroundColor Cyan
Write-Host "[INFO] Wowhead URLs added: $wowheadAdded abilities" -ForegroundColor Cyan
Write-Host "[INFO] Archetype tags added: $tagsAdded abilities" -ForegroundColor Cyan

# Export enriched database
$db | Export-Csv $OutputFile -NoTypeInformation -Encoding UTF8

Write-Host "" -ForegroundColor White
Write-Host "[INFO] Output: $OutputFile" -ForegroundColor Cyan
Write-Host "[INFO] Enriched database ready!" -ForegroundColor Green

# Show sample enriched abilities
Write-Host "" -ForegroundColor White
Write-Host "[INFO] Sample enriched abilities:" -ForegroundColor Cyan
$enriched = $db | Where-Object { -not [string]::IsNullOrWhiteSpace($_.wow_cost_rage) }
$enriched | Select-Object -First 5 | ForEach-Object {
    Write-Host "  - $($_.ability_name) ($($_.ability_abbreviation)): $($_.wow_cost_rage) rage, Tags: $($_.archetype_tags)" -ForegroundColor White
}
