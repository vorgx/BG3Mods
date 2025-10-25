# Validate L1-L20 Full Implementation - Virtual Playthrough
# Simulates character creation through L20 and validates all files

param(
    [switch]$Verbose
)

$ErrorActionPreference = "Stop"
$FailCount = 0
$WarnCount = 0

# Color helpers
function Write-Pass { param($Message) Write-Host "[PASS] $Message" -ForegroundColor Green }
function Write-Fail { param($Message) Write-Host "[FAIL] $Message" -ForegroundColor Red; $script:FailCount++ }
function Write-Warn { param($Message) Write-Host "[WARN] $Message" -ForegroundColor Yellow; $script:WarnCount++ }
function Write-Info { param($Message) Write-Host "[INFO] $Message" -ForegroundColor Cyan }
function Write-Section { param($Message) Write-Host "`n========================================" -ForegroundColor Magenta; Write-Host $Message -ForegroundColor Magenta; Write-Host "========================================" -ForegroundColor Magenta }

# File paths
$BasePath = "C:\Users\tenod\source\repos\BG3Mods"
$DataPath = "$BasePath\Data\Public\Warrior_Wow_78fe4967-4e62-5491-d981-dd781acca4d7"
$ClassDescFile = "$DataPath\ClassDescriptions\ClassDescriptions.lsx"
$ProgressionsFile = "$DataPath\Progressions\Progressions.lsx"
$SpellListsFile = "$DataPath\Lists\SpellLists.lsx"
$DatabaseFile = "$BasePath\Documentation\00_SourcesOfTruth\AbilityDatabase_Warrior_FullyEnriched.csv"
$LinkedCsvFile = "$BasePath\Documentation\00_SourcesOfTruth\Warrior Progression LINKED - Main.csv"

Write-Section "FULL IMPLEMENTATION VALIDATION - L1 TO L20"
Write-Info "Simulating character creation and progression..."
Write-Info "Date: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')`n"

# ========================================
# PHASE 1: FILE EXISTENCE CHECK
# ========================================
Write-Section "PHASE 1: CRITICAL FILES EXISTENCE"

$RequiredFiles = @(
    @{ Path = $ClassDescFile; Name = "ClassDescriptions.lsx" },
    @{ Path = $ProgressionsFile; Name = "Progressions.lsx" },
    @{ Path = $SpellListsFile; Name = "SpellLists.lsx" },
    @{ Path = $DatabaseFile; Name = "AbilityDatabase" },
    @{ Path = $LinkedCsvFile; Name = "LINKED CSV" }
)

foreach ($File in $RequiredFiles) {
    if (Test-Path $File.Path) {
        Write-Pass "$($File.Name) exists"
    } else {
        Write-Fail "$($File.Name) NOT FOUND at $($File.Path)"
    }
}

# ========================================
# PHASE 2: CHARACTER CREATION (L1)
# ========================================
Write-Section "PHASE 2: CHARACTER CREATION (LEVEL 1)"

Write-Info "Loading ClassDescriptions.lsx..."
[xml]$ClassDesc = Get-Content $ClassDescFile -Raw

# Check base Warrior class
$BaseClass = $ClassDesc.save.region.node.children.node | Where-Object { 
    ($_.attribute | Where-Object { $_.id -eq "Name" }).value -eq "WoWWarrior"
}

if ($BaseClass) {
    Write-Pass "Base Warrior class found"
    $BaseUUID = ($BaseClass.attribute | Where-Object { $_.id -eq "UUID" }).value
    $BaseProgressionUUID = ($BaseClass.attribute | Where-Object { $_.id -eq "ProgressionTableUUID" }).value
    Write-Info "  UUID: $BaseUUID"
    Write-Info "  ProgressionTableUUID: $BaseProgressionUUID"
} else {
    Write-Fail "Base Warrior class NOT FOUND"
}

# Check 3 subclasses (Arms, Fury, Protection)
$Subclasses = @("ArmsWarrior", "FuryWarrior", "ProtectionWarrior")
$FoundSubclasses = @()

foreach ($SubclassName in $Subclasses) {
    $Subclass = $ClassDesc.save.region.node.children.node | Where-Object {
        ($_.attribute | Where-Object { $_.id -eq "Name" }).value -eq $SubclassName
    }
    
    if ($Subclass) {
        Write-Pass "Subclass '$SubclassName' found"
        $FoundSubclasses += $SubclassName
        $SubUUID = ($Subclass.attribute | Where-Object { $_.id -eq "UUID" }).value
        $SubProgressionUUID = ($Subclass.attribute | Where-Object { $_.id -eq "ProgressionTableUUID" }).value
        if ($Verbose) {
            Write-Info "  UUID: $SubUUID"
            Write-Info "  ProgressionTableUUID: $SubProgressionUUID"
        }
    } else {
        Write-Fail "Subclass '$SubclassName' NOT FOUND"
    }
}

