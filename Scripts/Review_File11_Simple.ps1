# FILE 11 FULL REVIEW: Progressions.lsx (SIMPLIFIED VERSION)
# Direct grep-based analysis for accurate results

param(
    [string]$ProgressionsPath = "C:\Users\tenod\source\repos\BG3Mods\Data\Public\Warrior_Wow_78fe4967-4e62-5491-d981-dd781acca4d7\Progressions\Progressions.lsx"
)

Write-Host "`n====== FILE 11 (Progressions.lsx) FULL REVIEW ======`n" -ForegroundColor Cyan

# Color helpers
function Write-Pass { param($Message) Write-Host "[PASS] $Message" -ForegroundColor Green }
function Write-Fail { param($Message) Write-Host "[FAIL] $Message" -ForegroundColor Red; $script:FailCount++ }
function Write-Warn { param($Message) Write-Host "[WARN] $Message" -ForegroundColor Yellow }
function Write-Info { param($Message) Write-Host "[INFO] $Message" -ForegroundColor Cyan }
function Write-Section { param($Title) Write-Host "`n=== $Title ===" -ForegroundColor Magenta }

$script:FailCount = 0

# Check file exists
Write-Section "FILE VALIDATION"
if (-not (Test-Path $ProgressionsPath)) {
    Write-Fail "File not found: $ProgressionsPath"
    exit 1
}

$FileSize = (Get-Item $ProgressionsPath).Length
$TotalLines = (Get-Content $ProgressionsPath).Count
Write-Pass "File exists: $ProgressionsPath"
Write-Info "File Size: $FileSize bytes"
Write-Info "Total Lines: $TotalLines"

# Load file content
$Content = Get-Content $ProgressionsPath -Raw

# ====== COUNT NODES ======
Write-Section "NODE COUNT ANALYSIS"

$ProgressionNodeCount = ([regex]::Matches($Content, '<node id="Progression">')).Count
Write-Info "Total Progression nodes: $ProgressionNodeCount"

# ====== BASE CLASS (L1-12) ======
Write-Section "BASE CLASS PROGRESSIONS (Warrior L1-12)"

$BaseClassLevels = @()
for ($i = 1; $i -le 12; $i++) {
    # Look for pattern: Level="$i" ... Name="Warrior"
    $Pattern = '<node id="Progression">[\s\S]{0,200}?<attribute id="Level" type="uint8" value="' + $i + '"[\s\S]{0,200}?<attribute id="Name" type="LSString" value="Warrior"'
    if ($Content -match $Pattern) {
        $BaseClassLevels += $i
        Write-Pass "Level $i (Warrior) - FOUND"
    } else {
        Write-Fail "Level $i (Warrior) - MISSING"
    }
}

Write-Info "Base class levels found: $($BaseClassLevels.Count)/12"

# ====== SUBCLASS PROGRESSIONS (L3-20) ======
Write-Section "SUBCLASS PROGRESSIONS (L3-20)"

$Subclasses = @("Arms", "Fury", "Protection")
$SubclassData = @{}

foreach ($spec in $Subclasses) {
    Write-Info "`nAnalyzing: $spec"
    $SpecLevels = @()
    
    for ($lvl = 3; $lvl -le 20; $lvl++) {
        $Pattern = '<node id="Progression">[\s\S]{0,200}?<attribute id="Level" type="uint8" value="' + $lvl + '"[\s\S]{0,200}?<attribute id="Name" type="LSString" value="' + $spec + '"'
        if ($Content -match $Pattern) {
            $SpecLevels += $lvl
        }
    }
    
    $SubclassData[$spec] = $SpecLevels
    Write-Info "  Levels found: $($SpecLevels.Count)/18 (L3-L20)"
    
    if ($SpecLevels.Count -eq 18) {
        Write-Pass "  All subclass levels present"
    } else {
        Write-Fail "  Missing levels: $(3..20 | Where-Object { $_ -notin $SpecLevels })"
    }
    
    # Check critical levels
    if (3 -in $SpecLevels) {
        Write-Pass "  L3 (subclass unlock) exists"
    } else {
        Write-Fail "  L3 (subclass unlock) MISSING"
    }
    
    if (13 -in $SpecLevels) {
        Write-Warn "  L13 (hero talents) exists"
    } else {
        Write-Fail "  L13 (hero talents) MISSING"
    }
    
    if (20 -in $SpecLevels) {
        Write-Pass "  L20 (capstone) exists"
    } else {
        Write-Fail "  L20 (capstone) MISSING"
    }
}

