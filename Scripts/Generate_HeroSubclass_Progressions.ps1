# ============================================================================
# Generate Hero Subclass Progression Nodes (Phase 2 Step 6)
# ============================================================================
# Purpose: Generate 48 progression nodes for 6 hero subclasses (L13-20)
# Input: AbilityDatabase_Warrior_FullyEnriched.csv (granted_by_subclass column)
# Output: XML progression nodes ready to insert into Progressions.lsx
# ============================================================================

param(
    [Parameter(Mandatory=$false)]
    [string]$DatabasePath = "C:\Users\tenod\source\repos\BG3Mods\Documentation\00_SourcesOfTruth\AbilityDatabase_Warrior_FullyEnriched.csv",
    
    [Parameter(Mandatory=$false)]
    [string]$OutputPath = "C:\Users\tenod\source\repos\BG3Mods\Reports\HeroSubclass_Progressions_Generated.xml",
    
    [Parameter(Mandatory=$false)]
    [switch]$DryRun
)

Write-Host "`n========== HERO SUBCLASS PROGRESSION GENERATOR ==========" -ForegroundColor Cyan
Write-Host "Phase 2 Step 6: Generate 48 progression nodes (6 subclasses × 8 levels)" -ForegroundColor White
Write-Host ""

# ============================================================================
# 1. Load Database
# ============================================================================
Write-Host "[STEP 1] Loading ability database..." -ForegroundColor Yellow

if (-not (Test-Path $DatabasePath)) {
    Write-Host "[ERROR] Database not found: $DatabasePath" -ForegroundColor Red
    exit 1
}

$Database = Import-Csv $DatabasePath
Write-Host "[OK] Loaded $($Database.Count) abilities from database" -ForegroundColor Green

# Filter hero talents (rows with granted_by_subclass populated)
$HeroTalents = $Database | Where-Object { $_.granted_by_subclass -and $_.granted_by_subclass -ne "" }
Write-Host "[OK] Found $($HeroTalents.Count) hero talent abilities" -ForegroundColor Green

# ============================================================================
# 2. Define Hero Subclass Metadata
# ============================================================================
Write-Host "`n[STEP 2] Defining hero subclass metadata..." -ForegroundColor Yellow

$HeroSubclasses = @{
    'ArmsColossus' = @{
        Name = 'ArmsColossus'
        DisplayName = 'Arms Colossus'
        ClassDescriptionUUID = '9e3f65fd-68f8-4a46-8210-42c4f8ea0999'
        ProgressionTableUUID = '6a1b8c3d-7e9f-4a5b-8c6d-9e0f1a2b3c4d'
        ParentSpec = 'Arms'
        ParentTableUUID = 'd3c5a4f2-8b6e-4a1d-9c7f-2e8b5a3c1d9f'
    }
    'ArmsSlayers' = @{
        Name = 'ArmsSlayers'
        DisplayName = 'Arms Slayer'
        ClassDescriptionUUID = '8eb6da73-6020-4eb7-ab21-b9ff4fffe38b'
        ProgressionTableUUID = '5e34e41a-f929-47d5-aecb-3f48df5167c6'
        ParentSpec = 'Arms'
        ParentTableUUID = 'd3c5a4f2-8b6e-4a1d-9c7f-2e8b5a3c1d9f'
    }
    'FuryMountainThane' = @{
        Name = 'FuryMountainThane'
        DisplayName = 'Fury Mountain Thane'
        ClassDescriptionUUID = '162d56bd-4d1e-4957-8a43-c5ba3fb1ee8f'
        ProgressionTableUUID = '20d4f33d-b5f4-4f85-9039-715341d2fa83'
        ParentSpec = 'Fury'
        ParentTableUUID = 'b82a148a-f506-4e34-ba56-150ce01eeeba'
    }
    'FurySlayers' = @{
        Name = 'FurySlayers'
        DisplayName = 'Fury Slayer'
        ClassDescriptionUUID = '199180bf-1173-4631-9678-5c8342f81862'
        ProgressionTableUUID = 'c79e7ba2-a49e-4d16-a611-1fa5f4dc7190'
        ParentSpec = 'Fury'
        ParentTableUUID = 'b82a148a-f506-4e34-ba56-150ce01eeeba'
    }
    'ProtectionMountainThane' = @{
        Name = 'ProtectionMountainThane'
        DisplayName = 'Protection Mountain Thane'
        ClassDescriptionUUID = '861c5f75-69ab-4a06-8f16-6cf34d7f99d6'
        ProgressionTableUUID = 'aee4f826-ae7c-42eb-b26d-69403370b122'
        ParentSpec = 'Protection'
        ParentTableUUID = '59d97f4c-ea6f-48cb-a284-0a4f17917afe'
    }
    'ProtectionColossus' = @{
        Name = 'ProtectionColossus'
        DisplayName = 'Protection Colossus'
        ClassDescriptionUUID = '83268994-38e9-4bb5-b9e5-382926636d58'
        ProgressionTableUUID = 'edf56aa2-5f99-4971-ae64-6ac26f3cf004'
        ParentSpec = 'Protection'
        ParentTableUUID = '59d97f4c-ea6f-48cb-a284-0a4f17917afe'
    }
}

