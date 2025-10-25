# Generate SpellLists.lsx (FILE 12)
# Creates spell lists for Warrior progression (base class + 3 subclasses, L1-20)
# Outputs: SpellLists.lsx + UUID mapping CSV for Progressions.lsx reference

param(
    [string]$DatabaseCsv = "C:\Users\tenod\source\repos\BG3Mods\Documentation\00_SourcesOfTruth\AbilityDatabase_Warrior_FullyEnriched.csv",
    [string]$OutputFile = "C:\Users\tenod\source\repos\BG3Mods\Data\Public\Warrior_Wow_78fe4967-4e62-5491-d981-dd781acca4d7\Lists\SpellLists.lsx",
    [string]$UuidMappingFile = "C:\Users\tenod\source\repos\BG3Mods\Scripts\SpellList_UUID_Mapping.csv"
)

Write-Host "=== GENERATING FILE 12: SpellLists.lsx ===" -ForegroundColor Cyan

# Load ability database
Write-Host "`n[1] Loading ability database..." -ForegroundColor Yellow
$database = Import-Csv $DatabaseCsv

# Filter to spell/ability entries (not passives, not statuses)
$spellAbilities = $database | Where-Object { 
    $_.bg3_file_type -match '^Spell_' -and
    ($_.warrior_unlock -or $_.arms_unlock -or $_.fury_unlock -or $_.protection_unlock)
}

Write-Host "  Found $($spellAbilities.Count) spell abilities with unlock data" -ForegroundColor Gray

# Group spells by level and spec
Write-Host "`n[2] Grouping spells by level and specialization..." -ForegroundColor Yellow

$spellLists = @()
$uuidMapping = @()

# Process levels 1-20 for base Warrior class
for ($level = 1; $level -le 20; $level++) {
    $warriorSpells = $spellAbilities | Where-Object { $_.warrior_unlock -eq $level } | Select-Object -ExpandProperty ability_id
    
    if ($warriorSpells) {
        $spells = ($warriorSpells | Where-Object { $_ -and $_.Trim() }) -join ';'
        if ($spells) {
            $uuid = [guid]::NewGuid().ToString()
            $spellLists += [PSCustomObject]@{
                Level = $level
                Spec = "Warrior"
                UUID = $uuid
                Spells = $spells
            }
            $uuidMapping += [PSCustomObject]@{
                Level = $level
                Spec = "Warrior"
                UUID = $uuid
                SpellCount = ($spells -split ';').Count
            }
            Write-Host "  L$level Warrior: $($spells -split ';' | Measure-Object).Count spells" -ForegroundColor Gray
        }
    }
}

# Process levels 1-20 for Arms subclass
for ($level = 1; $level -le 20; $level++) {
    $armsSpells = $spellAbilities | Where-Object { $_.arms_unlock -eq $level } | Select-Object -ExpandProperty ability_id
    
    if ($armsSpells) {
        $spells = ($armsSpells | Where-Object { $_ -and $_.Trim() }) -join ';'
        if ($spells) {
            $uuid = [guid]::NewGuid().ToString()
            $spellLists += [PSCustomObject]@{
                Level = $level
                Spec = "Arms"
                UUID = $uuid
                Spells = $spells
            }
            $uuidMapping += [PSCustomObject]@{
                Level = $level
                Spec = "Arms"
                UUID = $uuid
                SpellCount = ($spells -split ';').Count
            }
            Write-Host "  L$level Arms: $($spells -split ';' | Measure-Object).Count spells" -ForegroundColor Gray
        }
    }
}

# Process levels 1-20 for Fury subclass
for ($level = 1; $level -le 20; $level++) {
    $furySpells = $spellAbilities | Where-Object { $_.fury_unlock -eq $level } | Select-Object -ExpandProperty ability_id
    
    if ($furySpells) {
        $spells = ($furySpells | Where-Object { $_ -and $_.Trim() }) -join ';'
        if ($spells) {
            $uuid = [guid]::NewGuid().ToString()
            $spellLists += [PSCustomObject]@{
                Level = $level
                Spec = "Fury"
                UUID = $uuid
                Spells = $spells
            }
            $uuidMapping += [PSCustomObject]@{
                Level = $level
                Spec = "Fury"
                UUID = $uuid
                SpellCount = ($spells -split ';').Count
            }
            Write-Host "  L$level Fury: $($spells -split ';' | Measure-Object).Count spells" -ForegroundColor Gray
        }
    }
}

