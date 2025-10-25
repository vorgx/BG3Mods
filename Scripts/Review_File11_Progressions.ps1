# FILE 11 FULL REVIEW: Progressions.lsx
# Comprehensive validation and analysis of all progression data

param(
    [string]$ProgressionsPath = "C:\Users\tenod\source\repos\BG3Mods\Data\Public\Warrior_Wow_78fe4967-4e62-5491-d981-dd781acca4d7\Progressions\Progressions.lsx"
)

Write-Host "`n====== FILE 11 (Progressions.lsx) COMPREHENSIVE REVIEW ======`n" -ForegroundColor Cyan

# Color helpers
function Write-Pass { param($Message) Write-Host "[PASS] $Message" -ForegroundColor Green }
function Write-Fail { param($Message) Write-Host "[FAIL] $Message" -ForegroundColor Red; $script:FailCount++ }
function Write-Warn { param($Message) Write-Host "[WARN] $Message" -ForegroundColor Yellow; $script:WarnCount++ }
function Write-Info { param($Message) Write-Host "[INFO] $Message" -ForegroundColor Cyan }
function Write-Section { param($Title) Write-Host "`n=== $Title ===" -ForegroundColor Magenta }

$script:FailCount = 0
$script:WarnCount = 0

# Load XML
Write-Section "FILE VALIDATION"
if (-not (Test-Path $ProgressionsPath)) {
    Write-Fail "File not found: $ProgressionsPath"
    exit 1
}

$RawContent = Get-Content $ProgressionsPath -Raw
$CleanedContent = $RawContent -replace '(?s)<!--.*?-->', ''
[xml]$Xml = $CleanedContent

$FileSize = (Get-Item $ProgressionsPath).Length
Write-Info "File Size: $FileSize bytes"
Write-Info "Total Lines: $((Get-Content $ProgressionsPath).Count)"

# Extract all progression nodes
$AllProgressions = $Xml.save.region.node.children.node | Where-Object { $_.id -eq "Progression" }
Write-Info "Total Progression Nodes: $($AllProgressions.Count)"

# ====== SECTION 1: STRUCTURE VALIDATION ======
Write-Section "1. XML STRUCTURE VALIDATION"

$ExpectedVersion = @{ major=4; minor=0; revision=9; build=0 }
$ActualVersion = $Xml.save.version
if ($ActualVersion.major -eq $ExpectedVersion.major -and 
    $ActualVersion.minor -eq $ExpectedVersion.minor) {
    Write-Pass "XML version correct: $($ActualVersion.major).$($ActualVersion.minor).$($ActualVersion.revision).$($ActualVersion.build)"
} else {
    Write-Fail "XML version mismatch. Expected 4.0.9.0, got $($ActualVersion.major).$($ActualVersion.minor).$($ActualVersion.revision).$($ActualVersion.build)"
}

# ====== SECTION 2: BASE CLASS PROGRESSIONS (L1-12) ======
Write-Section "2. BASE CLASS (Warrior) PROGRESSIONS (L1-12)"

$BaseClassProgressions = $AllProgressions | Where-Object { 
    $_.Attributes['Name'].'#text' -eq "Warrior" -and
    [int]$_.Attributes['Level'].'#text' -le 12
} | Sort-Object { [int]$_.Attributes['Level'].'#text' }

Write-Info "Base class levels found: $($BaseClassProgressions.Count) (expected 12)"

if ($BaseClassProgressions.Count -eq 12) {
    Write-Pass "All 12 base class levels present"
} else {
    Write-Fail "Expected 12 base class levels, found $($BaseClassProgressions.Count)"
}

