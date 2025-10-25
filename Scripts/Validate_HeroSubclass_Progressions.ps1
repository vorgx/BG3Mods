# Validate Hero Subclass Progression Structure
# Verifies 48 nodes inserted correctly with proper TableUUIDs and PassivesAdded values

param(
    [string]$ProgressionsPath = "C:\Users\tenod\source\repos\BG3Mods\Data\Public\Warrior_Wow_78fe4967-4e62-5491-d981-dd781acca4d7\Progressions\Progressions.lsx"
)

Write-Host "`n[PHASE 2 STEP 6 VALIDATION]`n" -ForegroundColor Yellow
Write-Host "="*80 -ForegroundColor Yellow

# Load and parse XML
Write-Host "`n[STEP 1] Loading Progressions.lsx..." -ForegroundColor Cyan
$Content = Get-Content $ProgressionsPath -Raw
# Strip multi-line comments
$CleanedContent = $Content -replace '(?s)<!--.*?-->', ''
[xml]$Xml = $CleanedContent

Write-Host "[PASS] XML parsed successfully" -ForegroundColor Green

# Expected hero subclasses with their TableUUIDs
$HeroSubclasses = @{
    'ArmsColossus' = '6a1b8c3d-7e9f-4a5b-8c6d-9e0f1a2b3c4d'
    'ArmsSlayers' = '5e34e41a-f929-47d5-aecb-3f48df5167c6'
    'FuryMountainThane' = '20d4f33d-b5f4-4f85-9039-715341d2fa83'
    'FurySlayers' = 'c79e7ba2-a49e-4d16-a611-1fa5f4dc7190'
    'ProtectionMountainThane' = 'aee4f826-ae7c-42eb-b26d-69403370b122'
    'ProtectionColossus' = 'edf56aa2-5f99-4971-ae64-6ac26f3cf004'
}

# Expected PassivesAdded per level
$ExpectedPassives = @{
    'ArmsColossus' = @{
        13 = @('WAR_Demolish')
        15 = @('WAR_Martial_Expert', 'WAR_Colossal_Might', 'WAR_Earthquake')
        17 = @('WAR_Arterial_Bleed', 'WAR_Tide_of_Battle', 'WAR_No_Stranger_to_Pain')
        19 = @('WAR_Practiced_Strikes', 'WAR_Precise_Might', 'WAR_Mountain_of_Muscle_and_Scars')
        20 = @('WAR_Dominance_of_the_Colossus')
    }
    'ArmsSlayers' = @{
        13 = @('WAR_Slayer_s_Dominance')
        15 = @('WAR_Imminent_Demise', 'WAR_Overwhelming_Blades', 'WAR_Relentless_Pursuit')
        17 = @('WAR_Death_Drive', 'WAR_Brutal_Finish', 'WAR_Opportunist')
        19 = @('WAR_Show_No_Mercy', 'WAR_Reap_the_Storm', 'WAR_Slayer_s_Malice')
        20 = @('WAR_Unrelenting_Onslaught')
    }
    'FuryMountainThane' = @{
        13 = @('WAR_Lightning_Strikes')
        15 = @('WAR_Crashing_Thunder', 'WAR_Ground_Current', 'WAR_Strength_of_the_Mountain')
        17 = @('WAR_Thunder_Blast', 'WAR_Storm_Bolts', 'WAR_Keep_your_feet_on_the_Ground')
        19 = @('WAR_Flashing_Skies', 'WAR_Thorim_s_Might', 'WAR_Burst_of_Power')
        20 = @('WAR_Avatar_of_the_Storm')
    }
    'FurySlayers' = @{
        13 = @('WAR_Slayer_s_Dominance')
        15 = @('WAR_Imminent_Demise', 'WAR_Overwhelming_Blades', 'WAR_Relentless_Pursuit')
        17 = @('WAR_Death_Drive', 'WAR_Brutal_Finish', 'WAR_Opportunist')
        19 = @('WAR_Show_No_Mercy', 'WAR_Reap_the_Storm', 'WAR_Slayer_s_Malice')
        20 = @('WAR_Unrelenting_Onslaught')
    }
    'ProtectionMountainThane' = @{
        13 = @('WAR_Lightning_Strikes')
        15 = @('WAR_Crashing_Thunder', 'WAR_Ground_Current', 'WAR_Strength_of_the_Mountain')
        17 = @('WAR_Thunder_Blast', 'WAR_Storm_Bolts', 'WAR_Keep_your_feet_on_the_Ground')
        19 = @('WAR_Flashing_Skies', 'WAR_Thorim_s_Might', 'WAR_Burst_of_Power')
        20 = @('WAR_Avatar_of_the_Storm')
    }
    'ProtectionColossus' = @{
        13 = @('WAR_Demolish')
        15 = @('WAR_Martial_Expert', 'WAR_Colossal_Might', 'WAR_Earthquake')
        17 = @('WAR_Arterial_Bleed', 'WAR_Tide_of_Battle', 'WAR_No_Stranger_to_Pain')
        19 = @('WAR_Practiced_Strikes', 'WAR_Precise_Might', 'WAR_Mountain_of_Muscle_and_Scars')
        20 = @('WAR_Dominance_of_the_Colossus')
    }
}

# Extract all progression nodes
$RootNode = $Xml.save.region.node
$AllProgressions = $RootNode.children.node | Where-Object { $_.id -eq 'Progression' }

Write-Host "[INFO] Found $($AllProgressions.Count) total progression nodes" -ForegroundColor Cyan

