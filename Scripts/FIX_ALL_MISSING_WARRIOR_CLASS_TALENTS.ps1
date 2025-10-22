# FIX_ALL_MISSING_WARRIOR_CLASS_TALENTS.ps1
# Populate warrior_unlock for all 35 missing Warrior Class Talents
#
# Date: October 22, 2025

param(
    [string]$DatabaseCsv = "C:\Users\tenod\source\repos\BG3Mods\Documentation\00_SourcesOfTruth\AbilityDatabase_Warrior_FullyEnriched.csv"
)

Write-Host "`n=== FIX ALL MISSING WARRIOR CLASS TALENTS ===" -ForegroundColor Cyan

# Backup
$BackupPath = $DatabaseCsv -replace '\.csv$', "_BACKUP_$(Get-Date -Format 'yyyyMMdd_HHmmss').csv"
Copy-Item $DatabaseCsv $BackupPath -Force
Write-Host "[BACKUP] $BackupPath`n" -ForegroundColor Green

# Load database
$Database = Import-Csv $DatabaseCsv

# Missing talents organized by level
$missingTalents = @{
    3 = @('Storm Bolt')
    4 = @('Intimidating Shout', 'Second Wind', 'Frothing Berserker', 'Bounding Stride', 'Pain and Gain')
    5 = @('Cacophonous Roar', 'Menace', 'Shockwave', 'Barbaric Training')
    6 = @('Honed Reflexes', 'Crushing Force', 'Bitter Immunity', 'Overwhelming Rage', 'Rumbling Earth', 'Reinforced Plates')
    7 = @('Wrecking Throw', 'Shattering Throw', 'Sidearm', 'Double Time', 'Seismic Reverberation', 'Concussive Blows', 'Berserker Shout', 'Piercing Howl', 'Barbaric Training')
    8 = @('Cruel Strikes', 'Wild Strikes', 'Dual Wield Specialization', 'Armored to the Teeth')
    10 = @('Uproar', 'Thunderous Words', "Berserker's Torment", "Titan's Torment", 'Piercing Challenge', "Champion's Might")
}

Write-Host "[FIX] Populating warrior_unlock for missing talents...`n" -ForegroundColor Cyan

$fixCount = 0
$notFoundCount = 0
$alreadySetCount = 0

foreach ($level in $missingTalents.Keys | Sort-Object) {
    Write-Host "--- Level $level ---" -ForegroundColor Yellow
    
    foreach ($talentName in $missingTalents[$level]) {
        $ability = $Database | Where-Object { $_.ability_name -eq $talentName }
        
        if (-not $ability) {
            Write-Host "  [NOT FOUND] $talentName" -ForegroundColor Red
            $notFoundCount++
            continue
        }
        
        if ([string]::IsNullOrWhiteSpace($ability.warrior_unlock)) {
            Write-Host "  [SET] $talentName -> warrior_unlock = $level" -ForegroundColor Green
            $ability.warrior_unlock = $level
            $fixCount++
        }
        else {
            Write-Host "  [SKIP] $talentName already has warrior_unlock = $($ability.warrior_unlock)" -ForegroundColor Gray
            $alreadySetCount++
        }
    }
}

# Save
Write-Host "`n[SAVE] Writing updated database..." -ForegroundColor Cyan
$Database | Export-Csv $DatabaseCsv -NoTypeInformation -Force

Write-Host "`n=== SUMMARY ===" -ForegroundColor Cyan
Write-Host "Talents fixed: $fixCount" -ForegroundColor Green
Write-Host "Already set: $alreadySetCount" -ForegroundColor Gray
Write-Host "Not found in database: $notFoundCount" -ForegroundColor $(if ($notFoundCount -gt 0) { "Red" } else { "Gray" })
Write-Host "Backup: $BackupPath" -ForegroundColor Gray

# Verify final count
Write-Host "`n=== FINAL VERIFICATION ===" -ForegroundColor Cyan
$allWarriorUnlock = @($Database | Where-Object { -not [string]::IsNullOrWhiteSpace($_.warrior_unlock) })
Write-Host "Total abilities with warrior_unlock: $($allWarriorUnlock.Count)" -ForegroundColor Cyan

# Show breakdown by level
Write-Host "`nBreakdown by level:" -ForegroundColor Gray
$allWarriorUnlock | Group-Object warrior_unlock | Sort-Object { [int]$_.Name } | ForEach-Object {
    Write-Host "  Level $($_.Name): $($_.Count) abilities" -ForegroundColor Yellow
}
