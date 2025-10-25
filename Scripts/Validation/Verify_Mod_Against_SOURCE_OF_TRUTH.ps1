# ============================================================================
# COMPREHENSIVE MOD VERIFICATION AGAINST SOURCE OF TRUTH
# ============================================================================
# Purpose: Verify all mod files match requirements in SOURCE_OF_TRUTH.md
# Date: October 24, 2025
# ============================================================================

param(
    [string]$ModPath = "C:\Users\tenod\source\repos\BG3Mods\Data"
)

# Color output functions (NO Unicode!)
function Write-Pass { param($Message) Write-Host "[PASS] $Message" -ForegroundColor Green }
function Write-Fail { param($Message) Write-Host "[FAIL] $Message" -ForegroundColor Red; $script:FailCount++ }
function Write-Warn { param($Message) Write-Host "[WARN] $Message" -ForegroundColor Yellow; $script:WarnCount++ }
function Write-Info { param($Message) Write-Host "[INFO] $Message" -ForegroundColor Cyan }
function Write-Section { param($Message) Write-Host "`n=== $Message ===" -ForegroundColor Magenta }

$script:FailCount = 0
$script:WarnCount = 0

# Expected values from SOURCE_OF_TRUTH.md
$EXPECTED_MOD_UUID = "78fe4967-4e62-5491-d981-dd781acca4d7"
$EXPECTED_FOLDER_NAME = "Warrior_Wow_78fe4967-4e62-5491-d981-dd781acca4d7"
$EXPECTED_MOD_NAME = "BG3Wow - World of Warcraft Warrior Class for Baldur's Gate 3"
$EXPECTED_VERSION64 = "36028797018963968"
$EXPECTED_BASE_CLASS_UUID = "78fe4967-4e62-5491-d981-dd781acca4d7"
$EXPECTED_CLASS_NAME = "WoWWarrior"

# Expected ProgressionTableUUIDs from SOURCE_OF_TRUTH.md Section [1]
$EXPECTED_PROGRESSIONS = @{
    "WoWWarrior" = "4f5d1434-5175-4fa9-b7dc-5a1c8f6c5521"
    "ArmsWarrior" = "d3c5a4f2-8b6e-4a1d-9c7f-2e8b5a3c1d9f"
    "FuryWarrior" = "e4d6b5g3-9c7f-5b2e-ad8g-3f9c6b4d2e0g"
    "ProtectionWarrior" = "f5e7c6h4-ad8g-6c3f-be9h-4g0d7c5e3f1h"
    "ArmsColossus" = "6a1b8c3d-7e9f-4a5b-8c6d-9e0f1a2b3c4d"
    "ArmsSlayers" = "7b2c9d4e-8f0g-5b6c-9d7e-0f1g2b3c4d5e"
    "FuryMountainThane" = "8c3d0e5f-9g1h-6c7d-0e8f-1g2h3c4d5e6f"
    "FurySlayers" = "9d4e1f6g-0h2i-7d8e-1f9g-2h3i4d5e6f7g"
    "ProtectionMountainThane" = "0e5f2g7h-1i3j-8e9f-2g0h-3i4j5e6f7g8h"
    "ProtectionColossus" = "1f6g3h8i-2j4k-9f0g-3h1i-4j5k6f7g8h9i"
}

Write-Host "`n============================================================================" -ForegroundColor Cyan
Write-Host "COMPREHENSIVE MOD VERIFICATION AGAINST SOURCE OF TRUTH" -ForegroundColor Cyan
Write-Host "============================================================================`n" -ForegroundColor Cyan

# ============================================================================
# PHASE 1: FOLDER STRUCTURE VERIFICATION
# ============================================================================
Write-Section "PHASE 1: Folder Structure"

$ModsFolder = Join-Path $ModPath "Mods\$EXPECTED_FOLDER_NAME"
$PublicFolder = Join-Path $ModPath "Public\$EXPECTED_FOLDER_NAME"

if (Test-Path $ModsFolder) {
    Write-Pass "Mods folder exists: $ModsFolder"
} else {
    Write-Fail "Mods folder missing: $ModsFolder"
}

if (Test-Path $PublicFolder) {
    Write-Pass "Public folder exists: $PublicFolder"
} else {
    Write-Fail "Public folder missing: $PublicFolder"
}

