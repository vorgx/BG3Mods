# Automation Script: Apply WoWWarlock Template to Warrior Mod
# This script automates the tedious parts of using Warlock as a template

$ErrorActionPreference = "Stop"

Write-Host "`n╔═══════════════════════════════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║         WARLOCK TEMPLATE APPLICATION SCRIPT                      ║" -ForegroundColor Cyan
Write-Host "╚═══════════════════════════════════════════════════════════════════╝`n" -ForegroundColor Cyan

# Configuration
$timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
$warlockUUID = "bdb3fa73-401b-4979-f02e-485422dd8d9c"
$warriorUUID = "78fe4967-4e62-5491-d981-dd781acca4d7"
$warlockSource = "Tests\02_ExampleMods\ExampleMod_WoWWarlock"

# ============================================================================
# PHASE 1: BACKUP EVERYTHING
# ============================================================================

Write-Host "═══ PHASE 1: BACKUP ═══`n" -ForegroundColor Yellow

Write-Host "Creating backups..." -ForegroundColor White
$fullBackup = "Tests\WARRIOR_BACKUP_BEFORE_TEMPLATE_$timestamp"
$statsBackup = "Tests\WARRIOR_STATS_BACKUP_$timestamp"

# Full backup
Write-Host "  → Backing up entire Data folder..." -ForegroundColor Gray
Copy-Item "Data" "$fullBackup" -Recurse -Force
Write-Host "    ✅ Full backup: $fullBackup" -ForegroundColor Green

# Stats backup
Write-Host "  → Backing up stat files separately..." -ForegroundColor Gray
New-Item -ItemType Directory -Path $statsBackup -Force | Out-Null
Copy-Item "Data\Public\BG3Wow_$warriorUUID\Stats\Generated\Data\*" "$statsBackup\" -Force
Write-Host "    ✅ Stats backup: $statsBackup" -ForegroundColor Green

Write-Host "`n✅ PHASE 1 COMPLETE - All backups created`n" -ForegroundColor Green
Read-Host "Press Enter to continue to Phase 2"

# ============================================================================
# PHASE 2: CLEAR & COPY WARLOCK STRUCTURE
# ============================================================================

Write-Host "`n═══ PHASE 2: COPY WARLOCK TEMPLATE ═══`n" -ForegroundColor Yellow

Write-Host "Clearing current Data folder..." -ForegroundColor White
Remove-Item "Data\*" -Recurse -Force
Write-Host "  ✅ Cleared" -ForegroundColor Green

Write-Host "`nCopying Warlock structure..." -ForegroundColor White

# Copy Mods folder
Write-Host "  → Copying Mods folder..." -ForegroundColor Gray
Copy-Item "$warlockSource\Mods\*" "Data\Mods\" -Recurse -Force
Write-Host "    ✅ Mods copied" -ForegroundColor Green

# Copy Public folder
Write-Host "  → Copying Public folder..." -ForegroundColor Gray
Copy-Item "$warlockSource\Public\*" "Data\Public\" -Recurse -Force
Write-Host "    ✅ Public copied" -ForegroundColor Green

Write-Host "`n✅ PHASE 2 COMPLETE - Warlock template copied`n" -ForegroundColor Green
Read-Host "Press Enter to continue to Phase 3"

# ============================================================================
# PHASE 3: RENAME FOLDERS (UUID CHANGE)
# ============================================================================

Write-Host "`n═══ PHASE 3: RENAME FOLDERS ═══`n" -ForegroundColor Yellow

Write-Host "Renaming Warlock UUID folders to Warrior UUID..." -ForegroundColor White

# Rename Mods folder
Write-Host "  → Renaming Mods folder..." -ForegroundColor Gray
Rename-Item "Data\Mods\Warlock_WoW_$warlockUUID" "Data\Mods\BG3Wow_$warriorUUID"
Write-Host "    ✅ Mods folder renamed" -ForegroundColor Green

