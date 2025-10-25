$DbPath = "C:\Users\tenod\source\repos\BG3Mods\Documentation\00_SourcesOfTruth\AbilityDatabase_Warrior_FullyEnriched.csv"
$Db = Import-Csv -Path $DbPath
$SpellZones = $Db | Where-Object { $_.bg3_file_type -eq "Spell_Zone" }

Write-Host "`nFound $($SpellZones.Count) Spell_Zone abilities:" -ForegroundColor Green
$SpellZones | Select-Object ability_id, ability_name, subclass_filter | Format-Table -AutoSize

# Export for generation script
$SpellZones | Export-Csv -Path "C:\Users\tenod\source\repos\BG3Mods\Scripts\Spell_Zone_Abilities.csv" -NoTypeInformation
Write-Host "Exported to: Scripts\Spell_Zone_Abilities.csv" -ForegroundColor Cyan