# Check 6 hero subclasses
$HeroSubclasses = @(
    "ArmsColossus", "ArmsSlayers",
    "FuryMountainThane", "FurySlayers",
    "ProtectionMountainThane", "ProtectionColossus"
)
$FoundHeroSubclasses = @()

foreach ($HeroName in $HeroSubclasses) {
    $HeroClass = $ClassDesc.save.region.node.children.node | Where-Object {
        ($_.attribute | Where-Object { $_.id -eq "Name" }).value -eq $HeroName
    }
    
    if ($HeroClass) {
        Write-Pass "Hero subclass '$HeroName' found"
        $FoundHeroSubclasses += $HeroName
    } else {
        Write-Fail "Hero subclass '$HeroName' NOT FOUND"
    }
}

Write-Info "`nCharacter Creation Summary:"
Write-Info "  Base class: $(if ($BaseClass) { 'READY' } else { 'MISSING' })"
Write-Info "  Subclasses: $($FoundSubclasses.Count)/3 found"
Write-Info "  Hero subclasses: $($FoundHeroSubclasses.Count)/6 found"

# ========================================
# PHASE 3: PROGRESSIONS L1-L12 (BASE + SUBCLASS)
# ========================================
Write-Section "PHASE 3: PROGRESSIONS L1-L12 (BASE + SUBCLASS)"

Write-Info "Loading Progressions.lsx..."
[xml]$Progressions = Get-Content $ProgressionsFile -Raw
$AllProgressions = $Progressions.save.region.node.children.node

Write-Info "Total progression nodes found: $($AllProgressions.Count)"

# Count progression nodes by type
$BaseProgressions = $AllProgressions | Where-Object {
    ($_.attribute | Where-Object { $_.id -eq "TableUUID" }).value -eq $BaseProgressionUUID
}

if ($BaseProgressions) {
    Write-Pass "Base Warrior progressions found ($($BaseProgressions.Count) nodes)"
    
    # Check L1-L12 levels
    for ($Level = 1; $Level -le 12; $Level++) {
        $LevelNode = $BaseProgressions | Where-Object {
            ($_.attribute | Where-Object { $_.id -eq "Level" }).value -eq $Level.ToString()
        }
        
        if ($LevelNode) {
            $Boosts = ($LevelNode.attribute | Where-Object { $_.id -eq "Boosts" }).value
            $PassivesAdded = ($LevelNode.attribute | Where-Object { $_.id -eq "PassivesAdded" }).value
            $AddSpells = $LevelNode.children.node | Where-Object { $_.id -eq "AddSpells" }
            $Spells = if ($AddSpells) { ($AddSpells.attribute | Where-Object { $_.id -eq "Spells" }).value } else { "" }
            
            if ($Boosts -or $PassivesAdded -or $Spells) {
                Write-Pass "  L$Level progression exists (Boosts: $($null -ne $Boosts), Passives: $($null -ne $PassivesAdded), Spells: $($Spells -ne ''))"
            } else {
                Write-Warn "  L$Level progression has NO grants"
            }
        } else {
            Write-Fail "  L$Level progression MISSING"
        }
    }
} else {
    Write-Fail "Base Warrior progressions NOT FOUND (TableUUID: $BaseProgressionUUID)"
}

# Check subclass progressions
foreach ($SubclassName in $FoundSubclasses) {
    $Subclass = $ClassDesc.save.region.node.children.node | Where-Object {
        ($_.attribute | Where-Object { $_.id -eq "Name" }).value -eq $SubclassName
    }
    $SubProgressionUUID = ($Subclass.attribute | Where-Object { $_.id -eq "ProgressionTableUUID" }).value
    
    $SubProgressions = $AllProgressions | Where-Object {
        ($_.attribute | Where-Object { $_.id -eq "TableUUID" }).value -eq $SubProgressionUUID
    }
    
    if ($SubProgressions) {
        Write-Pass "$SubclassName progressions found ($($SubProgressions.Count) nodes)"
    } else {
        Write-Fail "$SubclassName progressions NOT FOUND (TableUUID: $SubProgressionUUID)"
    }
}

# ========================================
# PHASE 4: HERO SUBCLASS PROGRESSIONS L13-L20
# ========================================
Write-Section "PHASE 4: HERO SUBCLASS PROGRESSIONS L13-L20"

Write-Info "Validating 6 hero subclass progressions (48 nodes expected)..."

$HeroProgressionCount = 0

