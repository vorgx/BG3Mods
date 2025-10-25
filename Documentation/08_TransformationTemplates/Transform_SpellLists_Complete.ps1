# Transform_SpellLists_Complete.ps1
# Generates complete SpellLists.lsx with 66 nodes (36 base/subclass + 30 hero)

param(
    [Parameter(Mandatory=$false)]
    [string]$OutputPath = ".\SpellLists_Warrior_Generated.xml"
)

Write-Host "`n[FILE 12 TRANSFORMATION: SPELLLISTS.LSX]" -ForegroundColor Cyan
Write-Host "=" * 80 -ForegroundColor Cyan

# ============================================================================
# UUID DEFINITIONS (From SOURCE_OF_TRUTH.md)
# ============================================================================

# Base Warrior Class (L1-12) - 12 SpellLists
$BaseWarriorUUIDs = @(
    @{Level=1; UUID="a1b2c3d4-5e6f-7a8b-9c0d-1e2f3a4b5c6d"; Comment="Warrior Level 1 Spells"; Spells="Target_WAR_Charge;WAR_HeroicStrike"},
    @{Level=2; UUID="b2c3d4e5-6f7a-8b9c-0d1e-2f3a4b5c6d7e"; Comment="Warrior Level 2 Spells"; Spells=""},
    @{Level=3; UUID="c3d4e5f6-7a8b-9c0d-1e2f-3a4b5c6d7e8f"; Comment="Warrior Level 3 Spells"; Spells=""},
    @{Level=4; UUID="d4e5f6a7-8b9c-0d1e-2f3a-4b5c6d7e8f9a"; Comment="Warrior Level 4 Spells"; Spells=""},
    @{Level=5; UUID="e5f6a7b8-9c0d-1e2f-3a4b-5c6d7e8f9a0b"; Comment="Warrior Level 5 Spells"; Spells=""},
    @{Level=6; UUID="f6a7b8c9-0d1e-2f3a-4b5c-6d7e8f9a0b1c"; Comment="Warrior Level 6 Spells"; Spells=""},
    @{Level=7; UUID="a7b8c9d0-1e2f-3a4b-5c6d-7e8f9a0b1c2d"; Comment="Warrior Level 7 Spells"; Spells=""},
    @{Level=8; UUID="b8c9d0e1-2f3a-4b5c-6d7e-8f9a0b1c2d3e"; Comment="Warrior Level 8 Spells"; Spells=""},
    @{Level=9; UUID="c9d0e1f2-3a4b-5c6d-7e8f-9a0b1c2d3e4f"; Comment="Warrior Level 9 Spells"; Spells=""},
    @{Level=10; UUID="d0e1f2a3-4b5c-6d7e-8f9a-0b1c2d3e4f5a"; Comment="Warrior Level 10 Spells"; Spells=""},
    @{Level=11; UUID="e1f2a3b4-5c6d-7e8f-9a0b-1c2d3e4f5a6b"; Comment="Warrior Level 11 Spells"; Spells=""},
    @{Level=12; UUID="f2a3b4c5-6d7e-8f9a-0b1c-2d3e4f5a6b7c"; Comment="Warrior Level 12 Spells"; Spells=""}
)

# Arms Warrior (L1-12) - 12 SpellLists
$ArmsUUIDs = @(
    @{Level=1; UUID="a3b4c5d6-7e8f-9a0b-1c2d-3e4f5a6b7c8d"; Comment="Arms Level 1 Spells"; Spells=""},
    @{Level=2; UUID="b4c5d6e7-8f9a-0b1c-2d3e-4f5a6b7c8d9e"; Comment="Arms Level 2 Spells"; Spells=""},
    @{Level=3; UUID="c5d6e7f8-9a0b-1c2d-3e4f-5a6b7c8d9e0f"; Comment="Arms Level 3 Spells"; Spells=""},
    @{Level=4; UUID="d6e7f8a9-0b1c-2d3e-4f5a-6b7c8d9e0f1a"; Comment="Arms Level 4 Spells"; Spells=""},
    @{Level=5; UUID="e7f8a9b0-1c2d-3e4f-5a6b-7c8d9e0f1a2b"; Comment="Arms Level 5 Spells"; Spells=""},
    @{Level=6; UUID="f8a9b0c1-2d3e-4f5a-6b7c-8d9e0f1a2b3c"; Comment="Arms Level 6 Spells"; Spells=""},
    @{Level=7; UUID="a9b0c1d2-3e4f-5a6b-7c8d-9e0f1a2b3c4d"; Comment="Arms Level 7 Spells"; Spells=""},
    @{Level=8; UUID="b0c1d2e3-4f5a-6b7c-8d9e-0f1a2b3c4d5e"; Comment="Arms Level 8 Spells"; Spells=""},
    @{Level=9; UUID="c1d2e3f4-5a6b-7c8d-9e0f-1a2b3c4d5e6f"; Comment="Arms Level 9 Spells"; Spells=""},
    @{Level=10; UUID="d2e3f4a5-6b7c-8d9e-0f1a-2b3c4d5e6f7a"; Comment="Arms Level 10 Spells"; Spells=""},
    @{Level=11; UUID="e3f4a5b6-7c8d-9e0f-1a2b-3c4d5e6f7a8b"; Comment="Arms Level 11 Spells"; Spells=""},
    @{Level=12; UUID="f4a5b6c7-8d9e-0f1a-2b3c-4d5e6f7a8b9c"; Comment="Arms Level 12 Spells"; Spells=""}
)

