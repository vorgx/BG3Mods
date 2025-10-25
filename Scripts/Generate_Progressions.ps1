# Generate Progressions.lsx (FILE 11) - Level by Level
# Creates progression nodes for Warrior base class + 3 subclasses (Arms/Fury/Protection)
# References SpellList UUIDs from FILE 12 and passive grants from database

param(
    [string]$DatabaseCsv = "C:\Users\tenod\source\repos\BG3Mods\Documentation\00_SourcesOfTruth\AbilityDatabase_Warrior_FullyEnriched.csv",
    [string]$SpellListMapping = "C:\Users\tenod\source\repos\BG3Mods\Scripts\SpellList_UUID_Mapping.csv",
    [string]$OutputFile = "C:\Users\tenod\source\repos\BG3Mods\Data\Public\Warrior_Wow_78fe4967-4e62-5491-d981-dd781acca4d7\Progressions\Progressions.lsx",
    [int]$StartLevel = 1,
    [int]$EndLevel = 12  # BG3 current level cap
)

Write-Host "=== GENERATING FILE 11: Progressions.lsx (LEVEL-BY-LEVEL) ===" -ForegroundColor Cyan
Write-Host "Processing levels $StartLevel-$EndLevel" -ForegroundColor Gray

# Load data sources
Write-Host "`n[1] Loading data sources..." -ForegroundColor Yellow
$database = Import-Csv $DatabaseCsv
$spellLists = Import-Csv $SpellListMapping
Write-Host "  Database: $($database.Count) abilities" -ForegroundColor Gray
Write-Host "  SpellLists: $($spellLists.Count) UUID mappings" -ForegroundColor Gray

# Separate passives and spells
$passives = $database | Where-Object { $_.bg3_file_type -eq 'Passive' }
$spells = $database | Where-Object { $_.bg3_file_type -match '^Spell_' }

Write-Host "  Passives: $($passives.Count)" -ForegroundColor Gray
Write-Host "  Spells: $($spells.Count)" -ForegroundColor Gray

# UUIDs for Warrior class and subclasses (from ClassDescriptions.lsx)
$warriorClassUuid = "4f5d1434-5175-4fa9-b7dc-5a1c8f6c5521"
$armsSubclassUuid = "d3c5a4f2-8b6e-4a1d-9c7f-2e8b5a3c1d9f"
$furySubclassUuid = "e4d6b5g3-9c7f-5b2e-ad8g-3f9c6b4d2e0g"
$protectionSubclassUuid = "f5e7c6h4-ad8g-6c3f-be9h-4g0d7c5e3f1h"

# Initialize progression nodes array
$progressionNodes = @()

Write-Host "`n[2] Generating progression nodes level-by-level..." -ForegroundColor Yellow

# ===== BASE WARRIOR CLASS PROGRESSIONS (L1-12) =====
Write-Host "`n  [BASE WARRIOR CLASS]" -ForegroundColor Cyan

for ($level = $StartLevel; $level -le $EndLevel; $level++) {
    Write-Host "  Processing Level $level..." -ForegroundColor Yellow
    
    # Get passives that unlock at this level for Warrior
    $levelPassives = $passives | Where-Object { $_.warrior_unlock -eq $level }
    $passivesList = ($levelPassives | Select-Object -ExpandProperty ability_id) -join ';'
    
    # Get SpellList UUID for this level (if exists)
    $spellListUuid = ($spellLists | Where-Object { $_.Level -eq $level -and $_.Spec -eq 'Warrior' }).UUID
    
    # Build Boosts string (proficiencies, action resources, etc.)
    $boosts = @()
    
    # Level-specific boosts
    switch ($level) {
        1 {
            $boosts += "ActionResource(Rage,100,0)"  # 100 max Rage
            $boosts += "Proficiency(HeavyArmor)"
            $boosts += "Proficiency(MartialWeapons)"
            $boosts += "Proficiency(Shields)"
        }
        2 {
            # Action Surge ability (handled as spell)
        }
        3 {
            # Subclass selection level
        }
        4 {
            $boosts += "Ability(Strength,1,4)"  # ASI option
        }
        5 {
            $boosts += "ActionResource(Rage,120,0)"  # Increase Rage to 120
        }
        8 {
            $boosts += "Ability(Strength,1,4)"  # ASI option
        }
        9 {
            $boosts += "ActionResource(Rage,140,0)"  # Increase Rage to 140
        }
        12 {
            $boosts += "Ability(Strength,1,4)"  # ASI option
        }
    }
    
    $boostsStr = if ($boosts.Count -gt 0) { $boosts -join ';' } else { "" }
    
    # Create progression node
    $node = [PSCustomObject]@{
        Level = $level
        Class = "Warrior"
        UUID = $warriorClassUuid
        ProgressionType = "Base"
        Boosts = $boostsStr
        PassivesAdded = $passivesList
        SpellListUUID = $spellListUuid
        PassiveCount = $levelPassives.Count
        SpellCount = if ($spellListUuid) { ($spellLists | Where-Object { $_.UUID -eq $spellListUuid }).SpellCount } else { 0 }
    }
    
    $progressionNodes += $node
    
    Write-Host "    L$level Warrior: $($node.PassiveCount) passives, $($node.SpellCount) spells" -ForegroundColor Gray
    if ($boostsStr) {
        Write-Host "    Boosts: $($boosts.Count) added" -ForegroundColor Gray
    }
}

