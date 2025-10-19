# ========================================
# BG3Wow Tests Folder Migration Script
# ========================================
# Purpose: Migrate 22 items from Tests/ root into 3 organized subfolders
# Created: October 17, 2025
# Version: 1.0
#
# IMPORTANT: Run with -WhatIf first to preview changes!
# Usage:
#   1. Dry-run: .\MIGRATE_TESTS.ps1 -WhatIf
#   2. Execute:  .\MIGRATE_TESTS.ps1
# ========================================

param(
    [switch]$WhatIf = $false
)

# Base paths
$TestsRoot = "c:\Users\tenod\source\repos\BG3Mods\Tests"
$ValidationReportsFolder = Join-Path $TestsRoot "01_ValidationReports"
$ExampleModsFolder = Join-Path $TestsRoot "02_ExampleMods"
# Note: 03_ExtractedContent was deleted due to Windows path length issues
# Folders renumbered: 04_TestReports → 03, 05_Tools → 04, 06_Troubleshooting → 05

# Ensure destination folders exist
if (-not $WhatIf) {
    if (-not (Test-Path $ValidationReportsFolder)) { New-Item -Path $ValidationReportsFolder -ItemType Directory -Force | Out-Null }
    if (-not (Test-Path $ExampleModsFolder)) { New-Item -Path $ExampleModsFolder -ItemType Directory -Force | Out-Null }
    if (-not (Test-Path $ExtractedContentFolder)) { New-Item -Path $ExtractedContentFolder -ItemType Directory -Force | Out-Null }
}

# ========================================
# Migration Lists
# ========================================

# 15 Validation .md files → 01_ValidationReports/
$ValidationReports = @(
    "ABILITY_DESIGN_FRAMEWORK.md",
    "ANALYSIS_SUMMARY.md",
    "COMPREHENSIVE_VALIDATION_REPORT.md",
    "COOLDOWN_VERIFICATION_REPORT.md",
    "CRASH_DIAGNOSIS_SUMMARY.md",
    "DECISION_SUMMARY.md",
    "LOCALIZATION_COMPLETE.md",
    "QUICK_VALIDATION_CHECKLIST.md",
    "SUNDER_ARMOR_COMPLETION.md",
    "SUNDER_ARMOR_IMPLEMENTATION.md",
    "SUNDER_ARMOR_LOCALIZATION.md",
    "VALIDATION_STATUS_FINAL.md",
    "VALIDATION_SUMMARY.md",
    "WARRIOR_ABILITIES_VALIDATION_REPORT.md",
    "WARRIOR_VALIDATION_RESULTS.md"
)

# 3 Example Mod folders → 02_ExampleMods/
$ExampleMods = @(
    "ExampleMod_5eSpells",
    "ExampleMod_WoWWarlock",
    "MinimalMod"
)

# 4 folders + 1 .pak → 03_ExtractedContent/
$ExtractedContent = @(
    "ExtractedPak",
    "InstalledPackageCheck",
    "NewPackage",
    "WoWWarrior_BACKUP",
    "WoWWarrior_BACKUP.pak"
)

# ========================================
# Migration Functions
# ========================================

function Write-MigrationHeader {
    Write-Host "`n========================================" -ForegroundColor Cyan
    Write-Host "BG3Wow Tests Folder Migration" -ForegroundColor Cyan
    Write-Host "========================================" -ForegroundColor Cyan
    if ($WhatIf) {
        Write-Host "DRY-RUN MODE: No changes will be made" -ForegroundColor Yellow
    } else {
        Write-Host "EXECUTING MIGRATION: Files/folders will be moved" -ForegroundColor Green
    }
    Write-Host ""
}

function Move-Items {
    param(
        [string]$CategoryName,
        [string[]]$Items,
        [string]$DestinationFolder
    )
    
    Write-Host "`nMigrating $CategoryName..." -ForegroundColor Cyan
    Write-Host "Destination: $DestinationFolder" -ForegroundColor Gray
    Write-Host ("=" * 60) -ForegroundColor Gray
    
    $SuccessCount = 0
    $ErrorCount = 0
    
    foreach ($Item in $Items) {
        $SourcePath = Join-Path $TestsRoot $Item
        $DestinationPath = Join-Path $DestinationFolder $Item
        
        if (Test-Path $SourcePath) {
            try {
                if ($WhatIf) {
                    Write-Host "[DRY-RUN] Would move: $Item" -ForegroundColor Yellow
                } else {
                    Move-Item -Path $SourcePath -Destination $DestinationPath -Force -ErrorAction Stop
                    Write-Host "[MOVED] $Item" -ForegroundColor Green
                }
                $SuccessCount++
            } catch {
                Write-Host "[ERROR] Failed to move $Item : $($_.Exception.Message)" -ForegroundColor Red
                $ErrorCount++
            }
        } else {
            Write-Host "[SKIPPED] Not found: $Item" -ForegroundColor DarkYellow
        }
    }
    
    Write-Host "`nSummary: $SuccessCount successful, $ErrorCount errors" -ForegroundColor Cyan
}

# ========================================
# Execute Migrations
# ========================================

Write-MigrationHeader

# Category 1: Validation Reports
Move-Items -CategoryName "Validation Reports" `
           -Items $ValidationReports `
           -DestinationFolder $ValidationReportsFolder

# Category 2: Example Mods
Move-Items -CategoryName "Example Mods" `
           -Items $ExampleMods `
           -DestinationFolder $ExampleModsFolder

# Category 3: Extracted Content
Move-Items -CategoryName "Extracted Content" `
           -Items $ExtractedContent `
           -DestinationFolder $ExtractedContentFolder

# ========================================
# Final Summary
# ========================================

Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host "Migration Complete!" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan

if ($WhatIf) {
    Write-Host "`nDRY-RUN COMPLETE. No changes were made." -ForegroundColor Yellow
    Write-Host "To execute the migration, run: .\MIGRATE_TESTS.ps1" -ForegroundColor Yellow
} else {
    Write-Host "`nMigration executed successfully." -ForegroundColor Green
    Write-Host "`nVerify the new structure:" -ForegroundColor Cyan
    Write-Host "  Tests/01_ValidationReports/ (15 .md files)" -ForegroundColor Gray
    Write-Host "  Tests/02_ExampleMods/ (3 folders)" -ForegroundColor Gray
    Write-Host "  Tests/03_TestReports/ (renamed from 04)" -ForegroundColor Gray
    Write-Host "  Tests/04_Tools/ (renamed from 05)" -ForegroundColor Gray
    Write-Host "  Tests/05_Troubleshooting/ (renamed from 06)" -ForegroundColor Gray
    Write-Host "  Note: 03_ExtractedContent was deleted (path length issues)" -ForegroundColor Yellow
}

Write-Host ""
