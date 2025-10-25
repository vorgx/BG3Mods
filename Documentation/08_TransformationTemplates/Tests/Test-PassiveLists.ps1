# Test-PassiveLists.ps1
# Validates FILE 13 PassiveLists.lsx transformation
# Usage: .\Test-PassiveLists.ps1 -FilePath "path\to\PassiveLists.lsx"

param(
    [Parameter(Mandatory=$true)]
    [string]$FilePath
)

# Color output helpers (NO Unicode characters!)
function Write-Pass { param($Message) Write-Host "[PASS] $Message" -ForegroundColor Green }
function Write-Fail { param($Message) Write-Host "[FAIL] $Message" -ForegroundColor Red; $script:FailCount++ }
function Write-Warn { param($Message) Write-Host "[WARN] $Message" -ForegroundColor Yellow }
function Write-Info { param($Message) Write-Host "[INFO] $Message" -ForegroundColor Cyan }

$script:FailCount = 0

Write-Host "`n[TEST] Validating PassiveLists.lsx (FILE 13)" -ForegroundColor Cyan
Write-Host "=" * 80 -ForegroundColor Gray

# 1. File exists
if (-not (Test-Path $FilePath)) {
    Write-Fail "File not found: $FilePath"
    exit 1
}
Write-Pass "File exists: $FilePath"

# 2. XML parsing (strip multi-line comments first)
try {
    $RawContent = Get-Content $FilePath -Raw
    $CleanedContent = $RawContent -replace '(?s)<!--.*?-->', ''
    [xml]$ParsedXml = $CleanedContent
    Write-Pass "XML parses without errors"
} catch {
    Write-Fail "XML parse error: $($_.Exception.Message)"
    exit 1
}

# 3. Extract all PassiveList nodes
$passiveListNodes = $ParsedXml.save.region.node.children.node
Write-Info "Total PassiveList nodes found: $($passiveListNodes.Count)"

# Helper function to get attribute value
function Get-AttributeValue {
    param($node, $attrId)
    $attr = $node.attribute | Where-Object { $_.id -eq $attrId }
    return $attr.value
}

# 4. Validate total node count (59 expected)
if ($passiveListNodes.Count -eq 59) {
    Write-Pass "Total node count: 59 (correct)"
} else {
    Write-Fail "Total node count: Expected 59, got $($passiveListNodes.Count)"
}

# 5. Regular talents breakdown validation
$warrior = $passiveListNodes | Where-Object { (Get-AttributeValue $_ "Comment") -match "^Warrior Level" }
$arms = $passiveListNodes | Where-Object { (Get-AttributeValue $_ "Comment") -match "^Arms Level" }
$fury = $passiveListNodes | Where-Object { (Get-AttributeValue $_ "Comment") -match "^Fury Level" }
$protection = $passiveListNodes | Where-Object { (Get-AttributeValue $_ "Comment") -match "^Protection Level" }

Write-Info "Base Warrior: $($warrior.Count) nodes (expected 8)"
Write-Info "Arms Subclass: $($arms.Count) nodes (expected 8)"
Write-Info "Fury Subclass: $($fury.Count) nodes (expected 5)"
Write-Info "Protection Subclass: $($protection.Count) nodes (expected 8)"

if ($warrior.Count -eq 8) {
    Write-Pass "Base Warrior node count: 8 (correct)"
} else {
    Write-Fail "Base Warrior node count: Expected 8, got $($warrior.Count)"
}

if ($arms.Count -eq 8) {
    Write-Pass "Arms Subclass node count: 8 (correct)"
} else {
    Write-Fail "Arms Subclass node count: Expected 8, got $($arms.Count)"
}

if ($fury.Count -eq 5) {
    Write-Pass "Fury Subclass node count: 5 (correct)"
} else {
    Write-Fail "Fury Subclass node count: Expected 5, got $($fury.Count)"
}

if ($protection.Count -eq 8) {
    Write-Pass "Protection Subclass node count: 8 (correct)"
} else {
    Write-Fail "Protection Subclass node count: Expected 8, got $($protection.Count)"
}

$regularTotal = $warrior.Count + $arms.Count + $fury.Count + $protection.Count
Write-Info "Regular Talents Subtotal: $regularTotal (expected 29)"

if ($regularTotal -eq 29) {
    Write-Pass "Regular Talents node count: 29 (correct)"
} else {
    Write-Fail "Regular Talents node count: Expected 29, got $regularTotal"
}

# 6. Hero talent paths validation
# Note: Comment format uses spaces (e.g., "Arms Colossus" not "ArmsColossus")
$heroPathPatterns = @{
    "Arms Colossus" = "Arms Colossus Level"
    "Arms Slayer" = "Arms Slayer Level"
    "Fury Mountain Thane" = "Fury Mountain Thane Level"
    "Fury Slayer" = "Fury Slayer Level"
    "Protection Mountain Thane" = "Protection Mountain Thane Level"
    "Protection Colossus" = "Protection Colossus Level"
}
$heroTotal = 0

foreach ($heroPath in $heroPathPatterns.Keys) {
    $pattern = $heroPathPatterns[$heroPath]
    $heroNodes = $passiveListNodes | Where-Object { (Get-AttributeValue $_ "Comment") -match "^$pattern" }
    $heroTotal += $heroNodes.Count
    Write-Info "$heroPath - $($heroNodes.Count) nodes (expected 5)"
    
    if ($heroNodes.Count -eq 5) {
        Write-Pass "$heroPath has 5 nodes (correct)"
    } else {
        Write-Fail "$heroPath should have 5 nodes, got $($heroNodes.Count)"
    }
}

if ($heroTotal -eq 30) {
    Write-Pass "Hero Talent Paths node count: 30 (correct)"
} else {
    Write-Fail "Hero Talent Paths node count: Expected 30, got $heroTotal"
}

