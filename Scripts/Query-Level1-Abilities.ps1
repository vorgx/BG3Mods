# Query Level 1 Abilities from Updated Database

$dbPath = "C:\Users\tenod\source\repos\BG3Mods\Documentation\00_SourcesOfTruth\AbilityDatabase_Warrior_FullyEnriched.csv"

Write-Host "=== Level 1 Abilities from Updated Database ===" -ForegroundColor Cyan
Write-Host ""

$data = Import-Csv $dbPath -Encoding UTF8

# Filter for Level 1 abilities
$level1Abilities = $data | Where-Object {
    $_.arms_unlock -eq '1' -or $_.fury_unlock -eq '1' -or $_.protection_unlock -eq '1'
}

Write-Host "Found $($level1Abilities.Count) Level 1 abilities" -ForegroundColor Green
Write-Host ""

# Group by subclass
Write-Host "=== ARMS WARRIOR (Level 1) ===" -ForegroundColor Yellow
$arms = $level1Abilities | Where-Object { $_.arms_unlock -eq '1' } | Select-Object ability_name, ability_type, bg3_file_type, bg3_spell_type
$arms | Format-Table -AutoSize
Write-Host "Total: $($arms.Count) abilities" -ForegroundColor Gray
Write-Host ""

Write-Host "=== FURY WARRIOR (Level 1) ===" -ForegroundColor Yellow
$fury = $level1Abilities | Where-Object { $_.fury_unlock -eq '1' } | Select-Object ability_name, ability_type, bg3_file_type, bg3_spell_type
$fury | Format-Table -AutoSize
Write-Host "Total: $($fury.Count) abilities" -ForegroundColor Gray
Write-Host ""

Write-Host "=== PROTECTION WARRIOR (Level 1) ===" -ForegroundColor Yellow
$protection = $level1Abilities | Where-Object { $_.protection_unlock -eq '1' } | Select-Object ability_name, ability_type, bg3_file_type, bg3_spell_type
$protection | Format-Table -AutoSize
Write-Host "Total: $($protection.Count) abilities" -ForegroundColor Gray
