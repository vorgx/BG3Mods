# BG3 Modders Multitool - Unpack PAK Script
# This script unpacks a PAK file for inspection/editing
# 
# USAGE:
# 1. Update $pakToUnpack to point to the PAK file you want to extract
# 2. Run this script (F5 in VS Code if configured in launch.json)

# ========================================
# CONFIGURATION
# ========================================

# Path to BG3 Modders Multitool executable
$multiToolPath = "C:\Tools\BG3-Modders-Multitool\bg3-modders-multitool.exe"

# PAK file to unpack
$pakToUnpack = Join-Path (Split-Path -Parent $PSScriptRoot) "Package\BG3Wow_Latest.pak"

# Output directory (will create if doesn't exist)
$outputFolder = Join-Path (Split-Path -Parent $PSScriptRoot) "Tests\UnpackedMod"

# ========================================
# VALIDATION
# ========================================

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "BG3 Warrior Mod - Unpack PAK" -ForegroundColor Cyan
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

# Check if PAK file exists
if (-not (Test-Path $pakToUnpack)) {
    Write-Host "ERROR: PAK file not found: $pakToUnpack" -ForegroundColor Red
    Write-Host ""
    Write-Host "Please update the `$pakToUnpack variable in this script." -ForegroundColor Yellow
    exit 1
}

# Ensure output directory exists
if (-not (Test-Path $outputFolder)) {
    New-Item -ItemType Directory -Path $outputFolder -Force | Out-Null
}

# ========================================
# UNPACK PAK
# ========================================

Write-Host "Configuration:" -ForegroundColor Green
Write-Host "  Multitool:     $multiToolPath"
Write-Host "  PAK File:      $pakToUnpack"
Write-Host "  Output Folder: $outputFolder"
Write-Host ""

Write-Host "Unpacking PAK file..." -ForegroundColor Yellow

# Build the argument list for unpacking
$arguments = @(
    "-s", "`"$pakToUnpack`""
    "-d", "`"$outputFolder`""
)

# Execute multitool
try {
    $process = Start-Process -FilePath $multiToolPath -ArgumentList $arguments -NoNewWindow -Wait -PassThru
    
    if ($process.ExitCode -eq 0) {
        Write-Host ""
        Write-Host "SUCCESS! PAK unpacked to:" -ForegroundColor Green
        Write-Host "  $outputFolder" -ForegroundColor Cyan
        Write-Host ""
    }
    else {
        Write-Host ""
        Write-Host "ERROR: Unpack failed with exit code $($process.ExitCode)" -ForegroundColor Red
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
