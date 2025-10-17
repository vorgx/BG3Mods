<#
.SYNOPSIS
    Master test/validation runner for BG3Wow mod project

.DESCRIPTION
    Kicks off all tests and validation scripts in the Tests/ folder.
    Runs in order: structure validation, file integrity checks, and migration tests.
    
.PARAMETER SkipValidation
    Skip the mod structure validation
    
.PARAMETER SkipMigration
    Skip the migration tests
    
.PARAMETER Verbose
    Show detailed output from each test
    
.EXAMPLE
    .\RUN_ALL_TESTS.ps1
    Run all tests with standard output
    
.EXAMPLE
    .\RUN_ALL_TESTS.ps1 -Verbose
    Run all tests with detailed output
    
.EXAMPLE
    .\RUN_ALL_TESTS.ps1 -SkipMigration
    Run only validation tests, skip migration
#>

[CmdletBinding()]
param(
    [switch]$SkipValidation,
    [switch]$SkipMigration,
    [switch]$Verbose
)

$ErrorActionPreference = "Continue"

# Get paths
$ProjectRoot = Split-Path -Parent $PSScriptRoot
$ScriptsFolder = Join-Path $ProjectRoot "Scripts"
$ToolsFolder = Join-Path $PSScriptRoot "Tools"

Write-Host "`n================================================================" -ForegroundColor Cyan
Write-Host "  BG3WOW MOD - COMPREHENSIVE TEST SUITE" -ForegroundColor White
Write-Host "================================================================`n" -ForegroundColor Cyan

$TestResults = @()
$StartTime = Get-Date

# TEST 1: Mod Structure Validation
if (-not $SkipValidation) {
    Write-Host "[1/2] Running Mod Structure Validation..." -ForegroundColor Yellow
    Write-Host "      Script: Scripts\validate_mod_structure.ps1" -ForegroundColor Gray
    
    $ValidationScript = Join-Path $ScriptsFolder "validate_mod_structure.ps1"
    
    if (Test-Path $ValidationScript) {
        try {
            $ValidateStart = Get-Date
            
            if ($Verbose) {
                & $ValidationScript
            } else {
                $Output = & $ValidationScript 2>&1
                # Show only summary/errors
                $Output | Where-Object { $_ -match "ERROR|WARNING|PASSED|FAILED|✓|✗" } | ForEach-Object {
                    Write-Host "      $_" -ForegroundColor White
                }
            }
            
            $ValidateEnd = Get-Date
            $ValidateDuration = ($ValidateEnd - $ValidateStart).TotalSeconds
            
            if ($LASTEXITCODE -eq 0) {
                Write-Host "      ✓ Validation PASSED ($([math]::Round($ValidateDuration, 2))s)" -ForegroundColor Green
                $TestResults += [PSCustomObject]@{
                    Test = "Mod Structure Validation"
                    Result = "PASSED"
                    Duration = "$([math]::Round($ValidateDuration, 2))s"
                }
            } else {
                Write-Host "      ✗ Validation FAILED ($([math]::Round($ValidateDuration, 2))s)" -ForegroundColor Red
                $TestResults += [PSCustomObject]@{
                    Test = "Mod Structure Validation"
                    Result = "FAILED"
                    Duration = "$([math]::Round($ValidateDuration, 2))s"
                }
            }
        }
        catch {
            Write-Host "      ✗ Validation ERROR: $_" -ForegroundColor Red
            $TestResults += [PSCustomObject]@{
                Test = "Mod Structure Validation"
                Result = "ERROR"
                Duration = "N/A"
            }
        }
    } else {
        Write-Host "      ! Validation script not found at: $ValidationScript" -ForegroundColor Yellow
        $TestResults += [PSCustomObject]@{
            Test = "Mod Structure Validation"
            Result = "SKIPPED"
            Duration = "N/A"
        }
    }
    Write-Host ""
} else {
    Write-Host "[1/2] Mod Structure Validation - SKIPPED" -ForegroundColor Gray
    Write-Host ""
}

