# Regenerate Progressions.lsx with CORRECT Hero Talents from LINKED CSV
# Manual hero talent assignments based on LINKED CSV analysis

param(
    [string]$OutputFile = "C:\Users\tenod\source\repos\BG3Mods\Data\Public\Warrior_Wow_78fe4967-4e62-5491-d981-dd781acca4d7\Progressions\Progressions.lsx"
)

Write-Host "=== REGENERATING PROGRESSIONS.LSX WITH CORRECT HERO TALENTS ===" -ForegroundColor Cyan

# Backup existing file
$backupFile = $OutputFile + ".backup_" + (Get-Date -Format "yyyyMMdd_HHmmss")
if (Test-Path $OutputFile) {
    Copy-Item $OutputFile $backupFile
    Write-Host "Backed up existing file to: $backupFile" -ForegroundColor Yellow
}

# UUIDs for classes
$warriorClassUuid = "4f5d1434-5175-4fa9-b7dc-5a1c8f6c5521"
$armsSubclassUuid = "d3c5a4f2-8b6e-4a1d-9c7f-2e8b5a3c1d9f"
$furySubclassUuid = "e4d6b5g3-9c7f-5b2e-ad8g-3f9c6b4d2e0g"
$protectionSubclassUuid = "f5e7c6h4-ad8g-6c3f-be9h-4g0d7c5e3f1h"

# Load spell list UUIDs
$spellListMapping = Import-Csv "C:\Users\tenod\source\repos\BG3Mods\Scripts\SpellList_UUID_Mapping.csv"

# Load database for passives
$database = Import-Csv "C:\Users\tenod\source\repos\BG3Mods\Documentation\00_SourcesOfTruth\AbilityDatabase_Warrior_FullyEnriched.csv"
$passives = $database | Where-Object { $_.bg3_file_type -eq 'Passive' }

# Helper function to get spell list UUID
function Get-SpellListUUID($level, $spec) {
    $match = $spellListMapping | Where-Object { $_.Level -eq $level -and $_.Spec -eq $spec }
    if ($match) { return $match.UUID }
    return $null
}

# Helper function to get passives for level/spec
# CRITICAL: For L13-20, IGNORE database (has old incorrect hero talents)
# Only use LINKED CSV hero talents for L13-20
function Get-PassivesForLevel($level, $spec) {
    # SKIP database passives for L13-20 (hero talents handled separately from LINKED CSV)
    if ($level -ge 13 -and $level -le 20 -and $spec -ne "Warrior") {
        return $null
    }
    
    $specColumn = switch ($spec) {
        "Warrior" { "warrior_unlock" }
        "Arms" { "arms_unlock" }
        "Fury" { "fury_unlock" }
        "Protection" { "protection_unlock" }
    }
    
    $levelPassives = $passives | Where-Object { $_.$specColumn -eq $level }
    if ($levelPassives) {
        return ($levelPassives | Select-Object -ExpandProperty ability_id) -join ';'
    }
    return $null
}

# MANUAL HERO TALENT ASSIGNMENTS FROM LINKED CSV
# Protection: Mountain Thane + Colossus
# Fury: Mountain Thane + Slayers
# Arms: Colossus + Slayers