Write-Host "[OK] Defined 6 hero subclasses with UUIDs and parent relationships" -ForegroundColor Green

# ============================================================================
# 3. Group Hero Talents by Subclass and Level
# ============================================================================
Write-Host "`n[STEP 3] Organizing hero talents by subclass and level..." -ForegroundColor Yellow

$TalentDistribution = @{}

foreach ($HeroSubclass in $HeroSubclasses.Keys) {
    $TalentDistribution[$HeroSubclass] = @{
        'L13' = @()  # Keystone (1 granted)
        'L15' = @()  # Choice tier (3 options)
        'L17' = @()  # Choice tier (3 options)
        'L19' = @()  # Choice tier (3 options)
        'L20' = @()  # Capstone (1 granted)
    }
}

# Parse granted_by_subclass column (format: "ArmsColossus,ProtectionColossus")
foreach ($Talent in $HeroTalents) {
    $Subclasses = $Talent.granted_by_subclass -split ',' | ForEach-Object { $_.Trim() }
    
    # Determine unlock level from database columns
    # Priority: fury_unlock > arms_unlock > protection_unlock > warrior_unlock
    $UnlockLevel = 0
    
    foreach ($Subclass in $Subclasses) {
        # Determine which unlock column to use based on subclass parent spec
        $ParentSpec = $HeroSubclasses[$Subclass].ParentSpec
        
        if ($ParentSpec -eq 'Fury' -and $Talent.fury_unlock -match '\d+') {
            $UnlockLevel = [int]$Matches[0]
        } elseif ($ParentSpec -eq 'Arms' -and $Talent.arms_unlock -match '\d+') {
            $UnlockLevel = [int]$Matches[0]
        } elseif ($ParentSpec -eq 'Protection' -and $Talent.protection_unlock -match '\d+') {
            $UnlockLevel = [int]$Matches[0]
        } elseif ($Talent.warrior_unlock -match '\d+') {
            $UnlockLevel = [int]$Matches[0]
        }
        
        # Map unlock level to progression tier
        if ($TalentDistribution.ContainsKey($Subclass)) {
            if ($UnlockLevel -eq 13) {
                $TalentDistribution[$Subclass]['L13'] += $Talent
            } elseif ($UnlockLevel -eq 15) {
                $TalentDistribution[$Subclass]['L15'] += $Talent
            } elseif ($UnlockLevel -eq 17) {
                $TalentDistribution[$Subclass]['L17'] += $Talent
            } elseif ($UnlockLevel -eq 19) {
                $TalentDistribution[$Subclass]['L19'] += $Talent
            } elseif ($UnlockLevel -eq 20) {
                $TalentDistribution[$Subclass]['L20'] += $Talent
            } else {
                # Fallback: distribute by count if unlock level not standard
                if ($TalentDistribution[$Subclass]['L15'].Count -lt 3) {
                    $TalentDistribution[$Subclass]['L15'] += $Talent
                } elseif ($TalentDistribution[$Subclass]['L17'].Count -lt 3) {
                    $TalentDistribution[$Subclass]['L17'] += $Talent
                } else {
                    $TalentDistribution[$Subclass]['L19'] += $Talent
                }
            }
        }
    }
}