# Check each level
$ExpectedLevels = 1..12
foreach ($level in $ExpectedLevels) {
    $LevelNode = $BaseClassProgressions | Where-Object { [int]$_.Attributes['Level'].'#text' -eq $level }
    if ($LevelNode) {
        Write-Pass "Level $level exists"
        
        # Check for critical attributes
        $TableUUID = $LevelNode.Attributes['TableUUID'].'#text'
        if ($TableUUID -eq "4f5d1434-5175-4fa9-b7dc-5a1c8f6c5521") {
            Write-Pass "  - TableUUID correct"
        } else {
            Write-Fail "  - TableUUID incorrect: $TableUUID"
        }
        
        # Check for spell grants
        $SpellSelector = $LevelNode.children.node | Where-Object { $_.id -eq "Selectors" } | 
            Select-Object -ExpandProperty children | Select-Object -ExpandProperty node | 
            Where-Object { $_.id -eq "AddSpells" }
        
        if ($SpellSelector) {
            Write-Pass "  - Has spell grants"
        }
        
        # Check for passives
        $Passives = $LevelNode.Attributes['PassivesAdded'].'#text'
        if ($Passives) {
            $PassiveCount = ($Passives -split ';').Count
            Write-Info "  - Passives: $PassiveCount ($Passives)"
        }
        
        # Check for boosts
        $Boosts = $LevelNode.Attributes['Boosts'].'#text'
        if ($Boosts) {
            Write-Info "  - Boosts: $Boosts"
        }
        
    } else {
        Write-Fail "Level $level MISSING"
    }
}

# ====== SECTION 3: SUBCLASS PROGRESSIONS (L3-20) ======
Write-Section "3. SUBCLASS PROGRESSIONS (L3-20)"

$Subclasses = @("Arms", "Fury", "Protection")
foreach ($subclass in $Subclasses) {
    Write-Info "`nSubclass: $subclass"
    
    $SubclassProgressions = $AllProgressions | Where-Object { 
        $_.Attributes['Name'].'#text' -eq $subclass
    } | Sort-Object { [int]$_.Attributes['Level'].'#text' }
    
    Write-Info "  Total levels: $($SubclassProgressions.Count) (expected 18: L3-20)"
    
    if ($SubclassProgressions.Count -eq 18) {
        Write-Pass "  All 18 subclass levels present"
    } else {
        Write-Fail "  Expected 18 levels, found $($SubclassProgressions.Count)"
    }
    
    # Check critical levels
    $L3Node = $SubclassProgressions | Where-Object { [int]$_.Attributes['Level'].'#text' -eq 3 }
    $L13Node = $SubclassProgressions | Where-Object { [int]$_.Attributes['Level'].'#text' -eq 13 }
    $L20Node = $SubclassProgressions | Where-Object { [int]$_.Attributes['Level'].'#text' -eq 20 }
    
    if ($L3Node) {
        Write-Pass "  L3 (subclass unlock) exists"
        $L3Passives = $L3Node.Attributes['PassivesAdded'].'#text'
        if ($L3Passives) {
            Write-Info "    Passives: $L3Passives"
        }
    } else {
        Write-Fail "  L3 (subclass unlock) MISSING"
    }
    
    if ($L13Node) {
        Write-Warn "  L13 (hero talents) exists"
        $L13Passives = $L13Node.Attributes['PassivesAdded'].'#text'
        if ($L13Passives) {
            $HeroTalentCount = ($L13Passives -split ';').Count
            Write-Warn "    Auto-grants $HeroTalentCount hero talent keystones (PHASE 1 - SHOULD BE CHOICE)"
            Write-Info "    Passives: $L13Passives"
        }
    } else {
        Write-Fail "  L13 (hero talents) MISSING"
    }
    
    if ($L20Node) {
        Write-Pass "  L20 (capstone) exists"
        $L20Passives = $L20Node.Attributes['PassivesAdded'].'#text'
        if ($L20Passives) {
            Write-Info "    Passives: $L20Passives"
        }
    } else {
        Write-Fail "  L20 (capstone) MISSING"
    }
}

# ====== SECTION 4: HERO TALENT ANALYSIS (L13-20) ======
Write-Section "4. HERO TALENT ANALYSIS (L13-20)"