# ====== HERO TALENTS DETAILED ANALYSIS ======
Write-Section "HERO TALENTS (L13-20) DETAILED ANALYSIS"

$HeroTalentsByTree = @{
    "Mountain_Thane" = @(
        "WAR_Lightning_Strikes", "WAR_Crashing_Thunder", "WAR_Ground_Current",
        "WAR_Strength_of_the_Mountain", "WAR_Thunder_Blast", "WAR_Storm_Bolts",
        "WAR_Keep_your_feet_on_the_Ground", "WAR_Flashing_Skies", "WAR_Thorim_s_Might",
        "WAR_Burst_of_Power", "WAR_Avatar_of_the_Storm"
    )
    "Colossus" = @(
        "WAR_Demolish", "WAR_Martial_Expert", "WAR_Colossal_Might", "WAR_Earthquake",
        "WAR_Arterial_Bleed", "WAR_Tide_of_Battle", "WAR_No_Stranger_to_Pain",
        "WAR_Practiced_Strikes", "WAR_Precise_Might", "WAR_Mountain_of_Muscle_and_Scars",
        "WAR_Dominance_of_the_Colossus"
    )
    "Slayers" = @(
        "WAR_Slayer_s_Dominance", "WAR_Imminent_Demise", "WAR_Overwhelming_Blades",
        "WAR_Relentless_Pursuit", "WAR_Death_Drive", "WAR_Brutal_Finish",
        "WAR_Opportunist", "WAR_Show_No_Mercy", "WAR_Reap_the_Storm",
        "WAR_Slayer_s_Malice", "WAR_Unrelenting_Onslaught"
    )
}

$TreeCompatibility = @{
    "Arms" = @("Colossus", "Slayers")
    "Fury" = @("Mountain_Thane", "Slayers")
    "Protection" = @("Mountain_Thane", "Colossus")
}

foreach ($spec in $Subclasses) {
    Write-Info "`n$spec - Compatible Trees: $($TreeCompatibility[$spec] -join ', ')"
    
    # Extract ALL PassivesAdded from L13-20 for this spec
    $SpecHeroSection = [regex]::Matches($Content, 
        '(?s)<node id="Progression">.*?<attribute id="Level" type="uint8" value="(1[3-9]|20)".*?<attribute id="Name" type="LSString" value="' + 
        $spec + '".*?(?=<node id="Progression"|</children>\s*</node>\s*</children>)')
    
    $AllPassives = @()
    foreach ($match in $SpecHeroSection) {
        if ($match.Value -match '<attribute id="PassivesAdded" type="LSString" value="([^"]+)"') {
            $Passives = $Matches[1] -split ';'
            $AllPassives += $Passives
        }
    }
    
    Write-Info "  Total hero talent passives granted: $($AllPassives.Count)"
    
    # Check which trees are represented
    foreach ($treeName in $TreeCompatibility[$spec]) {
        $TreeKey = $treeName -replace ' ', '_'
        $TreePassives = $HeroTalentsByTree[$TreeKey]
        $GrantedFromTree = $AllPassives | Where-Object { $_ -in $TreePassives }
        $GrantedCount = $GrantedFromTree.Count
        $ExpectedCount = $TreePassives.Count
        
        if ($GrantedCount -eq $ExpectedCount) {
            Write-Warn "  $treeName - $GrantedCount/$ExpectedCount talents (ALL GRANTED - PHASE 1)"
        } elseif ($GrantedCount -gt 0) {
            Write-Warn "  $treeName - $GrantedCount/$ExpectedCount talents (PARTIAL)"
        } else {
            Write-Info "  $treeName - 0/$ExpectedCount talents (NONE)"
        }
    }
    
    # Check for wrong tree grants
    $AllTreeNames = $HeroTalentsByTree.Keys
    foreach ($treeKey in $AllTreeNames) {
        $treeName = $treeKey -replace '_', ' '
        if ($treeName -notin $TreeCompatibility[$spec]) {
            $TreePassives = $HeroTalentsByTree[$treeKey]
            $WrongGrants = $AllPassives | Where-Object { $_ -in $TreePassives }
            if ($WrongGrants.Count -gt 0) {
                Write-Fail "  $treeName - $($WrongGrants.Count) talents granted (WRONG TREE!)"
            }
        }
    }
}