# Report distribution
Write-Host "`n[DISTRIBUTION REPORT]" -ForegroundColor Cyan
foreach ($Subclass in $HeroSubclasses.Keys) {
    Write-Host "  $Subclass :" -ForegroundColor White
    Write-Host "    L13 (Keystone): $($TalentDistribution[$Subclass]['L13'].Count) talents" -ForegroundColor Gray
    Write-Host "    L15 (Choice):   $($TalentDistribution[$Subclass]['L15'].Count) talents" -ForegroundColor Gray
    Write-Host "    L17 (Choice):   $($TalentDistribution[$Subclass]['L17'].Count) talents" -ForegroundColor Gray
    Write-Host "    L19 (Choice):   $($TalentDistribution[$Subclass]['L19'].Count) talents" -ForegroundColor Gray
    Write-Host "    L20 (Capstone): $($TalentDistribution[$Subclass]['L20'].Count) talents" -ForegroundColor Gray
}

# ============================================================================
# 4. Generate Progression Nodes
# ============================================================================
Write-Host "`n[STEP 4] Generating progression nodes..." -ForegroundColor Yellow

$GeneratedNodes = @()

foreach ($SubclassKey in $HeroSubclasses.Keys | Sort-Object) {
    $Subclass = $HeroSubclasses[$SubclassKey]
    
    Write-Host "  Generating nodes for $($Subclass.DisplayName)..." -ForegroundColor Cyan
    
    # L13: Keystone (granted passive)
    $L13Talents = $TalentDistribution[$SubclassKey]['L13']
    if ($L13Talents.Count -gt 0) {
        $PassivesAdded = ($L13Talents | ForEach-Object { $_.ability_id }) -join ';'
        
        $L13Node = @"
                <!-- $($Subclass.DisplayName) Level 13 - Keystone -->
                <node id="Progression">
                    <attribute id="Level" type="uint8" value="13"/>
                    <attribute id="Name" type="LSString" value="$($Subclass.Name)"/>
                    <attribute id="ProgressionType" type="uint8" value="0"/>
                    <attribute id="TableUUID" type="guid" value="$($Subclass.ProgressionTableUUID)"/>
                    <attribute id="PassivesAdded" type="LSString" value="$PassivesAdded"/>
                </node>
"@
        $GeneratedNodes += $L13Node
    }
    
    # L14: Empty (no talents this level)
    $L14Node = @"
                <!-- $($Subclass.DisplayName) Level 14 -->
                <node id="Progression">
                    <attribute id="Level" type="uint8" value="14"/>
                    <attribute id="Name" type="LSString" value="$($Subclass.Name)"/>
                    <attribute id="ProgressionType" type="uint8" value="0"/>
                    <attribute id="TableUUID" type="guid" value="$($Subclass.ProgressionTableUUID)"/>
                </node>
"@
    $GeneratedNodes += $L14Node
    
    # L15: Auto-granted talents (3 passives)
    $L15Talents = $TalentDistribution[$SubclassKey]['L15']
    if ($L15Talents.Count -gt 0) {
        $PassivesAdded = ($L15Talents | ForEach-Object { $_.ability_id }) -join ';'
        
        $L15Node = @"
                <!-- $($Subclass.DisplayName) Level 15 -->
                <node id="Progression">
                    <attribute id="Level" type="uint8" value="15"/>
                    <attribute id="Name" type="LSString" value="$($Subclass.Name)"/>
                    <attribute id="ProgressionType" type="uint8" value="0"/>
                    <attribute id="TableUUID" type="guid" value="$($Subclass.ProgressionTableUUID)"/>
                    <attribute id="PassivesAdded" type="LSString" value="$PassivesAdded"/>
                </node>
"@
        $GeneratedNodes += $L15Node
        
        Write-Host "    [INFO] L15 Passives: $($L15Talents.ability_id -join ', ')" -ForegroundColor DarkGray
    }
    
    # L16: Empty (no talents this level)
    $L16Node = @"
                <!-- $($Subclass.DisplayName) Level 16 -->
                <node id="Progression">
                    <attribute id="Level" type="uint8" value="16"/>
                    <attribute id="Name" type="LSString" value="$($Subclass.Name)"/>
                    <attribute id="ProgressionType" type="uint8" value="0"/>
                    <attribute id="TableUUID" type="guid" value="$($Subclass.ProgressionTableUUID)"/>
                </node>
"@
    $GeneratedNodes += $L16Node
    
    # L17: Auto-granted talents (3 passives)
    $L17Talents = $TalentDistribution[$SubclassKey]['L17']
    if ($L17Talents.Count -gt 0) {
        $PassivesAdded = ($L17Talents | ForEach-Object { $_.ability_id }) -join ';'
        
        $L17Node = @"
                <!-- $($Subclass.DisplayName) Level 17 -->
                <node id="Progression">
                    <attribute id="Level" type="uint8" value="17"/>
                    <attribute id="Name" type="LSString" value="$($Subclass.Name)"/>
                    <attribute id="ProgressionType" type="uint8" value="0"/>
                    <attribute id="TableUUID" type="guid" value="$($Subclass.ProgressionTableUUID)"/>
                    <attribute id="PassivesAdded" type="LSString" value="$PassivesAdded"/>
                </node>
"@
        $GeneratedNodes += $L17Node
        
        Write-Host "    [INFO] L17 Passives: $($L17Talents.ability_id -join ', ')" -ForegroundColor DarkGray
    }
    
    # L18: Empty (no talents this level)
    $L18Node = @"
                <!-- $($Subclass.DisplayName) Level 18 -->
                <node id="Progression">
                    <attribute id="Level" type="uint8" value="18"/>
                    <attribute id="Name" type="LSString" value="$($Subclass.Name)"/>
                    <attribute id="ProgressionType" type="uint8" value="0"/>
                    <attribute id="TableUUID" type="guid" value="$($Subclass.ProgressionTableUUID)"/>
                </node>
"@
    $GeneratedNodes += $L18Node
    
    # L19: Auto-granted talents (3 passives)
    $L19Talents = $TalentDistribution[$SubclassKey]['L19']
    if ($L19Talents.Count -gt 0) {
        $PassivesAdded = ($L19Talents | ForEach-Object { $_.ability_id }) -join ';'
        
        $L19Node = @"
                <!-- $($Subclass.DisplayName) Level 19 -->
                <node id="Progression">
                    <attribute id="Level" type="uint8" value="19"/>
                    <attribute id="Name" type="LSString" value="$($Subclass.Name)"/>
                    <attribute id="ProgressionType" type="uint8" value="0"/>
                    <attribute id="TableUUID" type="guid" value="$($Subclass.ProgressionTableUUID)"/>
                    <attribute id="PassivesAdded" type="LSString" value="$PassivesAdded"/>
                </node>
"@
        $GeneratedNodes += $L19Node
        
        Write-Host "    [INFO] L19 Passives: $($L19Talents.ability_id -join ', ')" -ForegroundColor DarkGray
    }
    
    # L20: Capstone (granted passive)
    $L20Talents = $TalentDistribution[$SubclassKey]['L20']
    if ($L20Talents.Count -gt 0) {
        $PassivesAdded = ($L20Talents | ForEach-Object { $_.ability_id }) -join ';'
        
        $L20Node = @"
                <!-- $($Subclass.DisplayName) Level 20 - Capstone -->
                <node id="Progression">
                    <attribute id="Level" type="uint8" value="20"/>
                    <attribute id="Name" type="LSString" value="$($Subclass.Name)"/>
                    <attribute id="ProgressionType" type="uint8" value="0"/>
                    <attribute id="TableUUID" type="guid" value="$($Subclass.ProgressionTableUUID)"/>
                    <attribute id="PassivesAdded" type="LSString" value="$PassivesAdded"/>
                </node>
"@
        $GeneratedNodes += $L20Node
    }
    
    Write-Host "    [OK] Generated 8 progression nodes for $($Subclass.DisplayName)" -ForegroundColor Green
}

