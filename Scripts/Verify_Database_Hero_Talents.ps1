# Verify Database Hero Talent Corrections
# Shows a few examples of corrected dual-spec assignments

$database = Import-Csv "C:\Users\tenod\source\repos\BG3Mods\Documentation\00_SourcesOfTruth\AbilityDatabase_Warrior_FullyEnriched.csv"

Write-Host "=== DATABASE HERO TALENT VERIFICATION ===" -ForegroundColor Cyan
Write-Host "Checking dual-spec assignments for hero talents`n" -ForegroundColor Gray

# Sample from each tree
$samples = @(
    @{ Name = "WAR_Lightning_Strikes"; Tree = "Mountain Thane"; ExpectedSpecs = @("Protection", "Fury") }
    @{ Name = "WAR_Demolish"; Tree = "Colossus"; ExpectedSpecs = @("Arms", "Protection") }
    @{ Name = "WAR_Slayer_s_Dominance"; Tree = "Slayers"; ExpectedSpecs = @("Arms", "Fury") }
)

foreach ($sample in $samples) {
    $ability = $database | Where-Object { $_.ability_id -eq $sample.Name }
    
    Write-Host "$($sample.Name) ($($sample.Tree)):" -ForegroundColor Yellow
    Write-Host "  warrior_unlock: '$($ability.warrior_unlock)'" -ForegroundColor Gray
    Write-Host "  arms_unlock: '$($ability.arms_unlock)'" -ForegroundColor Gray
    Write-Host "  fury_unlock: '$($ability.fury_unlock)'" -ForegroundColor Gray
    Write-Host "  protection_unlock: '$($ability.protection_unlock)'" -ForegroundColor Gray
    
    $correctSpecs = @()
    if ($ability.arms_unlock) { $correctSpecs += "Arms" }
    if ($ability.fury_unlock) { $correctSpecs += "Fury" }
    if ($ability.protection_unlock) { $correctSpecs += "Protection" }
    
    if ($correctSpecs.Count -eq 2 -and 
        $correctSpecs -contains $sample.ExpectedSpecs[0] -and 
        $correctSpecs -contains $sample.ExpectedSpecs[1]) {
        Write-Host "  ✅ CORRECT: Assigned to $($correctSpecs -join ' + ')" -ForegroundColor Green
    } else {
        Write-Host "  ❌ ERROR: Assigned to $($correctSpecs -join ' + '), expected $($sample.ExpectedSpecs -join ' + ')" -ForegroundColor Red
    }
    Write-Host ""
}

# Count all hero talents
$heroTalents = $database | Where-Object {
    $_.unlock_source -eq "Hero Talent" -or
    $_.ability_id -match "WAR_(Lightning_Strikes|Crashing_Thunder|Ground_Current|Strength_of_the_Mountain|Thunder_Blast|Storm_Bolts|Keep_your_feet_on_the_Ground|Flashing_Skies|Thorim_s_Might|Burst_of_Power|Avatar_of_the_Storm|Demolish|Martial_Expert|Colossal_Might|Earthquake|Arterial_Bleed|Tide_of_Battle|No_Stranger_to_Pain|Practiced_Strikes|Precise_Might|Mountain_of_Muscle_and_Scars|Dominance_of_the_Colossus|Slayer_s_Dominance|Imminent_Demise|Overwhelming_Blades|Relentless_Pursuit|Death_Drive|Brutal_Finish|Opportunist|Show_No_Mercy|Reap_the_Storm|Slayer_s_Malice|Unrelenting_Onslaught)"
}

Write-Host "Total hero talents in database: $($heroTalents.Count)" -ForegroundColor Cyan
Write-Host "Expected: 33 (11 per tree)" -ForegroundColor Gray
