$csv = Import-Csv 'C:\Users\tenod\source\repos\BG3Mods\Documentation\00_SourcesOfTruth\AbilityDatabase_Warrior_FullyEnriched.csv'
$heroTalents = $csv | Where-Object { $_.archetype_tags -like '*Hero-Talent*' }

Write-Host "`n=== HERO TALENT COUNT ===" -ForegroundColor Cyan
Write-Host "Total hero talent entries: $($heroTalents.Count)" -ForegroundColor Yellow
Write-Host ""

Write-Host "=== ALL HERO TALENT ability_id VALUES ===" -ForegroundColor Cyan
$heroTalents | ForEach-Object { Write-Host "  $_. ability_id" }
