<#
.SYNOPSIS
    Scrapes ability descriptions from Icy-Veins and updates the database
.DESCRIPTION
    Fetches ability descriptions from Icy-Veins Warrior guides for Mountain Thane, 
    Colossus, and Slayer hero talents, then updates the database with descriptions.
#>

param(
    [string]$DbPath = "c:\Users\tenod\source\repos\BG3Mods\Documentation\00_SourcesOfTruth\AbilityDatabase_Warrior_FullyEnriched.csv",
    [switch]$DryRun
)

Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host "WOW DESCRIPTION SCRAPER" -ForegroundColor Cyan
Write-Host "========================================`n" -ForegroundColor Cyan

# Load database
$Db = Import-Csv $DbPath -Encoding UTF8
$UpdateCount = 0

# Manual descriptions from Icy-Veins scraping (Hero Talents)
$HeroTalentDescriptions = @{
    # Mountain Thane (From Fury guide)
    'Lightning Strikes' = @{
        Short = 'Random lightning damage proc from rotational abilities.'
        Full = 'Random single target damage proc from most rotational abilities. The increased chance is multiplicative (25 * 1.3 = 32.5% chance), rather than additive.'
    }
    'Thunder Blast' = @{
        Short = 'Stronger version of Thunder Clap that ignores armor.'
        Full = 'Enables Thunder Blast, a stronger version of Thunder Clap that ignores armor. Granted by Avatar casts.'
    }
    'Avatar of the Storm' = @{
        Short = 'Grants Thunder Blast charges when casting Avatar.'
        Full = 'Thunder Blast charges are only granted by natural casts of Avatar, not including procs from Berserker or Titan''s Torment.'
    }
    'Storm Bolts' = @{
        Short = 'Splits stun effect across multiple targets.'
        Full = 'A mostly PvP talent, as being unable to dictate which two extra targets can contribute to diminishing returns.'
    }
    'Keep Your Feet on the Ground' = @{
        Short = 'Strong defensive bonus from Thunder Blast procs.'
        Full = 'Very strong passive defensive bonus due to the high frequency of Thunder Blast procs.'
    }
    'Flashing Skies' = @{
        Short = 'Significantly boosts Thunder Blast single target damage.'
        Full = 'Significantly boosts the single target value of Thunder Blast. Triggers in addition to the normal random chance for a lightning strike, allowing two for one cast.'
    }
    'Thorims Might' = @{
        Short = 'Greatly empowers lightning strikes and rotational abilities.'
        Full = 'Very powerful, giving lightning strikes and rotational abilities much more value.'
    }
    'Crashing Thunder' = @{
        Short = 'Allows Thunder Clap to replace Whirlwind in rotation.'
        Full = 'Allows Thunder Clap to effectively replace Whirlwind within the rotation.'
    }
    'Ground Current' = @{
        Short = 'Lightning Strikes hit multiple targets for reduced damage.'
        Full = 'Allows Lightning Strikes to hit multiple targets for significantly reduced damage. Does not hit the primary target of the lightning strike''s initial target.'
    }
    'Strength of the Mountain' = @{
        Short = 'General damage increase.'
        Full = 'General damage increase for Mountain Thane warriors.'
    }
    'Burst of Power' = @{
        Short = 'Random Bloodthirst damage increase.'
        Full = 'Random Bloodthirst damage increase triggered by lightning effects.'
    }
    'Tide of Battle' = @{
        Short = 'Variable Overpower damage increase.'
        Full = 'Variable Overpower damage increase based on combat conditions.'
    }
    'No Stranger to Pain' = @{
        Short = 'Increases Ignore Pain effectiveness.'
        Full = 'Increases the value of Ignore Pain, though the ability itself is rather small.'
    }
    
    # Colossus (From Arms guide)
    'Demolish' = @{
        Short = 'Powerful three-hit combo that slows movement by 99%.'
        Full = 'Very powerful three-hit combo, slowing movement speed by 99%. Defensive and mobility abilities do not interrupt the attack.'
    }
    'Dominance of the Colossus' = @{
        Short = 'Grants cooldown reduction and damage amplification debuff.'
        Full = 'Grants cooldown reduction and applies a debuff that increases all damage dealt, including that of the Demolish that applies it.'
    }
    'Earthquake' = @{
        Short = 'Very useful for reduced cooldown and knock-up disruption.'
        Full = 'Very useful for its reduced cooldown, while the knock-up allows disruption in spite of diminishing returns.'
    }
    'Colossal Might' = @{
        Short = 'Effectively doubles Demolish damage.'
        Full = 'Effectively doubles the damage of Demolish when active.'
    }
    'Martial Expert' = @{
        Short = 'Increases critical strike damage.'
        Full = 'One of several critical strike damage boosts for Colossus warriors.'
    }
    'Practiced Strikes' = @{
        Short = 'General damage increase.'
        Full = 'General damage increase for Colossus warriors.'
    }
    'Precise Might' = @{
        Short = 'Emphasizes regular Mortal Strike use and critical strikes.'
        Full = 'Further emphasizes using Mortal Strike regularly and getting critical strikes.'
    }
    'Mountain of Muscle and Scars' = @{
        Short = 'General damage/defense increase.'
        Full = 'General damage/defense, and almost unnoticeable size increase.'
    }
    'Arterial Bleed' = @{
        Short = 'Enhances bleed effects.'
        Full = 'Enhances bleed effects applied by Colossus abilities.'
    }
    
    # Slayer (From Arms/Fury guides)
    'Slayers Dominance' = @{
        Short = 'Frequent damage proc that applies Marked for Execution.'
        Full = 'Frequent random single target damage proc that inflicts the much more important Marked for Execution debuff.'
    }
    'Unrelenting Onslaught' = @{
        Short = 'Increases Bladestorm frequency at cost of cooldown sync.'
        Full = 'Typically desyncs Bladestorm from other major cooldowns, though the increased frequency is worth the tradeoff.'
    }
    'Imminent Demise' = @{
        Short = 'Allows consuming Marked for Execution, empowers Bladestorm.'
        Full = 'Allows the consumption of Marked for Execution, even without Sudden Death talented, while also making Bladestorm much more powerful. Has strong synergy with Unhinged.'
    }
    'Death Drive' = @{
        Short = 'Minor random healing during execute phase.'
        Full = 'Very minor and largely random, which means it will not always be effective healing.'
    }
    'Show No Mercy' = @{
        Short = 'Damage increase tied to Marked for Execution procs.'
        Full = 'Another damage increase tied to Marked for Execution and Sudden Death procs.'
    }
    
    # Additional from Slayer tree
    'Relentless Pursuit' = @{
        Short = 'Increases movement speed when targeting marked enemies.'
        Full = 'Very useful for keeping up with moving targets, especially when charging on the pull.'
    }
    'Brutal Finish' = @{
        Short = 'Damage bonus applies to each target hit.'
        Full = 'Better against multiple targets due to the damage bonus applying to each target hit.'
    }
    'Fierce Followthrough' = @{
        Short = 'Critical strikes grant damage bonus to all targets.'
        Full = 'Only triggers off crits against the primary target, though the resulting damage bonus affects every target.'
    }
    'Opportunist' = @{
        Short = 'Increases damage based on attack speed.'
        Full = 'High value due to the frequency of Tactician procs. (Arms) / Low value due to how infrequently Raging Blow resets its own cooldown. (Fury)'
    }
    'Overwhelming Blades' = @{
        Short = 'Universal damage increase with high uptime.'
        Full = 'Universal damage increase with a very high uptime.'
    }
    'Reap the Storm' = @{
        Short = 'Helps apply and maintain Overwhelming Blades.'
        Full = 'Helps apply and maintain Overwhelming Blades passive effect.'
    }
    'Slayers Malice' = @{
        Short = 'Increases Overpower/Raging Blow damage.'
        Full = 'Basic Overpower damage increase. (Arms) / Basic Raging Blow damage increase. (Fury)'
    }
    'Culling Cyclone' = @{
        Short = 'Increases Bladestorm single target value.'
        Full = 'Increases the single target value of Bladestorm, but does not further increase damage by hitting multiple targets.'
    }
    'Vicious Agility' = @{
        Short = 'Movement speed bonus after kills.'
        Full = 'Less regularly useful outside of specific encounter timing, though minorly better for open world content.'
    }
    
    # Extra abilities
    'Grant Extra Attack' = @{
        Short = 'Grants additional attack action.'
        Full = 'Provides an extra attack action during combat, allowing for additional offensive capabilities.'
    }
}