# Process levels 1-20 for Protection subclass
for ($level = 1; $level -le 20; $level++) {
    $protSpells = $spellAbilities | Where-Object { $_.protection_unlock -eq $level } | Select-Object -ExpandProperty ability_id
    
    if ($protSpells) {
        $spells = ($protSpells | Where-Object { $_ -and $_.Trim() }) -join ';'
        if ($spells) {
            $uuid = [guid]::NewGuid().ToString()
            $spellLists += [PSCustomObject]@{
                Level = $level
                Spec = "Protection"
                UUID = $uuid
                Spells = $spells
            }
            $uuidMapping += [PSCustomObject]@{
                Level = $level
                Spec = "Protection"
                UUID = $uuid
                SpellCount = ($spells -split ';').Count
            }
            Write-Host "  L$level Protection: $($spells -split ';' | Measure-Object).Count spells" -ForegroundColor Gray
        }
    }
}

Write-Host "`n  Total spell lists: $($spellLists.Count)" -ForegroundColor Green

# Generate XML content
Write-Host "`n[3] Generating SpellLists.lsx XML..." -ForegroundColor Yellow

$xml = @"
<?xml version="1.0" encoding="UTF-8"?>
<save>
    <version major="4" minor="0" revision="9" build="0"/>
    <region id="SpellLists">
        <node id="root">
            <children>
"@

foreach ($list in $spellLists) {
    $xml += @"

                <node id="SpellList">
                    <attribute id="Comment" type="LSString" value="$($list.Spec) Level $($list.Level) Spells"/>
                    <attribute id="Spells" type="LSString" value="$($list.Spells)"/>
                    <attribute id="UUID" type="guid" value="$($list.UUID)"/>
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

# Write SpellLists.lsx
$xml | Out-File -FilePath $OutputFile -Encoding UTF8 -Force
Write-Host "  Written: $OutputFile" -ForegroundColor Green
Write-Host "  Size: $((Get-Item $OutputFile).Length) bytes" -ForegroundColor Gray

# Export UUID mapping CSV
$uuidMapping | Export-Csv -Path $UuidMappingFile -NoTypeInformation -Force
Write-Host "`n[4] UUID Mapping exported:" -ForegroundColor Yellow
Write-Host "  File: $UuidMappingFile" -ForegroundColor Gray
Write-Host "  Entries: $($uuidMapping.Count)" -ForegroundColor Gray

# Summary
Write-Host "`n=== SUMMARY ===" -ForegroundColor Cyan
Write-Host "SpellLists.lsx: $($spellLists.Count) spell lists created" -ForegroundColor Green
Write-Host "UUID Mapping CSV: $($uuidMapping.Count) entries for Progressions.lsx reference" -ForegroundColor Green
Write-Host "`nBreakdown by spec:" -ForegroundColor Yellow
Write-Host "  Warrior: $(($uuidMapping | Where-Object { $_.Spec -eq 'Warrior' }).Count) lists" -ForegroundColor Gray
Write-Host "  Arms: $(($uuidMapping | Where-Object { $_.Spec -eq 'Arms' }).Count) lists" -ForegroundColor Gray
Write-Host "  Fury: $(($uuidMapping | Where-Object { $_.Spec -eq 'Fury' }).Count) lists" -ForegroundColor Gray
Write-Host "  Protection: $(($uuidMapping | Where-Object { $_.Spec -eq 'Protection' }).Count) lists" -ForegroundColor Gray

Write-Host "`nNext: Use UUID mapping to generate FILE 11 (Progressions.lsx)" -ForegroundColor Cyan
