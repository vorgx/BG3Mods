# Check Taunt Implementation
# Verify WAR_Taunt spell and WAR_TAUNTED status are correctly implemented

Write-Host "=== CHECKING TAUNT IMPLEMENTATION ===" -ForegroundColor Cyan

# [1] Check Spell_Target.txt for WAR_Taunt spell
Write-Host "`n[1] Checking Spell_Target.txt for WAR_Taunt spell:" -ForegroundColor Yellow
$spellTarget = Get-Content "C:\Users\tenod\source\repos\BG3Mods\Data\Public\Warrior_Wow_78fe4967-4e62-5491-d981-dd781acca4d7\Stats\Generated\Data\Spell_Target.txt" -Raw
if ($spellTarget -match 'new entry "Target_WAR_Taunt"') {
    Write-Host "  FOUND: Target_WAR_Taunt in Spell_Target.txt" -ForegroundColor Green
} else {
    Write-Host "  NOT FOUND: Target_WAR_Taunt in Spell_Target.txt" -ForegroundColor Red
}

# [2] Check Status_BOOST.txt for WAR_TAUNTED status
Write-Host "`n[2] Checking Status_BOOST.txt for WAR_TAUNTED status:" -ForegroundColor Yellow
$statusBoost = Get-Content "C:\Users\tenod\source\repos\BG3Mods\Data\Public\Warrior_Wow_78fe4967-4e62-5491-d981-dd781acca4d7\Stats\Generated\Data\Status_BOOST.txt" -Raw
if ($statusBoost -match 'new entry "WAR_TAUNTED"') {
    Write-Host "  FOUND: WAR_TAUNTED in Status_BOOST.txt" -ForegroundColor Green
} else {
    Write-Host "  NOT FOUND: WAR_TAUNTED in Status_BOOST.txt" -ForegroundColor Red
}

# [3] Check database for WAR_Taunt
Write-Host "`n[3] Database check for WAR_Taunt:" -ForegroundColor Yellow
$db = Import-Csv "C:\Users\tenod\source\repos\BG3Mods\Documentation\00_SourcesOfTruth\AbilityDatabase_Warrior_FullyEnriched.csv"
$taunt = $db | Where-Object { $_.ability_id -eq 'WAR_Taunt' }

if ($taunt) {
    Write-Host "  FOUND in database:" -ForegroundColor Green
    Write-Host "    ability_id: WAR_Taunt" -ForegroundColor Gray
    Write-Host "    ability_name: $($taunt.ability_name)" -ForegroundColor Gray
    Write-Host "    bg3_file_type: $($taunt.bg3_file_type)" -ForegroundColor Gray
    Write-Host "    status_applied: $($taunt.status_applied)" -ForegroundColor Gray
    Write-Host "    bg3_mechanic_equivalent: $($taunt.bg3_mechanic_equivalent)" -ForegroundColor Gray
} else {
    Write-Host "  NOT FOUND in database" -ForegroundColor Red
}

Write-Host "`n=== SUMMARY ===" -ForegroundColor Cyan
Write-Host "If Option A (keep Status_BOOST.txt as-is):" -ForegroundColor Yellow
Write-Host "  - WAR_Taunt spell exists in Spell_Target.txt (cast by player)" -ForegroundColor Gray
Write-Host "  - When implemented, spell will: ApplyStatus(TARGET,WAR_TAUNTED,100,1)" -ForegroundColor Gray
Write-Host "  - WAR_TAUNTED status in Status_BOOST.txt defines the taunt effect behavior" -ForegroundColor Gray
Write-Host "  - Both pieces work together: spell applies status, status defines effect" -ForegroundColor Gray
