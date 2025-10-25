# Link Localization Handles to Ability Database
# Created: October 25, 2025
# Purpose: Populate localization_handle_name and localization_handle_description columns

param(
    [string]$AbilityDatabasePath = "C:\Users\tenod\source\repos\BG3Mods\Documentation\00_SourcesOfTruth\AbilityDatabase_Warrior_FullyEnriched.csv",
    [string]$HandleMapPath = "C:\Users\tenod\source\repos\BG3Mods\Scripts\Generated_Localization_Handles.csv"
)

Write-Host "`n==================== LINK HANDLES TO DATABASE ====================" -ForegroundColor Cyan

# Validate files exist
if (-not (Test-Path $AbilityDatabasePath)) {
    throw "Ability database not found: $AbilityDatabasePath"
}

if (-not (Test-Path $HandleMapPath)) {
    throw "Handle map not found: $HandleMapPath"
}

# Create backup
$timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
$backupPath = Join-Path (Split-Path $AbilityDatabasePath -Parent) ("AbilityDatabase_Warrior_FullyEnriched_BACKUP_{0}.csv" -f $timestamp)
Copy-Item $AbilityDatabasePath $backupPath -Force
Write-Host "[BACKUP] Created: " -NoNewline -ForegroundColor Cyan
Write-Host $backupPath -ForegroundColor Yellow

# Load handle map
Write-Host "`n[STEP 1] Loading handle map..." -ForegroundColor Cyan
$handles = Import-Csv $HandleMapPath
$handleMap = @{}

foreach ($entry in $handles) {
    $name = $entry.EntryName
    if ([string]::IsNullOrWhiteSpace($name)) { continue }
    
    $trimmedName = $name.Trim()
    if ([string]::IsNullOrWhiteSpace($trimmedName)) { continue }
    
    # Build candidate keys (with and without spell type prefixes)
    $candidates = New-Object System.Collections.Generic.List[string]
    $candidates.Add($trimmedName)
    
    # Strip spell type prefix if present
    $prefixTrimmed = $trimmedName -replace '^(Target_|Zone_|Shout_|Jump_|Projectile_)', ''
    if ($prefixTrimmed -ne $trimmedName) {
        $candidates.Add($prefixTrimmed)
    }
    
    # Normalize WAR_ prefix
    $normalized = $prefixTrimmed
    if (-not [string]::IsNullOrWhiteSpace($normalized)) {
        $normalized = $normalized -replace '^WAR_WAR_', 'WAR_'
        if (-not $normalized.StartsWith('WAR_') -and $normalized.StartsWith('WAR')) {
            $normalized = 'WAR_' + $normalized.Substring(3)
        }
        $candidates.Add($normalized)
    }
    
    # Store all unique candidate keys
    $uniqueKeys = $candidates | Where-Object { -not [string]::IsNullOrWhiteSpace($_) } | Select-Object -Unique
    foreach ($key in $uniqueKeys) {
        if (-not $handleMap.ContainsKey($key)) {
            $handleMap[$key] = [PSCustomObject]@{
                HandleName = $entry.HandleName
                HandleDesc = $entry.HandleDesc
            }
        }
    }
}

Write-Host "[INFO] Handle map entries: " -NoNewline -ForegroundColor Cyan
Write-Host $handleMap.Count -ForegroundColor Green

# Load ability database
Write-Host "`n[STEP 2] Loading ability database..." -ForegroundColor Cyan
$abilities = Import-Csv $AbilityDatabasePath
Write-Host "[INFO] Ability rows: " -NoNewline -ForegroundColor Cyan
Write-Host $abilities.Count -ForegroundColor Green

# Link handles to abilities
Write-Host "`n[STEP 3] Linking handles to abilities..." -ForegroundColor Cyan
$matched = 0
foreach ($row in $abilities) {
    $id = $row.ability_id
    if ($id) { $id = $id.Trim() }
    
    $handleName = $null
    $handleDesc = $null
    
    if ($id -and $handleMap.ContainsKey($id)) {
        $handleName = $handleMap[$id].HandleName
        $handleDesc = $handleMap[$id].HandleDesc
        $matched++
    }
    
    # Add or update handle columns
    $row | Add-Member -NotePropertyName "localization_handle_name" -NotePropertyValue $handleName -Force
    $row | Add-Member -NotePropertyName "localization_handle_description" -NotePropertyValue $handleDesc -Force
}

# Export updated database
Write-Host "`n[STEP 4] Exporting updated database..." -ForegroundColor Cyan
$abilities | Export-Csv $AbilityDatabasePath -NoTypeInformation -Encoding UTF8

# Summary
Write-Host "`n[SUMMARY]" -ForegroundColor Cyan
Write-Host "Ability rows processed: " -NoNewline -ForegroundColor Cyan
Write-Host $abilities.Count -ForegroundColor Green
Write-Host "Handles matched: " -NoNewline -ForegroundColor Cyan
Write-Host $matched -ForegroundColor Green
Write-Host "Handles missing: " -NoNewline -ForegroundColor Cyan
Write-Host ($abilities.Count - $matched) -ForegroundColor Yellow

Write-Host "`n[SUCCESS] Database updated with localization handles!" -ForegroundColor Green
Write-Host "=====================================================================`n" -ForegroundColor Cyan