foreach ($HeroName in $FoundHeroSubclasses) {
    $HeroClass = $ClassDesc.save.region.node.children.node | Where-Object {
        ($_.attribute | Where-Object { $_.id -eq "Name" }).value -eq $HeroName
    }
    $HeroProgressionUUID = ($HeroClass.attribute | Where-Object { $_.id -eq "ProgressionTableUUID" }).value
    
    $HeroProgressions = $AllProgressions | Where-Object {
        ($_.attribute | Where-Object { $_.id -eq "TableUUID" }).value -eq $HeroProgressionUUID
    }
    
    if ($HeroProgressions) {
        Write-Pass "$HeroName progressions found ($($HeroProgressions.Count) nodes)"
        $HeroProgressionCount += $HeroProgressions.Count
        
        # Check L13-L20 levels
        for ($Level = 13; $Level -le 20; $Level++) {
            $LevelNode = $HeroProgressions | Where-Object {
                ($_.attribute | Where-Object { $_.id -eq "Level" }).value -eq $Level.ToString()
            }
            
            if ($LevelNode) {
                $PassivesAdded = ($LevelNode.attribute | Where-Object { $_.id -eq "PassivesAdded" }).value
                if ($PassivesAdded) {
                    if ($Verbose) {
                        Write-Info "    Level $Level - Passives = $PassivesAdded"
                    }
                } else {
                    # Empty nodes are OK (placeholder levels L14/16/18)
                    if ($Verbose) {
                        Write-Info "    Level $Level - Empty (placeholder)"
                    }
                }
            } else {
                Write-Fail "  $HeroName Level ${Level} progression MISSING"
            }
        }
    } else {
        Write-Fail "$HeroName progressions NOT FOUND (TableUUID: $HeroProgressionUUID)"
    }
}

Write-Info "`nHero Subclass Summary:"
Write-Info "  Total hero progression nodes: $HeroProgressionCount (expected: 48)"
if ($HeroProgressionCount -eq 48) {
    Write-Pass "Hero progression count correct!"
} else {
    Write-Fail "Hero progression count mismatch! (expected 48, got $HeroProgressionCount)"
}

# ========================================
# PHASE 5: SPELL LISTS VALIDATION
# ========================================
Write-Section "PHASE 5: SPELL LISTS VALIDATION"

Write-Info "Loading SpellLists.lsx..."
[xml]$SpellLists = Get-Content $SpellListsFile -Raw
$AllSpellLists = $SpellLists.save.region.node.children.node | Where-Object { $_.id -eq "SpellList" }

Write-Info "Total SpellList nodes found: $($AllSpellLists.Count) (expected: 66)"

if ($AllSpellLists.Count -eq 66) {
    Write-Pass "SpellList count correct!"
} else {
    Write-Warn "SpellList count: $($AllSpellLists.Count) (expected 66)"
}

# Count hero subclass spell lists
$HeroSpellListCount = 0
foreach ($HeroName in $HeroSubclasses) {
    $HeroSpellLists = $AllSpellLists | Where-Object {
        $CommentAttr = $_.attribute | Where-Object { $_.id -eq "Comment" }
        $CommentAttr.value -like "*$HeroName*"
    }
    
    if ($HeroSpellLists) {
        Write-Pass "$HeroName SpellLists found ($($HeroSpellLists.Count) nodes)"
        $HeroSpellListCount += $HeroSpellLists.Count
    } else {
        Write-Fail "$HeroName SpellLists NOT FOUND"
    }
}

Write-Info "`nSpellList Summary:"
Write-Info "  Hero subclass SpellLists: $HeroSpellListCount (expected: 30)"
if ($HeroSpellListCount -eq 30) {
    Write-Pass "Hero SpellList count correct!"
} else {
    Write-Fail "Hero SpellList count mismatch! (expected 30, got $HeroSpellListCount)"
}

# ========================================
# PHASE 6: CROSS-REFERENCE VALIDATION
# ========================================
Write-Section "PHASE 6: CROSS-REFERENCE VALIDATION"

Write-Info "Checking ProgressionTableUUID references..."

# Verify all ProgressionTableUUIDs in ClassDescriptions match Progressions
$AllClasses = $ClassDesc.save.region.node.children.node
$OrphanedProgressions = 0

foreach ($Class in $AllClasses) {
    $ClassName = ($Class.attribute | Where-Object { $_.id -eq "Name" }).value
    $ProgressionUUID = ($Class.attribute | Where-Object { $_.id -eq "ProgressionTableUUID" }).value
    
    $MatchingProgressions = $AllProgressions | Where-Object {
        ($_.attribute | Where-Object { $_.id -eq "TableUUID" }).value -eq $ProgressionUUID
    }
    
    if ($MatchingProgressions) {
        Write-Pass "$ClassName ProgressionTableUUID referenced in Progressions.lsx ($($MatchingProgressions.Count) nodes)"
    } else {
        Write-Fail "$ClassName ProgressionTableUUID NOT FOUND in Progressions.lsx (UUID: $ProgressionUUID)"
        $OrphanedProgressions++
    }
}

