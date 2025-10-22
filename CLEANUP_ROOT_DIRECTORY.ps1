########################################
# ROOT DIRECTORY CLEANUP SCRIPT
########################################
# Purpose: Organize root directory to essential files only
# Date: October 21, 2025
# Usage: .\CLEANUP_ROOT_DIRECTORY.ps1 [-DryRun]

param(
    [switch]$DryRun
)

# Color output helpers (NO Unicode!)
function Write-Pass { param($Message) Write-Host "[KEEP] $Message" -ForegroundColor Green }
function Write-Archive { param($Message) Write-Host "[MOVE] $Message" -ForegroundColor Yellow }
function Write-Delete { param($Message) Write-Host "[DELETE] $Message" -ForegroundColor Red }
function Write-Info { param($Message) Write-Host "[INFO] $Message" -ForegroundColor Cyan }
function Write-Create { param($Message) Write-Host "[CREATE] $Message" -ForegroundColor Magenta }

# Header
Write-Host ""
Write-Host "========================================"
Write-Host " CLEANUP: ROOT DIRECTORY"
Write-Host "========================================"
Write-Host ""

if ($DryRun) {
    Write-Host "[DRY RUN MODE] No files will be moved/deleted" -ForegroundColor Yellow
    Write-Host ""
}

# Define root path
$RootPath = $PSScriptRoot

# Files to KEEP in root
$KeepFiles = @(
    "README.md",
    "INDEX.md",
    "BG3Mods.code-workspace",
    "settings.json",
    "CLEANUP_SOURCE_OF_TRUTH.ps1",
    "CLEANUP_ROOT_DIRECTORY.ps1"
)

# Define destination folders and their files
$MoveMap = @{
    # Session Summaries
    "Documentation\10_SessionSummaries" = @(
        "ENRICHMENT_COMPLETE_SUMMARY.md",
        "ENRICHMENT_STATUS_REPORT.md",
        "ENRICHMENT_STRATEGY_PIVOT.md",
        "HANDOVER_ABILITY_DATABASE_OCT20.md",
        "HANDOVER_NEXT_SESSION_OCT21.md"
    )
    
    # Planning Documents (Archive)
    "Documentation\00_SourcesOfTruth\Archive\PlanningDocuments" = @(
        "EXCEL_COMPLETE_BREAKDOWN_OCT20.md",
        "EXCEL_CSV_FINAL_SCAN_OCT20.md",
        "EXCEL_CSV_SCAN_REPORT_OCT20.md",
        "SOURCE_OF_TRUTH_UPDATES_REQUIRED_OCT20.md"
    )
    
    # Enrichment Batches (Archive)
    "Documentation\00_SourcesOfTruth\Archive\EnrichmentBatches" = @(
        "FULL_ENRICHMENT_STRATEGY.md"
    )
    
    # Project Documents
    "Documentation\06_ProjectDocuments" = @(
        "ABILITY_DATABASE_QUICK_REF.md"
    )
    
    # Database Scripts
    "Scripts\Database" = @(
        "CREATE_ABILITY_DATABASE.ps1",
        "CLEANUP_ABILITY_DATABASE.ps1",
        "FIX_CLASSIFICATION.ps1"
    )
    
    # Enrichment Scripts
    "Scripts\Enrichment" = @(
        "AUTO_ENRICH_PASSIVES.ps1",
        "COMPREHENSIVE_WOW_ENRICHMENT.ps1",
        "ENRICH_BATCH_OFFENSIVE.ps1",
        "ENRICH_BATCH_OFFENSIVE_2.ps1",
        "ENRICH_FINAL_BATCH.ps1",
        "ENRICH_FROM_SOURCE_OF_TRUTH.ps1",
        "ENRICH_MANUAL_WORKFLOW.ps1",
        "ENRICH_WOW_DATA.ps1",
        "PARSE_ICYVEINS_HTML.ps1",
        "PARSE_ICYVEINS_SIMPLE.ps1"
    )
}

# Files to DELETE
$DeleteFiles = @(
    "temp_lightning_strikes.txt",
    "temp_slayer_extract.txt",
    "temp_snippet.txt",
    "ROOT_CLEANUP_ANALYSIS.md"  # This analysis doc itself
)

# Create destination folders
foreach ($folder in $MoveMap.Keys) {
    $fullPath = Join-Path $RootPath $folder
    if (-not (Test-Path $fullPath)) {
        if ($DryRun) {
            Write-Create "Would create folder: $folder"
        } else {
            New-Item -Path $fullPath -ItemType Directory -Force | Out-Null
            Write-Create $folder
        }
    }
}

Write-Host ""

# Show files being kept
Write-Info "Files remaining in root:"
foreach ($file in $KeepFiles) {
    Write-Pass "  - $file"
}

Write-Host ""

# Move files
Write-Info "Moving files to organized locations:"
$moveCount = 0
foreach ($destination in $MoveMap.Keys) {
    foreach ($file in $MoveMap[$destination]) {
        $sourcePath = Join-Path $RootPath $file
        if (Test-Path $sourcePath) {
            $destPath = Join-Path $RootPath $destination
            $destFile = Join-Path $destPath $file
            
            if ($DryRun) {
                Write-Archive "  $file -> $destination"
            } else {
                Move-Item -Path $sourcePath -Destination $destFile -Force
                Write-Archive "  MOVED: $file -> $destination"
            }
            $moveCount++
        }
    }
}

Write-Host ""

# Delete temp files
Write-Info "Removing temp files:"
$deleteCount = 0
foreach ($file in $DeleteFiles) {
    $filePath = Join-Path $RootPath $file
    if (Test-Path $filePath) {
        if ($DryRun) {
            Write-Delete "  Would delete: $file"
        } else {
            try {
                Remove-Item -Path $filePath -Force
                Write-Delete "  DELETED: $file"
            } catch {
                Write-Host "  [ERROR] Could not delete $file : $($_.Exception.Message)" -ForegroundColor Red
            }
        }
        $deleteCount++
    }
}

Write-Host ""
Write-Host "========================================"
Write-Host " CLEANUP SUMMARY"
Write-Host "========================================"
Write-Host ""
Write-Host "Files kept in root: $($KeepFiles.Count)" -ForegroundColor Green
Write-Host "Files moved: $moveCount" -ForegroundColor Yellow
Write-Host "Files deleted: $deleteCount" -ForegroundColor Red
Write-Host ""

if ($DryRun) {
    Write-Host "[DRY RUN] Run without -DryRun flag to apply changes" -ForegroundColor Yellow
} else {
    Write-Host "[SUCCESS] Cleanup complete!" -ForegroundColor Green
    Write-Host ""
    Write-Host "Next steps:" -ForegroundColor Cyan
    Write-Host "  1. Verify root directory is clean" -ForegroundColor Cyan
    Write-Host "  2. Check Scripts/Database/ and Scripts/Enrichment/ folders" -ForegroundColor Cyan
    Write-Host "  3. Verify Documentation/ folders have new files" -ForegroundColor Cyan
}

Write-Host ""