# ===== ARMS SUBCLASS PROGRESSIONS (L3-12) =====
Write-Host "`n  [ARMS SUBCLASS]" -ForegroundColor Cyan

for ($level = 3; $level -le $EndLevel; $level++) {
    Write-Host "  Processing Arms Level $level..." -ForegroundColor Yellow
    
    # Get passives that unlock at this level for Arms
    $levelPassives = $passives | Where-Object { $_.arms_unlock -eq $level }
    $passivesList = ($levelPassives | Select-Object -ExpandProperty ability_id) -join ';'
    
    # Get SpellList UUID for this level (if exists)
    $spellListUuid = ($spellLists | Where-Object { $_.Level -eq $level -and $_.Spec -eq 'Arms' }).UUID
    
    # Arms-specific boosts
    $boosts = @()
    
    switch ($level) {
        3 {
            # Subclass features granted
            $boosts += "Proficiency(TwoHandedWeapons)"
        }
    }
    
    $boostsStr = if ($boosts.Count -gt 0) { $boosts -join ';' } else { "" }
    
    # Create progression node
    $node = [PSCustomObject]@{
        Level = $level
        Class = "Arms"
        UUID = $armsSubclassUuid
        ProgressionType = "Subclass"
        Boosts = $boostsStr
        PassivesAdded = $passivesList
        SpellListUUID = $spellListUuid
        PassiveCount = $levelPassives.Count
        SpellCount = if ($spellListUuid) { ($spellLists | Where-Object { $_.UUID -eq $spellListUuid }).SpellCount } else { 0 }
    }
    
    $progressionNodes += $node
    
    Write-Host "    L$level Arms: $($node.PassiveCount) passives, $($node.SpellCount) spells" -ForegroundColor Gray
}

# ===== FURY SUBCLASS PROGRESSIONS (L3-12) =====
Write-Host "`n  [FURY SUBCLASS]" -ForegroundColor Cyan

for ($level = 3; $level -le $EndLevel; $level++) {
    Write-Host "  Processing Fury Level $level..." -ForegroundColor Yellow
    
    # Get passives that unlock at this level for Fury
    $levelPassives = $passives | Where-Object { $_.fury_unlock -eq $level }
    $passivesList = ($levelPassives | Select-Object -ExpandProperty ability_id) -join ';'
    
    # Get SpellList UUID for this level (if exists)
    $spellListUuid = ($spellLists | Where-Object { $_.Level -eq $level -and $_.Spec -eq 'Fury' }).UUID
    
    # Fury-specific boosts
    $boosts = @()
    
    switch ($level) {
        3 {
            # Subclass features granted
            $boosts += "Proficiency(DualWielding)"
        }
    }
    
    $boostsStr = if ($boosts.Count -gt 0) { $boosts -join ';' } else { "" }
    
    # Create progression node
    $node = [PSCustomObject]@{
        Level = $level
        Class = "Fury"
        UUID = $furySubclassUuid
        ProgressionType = "Subclass"
        Boosts = $boostsStr
        PassivesAdded = $passivesList
        SpellListUUID = $spellListUuid
        PassiveCount = $levelPassives.Count
        SpellCount = if ($spellListUuid) { ($spellLists | Where-Object { $_.UUID -eq $spellListUuid }).SpellCount } else { 0 }
    }
    
    $progressionNodes += $node
    
    Write-Host "    L$level Fury: $($node.PassiveCount) passives, $($node.SpellCount) spells" -ForegroundColor Gray
}

# ===== PROTECTION SUBCLASS PROGRESSIONS (L3-12) =====
Write-Host "`n  [PROTECTION SUBCLASS]" -ForegroundColor Cyan

for ($level = 3; $level -le $EndLevel; $level++) {
    Write-Host "  Processing Protection Level $level..." -ForegroundColor Yellow
    
    # Get passives that unlock at this level for Protection
    $levelPassives = $passives | Where-Object { $_.protection_unlock -eq $level }
    $passivesList = ($levelPassives | Select-Object -ExpandProperty ability_id) -join ';'
    
    # Get SpellList UUID for this level (if exists)
    $spellListUuid = ($spellLists | Where-Object { $_.Level -eq $level -and $_.Spec -eq 'Protection' }).UUID
    
    # Protection-specific boosts
    $boosts = @()
    
    switch ($level) {
        3 {
            # Subclass features granted
            $boosts += "Proficiency(Shields)"
            $boosts += "AC(1)"  # Bonus AC from shield mastery
        }
    }
    
    $boostsStr = if ($boosts.Count -gt 0) { $boosts -join ';' } else { "" }
    
    # Create progression node
    $node = [PSCustomObject]@{
        Level = $level
        Class = "Protection"
        UUID = $protectionSubclassUuid
        ProgressionType = "Subclass"
        Boosts = $boostsStr
        PassivesAdded = $passivesList
        SpellListUUID = $spellListUuid
        PassiveCount = $levelPassives.Count
        SpellCount = if ($spellListUuid) { ($spellLists | Where-Object { $_.UUID -eq $spellListUuid }).SpellCount } else { 0 }
    }
    
    $progressionNodes += $node
    
    Write-Host "    L$level Protection: $($node.PassiveCount) passives, $($node.SpellCount) spells" -ForegroundColor Gray
}