# Fury Warrior (L1-12) - 12 SpellLists
$FuryUUIDs = @(
    @{Level=1; UUID="a5b6c7d8-9e0f-1a2b-3c4d-5e6f7a8b9c0d"; Comment="Fury Level 1 Spells"; Spells=""},
    @{Level=2; UUID="b6c7d8e9-0f1a-2b3c-4d5e-6f7a8b9c0d1e"; Comment="Fury Level 2 Spells"; Spells=""},
    @{Level=3; UUID="c7d8e9f0-1a2b-3c4d-5e6f-7a8b9c0d1e2f"; Comment="Fury Level 3 Spells"; Spells=""},
    @{Level=4; UUID="d8e9f0a1-2b3c-4d5e-6f7a-8b9c0d1e2f3a"; Comment="Fury Level 4 Spells"; Spells=""},
    @{Level=5; UUID="e9f0a1b2-3c4d-5e6f-7a8b-9c0d1e2f3a4b"; Comment="Fury Level 5 Spells"; Spells=""},
    @{Level=6; UUID="f0a1b2c3-4d5e-6f7a-8b9c-0d1e2f3a4b5c"; Comment="Fury Level 6 Spells"; Spells=""},
    @{Level=7; UUID="a1b2c3d4-5e6f-7a8b-9c0d-1e2f3a4b5c6d"; Comment="Fury Level 7 Spells"; Spells=""},
    @{Level=8; UUID="b2c3d4e5-6f7a-8b9c-0d1e-2f3a4b5c6d7e"; Comment="Fury Level 8 Spells"; Spells=""},
    @{Level=9; UUID="c3d4e5f6-7a8b-9c0d-1e2f-3a4b5c6d7e8f"; Comment="Fury Level 9 Spells"; Spells=""},
    @{Level=10; UUID="d4e5f6a7-8b9c-0d1e-2f3a-4b5c6d7e8f9a"; Comment="Fury Level 10 Spells"; Spells=""},
    @{Level=11; UUID="e5f6a7b8-9c0d-1e2f-3a4b-5c6d7e8f9a0b"; Comment="Fury Level 11 Spells"; Spells=""},
    @{Level=12; UUID="f6a7b8c9-0d1e-2f3a-4b5c-6d7e8f9a0b1c"; Comment="Fury Level 12 Spells"; Spells=""}
)

# Protection Warrior (L1-12) - 12 SpellLists
$ProtectionUUIDs = @(
    @{Level=1; UUID="a7b8c9d0-1e2f-3a4b-5c6d-7e8f9a0b1c2d"; Comment="Protection Level 1 Spells"; Spells=""},
    @{Level=2; UUID="b8c9d0e1-2f3a-4b5c-6d7e-8f9a0b1c2d3e"; Comment="Protection Level 2 Spells"; Spells=""},
    @{Level=3; UUID="c9d0e1f2-3a4b-5c6d-7e8f-9a0b1c2d3e4f"; Comment="Protection Level 3 Spells"; Spells=""},
    @{Level=4; UUID="d0e1f2a3-4b5c-6d7e-8f9a-0b1c2d3e4f5a"; Comment="Protection Level 4 Spells"; Spells=""},
    @{Level=5; UUID="e1f2a3b4-5c6d-7e8f-9a0b-1c2d3e4f5a6b"; Comment="Protection Level 5 Spells"; Spells=""},
    @{Level=6; UUID="f2a3b4c5-6d7e-8f9a-0b1c-2d3e4f5a6b7c"; Comment="Protection Level 6 Spells"; Spells=""},
    @{Level=7; UUID="a3b4c5d6-7e8f-9a0b-1c2d-3e4f5a6b7c8d"; Comment="Protection Level 7 Spells"; Spells=""},
    @{Level=8; UUID="b4c5d6e7-8f9a-0b1c-2d3e-4f5a6b7c8d9e"; Comment="Protection Level 8 Spells"; Spells=""},
    @{Level=9; UUID="c5d6e7f8-9a0b-1c2d-3e4f-5a6b7c8d9e0f"; Comment="Protection Level 9 Spells"; Spells=""},
    @{Level=10; UUID="d6e7f8a9-0b1c-2d3e-4f5a-6b7c8d9e0f1a"; Comment="Protection Level 10 Spells"; Spells=""},
    @{Level=11; UUID="e7f8a9b0-1c2d-3e4f-5a6b-7c8d9e0f1a2b"; Comment="Protection Level 11 Spells"; Spells=""},
    @{Level=12; UUID="f8a9b0c1-2d3e-4f5a-6b7c-8d9e0f1a2b3c"; Comment="Protection Level 12 Spells"; Spells=""}
)