# Check required subfolders in Public
$RequiredPublicFolders = @(
    "ClassDescriptions",
    "Progressions",
    "ActionResourceDefinitions",
    "Lists",
    "Stats\Generated\Data",
    "CharacterCreationPresets"
)

foreach ($folder in $RequiredPublicFolders) {
    $folderPath = Join-Path $PublicFolder $folder
    if (Test-Path $folderPath) {
        Write-Pass "Required folder exists: $folder"
    } else {
        Write-Fail "Required folder missing: $folder"
    }
}

# Check Localization folder in Mods
$LocalizationFolder = Join-Path $ModsFolder "Localization\English"
if (Test-Path $LocalizationFolder) {
    Write-Pass "Localization folder exists"
    
    # Check for LOCA file
    $LocaFile = Join-Path $LocalizationFolder "English.loca"
    if (Test-Path $LocaFile) {
        Write-Pass "English.loca file exists ($(((Get-Item $LocaFile).Length / 1KB).ToString('0.0')) KB)"
    } else {
        Write-Fail "English.loca file missing"
    }
} else {
    Write-Fail "Localization folder missing"
}

# ============================================================================
# PHASE 2: META.LSX VERIFICATION
# ============================================================================
Write-Section "PHASE 2: meta.lsx Verification"

$MetaPath = Join-Path $ModsFolder "meta.lsx"

if (-not (Test-Path $MetaPath)) {
    Write-Fail "meta.lsx not found at: $MetaPath"
} else {
    Write-Info "Reading meta.lsx..."
    
    # Read and clean multi-line comments
    $RawContent = Get-Content $MetaPath -Raw
    $CleanedContent = $RawContent -replace '(?s)<!--.*?-->', ''
    [xml]$MetaXml = $CleanedContent
    
    # Check UUID
    $ModuleInfoNode = $MetaXml.save.region.node.children.node | Where-Object { $_.attribute | Where-Object { $_.id -eq "UUID" } }
    $UuidAttr = ($ModuleInfoNode.attribute | Where-Object { $_.id -eq "UUID" }).value
    
    if ($UuidAttr -eq $EXPECTED_MOD_UUID) {
        Write-Pass "Mod UUID correct: $UuidAttr"
    } else {
        Write-Fail "Mod UUID mismatch: Expected $EXPECTED_MOD_UUID, got $UuidAttr"
    }
    
    # Check Folder attribute
    $FolderAttr = ($ModuleInfoNode.attribute | Where-Object { $_.id -eq "Folder" }).value
    if ($FolderAttr -eq $EXPECTED_FOLDER_NAME) {
        Write-Pass "Folder name correct: $FolderAttr"
    } else {
        Write-Fail "Folder name mismatch: Expected $EXPECTED_FOLDER_NAME, got $FolderAttr"
    }
    
    # Check Name attribute
    $NameAttr = ($ModuleInfoNode.attribute | Where-Object { $_.id -eq "Name" }).value
    if ($NameAttr -eq $EXPECTED_MOD_NAME) {
        Write-Pass "Mod name correct: $NameAttr"
    } else {
        Write-Fail "Mod name mismatch: Expected '$EXPECTED_MOD_NAME', got '$NameAttr'"
    }
    
    # Check Version64
    $Version64Attr = ($ModuleInfoNode.attribute | Where-Object { $_.id -eq "Version64" }).value
    if ($Version64Attr -eq $EXPECTED_VERSION64) {
        Write-Pass "Version64 correct: $Version64Attr"
    } else {
        Write-Warn "Version64 mismatch: Expected $EXPECTED_VERSION64, got $Version64Attr (may be intentional version update)"
    }
    
    # Check dependency count (should be 13)
    $DependencyNodes = $MetaXml.save.region.node.children.node.children.node | Where-Object { $_.id -eq "ModuleShortDesc" }
    $DependencyCount = ($DependencyNodes | Measure-Object).Count
    
    if ($DependencyCount -eq 13) {
        Write-Pass "Dependency count correct: 13 dependencies"
    } else {
        Write-Warn "Dependency count: $DependencyCount (expected 13 from SOURCE_OF_TRUTH)"
    }
}

# ============================================================================
# PHASE 3: CLASSDESCRIPTIONS.LSX VERIFICATION
# ============================================================================
Write-Section "PHASE 3: ClassDescriptions.lsx Verification"

