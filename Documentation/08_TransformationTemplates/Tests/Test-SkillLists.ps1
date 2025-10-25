# Test-SkillLists.ps1
# Validates SkillLists.lsx transformation (FILE 18)
# Tests: 4 subclass-specific skill lists with correct UUIDs and skill sets

param(
    [Parameter(Mandatory=$false)]
    [string]$FilePath = "C:\Users\tenod\source\repos\BG3Mods\Data\Public\Warrior_Wow_78fe4967-4e62-5491-d981-dd781acca4d7\Lists\SkillLists.lsx"
)

# Initialize counters
$script:FailCount = 0
$script:PassCount = 0

# Color output helpers (NO Unicode characters)
function Write-Pass { param($Message) Write-Host "[PASS] $Message" -ForegroundColor Green; $script:PassCount++ }
function Write-Fail { param($Message) Write-Host "[FAIL] $Message" -ForegroundColor Red; $script:FailCount++ }
function Write-Warn { param($Message) Write-Host "[WARN] $Message" -ForegroundColor Yellow }
function Write-Info { param($Message) Write-Host "[INFO] $Message" -ForegroundColor Cyan }

Write-Host "`n==================== Testing SkillLists.lsx (FILE 18) ====================`n" -ForegroundColor Cyan

# Check file exists
if (-not (Test-Path $FilePath)) {
    Write-Fail "File not found: $FilePath"
    exit 1
}
Write-Pass "File exists: $FilePath"

# Read and parse XML (strip multi-line comments first)
try {
    $RawContent = Get-Content $FilePath -Raw
    $CleanedContent = $RawContent -replace '(?s)<!--.*?-->', ''
    [xml]$Xml = $CleanedContent
    Write-Pass "XML parsed successfully"
} catch {
    Write-Fail "XML parse error: $($_.Exception.Message)"
    exit 1
}

# Test 1: Check root structure
Write-Info "`n[TEST 1] Root Structure"
$region = $Xml.save.region | Where-Object { $_.id -eq "SkillLists" }
if ($region) {
    Write-Pass "SkillLists region found"
} else {
    Write-Fail "SkillLists region not found"
}

# Test 2: Count SkillList nodes (should be 4)
Write-Info "`n[TEST 2] SkillList Node Count"
$skillLists = $region.node.children.node | Where-Object { $_.id -eq "SkillList" }
$nodeCount = $skillLists.Count
Write-Info "Found $nodeCount SkillList nodes"

if ($nodeCount -eq 4) {
    Write-Pass "Correct number of SkillList nodes (4)"
} else {
    Write-Fail "Expected 4 SkillList nodes, found $nodeCount"
}

# Test 3: Verify all UUIDs are unique and follow pattern
Write-Info "`n[TEST 3] UUID Validation"
$expectedUUIDs = @(
    "78fe4967-0003-0000-0000-000000000001",  # Base Warrior
    "78fe4967-0003-0000-0000-000000000002",  # Arms Warrior
    "78fe4967-0003-0000-0000-000000000003",  # Fury Warrior
    "78fe4967-0003-0000-0000-000000000004"   # Protection Warrior
)

$actualUUIDs = @()
foreach ($skillList in $skillLists) {
    $uuid = $skillList.attribute | Where-Object { $_.id -eq "UUID" } | Select-Object -ExpandProperty value
    $actualUUIDs += $uuid
    Write-Info "UUID: $uuid"
}

# Check all expected UUIDs present
$allMatch = $true
foreach ($expectedUUID in $expectedUUIDs) {
    if ($actualUUIDs -notcontains $expectedUUID) {
        Write-Fail "Missing expected UUID: $expectedUUID"
        $allMatch = $false
    }
}

if ($allMatch -and $actualUUIDs.Count -eq 4) {
    Write-Pass "All UUIDs present and correct"
}

# Check UUIDs are unique
$uniqueUUIDs = $actualUUIDs | Select-Object -Unique
if ($uniqueUUIDs.Count -eq $actualUUIDs.Count) {
    Write-Pass "All UUIDs are unique"
} else {
    Write-Fail "Duplicate UUIDs detected"
}

