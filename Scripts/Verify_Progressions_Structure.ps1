# ============================================================================
# Progressions.lsx Comprehensive Verification Script
# ============================================================================
# Purpose: Systematically verify the entire Progressions.lsx file structure
# After Phase 2 Step 5 modifications (L13 SubClasses nodes added)
# ============================================================================

param(
    [Parameter(Mandatory=$false)]
    [string]$FilePath = "C:\Users\tenod\source\repos\BG3Mods\Data\Public\Warrior_Wow_78fe4967-4e62-5491-d981-dd781acca4d7\Progressions\Progressions.lsx"
)

# Color output helpers (NO Unicode!)
function Write-Pass { param($Message) Write-Host "[PASS] $Message" -ForegroundColor Green }
function Write-Fail { param($Message) Write-Host "[FAIL] $Message" -ForegroundColor Red; $script:FailCount++ }
function Write-Warn { param($Message) Write-Host "[WARN] $Message" -ForegroundColor Yellow; $script:WarnCount++ }
function Write-Info { param($Message) Write-Host "[INFO] $Message" -ForegroundColor Cyan }
function Write-Section { param($Message) Write-Host "`n========== $Message ==========" -ForegroundColor Magenta }

# Initialize counters
$script:FailCount = 0
$script:WarnCount = 0
$script:PassCount = 0

# ============================================================================
# 1. File Existence & XML Parsing
# ============================================================================
Write-Section "FILE VALIDATION"

if (-not (Test-Path $FilePath)) {
    Write-Fail "File not found: $FilePath"
    exit 1
}
Write-Pass "File exists: $FilePath"

try {
    $RawContent = Get-Content $FilePath -Raw
    # Strip multi-line XML comments (critical for parsing)
    $CleanedContent = $RawContent -replace '(?s)<!--.*?-->', ''
    [xml]$Xml = $CleanedContent
    Write-Pass "XML parsing successful"
} catch {
    Write-Fail "XML parsing failed: $_"
    exit 1
}

# ============================================================================
# 2. Expected UUIDs (from PHASE2_UUID_MAPPING.md)
# ============================================================================
Write-Section "UUID REFERENCE DATA"

$ExpectedUUIDs = @{
    # Parent Subclasses (L3 spec choices)
    'Arms'       = '1a2b3c4d-5e6f-7a8b-9c0d-1e2f3a4b5c6d'
    'Fury'       = '2b3c4d5e-6f7a-8b9c-0d1e-2f3a4b5c6d7e'
    'Protection' = '3c4d5e6f-7a8b-9c0d-1e2f-3a4b5c6d7e8f'
    
    # Hero Subclasses (L13 hero talent choices)
    'ArmsColossus'           = '9e3f65fd-68f8-4a46-8210-42c4f8ea0999'
    'ArmsSlayers'            = '8eb6da73-6020-4eb7-ab21-b9ff4fffe38b'
    'FuryMountainThane'      = '162d56bd-4d1e-4957-8a43-c5ba3fb1ee8f'
    'FurySlayers'            = '199180bf-1173-4631-9678-5c8342f81862'
    'ProtectionMountainThane'= '861c5f75-69ab-4a06-8f16-6cf34d7f99d6'
    'ProtectionColossus'     = '83268994-38e9-4bb5-b9e5-382926636d58'
    
    # ProgressionTableUUIDs
    'ArmsTableUUID'          = 'd3c5a4f2-8b6e-4a1d-9c7f-2e8b5a3c1d9f'
    'FuryTableUUID'          = 'e4d6b5g3-9c7f-5b2e-ad8g-3f9c6b4d2e0g'
    'ProtectionTableUUID'    = 'f5e7c6h4-ad8g-6c3f-be9h-4g0d7c5e3f1h'
}

Write-Info "Loaded $($ExpectedUUIDs.Count) expected UUIDs"

# ============================================================================
# 3. Progression Node Extraction
# ============================================================================
Write-Section "PROGRESSION NODE EXTRACTION"

$AllProgressions = $Xml.SelectNodes("//node[@id='Progression']")
Write-Info "Found $($AllProgressions.Count) total <node id='Progression'> entries"

# Group by Name attribute
$GroupedProgressions = $AllProgressions | Group-Object { 
    $NameAttr = $_.SelectSingleNode("attribute[@id='Name']")
    if ($NameAttr) { $NameAttr.value } else { "Warrior" }
}

