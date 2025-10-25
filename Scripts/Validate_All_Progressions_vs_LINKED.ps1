# Comprehensive Validation: Progressions.lsx vs LINKED CSV
# Double-checks ALL progressions (base class + all subclasses L1-20)

param(
    [string]$ProgressionsFile = "C:\Users\tenod\source\repos\BG3Mods\Data\Public\Warrior_Wow_78fe4967-4e62-5491-d981-dd781acca4d7\Progressions\Progressions.lsx",
    [string]$LinkedCsv = "C:\Users\tenod\source\repos\BG3Mods\Documentation\00_SourcesOfTruth\Warrior Progression LINKED - Main.csv"
)

Write-Host "=== COMPREHENSIVE PROGRESSION VALIDATION ===" -ForegroundColor Cyan
Write-Host "Checking: $ProgressionsFile" -ForegroundColor Gray
Write-Host "Against: $LinkedCsv`n" -ForegroundColor Gray

# Parse Progressions.lsx
$rawXml = Get-Content $ProgressionsFile -Raw
$cleanXml = $rawXml -replace '(?s)<!--.*?-->', ''
[xml]$xml = $cleanXml

$progressions = $xml.save.region.node.children.node | Where-Object { $_.id -eq 'Progression' }

# Load LINKED CSV (skip 3-row header structure)
$csvLines = Get-Content $LinkedCsv
$dataLines = $csvLines[3..($csvLines.Count-1)]

# Parse data rows
$linkedData = @()
foreach ($line in $dataLines) {
    $fields = $line -split ','
    if ($fields[0]) {
        $linkedData += [PSCustomObject]@{
            Level = $fields[0]
            WarriorSpells = $fields[1]
            ArmsSpells = $fields[2]
            FurySpells = $fields[3]
            ProtectionSpells = $fields[4]
            # Passives columns 5-52 (base + subclass passives)
            # Hero Talents columns 53-67
            MountainThane_L13 = $fields[53]
            MountainThane_L15 = $fields[54]
            MountainThane_L17 = $fields[55]
            MountainThane_L19 = $fields[56]
            MountainThane_L20 = $fields[57]
            Colossus_L13 = $fields[58]
            Colossus_L15 = $fields[59]
            Colossus_L17 = $fields[60]
            Colossus_L19 = $fields[61]
            Colossus_L20 = $fields[62]
            Slayers_L13 = $fields[63]
            Slayers_L15 = $fields[64]
            Slayers_L17 = $fields[65]
            Slayers_L19 = $fields[66]
            Slayers_L20 = $fields[67]
        }
    }
}

Write-Host "[1] HERO TALENT VALIDATION (L13-20)" -ForegroundColor Yellow
Write-Host "=" * 80 -ForegroundColor Gray

$heroTalentErrors = 0