$ClassDescPath = Join-Path $PublicFolder "ClassDescriptions\ClassDescriptions.lsx"

if (-not (Test-Path $ClassDescPath)) {
    Write-Fail "ClassDescriptions.lsx not found at: $ClassDescPath"
} else {
    Write-Info "Reading ClassDescriptions.lsx..."
    
    # Read and clean
    $RawContent = Get-Content $ClassDescPath -Raw
    $CleanedContent = $RawContent -replace '(?s)<!--.*?-->', ''
    [xml]$ClassXml = $CleanedContent
    
    # Get all ClassDescription nodes
    $ClassNodes = $ClassXml.save.region.node.children.node | Where-Object { $_.id -eq "ClassDescription" }
    
    Write-Info "Found $($ClassNodes.Count) class definitions"
    
    # Verify base class (WoWWarrior)
    foreach ($classNode in $ClassNodes) {
        $ClassName = ($classNode.attribute | Where-Object { $_.id -eq "Name" }).value
        $ClassUUID = ($classNode.attribute | Where-Object { $_.id -eq "UUID" }).value
        $ProgressionTableUUID = ($classNode.attribute | Where-Object { $_.id -eq "ProgressionTableUUID" }).value
        
        Write-Info "Checking class: $ClassName (UUID: $ClassUUID)"
        
        # Check if ProgressionTableUUID matches expected
        if ($EXPECTED_PROGRESSIONS.ContainsKey($ClassName)) {
            $ExpectedProgUUID = $EXPECTED_PROGRESSIONS[$ClassName]
            if ($ProgressionTableUUID -eq $ExpectedProgUUID) {
                Write-Pass "  ProgressionTableUUID correct for $ClassName"
            } else {
                Write-Fail "  ProgressionTableUUID mismatch for $ClassName"
                Write-Info "    Expected: $ExpectedProgUUID"
                Write-Info "    Got:      $ProgressionTableUUID"
            }
        } else {
            Write-Warn "  No expected ProgressionTableUUID defined for $ClassName in SOURCE_OF_TRUTH"
        }
        
        # Special checks for base class
        if ($ClassName -eq "WoWWarrior") {
            if ($ClassUUID -eq $EXPECTED_BASE_CLASS_UUID) {
                Write-Pass "  Base class UUID correct"
            } else {
                Write-Fail "  Base class UUID mismatch: Expected $EXPECTED_BASE_CLASS_UUID, got $ClassUUID"
            }
            
            # Check hit dice
            $BaseHp = ($classNode.attribute | Where-Object { $_.id -eq "BaseHp" }).value
            $HpPerLevel = ($classNode.attribute | Where-Object { $_.id -eq "HpPerLevel" }).value
            
            if ($BaseHp -eq "10") {
                Write-Pass "  BaseHp correct: 10"
            } else {
                Write-Fail "  BaseHp incorrect: Expected 10, got $BaseHp"
            }
            
            if ($HpPerLevel -eq "10") {
                Write-Pass "  HpPerLevel correct: 10"
            } else {
                Write-Fail "  HpPerLevel incorrect: Expected 10, got $HpPerLevel"
            }
            
            # Check primary ability
            $PrimaryAbility = ($classNode.attribute | Where-Object { $_.id -eq "PrimaryAbility" }).value
            if ($PrimaryAbility -eq "1") {
                Write-Pass "  PrimaryAbility correct: 1 (Strength)"
            } else {
                Write-Fail "  PrimaryAbility incorrect: Expected 1 (Strength), got $PrimaryAbility"
            }
        }
    }
}

# ============================================================================
# PHASE 4: PROGRESSIONS.LSX VERIFICATION
# ============================================================================
Write-Section "PHASE 4: Progressions.lsx Verification"

$ProgressionsPath = Join-Path $PublicFolder "Progressions\Progressions.lsx"