Write-Info "Progression groups:"
foreach ($Group in $GroupedProgressions) {
    $ClassName = if ($Group.Name) { $Group.Name } else { "(No Name)" }
    Write-Info "  - $ClassName : $($Group.Count) levels"
}

# ============================================================================
# 4. Base Warrior Progression Validation (L1-20)
# ============================================================================
Write-Section "BASE WARRIOR PROGRESSION (L1-20)"

$BaseWarrior = $AllProgressions | Where-Object { 
    $NameAttr = $_.SelectSingleNode("attribute[@id='Name']")
    $NameAttr -and $NameAttr.value -eq 'Warrior'
}

if ($BaseWarrior.Count -ne 20) {
    Write-Fail "Expected 20 base Warrior progressions, found $($BaseWarrior.Count)"
} else {
    Write-Pass "Base Warrior has 20 progression levels"
}

# Check level continuity
$BaseWarriorLevels = $BaseWarrior | ForEach-Object { 
    $LevelAttr = $_.SelectSingleNode("attribute[@id='Level']")
    [int]$LevelAttr.value
} | Sort-Object
$ExpectedLevels = 1..20

$MissingLevels = $ExpectedLevels | Where-Object { $_ -notin $BaseWarriorLevels }
$ExtraLevels = $BaseWarriorLevels | Where-Object { $_ -notin $ExpectedLevels }

if ($MissingLevels) {
    Write-Fail "Base Warrior missing levels: $($MissingLevels -join ', ')"
} elseif ($ExtraLevels) {
    Write-Fail "Base Warrior has extra levels: $($ExtraLevels -join ', ')"
} else {
    Write-Pass "Base Warrior level continuity: L1-20 complete"
}

# Check key levels
$L1 = $BaseWarrior | Where-Object { $_.Attributes['Level'].Value -eq '1' }
if ($L1.Attributes['Boosts'].Value -match 'ActionResource\(Rage') {
    Write-Pass "L1: Rage resource granted"
} else {
    Write-Fail "L1: Rage resource NOT found in Boosts"
}

$L3 = $BaseWarrior | Where-Object { $_.Attributes['Level'].Value -eq '3' }
# L3 should NOT have SubClasses node (that's for specs, not base class)
if ($L3.SelectNodes(".//node[@id='SubClasses']").Count -eq 0) {
    Write-Pass "L3: Base Warrior correctly has no SubClasses node (spec choice handled elsewhere)"
} else {
    Write-Warn "L3: Base Warrior has SubClasses node (unexpected - verify intended design)"
}

# ============================================================================
# 5. Arms Progression Validation (L3-20)
# ============================================================================
Write-Section "ARMS PROGRESSION (L3-20)"

$ArmsProgressions = $AllProgressions | Where-Object { 
    $_.Attributes['Name'].Value -eq 'Arms' 
}

if ($ArmsProgressions.Count -ne 18) {
    Write-Warn "Expected 18 Arms progressions (L3-20), found $($ArmsProgressions.Count)"
} else {
    Write-Pass "Arms has 18 progression levels"
}

# Verify TableUUID consistency
$ArmsTableUUIDs = $ArmsProgressions | ForEach-Object { $_.Attributes['TableUUID'].Value } | Select-Object -Unique
if ($ArmsTableUUIDs.Count -ne 1) {
    Write-Fail "Arms has multiple TableUUIDs: $($ArmsTableUUIDs -join ', ')"
} elseif ($ArmsTableUUIDs[0] -eq $ExpectedUUIDs['ArmsTableUUID']) {
    Write-Pass "Arms TableUUID correct: $($ArmsTableUUIDs[0])"
} else {
    Write-Fail "Arms TableUUID mismatch. Expected: $($ExpectedUUIDs['ArmsTableUUID']), Found: $($ArmsTableUUIDs[0])"
}

