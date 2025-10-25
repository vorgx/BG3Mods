<#
.SYNOPSIS
    Runs all available template validation tests for transformed mod files.

.DESCRIPTION
    Executes validation tests for FILES 1-2 (currently implemented).
    Future: Will test all 15 critical files once tests are created.

.PARAMETER ModPath
    Root path to mod's Data folder (e.g., "C:\Users\...\BG3Mods\Data")

.PARAMETER StopOnFirstFailure
    If set, stops execution after first failed test (default: false, runs all)

.EXAMPLE
    .\Test-AllFiles.ps1 -ModPath "C:\Users\tenod\source\repos\BG3Mods\Data"

.EXAMPLE
    .\Test-AllFiles.ps1 -ModPath "C:\Users\tenod\source\repos\BG3Mods\Data" -StopOnFirstFailure
#>

param(
    [Parameter(Mandatory=$true, HelpMessage="Path to Data folder")]
    [string]$ModPath,
    
    [Parameter(Mandatory=$false)]
    [switch]$StopOnFirstFailure
)

$ErrorActionPreference = "Continue"
$TestsPath = $PSScriptRoot

Write-Host "`n" -NoNewline
Write-Host "========================================" -ForegroundColor Magenta
Write-Host "   MOD VALIDATION TEST SUITE" -ForegroundColor Magenta
Write-Host "========================================" -ForegroundColor Magenta
Write-Host "Running all available template tests..." -ForegroundColor Cyan
Write-Host ""

$TotalTests = 0
$PassedTests = 0
$FailedTests = 0
$TestResults = @()

# Helper to run test and track results
function Invoke-ValidationTest {
    param(
        [string]$TestName,
        [string]$ScriptPath,
        [hashtable]$Parameters
    )
    
    $script:TotalTests++
    Write-Host "========================================" -ForegroundColor Cyan
    Write-Host "TEST $script:TotalTests: $TestName" -ForegroundColor Cyan
    Write-Host "========================================" -ForegroundColor Cyan
    
    try {
        $result = & $ScriptPath @Parameters
        $exitCode = $LASTEXITCODE
        
        if ($exitCode -eq 0) {
            $script:PassedTests++
            $script:TestResults += [PSCustomObject]@{
                Test = $TestName
                Status = "PASS"
                ExitCode = $exitCode
            }
            Write-Host ""
            return $true
        } else {
            $script:FailedTests++
            $script:TestResults += [PSCustomObject]@{
                Test = $TestName
                Status = "FAIL"
                ExitCode = $exitCode
            }
            Write-Host ""
            return $false
        }
    } catch {
        $script:FailedTests++
        $script:TestResults += [PSCustomObject]@{
            Test = $TestName
            Status = "ERROR"
            ExitCode = -1
            Error = $_.Exception.Message
        }
        Write-Host "ERROR: $($_.Exception.Message)" -ForegroundColor Red
        Write-Host ""
        return $false
    }
}

# Test 1: meta.lsx
$Test1Params = @{
    ModPath = $ModPath
}
$test1Result = Invoke-ValidationTest -TestName "FILE 1: meta.lsx" -ScriptPath (Join-Path $TestsPath "FILE_01_Test-MetaLsx.ps1") -Parameters $Test1Params

if (-not $test1Result -and $StopOnFirstFailure) {
    Write-Host "Stopping after first failure (use -StopOnFirstFailure:`$false to run all tests)" -ForegroundColor Yellow
    exit 1
}

# Extract mod UUID from meta.lsx for next test
$ModsFolders = Get-ChildItem -Path (Join-Path $ModPath "Mods") -Directory -ErrorAction SilentlyContinue
$MetaFile = $ModsFolders | ForEach-Object { Get-ChildItem -Path $_.FullName -Filter "meta.lsx" -File -ErrorAction SilentlyContinue } | Select-Object -First 1