if (-not (Test-Path $ProgressionsPath)) {
    Write-Fail "Progressions.lsx not found at: $ProgressionsPath"
} else {
    Write-Info "Reading Progressions.lsx..."
    
    # Read and clean
    $RawContent = Get-Content $ProgressionsPath -Raw
    $CleanedContent = $RawContent -replace '(?s)<!--.*?-->', ''
    [xml]$ProgressionsXml = $CleanedContent
    
    # Get all Progression nodes
    $ProgressionNodes = $ProgressionsXml.save.region.node.children.node | Where-Object { $_.id -eq "Progression" }
    
    Write-Info "Found $($ProgressionNodes.Count) progression nodes"
    
    # Check that it's NOT Warlock content
    $FirstProgName = ($ProgressionNodes[0].attribute | Where-Object { $_.id -eq "Name" }).value
    
    if ($FirstProgName -like "*Warlock*" -or $FirstProgName -like "*WoWWarlock*") {
        Write-Fail "CRITICAL: Progressions.lsx contains WARLOCK content! Name: $FirstProgName"
    } elseif ($FirstProgName -eq "Warrior" -or $FirstProgName -eq "WoWWarrior") {
        Write-Pass "Progressions.lsx contains WARRIOR content (Name: $FirstProgName)"
    } else {
        Write-Warn "Progressions.lsx first node has unexpected Name: $FirstProgName"
    }
    
    # Check TableUUIDs match ClassDescriptions
    foreach ($progNode in $ProgressionNodes) {
        $ProgName = ($progNode.attribute | Where-Object { $_.id -eq "Name" }).value
        $TableUUID = ($progNode.attribute | Where-Object { $_.id -eq "TableUUID" }).value
        
        # Only check first 10 nodes (major classes)
        if ($EXPECTED_PROGRESSIONS.ContainsKey($ProgName)) {
            $ExpectedTableUUID = $EXPECTED_PROGRESSIONS[$ProgName]
            if ($TableUUID -eq $ExpectedTableUUID) {
                Write-Pass "  TableUUID correct for $ProgName"
            } else {
                Write-Fail "  TableUUID mismatch for $ProgName"
                Write-Info "    Expected: $ExpectedTableUUID"
                Write-Info "    Got:      $TableUUID"
            }
        }
    }
    
    # Check for Rage resource grants
    $RageFound = $false
    foreach ($progNode in $ProgressionNodes) {
        $Boosts = ($progNode.attribute | Where-Object { $_.id -eq "Boosts" }).value
        if ($Boosts -like "*ActionResource(Rage*") {
            $RageFound = $true
            Write-Pass "  Rage resource found in Progressions"
            break
        }
    }
    
    if (-not $RageFound) {
        Write-Fail "  Rage resource NOT found in Progressions.lsx"
    }
    
    # Check for Warrior-specific abilities (not Warlock spells)
    $WarriorAbilitiesFound = $false
    foreach ($progNode in $ProgressionNodes) {
        $PassivesAdded = ($progNode.attribute | Where-Object { $_.id -eq "PassivesAdded" }).value
        if ($PassivesAdded -like "*WAR_*") {
            $WarriorAbilitiesFound = $true
            Write-Pass "  Warrior abilities (WAR_*) found in Progressions"
            break
        }
    }
    
    if (-not $WarriorAbilitiesFound) {
        Write-Warn "  No Warrior abilities (WAR_*) found in PassivesAdded"
    }
}

# ============================================================================
# PHASE 5: ACTIONRESOURCEDEFINITIONS.LSX VERIFICATION
# ============================================================================
Write-Section "PHASE 5: ActionResourceDefinitions.lsx Verification"

$ActionResourcePath = Join-Path $PublicFolder "ActionResourceDefinitions\ActionResourceDefinitions.lsx"