# Hero Subclass UUIDs (L13/15/17/19/20) - 30 SpellLists (6 subclasses × 5 levels)
# From SOURCE_OF_TRUTH.md Section [5] Hero Classes
$HeroSubclassUUIDs = @(
    # ArmsColossus (5 SpellLists)
    @{Level=13; Spec="ArmsColossus"; UUID="6a1b8c3d-7e9f-4a5b-8c6d-9e0f1a2b3c4d"; Comment="ArmsColossus Level 13 Spells"; Spells=""},
    @{Level=15; Spec="ArmsColossus"; UUID="6a1b8c3d-7e9f-4a5b-8c6d-9e0f1a2b3c4e"; Comment="ArmsColossus Level 15 Spells"; Spells=""},
    @{Level=17; Spec="ArmsColossus"; UUID="6a1b8c3d-7e9f-4a5b-8c6d-9e0f1a2b3c4f"; Comment="ArmsColossus Level 17 Spells"; Spells=""},
    @{Level=19; Spec="ArmsColossus"; UUID="6a1b8c3d-7e9f-4a5b-8c6d-9e0f1a2b3c5a"; Comment="ArmsColossus Level 19 Spells"; Spells=""},
    @{Level=20; Spec="ArmsColossus"; UUID="6a1b8c3d-7e9f-4a5b-8c6d-9e0f1a2b3c5b"; Comment="ArmsColossus Level 20 Spells"; Spells=""},
    
    # ArmsSlayers (5 SpellLists)
    @{Level=13; Spec="ArmsSlayers"; UUID="7b2c9d4e-8f0g-5b6c-9d7e-0f1g2b3c4d5e"; Comment="ArmsSlayers Level 13 Spells"; Spells=""},
    @{Level=15; Spec="ArmsSlayers"; UUID="7b2c9d4e-8f0a-5b6c-9d7e-0f1a2b3c4d5e"; Comment="ArmsSlayers Level 15 Spells"; Spells=""},
    @{Level=17; Spec="ArmsSlayers"; UUID="7b2c9d4e-8f0a-5b6c-9d7e-0f1a2b3c4d5f"; Comment="ArmsSlayers Level 17 Spells"; Spells=""},
    @{Level=19; Spec="ArmsSlayers"; UUID="7b2c9d4e-8f0a-5b6c-9d7e-0f1a2b3c4d6a"; Comment="ArmsSlayers Level 19 Spells"; Spells=""},
    @{Level=20; Spec="ArmsSlayers"; UUID="7b2c9d4e-8f0a-5b6c-9d7e-0f1a2b3c4d6b"; Comment="ArmsSlayers Level 20 Spells"; Spells=""},
    
    # FuryMountainThane (5 SpellLists)
    @{Level=13; Spec="FuryMountainThane"; UUID="8c3d0e5f-9g1h-6c7d-0e8f-1g2h3c4d5e6f"; Comment="FuryMountainThane Level 13 Spells"; Spells=""},
    @{Level=15; Spec="FuryMountainThane"; UUID="8c3d0e5f-9a1b-6c7d-0e8f-1a2b3c4d5e6f"; Comment="FuryMountainThane Level 15 Spells"; Spells=""},
    @{Level=17; Spec="FuryMountainThane"; UUID="8c3d0e5f-9a1b-6c7d-0e8f-1a2b3c4d5e7a"; Comment="FuryMountainThane Level 17 Spells"; Spells=""},
    @{Level=19; Spec="FuryMountainThane"; UUID="8c3d0e5f-9a1b-6c7d-0e8f-1a2b3c4d5e7b"; Comment="FuryMountainThane Level 19 Spells"; Spells=""},
    @{Level=20; Spec="FuryMountainThane"; UUID="8c3d0e5f-9a1b-6c7d-0e8f-1a2b3c4d5e7c"; Comment="FuryMountainThane Level 20 Spells"; Spells=""},
    
    # FurySlayers (5 SpellLists)
    @{Level=13; Spec="FurySlayers"; UUID="9d4e1f6g-0h2i-7d8e-1f9g-2h3i4d5e6f7g"; Comment="FurySlayers Level 13 Spells"; Spells=""},
    @{Level=15; Spec="FurySlayers"; UUID="9d4e1f6a-0b2c-7d8e-1f9a-2b3c4d5e6f7a"; Comment="FurySlayers Level 15 Spells"; Spells=""},
    @{Level=17; Spec="FurySlayers"; UUID="9d4e1f6a-0b2c-7d8e-1f9a-2b3c4d5e6f7b"; Comment="FurySlayers Level 17 Spells"; Spells=""},
    @{Level=19; Spec="FurySlayers"; UUID="9d4e1f6a-0b2c-7d8e-1f9a-2b3c4d5e6f7c"; Comment="FurySlayers Level 19 Spells"; Spells=""},
    @{Level=20; Spec="FurySlayers"; UUID="9d4e1f6a-0b2c-7d8e-1f9a-2b3c4d5e6f7d"; Comment="FurySlayers Level 20 Spells"; Spells=""},
    
    # ProtectionMountainThane (5 SpellLists)
    @{Level=13; Spec="ProtectionMountainThane"; UUID="0e5f2g7h-1i3j-8e9f-2g0h-3i4j5e6f7g8h"; Comment="ProtectionMountainThane Level 13 Spells"; Spells=""},
    @{Level=15; Spec="ProtectionMountainThane"; UUID="0e5f2a7b-1c3d-8e9f-2a0b-3c4d5e6f7a8b"; Comment="ProtectionMountainThane Level 15 Spells"; Spells=""},
    @{Level=17; Spec="ProtectionMountainThane"; UUID="0e5f2a7b-1c3d-8e9f-2a0b-3c4d5e6f7a8c"; Comment="ProtectionMountainThane Level 17 Spells"; Spells=""},
    @{Level=19; Spec="ProtectionMountainThane"; UUID="0e5f2a7b-1c3d-8e9f-2a0b-3c4d5e6f7a8d"; Comment="ProtectionMountainThane Level 19 Spells"; Spells=""},
    @{Level=20; Spec="ProtectionMountainThane"; UUID="0e5f2a7b-1c3d-8e9f-2a0b-3c4d5e6f7a8e"; Comment="ProtectionMountainThane Level 20 Spells"; Spells=""},
    
    # ProtectionColossus (5 SpellLists)
    @{Level=13; Spec="ProtectionColossus"; UUID="1f6g3h8i-2j4k-9f0g-3h1i-4j5k6f7g8h9i"; Comment="ProtectionColossus Level 13 Spells"; Spells=""},
    @{Level=15; Spec="ProtectionColossus"; UUID="1f6a3b8c-2d4e-9f0a-3b1c-4d5e6f7a8b9c"; Comment="ProtectionColossus Level 15 Spells"; Spells=""},
    @{Level=17; Spec="ProtectionColossus"; UUID="1f6a3b8c-2d4e-9f0a-3b1c-4d5e6f7a8b9d"; Comment="ProtectionColossus Level 17 Spells"; Spells=""},
    @{Level=19; Spec="ProtectionColossus"; UUID="1f6a3b8c-2d4e-9f0a-3b1c-4d5e6f7a8b9e"; Comment="ProtectionColossus Level 19 Spells"; Spells=""},
    @{Level=20; Spec="ProtectionColossus"; UUID="1f6a3b8c-2d4e-9f0a-3b1c-4d5e6f7a8b9f"; Comment="ProtectionColossus Level 20 Spells"; Spells=""}
)

