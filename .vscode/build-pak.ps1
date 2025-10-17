# BG3 Modders Multitool - Build PAK Script
# This script packages the mod using BG3 Modders Multitool
# 
# SETUP INSTRUCTIONS:
# 1. Download BG3 Modders Multitool from: https://github.com/ShinyHobo/BG3-Modders-Multitool/releases
# 2. Update the $multiToolPath variable below to point to bg3-modders-multitool.exe
# 3. Press F5 in VS Code to run this script (or use Ctrl+F5 for no debugging)

# ========================================
# CONFIGURATION
# ========================================

# Path to BG3 Modders Multitool executable
# IMPORTANT: Update this path to where you extracted the multitool
$multiToolPath = "C:\Tools\BG3-Modders-Multitool\bg3-modders-multitool.exe"

# Workspace paths
$workspaceRoot = Split-Path -Parent $PSScriptRoot
$sourceFolder = Join-Path $workspaceRoot "Data"
$destinationPak = Join-Path $workspaceRoot "Package\BG3Wow_Latest.pak"

# Package settings
$compressionLevel = 1  # 1 = LZ4 (recommended for BG3 Patch 8)
$packageVersion = "1.0.1.0"  # Update this with each release

# ========================================
# VALIDATION
# ========================================

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "BG3 Warrior Mod - Build PAK" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Check if multitool exists
if (-not (Test-Path $multiToolPath)) {
    Write-Host "ERROR: BG3 Modders Multitool not found at: $multiToolPath" -ForegroundColor Red
    Write-Host ""
    Write-Host "Please download from: https://github.com/ShinyHobo/BG3-Modders-Multitool/releases" -ForegroundColor Yellow
    Write-Host "Then update the `$multiToolPath variable in this script." -ForegroundColor Yellow
    Write-Host ""
    Read-Host "Press Enter to exit"
    exit 1
}

# Check if source folder exists
if (-not (Test-Path $sourceFolder)) {
    Write-Host "ERROR: Source folder not found: $sourceFolder" -ForegroundColor Red
    exit 1
}

# Ensure Package directory exists
$packageDir = Split-Path -Parent $destinationPak
if (-not (Test-Path $packageDir)) {
    New-Item -ItemType Directory -Path $packageDir -Force | Out-Null
}

# ========================================
# BUILD PACKAGE
# ========================================

Write-Host "Configuration:" -ForegroundColor Green
Write-Host "  Multitool:   $multiToolPath"
Write-Host "  Source:      $sourceFolder"
Write-Host "  Destination: $destinationPak"
Write-Host "  Compression: Level $compressionLevel (LZ4)"
Write-Host "  Version:     $packageVersion"
Write-Host ""

Write-Host "Building package..." -ForegroundColor Yellow

# Build the argument list
$arguments = @(
    "-s", "`"$sourceFolder`""
    "-d", "`"$destinationPak`""
    "-c", "$compressionLevel"
)

# Execute multitool
try {
    $process = Start-Process -FilePath $multiToolPath -ArgumentList $arguments -NoNewWindow -Wait -PassThru
    
    if ($process.ExitCode -eq 0) {
        Write-Host ""
        Write-Host "SUCCESS! Package created:" -ForegroundColor Green
        Write-Host "  $destinationPak" -ForegroundColor Cyan
        Write-Host ""
        
        # Show file size
        if (Test-Path $destinationPak) {
            $fileSize = (Get-Item $destinationPak).Length / 1MB
            Write-Host "  Size: $($fileSize.ToString('N2')) MB" -ForegroundColor Cyan
        }
        
        Write-Host ""
        Write-Host "Install Location:" -ForegroundColor Yellow
        Write-Host "  Copy to: %LOCALAPPDATA%\Larian Studios\Baldur's Gate 3\Mods\" -ForegroundColor Gray
        Write-Host ""
    }
    else {
        Write-Host ""
        Write-Host "ERROR: Build failed with exit code $($process.ExitCode)" -ForegroundColor Red
        exit $process.ExitCode
    }
}
catch {
    Write-Host ""
    Write-Host "ERROR: Failed to execute multitool" -ForegroundColor Red
    Write-Host $_.Exception.Message -ForegroundColor Red
    exit 1
}

Write-Host "========================================" -ForegroundColor Cyan
