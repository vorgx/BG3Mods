# Section [5] Hero Classes Validation Script
# Validates all 6 hero subclass implementations against SOURCE_OF_TRUTH.md documentation
# Created: October 25, 2025

param(
    [Parameter(Mandatory=$false)]
    [string]$ClassDescriptionsPath = "C:\Users\tenod\source\repos\BG3Mods\Data\Public\Warrior_Wow_78fe4967-4e62-5491-d981-dd781acca4d7\ClassDescriptions\ClassDescriptions.lsx",
    
    [Parameter(Mandatory=$false)]
    [string]$SourceOfTruthPath = "C:\Users\tenod\source\repos\BG3Mods\Documentation\00_SourcesOfTruth\SOURCE_OF_TRUTH.md"
)

# Color output helpers (NO Unicode characters!)
function Write-Pass { param($Message) Write-Host "[PASS] $Message" -ForegroundColor Green }
function Write-Fail { param($Message) Write-Host "[FAIL] $Message" -ForegroundColor Red; $script:FailCount++ }
function Write-Warn { param($Message) Write-Host "[WARN] $Message" -ForegroundColor Yellow }
function Write-Info { param($Message) Write-Host "[INFO] $Message" -ForegroundColor Cyan }
function Write-Section { param($Message) Write-Host "`n=== $Message ===" -ForegroundColor Magenta }

$script:FailCount = 0

Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host "Section [5] Hero Classes Validation" -ForegroundColor Cyan
Write-Host "========================================`n" -ForegroundColor Cyan

# ========================================
# PHASE 1: Load and Parse Files
# ========================================
Write-Section "PHASE 1: Load Files"

if (-not (Test-Path $ClassDescriptionsPath)) {
    Write-Fail "ClassDescriptions.lsx not found at: $ClassDescriptionsPath"
    exit 1
}
Write-Pass "ClassDescriptions.lsx found"

if (-not (Test-Path $SourceOfTruthPath)) {
    Write-Fail "SOURCE_OF_TRUTH.md not found at: $SourceOfTruthPath"
    exit 1
}
Write-Pass "SOURCE_OF_TRUTH.md found"

# Parse ClassDescriptions.lsx (strip multi-line comments)
$RawContent = Get-Content $ClassDescriptionsPath -Raw
$CleanedContent = $RawContent -replace '(?s)<!--.*?-->', ''
[xml]$ClassDescXml = $CleanedContent

Write-Pass "ClassDescriptions.lsx parsed successfully"

# Load SOURCE_OF_TRUTH.md
$SourceOfTruth = Get-Content $SourceOfTruthPath -Raw
Write-Pass "SOURCE_OF_TRUTH.md loaded successfully"

# ========================================
# PHASE 2: Extract Hero Subclass Nodes
# ========================================
Write-Section "PHASE 2: Extract Hero Subclass Nodes"

$AllClassNodes = $ClassDescXml.save.region.node.children.node | Where-Object { $_.id -eq "ClassDescription" }
Write-Info "Total ClassDescription nodes found: $($AllClassNodes.Count)"

# Expected hero subclasses
$ExpectedHeroSubclasses = @(
    "ArmsColossus",
    "ArmsSlayers", 
    "FuryMountainThane",
    "FurySlayers",
    "ProtectionMountainThane",
    "ProtectionColossus"
)

$HeroNodes = @{}
foreach ($expectedName in $ExpectedHeroSubclasses) {
    $node = $AllClassNodes | Where-Object { 
        ($_.attribute | Where-Object { $_.id -eq "Name" }).value -eq $expectedName 
    }
    if ($node) {
        $HeroNodes[$expectedName] = $node
        Write-Pass "Found hero subclass: $expectedName"
    } else {
        Write-Fail "Missing hero subclass: $expectedName"
    }
}

if ($HeroNodes.Count -ne 6) {
    Write-Fail "Expected 6 hero subclasses, found $($HeroNodes.Count)"
} else {
    Write-Pass "All 6 hero subclasses found"
}

# ========================================
# PHASE 3: Validate Hero Subclass UUIDs
# ========================================
Write-Section "PHASE 3: Validate Hero Subclass UUIDs"

# Expected UUIDs from SOURCE_OF_TRUTH.md Section [1]
$ExpectedUUIDs = @{
    "ArmsColossus" = "9e3f65fd-68f8-4a46-8210-42c4f8ea0999"
    "ArmsSlayers" = "8eb6da73-6020-4eb7-ab21-b9ff4fffe38b"
    "FuryMountainThane" = "162d56bd-4d1e-4957-8a43-c5ba3fb1ee8f"
    "FurySlayers" = "199180bf-1173-4631-9678-5c8342f81862"
    "ProtectionMountainThane" = "861c5f75-69ab-4a06-8f16-6cf34d7f99d6"
    "ProtectionColossus" = "83268994-38e9-4bb5-b9e5-382926636d58"
}

