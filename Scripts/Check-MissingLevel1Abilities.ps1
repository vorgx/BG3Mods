# Check Missing Level 1 Abilities

$dbPath = "C:\Users\tenod\source\repos\BG3Mods\Documentation\00_SourcesOfTruth\AbilityDatabase_Warrior_FullyEnriched.csv"

$data = Import-Csv $dbPath -Encoding UTF8

# Search for the 4 missing abilities
$missingAbilities = @('Charge', 'Taunt', 'Mastery: Critical Block', 'Mastery: Unshackled Fury')

Write-Host "=== Checking Missing Level 1 Abilities ===" -ForegroundColor Cyan
Write-Host ""

foreach ($abilityName in $missingAbilities) {
    Write-Host "Searching for: $abilityName" -ForegroundColor Yellow
    $found = $data | Where-Object { $_.ability_name -like "*$abilityName*" }
    
    if ($found) {
        $found | Select-Object ability_name, warrior_unlock, arms_unlock, fury_unlock, protection_unlock, unlock_source, subclass_filter | Format-Table -AutoSize
    } else {
        Write-Host "  NOT FOUND in database!" -ForegroundColor Red
    }
    Write-Host ""
}