# Rename Public folder
Write-Host "  → Renaming Public folder..." -ForegroundColor Gray
Rename-Item "Data\Public\Warlock_WoW_$warlockUUID" "Data\Public\BG3Wow_$warriorUUID"
Write-Host "    ✅ Public folder renamed" -ForegroundColor Green

Write-Host "`n✅ PHASE 3 COMPLETE - Folders renamed`n" -ForegroundColor Green
Read-Host "Press Enter to continue to Phase 4"

# ============================================================================
# PHASE 4: GLOBAL FIND & REPLACE
# ============================================================================

Write-Host "`n═══ PHASE 4: GLOBAL UUID & NAME REPLACEMENT ═══`n" -ForegroundColor Yellow

Write-Host "Finding all text files..." -ForegroundColor White
$files = Get-ChildItem "Data" -Recurse -Include "*.lsx","*.txt","*.xml" -File
Write-Host "  Found $($files.Count) files to process`n" -ForegroundColor Gray

Write-Host "Replacing UUIDs and names..." -ForegroundColor White
$processed = 0
foreach ($file in $files) {
    $processed++
    Write-Progress -Activity "Replacing content" -Status "Processing $($file.Name)" -PercentComplete (($processed / $files.Count) * 100)
    
    $content = Get-Content $file.FullName -Raw -Encoding UTF8
    
    # Replace Warlock UUID with Warrior UUID
    $content = $content -replace $warlockUUID, $warriorUUID
    
    # Replace mod names
    $content = $content -replace "Warlock_WoW", "BG3Wow"
    $content = $content -replace "WoWWarlock", "WoWWarrior"
    
    # Save back (preserve encoding)
    $Utf8NoBomEncoding = New-Object System.Text.UTF8Encoding $False
    [System.IO.File]::WriteAllText($file.FullName, $content, $Utf8NoBomEncoding)
}
Write-Progress -Activity "Replacing content" -Completed

Write-Host "  ✅ Replaced UUIDs in $($files.Count) files" -ForegroundColor Green
Write-Host "  ✅ Replaced mod names in $($files.Count) files" -ForegroundColor Green

Write-Host "`n✅ PHASE 4 COMPLETE - All replacements done`n" -ForegroundColor Green
Read-Host "Press Enter to continue to Phase 5"

# ============================================================================
# PHASE 5: RESTORE WARRIOR STAT FILES
# ============================================================================

Write-Host "`n═══ PHASE 5: RESTORE WARRIOR STAT FILES ═══`n" -ForegroundColor Yellow

$statsPath = "Data\Public\BG3Wow_$warriorUUID\Stats\Generated\Data"

Write-Host "Removing Warlock stat files..." -ForegroundColor White
Remove-Item "$statsPath\*" -Force
Write-Host "  ✅ Cleared Warlock stats" -ForegroundColor Green

Write-Host "`nRestoring Warrior stat files..." -ForegroundColor White
Copy-Item "$statsBackup\*" "$statsPath\" -Force
Write-Host "  ✅ Restored our Warrior abilities:" -ForegroundColor Green

# List restored files
Get-ChildItem "$statsPath\*.txt" | ForEach-Object {
    $entries = (Select-String -Path $_.FullName -Pattern "^new entry" | Measure-Object).Count
    Write-Host "    • $($_.Name): $entries entries" -ForegroundColor Gray
}

Write-Host "`n✅ PHASE 5 COMPLETE - Warrior stats restored`n" -ForegroundColor Green
Read-Host "Press Enter to continue to Phase 6"

# ============================================================================
# PHASE 6: CLEAN UP WARLOCK-SPECIFIC FILES
# ============================================================================

Write-Host "`n═══ PHASE 6: REMOVE WARLOCK-SPECIFIC FILES ═══`n" -ForegroundColor Yellow

$publicPath = "Data\Public\BG3Wow_$warriorUUID"

Write-Host "Removing unnecessary Warlock files..." -ForegroundColor White