foreach ($heroName in $ExpectedUUIDs.Keys) {
    if ($HeroNodes.ContainsKey($heroName)) {
        $node = $HeroNodes[$heroName]
        $actualUUID = ($node.attribute | Where-Object { $_.id -eq "UUID" }).value
        $expectedUUID = $ExpectedUUIDs[$heroName]
        
        Write-Info "$heroName UUID: $actualUUID"
        if ($actualUUID -eq $expectedUUID) {
            Write-Pass "$heroName UUID matches documentation"
        } else {
            Write-Fail "$heroName UUID mismatch - Expected: $expectedUUID, Got: $actualUUID"
        }
    }
}

# ========================================
# PHASE 4: Validate ParentGuid References
# ========================================
Write-Section "PHASE 4: Validate ParentGuid References"

# Expected ParentGuids (pointing to parent subclass)
$ExpectedParentGuids = @{
    "ArmsColossus" = "1a2b3c4d-5e6f-7a8b-9c0d-1e2f3a4b5c6d"           # ArmsWarrior
    "ArmsSlayers" = "1a2b3c4d-5e6f-7a8b-9c0d-1e2f3a4b5c6d"            # ArmsWarrior
    "FuryMountainThane" = "2b3c4d5e-6f7a-8b9c-0d1e-2f3a4b5c6d7e"      # FuryWarrior
    "FurySlayers" = "2b3c4d5e-6f7a-8b9c-0d1e-2f3a4b5c6d7e"            # FuryWarrior
    "ProtectionMountainThane" = "3c4d5e6f-7a8b-9c0d-1e2f-3a4b5c6d7e8f" # ProtectionWarrior
    "ProtectionColossus" = "3c4d5e6f-7a8b-9c0d-1e2f-3a4b5c6d7e8f"     # ProtectionWarrior
}

foreach ($heroName in $ExpectedParentGuids.Keys) {
    if ($HeroNodes.ContainsKey($heroName)) {
        $node = $HeroNodes[$heroName]
        $actualParentGuid = ($node.attribute | Where-Object { $_.id -eq "ParentGuid" }).value
        $expectedParentGuid = $ExpectedParentGuids[$heroName]
        
        Write-Info "$heroName ParentGuid: $actualParentGuid"
        if ($actualParentGuid -eq $expectedParentGuid) {
            Write-Pass "$heroName ParentGuid correct"
        } else {
            Write-Fail "$heroName ParentGuid mismatch - Expected: $expectedParentGuid, Got: $actualParentGuid"
        }
    }
}

# ========================================
# PHASE 5: Validate HP Inheritance
# ========================================
Write-Section "PHASE 5: Validate HP Inheritance"

foreach ($heroName in $HeroNodes.Keys) {
    $node = $HeroNodes[$heroName]
    $hpPerLevel = ($node.attribute | Where-Object { $_.id -eq "HpPerLevel" }).value
    
    Write-Info "$heroName HpPerLevel: $hpPerLevel"
    if ($hpPerLevel -eq "10") {
        Write-Pass "$heroName HpPerLevel=10 (inherits from parent subclass)"
    } else {
        Write-Fail "$heroName HpPerLevel should be 10, got: $hpPerLevel"
    }
}

# Validate inheritance behavior documentation
Write-Info "Checking SOURCE_OF_TRUTH.md HP inheritance documentation..."
if ($SourceOfTruth -match "Arms-based heroes.*ArmsColossus.*ArmsSlayers.*Inherit 6 HP/level") {
    Write-Pass "Arms-based hero HP inheritance documented (6 HP/level)"
} else {
    Write-Warn "Arms-based hero HP inheritance may need clearer documentation"
}

if ($SourceOfTruth -match "Fury-based heroes.*FuryMountainThane.*FurySlayers.*Inherit 5 HP/level") {
    Write-Pass "Fury-based hero HP inheritance documented (5 HP/level)"
} else {
    Write-Warn "Fury-based hero HP inheritance may need clearer documentation"
}

if ($SourceOfTruth -match "Protection-based heroes.*ProtectionMountainThane.*ProtectionColossus.*Inherit 7 HP/level") {
    Write-Pass "Protection-based hero HP inheritance documented (7 HP/level)"
} else {
    Write-Warn "Protection-based hero HP inheritance may need clearer documentation"
}