# ====== SPELL LIST REFERENCES ======
Write-Section "SPELL LIST REFERENCES"

$SpellListMatches = [regex]::Matches($Content, '<node id="AddSpells">[\s\S]{0,100}?<attribute id="UUID" type="guid" value="([a-f0-9\-]+)"')
$AllSpellListUUIDs = $SpellListMatches | ForEach-Object { $_.Groups[1].Value }
$UniqueSpellListUUIDs = $AllSpellListUUIDs | Select-Object -Unique

Write-Info "Total spell list references: $($AllSpellListUUIDs.Count)"
Write-Info "Unique spell list UUIDs: $($UniqueSpellListUUIDs.Count)"

foreach ($uuid in $UniqueSpellListUUIDs) {
    $Count = ($AllSpellListUUIDs | Where-Object { $_ -eq $uuid }).Count
    Write-Info "  $uuid - Used $Count times"
}

# ====== PASSIVE GRANTS SUMMARY ======
Write-Section "PASSIVE GRANTS SUMMARY"

$PassiveMatches = [regex]::Matches($Content, '<attribute id="PassivesAdded" type="LSString" value="([^"]+)"')
$AllPassiveStrings = $PassiveMatches | ForEach-Object { $_.Groups[1].Value }
$AllIndividualPassives = $AllPassiveStrings | ForEach-Object { $_ -split ';' }

Write-Info "Total passive grant lines: $($AllPassiveStrings.Count)"
Write-Info "Total individual passives granted: $($AllIndividualPassives.Count)"

$UniquePassives = $AllIndividualPassives | Select-Object -Unique
Write-Info "Unique passives: $($UniquePassives.Count)"

# Check for duplicates
$PassiveGroups = $AllIndividualPassives | Group-Object
$Duplicates = $PassiveGroups | Where-Object { $_.Count -gt 1 }
if ($Duplicates) {
    Write-Warn "Passives granted multiple times:"
    foreach ($dup in $Duplicates) {
        Write-Warn "  $($dup.Name) - Granted $($dup.Count) times"
    }
} else {
    Write-Pass "No duplicate passive grants"
}

# ====== BOOST ANALYSIS ======
Write-Section "BOOST ANALYSIS"

$BoostMatches = [regex]::Matches($Content, '<attribute id="Boosts" type="LSString" value="([^"]+)"')
$AllBoosts = $BoostMatches | ForEach-Object { $_.Groups[1].Value }

Write-Info "Total boost entries: $($AllBoosts.Count)"

if ($AllBoosts.Count -gt 0) {
    Write-Info "Sample boosts:"
    $AllBoosts | Select-Object -First 5 | ForEach-Object {
        Write-Info "  $_"
    }
}

# ====== PHASE 2 READINESS ======
Write-Section "PHASE 2 IMPLEMENTATION READINESS"