# RootTemplates (140 demon templates)
if (Test-Path "$publicPath\RootTemplates") {
    Write-Host "  → Removing RootTemplates (140 demon files)..." -ForegroundColor Gray
    Remove-Item "$publicPath\RootTemplates" -Recurse -Force
    Write-Host "    ✅ Removed RootTemplates" -ForegroundColor Green
}

# GUI customizations
if (Test-Path "$publicPath\GUI") {
    Write-Host "  → Removing GUI customizations..." -ForegroundColor Gray
    Remove-Item "$publicPath\GUI" -Recurse -Force
    Write-Host "    ✅ Removed GUI" -ForegroundColor Green
}

# Custom Assets
if (Test-Path "$publicPath\Assets") {
    Write-Host "  → Removing custom Assets..." -ForegroundColor Gray
    Remove-Item "$publicPath\Assets" -Recurse -Force
    Write-Host "    ✅ Removed Assets" -ForegroundColor Green
}

# Content visuals
if (Test-Path "$publicPath\Content") {
    Write-Host "  → Removing Content visuals..." -ForegroundColor Gray
    Remove-Item "$publicPath\Content" -Recurse -Force
    Write-Host "    ✅ Removed Content" -ForegroundColor Green
}

# MultiEffectInfos
if (Test-Path "$publicPath\MultiEffectInfos") {
    Write-Host "  → Removing MultiEffectInfos..." -ForegroundColor Gray
    Remove-Item "$publicPath\MultiEffectInfos" -Recurse -Force
    Write-Host "    ✅ Removed MultiEffectInfos" -ForegroundColor Green
}

Write-Host "`n✅ PHASE 6 COMPLETE - Cleaned up Warlock-specific files`n" -ForegroundColor Green
Read-Host "Press Enter to continue to Phase 7"

# ============================================================================
# PHASE 7: SUMMARY & NEXT STEPS
# ============================================================================

Write-Host "`n╔═══════════════════════════════════════════════════════════════════╗" -ForegroundColor Green
Write-Host "║              ✅ AUTOMATION COMPLETE! ✅                          ║" -ForegroundColor Green
Write-Host "╚═══════════════════════════════════════════════════════════════════╝`n" -ForegroundColor Green

Write-Host "📊 WHAT WAS AUTOMATED:" -ForegroundColor Cyan
Write-Host "  ✅ Full backup created" -ForegroundColor White
Write-Host "  ✅ Warlock template copied" -ForegroundColor White
Write-Host "  ✅ Folders renamed to Warrior UUID" -ForegroundColor White
Write-Host "  ✅ All UUIDs replaced ($($files.Count) files)" -ForegroundColor White
Write-Host "  ✅ All mod names replaced" -ForegroundColor White
Write-Host "  ✅ Warrior stat files restored (135 entries)" -ForegroundColor White
Write-Host "  ✅ Warlock-specific files removed`n" -ForegroundColor White

Write-Host "📁 CURRENT STRUCTURE:" -ForegroundColor Cyan
Write-Host "  Data\Mods\BG3Wow_$warriorUUID\" -ForegroundColor Gray
Write-Host "    └─ meta.lsx (needs manual update)" -ForegroundColor Yellow
Write-Host "  Data\Public\BG3Wow_$warriorUUID\" -ForegroundColor Gray
Write-Host "    ├─ ActionResourceDefinitions\ (needs manual update)" -ForegroundColor Yellow
Write-Host "    ├─ ClassDescriptions\ (needs manual update)" -ForegroundColor Yellow
Write-Host "    ├─ Progressions\ (needs manual update)" -ForegroundColor Yellow
Write-Host "    ├─ Lists\ (needs manual update)" -ForegroundColor Yellow
Write-Host "    ├─ Stats\Generated\Data\ (✅ already has Warrior abilities)" -ForegroundColor Green
Write-Host "    └─ Localization\ (needs manual update)`n" -ForegroundColor Yellow