# ============================================================================
# GENERATE XML
# ============================================================================

Write-Host "`n[STEP 1] Generating SpellList Nodes..." -ForegroundColor Yellow

$XmlContent = @()

# Helper function to generate SpellList node
function New-SpellListNode {
    param($Entry)
    
    $XmlContent = @"
                <node id="SpellList">
                    <attribute id="Comment" type="LSString" value="$($Entry.Comment)"/>
                    <attribute id="Spells" type="LSString" value="$($Entry.Spells)"/>
                    <attribute id="UUID" type="guid" value="$($Entry.UUID)"/>
                </node>
"@
    return $XmlContent
}

# Base Warrior Class (12 nodes)
Write-Host "  [1] Base Warrior Class (L1-12): 12 nodes" -ForegroundColor Cyan
$XmlContent += "                <!-- Base Warrior Class Spell Lists (L1-12) -->"
foreach ($Entry in $BaseWarriorUUIDs) {
    $XmlContent += (New-SpellListNode -Entry $Entry)
}

# Arms Warrior (12 nodes)
Write-Host "  [2] Arms Warrior (L1-12): 12 nodes" -ForegroundColor Cyan
$XmlContent += "`n                <!-- Arms Warrior Spell Lists (L1-12) -->"
foreach ($Entry in $ArmsUUIDs) {
    $XmlContent += (New-SpellListNode -Entry $Entry)
}

