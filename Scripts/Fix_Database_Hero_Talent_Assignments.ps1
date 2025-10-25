# Update Database with Correct Hero Talent Assignments from LINKED CSV
# Corrects L13-20 hero talent unlock columns to match 3-tree shared architecture

param(
    [string]$DatabasePath = "C:\Users\tenod\source\repos\BG3Mods\Documentation\00_SourcesOfTruth\AbilityDatabase_Warrior_FullyEnriched.csv"
)

Write-Host "=== UPDATING DATABASE WITH CORRECT HERO TALENT ASSIGNMENTS ===" -ForegroundColor Cyan
Write-Host "Source: Warrior Progression LINKED - Main.csv (columns 53-67)" -ForegroundColor Gray
Write-Host "Target: $DatabasePath`n" -ForegroundColor Gray

# Backup database
$backupPath = $DatabasePath + ".backup_" + (Get-Date -Format "yyyyMMdd_HHmmss")
Copy-Item $DatabasePath $backupPath
Write-Host "[1] Backup created: $backupPath" -ForegroundColor Yellow

# Load database
$database = Import-Csv $DatabasePath

Write-Host "`n[2] Correcting hero talent assignments..." -ForegroundColor Yellow

# CORRECT HERO TALENT ASSIGNMENTS FROM LINKED CSV
# Mountain Thane: Protection + Fury (columns 53-57)
# Colossus: Arms + Protection (columns 58-62)
# Slayers: Arms + Fury (columns 63-67)

$heroTalentCorrections = @{
    # MOUNTAIN THANE (Protection + Fury)
    "WAR_Lightning_Strikes" = @{ Level = 13; Specs = @("Protection", "Fury") }
    "WAR_Crashing_Thunder" = @{ Level = 15; Specs = @("Protection", "Fury") }
    "WAR_Ground_Current" = @{ Level = 15; Specs = @("Protection", "Fury") }
    "WAR_Strength_of_the_Mountain" = @{ Level = 15; Specs = @("Protection", "Fury") }
    "WAR_Thunder_Blast" = @{ Level = 17; Specs = @("Protection", "Fury") }
    "WAR_Storm_Bolts" = @{ Level = 17; Specs = @("Protection", "Fury") }
    "WAR_Keep_your_feet_on_the_Ground" = @{ Level = 17; Specs = @("Protection", "Fury") }
    "WAR_Flashing_Skies" = @{ Level = 19; Specs = @("Protection", "Fury") }
    "WAR_Thorim_s_Might" = @{ Level = 19; Specs = @("Protection", "Fury") }
    "WAR_Burst_of_Power" = @{ Level = 19; Specs = @("Protection", "Fury") }
    "WAR_Avatar_of_the_Storm" = @{ Level = 20; Specs = @("Protection", "Fury") }
    
    # COLOSSUS (Arms + Protection)
    "WAR_Demolish" = @{ Level = 13; Specs = @("Arms", "Protection") }
    "WAR_Martial_Expert" = @{ Level = 15; Specs = @("Arms", "Protection") }
    "WAR_Colossal_Might" = @{ Level = 15; Specs = @("Arms", "Protection") }
    "WAR_Earthquake" = @{ Level = 15; Specs = @("Arms", "Protection") }
    "WAR_Arterial_Bleed" = @{ Level = 17; Specs = @("Arms", "Protection") }
    "WAR_Tide_of_Battle" = @{ Level = 17; Specs = @("Arms", "Protection") }
    "WAR_No_Stranger_to_Pain" = @{ Level = 17; Specs = @("Arms", "Protection") }
    "WAR_Practiced_Strikes" = @{ Level = 19; Specs = @("Arms", "Protection") }
    "WAR_Precise_Might" = @{ Level = 19; Specs = @("Arms", "Protection") }
    "WAR_Mountain_of_Muscle_and_Scars" = @{ Level = 19; Specs = @("Arms", "Protection") }
    "WAR_Dominance_of_the_Colossus" = @{ Level = 20; Specs = @("Arms", "Protection") }
    
    # SLAYERS (Arms + Fury)
    "WAR_Slayer_s_Dominance" = @{ Level = 13; Specs = @("Arms", "Fury") }
    "WAR_Imminent_Demise" = @{ Level = 15; Specs = @("Arms", "Fury") }
    "WAR_Overwhelming_Blades" = @{ Level = 15; Specs = @("Arms", "Fury") }
    "WAR_Relentless_Pursuit" = @{ Level = 15; Specs = @("Arms", "Fury") }
    "WAR_Death_Drive" = @{ Level = 17; Specs = @("Arms", "Fury") }
    "WAR_Brutal_Finish" = @{ Level = 17; Specs = @("Arms", "Fury") }
    "WAR_Opportunist" = @{ Level = 17; Specs = @("Arms", "Fury") }
    "WAR_Show_No_Mercy" = @{ Level = 19; Specs = @("Arms", "Fury") }
    "WAR_Reap_the_Storm" = @{ Level = 19; Specs = @("Arms", "Fury") }
    "WAR_Slayer_s_Malice" = @{ Level = 19; Specs = @("Arms", "Fury") }
    "WAR_Unrelenting_Onslaught" = @{ Level = 20; Specs = @("Arms", "Fury") }
}

