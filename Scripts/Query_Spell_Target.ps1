param()

$DbPath = "C:\Users\tenod\source\repos\BG3Mods\Documentation\00_SourcesOfTruth\AbilityDatabase_Warrior_FullyEnriched.csv"

Write-Host "Loading database from: $DbPath" -ForegroundColor Cyan

try {
    $Db = Import-Csv -Path $DbPath
    Write-Host "Total abilities in database: $($Db.Count)" -ForegroundColor Green
    
    $SpellTargets = $Db | Where-Object { $_.bg3_file_type -eq "Spell_Target" }
    Write-Host "`nSpell_Target abilities found: $($SpellTargets.Count)" -ForegroundColor Yellow
    
    Write-Host "`n=== SPELL_TARGET ABILITIES ===" -ForegroundColor Cyan
    $SpellTargets | Select-Object ability_id, ability_name, wow_spec, unlock_level | 
        Format-Table -AutoSize
        
    Write-Host "`nExporting to CSV for reference..." -ForegroundColor Cyan
    $SpellTargets | Export-Csv -Path "C:\Users\tenod\source\repos\BG3Mods\Scripts\Spell_Target_Abilities.csv" -NoTypeInformation
    Write-Host "Exported to: Scripts\Spell_Target_Abilities.csv" -ForegroundColor Green
    
} catch {
    Write-Host "ERROR: $_" -ForegroundColor Red
    exit 1
}