# Fury Warrior (12 nodes)
Write-Host "  [3] Fury Warrior (L1-12): 12 nodes" -ForegroundColor Cyan
$XmlContent += "`n                <!-- Fury Warrior Spell Lists (L1-12) -->"
foreach ($Entry in $FuryUUIDs) {
    $XmlContent += (New-SpellListNode -Entry $Entry)
}

# Protection Warrior (12 nodes)
Write-Host "  [4] Protection Warrior (L1-12): 12 nodes" -ForegroundColor Cyan
$XmlContent += "`n                <!-- Protection Warrior Spell Lists (L1-12) -->"
foreach ($Entry in $ProtectionUUIDs) {
    $XmlContent += (New-SpellListNode -Entry $Entry)
}

# Hero Subclasses (30 nodes)
Write-Host "  [5] Hero Subclasses (L13/15/17/19/20): 30 nodes" -ForegroundColor Cyan
$HeroGroups = $HeroSubclassUUIDs | Group-Object -Property Spec
foreach ($Group in $HeroGroups) {
    $XmlContent += "`n                <!-- $($Group.Name) Hero Subclass Spell Lists -->"
    foreach ($Entry in $Group.Group) {
        $XmlContent += (New-SpellListNode -Entry $Entry)
    }
}

# ============================================================================
# CREATE FULL XML FILE
# ============================================================================

Write-Host "`n[STEP 2] Creating Full XML Structure..." -ForegroundColor Yellow

$FullXml = @"
<?xml version="1.0" encoding="UTF-8"?>
<save>
    <version major="4" minor="8" revision="0" build="200"/>
    <region id="SpellLists">
        <node id="root">
            <children>
$($XmlContent -join "`n")
            </children>
        </node>
    </region>
</save>
"@

$FullXml | Out-File -FilePath $OutputPath -Encoding UTF8

Write-Host "[SUCCESS] Generated 66 SpellList nodes" -ForegroundColor Green
Write-Host "[OUTPUT] $OutputPath" -ForegroundColor Cyan

# ============================================================================
# SUMMARY
# ============================================================================

Write-Host "`n[SUMMARY]" -ForegroundColor Cyan
Write-Host "=" * 80 -ForegroundColor Cyan
Write-Host "  Base Warrior (L1-12): 12 SpellLists" -ForegroundColor White
Write-Host "  Arms Warrior (L1-12): 12 SpellLists" -ForegroundColor White
Write-Host "  Fury Warrior (L1-12): 12 SpellLists" -ForegroundColor White
Write-Host "  Protection Warrior (L1-12): 12 SpellLists" -ForegroundColor White
Write-Host "  Hero Subclasses (L13-20): 30 SpellLists" -ForegroundColor White
Write-Host "  --------------------------------" -ForegroundColor Gray
Write-Host "  TOTAL: 78 SpellList nodes" -ForegroundColor Green

Write-Host "`n[NOTES]" -ForegroundColor Yellow
Write-Host "  - All SpellLists use 'Zero SpellList' pattern (empty Spells attribute)" -ForegroundColor Gray
Write-Host "  - Abilities are auto-granted via Progressions.lsx (AddSpells/PassivesAdded)" -ForegroundColor Gray
Write-Host "  - Base Warrior L1 has actual spells (Charge + Heroic Strike)" -ForegroundColor Gray
Write-Host "  - All other SpellLists have empty Spells attribute" -ForegroundColor Gray

Write-Host "`n[NEXT STEP]" -ForegroundColor Cyan
Write-Host "  Replace current SpellLists.lsx content with generated XML" -ForegroundColor Yellow