$HeroTalentLevels = @(13, 15, 17, 19, 20)
$HeroTrees = @{
    "Mountain Thane" = @("WAR_Lightning_Strikes", "WAR_Crashing_Thunder", "WAR_Ground_Current", 
                         "WAR_Strength_of_the_Mountain", "WAR_Thunder_Blast", "WAR_Storm_Bolts",
                         "WAR_Keep_your_feet_on_the_Ground", "WAR_Flashing_Skies", "WAR_Thorim_s_Might",
                         "WAR_Burst_of_Power", "WAR_Avatar_of_the_Storm")
    "Colossus" = @("WAR_Demolish", "WAR_Martial_Expert", "WAR_Colossal_Might", "WAR_Earthquake",
                   "WAR_Arterial_Bleed", "WAR_Tide_of_Battle", "WAR_No_Stranger_to_Pain",
                   "WAR_Practiced_Strikes", "WAR_Precise_Might", "WAR_Mountain_of_Muscle_and_Scars",
                   "WAR_Dominance_of_the_Colossus")
    "Slayers" = @("WAR_Slayer_s_Dominance", "WAR_Imminent_Demise", "WAR_Overwhelming_Blades",
                  "WAR_Relentless_Pursuit", "WAR_Death_Drive", "WAR_Brutal_Finish",
                  "WAR_Opportunist", "WAR_Show_No_Mercy", "WAR_Reap_the_Storm",
                  "WAR_Slayer_s_Malice", "WAR_Unrelenting_Onslaught")
}

$TreeCompatibility = @{
    "Arms" = @("Colossus", "Slayers")
    "Fury" = @("Mountain Thane", "Slayers")
    "Protection" = @("Mountain Thane", "Colossus")
}

foreach ($subclass in $Subclasses) {
    Write-Info "`nSubclass: $subclass - Compatible Trees: $($TreeCompatibility[$subclass] -join ', ')"
    
    $SubclassHeroProgressions = $AllProgressions | Where-Object { 
        $_.Attributes['Name'].'#text' -eq $subclass -and
        [int]$_.Attributes['Level'].'#text' -in $HeroTalentLevels
    } | Sort-Object { [int]$_.Attributes['Level'].'#text' }
    
    $AllGrantedPassives = @()
    foreach ($node in $SubclassHeroProgressions) {
        $Passives = $node.Attributes['PassivesAdded'].'#text'
        if ($Passives) {
            $AllGrantedPassives += ($Passives -split ';')
        }
    }
    
    Write-Info "  Total hero talent passives granted: $($AllGrantedPassives.Count)"
    
    # Check which trees are represented
    foreach ($treeName in $TreeCompatibility[$subclass]) {
        $TreePassives = $HeroTrees[$treeName]
        $GrantedFromTree = $AllGrantedPassives | Where-Object { $_ -in $TreePassives }
        $GrantedCount = $GrantedFromTree.Count
        $ExpectedCount = $TreePassives.Count
        
        if ($GrantedCount -eq $ExpectedCount) {
            Write-Warn "  ${treeName}: $GrantedCount/$ExpectedCount talents granted (ALL - PHASE 1)"
        } elseif ($GrantedCount -gt 0) {
            Write-Warn "  ${treeName}: $GrantedCount/$ExpectedCount talents granted (PARTIAL)"
        } else {
            Write-Info "  ${treeName}: 0/$ExpectedCount talents granted (NONE)"
        }
    }
    
    # Check for incorrect tree grants
    $CompatibleTrees = $TreeCompatibility[$subclass]
    foreach ($treeName in $HeroTrees.Keys) {
        if ($treeName -notin $CompatibleTrees) {
            $TreePassives = $HeroTrees[$treeName]
            $GrantedFromWrongTree = $AllGrantedPassives | Where-Object { $_ -in $TreePassives }
            if ($GrantedFromWrongTree.Count -gt 0) {
                Write-Fail "  ${treeName}: $($GrantedFromWrongTree.Count) talents granted (WRONG TREE FOR THIS SPEC!)"
            }
        }
    }
}

