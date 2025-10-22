# CLEANUP SOURCE OF TRUTH FOLDER
# Date: October 21, 2025
# Purpose: Organize 00_SourcesOfTruth folder - keep only essential files in root

param(
    [Parameter(Mandatory=$false)]
    [switch]$DryRun = $false
)

$SourceFolder = "Documentation\00_SourcesOfTruth"

Write-Host "========================================" -ForegroundColor Cyan
Write-Host " CLEANUP: SOURCE OF TRUTH FOLDER" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

if ($DryRun) {
    Write-Host "[DRY RUN MODE] No files will be moved/deleted" -ForegroundColor Yellow
    Write-Host ""
}

# Create archive folders if they don't exist
$archiveFolders = @(
    "$SourceFolder\Archive\OldVersions",
    "$SourceFolder\Archive\EnrichmentBatches",
    "$SourceFolder\Archive\PlanningDocuments",
    "$SourceFolder\Archive\DraftSections",
    "$SourceFolder\Archive\ReferenceAnalysis"
)

foreach ($folder in $archiveFolders) {
    if (-not (Test-Path $folder)) {
        if (-not $DryRun) {
            New-Item -Path $folder -ItemType Directory -Force | Out-Null
        }
        Write-Host "[CREATE] $folder" -ForegroundColor Green
    }
}

Write-Host ""

# FILES TO KEEP IN ROOT (5 files only)
$keepFiles = @(
    "SOURCE_OF_TRUTH.md",
    "AbilityDatabase_Warrior_FullyEnriched.csv",
    "Warrior Progression for all subclasses.xlsx",
    "Warrior Progression for all subclasses and Default hero structure.csv",
    "README.md"
)

Write-Host "[KEEP] Files remaining in root:" -ForegroundColor Green
foreach ($file in $keepFiles) {
    Write-Host "  - $file" -ForegroundColor White
}
Write-Host ""

# ARCHIVE DEFINITIONS
$archiveMap = @{
    # Old database versions
    "AbilityDatabase_Warrior.csv" = "Archive\OldVersions"
    "AbilityDatabase_Warrior_FullyEnriched_v2.csv" = "Archive\OldVersions"
    "AbilityDatabase_Warrior_Original.csv" = "Archive\OldVersions"
    "AbilityDatabase_Warrior_PreReclassify.csv" = "Archive\OldVersions"
    "Warrior Progression for all subclasses.csv" = "Archive\OldVersions"
    
    # CSV backups (recent backups from Oct 21-22)
    "AbilityDatabase_Warrior_FullyEnriched_BACKUP_20251021_234722.csv" = "Archive\OldVersions"
    "AbilityDatabase_Warrior_FullyEnriched_BACKUP_20251022_015617.csv" = "Archive\OldVersions"
    "AbilityDatabase_Warrior_FullyEnriched_BACKUP_20251022_015705.csv" = "Archive\OldVersions"
    "AbilityDatabase_Warrior_FullyEnriched_BACKUP_20251022_015901.csv" = "Archive\OldVersions"
    "AbilityDatabase_Warrior_FullyEnriched_BACKUP_20251022_015944.csv" = "Archive\OldVersions"
    "AbilityDatabase_Warrior_FullyEnriched_BACKUP_20251022_020122.csv" = "Archive\OldVersions"
    "AbilityDatabase_Warrior_FullyEnriched_BACKUP_20251022_020619.csv" = "Archive\OldVersions"
    "AbilityDatabase_Warrior_FullyEnriched_BACKUP_20251022_020819.csv" = "Archive\OldVersions"
    "AbilityUnlockMapping.csv" = "Archive\OldVersions"
    
    # Enrichment batches
    "ENRICHMENT_BATCH_20251020_235804.csv" = "Archive\EnrichmentBatches"
    "ENRICHMENT_BATCH_20251021_000208.csv" = "Archive\EnrichmentBatches"
    "ENRICHMENT_BATCH_20251021_000424.csv" = "Archive\EnrichmentBatches"
    "ENRICHMENT_BATCH_20251021_000548.csv" = "Archive\EnrichmentBatches"
    
    # Planning documents
    "ABILITY_DATABASE_PLANNING.md" = "Archive\PlanningDocuments"
    "ABILITIES_NEEDING_REVIEW.md" = "Archive\PlanningDocuments"
    "AbilityDatabase_README.md" = "Archive\PlanningDocuments"
    "EXCEL_ABILITY_COUNT_SUMMARY.md" = "Archive\PlanningDocuments"
    "EXCEL_CSV_FULL_ANALYSIS_OCT20.md" = "Archive\PlanningDocuments"
    "EXCEL_CSV_VALIDATION_SUMMARY_OCT20.md" = "Archive\PlanningDocuments"
    "EXCEL_WARRIOR_PROGRESSION_ANALYSIS.md" = "Archive\PlanningDocuments"
    "OPTIONAL_IMPROVEMENTS_MOCKUP.md" = "Archive\PlanningDocuments"
    "RESOURCE_AUDIT_NEEDED.md" = "Archive\PlanningDocuments"
    "SESSION_SUMMARY_EXCEL_INTEGRATION.md" = "Archive\PlanningDocuments"
    "SOURCE_OF_TRUTH_VALIDATION_REPORT.md" = "Archive\PlanningDocuments"
    "USER_FEEDBACK_PROCESSED.md" = "Archive\PlanningDocuments"
    
    # Draft sections (now finalized in SOURCE_OF_TRUTH.md)
    "SECTION_3.2_CORE_MECHANICS_DRAFT.md" = "Archive\DraftSections"
    "SECTION_3.3_DRAFT_UPDATE_SUMMARY.md" = "Archive\DraftSections"
    "SECTION_3.3_FINAL_SUMMARY.md" = "Archive\DraftSections"
    "SECTION_3.3_LEVEL_BY_LEVEL_DRAFT.md" = "Archive\DraftSections"
    "SECTION_4.1_ARMS_WARRIOR_DRAFT.md" = "Archive\DraftSections"
    "WARRIOR_COMPLETE_STRUCTURE_L1-L20.md" = "Archive\DraftSections"
    "SPECIALIZATION_AUTO_GRANT_CORRECTION.md" = "Archive\DraftSections"
    
    # Warlock/reference analysis
    "DEMONHUNTER_SPELLLIST_ANALYSIS.md" = "Archive\ReferenceAnalysis"
    "WARLOCK_BASE_VS_ADDON_ANALYSIS.md" = "Archive\ReferenceAnalysis"
    "WARLOCK_REVERSE_ENGINEERING.md" = "Archive\ReferenceAnalysis"
    "WARLOCK_SPELLLIST_ANALYSIS.md" = "Archive\ReferenceAnalysis"
    "WARLOCK_VS_WARRIOR_HERO_TALENTS_COMPARISON.md" = "Archive\ReferenceAnalysis"
    "WARRIOR_SPELLLIST_BREAKDOWN.md" = "Archive\ReferenceAnalysis"
    "WARRIOR_WARLOCK_FULL_SPELLLISTS_COMPARISON.md" = "Archive\ReferenceAnalysis"
    "ImplementedAbilities_Scan.csv" = "Archive\ReferenceAnalysis"
}