# Verify L13 SubClasses node
$ArmsL13 = $ArmsProgressions | Where-Object { $_.Attributes['Level'].Value -eq '13' }
if (-not $ArmsL13) {
    Write-Fail "Arms L13 progression not found"
} else {
    $SubClassesNode = $ArmsL13.SelectNodes(".//node[@id='SubClasses']")
    if ($SubClassesNode.Count -eq 0) {
        Write-Fail "Arms L13: SubClasses node NOT found"
    } else {
        Write-Pass "Arms L13: SubClasses node exists"
        
        # Check SubClass children
        $SubClassChildren = $SubClassesNode[0].SelectNodes(".//node[@id='SubClass']")
        if ($SubClassChildren.Count -ne 2) {
            Write-Fail "Arms L13: Expected 2 SubClass children, found $($SubClassChildren.Count)"
        } else {
            Write-Pass "Arms L13: 2 SubClass children found"
            
            # Verify UUIDs
            $FoundUUIDs = $SubClassChildren | ForEach-Object { $_.Attributes['Object'].Value }
            $ExpectedArmsHeroes = @($ExpectedUUIDs['ArmsColossus'], $ExpectedUUIDs['ArmsSlayers'])
            
            $MissingHeroes = $ExpectedArmsHeroes | Where-Object { $_ -notin $FoundUUIDs }
            $ExtraHeroes = $FoundUUIDs | Where-Object { $_ -notin $ExpectedArmsHeroes }
            
            if ($MissingHeroes) {
                Write-Fail "Arms L13: Missing hero UUIDs: $($MissingHeroes -join ', ')"
            } elseif ($ExtraHeroes) {
                Write-Fail "Arms L13: Extra hero UUIDs: $($ExtraHeroes -join ', ')"
            } else {
                Write-Pass "Arms L13: Hero talent UUIDs correct (ArmsColossus, ArmsSlayers)"
            }
        }
    }
    
    # Verify NO PassivesAdded (removed in Step 5)
    if ($ArmsL13.Attributes['PassivesAdded']) {
        Write-Fail "Arms L13: PassivesAdded attribute still exists (should be removed)"
    } else {
        Write-Pass "Arms L13: PassivesAdded correctly removed"
    }
}

# ============================================================================
# 6. Fury Progression Validation (L3-20)
# ============================================================================
Write-Section "FURY PROGRESSION (L3-20)"

$FuryProgressions = $AllProgressions | Where-Object { 
    $_.Attributes['Name'].Value -eq 'Fury' 
}

if ($FuryProgressions.Count -ne 18) {
    Write-Warn "Expected 18 Fury progressions (L3-20), found $($FuryProgressions.Count)"
} else {
    Write-Pass "Fury has 18 progression levels"
}

# Verify TableUUID consistency
$FuryTableUUIDs = $FuryProgressions | ForEach-Object { $_.Attributes['TableUUID'].Value } | Select-Object -Unique
if ($FuryTableUUIDs.Count -ne 1) {
    Write-Fail "Fury has multiple TableUUIDs: $($FuryTableUUIDs -join ', ')"
} elseif ($FuryTableUUIDs[0] -eq $ExpectedUUIDs['FuryTableUUID']) {
    Write-Pass "Fury TableUUID correct: $($FuryTableUUIDs[0])"
} else {
    Write-Fail "Fury TableUUID mismatch. Expected: $($ExpectedUUIDs['FuryTableUUID']), Found: $($FuryTableUUIDs[0])"
}

# Verify L13 SubClasses node
$FuryL13 = $FuryProgressions | Where-Object { $_.Attributes['Level'].Value -eq '13' }
if (-not $FuryL13) {
    Write-Fail "Fury L13 progression not found"
} else {
    $SubClassesNode = $FuryL13.SelectNodes(".//node[@id='SubClasses']")
    if ($SubClassesNode.Count -eq 0) {
        Write-Fail "Fury L13: SubClasses node NOT found"
    } else {
        Write-Pass "Fury L13: SubClasses node exists"
        
        # Check SubClass children
        $SubClassChildren = $SubClassesNode[0].SelectNodes(".//node[@id='SubClass']")
        if ($SubClassChildren.Count -ne 2) {
            Write-Fail "Fury L13: Expected 2 SubClass children, found $($SubClassChildren.Count)"
        } else {
            Write-Pass "Fury L13: 2 SubClass children found"
            
            # Verify UUIDs
            $FoundUUIDs = $SubClassChildren | ForEach-Object { $_.Attributes['Object'].Value }
            $ExpectedFuryHeroes = @($ExpectedUUIDs['FuryMountainThane'], $ExpectedUUIDs['FurySlayers'])
            
            $MissingHeroes = $ExpectedFuryHeroes | Where-Object { $_ -notin $FoundUUIDs }
            $ExtraHeroes = $FoundUUIDs | Where-Object { $_ -notin $ExpectedFuryHeroes }
            
            if ($MissingHeroes) {
                Write-Fail "Fury L13: Missing hero UUIDs: $($MissingHeroes -join ', ')"
            } elseif ($ExtraHeroes) {
                Write-Fail "Fury L13: Extra hero UUIDs: $($ExtraHeroes -join ', ')"
            } else {
                Write-Pass "Fury L13: Hero talent UUIDs correct (FuryMountainThane, FurySlayers)"
            }
        }
    }
    
    # Verify NO PassivesAdded (removed in Step 5)
    if ($FuryL13.Attributes['PassivesAdded']) {
        Write-Fail "Fury L13: PassivesAdded attribute still exists (should be removed)"
    } else {
        Write-Pass "Fury L13: PassivesAdded correctly removed"
    }
}