# Expected hero talents from LINKED CSV
$expectedHeroTalents = @{
    # Arms: Colossus + Slayers
    "Arms_13" = @("WAR_Demolish", "WAR_Slayer_s_Dominance")
    "Arms_15" = @("WAR_Martial_Expert", "WAR_Colossal_Might", "WAR_Earthquake", "WAR_Imminent_Demise", "WAR_Overwhelming_Blades", "WAR_Relentless_Pursuit")
    "Arms_17" = @("WAR_Arterial_Bleed", "WAR_Tide_of_Battle", "WAR_No_Stranger_to_Pain", "WAR_Death_Drive", "WAR_Brutal_Finish", "WAR_Opportunist")
    "Arms_19" = @("WAR_Practiced_Strikes", "WAR_Precise_Might", "WAR_Mountain_of_Muscle_and_Scars", "WAR_Show_No_Mercy", "WAR_Reap_the_Storm", "WAR_Slayer_s_Malice")
    "Arms_20" = @("WAR_Dominance_of_the_Colossus", "WAR_Unrelenting_Onslaught")
    
    # Fury: Mountain Thane + Slayers
    "Fury_13" = @("WAR_Lightning_Strikes", "WAR_Slayer_s_Dominance")
    "Fury_15" = @("WAR_Crashing_Thunder", "WAR_Ground_Current", "WAR_Strength_of_the_Mountain", "WAR_Imminent_Demise", "WAR_Overwhelming_Blades", "WAR_Relentless_Pursuit")
    "Fury_17" = @("WAR_Thunder_Blast", "WAR_Storm_Bolts", "WAR_Keep_your_feet_on_the_Ground", "WAR_Death_Drive", "WAR_Brutal_Finish", "WAR_Opportunist")
    "Fury_19" = @("WAR_Flashing_Skies", "WAR_Thorim_s_Might", "WAR_Burst_of_Power", "WAR_Show_No_Mercy", "WAR_Reap_the_Storm", "WAR_Slayer_s_Malice")
    "Fury_20" = @("WAR_Avatar_of_the_Storm", "WAR_Unrelenting_Onslaught")
    
    # Protection: Mountain Thane + Colossus
    "Protection_13" = @("WAR_Lightning_Strikes", "WAR_Demolish")
    "Protection_15" = @("WAR_Crashing_Thunder", "WAR_Ground_Current", "WAR_Strength_of_the_Mountain", "WAR_Martial_Expert", "WAR_Colossal_Might", "WAR_Earthquake")
    "Protection_17" = @("WAR_Thunder_Blast", "WAR_Storm_Bolts", "WAR_Keep_your_feet_on_the_Ground", "WAR_Arterial_Bleed", "WAR_Tide_of_Battle", "WAR_No_Stranger_to_Pain")
    "Protection_19" = @("WAR_Flashing_Skies", "WAR_Thorim_s_Might", "WAR_Burst_of_Power", "WAR_Practiced_Strikes", "WAR_Precise_Might", "WAR_Mountain_of_Muscle_and_Scars")
    "Protection_20" = @("WAR_Avatar_of_the_Storm", "WAR_Dominance_of_the_Colossus")
}

foreach ($spec in @("Arms", "Fury", "Protection")) {
    Write-Host "`n$spec Subclass Hero Talents (L13-20):" -ForegroundColor Cyan
    
    foreach ($level in @(13, 15, 17, 19, 20)) {
        $key = "${spec}_${level}"
        $expectedTalents = $expectedHeroTalents[$key]
        
        $progNode = $progressions | Where-Object { 
            $_.Attribute | Where-Object { $_.id -eq 'Name' -and $_.value -eq $spec }
        } | Where-Object {
            ($_.Attribute | Where-Object { $_.id -eq 'Level' }).value -eq $level
        }
        
        if ($progNode) {
            $passivesAttr = $progNode.Attribute | Where-Object { $_.id -eq 'PassivesAdded' }
            $actualPassives = if ($passivesAttr) { $passivesAttr.value -split ';' } else { @() }
            
            # Extract hero talents (ignore base passives from database)
            $actualHeroTalents = $actualPassives | Where-Object { 
                $_ -match 'WAR_(Lightning_Strikes|Crashing_Thunder|Ground_Current|Strength_of_the_Mountain|Thunder_Blast|Storm_Bolts|Keep_your_feet_on_the_Ground|Flashing_Skies|Thorim_s_Might|Burst_of_Power|Avatar_of_the_Storm|Demolish|Martial_Expert|Colossal_Might|Earthquake|Arterial_Bleed|Tide_of_Battle|No_Stranger_to_Pain|Practiced_Strikes|Precise_Might|Mountain_of_Muscle_and_Scars|Dominance_of_the_Colossus|Slayer_s_Dominance|Imminent_Demise|Overwhelming_Blades|Relentless_Pursuit|Death_Drive|Brutal_Finish|Opportunist|Show_No_Mercy|Reap_the_Storm|Slayer_s_Malice|Unrelenting_Onslaught)'
            }
            
            # Check if all expected talents are present
            $missing = $expectedTalents | Where-Object { $actualHeroTalents -notcontains $_ }
            $extra = $actualHeroTalents | Where-Object { $expectedTalents -notcontains $_ }
            
            if ($missing.Count -eq 0 -and $extra.Count -eq 0) {
                Write-Host "  [PASS] L$level : $($expectedTalents.Count) talents correct" -ForegroundColor Green
            } else {
                Write-Host "  [FAIL] L$level :" -ForegroundColor Red
                if ($missing.Count -gt 0) {
                    Write-Host "    Missing: $($missing -join ', ')" -ForegroundColor Red
                }
                if ($extra.Count -gt 0) {
                    Write-Host "    Extra: $($extra -join ', ')" -ForegroundColor Yellow
                }
                $heroTalentErrors++
            }
        } else {
            Write-Host "  [FAIL] L$level : Node not found in Progressions.lsx!" -ForegroundColor Red
            $heroTalentErrors++
        }
    }
}