Write-Host "`n[OK] Generated $($GeneratedNodes.Count) total progression nodes" -ForegroundColor Green

# ============================================================================
# 5. Save Output
# ============================================================================
Write-Host "`n[STEP 5] Saving generated nodes..." -ForegroundColor Yellow

$OutputContent = @"
<?xml version="1.0" encoding="UTF-8"?>
<!-- ============================================================================ -->
<!-- HERO SUBCLASS PROGRESSION NODES (Phase 2 Step 6)                            -->
<!-- Generated: $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")                        -->
<!-- Total Nodes: $($GeneratedNodes.Count)                                       -->
<!-- ============================================================================ -->
<!-- INSTRUCTIONS:                                                                -->
<!-- 1. Copy each subclass's 8 nodes into Progressions.lsx                       -->
<!-- 2. Insert AFTER the parent spec's L20 node                                  -->
<!-- 3. Maintain proper indentation (16 spaces for <node id="Progression">)      -->
<!-- 4. Verify XML structure after insertion                                     -->
<!-- ============================================================================ -->

$($GeneratedNodes -join "`n`n")

<!-- ============================================================================ -->
<!-- END OF GENERATED NODES                                                       -->
<!-- ============================================================================ -->
"@

if ($DryRun) {
    Write-Host "[DRY RUN] Would save to: $OutputPath" -ForegroundColor Yellow
    Write-Host "[DRY RUN] Preview (first 500 chars):" -ForegroundColor Yellow
    Write-Host $OutputContent.Substring(0, [Math]::Min(500, $OutputContent.Length)) -ForegroundColor DarkGray
} else {
    $OutputContent | Out-File -FilePath $OutputPath -Encoding UTF8
    Write-Host "[OK] Saved generated nodes to: $OutputPath" -ForegroundColor Green
}

