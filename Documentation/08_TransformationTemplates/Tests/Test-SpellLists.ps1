# Test-SpellLists.ps1
# Validates FILE 12 SpellLists.lsx transformation
# Usage: .\Test-SpellLists.ps1 -FilePath "path\to\SpellLists.lsx"

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

Write-Host "`n[TEST] Validating SpellLists.lsx (FILE 12)" -ForegroundColor Cyan
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

# 3. Extract all SpellList nodes
$spellListNodes = $ParsedXml.save.region.node.children.node
Write-Info "Total SpellList nodes found: $($spellListNodes.Count)"

# Helper function to get attribute value
function Get-AttributeValue {
    param($node, $attrId)
    $attr = $node.attribute | Where-Object { $_.id -eq $attrId }
    return $attr.value
}

# 4. Validate total node count (72 expected)
if ($spellListNodes.Count -eq 72) {
    Write-Pass "Total node count: 72 (correct)"
} else {
    Write-Fail "Total node count: Expected 72, got $($spellListNodes.Count)"
}

# 5. Breakdown validation
$warrior = $spellListNodes | Where-Object { (Get-AttributeValue $_ "Comment") -match "^Warrior Level" }
$arms = $spellListNodes | Where-Object { (Get-AttributeValue $_ "Comment") -match "^Arms Level" }
$fury = $spellListNodes | Where-Object { (Get-AttributeValue $_ "Comment") -match "^Fury Level" }
$protection = $spellListNodes | Where-Object { (Get-AttributeValue $_ "Comment") -match "^Protection Level" }

Write-Info "Base Warrior: $($warrior.Count) nodes"
Write-Info "Arms Subclass: $($arms.Count) nodes"
Write-Info "Fury Subclass: $($fury.Count) nodes"
Write-Info "Protection Subclass: $($protection.Count) nodes"

$baseSubclassTotal = $warrior.Count + $arms.Count + $fury.Count + $protection.Count
Write-Info "Base/Subclass Subtotal: $baseSubclassTotal"

if ($baseSubclassTotal -eq 42) {
    Write-Pass "Base/Subclass node count: 42 (correct)"
} else {
    Write-Fail "Base/Subclass node count: Expected 42, got $baseSubclassTotal"
}

# 6. Hero subclass validation
$heroSubclasses = @("ArmsColossus", "ArmsSlayers", "FuryMountainThane", "FurySlayers", "ProtectionMountainThane", "ProtectionColossus")
$heroTotal = 0

foreach ($hero in $heroSubclasses) {
    $heroNodes = $spellListNodes | Where-Object { (Get-AttributeValue $_ "Comment") -match "^$hero Level" }
    $heroTotal += $heroNodes.Count
    Write-Info "$hero - $($heroNodes.Count) nodes"
    
    if ($heroNodes.Count -ne 5) {
        Write-Fail "$hero should have 5 nodes, got $($heroNodes.Count)"
    }
}

if ($heroTotal -eq 30) {
    Write-Pass "Hero Subclass node count: 30 (correct)"
} else {
    Write-Fail "Hero Subclass node count: Expected 30, got $heroTotal"
}

# 7. UUID uniqueness check
$uuids = $spellListNodes | ForEach-Object { Get-AttributeValue $_ "UUID" }
$uniqueUuids = $uuids | Select-Object -Unique

if ($uuids.Count -eq $uniqueUuids.Count) {
    Write-Pass "All UUIDs are unique ($($uuids.Count) total)"
} else {
    Write-Fail "Duplicate UUIDs found: $($uuids.Count) total, $($uniqueUuids.Count) unique"
}

# 8. Zero SpellList pattern validation (hero subclasses)
$heroNodes = $spellListNodes | Where-Object { (Get-AttributeValue $_ "Comment") -match "^(ArmsColossus|ArmsSlayers|FuryMountainThane|FurySlayers|ProtectionMountainThane|ProtectionColossus) Level" }
$emptySpellsCount = ($heroNodes | Where-Object { (Get-AttributeValue $_ "Spells") -eq "" }).Count

if ($emptySpellsCount -eq 30) {
    Write-Pass "All 30 hero nodes use Zero SpellList pattern (empty Spells attribute)"
} else {
    Write-Fail "Zero SpellList pattern: Expected 30 empty Spells, got $emptySpellsCount"
}

# 9. Base/subclass populated Spells check
$baseSubclassNodes = $spellListNodes | Where-Object { (Get-AttributeValue $_ "Comment") -match "^(Warrior|Arms|Fury|Protection) Level" }
$populatedSpellsCount = ($baseSubclassNodes | Where-Object { 
    $spells = Get-AttributeValue $_ "Spells"
    $spells -and $spells -ne "" 
}).Count

Write-Info "Base/Subclass nodes with populated Spells: $populatedSpellsCount / $($baseSubclassNodes.Count)"

if ($populatedSpellsCount -eq 42) {
    Write-Pass "All 42 base/subclass nodes have populated Spells attributes"
} elseif ($populatedSpellsCount -gt 0) {
    Write-Warn "$populatedSpellsCount of 42 base/subclass nodes have populated Spells (some may be empty)"
} else {
    Write-Fail "No base/subclass nodes have populated Spells attributes"
}

# 10. Comment format validation
$invalidComments = $spellListNodes | Where-Object { (Get-AttributeValue $_ "Comment") -notmatch "^[A-Za-z]+ Level \d+" }

if ($invalidComments.Count -eq 0) {
    Write-Pass "All Comment attributes follow correct format"
} else {
    Write-Fail "Found $($invalidComments.Count) nodes with invalid Comment format"
}

# 11. Version header validation
$version = $ParsedXml.save.version
Write-Info "XML Version: major=$($version.major) minor=$($version.minor) revision=$($version.revision) build=$($version.build)"

if ($version.major -eq "4") {
    Write-Pass "Version header correct (major=4)"
} else {
    Write-Warn "Version major is $($version.major), expected 4"
}

# Summary
Write-Host "`n" + ("=" * 80) -ForegroundColor Gray
if ($FailCount -eq 0) {
    Write-Host "[SUCCESS] All tests passed! SpellLists.lsx is valid." -ForegroundColor Green
    exit 0
} else {
    Write-Host "[FAILURE] $FailCount test(s) failed." -ForegroundColor Red
    exit 1
}
