# Test-ActionResourceDefinitions.ps1
# Validates FILE 3 transformation: ActionResourceDefinitions.lsx
# Tests 6 Warrior resources with correct max values, replenish types, and UUIDs

param(
    [Parameter(Mandatory=$false)]
    [string]$FilePath = "C:\Users\tenod\source\repos\BG3Mods\Data\Public\Warrior_Wow_78fe4967-4e62-5491-d981-dd781acca4d7\ActionResourceDefinitions\ActionResourceDefinitions.lsx"
)

# Color output helpers (NO Unicode!)
function Write-Pass { param($Message) Write-Host "[PASS] $Message" -ForegroundColor Green }
function Write-Fail { param($Message) Write-Host "[FAIL] $Message" -ForegroundColor Red; $script:FailCount++ }
function Write-Warn { param($Message) Write-Host "[WARN] $Message" -ForegroundColor Yellow }
function Write-Info { param($Message) Write-Host "[INFO] $Message" -ForegroundColor Cyan }

$script:FailCount = 0

Write-Host "`n=== FILE 3: ActionResourceDefinitions.lsx Validation ===" -ForegroundColor Cyan
Write-Info "File: $FilePath"

# Test 1: File exists
if (-not (Test-Path $FilePath)) {
    Write-Fail "File not found: $FilePath"
    exit 1
}
Write-Pass "File exists"

# Test 2: Parse XML (strip multi-line comments first)
try {
    $RawContent = Get-Content $FilePath -Raw
    $CleanedContent = $RawContent -replace '(?s)<!--.*?-->', ''
    [xml]$Xml = $CleanedContent
    Write-Pass "XML parses without errors"
} catch {
    Write-Fail "XML parse error: $_"
    exit 1
}

# Test 3: Verify region ID
$Region = $Xml.save.region
if ($Region.id -eq "ActionResourceDefinitions") {
    Write-Pass "Region ID correct: ActionResourceDefinitions"
} else {
    Write-Fail "Region ID incorrect: expected 'ActionResourceDefinitions', got '$($Region.id)'"
}

# Test 4: Count resources (should be exactly 6)
$Resources = $Xml.save.region.node.children.node
Write-Info "Found $($Resources.Count) resource(s)"
if ($Resources.Count -eq 6) {
    Write-Pass "Correct resource count: 6"
} else {
    Write-Fail "Resource count mismatch: expected 6, got $($Resources.Count)"
}

# Test 5: Validate each resource (name, max, replenish, UUID)
$ExpectedResources = @(
    @{ Name="Rage"; Max=100; Replenish="Default"; UUID="a1b2c3d4-e5f6-7a8b-9c0d-1e2f3a4b5c6d" },
    @{ Name="DefensiveCharge"; Max=1; Replenish="Rest"; UUID="e7f8a9b0-1c2d-3e4f-5a6b-7c8d9e0f1a2b" },
    @{ Name="TankCooldown"; Max=1; Replenish="Rest"; UUID="b3c4d5e6-f7a8-9b0c-1d2e-3f4a5b6c7d8e" },
    @{ Name="MobilityCharge"; Max=2; Replenish="ShortRest"; UUID="c9d8e7f6-5a4b-3c2d-1e0f-9b8a7c6d5e4f" },
    @{ Name="OverpowerCharge"; Max=2; Replenish="Default"; UUID="d1e2f3a4-b5c6-7d8e-9f0a-1b2c3d4e5f6a" },
    @{ Name="ThunderCharge"; Max=3; Replenish="Default"; UUID="e5f6a7b8-c9d0-1e2f-3a4b-5c6d7e8f9a0b" }
)

