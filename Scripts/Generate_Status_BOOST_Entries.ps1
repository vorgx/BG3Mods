param(
    [switch]$DryRun
)

# ========================================
# CONFIGURATION
# ========================================
$DbPath = "C:\Users\tenod\source\repos\BG3Mods\Documentation\00_SourcesOfTruth\AbilityDatabase_Warrior_FullyEnriched.csv"
$StatusListPath = "C:\Users\tenod\source\repos\BG3Mods\Scripts\WAR_Status_Effects.csv"
$OutputPath = "C:\Users\tenod\source\repos\BG3Mods\Data\Public\Warrior_Wow_78fe4967-4e62-5491-d981-dd781acca4d7\Stats\Generated\Data\Status_BOOST.txt"
$BackupPath = "C:\Users\tenod\source\repos\BG3Mods\Data\Public\Warrior_Wow_78fe4967-4e62-5491-d981-dd781acca4d7\Stats\Generated\Data\Status_BOOST_BACKUP_$(Get-Date -Format 'yyyyMMdd_HHmmss').txt"

# ========================================
# LOAD DATABASE
# ========================================
Write-Host "Loading database from: $DbPath" -ForegroundColor Cyan
$Db = Import-Csv -Path $DbPath
$StatusList = Import-Csv -Path $StatusListPath

Write-Host "Found $($StatusList.Count) unique status effects" -ForegroundColor Green

# ========================================
# GENERATE STATUS ENTRIES
# ========================================

function New-StatusEntry {
    param($StatusName, $SourceAbility)
    
    # Get source ability details for context
    $sourceDetails = $Db | Where-Object { $_.ability_id -eq $SourceAbility } | Select-Object -First 1
    $description = if ($sourceDetails) { $sourceDetails.implementation_notes } else { "Status effect from $SourceAbility" }
    
    $entry = @"

// $StatusName
// Source: $($sourceDetails.ability_name)
// Implementation: $description
new entry "$StatusName"
type "StatusData"
data "StatusType" "BOOST"
data "DisplayName" "h123abc01;1"  // TODO: Generate proper localization handle
data "Description" "h123abc02;1"  // TODO: Generate proper localization handle
data "Icon" "statIcons_Default"  // TODO: Create custom icon
data "StackId" "$StatusName"
data "StackType" "Overwrite"
data "TickType" "StartTurn"
data "RemoveEvents" "OnTurn"
data "RemoveConditions" ""
data "StatusPropertyFlags" "BringIntoCombat"
// TODO: Implement status effects based on source ability mechanics
// Possible effects: Boosts, StatusPropertyFlags, OnApply, OnRemove, OnTick, TickFunctors
data "Boosts" "Placeholder();"  // TODO: Replace with actual status effects

"@
    return $entry
}

# ========================================
# BUILD OUTPUT
# ========================================
$Output = @"
// ========================================
// WARRIOR STATUS_BOOST DEFINITIONS
// Generated: $(Get-Date -Format 'MMMM dd, yyyy')
// Patch: 8 Compatible (4.8.0.10)
// Source: AbilityDatabase_Warrior_FullyEnriched.csv
// ========================================
// Total Status Effects: $($StatusList.Count)
// Note: Status effects applied by Warrior abilities
// ========================================

"@

# Output all status effects alphabetically
Write-Host "`nGenerating status entries alphabetically..." -ForegroundColor Cyan
foreach ($status in ($StatusList | Sort-Object StatusName)) {
    # Get first source ability for context
    $firstSource = ($status.SourceAbilities -split ',')[0].Trim()
    $Output += New-StatusEntry -StatusName $status.StatusName -SourceAbility $firstSource
}

# ========================================
# OUTPUT
# ========================================
$LineCount = ($Output -split "`n").Count
Write-Host "`nGenerated $LineCount lines of content" -ForegroundColor Green

if ($DryRun) {
    Write-Host "`n=== DRY RUN MODE ===" -ForegroundColor Yellow
    Write-Host "Output preview (first 60 lines):" -ForegroundColor Cyan
    ($Output -split "`n")[0..59] | ForEach-Object { Write-Host $_ }
    Write-Host "`n... (truncated) ..." -ForegroundColor Gray
    Write-Host "`nDry run complete. Use without -DryRun to write file." -ForegroundColor Yellow
} else {
    # Backup existing file
    if (Test-Path $OutputPath) {
        Write-Host "`nCreating backup: $BackupPath" -ForegroundColor Yellow
        Copy-Item -Path $OutputPath -Destination $BackupPath -Force
    }
    
    # Write output
    Write-Host "`nWriting to: $OutputPath" -ForegroundColor Cyan
    $Output | Out-File -FilePath $OutputPath -Encoding UTF8 -NoNewline
    
    # Verify
    $EntryCount = (Select-String -Path $OutputPath -Pattern '^new entry "WAR_' -AllMatches).Matches.Count
    Write-Host "`nVerification: $EntryCount entries written (expected: $($StatusList.Count))" -ForegroundColor Green
    
    if ($EntryCount -eq $StatusList.Count) {
        Write-Host "SUCCESS: All Status_BOOST entries generated!" -ForegroundColor Green
    } else {
        Write-Host "WARNING: Entry count mismatch! Expected $($StatusList.Count), got $EntryCount" -ForegroundColor Red
        Write-Host "This may be normal if some statuses don't follow WAR_* naming convention." -ForegroundColor Yellow
    }
}