# Test 4: Verify skill list names
Write-Info "`n[TEST 4] Skill List Names"
$expectedNames = @(
    "Base Warrior Skill List",
    "Arms Warrior Skill List",
    "Fury Warrior Skill List",
    "Protection Warrior Skill List"
)

$actualNames = @()
foreach ($skillList in $skillLists) {
    $name = $skillList.attribute | Where-Object { $_.id -eq "Name" } | Select-Object -ExpandProperty value
    $actualNames += $name
    Write-Info "Name: $name"
}

$namesMatch = $true
foreach ($expectedName in $expectedNames) {
    if ($actualNames -notcontains $expectedName) {
        Write-Fail "Missing expected name: $expectedName"
        $namesMatch = $false
    }
}

if ($namesMatch) {
    Write-Pass "All skill list names correct"
}

# Test 5: Verify skill sets for each subclass
Write-Info "`n[TEST 5] Skill Set Validation"

# Expected skill sets
$expectedSkills = @{
    "78fe4967-0003-0000-0000-000000000001" = @("Athletics", "Acrobatics", "Intimidation", "Perception", "Survival", "AnimalHandling")  # Base (6)
    "78fe4967-0003-0000-0000-000000000002" = @("Athletics", "Intimidation", "Perception", "Survival")  # Arms (4)
    "78fe4967-0003-0000-0000-000000000003" = @("Athletics", "Acrobatics", "Intimidation", "Survival")  # Fury (4)
    "78fe4967-0003-0000-0000-000000000004" = @("Athletics", "Intimidation", "Perception", "Survival", "AnimalHandling")  # Protection (5)
}

foreach ($skillList in $skillLists) {
    $uuid = $skillList.attribute | Where-Object { $_.id -eq "UUID" } | Select-Object -ExpandProperty value
    $name = $skillList.attribute | Where-Object { $_.id -eq "Name" } | Select-Object -ExpandProperty value
    $skillsAttr = $skillList.attribute | Where-Object { $_.id -eq "Skills" } | Select-Object -ExpandProperty value
    
    Write-Info "`nChecking: $name"
    Write-Info "Skills: $skillsAttr"
    
    # Parse skills (remove spaces after commas)
    $actualSkills = $skillsAttr -split ',\s*'
    $expected = $expectedSkills[$uuid]
    
    # Check skill count
    $expectedCount = $expected.Count
    $actualCount = $actualSkills.Count
    Write-Info "Expected count: $expectedCount, Actual count: $actualCount"
    
    if ($actualCount -eq $expectedCount) {
        Write-Pass "$name has correct skill count ($actualCount)"
    } else {
        Write-Fail "$name has wrong skill count (expected $expectedCount, got $actualCount)"
    }
    
    # Check each skill is present
    $allSkillsMatch = $true
    foreach ($skill in $expected) {
        if ($actualSkills -notcontains $skill) {
            Write-Fail "$name missing skill: $skill"
            $allSkillsMatch = $false
        }
    }
    
    if ($allSkillsMatch) {
        Write-Pass "$name has all correct skills"
    }
}

# Test 6: Verify subclass-specific skill differences
Write-Info "`n[TEST 6] Subclass Skill Differentiation"

# Base vs Arms: Base has Acrobatics + AnimalHandling, Arms doesn't
$baseList = $skillLists | Where-Object { ($_ | Select-Object -ExpandProperty attribute | Where-Object { $_.id -eq "UUID" }).value -eq "78fe4967-0003-0000-0000-000000000001" }
$armsList = $skillLists | Where-Object { ($_ | Select-Object -ExpandProperty attribute | Where-Object { $_.id -eq "UUID" }).value -eq "78fe4967-0003-0000-0000-000000000002" }

$baseSkills = ($baseList.attribute | Where-Object { $_.id -eq "Skills" }).value
$armsSkills = ($armsList.attribute | Where-Object { $_.id -eq "Skills" }).value

if ($baseSkills -match "Acrobatics" -and $armsSkills -notmatch "Acrobatics") {
    Write-Pass "Base has Acrobatics, Arms doesn't (correct)"
} else {
    Write-Fail "Base/Arms Acrobatics differentiation incorrect"
}