# ============================================================================
# 6. Final Report
# ============================================================================
Write-Host "`n========== GENERATION COMPLETE ==========" -ForegroundColor Cyan
Write-Host ""
Write-Host "SUMMARY:" -ForegroundColor Yellow
Write-Host "  - Hero Subclasses Processed: 6" -ForegroundColor White
Write-Host "  - Progression Nodes Generated: $($GeneratedNodes.Count)" -ForegroundColor White
Write-Host "  - Levels Covered: L13-L20 (8 levels per subclass)" -ForegroundColor White
Write-Host "  - Output File: $OutputPath" -ForegroundColor White
Write-Host ""
Write-Host "NEXT STEPS:" -ForegroundColor Yellow
Write-Host "  1. Review generated nodes in output file" -ForegroundColor White
Write-Host "  2. Insert nodes into Progressions.lsx (after parent spec L20 nodes)" -ForegroundColor White
Write-Host "  3. Validate XML structure with get_errors" -ForegroundColor White
Write-Host "  4. Run validation: Validate_HeroSubclass_Progressions.ps1" -ForegroundColor White
Write-Host "  5. Proceed to Phase 2 Step 7 (update SpellList_UUID_Mapping.csv)" -ForegroundColor White
Write-Host ""

if ($DryRun) {
    Write-Host "[DRY RUN MODE] No files were modified" -ForegroundColor Yellow
} else {
    Write-Host "[SUCCESS] Generated nodes saved - ready for manual insertion" -ForegroundColor Green
}

exit 0