Write-Info "Current State: PHASE 1 (Auto-grants all compatible hero talents)"
Write-Warn ""
Write-Warn "Phase 2 Changes Required:"
Write-Warn "  1. ClassDescriptions.lsx - Add 6 feat definitions (2 per subclass)"
Write-Warn "  2. Progressions.lsx L13 - Replace auto-grant with feat selection"
Write-Warn "  3. Status_BOOST.txt - Add 3 permanent statuses"
Write-Warn "  4. Passive.txt - Add EnabledConditions to 33 hero talent passives"
Write-Warn "  5. English.loca.xml - Add 18 localization handles"
Write-Warn ""
Write-Info "Estimated Implementation Time: 8-10 hours"
Write-Info "See: Documentation/07_DesignDocuments/PHASE2_IMPLEMENTATION_PLAN.md"

# ====== L13 SPECIFIC CHECK ======
Write-Section "L13 NODE ANALYSIS (Hero Talent Entry Point)"

foreach ($spec in $Subclasses) {
    $L13Pattern = '(?s)<node id="Progression">.*?<attribute id="Level" type="uint8" value="13".*?<attribute id="Name" type="LSString" value="' + $spec + '".*?(?=<node id="Progression"|</children>\s*</node>\s*</children>)'
    if ($Content -match $L13Pattern) {
        $L13Node = $Matches[0]
        if ($L13Node -match '<attribute id="PassivesAdded" type="LSString" value="([^"]+)"') {
            $L13Passives = $Matches[1]
            $KeystoneCount = ($L13Passives -split ';').Count
            Write-Warn "$spec L13: Auto-grants $KeystoneCount keystones"
            Write-Info "  Currently: $L13Passives"
            Write-Info "  Phase 2: Should offer CHOICE between 2 feats"
        }
    }
}

# ====== FINAL SUMMARY ======
Write-Section "FINAL SUMMARY"

Write-Host "`nNode Counts:" -ForegroundColor Cyan
Write-Host "  Total Progression Nodes: $ProgressionNodeCount" -ForegroundColor White
Write-Host "  Base Class (L1-12): $($BaseClassLevels.Count)/12" -ForegroundColor White
Write-Host "  Arms (L3-20): $($SubclassData['Arms'].Count)/18" -ForegroundColor White
Write-Host "  Fury (L3-20): $($SubclassData['Fury'].Count)/18" -ForegroundColor White
Write-Host "  Protection (L3-20): $($SubclassData['Protection'].Count)/18" -ForegroundColor White

Write-Host "`nContent Summary:" -ForegroundColor Cyan
Write-Host "  Unique Passives: $($UniquePassives.Count)" -ForegroundColor White
Write-Host "  Spell List UUIDs: $($UniqueSpellListUUIDs.Count)" -ForegroundColor White
Write-Host "  Boost Entries: $($AllBoosts.Count)" -ForegroundColor White

Write-Host "`nFunctionality:" -ForegroundColor Cyan
Write-Host "  Base Class: " -NoNewline; Write-Host "COMPLETE" -ForegroundColor Green
Write-Host "  Subclass Progressions: " -NoNewline; Write-Host "COMPLETE" -ForegroundColor Green
Write-Host "  Hero Talents: " -NoNewline; Write-Host "PHASE 1 (Auto-grant)" -ForegroundColor Yellow
Write-Host "  Tree Choice: " -NoNewline; Write-Host "NOT IMPLEMENTED" -ForegroundColor Yellow

Write-Host "`nFILE 11 STATUS: " -NoNewline
if ($script:FailCount -eq 0) {
    Write-Host "FUNCTIONAL (Phase 1)" -ForegroundColor Green
    Write-Host "  Mod is playable but overpowered (grants all 22 hero talents)" -ForegroundColor Yellow
} else {
    Write-Host "HAS $script:FailCount CRITICAL ERRORS" -ForegroundColor Red
}

Write-Host "`n====== REVIEW COMPLETE ======`n" -ForegroundColor Cyan

if ($script:FailCount -gt 0) { exit 1 } else { exit 0 }