# DELETE (Excel temp file)
$deleteFiles = @(
    "~`$Warrior Progression for all subclasses.xlsx"
)

# MOVE TO OTHER DOCUMENTATION FOLDERS
$moveFiles = @{
    "HERO_TALENTS_OVERVIEW.md" = "..\06_ProjectDocuments"
    "RAGE_COMBAT_SIMULATION.md" = "..\06_ProjectDocuments"
}

Write-Host "[ARCHIVE] Moving files to archive folders:" -ForegroundColor Yellow
foreach ($file in $archiveMap.Keys) {
    $sourcePath = Join-Path $SourceFolder $file
    $destFolder = Join-Path $SourceFolder $archiveMap[$file]
    $destPath = Join-Path $destFolder $file
    
    if (Test-Path $sourcePath) {
        if (-not $DryRun) {
            Move-Item -Path $sourcePath -Destination $destPath -Force
        }
        Write-Host "  MOVED: $file -> $($archiveMap[$file])" -ForegroundColor Cyan
    }
    else {
        Write-Host "  SKIP: $file (not found)" -ForegroundColor Gray
    }
}

Write-Host ""
Write-Host "[DELETE] Removing temp files:" -ForegroundColor Red
foreach ($file in $deleteFiles) {
    $filePath = Join-Path $SourceFolder $file
    if (Test-Path $filePath) {
        if (-not $DryRun) {
            Remove-Item -Path $filePath -Force
        }
        Write-Host "  DELETED: $file" -ForegroundColor Red
    }
    else {
        Write-Host "  SKIP: $file (not found)" -ForegroundColor Gray
    }
}

Write-Host ""
Write-Host "[MOVE] Moving to other documentation folders:" -ForegroundColor Yellow
foreach ($file in $moveFiles.Keys) {
    $sourcePath = Join-Path $SourceFolder $file
    $destFolder = Join-Path $SourceFolder $moveFiles[$file]
    $destPath = Join-Path $destFolder $file
    
    if (Test-Path $sourcePath) {
        if (-not $DryRun) {
            Move-Item -Path $sourcePath -Destination $destPath -Force
        }
        Write-Host "  MOVED: $file -> $($moveFiles[$file])" -ForegroundColor Cyan
    }
    else {
        Write-Host "  SKIP: $file (not found)" -ForegroundColor Gray
    }
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host " CLEANUP SUMMARY" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Files kept in root: $($keepFiles.Count)" -ForegroundColor Green
Write-Host "Files archived: $($archiveMap.Count)" -ForegroundColor Yellow
Write-Host "Files moved to other docs: $($moveFiles.Count)" -ForegroundColor Yellow
Write-Host "Files deleted: $($deleteFiles.Count)" -ForegroundColor Red
Write-Host ""

if ($DryRun) {
    Write-Host "[DRY RUN] Run without -DryRun flag to apply changes" -ForegroundColor Yellow
}
else {
    Write-Host "[SUCCESS] Cleanup complete!" -ForegroundColor Green
    Write-Host ""
    Write-Host "Next steps:" -ForegroundColor Cyan
    Write-Host "  1. Review Archive/ folders if needed" -ForegroundColor White
    Write-Host "  2. Update README.md with new folder structure" -ForegroundColor White
    Write-Host "  3. Add Archive/ to .gitignore if desired" -ForegroundColor White
}

Write-Host ""
