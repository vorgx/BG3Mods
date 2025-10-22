# Fix Missing Level 1 Unlock Entries in Database
# Populates the 6 abilities that have empty unlock columns but should have L1 values

$dbPath = "C:\Users\tenod\source\repos\BG3Mods\Documentation\00_SourcesOfTruth\AbilityDatabase_Warrior_FullyEnriched.csv"
$backupPath = "C:\Users\tenod\source\repos\BG3Mods\Documentation\00_SourcesOfTruth\AbilityDatabase_Warrior_FullyEnriched_BACKUP_$(Get-Date -Format 'yyyyMMdd_HHmmss').csv"

Write-Host "=== Fixing Missing Level 1 Unlock Entries ===" -ForegroundColor Cyan
Write-Host ""

# Create backup
Write-Host "Creating backup..." -ForegroundColor Yellow
Copy-Item $dbPath $backupPath
Write-Host "Backup created: $backupPath" -ForegroundColor Green
Write-Host ""

# Load database
$database = Import-Csv $dbPath -Encoding UTF8

# Define fixes based on CSV column verification
$fixes = @(
    # Arms abilities
    @{ Ability = "Charge"; Arms = "1"; Fury = "3"; Protection = ""; Reason = "Arms Baseline Col 4, Fury Baseline Col 9 (L3)" }
    @{ Ability = "Seasoned Soldier"; Arms = "1"; Fury = ""; Protection = ""; Reason = "Arms Spec Row 1 Col 23" }
    @{ Ability = "Mastery: Deep Wounds"; Arms = "1"; Fury = ""; Protection = ""; Reason = "Arms Spec Row 1 Col 24" }
    
    # Fury abilities
    @{ Ability = "Mastery: Unshackled Fury"; Arms = ""; Fury = "1"; Protection = ""; Reason = "Fury Spec Row 1 Col 37" }
    
    # Protection abilities
    @{ Ability = "Taunt"; Arms = ""; Fury = ""; Protection = "1"; Reason = "Protection Baseline Col 6" }
    @{ Ability = "Mastery: Critical Block"; Arms = ""; Fury = ""; Protection = "1"; Reason = "Protection Baseline Col 7" }
)

Write-Host "Applying fixes..." -ForegroundColor Yellow
Write-Host ""

$fixedCount = 0
foreach ($fix in $fixes) {
    $ability = $database | Where-Object { $_.ability_name -eq $fix.Ability } | Select-Object -First 1
    
    if ($ability) {
        $oldValues = "arms=$($ability.arms_unlock), fury=$($ability.fury_unlock), protection=$($ability.protection_unlock)"
        
        # Update unlock columns
        $ability.arms_unlock = $fix.Arms
        $ability.fury_unlock = $fix.Fury
        $ability.protection_unlock = $fix.Protection
        
        $newValues = "arms=$($ability.arms_unlock), fury=$($ability.fury_unlock), protection=$($ability.protection_unlock)"
        
        Write-Host "[FIXED] $($fix.Ability)" -ForegroundColor Green
        Write-Host "     Reason: $($fix.Reason)" -ForegroundColor Gray
        Write-Host "     Old: $oldValues" -ForegroundColor Gray
        Write-Host "     New: $newValues" -ForegroundColor Gray
        Write-Host ""
        
        $fixedCount++
    } else {
        Write-Host "[NOT FOUND] $($fix.Ability)" -ForegroundColor Red
        Write-Host ""
    }
}

# Export fixed database
Write-Host "Exporting fixed database..." -ForegroundColor Yellow
$database | Export-Csv $dbPath -NoTypeInformation -Encoding UTF8
Write-Host "Database updated: $dbPath" -ForegroundColor Green
Write-Host ""

Write-Host "=== Summary ===" -ForegroundColor Cyan
Write-Host "Fixed $fixedCount out of $($fixes.Count) abilities" -ForegroundColor White
Write-Host "Backup location: $backupPath" -ForegroundColor White
Write-Host ""

# Verify fixes
Write-Host "=== Verification ===" -ForegroundColor Yellow
Write-Host ""

$databaseUpdated = Import-Csv $dbPath -Encoding UTF8

foreach ($fix in $fixes) {
    $ability = $databaseUpdated | Where-Object { $_.ability_name -eq $fix.Ability } | Select-Object -First 1
    
    if ($ability) {
        $verified = $true
        if ($fix.Arms -ne "" -and $ability.arms_unlock -ne $fix.Arms) { $verified = $false }
        if ($fix.Fury -ne "" -and $ability.fury_unlock -ne $fix.Fury) { $verified = $false }
        if ($fix.Protection -ne "" -and $ability.protection_unlock -ne $fix.Protection) { $verified = $false }
        
        $status = if ($verified) { "[OK]" } else { "[FAILED]" }
        $statusColor = if ($verified) { "Green" } else { "Red" }
        
        Write-Host "$status $($ability.ability_name)" -ForegroundColor $statusColor
        Write-Host "     arms=$($ability.arms_unlock), fury=$($ability.fury_unlock), protection=$($ability.protection_unlock)" -ForegroundColor Gray
    }
}

Write-Host ""
Write-Host "=== COMPLETE ===" -ForegroundColor Green