Write-Host "`n[3] Generating Progressions.lsx XML..." -ForegroundColor Yellow

# Generate XML structure
$xml = @"
<?xml version="1.0" encoding="UTF-8"?>
<save>
    <version major="4" minor="0" revision="9" build="0"/>
    <region id="Progressions">
        <node id="root">
            <children>
"@

# Generate progression nodes for each entry
foreach ($prog in $progressionNodes) {
    $xml += @"

                <!-- $($prog.Class) Level $($prog.Level) -->
                <node id="Progression">
                    <attribute id="Level" type="uint8" value="$($prog.Level)"/>
                    <attribute id="Name" type="LSString" value="$($prog.Class)"/>
                    <attribute id="ProgressionType" type="uint8" value="0"/>
                    <attribute id="TableUUID" type="guid" value="$($prog.UUID)"/>
"@

    # Add Boosts if present
    if ($prog.Boosts) {
        $xml += @"

                    <attribute id="Boosts" type="LSString" value="$($prog.Boosts)"/>
"@
    }

    # Add PassivesAdded if present
    if ($prog.PassivesAdded) {
        $xml += @"

                    <attribute id="PassivesAdded" type="LSString" value="$($prog.PassivesAdded)"/>
"@
    }

    # Add Selectors for spell lists if present
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

# Create output directory if needed
$outputDir = Split-Path $OutputFile -Parent
if (!(Test-Path $outputDir)) {
    New-Item -ItemType Directory -Path $outputDir -Force | Out-Null
    Write-Host "  Created directory: $outputDir" -ForegroundColor Gray
}

# Write Progressions.lsx
$xml | Out-File -FilePath $OutputFile -Encoding UTF8 -Force
Write-Host "  Written: $OutputFile" -ForegroundColor Green
Write-Host "  Size: $((Get-Item $OutputFile).Length) bytes" -ForegroundColor Gray

Write-Host "`n[4] Summary Statistics..." -ForegroundColor Yellow

$baseWarrior = $progressionNodes | Where-Object { $_.Class -eq 'Warrior' }
$armsNodes = $progressionNodes | Where-Object { $_.Class -eq 'Arms' }
$furyNodes = $progressionNodes | Where-Object { $_.Class -eq 'Fury' }
$protectionNodes = $progressionNodes | Where-Object { $_.Class -eq 'Protection' }

Write-Host "`n  Base Warrior: $($baseWarrior.Count) progression nodes (L$StartLevel-L$EndLevel)" -ForegroundColor Gray
Write-Host "    Total passives: $(($baseWarrior | Measure-Object -Property PassiveCount -Sum).Sum)" -ForegroundColor Gray
Write-Host "    Total spells: $(($baseWarrior | Measure-Object -Property SpellCount -Sum).Sum)" -ForegroundColor Gray

Write-Host "`n  Arms Subclass: $($armsNodes.Count) progression nodes (L3-L$EndLevel)" -ForegroundColor Gray
Write-Host "    Total passives: $(($armsNodes | Measure-Object -Property PassiveCount -Sum).Sum)" -ForegroundColor Gray
Write-Host "    Total spells: $(($armsNodes | Measure-Object -Property SpellCount -Sum).Sum)" -ForegroundColor Gray

Write-Host "`n  Fury Subclass: $($furyNodes.Count) progression nodes (L3-L$EndLevel)" -ForegroundColor Gray
Write-Host "    Total passives: $(($furyNodes | Measure-Object -Property PassiveCount -Sum).Sum)" -ForegroundColor Gray
Write-Host "    Total spells: $(($furyNodes | Measure-Object -Property SpellCount -Sum).Sum)" -ForegroundColor Gray

Write-Host "`n  Protection Subclass: $($protectionNodes.Count) progression nodes (L3-L$EndLevel)" -ForegroundColor Gray
Write-Host "    Total passives: $(($protectionNodes | Measure-Object -Property PassiveCount -Sum).Sum)" -ForegroundColor Gray
Write-Host "    Total spells: $(($protectionNodes | Measure-Object -Property SpellCount -Sum).Sum)" -ForegroundColor Gray

Write-Host "`n=== SUMMARY ===" -ForegroundColor Cyan
Write-Host "Progressions.lsx: $($progressionNodes.Count) total progression nodes" -ForegroundColor Green
Write-Host "Levels covered: $StartLevel-$EndLevel" -ForegroundColor Green
Write-Host "Classes: 1 base + 3 subclasses" -ForegroundColor Green
Write-Host "`nNext: Generate FILE 15 (Localization) for readable ability names" -ForegroundColor Yellow