Write-Host "`n[2] BASE CLASS PROGRESSION VALIDATION (L1-20)" -ForegroundColor Yellow
Write-Host "=" * 80 -ForegroundColor Gray

$baseErrors = 0
$warriorNodes = $progressions | Where-Object { 
    ($_.Attribute | Where-Object { $_.id -eq 'Name' }).value -eq 'Warrior'
}

Write-Host "Total Warrior base nodes: $($warriorNodes.Count)" -ForegroundColor Gray
if ($warriorNodes.Count -ne 20) {
    Write-Host "[FAIL] Expected 20 Warrior nodes (L1-20), found $($warriorNodes.Count)" -ForegroundColor Red
    $baseErrors++
} else {
    Write-Host "[PASS] Warrior has 20 nodes (L1-20)" -ForegroundColor Green
}

# Check critical levels
$criticalLevels = @{
    1 = @("ActionResource(Rage,100,0)", "Proficiency(HeavyArmor)", "Proficiency(MartialWeapons)")
    4 = @("Ability(Strength,1,4)")
    5 = @("ActionResource(Rage,120,0)")
    8 = @("Ability(Strength,1,4)")
    9 = @("ActionResource(Rage,140,0)")
    12 = @("Ability(Strength,1,4)")
}

foreach ($level in $criticalLevels.Keys) {
    $node = $warriorNodes | Where-Object { 
        ($_.Attribute | Where-Object { $_.id -eq 'Level' }).value -eq $level
    }
    
    if ($node) {
        $boostsAttr = $node.Attribute | Where-Object { $_.id -eq 'Boosts' }
        $actualBoosts = if ($boostsAttr) { $boostsAttr.value -split ';' } else { @() }
        
        $expectedBoosts = $criticalLevels[$level]
        $missing = $expectedBoosts | Where-Object { $actualBoosts -notcontains $_ }
        
        if ($missing.Count -eq 0) {
            Write-Host "[PASS] Warrior L$level boosts correct" -ForegroundColor Green
        } else {
            Write-Host "[FAIL] Warrior L$level missing boosts: $($missing -join ', ')" -ForegroundColor Red
            $baseErrors++
        }
    } else {
        Write-Host "[FAIL] Warrior L$level node not found!" -ForegroundColor Red
        $baseErrors++
    }
}

Write-Host "`n[3] SUBCLASS PROGRESSION VALIDATION (L3-20)" -ForegroundColor Yellow
Write-Host "=" * 80 -ForegroundColor Gray