# TEST 2: Migration Tests
if (-not $SkipMigration) {
    Write-Host "[2/2] Running Migration Tests..." -ForegroundColor Yellow
    Write-Host "      Script: Tests\Tools\MIGRATE_TESTS.ps1" -ForegroundColor Gray
    
    $MigrationScript = Join-Path $ToolsFolder "MIGRATE_TESTS.ps1"
    
    if (Test-Path $MigrationScript) {
        try {
            $MigrateStart = Get-Date
            
            if ($Verbose) {
                & $MigrationScript
            } else {
                $Output = & $MigrationScript 2>&1
                # Show only summary/errors
                $Output | Where-Object { $_ -match "ERROR|WARNING|PASSED|FAILED|Migrated|✓|✗" } | ForEach-Object {
                    Write-Host "      $_" -ForegroundColor White
                }
            }
            
            $MigrateEnd = Get-Date
            $MigrateDuration = ($MigrateEnd - $MigrateStart).TotalSeconds
            
            if ($LASTEXITCODE -eq 0) {
                Write-Host "      ✓ Migration Tests PASSED ($([math]::Round($MigrateDuration, 2))s)" -ForegroundColor Green
                $TestResults += [PSCustomObject]@{
                    Test = "Migration Tests"
                    Result = "PASSED"
                    Duration = "$([math]::Round($MigrateDuration, 2))s"
                }
            } else {
                Write-Host "      ✗ Migration Tests FAILED ($([math]::Round($MigrateDuration, 2))s)" -ForegroundColor Red
                $TestResults += [PSCustomObject]@{
                    Test = "Migration Tests"
                    Result = "FAILED"
                    Duration = "$([math]::Round($MigrateDuration, 2))s"
                }
            }
        }
        catch {
            Write-Host "      ✗ Migration ERROR: $_" -ForegroundColor Red
            $TestResults += [PSCustomObject]@{
                Test = "Migration Tests"
                Result = "ERROR"
                Duration = "N/A"
            }
        }
    } else {
        Write-Host "      ! Migration script not found at: $MigrationScript" -ForegroundColor Yellow
        $TestResults += [PSCustomObject]@{
            Test = "Migration Tests"
            Result = "SKIPPED"
            Duration = "N/A"
        }
    }
    Write-Host ""
} else {
    Write-Host "[2/2] Migration Tests - SKIPPED" -ForegroundColor Gray
    Write-Host ""
}

# FINAL SUMMARY
$EndTime = Get-Date
$TotalDuration = ($EndTime - $StartTime).TotalSeconds

Write-Host "================================================================" -ForegroundColor Cyan
Write-Host "  TEST SUMMARY" -ForegroundColor White
Write-Host "================================================================" -ForegroundColor Cyan

$TestResults | Format-Table -AutoSize

$PassedCount = ($TestResults | Where-Object { $_.Result -eq "PASSED" }).Count
$FailedCount = ($TestResults | Where-Object { $_.Result -eq "FAILED" -or $_.Result -eq "ERROR" }).Count
$SkippedCount = ($TestResults | Where-Object { $_.Result -eq "SKIPPED" }).Count

Write-Host "Total Duration: $([math]::Round($TotalDuration, 2))s" -ForegroundColor White
Write-Host "Tests Passed:   $PassedCount" -ForegroundColor Green
Write-Host "Tests Failed:   $FailedCount" -ForegroundColor $(if ($FailedCount -gt 0) { "Red" } else { "Gray" })
Write-Host "Tests Skipped:  $SkippedCount" -ForegroundColor Gray

Write-Host "`n================================================================`n" -ForegroundColor Cyan

# Exit code: 0 if all tests passed, 1 if any failed
if ($FailedCount -gt 0) {
    exit 1
} else {
    exit 0
}