if ($MetaFile) {
    try {
        [xml]$MetaXml = Get-Content $MetaFile.FullName -Raw
        $ModuleInfo = $MetaXml.save.region.node.children.node | Where-Object { $_.id -eq "ModuleInfo" }
        $ModUUID = ($ModuleInfo.attribute | Where-Object { $_.id -eq "UUID" }).value
        $ModFolderName = Split-Path (Split-Path $MetaFile.FullName -Parent) -Leaf
    } catch {
        Write-Host "Warning: Could not extract UUID from meta.lsx for subsequent tests" -ForegroundColor Yellow
    }
}

# Test 2: ClassDescriptions.lsx
if ($ModFolderName) {
    $ClassDescPath = Join-Path $ModPath "Public\$ModFolderName\ClassDescriptions\ClassDescriptions.lsx"
    
    if (Test-Path $ClassDescPath) {
        $Test2Params = @{
            FilePath = $ClassDescPath
        }
        if ($ModUUID) {
            $Test2Params.ExpectedBaseUUID = $ModUUID
        }
        
        $test2Result = Invoke-ValidationTest -TestName "FILE 2: ClassDescriptions.lsx" -ScriptPath (Join-Path $TestsPath "FILE_02_Test-ClassDescriptions.ps1") -Parameters $Test2Params
        
        if (-not $test2Result -and $StopOnFirstFailure) {
            Write-Host "Stopping after first failure" -ForegroundColor Yellow
            exit 1
        }
    } else {
        Write-Host "⚠️  SKIP: ClassDescriptions.lsx not found at: $ClassDescPath" -ForegroundColor Yellow
        Write-Host ""
    }
} else {
    Write-Host "⚠️  SKIP: FILE 2 test (could not determine mod folder)" -ForegroundColor Yellow
    Write-Host ""
}

# FILE 3: ActionResourceDefinitions.lsx
Write-Host "FILE 3: ActionResourceDefinitions.lsx" -ForegroundColor Cyan
if ($ModUUID) {
    $ActionResPath = Join-Path $ModPath "Public\Warrior_Wow_$ModUUID\ActionResourceDefinitions\ActionResourceDefinitions.lsx"
    
    if (Test-Path $ActionResPath) {
        $test3Result = Invoke-ValidationTest -TestName "FILE 3: ActionResourceDefinitions.lsx" `
                               -ScriptPath (Join-Path $TestsPath "FILE_03_Test-ActionResourceDefinitions.ps1") `
                               -Parameters @{ FilePath = $ActionResPath }
        
        if (-not $test3Result -and $StopOnFirstFailure) {
            Write-Host "Stopping after first failure" -ForegroundColor Yellow
            exit 1
        }
    } else {
        Write-Host "⚠️  SKIP: ActionResourceDefinitions.lsx not found at: $ActionResPath" -ForegroundColor Yellow
        Write-Host ""
    }
} else {
    Write-Host "⚠️  SKIP: FILE 3 test (could not determine mod folder)" -ForegroundColor Yellow
    Write-Host ""
}

# FILE 4: Passive charge unlock wiring
if ($ModUUID) {
    $PassivePath = Join-Path $ModPath "Public\Warrior_Wow_$ModUUID\Stats\Generated\Data\Passive.txt"
    $StatusPath = Join-Path $ModPath "Public\Warrior_Wow_$ModUUID\Stats\Generated\Data\Status_BOOST.txt"

    if ((Test-Path $PassivePath) -and (Test-Path $StatusPath)) {
        $test4Result = Invoke-ValidationTest -TestName "FILE 4: Charge unlock passives" `
                               -ScriptPath (Join-Path $TestsPath "FILE_07_Test-ChargeUnlocks.ps1") `
                               -Parameters @{ PassiveFilePath = $PassivePath; StatusFilePath = $StatusPath }

        if (-not $test4Result -and $StopOnFirstFailure) {
            Write-Host "Stopping after first failure" -ForegroundColor Yellow
            exit 1
        }
    } else {
        Write-Host "⚠️  SKIP: Passive.txt or Status_BOOST.txt not found for charge unlock audit" -ForegroundColor Yellow
        Write-Host ""
    }
} else {
    Write-Host "⚠️  SKIP: FILE 4 test (could not determine mod folder)" -ForegroundColor Yellow
    Write-Host ""
}