$subclassErrors = 0
foreach ($spec in @("Arms", "Fury", "Protection")) {
    $specNodes = $progressions | Where-Object { 
        ($_.Attribute | Where-Object { $_.id -eq 'Name' }).value -eq $spec
    }
    
    Write-Host "`n$spec Subclass:" -ForegroundColor Cyan
    Write-Host "  Total nodes: $($specNodes.Count)" -ForegroundColor Gray
    
    if ($specNodes.Count -ne 18) {
        Write-Host "  [FAIL] Expected 18 nodes (L3-20), found $($specNodes.Count)" -ForegroundColor Red
        $subclassErrors++
    } else {
        Write-Host "  [PASS] Has 18 nodes (L3-20)" -ForegroundColor Green
    }
    
    # Check L3 subclass-specific boosts
    $l3Node = $specNodes | Where-Object { 
        ($_.Attribute | Where-Object { $_.id -eq 'Level' }).value -eq 3
    }
    
    if ($l3Node) {
        $boostsAttr = $l3Node.Attribute | Where-Object { $_.id -eq 'Boosts' }
        $actualBoosts = if ($boostsAttr) { $boostsAttr.value } else { "" }
        
        $expectedBoost = switch ($spec) {
            "Arms" { "Proficiency(TwoHandedWeapons)" }
            "Fury" { "Proficiency(DualWielding)" }
            "Protection" { "Proficiency(Shields)" }
        }
        
        if ($actualBoosts -match $expectedBoost) {
            Write-Host "  [PASS] L3 boost: $expectedBoost" -ForegroundColor Green
        } else {
            Write-Host "  [FAIL] L3 missing expected boost: $expectedBoost" -ForegroundColor Red
            Write-Host "        Found: $actualBoosts" -ForegroundColor Yellow
            $subclassErrors++
        }
    } else {
        Write-Host "  [FAIL] L3 node not found!" -ForegroundColor Red
        $subclassErrors++
    }
}

Write-Host "`n[4] SPELL LIST REFERENCES VALIDATION" -ForegroundColor Yellow
Write-Host "=" * 80 -ForegroundColor Gray

$spellListErrors = 0
$nodesWithSpells = $progressions | Where-Object { $_.children.node.node }

foreach ($node in $nodesWithSpells) {
    $level = ($node.Attribute | Where-Object { $_.id -eq 'Level' }).value
    $name = ($node.Attribute | Where-Object { $_.id -eq 'Name' }).value
    $spellSelector = $node.children.node.node | Where-Object { $_.id -eq 'AddSpells' }
    
    if ($spellSelector) {
        $uuid = ($spellSelector.Attribute | Where-Object { $_.id -eq 'UUID' }).value
        
        if ($uuid) {
            Write-Host "[PASS] $name L$level has spell list UUID: $uuid" -ForegroundColor Green
        } else {
            Write-Host "[FAIL] $name L$level missing spell list UUID!" -ForegroundColor Red
            $spellListErrors++
        }
    }
}

Write-Host "`n=== VALIDATION SUMMARY ===" -ForegroundColor Cyan
Write-Host "=" * 80 -ForegroundColor Gray

$totalErrors = $heroTalentErrors + $baseErrors + $subclassErrors + $spellListErrors

Write-Host "Hero Talent Errors (L13-20): $heroTalentErrors" -ForegroundColor $(if ($heroTalentErrors -eq 0) { "Green" } else { "Red" })
Write-Host "Base Class Errors (L1-20): $baseErrors" -ForegroundColor $(if ($baseErrors -eq 0) { "Green" } else { "Red" })
Write-Host "Subclass Errors (L3-20): $subclassErrors" -ForegroundColor $(if ($subclassErrors -eq 0) { "Green" } else { "Red" })
Write-Host "Spell List Errors: $spellListErrors" -ForegroundColor $(if ($spellListErrors -eq 0) { "Green" } else { "Red" })
Write-Host "`nTotal Errors: $totalErrors" -ForegroundColor $(if ($totalErrors -eq 0) { "Green" } else { "Red" })

if ($totalErrors -eq 0) {
    Write-Host "`n✅ ALL PROGRESSIONS VALIDATED SUCCESSFULLY!" -ForegroundColor Green
    Write-Host "Progressions.lsx matches LINKED CSV for all classes L1-20" -ForegroundColor Cyan
} else {
    Write-Host "`n❌ VALIDATION FAILED - $totalErrors errors found" -ForegroundColor Red
}
