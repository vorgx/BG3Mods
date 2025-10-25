# Fix LINKED CSV Naming Format
# Updates all ability_id references from old format (WAR__Name_) to new format (WAR_Name)

param(
    [string]$LinkedPath = "C:\Users\tenod\source\repos\BG3Mods\Documentation\00_SourcesOfTruth\Warrior Progression LINKED - Main.csv",
    [string]$BackupPath = "C:\Users\tenod\source\repos\BG3Mods\Documentation\00_SourcesOfTruth\Warrior Progression LINKED - Main.BACKUP.csv",
    [switch]$DryRun = $false
)

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "LINKED CSV Naming Format Fix" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Backup original file
Write-Host "[STEP 1] Creating backup..." -ForegroundColor Yellow
try {
    Copy-Item $LinkedPath $BackupPath -Force
    Write-Host "[PASS] Backup created: $BackupPath" -ForegroundColor Green
} catch {
    Write-Host "[FAIL] Failed to create backup: $_" -ForegroundColor Red
    exit 1
}

# Read file
Write-Host "[STEP 2] Reading LINKED CSV..." -ForegroundColor Yellow
try {
    $Content = Get-Content $LinkedPath -Raw -Encoding UTF8
    Write-Host "[PASS] File loaded ($(($Content -split "`n").Count) lines)" -ForegroundColor Green
} catch {
    Write-Host "[FAIL] Failed to read file: $_" -ForegroundColor Red
    exit 1
}

# Find all ability_id patterns
Write-Host "[STEP 3] Scanning for ability_id patterns..." -ForegroundColor Yellow
$MatchResults = [regex]::Matches($Content, 'WAR__[A-Za-z_]+_')
$UniquePatterns = $MatchResults.Value | Select-Object -Unique | Sort-Object
Write-Host "[INFO] Found $($UniquePatterns.Count) unique ability_id patterns with double underscores" -ForegroundColor Cyan

if ($UniquePatterns.Count -eq 0) {
    Write-Host "[WARN] No patterns found to fix. File may already be corrected." -ForegroundColor Yellow
    exit 0
}

# Display patterns to be fixed
Write-Host ""
Write-Host "Patterns to fix:" -ForegroundColor Yellow
$ReplacementMap = @{}
foreach ($Pattern in $UniquePatterns) {
    # Remove one underscore from double underscore prefix and trailing underscore
    # WAR__Name_ -> WAR_Name
    $NewPattern = $Pattern -replace '^WAR__', 'WAR_' -replace '_$', ''
    $ReplacementMap[$Pattern] = $NewPattern
    Write-Host "  $Pattern -> $NewPattern" -ForegroundColor Gray
}

if ($DryRun) {
    Write-Host ""
    Write-Host "[DRY RUN] Would replace $($ReplacementMap.Count) patterns" -ForegroundColor Yellow
    Write-Host "[DRY RUN] No changes made to file" -ForegroundColor Yellow
    exit 0
}

# Apply replacements
Write-Host ""
Write-Host "[STEP 4] Applying replacements..." -ForegroundColor Yellow
$ReplacementCount = 0
foreach ($OldPattern in $ReplacementMap.Keys) {
    $NewPattern = $ReplacementMap[$OldPattern]
    $OccurrenceCount = ([regex]::Matches($Content, [regex]::Escape($OldPattern))).Count
    $Content = $Content -replace [regex]::Escape($OldPattern), $NewPattern
    $ReplacementCount += $OccurrenceCount
    Write-Host "  Replaced '$OldPattern' -> '$NewPattern' ($OccurrenceCount occurrences)" -ForegroundColor Gray
}
Write-Host "[PASS] Applied $ReplacementCount total replacements" -ForegroundColor Green

# Verify changes
Write-Host "[STEP 5] Verifying changes..." -ForegroundColor Yellow
$RemainingIssues = [regex]::Matches($Content, 'WAR__[A-Za-z_]+_')
if ($RemainingIssues.Count -gt 0) {
    Write-Host "[WARN] $($RemainingIssues.Count) issues still remain after replacement" -ForegroundColor Yellow
    Write-Host "Remaining patterns:" -ForegroundColor Yellow
    $RemainingIssues.Value | Select-Object -Unique | ForEach-Object { Write-Host "  $_" -ForegroundColor Gray }
} else {
    Write-Host "[PASS] No double underscore patterns remaining!" -ForegroundColor Green
}

# Check for any remaining trailing underscores in WAR_ patterns
$TrailingUnderscores = [regex]::Matches($Content, 'WAR_[A-Za-z_]+_(?=[,\r\n])')
if ($TrailingUnderscores.Count -gt 0) {
    Write-Host "[WARN] Found $($TrailingUnderscores.Count) trailing underscores in corrected patterns" -ForegroundColor Yellow
    # Additional cleanup for trailing underscores
    $Content = $Content -replace '(WAR_[A-Za-z_]+)_(?=[,\r\n])', '$1'
    Write-Host "[INFO] Cleaned up trailing underscores" -ForegroundColor Cyan
}

# Save fixed file
Write-Host "[STEP 6] Saving fixed file..." -ForegroundColor Yellow
try {
    $Content | Out-File $LinkedPath -Encoding UTF8 -NoNewline
    Write-Host "[PASS] File saved: $LinkedPath" -ForegroundColor Green
} catch {
    Write-Host "[FAIL] Failed to save file: $_" -ForegroundColor Red
    Write-Host "[INFO] Restoring backup..." -ForegroundColor Yellow
    Copy-Item $BackupPath $LinkedPath -Force
    exit 1
}

# Generate summary
Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "FIX COMPLETE" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Unique patterns fixed: $($ReplacementMap.Count)" -ForegroundColor Cyan
Write-Host "Total replacements: $ReplacementCount" -ForegroundColor Cyan
Write-Host "Backup location: $BackupPath" -ForegroundColor Cyan
Write-Host ""
Write-Host "[INFO] Re-run Phase1_Baseline_Validation.ps1 to verify fixes" -ForegroundColor Yellow
Write-Host ""

exit 0
