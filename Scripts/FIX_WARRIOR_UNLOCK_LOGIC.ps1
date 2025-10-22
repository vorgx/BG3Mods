# FIX_WARRIOR_UNLOCK_LOGIC.ps1
# Fixes warrior_unlock column logic
# Rule: warrior_unlock should ONLY be populated when all three specs
# (arms, fury, protection) unlock the ability at THE SAME LEVEL
#
# Date: October 22, 2025

param(
    [string]$DatabaseCsv = "C:\Users\tenod\source\repos\BG3Mods\Documentation\00_SourcesOfTruth\AbilityDatabase_Warrior_FullyEnriched.csv"
)

Write-Host "`n=== FIX WARRIOR_UNLOCK LOGIC ===" -ForegroundColor Cyan

# Backup
$BackupPath = $DatabaseCsv -replace '\.csv$', "_BACKUP_$(Get-Date -Format 'yyyyMMdd_HHmmss').csv"
Copy-Item $DatabaseCsv $BackupPath -Force
Write-Host "[BACKUP] $BackupPath`n" -ForegroundColor Green

# Load database
$Database = Import-Csv $DatabaseCsv

Write-Host "[FIX] Applying correct warrior_unlock logic...`n" -ForegroundColor Cyan

$FixCount = 0
$SetCount = 0

foreach ($ability in $Database) {
    $arms = $ability.arms_unlock
    $fury = $ability.fury_unlock
    $prot = $ability.protection_unlock
    $current = $ability.warrior_unlock
    
    # Check if all three specs have the SAME level
    $shouldHaveWarriorUnlock = $false
    $warriorLevel = $null
    
    if ($arms -and $fury -and $prot) {
        if ($arms -eq $fury -and $fury -eq $prot) {
            $shouldHaveWarriorUnlock = $true
            $warriorLevel = $arms
        }
    }
    
    # Fix if needed
    if ($shouldHaveWarriorUnlock) {
        if ($current -ne $warriorLevel) {
            Write-Host "[SET] $($ability.ability_name): warrior_unlock = $warriorLevel (arms=$arms, fury=$fury, prot=$prot)" -ForegroundColor Green
            $ability.warrior_unlock = $warriorLevel
            $SetCount++
        }
    }
    else {
        if ($current) {
            Write-Host "[CLEAR] $($ability.ability_name): warrior_unlock removed (was $current, but levels don't match: arms=$arms, fury=$fury, prot=$prot)" -ForegroundColor Yellow
            $ability.warrior_unlock = ''
            $FixCount++
        }
    }
}

# Save
Write-Host "`n[SAVE] Writing corrected database..." -ForegroundColor Cyan
$Database | Export-Csv $DatabaseCsv -NoTypeInformation -Force

Write-Host "`n=== SUMMARY ===" -ForegroundColor Cyan
Write-Host "Incorrect warrior_unlock cleared: $FixCount" -ForegroundColor Yellow
Write-Host "Correct warrior_unlock set: $SetCount" -ForegroundColor Green
Write-Host "Backup: $BackupPath" -ForegroundColor Gray

# Show final warrior_unlock abilities
Write-Host "`n=== FINAL WARRIOR_UNLOCK ABILITIES ===`n" -ForegroundColor Cyan
$Database | Where-Object { $_.warrior_unlock } | Select-Object ability_name, warrior_unlock, arms_unlock, fury_unlock, protection_unlock | Format-Table -AutoSize