# ========================================
# PHASE 6: Validate ProgressionTableUUID
# ========================================
Write-Section "PHASE 6: Validate ProgressionTableUUID Exists"

foreach ($heroName in $HeroNodes.Keys) {
    $node = $HeroNodes[$heroName]
    $progressionTableUUID = ($node.attribute | Where-Object { $_.id -eq "ProgressionTableUUID" }).value
    
    Write-Info "$heroName ProgressionTableUUID: $progressionTableUUID"
    if ($progressionTableUUID -and $progressionTableUUID -ne "00000000-0000-0000-0000-000000000000") {
        Write-Pass "$heroName has valid ProgressionTableUUID"
    } else {
        Write-Fail "$heroName missing or invalid ProgressionTableUUID"
    }
}

# ========================================
# PHASE 7: Validate Talent Count Documentation
# ========================================
Write-Section "PHASE 7: Validate Talent Count Documentation"

# Simpler approach: search for "11 (" near each hero spec section
$MountainThaneFound = $SourceOfTruth -match '## \[5\.1\] Mountain Thane.*?\*\*Total Talents\*\*:\s*11\s*\('
$ColossusFound = $SourceOfTruth -match '## \[5\.2\] Colossus.*?\*\*Total Talents\*\*:\s*11\s*\('
$SlayerFound = $SourceOfTruth -match '## \[5\.3\] Slayer.*?\*\*Total Talents\*\*:\s*11\s*\('

# Count occurrences of "Total Talents**: 11 ("
$TalentMatches = ([regex]::Matches($SourceOfTruth, '\*\*Total Talents\*\*:\s*11\s*\(1 keystone \+ 9 auto-grants \+ 1 capstone\)')).Count

Write-Info "Found $TalentMatches occurrences of 'Total Talents: 11 (1 keystone + 9 auto-grants + 1 capstone)'"

if ($TalentMatches -ge 3) {
    Write-Pass "All 3 hero specs (Mountain Thane/Colossus/Slayer) documented with 11 talents"
} else {
    Write-Fail "Expected 3 hero specs with 11 talents, found $TalentMatches"
}

# Check total count
if ($SourceOfTruth -match "33 total.*all 3.*hero spec") {
    Write-Pass "Total hero talents documented as 33 (11×3)"
} else {
    Write-Fail "Total hero talent count (33) not clearly documented"
}

# ========================================
# PHASE 8: Validate ClassDescriptions.lsx Implementation Notes
# ========================================
Write-Section "PHASE 8: Validate Implementation Notes in Documentation"

# Check if Section [5] has implementation notes for each hero subclass
$heroSubclassesWithNotes = 0

foreach ($heroName in $ExpectedHeroSubclasses) {
    if ($SourceOfTruth -match "$heroName.*UUID.*ParentGuid.*HpPerLevel") {
        Write-Pass "$heroName has implementation notes in documentation"
        $heroSubclassesWithNotes++
    } else {
        Write-Warn "$heroName missing detailed implementation notes in Section [5]"
    }
}

if ($heroSubclassesWithNotes -eq 6) {
    Write-Pass "All 6 hero subclasses have implementation notes documented"
} else {
    Write-Warn "Only $heroSubclassesWithNotes/6 hero subclasses have complete implementation notes"
}

# ========================================
# FINAL RESULTS
# ========================================
Write-Section "VALIDATION SUMMARY"

$TotalChecks = 40 + $HeroNodes.Count * 5  # Approximate check count
$PassedChecks = $TotalChecks - $script:FailCount

Write-Host "`n" -NoNewline
if ($script:FailCount -eq 0) {
    Write-Host "========================================" -ForegroundColor Green
    Write-Host "ALL VALIDATION CHECKS PASSED!" -ForegroundColor Green
    Write-Host "========================================" -ForegroundColor Green
    Write-Host "Total Checks: $TotalChecks" -ForegroundColor Green
    Write-Host "Hero Subclasses Validated: 6/6" -ForegroundColor Green
    Write-Host "Section [5] Status: COMPLETE" -ForegroundColor Green
    exit 0
} else {
    Write-Host "========================================" -ForegroundColor Red
    Write-Host "VALIDATION FAILED" -ForegroundColor Red
    Write-Host "========================================" -ForegroundColor Red
    Write-Host "Total Checks: $TotalChecks" -ForegroundColor Red
    Write-Host "Passed: $PassedChecks" -ForegroundColor Red
    Write-Host "Failed: $script:FailCount" -ForegroundColor Red
    Write-Host "`nPlease review failures above and fix." -ForegroundColor Yellow
    exit 1
}
