# ARCHIVE_PACKAGES.ps1
# Automates archival of older BG3Wow mod package versions
# Follows retention policy: Keep latest 2 in root, move others to Archive/

param(
    [switch]$WhatIf  # Dry-run mode: shows what would be moved without actually moving files
)

# Color-coded output
function Write-Header { param($text) Write-Host "`n=== $text ===" -ForegroundColor Cyan }
function Write-Success { param($text) Write-Host "[OK] $text" -ForegroundColor Green }
function Write-Warning { param($text) Write-Host "[WARN] $text" -ForegroundColor Yellow }
function Write-Error { param($text) Write-Host "[ERROR] $text" -ForegroundColor Red }

Write-Header "BG3Wow Package Archival Script"

if ($WhatIf) {
    Write-Warning "DRY-RUN MODE: No files will be moved. Use without -WhatIf to execute."
}

# Define Package root
$PackageRoot = $PSScriptRoot
$ArchiveRoot = Join-Path $PackageRoot "Archive"

# Verify Archive/ structure exists
if (-not (Test-Path $ArchiveRoot)) {
    Write-Error "Archive/ folder not found at: $ArchiveRoot"
    Write-Host "Run this command first: New-Item -ItemType Directory -Path '$ArchiveRoot'"
    exit 1
}

# Define archival mappings: SourceFile -> DestinationFolder
# Format: @{ "BG3Wow_vX.X.X.X[_SUFFIX].pak" = "Archive/vX.X.X.X/" }
$ArchiveMap = @{
    "BG3Wow_v1.0.0.0.pak" = "Archive\v1.0.0.0"
    "BG3Wow_v1.0.0.1_FIXED.pak" = "Archive\v1.0.0.1"
    "BG3Wow_v1.0.0.2_SE.pak" = "Archive\v1.0.0.2"
    "BG3Wow_v1.0.0.3_LOCFIX.pak" = "Archive\v1.0.0.3"
}

# Files to KEEP in Package/ root (never archive these)
$KeepInRoot = @(
    "BG3Wow_Latest.pak",           # Current version symlink
    "CHANGELOG.md",                # Version history
    "RETENTION_POLICY.md",         # This policy document
    "ARCHIVE_PACKAGES.ps1",        # This script
    "INSTALL_GUIDE.md",            # User documentation
    "README.md",                   # Package folder README
    "Package.pak"                  # Legacy filename (if exists)
)

# Function to archive a single file
function Move-PackageToArchive {
    param(
        [string]$SourceFile,
        [string]$DestinationFolder
    )
    
    $SourcePath = Join-Path $PackageRoot $SourceFile
    $DestinationPath = Join-Path $PackageRoot $DestinationFolder
    
    # Check if source file exists
    if (-not (Test-Path $SourcePath)) {
        Write-Warning "Source file not found (already archived?): $SourceFile"
        return
    }
    
    # Check if destination folder exists
    if (-not (Test-Path $DestinationPath)) {
        Write-Warning "Destination folder missing: $DestinationFolder"
        Write-Host "  Creating folder: $DestinationPath"
        if (-not $WhatIf) {
            New-Item -ItemType Directory -Path $DestinationPath -Force | Out-Null
        }
    }
    
    # Check if file already exists in archive
    $DestinationFile = Join-Path $DestinationPath (Split-Path $SourceFile -Leaf)
    if (Test-Path $DestinationFile) {
        Write-Warning "File already exists in archive: $DestinationFile"
        Write-Host "  Skipping (use manual cleanup if duplicate)"
        return
    }
    
    # Move file
    try {
        if ($WhatIf) {
            Write-Host "[DRY-RUN] Would move: $SourceFile -> $DestinationFolder" -ForegroundColor Magenta
        } else {
            Move-Item -Path $SourcePath -Destination $DestinationPath -Force
            Write-Success "Moved: $SourceFile -> $DestinationFolder"
        }
    } catch {
        Write-Error "Failed to move $SourceFile : $_"
    }
}

# Execute archival for mapped files
Write-Header "Archiving Mapped Versions"
foreach ($SourceFile in $ArchiveMap.Keys) {
    $DestinationFolder = $ArchiveMap[$SourceFile]
    Move-PackageToArchive -SourceFile $SourceFile -DestinationFolder $DestinationFolder
}

# Report current Package/ root contents
Write-Header "Current Package/ Root Contents"
$RootFiles = Get-ChildItem -Path $PackageRoot -Filter "*.pak" -File | Select-Object -ExpandProperty Name

if ($RootFiles.Count -eq 0) {
    Write-Warning "No .pak files found in Package/ root"
} else {
    Write-Host "Files remaining in Package/ root:"
    foreach ($File in $RootFiles) {
        if ($KeepInRoot -contains $File) {
            Write-Host "  [KEEP] $File" -ForegroundColor Green
        } else {
            Write-Warning "  [REVIEW] $File (not in KeepInRoot list - manual decision needed)"
        }
    }
}

# Report Archive/ contents
Write-Header "Archive/ Contents"
$ArchiveFolders = Get-ChildItem -Path $ArchiveRoot -Directory | Select-Object -ExpandProperty Name

if ($ArchiveFolders.Count -eq 0) {
    Write-Warning "No version folders found in Archive/"
} else {
    foreach ($Folder in $ArchiveFolders) {
        $FolderPath = Join-Path $ArchiveRoot $Folder
        $PakCount = (Get-ChildItem -Path $FolderPath -Filter "*.pak" -File).Count
        Write-Host "  $Folder : $PakCount .pak file(s)" -ForegroundColor Cyan
    }
}

# Summary
Write-Header "Archival Summary"
if ($WhatIf) {
    Write-Warning "DRY-RUN COMPLETE: No files were moved. Review output above."
    Write-Host "`nTo execute archival, run: .\ARCHIVE_PACKAGES.ps1" -ForegroundColor Yellow
} else {
    Write-Success "Archival complete! Review Archive/ folders for moved files."
    Write-Host "`nNext steps:"
    Write-Host "  1. Verify BG3Wow_Latest.pak is current version"
    Write-Host "  2. Update CHANGELOG.md with archive dates"
    Write-Host "  3. Test package installation: Copy BG3Wow_Latest.pak to game Mods/ folder"
    Write-Host "  4. Review [REVIEW] files above for manual archival decision"
}

Write-Host ""