$heroTalents = @{
    # ARMS SUBCLASS (Colossus + Slayers)
    "Arms_13" = "WAR_Demolish;WAR_Slayer_s_Dominance"
    "Arms_15" = "WAR_Martial_Expert;WAR_Colossal_Might;WAR_Earthquake;WAR_Imminent_Demise;WAR_Overwhelming_Blades;WAR_Relentless_Pursuit"
    "Arms_17" = "WAR_Arterial_Bleed;WAR_Tide_of_Battle;WAR_No_Stranger_to_Pain;WAR_Death_Drive;WAR_Brutal_Finish;WAR_Opportunist"
    "Arms_19" = "WAR_Practiced_Strikes;WAR_Precise_Might;WAR_Mountain_of_Muscle_and_Scars;WAR_Show_No_Mercy;WAR_Reap_the_Storm;WAR_Slayer_s_Malice"
    "Arms_20" = "WAR_Dominance_of_the_Colossus;WAR_Unrelenting_Onslaught"
    
    # FURY SUBCLASS (Mountain Thane + Slayers)
    "Fury_13" = "WAR_Lightning_Strikes;WAR_Slayer_s_Dominance"
    "Fury_15" = "WAR_Crashing_Thunder;WAR_Ground_Current;WAR_Strength_of_the_Mountain;WAR_Imminent_Demise;WAR_Overwhelming_Blades;WAR_Relentless_Pursuit"
    "Fury_17" = "WAR_Thunder_Blast;WAR_Storm_Bolts;WAR_Keep_your_feet_on_the_Ground;WAR_Death_Drive;WAR_Brutal_Finish;WAR_Opportunist"
    "Fury_19" = "WAR_Flashing_Skies;WAR_Thorim_s_Might;WAR_Burst_of_Power;WAR_Show_No_Mercy;WAR_Reap_the_Storm;WAR_Slayer_s_Malice"
    "Fury_20" = "WAR_Avatar_of_the_Storm;WAR_Unrelenting_Onslaught"
    
    # PROTECTION SUBCLASS (Mountain Thane + Colossus)
    "Protection_13" = "WAR_Lightning_Strikes;WAR_Demolish"
    "Protection_15" = "WAR_Crashing_Thunder;WAR_Ground_Current;WAR_Strength_of_the_Mountain;WAR_Martial_Expert;WAR_Colossal_Might;WAR_Earthquake"
    "Protection_17" = "WAR_Thunder_Blast;WAR_Storm_Bolts;WAR_Keep_your_feet_on_the_Ground;WAR_Arterial_Bleed;WAR_Tide_of_Battle;WAR_No_Stranger_to_Pain"
    "Protection_19" = "WAR_Flashing_Skies;WAR_Thorim_s_Might;WAR_Burst_of_Power;WAR_Practiced_Strikes;WAR_Precise_Might;WAR_Mountain_of_Muscle_and_Scars"
    "Protection_20" = "WAR_Avatar_of_the_Storm;WAR_Dominance_of_the_Colossus"
}

Write-Host "`n[1] Building progression data..." -ForegroundColor Yellow

$progressions = @()

# BASE WARRIOR CLASS (L1-20)
Write-Host "  Processing Base Warrior L1-20..." -ForegroundColor Gray
for ($level = 1; $level -le 20; $level++) {
    $spellListUuid = Get-SpellListUUID $level "Warrior"
    $passiveList = Get-PassivesForLevel $level "Warrior"
    
    $boosts = @()
    switch ($level) {
        1 { $boosts = @("ActionResource(Rage,100,0)", "Proficiency(HeavyArmor)", "Proficiency(MartialWeapons)", "Proficiency(Shields)") }
        4 { $boosts = @("Ability(Strength,1,4)") }
        5 { $boosts = @("ActionResource(Rage,120,0)") }
        8 { $boosts = @("Ability(Strength,1,4)") }
        9 { $boosts = @("ActionResource(Rage,140,0)") }
        12 { $boosts = @("Ability(Strength,1,4)") }
        16 { $boosts = @("Ability(Strength,1,4)") }
        19 { $boosts = @("Ability(Strength,1,4)") }
        20 { $boosts = @("Ability(Strength,1,4)") }
    }
    
    $progressions += [PSCustomObject]@{
        Class = "Warrior"
        Level = $level
        UUID = $warriorClassUuid
        Boosts = if ($boosts.Count -gt 0) { $boosts -join ';' } else { $null }
        Passives = $passiveList
        SpellListUUID = $spellListUuid
    }
}

# ARMS SUBCLASS (L3-20)
Write-Host "  Processing Arms Subclass L3-20..." -ForegroundColor Gray
for ($level = 3; $level -le 20; $level++) {
    $spellListUuid = Get-SpellListUUID $level "Arms"
    
    # For L13-20: ONLY use hero talents (database has old incorrect assignments)
    # For L3-12: Use database passives
    if ($level -ge 13 -and $level -le 20) {
        $passiveList = $heroTalents["Arms_$level"]
    } else {
        $passiveList = Get-PassivesForLevel $level "Arms"
    }
    
    $boosts = @()
    if ($level -eq 3) {
        $boosts = @("Proficiency(TwoHandedWeapons)")
    }
    
    $progressions += [PSCustomObject]@{
        Class = "Arms"
        Level = $level
        UUID = $armsSubclassUuid
        Boosts = if ($boosts.Count -gt 0) { $boosts -join ';' } else { $null }
        Passives = $passiveList
        SpellListUUID = $spellListUuid
    }
}