# ============================================================================
# 7. Protection Progression Validation (L3-20)
# ============================================================================
Write-Section "PROTECTION PROGRESSION (L3-20)"

$ProtectionProgressions = $AllProgressions | Where-Object { 
    $_.Attributes['Name'].Value -eq 'Protection' 
}

if ($ProtectionProgressions.Count -ne 18) {
    Write-Warn "Expected 18 Protection progressions (L3-20), found $($ProtectionProgressions.Count)"
} else {
    Write-Pass "Protection has 18 progression levels"
}

# Verify TableUUID consistency
$ProtectionTableUUIDs = $ProtectionProgressions | ForEach-Object { $_.Attributes['TableUUID'].Value } | Select-Object -Unique
if ($ProtectionTableUUIDs.Count -ne 1) {
    Write-Fail "Protection has multiple TableUUIDs: $($ProtectionTableUUIDs -join ', ')"
} elseif ($ProtectionTableUUIDs[0] -eq $ExpectedUUIDs['ProtectionTableUUID']) {
    Write-Pass "Protection TableUUID correct: $($ProtectionTableUUIDs[0])"
} else {
    Write-Fail "Protection TableUUID mismatch. Expected: $($ExpectedUUIDs['ProtectionTableUUID']), Found: $($ProtectionTableUUIDs[0])"
}

# Verify L13 SubClasses node
$ProtectionL13 = $ProtectionProgressions | Where-Object { $_.Attributes['Level'].Value -eq '13' }
if (-not $ProtectionL13) {
    Write-Fail "Protection L13 progression not found"
} else {
    $SubClassesNode = $ProtectionL13.SelectNodes(".//node[@id='SubClasses']")
    if ($SubClassesNode.Count -eq 0) {
        Write-Fail "Protection L13: SubClasses node NOT found"
    } else {
        Write-Pass "Protection L13: SubClasses node exists"
        
        # Check SubClass children
        $SubClassChildren = $SubClassesNode[0].SelectNodes(".//node[@id='SubClass']")
        if ($SubClassChildren.Count -ne 2) {
            Write-Fail "Protection L13: Expected 2 SubClass children, found $($SubClassChildren.Count)"
        } else {
            Write-Pass "Protection L13: 2 SubClass children found"
            
            # Verify UUIDs
            $FoundUUIDs = $SubClassChildren | ForEach-Object { $_.Attributes['Object'].Value }
            $ExpectedProtectionHeroes = @($ExpectedUUIDs['ProtectionMountainThane'], $ExpectedUUIDs['ProtectionColossus'])
            
            $MissingHeroes = $ExpectedProtectionHeroes | Where-Object { $_ -notin $FoundUUIDs }
            $ExtraHeroes = $FoundUUIDs | Where-Object { $_ -notin $ExpectedProtectionHeroes }
            
            if ($MissingHeroes) {
                Write-Fail "Protection L13: Missing hero UUIDs: $($MissingHeroes -join ', ')"
            } elseif ($ExtraHeroes) {
                Write-Fail "Protection L13: Extra hero UUIDs: $($ExtraHeroes -join ', ')"
            } else {
                Write-Pass "Protection L13: Hero talent UUIDs correct (ProtectionMountainThane, ProtectionColossus)"
            }
        }
    }
    
    # Verify NO PassivesAdded (removed in Step 5)
    if ($ProtectionL13.Attributes['PassivesAdded']) {
        Write-Fail "Protection L13: PassivesAdded attribute still exists (should be removed)"
    } else {
        Write-Pass "Protection L13: PassivesAdded correctly removed"
    }
}

# ============================================================================
# 8. Spell List References Validation
# ============================================================================
Write-Section "SPELL LIST REFERENCES"

$AllSpellListRefs = $Xml.SelectNodes("//node[@id='AddSpells']")
Write-Info "Found $($AllSpellListRefs.Count) SpellList references (AddSpells nodes)"

# Check for duplicate UUIDs (indicates potential copy-paste errors)
$SpellListUUIDs = $AllSpellListRefs | ForEach-Object { $_.Attributes['UUID'].Value }
$DuplicateSpellLists = $SpellListUUIDs | Group-Object | Where-Object { $_.Count -gt 1 }