if (-not (Test-Path $ActionResourcePath)) {
    Write-Fail "ActionResourceDefinitions.lsx not found"
} else {
    Write-Info "Reading ActionResourceDefinitions.lsx..."
    
    # Read and clean
    $RawContent = Get-Content $ActionResourcePath -Raw
    $CleanedContent = $RawContent -replace '(?s)<!--.*?-->', ''
    [xml]$ResourceXml = $CleanedContent
    
    # Get all ActionResourceDefinition nodes
    $ResourceNodes = $ResourceXml.save.region.node.children.node | Where-Object { $_.id -eq "ActionResourceDefinition" }
    
    Write-Info "Found $($ResourceNodes.Count) action resource definitions"
    
    # Check for Rage resource
    $RageResource = $ResourceNodes | Where-Object { 
        ($_.attribute | Where-Object { $_.id -eq "Name" }).value -eq "Rage"
    }
    
    if ($RageResource) {
        Write-Pass "Rage resource defined"
        
        # Check Rage properties
        $MaxLevel = ($RageResource.attribute | Where-Object { $_.id -eq "MaxLevel" }).value
        if ($MaxLevel -eq "100") {
            Write-Pass "  Rage MaxLevel correct: 100"
        } else {
            Write-Fail "  Rage MaxLevel incorrect: Expected 100, got $MaxLevel"
        }
    } else {
        Write-Fail "Rage resource NOT defined"
    }
    
    # Expected resources from SOURCE_OF_TRUTH (6 total)
    $ExpectedResources = @("Rage", "DefensiveCharge", "TankCooldown", "MobilityCharge", "OverpowerCharge", "ThunderCharge")
    
    foreach ($expectedRes in $ExpectedResources) {
        $ResNode = $ResourceNodes | Where-Object { 
            ($_.attribute | Where-Object { $_.id -eq "Name" }).value -eq $expectedRes
        }
        
        if ($ResNode) {
            Write-Pass "  Resource defined: $expectedRes"
        } else {
            Write-Warn "  Resource missing: $expectedRes"
        }
    }
}

# ============================================================================
# PHASE 6: CHARACTERCREATIONPRESETS VERIFICATION
# ============================================================================
Write-Section "PHASE 6: CharacterCreationPresets Verification"

$CharCreationPath = Join-Path $PublicFolder "CharacterCreationPresets\AbilityDistributionPresets.lsx"

if (-not (Test-Path $CharCreationPath)) {
    Write-Fail "AbilityDistributionPresets.lsx not found (required per YouTube guide)"
} else {
    Write-Info "Reading AbilityDistributionPresets.lsx..."
    
    # Read and clean
    $RawContent = Get-Content $CharCreationPath -Raw
    $CleanedContent = $RawContent -replace '(?s)<!--.*?-->', ''
    [xml]$CharCreationXml = $CleanedContent
    
    # Get all preset nodes
    $PresetNodes = $CharCreationXml.save.region.node.children.node | Where-Object { $_.id -eq "CharacterCreationAbilityDistributionPreset" }
    
    Write-Info "Found $($PresetNodes.Count) ability distribution presets"
    
    # Check that ClassUUID matches Warrior
    foreach ($preset in $PresetNodes) {
        $ClassUUID = ($preset.attribute | Where-Object { $_.id -eq "ClassUUID" }).value
        if ($ClassUUID -eq $EXPECTED_BASE_CLASS_UUID) {
            Write-Pass "  Preset ClassUUID correct: $ClassUUID"
        } else {
            Write-Fail "  Preset ClassUUID mismatch: Expected $EXPECTED_BASE_CLASS_UUID, got $ClassUUID"
        }
    }
}

# ============================================================================
# SUMMARY
# ============================================================================
Write-Host "`n============================================================================" -ForegroundColor Cyan
Write-Host "VERIFICATION SUMMARY" -ForegroundColor Cyan
Write-Host "============================================================================`n" -ForegroundColor Cyan

Write-Host "Total Checks:"
Write-Host "  PASS: " -NoNewline -ForegroundColor Green
Write-Host "$($script:FailCount + $script:WarnCount + 1)" -ForegroundColor Green
Write-Host "  WARN: " -NoNewline -ForegroundColor Yellow
Write-Host "$($script:WarnCount)" -ForegroundColor Yellow
Write-Host "  FAIL: " -NoNewline -ForegroundColor Red
Write-Host "$($script:FailCount)" -ForegroundColor Red

Write-Host ""

if ($script:FailCount -eq 0 -and $script:WarnCount -eq 0) {
    Write-Host "*** MOD FULLY COMPLIANT WITH SOURCE_OF_TRUTH.MD ***" -ForegroundColor Green
    exit 0
} elseif ($script:FailCount -eq 0) {
    Write-Host "*** MOD COMPLIANT WITH WARNINGS ***" -ForegroundColor Yellow
    Write-Host "Review warnings above - they may be intentional changes." -ForegroundColor Yellow
    exit 0
} else {
    Write-Host "*** MOD HAS CRITICAL ISSUES ***" -ForegroundColor Red
    Write-Host "Fix failed checks above before packaging." -ForegroundColor Red
    exit 1
}