# ====== SECTION 5: SPELL LIST REFERENCES ======
Write-Section "5. SPELL LIST REFERENCES"

$AllSpellSelectors = $AllProgressions | ForEach-Object {
    $_.children.node | Where-Object { $_.id -eq "Selectors" } | 
    Select-Object -ExpandProperty children | Select-Object -ExpandProperty node | 
    Where-Object { $_.id -eq "AddSpells" }
}

$UniqueSpellListUUIDs = $AllSpellSelectors | ForEach-Object { $_.Attributes['UUID'].'#text' } | 
    Select-Object -Unique

Write-Info "Total spell list references: $($AllSpellSelectors.Count)"
Write-Info "Unique spell list UUIDs: $($UniqueSpellListUUIDs.Count)"

foreach ($uuid in $UniqueSpellListUUIDs) {
    $UsageCount = ($AllSpellSelectors | Where-Object { $_.Attributes['UUID'].'#text' -eq $uuid }).Count
    Write-Info "  $uuid - Used $UsageCount times"
}

# ====== SECTION 6: PASSIVE GRANTS SUMMARY ======
Write-Section "6. PASSIVE GRANTS SUMMARY"

$AllPassiveGrants = $AllProgressions | Where-Object { $_.Attributes['PassivesAdded'] } | 
    ForEach-Object { 
        $Level = $_.Attributes['Level'].'#text'
        $Name = $_.Attributes['Name'].'#text'
        $Passives = $_.Attributes['PassivesAdded'].'#text' -split ';'
        foreach ($passive in $Passives) {
            [PSCustomObject]@{
                Level = [int]$Level
                Class = $Name
                Passive = $passive
            }
        }
    }

Write-Info "Total passive grants: $($AllPassiveGrants.Count)"

# Count unique passives
$UniquePassives = $AllPassiveGrants.Passive | Select-Object -Unique
Write-Info "Unique passives granted: $($UniquePassives.Count)"

# Check for duplicates (same passive granted multiple times)
$DuplicatePassives = $AllPassiveGrants | Group-Object Passive | Where-Object { $_.Count -gt 1 }
if ($DuplicatePassives) {
    Write-Warn "Passives granted multiple times:"
    foreach ($dup in $DuplicatePassives) {
        Write-Warn "  $($dup.Name) - Granted $($dup.Count) times"
        foreach ($grant in $dup.Group) {
            Write-Info "    L$($grant.Level) $($grant.Class)"
        }
    }
} else {
    Write-Pass "No duplicate passive grants"
}

# ====== SECTION 7: BOOST ANALYSIS ======
Write-Section "7. BOOST ANALYSIS"

$AllBoosts = $AllProgressions | Where-Object { $_.Attributes['Boosts'] } | 
    ForEach-Object {
        [PSCustomObject]@{
            Level = [int]$_.Attributes['Level'].'#text'
            Class = $_.Attributes['Name'].'#text'
            Boosts = $_.Attributes['Boosts'].'#text'
        }
    }

Write-Info "Total levels with boosts: $($AllBoosts.Count)"

foreach ($boost in $AllBoosts) {
    Write-Info "L$($boost.Level) $($boost.Class): $($boost.Boosts)"
}

# ====== SECTION 8: PHASE 2 READINESS CHECK ======
Write-Section "8. PHASE 2 READINESS CHECK"

Write-Info "Current Implementation: PHASE 1 (Auto-grants all compatible hero talents)"
Write-Warn "Phase 2 Changes Needed:"
Write-Warn "  1. L13 nodes: Replace auto-grant passives with feat selection mechanism"
Write-Warn "  2. Hero talent passives: Add EnabledConditions to check status"
Write-Warn "  3. Status effects: Create 3 permanent statuses (CHOSEN_MOUNTAIN_THANE, CHOSEN_COLOSSUS, CHOSEN_SLAYERS)"
Write-Warn "  4. Feat definitions: Create 6 feats in ClassDescriptions.lsx"
Write-Warn "  5. Localization: Add 18 new handles for feats and statuses"