# FILE 12: SpellLists.lsx
if ($ModUUID) {
    $SpellListsPath = Join-Path $ModPath "Public\Warrior_Wow_$ModUUID\Lists\SpellLists.lsx"
    
    if (Test-Path $SpellListsPath) {
        $test12Result = Invoke-ValidationTest -TestName "FILE 12: SpellLists.lsx" `
                               -ScriptPath (Join-Path $TestsPath "Test-SpellLists.ps1") `
                               -Parameters @{ FilePath = $SpellListsPath }
        
        if (-not $test12Result -and $StopOnFirstFailure) {
            Write-Host "Stopping after first failure" -ForegroundColor Yellow
            exit 1
        }
    } else {
        Write-Host "⚠️  SKIP: SpellLists.lsx not found at: $SpellListsPath" -ForegroundColor Yellow
        Write-Host ""
    }
} else {
    Write-Host "⚠️  SKIP: FILE 12 test (could not determine mod folder)" -ForegroundColor Yellow
    Write-Host ""
}

# FILE 13: PassiveLists.lsx
if ($ModUUID) {
    $PassiveListsPath = Join-Path $ModPath "Public\Warrior_Wow_$ModUUID\Lists\PassiveLists.lsx"
    
    if (Test-Path $PassiveListsPath) {
        $test13Result = Invoke-ValidationTest -TestName "FILE 13: PassiveLists.lsx" `
                               -ScriptPath (Join-Path $TestsPath "Test-PassiveLists.ps1") `
                               -Parameters @{ FilePath = $PassiveListsPath }
        
        if (-not $test13Result -and $StopOnFirstFailure) {
            Write-Host "Stopping after first failure" -ForegroundColor Yellow
            exit 1
        }
    } else {
        Write-Host "⚠️  SKIP: PassiveLists.lsx not found at: $PassiveListsPath" -ForegroundColor Yellow
        Write-Host ""
    }
} else {
    Write-Host "⚠️  SKIP: FILE 13 test (could not determine mod folder)" -ForegroundColor Yellow
    Write-Host ""
}

# Future tests placeholder
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "PENDING TESTS (Not Yet Implemented):" -ForegroundColor Yellow
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  FILES 4-10: Stats/*.txt files" -ForegroundColor Gray
Write-Host "  FILE 11: Progressions.lsx (CRITICAL)" -ForegroundColor Gray
Write-Host "  FILE 12: Localization/English.loca.xml" -ForegroundColor Gray
Write-Host "  FILES 13-15: Lists, Script Extender" -ForegroundColor Gray
Write-Host ""
Write-Host "Create additional Test-*.ps1 scripts as more files are transformed." -ForegroundColor Gray
Write-Host ""

# Final Summary
Write-Host "========================================" -ForegroundColor Magenta
Write-Host "   FINAL RESULTS" -ForegroundColor Magenta
Write-Host "========================================" -ForegroundColor Magenta
Write-Host ""

# Results table
$TestResults | Format-Table -AutoSize

# Summary
Write-Host "Total Tests:  $TotalTests" -ForegroundColor Cyan
Write-Host "Passed:       " -NoNewline
Write-Host "$PassedTests" -ForegroundColor Green
Write-Host "Failed:       " -NoNewline
if ($FailedTests -gt 0) {
    Write-Host "$FailedTests" -ForegroundColor Red
} else {
    Write-Host "$FailedTests" -ForegroundColor Green
}
Write-Host ""

if ($FailedTests -eq 0) {
    Write-Host "✅ ALL TESTS PASSED!" -ForegroundColor Green
    Write-Host "Your mod transformation follows the template patterns correctly." -ForegroundColor Green
    Write-Host "You can now proceed with custom tweaks if desired." -ForegroundColor Cyan
    Write-Host ""
    exit 0
} else {
    Write-Host "❌ SOME TESTS FAILED" -ForegroundColor Red
    Write-Host "Review failures above and fix issues before proceeding." -ForegroundColor Yellow
    Write-Host "See: Documentation\08_TransformationTemplates\*.md for guidance" -ForegroundColor Yellow
    Write-Host ""
    exit 1
}