Write-Host "[INFO] Loaded $($HeroTalentDescriptions.Count) hero talent descriptions from Icy-Veins" -ForegroundColor Cyan

# Update database
foreach ($ability in $Db) {
    $name = $ability.ability_name
    
    if ($HeroTalentDescriptions.ContainsKey($name)) {
        $needsUpdate = $false
        $desc = $HeroTalentDescriptions[$name]
        
        # Check if short description is missing
        if ([string]::IsNullOrWhiteSpace($ability.description_short)) {
            if (-not $DryRun) {
                $ability.description_short = $desc.Short
            }
            $needsUpdate = $true
        }
        
        # Check if full description is missing
        if ([string]::IsNullOrWhiteSpace($ability.description_full)) {
            if (-not $DryRun) {
                $ability.description_full = $desc.Full
            }
            $needsUpdate = $true
        }
        
        if ($needsUpdate) {
            Write-Host "  [UPDATED] $name" -ForegroundColor Green
            if ($DryRun) {
                Write-Host "    Short: $($desc.Short)" -ForegroundColor Gray
                Write-Host "    Full: $($desc.Full)" -ForegroundColor Gray
            }
            $UpdateCount++
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
Write-Host "SCRAPING SUMMARY" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Abilities Updated: $UpdateCount" -ForegroundColor $(if ($UpdateCount -gt 0) { 'Green' } else { 'Yellow' })
if ($DryRun) {
    Write-Host "  Mode: DRY RUN (no changes saved)" -ForegroundColor Yellow
}

# Check remaining missing
$Remaining = $Db | Where-Object { 
    ([string]::IsNullOrWhiteSpace($_.description_short) -or [string]::IsNullOrWhiteSpace($_.description_full)) 
}
Write-Host "  Remaining Missing: $($Remaining.Count)" -ForegroundColor $(if ($Remaining.Count -eq 0) { 'Green' } else { 'Yellow' })

if ($Remaining.Count -gt 0) {
    Write-Host "`n[REMAINING ABILITIES NEEDING DESCRIPTIONS]:" -ForegroundColor Yellow
    $Remaining | Select-Object ability_name, archetype_tags | Format-Table -AutoSize
}

Write-Host "`n========================================`n" -ForegroundColor Cyan
