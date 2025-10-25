$DbPath = "C:\Users\tenod\source\repos\BG3Mods\Documentation\00_SourcesOfTruth\AbilityDatabase_Warrior_FullyEnriched.csv"
$Db = Import-Csv -Path $DbPath

Write-Host "`n=== STATUS EFFECTS IN DATABASE INVESTIGATION ===" -ForegroundColor Cyan

Write-Host "`n[1] Total abilities in database: $($Db.Count)" -ForegroundColor White

# Check if status effects are separate entries
Write-Host "`n[2] Checking for entries with ability_type='Status':" -ForegroundColor Yellow
$statusTypeEntries = $Db | Where-Object { $_.ability_type -eq "Status" -or $_.ability_type -like "*Status*" }
Write-Host "Found: $($statusTypeEntries.Count)" -ForegroundColor $(if ($statusTypeEntries.Count -gt 0) { "Green" } else { "Red" })

# Check if status effect NAMES match ability IDs
Write-Host "`n[3] Checking if status names (from status_applied) exist as ability_id:" -ForegroundColor Yellow
$statusNames = @(
    "WAR_AVATAR", "WAR_BATTLE_SHOUT", "WAR_BATTLE_STANCE", "WAR_BERSERKER_SHOUT",
    "WAR_COLOSSUS_SMASH", "WAR_DEFENSIVE_STANCE", "WAR_DEMORALIZING_SHOUT",
    "WAR_DIE_BY_THE_SWORD", "WAR_DISRUPTING_SHOUT", "WAR_ENRAGED_REGENERATION",
    "WAR_HAMSTRING", "WAR_IGNORE_PAIN", "WAR_IMPENETRABLE_WALL", "WAR_INTIMIDATING_SHOUT",
    "WAR_PUMMEL", "WAR_RECKLESSNESS", "WAR_SHIELD_BLOCK", "WAR_SHIELD_WALL",
    "WAR_SHOCKWAVE", "WAR_SPELL_REFLECTION", "WAR_STORM_BOLT", "WAR_STORM_BOLTS",
    "WAR_STORM_WALL", "WAR_TAUNTED", "WAR_WARBREAKER"
)

$foundInDb = 0
$notFoundInDb = 0

foreach ($statusName in $statusNames) {
    $entry = $Db | Where-Object { $_.ability_id -eq $statusName }
    if ($entry) {
        $foundInDb++
        Write-Host "  FOUND: $statusName" -ForegroundColor Green
        Write-Host "    - ability_name: $($entry.ability_name)" -ForegroundColor Gray
        Write-Host "    - ability_type: $($entry.ability_type)" -ForegroundColor Gray
        Write-Host "    - bg3_file_type: $($entry.bg3_file_type)" -ForegroundColor Gray
    } else {
        $notFoundInDb++
        Write-Host "  NOT FOUND: $statusName" -ForegroundColor Red
    }
}

Write-Host "`n[4] Summary:" -ForegroundColor Yellow
Write-Host "  Status names that ARE in database: $foundInDb / $($statusNames.Count)" -ForegroundColor $(if ($foundInDb -eq $statusNames.Count) { "Green" } else { "Yellow" })
Write-Host "  Status names NOT in database: $notFoundInDb / $($statusNames.Count)" -ForegroundColor $(if ($notFoundInDb -eq 0) { "Green" } else { "Red" })

# Check the abilities that CREATE these status effects
Write-Host "`n[5] Checking abilities that CREATE status effects (source abilities):" -ForegroundColor Yellow
$sourceAbilities = $Db | Where-Object { $_.status_applied -like "WAR_*" }
Write-Host "Found $($sourceAbilities.Count) abilities that apply status effects" -ForegroundColor Green

Write-Host "`nSample source abilities:" -ForegroundColor Gray
$sourceAbilities | Select-Object -First 5 ability_id, ability_name, bg3_file_type, status_applied | Format-Table -AutoSize

# Key insight
Write-Host "`n=== KEY INSIGHT ===" -ForegroundColor Cyan
if ($notFoundInDb -eq $statusNames.Count) {
    Write-Host "STATUS EFFECTS ARE NOT IN DATABASE AS SEPARATE ENTRIES!" -ForegroundColor Red
    Write-Host "They are referenced by abilities but don't have their own database rows." -ForegroundColor Yellow
    Write-Host "`nThis means:" -ForegroundColor White
    Write-Host "  - The 25 status effects were EXTRACTED from the 'status_applied' column" -ForegroundColor White
    Write-Host "  - They do NOT have enriched data (damage formulas, descriptions, etc.)" -ForegroundColor White
    Write-Host "  - Status_BOOST.txt generation used SOURCE ability data, not status data" -ForegroundColor White
    Write-Host "`nIMPLICATION:" -ForegroundColor Yellow
    Write-Host "  Status_BOOST.txt entries are TEMPLATE PLACEHOLDERS ONLY" -ForegroundColor Yellow
    Write-Host "  They need manual implementation based on source ability mechanics" -ForegroundColor Yellow
} else {
    Write-Host "Some status effects ARE in database as separate entries!" -ForegroundColor Green
    Write-Host "Found $foundInDb / $($statusNames.Count) in database" -ForegroundColor Green
}