# 7. UUID uniqueness check
$uuids = $passiveListNodes | ForEach-Object { Get-AttributeValue $_ "UUID" }
$uniqueUuids = $uuids | Select-Object -Unique

if ($uuids.Count -eq $uniqueUuids.Count) {
    Write-Pass "All UUIDs are unique ($($uuids.Count) total)"
} else {
    Write-Fail "Duplicate UUIDs found: $($uuids.Count) total, $($uniqueUuids.Count) unique"
    # Find duplicates
    $uuids | Group-Object | Where-Object { $_.Count -gt 1 } | ForEach-Object {
        Write-Info "  Duplicate UUID: $($_.Name) appears $($_.Count) times"
    }
}

# 8. Passives attribute populated check
$emptyPassivesCount = ($passiveListNodes | Where-Object { 
    $passives = Get-AttributeValue $_ "Passives"
    -not $passives -or $passives -eq "" 
}).Count

if ($emptyPassivesCount -eq 0) {
    Write-Pass "All 59 nodes have populated Passives attributes"
} else {
    Write-Warn "$emptyPassivesCount nodes have empty Passives attributes (may be valid if no choices at that level)"
    # Show which ones are empty
    $passiveListNodes | Where-Object { 
        $passives = Get-AttributeValue $_ "Passives"
        -not $passives -or $passives -eq ""
    } | ForEach-Object {
        $comment = Get-AttributeValue $_ "Comment"
        Write-Info "  Empty Passives: $comment"
    }
}

# 9. Comment format validation
$validComments = 0
$invalidCommentNodes = @()

foreach ($node in $passiveListNodes) {
    $comment = Get-AttributeValue $node "Comment"
    # Regular talents: "Warrior Level 2 Passives", "Arms Level 4 Passives", etc.
    # Hero paths: "Arms Colossus Level 13", "Fury Mountain Thane Level 15", etc. (with spaces)
    if ($comment -match "^(Warrior|Arms|Fury|Protection|Arms Colossus|Arms Slayer|Fury Mountain Thane|Fury Slayer|Protection Mountain Thane|Protection Colossus) Level \d+") {
        $validComments++
    } else {
        $invalidCommentNodes += $node
    }
}

if ($validComments -eq $passiveListNodes.Count) {
    Write-Pass "All Comment attributes follow correct format"
} else {
    Write-Fail "Found $($invalidCommentNodes.Count) nodes with invalid Comment format"
    foreach ($node in $invalidCommentNodes) {
        $comment = Get-AttributeValue $node "Comment"
        Write-Info "  Invalid Comment: '$comment'"
    }
}

# 10. No Warlock patterns check
$warlockPatterns = @("WoWWarlock_", "Demo_", "Destro_", "Aff_")
$warlockFound = $false

foreach ($pattern in $warlockPatterns) {
    $matchingNodes = $passiveListNodes | Where-Object { 
        $passives = Get-AttributeValue $_ "Passives"
        $passives -match $pattern
    }
    
    if ($matchingNodes.Count -gt 0) {
        $warlockFound = $true
        Write-Fail "Found Warlock pattern '$pattern' in $($matchingNodes.Count) nodes"
    }
}

if (-not $warlockFound) {
    Write-Pass "No Warlock patterns found (WoWWarlock_, Demo_, Destro_, Aff_)"
}

# 11. Warrior patterns present check
$warriorPatternCount = ($passiveListNodes | Where-Object {
    $passives = Get-AttributeValue $_ "Passives"
    $passives -match "WAR_"
}).Count

Write-Info "Nodes with WAR_ patterns: $warriorPatternCount / $($passiveListNodes.Count)"

if ($warriorPatternCount -gt 0) {
    Write-Pass "Warrior patterns (WAR_) found in $warriorPatternCount nodes"
} else {
    Write-Fail "No Warrior patterns (WAR_) found - all nodes have empty Passives?"
}

# 12. Version header validation
$version = $ParsedXml.save.version
Write-Info "XML Version: major=$($version.major) minor=$($version.minor) revision=$($version.revision) build=$($version.build)"

if ($version.major -eq "4") {
    Write-Pass "Version header correct (major=4)"
} else {
    Write-Warn "Version major is $($version.major), expected 4"
}

# 13. Hero path level coverage check (L13/15/17/19/20)
$expectedHeroLevels = @(13, 15, 17, 19, 20)
foreach ($heroPath in $heroPathPatterns.Keys) {
    $pattern = $heroPathPatterns[$heroPath]
    $heroNodes = $passiveListNodes | Where-Object { (Get-AttributeValue $_ "Comment") -match "^$pattern" }
    $foundLevels = @()
    
    foreach ($node in $heroNodes) {
        $comment = Get-AttributeValue $node "Comment"
        if ($comment -match "Level (\d+)") {
            $foundLevels += [int]$matches[1]
        }
    }
    
    $foundLevels = $foundLevels | Sort-Object
    $missingLevels = $expectedHeroLevels | Where-Object { $_ -notin $foundLevels }
    
    if ($missingLevels.Count -eq 0) {
        Write-Pass "$heroPath has all 5 required levels (13/15/17/19/20)"
    } else {
        Write-Fail "$heroPath missing levels: $($missingLevels -join ', ')"
    }
}

# Summary
Write-Host "`n" + ("=" * 80) -ForegroundColor Gray
if ($FailCount -eq 0) {
    Write-Host "[SUCCESS] All tests passed! PassiveLists.lsx is valid." -ForegroundColor Green
    exit 0
} else {
    Write-Host "[FAILURE] $FailCount test(s) failed." -ForegroundColor Red
    exit 1
}