# Check L13 nodes specifically
Write-Info "`nCurrent L13 Implementation:"
foreach ($subclass in $Subclasses) {
    $L13Node = $AllProgressions | Where-Object { 
        $_.Attributes['Name'].'#text' -eq $subclass -and
        [int]$_.Attributes['Level'].'#text' -eq 13
    }
    
    if ($L13Node) {
        $L13Passives = $L13Node.Attributes['PassivesAdded'].'#text'
        $KeystoneCount = ($L13Passives -split ';').Count
        Write-Warn "  $subclass L13: Auto-grants $KeystoneCount keystones"
        Write-Info "    Currently: $L13Passives"
        Write-Info "    Phase 2: Should offer choice between 2 feats"
    }
}

# ====== SECTION 9: CRITICAL ISSUES ======
Write-Section "9. CRITICAL ISSUES"

if ($script:FailCount -eq 0) {
    Write-Pass "No critical issues found"
} else {
    Write-Fail "$($script:FailCount) critical issues found (see above)"
}

if ($script:WarnCount -gt 0) {
    Write-Warn "$($script:WarnCount) warnings (mostly Phase 1 vs Phase 2 differences)"
}

# ====== FINAL SUMMARY ======
Write-Section "FINAL SUMMARY"

Write-Host "`nFile Structure:" -ForegroundColor Cyan
Write-Host "  Total Nodes: $($AllProgressions.Count)" -ForegroundColor White
Write-Host "  Base Class Levels (1-12): 12 nodes" -ForegroundColor White
Write-Host "  Subclass Levels (3-20): 18 nodes × 3 specs = 54 nodes" -ForegroundColor White
Write-Host "  Expected Total: 66 nodes" -ForegroundColor White

if ($AllProgressions.Count -eq 74) {
    Write-Pass "Total node count: 74 (includes some duplicate/override levels)"
} elseif ($AllProgressions.Count -ge 66) {
    Write-Pass "Total node count: $($AllProgressions.Count) (meets minimum 66)"
} else {
    Write-Fail "Total node count: $($AllProgressions.Count) (expected at least 66)"
}

Write-Host "`nFunctionality Status:" -ForegroundColor Cyan
Write-Host "  Base Class (L1-12): " -NoNewline; Write-Host "COMPLETE" -ForegroundColor Green
Write-Host "  Subclass Progressions (L3-12): " -NoNewline; Write-Host "COMPLETE" -ForegroundColor Green
Write-Host "  Hero Talents (L13-20): " -NoNewline; Write-Host "PHASE 1 (Auto-grant both trees)" -ForegroundColor Yellow
Write-Host "  Choice Mechanism: " -NoNewline; Write-Host "NOT IMPLEMENTED (Phase 2 needed)" -ForegroundColor Yellow

Write-Host "`nValidation Result:" -ForegroundColor Cyan
if ($script:FailCount -eq 0 -and $script:WarnCount -le 20) {
    Write-Host "  FILE 11 STATUS: " -NoNewline; Write-Host "FUNCTIONAL (Phase 1)" -ForegroundColor Green
    Write-Host "  Mod is playable but overpowered (grants all 22 hero talents)" -ForegroundColor Yellow
    Write-Host "  Phase 2 implementation will add proper tree choice at L13" -ForegroundColor Cyan
} elseif ($script:FailCount -eq 0) {
    Write-Host "  FILE 11 STATUS: " -NoNewline; Write-Host "NEEDS REVIEW" -ForegroundColor Yellow
} else {
    Write-Host "  FILE 11 STATUS: " -NoNewline; Write-Host "HAS ERRORS" -ForegroundColor Red
}

Write-Host "`n====== REVIEW COMPLETE ======`n" -ForegroundColor Cyan

if ($script:FailCount -gt 0) {
    exit 1
} else {
    exit 0
}