foreach ($Expected in $ExpectedResources) {
    $Resource = $Resources | Where-Object { 
        $_.attribute | Where-Object { $_.id -eq "Name" -and $_.value -eq $Expected.Name }
    }
    
    if (-not $Resource) {
        Write-Fail "Resource not found: $($Expected.Name)"
        continue
    }
    
    Write-Info "`nValidating: $($Expected.Name)"
    
    # Check Name
    $Name = ($Resource.attribute | Where-Object { $_.id -eq "Name" }).value
    if ($Name -eq $Expected.Name) {
        Write-Pass "  Name: $Name"
    } else {
        Write-Fail "  Name mismatch: expected '$($Expected.Name)', got '$Name'"
    }
    
    # Check MaxValue
    $MaxValue = ($Resource.attribute | Where-Object { $_.id -eq "MaxValue" }).value
    if ($MaxValue -eq $Expected.Max) {
        Write-Pass "  MaxValue: $MaxValue"
    } else {
        Write-Fail "  MaxValue mismatch: expected $($Expected.Max), got $MaxValue"
    }
    
    # Check ReplenishType
    $Replenish = ($Resource.attribute | Where-Object { $_.id -eq "ReplenishType" }).value
    if ($Replenish -eq $Expected.Replenish) {
        Write-Pass "  ReplenishType: $Replenish"
    } else {
        Write-Fail "  ReplenishType mismatch: expected '$($Expected.Replenish)', got '$Replenish'"
    }
    
    # Check UUID
    $UUID = ($Resource.attribute | Where-Object { $_.id -eq "UUID" }).value
    if ($UUID -eq $Expected.UUID) {
        Write-Pass "  UUID: $UUID"
    } else {
        Write-Fail "  UUID mismatch: expected '$($Expected.UUID)', got '$UUID'"
    }
    
    # Check ShowOnActionResourcePanel (should be true for all)
    $ShowPanel = ($Resource.attribute | Where-Object { $_.id -eq "ShowOnActionResourcePanel" }).value
    if ($ShowPanel -eq "true") {
        Write-Pass "  ShowOnActionResourcePanel: true"
    } else {
        Write-Fail "  ShowOnActionResourcePanel not set to true"
    }
}

# Test 6: No leftover Warlock resources
$WarlockResourceNames = @("SoulShard", "Soulfire", "DemonicCore", "Havoc", "TormentedCrescendo", 
                          "TormentedSoul", "BloodInvocation", "SoulShardFragment", "FireandBrimstone", "DeathBolt")

$FoundWarlock = $false
foreach ($WarlockName in $WarlockResourceNames) {
    $Found = $Resources | Where-Object { 
        $_.attribute | Where-Object { $_.id -eq "Name" -and $_.value -eq $WarlockName }
    }
    if ($Found) {
        Write-Fail "Leftover Warlock resource found: $WarlockName"
        $FoundWarlock = $true
    }
}

if (-not $FoundWarlock) {
    Write-Pass "No leftover Warlock resources"
}

# Test 7: Valid ReplenishType values only
$ValidReplenishTypes = @("Combat", "ShortRest", "Rest", "Proc", "Default")
$AllValid = $true
foreach ($Resource in $Resources) {
    $Replenish = ($Resource.attribute | Where-Object { $_.id -eq "ReplenishType" }).value
    if ($Replenish -notin $ValidReplenishTypes) {
        Write-Fail "Invalid ReplenishType '$Replenish' found (must be Combat, ShortRest, Rest, Proc, or Default)"
        $AllValid = $false
    }
}
if ($AllValid) {
    Write-Pass "All ReplenishType values are valid"
}

# Test 8: Localization handles present
$AllHandlesPresent = $true
foreach ($Resource in $Resources) {
    $Name = ($Resource.attribute | Where-Object { $_.id -eq "Name" }).value
    $DisplayHandle = ($Resource.attribute | Where-Object { $_.id -eq "DisplayName" }).handle
    $DescHandle = ($Resource.attribute | Where-Object { $_.id -eq "Description" }).handle
    
    if (-not $DisplayHandle) {
        Write-Fail "$Name missing DisplayName handle"
        $AllHandlesPresent = $false
    }
    if (-not $DescHandle) {
        Write-Fail "$Name missing Description handle"
        $AllHandlesPresent = $false
    }
}
if ($AllHandlesPresent) {
    Write-Pass "All resources have DisplayName and Description handles"
}

# Summary
Write-Host "`n=== TEST SUMMARY ===" -ForegroundColor Cyan
if ($script:FailCount -eq 0) {
    Write-Host "ALL TESTS PASSED" -ForegroundColor Green
    exit 0
} else {
    Write-Host "$($script:FailCount) TEST(S) FAILED" -ForegroundColor Red
    exit 1
}