Write-Host "`n[STEP 2] Validating hero subclass nodes...`n" -ForegroundColor Cyan

$TotalNodes = 0
$PassedChecks = 0
$FailedChecks = 0

foreach ($SubclassName in $HeroSubclasses.Keys | Sort-Object) {
    Write-Host "  Testing: $SubclassName" -ForegroundColor Yellow
    
    # Get all nodes for this subclass
    $SubclassNodes = $AllProgressions | Where-Object {
        $NameAttr = $_.attribute | Where-Object { $_.id -eq 'Name' }
        $NameAttr.value -eq $SubclassName
    }
    
    $NodeCount = ($SubclassNodes | Measure-Object).Count
    $TotalNodes += $NodeCount
    
    # Verify 8 nodes (L13-20)
    if ($NodeCount -eq 8) {
        Write-Host "    [PASS] Node count: $NodeCount" -ForegroundColor Green
        $PassedChecks++
    } else {
        Write-Host "    [FAIL] Node count: $NodeCount (expected 8)" -ForegroundColor Red
        $FailedChecks++
        continue
    }
    
    # Verify TableUUID consistency
    $ExpectedTableUUID = $HeroSubclasses[$SubclassName]
    $TableUUIDs = @($SubclassNodes | ForEach-Object {
        [string](($_.attribute | Where-Object { $_.id -eq 'TableUUID' }).value)
    } | Select-Object -Unique)
    
    if ($TableUUIDs.Count -eq 1 -and $TableUUIDs[0] -eq $ExpectedTableUUID) {
        Write-Host "    [PASS] TableUUID: $ExpectedTableUUID" -ForegroundColor Green
        $PassedChecks++
    } else {
        Write-Host "    [FAIL] TableUUID mismatch or inconsistent" -ForegroundColor Red
        $FailedChecks++
    }
    
    # Verify PassivesAdded for talent levels (L13, L15, L17, L19, L20)
    $TalentLevels = @(13, 15, 17, 19, 20)
    foreach ($Level in $TalentLevels) {
        $Node = $SubclassNodes | Where-Object {
            ($_.attribute | Where-Object { $_.id -eq 'Level' }).value -eq $Level
        }
        
        if (-not $Node) {
            Write-Host "    [FAIL] Missing L$Level node" -ForegroundColor Red
            $FailedChecks++
            continue
        }
        
        $PassivesAdded = ($Node.attribute | Where-Object { $_.id -eq 'PassivesAdded' }).value
        
        if ($PassivesAdded) {
            $ActualPassives = $PassivesAdded -split ';' | Sort-Object
            $ExpectedPassivesForLevel = $ExpectedPassives[$SubclassName][$Level] | Sort-Object
            
            $Match = $true
            if ($ActualPassives.Count -ne $ExpectedPassivesForLevel.Count) {
                $Match = $false
            } else {
                for ($i = 0; $i -lt $ActualPassives.Count; $i++) {
                    if ($ActualPassives[$i] -ne $ExpectedPassivesForLevel[$i]) {
                        $Match = $false
                        break
                    }
                }
            }
            
            if ($Match) {
                Write-Host "    [PASS] L$Level passives: $($ActualPassives.Count) talents" -ForegroundColor Green
                $PassedChecks++
            } else {
                Write-Host "    [FAIL] L$Level passives mismatch" -ForegroundColor Red
                Write-Host "      Expected: $($ExpectedPassivesForLevel -join ', ')" -ForegroundColor Gray
                Write-Host "      Actual:   $($ActualPassives -join ', ')" -ForegroundColor Gray
                $FailedChecks++
            }
        } else {
            Write-Host "    [FAIL] L$Level missing PassivesAdded attribute" -ForegroundColor Red
            $FailedChecks++
        }
    }
    
    # Verify empty nodes (L14, L16, L18) have no PassivesAdded
    $EmptyLevels = @(14, 16, 18)
    foreach ($Level in $EmptyLevels) {
        $Node = $SubclassNodes | Where-Object {
            ($_.attribute | Where-Object { $_.id -eq 'Level' }).value -eq $Level
        }
        
        if ($Node) {
            $PassivesAdded = ($Node.attribute | Where-Object { $_.id -eq 'PassivesAdded' }).value
            if (-not $PassivesAdded) {
                Write-Host "    [PASS] L$Level empty (no passives)" -ForegroundColor Green
                $PassedChecks++
            } else {
                Write-Host "    [FAIL] L$Level should be empty" -ForegroundColor Red
                $FailedChecks++
            }
        } else {
            Write-Host "    [FAIL] Missing L$Level node" -ForegroundColor Red
            $FailedChecks++
        }
    }
    
    Write-Host ""
}

# Final summary
Write-Host "="*80 -ForegroundColor Yellow
Write-Host "`n[SUMMARY]" -ForegroundColor Yellow
Write-Host "  Total hero subclass nodes: $TotalNodes / 48" -ForegroundColor $(if($TotalNodes -eq 48){'Green'}else{'Red'})
Write-Host "  Validation checks passed: $PassedChecks" -ForegroundColor Green
Write-Host "  Validation checks failed: $FailedChecks" -ForegroundColor $(if($FailedChecks -eq 0){'Green'}else{'Red'})

if ($FailedChecks -eq 0 -and $TotalNodes -eq 48) {
    Write-Host "`n[SUCCESS] Phase 2 Step 6 validation complete! All 48 nodes are correct.`n" -ForegroundColor Green
    exit 0
} else {
    Write-Host "`n[FAILED] Validation errors detected. Please review above.`n" -ForegroundColor Red
    exit 1
}