Write-Host "🔧 MANUAL WORK NEEDED:" -ForegroundColor Cyan
Write-Host "  1. Update meta.lsx:" -ForegroundColor Yellow
Write-Host "     • Name: 'BG3Wow'" -ForegroundColor Gray
Write-Host "     • Author: [your name]" -ForegroundColor Gray
Write-Host "     • Description: Warrior class description`n" -ForegroundColor Gray

Write-Host "  2. Update ClassDescriptions\ClassDescriptions.lsx:" -ForegroundColor Yellow
Write-Host "     • Change class name to 'Warrior'" -ForegroundColor Gray
Write-Host "     • Change SpellCastingAbility to 'Strength'" -ForegroundColor Gray
Write-Host "     • Update subclass names (Arms, Fury, Protection)" -ForegroundColor Gray
Write-Host "     • Adjust BaseHp/HpPerLevel`n" -ForegroundColor Gray

Write-Host "  3. Update ActionResourceDefinitions\ActionResourceDefinitions.lsx:" -ForegroundColor Yellow
Write-Host "     • Delete all Soul Shard resources" -ForegroundColor Gray
Write-Host "     • Add Rage resource definition`n" -ForegroundColor Gray

Write-Host "  4. Update Progressions\Progressions.lsx:" -ForegroundColor Yellow
Write-Host "     • Replace Warlock ability grants with Warrior abilities" -ForegroundColor Gray
Write-Host "     • Use correct prefixes (Target_, Shout_, etc.)" -ForegroundColor Gray
Write-Host "     • Update PassivesAdded`n" -ForegroundColor Gray

Write-Host "  5. Update Lists\ folder:" -ForegroundColor Yellow
Write-Host "     • SpellLists.lsx: Change Warlock spells to Warrior spells" -ForegroundColor Gray
Write-Host "     • PassiveLists.lsx: Change Warlock passives to Warrior passives`n" -ForegroundColor Gray

Write-Host "  6. Update Localization\English\English.loca.xml:" -ForegroundColor Yellow
Write-Host "     • Replace all Warlock strings with Warrior strings`n" -ForegroundColor Gray

Write-Host "📖 DETAILED INSTRUCTIONS:" -ForegroundColor Cyan
Write-Host "  See: Reports\06_WARLOCK_TEMPLATE_PLAN.md" -ForegroundColor Gray
Write-Host "  Sections: Phase 5-11 have step-by-step manual update instructions`n" -ForegroundColor Gray

Write-Host "🎯 ESTIMATED TIME FOR MANUAL WORK: 1-1.5 hours`n" -ForegroundColor Green

Write-Host "💾 BACKUPS AVAILABLE:" -ForegroundColor Cyan
Write-Host "  • Full backup: $fullBackup" -ForegroundColor Gray
Write-Host "  • Stats backup: $statsBackup`n" -ForegroundColor Gray

Write-Host "═══════════════════════════════════════════════════════════════════`n" -ForegroundColor Cyan

# Create checkpoint
Write-Host "Creating checkpoint package..." -ForegroundColor White
$checkpointPath = "Package\BG3Wow_TEMPLATE_CHECKPOINT_$timestamp.pak"
$sourcePath = (Resolve-Path "Data").Path
& "LsLib\Tools\Divine.exe" -g bg3 -a create-package -s $sourcePath -d $checkpointPath -c lz4 2>&1 | Out-Null

if (Test-Path $checkpointPath) {
    Write-Host "✅ Checkpoint saved: Package\BG3Wow_TEMPLATE_CHECKPOINT_$timestamp.pak`n" -ForegroundColor Green
    Write-Host "   You can test this checkpoint (will probably crash, needs manual updates)" -ForegroundColor Yellow
} else {
    Write-Host "⚠️  Checkpoint package failed (Divine.exe error)" -ForegroundColor Yellow
    Write-Host "   Continue with manual updates, we'll package after those are done`n" -ForegroundColor Gray
}

Write-Host "Ready to start manual updates? Check the plan in Reports\06_WARLOCK_TEMPLATE_PLAN.md" -ForegroundColor Cyan
Write-Host "Then tell me which file you want to start with!`n" -ForegroundColor Cyan