if ($DuplicateSpellLists) {
    Write-Warn "Duplicate SpellList UUIDs found (may be intentional for shared lists):"
    foreach ($Dup in $DuplicateSpellLists) {
        Write-Warn "  - UUID $($Dup.Name) appears $($Dup.Count) times"
    }
} else {
    Write-Pass "No duplicate SpellList UUIDs (all unique or intentionally shared)"
}

# ============================================================================
# 9. PassivesAdded References Validation
# ============================================================================
Write-Section "PASSIVESADDED REFERENCES"

$AllPassivesAdded = $AllProgressions | Where-Object { $_.Attributes['PassivesAdded'] }
Write-Info "Found $($AllPassivesAdded.Count) progressions with PassivesAdded attributes"

# Extract all passive names
$AllPassiveNames = $AllPassivesAdded | ForEach-Object {
    $_.Attributes['PassivesAdded'].Value -split ';'
} | Where-Object { $_ } | Select-Object -Unique

Write-Info "Total unique passive names: $($AllPassiveNames.Count)"

# Check for placeholder patterns (TODO items)
$PlaceholderPassives = $AllPassiveNames | Where-Object { $_ -match 'TODO|PLACEHOLDER|TEMP' }
if ($PlaceholderPassives) {
    Write-Warn "Placeholder passive names found:"
    foreach ($Placeholder in $PlaceholderPassives) {
        Write-Warn "  - $Placeholder"
    }
} else {
    Write-Pass "No obvious placeholder passive names (TODO/PLACEHOLDER/TEMP)"
}

# ============================================================================
# 10. Node Nesting Structure Validation
# ============================================================================
Write-Section "NODE NESTING STRUCTURE"

# Check for orphaned attributes (attributes outside proper node structure)
$AllAttributes = $Xml.SelectNodes("//*[@*]")
Write-Info "Found $($AllAttributes.Count) nodes with attributes"

# Check for missing required attributes in Progression nodes
$ProgressionsWithoutLevel = $AllProgressions | Where-Object { -not $_.Attributes['Level'] }
$ProgressionsWithoutName = $AllProgressions | Where-Object { -not $_.Attributes['Name'] }
$ProgressionsWithoutTableUUID = $AllProgressions | Where-Object { -not $_.Attributes['TableUUID'] }

if ($ProgressionsWithoutLevel.Count -gt 0) {
    Write-Fail "$($ProgressionsWithoutLevel.Count) Progression nodes missing 'Level' attribute"
} else {
    Write-Pass "All Progression nodes have 'Level' attribute"
}

if ($ProgressionsWithoutName.Count -gt 0) {
    Write-Fail "$($ProgressionsWithoutName.Count) Progression nodes missing 'Name' attribute"
} else {
    Write-Pass "All Progression nodes have 'Name' attribute"
}

if ($ProgressionsWithoutTableUUID.Count -gt 0) {
    Write-Fail "$($ProgressionsWithoutTableUUID.Count) Progression nodes missing 'TableUUID' attribute"
} else {
    Write-Pass "All Progression nodes have 'TableUUID' attribute"
}

# ============================================================================
# 11. Final Report
# ============================================================================
Write-Section "VERIFICATION SUMMARY"

$TotalChecks = $script:PassCount + $script:FailCount + $script:WarnCount

Write-Host ""
Write-Host "RESULTS:" -ForegroundColor Cyan
Write-Host "  Total Checks: $TotalChecks" -ForegroundColor White
Write-Pass "  Passed: $script:PassCount"
Write-Warn "  Warnings: $script:WarnCount"
Write-Fail "  Failures: $script:FailCount"
Write-Host ""

if ($script:FailCount -eq 0) {
    Write-Host "========================================" -ForegroundColor Green
    Write-Host " PROGRESSIONS.LSX VERIFICATION PASSED" -ForegroundColor Green
    Write-Host "========================================" -ForegroundColor Green
    Write-Host ""
    Write-Host "File is ready for Phase 2 Step 6 (generate 48 hero subclass progression nodes)" -ForegroundColor Green
    exit 0
} else {
    Write-Host "========================================" -ForegroundColor Red
    Write-Host " PROGRESSIONS.LSX VERIFICATION FAILED" -ForegroundColor Red
    Write-Host "========================================" -ForegroundColor Red
    Write-Host ""
    Write-Host "Please fix $script:FailCount failure(s) before proceeding to Step 6" -ForegroundColor Red
    exit 1
}
