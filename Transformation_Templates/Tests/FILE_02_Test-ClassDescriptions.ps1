# Template Validation Test: ClassDescriptions.lsx (FILE 2)
# Validates class attributes, HP values, UUIDs, subclass relationships

param(
    [Parameter(Mandatory=$true)]
    [string]$FilePath,
    
    [Parameter(Mandatory=$false)]
    [string]$ExpectedBaseUUID,
    
    [Parameter(Mandatory=$false)]
    [int]$ExpectedSubclassCount = 1
)

# Color output helpers
function Write-Pass { param($Message) Write-Host "[PASS] $Message" -ForegroundColor Green }
function Write-Fail { param($Message) Write-Host "[FAIL] $Message" -ForegroundColor Red; $script:FailCount++ }
function Write-Warn { param($Message) Write-Host "[WARN] $Message" -ForegroundColor Yellow }
function Write-Info { param($Message) Write-Host "[INFO] $Message" -ForegroundColor Cyan }

$FailCount = 0

Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host "FILE 2 VALIDATION: ClassDescriptions.lsx" -ForegroundColor Cyan
Write-Host "========================================`n" -ForegroundColor Cyan

# Test 1: File exists
if (-not (Test-Path $FilePath)) {
    Write-Fail "File not found: $FilePath"
    exit 1
}
Write-Pass "File exists"

# Test 2: Parse XML (remove multi-line comments first)
try {
    $RawContent = Get-Content $FilePath -Raw -ErrorAction Stop
    
    # Remove multi-line XML comments (<!-- ... -->)
    # Use non-greedy matching to handle comments that span multiple lines
    $CleanedContent = $RawContent -replace '(?s)<!--.*?-->', ''
    
    # Debug: Show if comments were removed
    $CommentCount = ([regex]::Matches($RawContent, '<!--')).Count
    if ($CommentCount -gt 0) {
        Write-Info "Stripped $CommentCount comment block(s) from XML"
    }
    
    [xml]$ClassXml = $CleanedContent
    Write-Pass "XML parsed successfully"
} catch {
    Write-Fail "Failed to parse XML: $($_.Exception.Message)"
    # Show first 200 chars of cleaned content for debugging
    if ($CleanedContent) {
        $Preview = $CleanedContent.Substring(0, [Math]::Min(200, $CleanedContent.Length))
        Write-Info "Content preview: $Preview..."
    }
    exit 1
}

# Test 3: Find ClassDescription nodes
$ClassNodes = $ClassXml.save.region.node.children.node | Where-Object { $_.id -eq "ClassDescription" }
if (-not $ClassNodes) {
    Write-Fail "No ClassDescription nodes found"
    exit 1
}

$NodeCount = ($ClassNodes | Measure-Object).Count
Write-Pass "Found $NodeCount ClassDescription node(s)"

# Helper to get attribute
function Get-Attr {
    param($Node, $Name)
    $attr = $Node.attribute | Where-Object { $_.id -eq $Name }
    return $attr.value
}

# Test 4: Identify base class and subclasses
$BaseClasses = @()
$Subclasses = @()

foreach ($node in $ClassNodes) {
    $ParentGuid = Get-Attr $node "ParentGuid"
    if ([string]::IsNullOrWhiteSpace($ParentGuid)) {
        $BaseClasses += $node
    } else {
        $Subclasses += $node
    }
}

Write-Info "Found $($BaseClasses.Count) base class(es), $($Subclasses.Count) subclass(es)"

# Test 5: Should have exactly 1 base class
if ($BaseClasses.Count -ne 1) {
    Write-Fail "Expected exactly 1 base class, found $($BaseClasses.Count)"
} else {
    Write-Pass "Exactly 1 base class found"
}