if ($baseSkills -match "AnimalHandling" -and $armsSkills -notmatch "AnimalHandling") {
    Write-Pass "Base has AnimalHandling, Arms doesn't (correct)"
} else {
    Write-Fail "Base/Arms AnimalHandling differentiation incorrect"
}

# Fury: Should have Acrobatics (mobility focus)
$furyList = $skillLists | Where-Object { ($_ | Select-Object -ExpandProperty attribute | Where-Object { $_.id -eq "UUID" }).value -eq "78fe4967-0003-0000-0000-000000000003" }
$furySkills = ($furyList.attribute | Where-Object { $_.id -eq "Skills" }).value

if ($furySkills -match "Acrobatics") {
    Write-Pass "Fury has Acrobatics (mobility focus correct)"
} else {
    Write-Fail "Fury missing Acrobatics"
}

# Fury: Should NOT have Perception (no tactical awareness)
if ($furySkills -notmatch "Perception") {
    Write-Pass "Fury doesn't have Perception (correct - no tactical focus)"
} else {
    Write-Fail "Fury has Perception (should not - focused berserker)"
}

# Protection: Should have 5 skills (most diverse)
$protList = $skillLists | Where-Object { ($_ | Select-Object -ExpandProperty attribute | Where-Object { $_.id -eq "UUID" }).value -eq "78fe4967-0003-0000-0000-000000000004" }
$protSkills = ($protList.attribute | Where-Object { $_.id -eq "Skills" }).value
$protSkillCount = ($protSkills -split ',\s*').Count

if ($protSkillCount -eq 5) {
    Write-Pass "Protection has 5 skills (most diverse for tank utility)"
} else {
    Write-Fail "Protection has $protSkillCount skills (expected 5)"
}

# Protection: Should have AnimalHandling (mount/companion tanking)
if ($protSkills -match "AnimalHandling") {
    Write-Pass "Protection has AnimalHandling (mount/companion tanking)"
} else {
    Write-Fail "Protection missing AnimalHandling"
}

# Test 7: Verify all skill lists have Athletics (universal Warrior skill)
Write-Info "`n[TEST 7] Universal Skills"
$allHaveAthletics = $true
foreach ($skillList in $skillLists) {
    $name = $skillList.attribute | Where-Object { $_.id -eq "Name" } | Select-Object -ExpandProperty value
    $skills = $skillList.attribute | Where-Object { $_.id -eq "Skills" } | Select-Object -ExpandProperty value
    
    if ($skills -notmatch "Athletics") {
        Write-Fail "$name missing Athletics"
        $allHaveAthletics = $false
    }
}

if ($allHaveAthletics) {
    Write-Pass "All subclasses have Athletics (universal Warrior skill)"
}

# Test 8: Verify all skill lists have Intimidation (universal Warrior skill)
$allHaveIntimidation = $true
foreach ($skillList in $skillLists) {
    $name = $skillList.attribute | Where-Object { $_.id -eq "Name" } | Select-Object -ExpandProperty value
    $skills = $skillList.attribute | Where-Object { $_.id -eq "Skills" } | Select-Object -ExpandProperty value
    
    if ($skills -notmatch "Intimidation") {
        Write-Fail "$name missing Intimidation"
        $allHaveIntimidation = $false
    }
}

if ($allHaveIntimidation) {
    Write-Pass "All subclasses have Intimidation (universal Warrior skill)"
}

# Final Summary
Write-Host "`n==================== Test Summary ====================`n" -ForegroundColor Cyan
Write-Host "Total Passed: $script:PassCount" -ForegroundColor Green
Write-Host "Total Failed: $script:FailCount" -ForegroundColor Red

if ($script:FailCount -eq 0) {
    Write-Host "`n[SUCCESS] All tests passed! SkillLists.lsx is correctly transformed.`n" -ForegroundColor Green
    exit 0
} else {
    Write-Host "`n[FAILURE] $script:FailCount test(s) failed. Review errors above.`n" -ForegroundColor Red
    exit 1
}
