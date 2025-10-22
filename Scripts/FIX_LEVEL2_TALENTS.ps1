# FIX_LEVEL2_TALENTS.ps1
# Manually fix the 4 missing Level 2 Warrior Class Talents
# These should all have warrior_unlock = 2 (since all specs get them)
#
# Date: October 22, 2025

param(
    [string]$DatabaseCsv = "C:\Users\tenod\source\repos\BG3Mods\Documentation\00_SourcesOfTruth\AbilityDatabase_Warrior_FullyEnriched.csv"
)

Write-Host "`n=== FIX LEVEL 2 WARRIOR CLASS TALENTS ===" -ForegroundColor Cyan

# Backup
$BackupPath = $DatabaseCsv -replace '\.csv$', "_BACKUP_$(Get-Date -Format 'yyyyMMdd_HHmmss').csv"
Copy-Item $DatabaseCsv $BackupPath -Force
Write-Host "[BACKUP] $BackupPath`n" -ForegroundColor Green

# Load database
$Database = Import-Csv $DatabaseCsv

# Level 2 Warrior Class Talents (all specs get these)
$level2Talents = @('Fast Footwork', 'War Machine', 'Leeching Strikes', 'Intervene')

Write-Host "[FIX] Setting warrior_unlock = 2 for Level 2 class talents...`n" -ForegroundColor Cyan

$fixCount = 0

foreach ($talentName in $level2Talents) {
    $ability = $Database | Where-Object { $_.ability_name -eq $talentName }
    
    if ($ability) {
        if ([string]::IsNullOrWhiteSpace($ability.warrior_unlock)) {
            Write-Host "[SET] $talentName -> warrior_unlock = 2" -ForegroundColor Green
            $ability.warrior_unlock = 2
            $fixCount++
        }
        else {
            Write-Host "[SKIP] $talentName already has warrior_unlock = $($ability.warrior_unlock)" -ForegroundColor Gray
        }
    }
    else {
        Write-Host "[ERROR] $talentName not found in database!" -ForegroundColor Red
    }
}

# Save
Write-Host "`n[SAVE] Writing updated database..." -ForegroundColor Cyan
$Database | Export-Csv $DatabaseCsv -NoTypeInformation -Force

Write-Host "`n=== SUMMARY ===" -ForegroundColor Cyan
Write-Host "Level 2 talents fixed: $fixCount" -ForegroundColor Green
Write-Host "Backup: $BackupPath" -ForegroundColor Gray

# Verify
Write-Host "`n=== VERIFICATION ===" -ForegroundColor Cyan
$Database | Where-Object { $_.warrior_unlock -eq '2' } | Select-Object ability_name, warrior_unlock | Format-Table -AutoSize