$correctionCount = 0
$notFoundCount = 0

foreach ($abilityId in $heroTalentCorrections.Keys) {
    $correction = $heroTalentCorrections[$abilityId]
    $ability = $database | Where-Object { $_.ability_id -eq $abilityId }
    
    if ($ability) {
        # Clear all unlock columns first
        $ability.warrior_unlock = ""
        $ability.arms_unlock = ""
        $ability.fury_unlock = ""
        $ability.protection_unlock = ""
        
        # Set correct unlock levels for assigned specs
        foreach ($spec in $correction.Specs) {
            switch ($spec) {
                "Arms" { $ability.arms_unlock = $correction.Level }
                "Fury" { $ability.fury_unlock = $correction.Level }
                "Protection" { $ability.protection_unlock = $correction.Level }
            }
        }
        
        Write-Host "  [FIXED] $abilityId → L$($correction.Level) for $($correction.Specs -join ', ')" -ForegroundColor Green
        $correctionCount++
    } else {
        Write-Host "  [WARN] $abilityId not found in database!" -ForegroundColor Yellow
        $notFoundCount++
    }
}

Write-Host "`n[3] Writing corrected database..." -ForegroundColor Yellow
$database | Export-Csv -Path $DatabasePath -NoTypeInformation -Force

Write-Host "`n[4] Validation..." -ForegroundColor Yellow
Write-Host "  Corrections applied: $correctionCount" -ForegroundColor $(if ($correctionCount -eq 33) { "Green" } else { "Yellow" })
Write-Host "  Not found: $notFoundCount" -ForegroundColor $(if ($notFoundCount -eq 0) { "Green" } else { "Red" })
Write-Host "  Expected: 33 hero talents (11 per tree)" -ForegroundColor Gray

if ($correctionCount -eq 33 -and $notFoundCount -eq 0) {
    Write-Host "`n✅ DATABASE UPDATED SUCCESSFULLY!" -ForegroundColor Green
    Write-Host "All 33 hero talents now have correct unlock levels:" -ForegroundColor Cyan
    Write-Host "  - Mountain Thane (11): Protection + Fury" -ForegroundColor Gray
    Write-Host "  - Colossus (11): Arms + Protection" -ForegroundColor Gray
    Write-Host "  - Slayers (11): Arms + Fury" -ForegroundColor Gray
} else {
    Write-Host "`n⚠️ WARNING: Not all corrections applied!" -ForegroundColor Yellow
    Write-Host "Expected 33 corrections, got $correctionCount" -ForegroundColor Yellow
}

Write-Host "`nBackup location: $backupPath" -ForegroundColor Gray