if ($OrphanedProgressions -eq 0) {
    Write-Pass "All ProgressionTableUUIDs cross-referenced successfully"
} else {
    Write-Fail "$OrphanedProgressions orphaned ProgressionTableUUID(s) found"
}

# ========================================
# PHASE 7: ABILITY DATABASE CROSS-CHECK
# ========================================
Write-Section "PHASE 7: ABILITY DATABASE VALIDATION"

Write-Info "Loading ability database..."
$Database = Import-Csv $DatabaseFile

Write-Info "Total abilities in database: $($Database.Count)"

# Count abilities by type
$SpellAbilities = $Database | Where-Object { $_.bg3_file_type -like "Spell_*" }
$PassiveAbilities = $Database | Where-Object { $_.bg3_file_type -eq "Passive" }
$StatusAbilities = $Database | Where-Object { $_.bg3_file_type -like "Status_*" }

Write-Info "  Spell abilities: $($SpellAbilities.Count)"
Write-Info "  Passive abilities: $($PassiveAbilities.Count)"
Write-Info "  Status abilities: $($StatusAbilities.Count)"

# Check implementation status
$ImplementedAbilities = $Database | Where-Object { $_.implementation_status -eq "Implemented" }
$TestedAbilities = $Database | Where-Object { $_.tested_in_game -eq "Yes" }

Write-Info "`nImplementation Status:"
Write-Info "  Implemented: $($ImplementedAbilities.Count)/$($Database.Count) ($([math]::Round($ImplementedAbilities.Count / $Database.Count * 100, 1))%)"
Write-Info "  Tested in-game: $($TestedAbilities.Count)/$($Database.Count)"

# ========================================
# FINAL REPORT
# ========================================
Write-Section "FINAL VALIDATION REPORT"

Write-Host "`nVALIDATION SUMMARY:" -ForegroundColor Cyan
Write-Host "===================" -ForegroundColor Cyan
Write-Host "  Passes:   " -NoNewline; Write-Host $($AllProgressions.Count - $FailCount) -ForegroundColor Green
Write-Host "  Failures: " -NoNewline; Write-Host $FailCount -ForegroundColor Red
Write-Host "  Warnings: " -NoNewline; Write-Host $WarnCount -ForegroundColor Yellow

Write-Host "`nIMPLEMENTATION READINESS:" -ForegroundColor Cyan
Write-Host "==========================" -ForegroundColor Cyan
Write-Host "  Base Class:        " -NoNewline
if ($BaseClass) { Write-Host "READY" -ForegroundColor Green } else { Write-Host "MISSING" -ForegroundColor Red }

Write-Host "  Subclasses (3):    " -NoNewline
if ($FoundSubclasses.Count -eq 3) { Write-Host "READY" -ForegroundColor Green } else { Write-Host "INCOMPLETE ($($FoundSubclasses.Count)/3)" -ForegroundColor Yellow }

Write-Host "  Hero Subclasses (6): " -NoNewline
if ($FoundHeroSubclasses.Count -eq 6) { Write-Host "READY" -ForegroundColor Green } else { Write-Host "INCOMPLETE ($($FoundHeroSubclasses.Count)/6)" -ForegroundColor Yellow }

Write-Host "  Progressions L1-12: " -NoNewline
if ($BaseProgressions -and $FoundSubclasses.Count -eq 3) { Write-Host "READY" -ForegroundColor Green } else { Write-Host "INCOMPLETE" -ForegroundColor Yellow }

Write-Host "  Progressions L13-20: " -NoNewline
if ($HeroProgressionCount -eq 48) { Write-Host "READY (48/48 nodes)" -ForegroundColor Green } else { Write-Host "INCOMPLETE ($HeroProgressionCount/48)" -ForegroundColor Yellow }

Write-Host "  SpellLists:        " -NoNewline
if ($AllSpellLists.Count -eq 66 -and $HeroSpellListCount -eq 30) { Write-Host "READY (66 total, 30 hero)" -ForegroundColor Green } else { Write-Host "INCOMPLETE" -ForegroundColor Yellow }

Write-Host "`nOVERALL STATUS: " -NoNewline
if ($FailCount -eq 0) {
    Write-Host "PASS - READY FOR IN-GAME TESTING" -ForegroundColor Green -BackgroundColor DarkGreen
} elseif ($FailCount -le 5) {
    Write-Host "PARTIAL - MINOR ISSUES FOUND" -ForegroundColor Yellow -BackgroundColor DarkYellow
} else {
    Write-Host "FAIL - CRITICAL ISSUES FOUND" -ForegroundColor Red -BackgroundColor DarkRed
}

Write-Host ""

# Exit with appropriate code
if ($FailCount -gt 0) {
    exit 1
} else {
    exit 0
}