# Test 6: Validate base class
if ($BaseClasses.Count -eq 1) {
    $BaseClass = $BaseClasses[0]
    $BaseUUID = Get-Attr $BaseClass "UUID"
    $BaseName = Get-Attr $BaseClass "Name"
    $BaseHp = Get-Attr $BaseClass "BaseHp"
    $HpPerLevel = Get-Attr $BaseClass "HpPerLevel"
    $PrimaryAbility = Get-Attr $BaseClass "PrimaryAbility"
    $SpellCastingAbility = Get-Attr $BaseClass "SpellCastingAbility"
    $ClassEquipment = Get-Attr $BaseClass "ClassEquipment"
    $SoundClassType = Get-Attr $BaseClass "SoundClassType"
    $SpellList = Get-Attr $BaseClass "SpellList"
    
    Write-Info "Base class: $BaseName"
    Write-Info "UUID: $BaseUUID"
    Write-Info "HP: $BaseHp / $HpPerLevel per level"
    
    # Test UUID
    if ($ExpectedBaseUUID -and ($BaseUUID -ne $ExpectedBaseUUID)) {
        Write-Fail "Base UUID mismatch! Expected: $ExpectedBaseUUID, Found: $BaseUUID"
    } elseif ($ExpectedBaseUUID) {
        Write-Pass "Base UUID matches expected"
    }
    
    if ($BaseUUID -notmatch '^[a-f0-9]{8}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{12}$') {
        Write-Fail "Base UUID format invalid"
    } else {
        Write-Pass "Base UUID format valid"
    }
    
    # Test Name
    if ([string]::IsNullOrWhiteSpace($BaseName)) {
        Write-Fail "Base class Name is empty"
    } else {
        Write-Pass "Base class Name populated"
    }
    
    # Test HP values
    try {
        $BaseHpInt = [int]$BaseHp
        $HpPerLevelInt = [int]$HpPerLevel
        
        if ($BaseHpInt -le 0) {
            Write-Fail "BaseHp should be positive"
        } else {
            Write-Pass "BaseHp valid: $BaseHp"
        }
        
        if ($HpPerLevelInt -le 0) {
            Write-Fail "HpPerLevel should be positive"
        } else {
            Write-Pass "HpPerLevel valid: $HpPerLevel"
        }
    } catch {
        Write-Fail "HP values not valid integers"
    }
    
    # Test Ability scores
    try {
        $PrimaryInt = [int]$PrimaryAbility
        $SpellCastingInt = [int]$SpellCastingAbility
        
        if ($PrimaryInt -lt 1 -or $PrimaryInt -gt 6) {
            Write-Fail "PrimaryAbility out of range (1-6)"
        } else {
            Write-Pass "PrimaryAbility valid: $PrimaryAbility"
        }
        
        if ($SpellCastingInt -lt 1 -or $SpellCastingInt -gt 6) {
            Write-Fail "SpellCastingAbility out of range (1-6)"
        } else {
            Write-Pass "SpellCastingAbility valid: $SpellCastingAbility"
        }
    } catch {
        Write-Fail "Ability scores not valid integers"
    }
    
    # Test Equipment and Sounds
    if ([string]::IsNullOrWhiteSpace($ClassEquipment)) {
        Write-Fail "ClassEquipment is empty"
    } else {
        Write-Pass "ClassEquipment populated"
    }
    
    if ([string]::IsNullOrWhiteSpace($SoundClassType)) {
        Write-Fail "SoundClassType is empty"
    } else {
        Write-Pass "SoundClassType populated"
    }
    
    # Test SpellList
    if ([string]::IsNullOrWhiteSpace($SpellList)) {
        Write-Fail "SpellList UUID is empty"
    } elseif ($SpellList -eq "32879c22-4858-48ef-8f8d-22e6d395b396") {
        Write-Info "Using dummy SpellList UUID (matches Warlock template)"
    } else {
        Write-Pass "SpellList UUID populated"
    }
    
    # Test Tags
    $Tags = $BaseClass.children.node | Where-Object { $_.id -eq "Tags" }
    if (-not $Tags) {
        Write-Fail "Base class missing Tags child node"
    } else {
        Write-Pass "Base class has Tags node"
    }
}

# Test 7: Validate subclasses
if ($Subclasses.Count -ne $ExpectedSubclassCount) {
    Write-Info "Found $($Subclasses.Count) subclass(es), expected $ExpectedSubclassCount"
}

foreach ($Subclass in $Subclasses) {
    $SubUUID = Get-Attr $Subclass "UUID"
    $SubName = Get-Attr $Subclass "Name"
    $SubParentGuid = Get-Attr $Subclass "ParentGuid"
    
    Write-Info "Validating subclass: $SubName"
    
    # Test ParentGuid
    if ($BaseClasses.Count -eq 1 -and $SubParentGuid -ne $BaseUUID) {
        Write-Fail "Subclass ParentGuid does not match base class UUID"
    } elseif ($BaseClasses.Count -eq 1) {
        Write-Pass "Subclass ParentGuid links to base class"
    }
    
    # Test UUID unique
    if ($SubUUID -eq $BaseUUID) {
        Write-Fail "Subclass UUID same as base class (must be unique)"
    } elseif ($SubUUID -notmatch '^[a-f0-9]{8}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{12}$') {
        Write-Fail "Subclass UUID format invalid"
    } else {
        Write-Pass "Subclass UUID valid and unique"
    }
    
    # Test Tags
    $SubTags = $Subclass.children.node | Where-Object { $_.id -eq "Tags" }
    if (-not $SubTags) {
        Write-Fail "Subclass missing Tags child node"
    } else {
        Write-Pass "Subclass has Tags node"
    }
}

# Test 8: Check for duplicate UUIDs
$AllUUIDs = @()
foreach ($node in $ClassNodes) {
    $uuid = Get-Attr $node "UUID"
    if ($AllUUIDs -contains $uuid) {
        Write-Fail "Duplicate UUID found: $uuid"
    } else {
        $AllUUIDs += $uuid
    }
}
if ($AllUUIDs.Count -eq $NodeCount) {
    Write-Pass "All UUIDs are unique"
}

# Test 9: Warrior-specific checks
if ($BaseName -like "*Warrior*") {
    Write-Info "Detected Warrior class, running Warrior-specific checks"
    
    if ($BaseHp -eq "10" -and $HpPerLevel -eq "10") {
        Write-Pass "Warrior HP correct (d10: 10/10)"
    }
    
    if ($PrimaryAbility -eq "1") {
        Write-Pass "Warrior PrimaryAbility correct (Strength)"
    }
    
    if ($ClassEquipment -eq "EQP_CC_Barbarian") {
        Write-Pass "Warrior equipment correct (Barbarian)"
    }
    
    if ($SoundClassType -eq "Barbarian") {
        Write-Pass "Warrior sounds correct (Barbarian)"
    }
}

# Final summary
Write-Host "`n========================================" -ForegroundColor Cyan
if ($FailCount -eq 0) {
    Write-Host "[SUCCESS] ALL TESTS PASSED" -ForegroundColor Green
    Write-Host "========================================" -ForegroundColor Cyan
    Write-Info "Base class: $BaseName"
    Write-Info "Subclasses: $($Subclasses.Count)"
    exit 0
} else {
    Write-Host "[FAILED] $FailCount test(s) failed" -ForegroundColor Red
    Write-Host "========================================" -ForegroundColor Cyan
    exit 1
}
