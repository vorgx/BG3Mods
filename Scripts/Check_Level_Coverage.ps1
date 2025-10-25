# Check Spell Unlocks by Level (L1-20)

$db = Import-Csv 'C:\Users\tenod\source\repos\BG3Mods\Documentation\00_SourcesOfTruth\AbilityDatabase_Warrior_FullyEnriched.csv'

Write-Host "=== SPELL UNLOCKS BY LEVEL ===" -ForegroundColor Cyan

for ($i=1; $i -le 20; $i++) {
    $warrior = ($db | Where-Object { $_.warrior_unlock -eq $i -and $_.bg3_file_type -match '^Spell_' }).Count
    $arms = ($db | Where-Object { $_.arms_unlock -eq $i -and $_.bg3_file_type -match '^Spell_' }).Count
    $fury = ($db | Where-Object { $_.fury_unlock -eq $i -and $_.bg3_file_type -match '^Spell_' }).Count
    $prot = ($db | Where-Object { $_.protection_unlock -eq $i -and $_.bg3_file_type -match '^Spell_' }).Count
    
    $total = $warrior + $arms + $fury + $prot
    
    if ($total -gt 0) {
        $color = if ($i -le 12) { 'Green' } else { 'Yellow' }
        Write-Host "Level $i : Warrior=$warrior, Arms=$arms, Fury=$fury, Protection=$prot (Total: $total spells)" -ForegroundColor $color
    } else {
        Write-Host "Level $i : No spell unlocks" -ForegroundColor Gray
    }
}

Write-Host "`n=== SUMMARY ===" -ForegroundColor Cyan
$l1to12 = ($db | Where-Object { [int]$_.warrior_unlock -le 12 -or [int]$_.arms_unlock -le 12 -or [int]$_.fury_unlock -le 12 -or [int]$_.protection_unlock -le 12 } | Where-Object { $_.bg3_file_type -match '^Spell_' }).Count
$l13to20 = ($db | Where-Object { [int]$_.warrior_unlock -ge 13 -or [int]$_.arms_unlock -ge 13 -or [int]$_.fury_unlock -ge 13 -or [int]$_.protection_unlock -ge 13 } | Where-Object { $_.bg3_file_type -match '^Spell_' }).Count

Write-Host "Spells with unlocks L1-12: $l1to12" -ForegroundColor Green
Write-Host "Spells with unlocks L13-20: $l13to20" -ForegroundColor Yellow

if ($l13to20 -eq 0) {
    Write-Host "`n⚠️ No spells are assigned to levels 13-20 in the database!" -ForegroundColor Red
    Write-Host "SpellLists.lsx cannot be extended beyond L12 without database entries." -ForegroundColor Red
    Write-Host "`nRecommendation: Database needs L13-20 spell assignments for hero talents/capstones" -ForegroundColor Yellow
}