# FURY SUBCLASS (L3-20)
Write-Host "  Processing Fury Subclass L3-20..." -ForegroundColor Gray
for ($level = 3; $level -le 20; $level++) {
    $spellListUuid = Get-SpellListUUID $level "Fury"
    
    # For L13-20: ONLY use hero talents (database has old incorrect assignments)
    # For L3-12: Use database passives
    if ($level -ge 13 -and $level -le 20) {
        $passiveList = $heroTalents["Fury_$level"]
    } else {
        $passiveList = Get-PassivesForLevel $level "Fury"
    }
    
    $boosts = @()
    if ($level -eq 3) {
        $boosts = @("Proficiency(DualWielding)")
    }
    
    $progressions += [PSCustomObject]@{
        Class = "Fury"
        Level = $level
        UUID = $furySubclassUuid
        Boosts = if ($boosts.Count -gt 0) { $boosts -join ';' } else { $null }
        Passives = $passiveList
        SpellListUUID = $spellListUuid
    }
}

# PROTECTION SUBCLASS (L3-20)
Write-Host "  Processing Protection Subclass L3-20..." -ForegroundColor Gray
for ($level = 3; $level -le 20; $level++) {
    $spellListUuid = Get-SpellListUUID $level "Protection"
    
    # For L13-20: ONLY use hero talents (database has old incorrect assignments)
    # For L3-12: Use database passives
    if ($level -ge 13 -and $level -le 20) {
        $passiveList = $heroTalents["Protection_$level"]
    } else {
        $passiveList = Get-PassivesForLevel $level "Protection"
    }
    
    $boosts = @()
    if ($level -eq 3) {
        $boosts = @("Proficiency(Shields)", "AC(1)")
    }
    
    $progressions += [PSCustomObject]@{
        Class = "Protection"
        Level = $level
        UUID = $protectionSubclassUuid
        Boosts = if ($boosts.Count -gt 0) { $boosts -join ';' } else { $null }
        Passives = $passiveList
        SpellListUUID = $spellListUuid
    }
}

Write-Host "`n[2] Generating XML..." -ForegroundColor Yellow

$xml = @"
<?xml version="1.0" encoding="UTF-8"?>
<save>
    <version major="4" minor="0" revision="9" build="0"/>
    <region id="Progressions">
        <node id="root">
            <children>
"@

foreach ($prog in $progressions) {
    $xml += @"

                <!-- $($prog.Class) Level $($prog.Level) -->
                <node id="Progression">
                    <attribute id="Level" type="uint8" value="$($prog.Level)"/>
                    <attribute id="Name" type="LSString" value="$($prog.Class)"/>
                    <attribute id="ProgressionType" type="uint8" value="0"/>
                    <attribute id="TableUUID" type="guid" value="$($prog.UUID)"/>
"@

    if ($prog.Boosts) {
        $xml += @"

                    <attribute id="Boosts" type="LSString" value="$($prog.Boosts)"/>
"@
    }

    if ($prog.Passives) {
        $xml += @"

                    <attribute id="PassivesAdded" type="LSString" value="$($prog.Passives)"/>
"@
    }

    if ($prog.SpellListUUID) {
        $xml += @"

                    <children>
                        <node id="Selectors">
                            <children>
                                <node id="AddSpells">
                                    <attribute id="UUID" type="guid" value="$($prog.SpellListUUID)"/>
                                </node>
                            </children>
                        </node>
                    </children>
"@
    }

    $xml += @"

                </node>
"@
}

$xml += @"

            </children>
        </node>
    </region>
</save>
"@

# Write file
$xml | Out-File -FilePath $OutputFile -Encoding UTF8 -Force

Write-Host "`n[3] Validation..." -ForegroundColor Yellow
Write-Host "  File written: $OutputFile" -ForegroundColor Green
Write-Host "  Size: $((Get-Item $OutputFile).Length) bytes" -ForegroundColor Gray
Write-Host "  Total progression nodes: $($progressions.Count)" -ForegroundColor Gray

Write-Host "`n[4] Hero Talent Summary..." -ForegroundColor Yellow
Write-Host "  Arms L13-20: Colossus + Slayers" -ForegroundColor Green
Write-Host "  Fury L13-20: Mountain Thane + Slayers" -ForegroundColor Green
Write-Host "  Protection L13-20: Mountain Thane + Colossus" -ForegroundColor Green

Write-Host "`n✅ Progressions.lsx regenerated with CORRECT hero talents!" -ForegroundColor Cyan
