# Generate PassiveLists.lsx (FILE 13)
# Creates passive lists for Warrior talent choices (base class + 3 subclasses + 6 hero paths)
# Outputs: PassiveLists.lsx + UUID mapping CSV for Progressions.lsx reference
# Expected node counts:
#   - Warrior: 8 PassiveLists (L1-20, only levels with talent passives)
#   - Arms: 8 PassiveLists (L1-20, only levels with talent passives)
#   - Fury: 5 PassiveLists (L1-20, only levels with talent passives)
#   - Protection: 8 PassiveLists (L1-20, only levels with talent passives)
#   - ArmsColossus: 5 PassiveLists (L13/15/17/19/20)
#   - ArmsSlayers: 5 PassiveLists (L13/15/17/19/20)
#   - FurySlayers: 5 PassiveLists (L13/15/17/19/20)
#   - FuryMountainThane: 5 PassiveLists (L13/15/17/19/20)
#   - ProtectionColossus: 5 PassiveLists (L13/15/17/19/20)
#   - ProtectionMountainThane: 5 PassiveLists (L13/15/17/19/20)
# Total: 29 regular + 30 hero = 59 PassiveList nodes

param(
    [string]$DatabaseCsv = "C:\Users\tenod\source\repos\BG3Mods\Documentation\00_SourcesOfTruth\AbilityDatabase_Warrior_FullyEnriched.csv",
    [string]$OutputFile = "C:\Users\tenod\source\repos\BG3Mods\Data\Public\Warrior_Wow_78fe4967-4e62-5491-d981-dd781acca4d7\Lists\PassiveLists.lsx",
    [string]$UuidMappingFile = "C:\Users\tenod\source\repos\BG3Mods\Scripts\PassiveList_UUID_Mapping.csv"
)

Write-Host "=== GENERATING FILE 13: PassiveLists.lsx ===" -ForegroundColor Cyan

# Load ability database
Write-Host "`n[1] Loading ability database..." -ForegroundColor Yellow
$database = Import-Csv $DatabaseCsv

# Filter to Talent-Passive entries (these are player choices)
$talentPassives = $database | Where-Object { 
    $_.ability_subtype -eq 'Talent-Passive' -and
    ($_.warrior_unlock -or $_.arms_unlock -or $_.fury_unlock -or $_.protection_unlock)
}

# Filter to Hero-Talent-Passive entries + Lightning Strikes (Mountain Thane L13 keystone)
# NOTE: Lightning Strikes has ability_subtype "Single-Target-Attack", not "Hero-Talent-Passive"
$heroPassives = $database | Where-Object { 
    ($_.ability_subtype -eq 'Hero-Talent-Passive' -or $_.ability_name -eq 'Lightning Strikes') -and
    ($_.warrior_unlock -or $_.arms_unlock -or $_.fury_unlock -or $_.protection_unlock) -and
    $_.granted_by_subclass -match 'Colossus|Slayers|MountainThane'
}

Write-Host "  Found $($talentPassives.Count) talent passives with unlock data" -ForegroundColor Gray
Write-Host "  Found $($heroPassives.Count) hero talent passives (including Lightning Strikes keystone)" -ForegroundColor Gray

# Group passives by level and spec
Write-Host "`n[2] Grouping passives by level and specialization..." -ForegroundColor Yellow

$passiveLists = @()
$uuidMapping = @()

# Process levels 1-20 for base Warrior class (only levels with passives)
for ($level = 1; $level -le 20; $level++) {
    $warriorPassives = $talentPassives | Where-Object { $_.warrior_unlock -eq $level } | Select-Object -ExpandProperty ability_id
    
    if ($warriorPassives) {
        $passives = ($warriorPassives | Where-Object { $_ -and $_.Trim() }) -join ';'
        if ($passives) {
            $uuid = [guid]::NewGuid().ToString()
            $passiveLists += [PSCustomObject]@{
                Level = $level
                Spec = "Warrior"
                UUID = $uuid
                Passives = $passives
                Comment = "Warrior Level $level Passives"
            }
            $uuidMapping += [PSCustomObject]@{
                Level = $level
                Spec = "Warrior"
                UUID = $uuid
                PassiveCount = ($passives -split ';').Count
            }
            Write-Host "  L$level Warrior: $($passives -split ';' | Measure-Object).Count passives" -ForegroundColor Gray
        }
    }
}

# Process levels 1-20 for Arms subclass
for ($level = 1; $level -le 20; $level++) {
    $armsPassives = $talentPassives | Where-Object { $_.arms_unlock -eq $level } | Select-Object -ExpandProperty ability_id
    
    if ($armsPassives) {
        $passives = ($armsPassives | Where-Object { $_ -and $_.Trim() }) -join ';'
        if ($passives) {
            $uuid = [guid]::NewGuid().ToString()
            $passiveLists += [PSCustomObject]@{
                Level = $level
                Spec = "Arms"
                UUID = $uuid
                Passives = $passives
                Comment = "Arms Level $level Passives"
            }
            $uuidMapping += [PSCustomObject]@{
                Level = $level
                Spec = "Arms"
                UUID = $uuid
                PassiveCount = ($passives -split ';').Count
            }
            Write-Host "  L$level Arms: $($passives -split ';' | Measure-Object).Count passives" -ForegroundColor Gray
        }
    }
}

# Process levels 1-20 for Fury subclass
for ($level = 1; $level -le 20; $level++) {
    $furyPassives = $talentPassives | Where-Object { $_.fury_unlock -eq $level } | Select-Object -ExpandProperty ability_id
    
    if ($furyPassives) {
        $passives = ($furyPassives | Where-Object { $_ -and $_.Trim() }) -join ';'
        if ($passives) {
            $uuid = [guid]::NewGuid().ToString()
            $passiveLists += [PSCustomObject]@{
                Level = $level
                Spec = "Fury"
                UUID = $uuid
                Passives = $passives
                Comment = "Fury Level $level Passives"
            }
            $uuidMapping += [PSCustomObject]@{
                Level = $level
                Spec = "Fury"
                UUID = $uuid
                PassiveCount = ($passives -split ';').Count
            }
            Write-Host "  L$level Fury: $($passives -split ';' | Measure-Object).Count passives" -ForegroundColor Gray
        }
    }
}

# Process levels 1-20 for Protection subclass
for ($level = 1; $level -le 20; $level++) {
    $protectionPassives = $talentPassives | Where-Object { $_.protection_unlock -eq $level } | Select-Object -ExpandProperty ability_id
    
    if ($protectionPassives) {
        $passives = ($protectionPassives | Where-Object { $_ -and $_.Trim() }) -join ';'
        if ($passives) {
            $uuid = [guid]::NewGuid().ToString()
            $passiveLists += [PSCustomObject]@{
                Level = $level
                Spec = "Protection"
                UUID = $uuid
                Passives = $passives
                Comment = "Protection Level $level Passives"
            }
            $uuidMapping += [PSCustomObject]@{
                Level = $level
                Spec = "Protection"
                UUID = $uuid
                PassiveCount = ($passives -split ';').Count
            }
            Write-Host "  L$level Protection: $($passives -split ';' | Measure-Object).Count passives" -ForegroundColor Gray
        }
    }
}

# Process Hero Talent Passives by PATH (6 paths × 5 levels = 30 PassiveLists)
Write-Host "`n  Processing Hero Talent Passives by PATH..." -ForegroundColor Cyan

# Arms Colossus (L13-20)
for ($level = 13; $level -le 20; $level++) {
    $pathPassives = $heroPassives | Where-Object { 
        $_.granted_by_subclass -match 'ArmsColossus' -and $_.arms_unlock -eq $level 
    } | Select-Object -ExpandProperty ability_id
    
    if ($pathPassives) {
        $passives = ($pathPassives | Where-Object { $_ -and $_.Trim() }) -join ';'
        if ($passives) {
            $uuid = [guid]::NewGuid().ToString()
            $passiveLists += [PSCustomObject]@{
                Level = $level
                Spec = "ArmsColossus"
                UUID = $uuid
                Passives = $passives
                Comment = "Arms Colossus Level $level"
            }
            $uuidMapping += [PSCustomObject]@{
                Level = $level
                Spec = "ArmsColossus"
                UUID = $uuid
                PassiveCount = ($passives -split ';').Count
            }
            Write-Host "  L$level ArmsColossus: $($passives -split ';' | Measure-Object).Count passives" -ForegroundColor Gray
        }
    }
}

# Arms Slayers (L13-20)
for ($level = 13; $level -le 20; $level++) {
    $pathPassives = $heroPassives | Where-Object { 
        $_.granted_by_subclass -match 'ArmsSlayers' -and $_.arms_unlock -eq $level 
    } | Select-Object -ExpandProperty ability_id
    
    if ($pathPassives) {
        $passives = ($pathPassives | Where-Object { $_ -and $_.Trim() }) -join ';'
        if ($passives) {
            $uuid = [guid]::NewGuid().ToString()
            $passiveLists += [PSCustomObject]@{
                Level = $level
                Spec = "ArmsSlayers"
                UUID = $uuid
                Passives = $passives
                Comment = "Arms Slayer Level $level"
            }
            $uuidMapping += [PSCustomObject]@{
                Level = $level
                Spec = "ArmsSlayers"
                UUID = $uuid
                PassiveCount = ($passives -split ';').Count
            }
            Write-Host "  L$level ArmsSlayers: $($passives -split ';' | Measure-Object).Count passives" -ForegroundColor Gray
        }
    }
}

# Fury Slayers (L13-20)
for ($level = 13; $level -le 20; $level++) {
    $pathPassives = $heroPassives | Where-Object { 
        $_.granted_by_subclass -match 'FurySlayers' -and $_.fury_unlock -eq $level 
    } | Select-Object -ExpandProperty ability_id
    
    if ($pathPassives) {
        $passives = ($pathPassives | Where-Object { $_ -and $_.Trim() }) -join ';'
        if ($passives) {
            $uuid = [guid]::NewGuid().ToString()
            $passiveLists += [PSCustomObject]@{
                Level = $level
                Spec = "FurySlayers"
                UUID = $uuid
                Passives = $passives
                Comment = "Fury Slayer Level $level"
            }
            $uuidMapping += [PSCustomObject]@{
                Level = $level
                Spec = "FurySlayers"
                UUID = $uuid
                PassiveCount = ($passives -split ';').Count
            }
            Write-Host "  L$level FurySlayers: $($passives -split ';' | Measure-Object).Count passives" -ForegroundColor Gray
        }
    }
}

# Fury Mountain Thane (L13-20)
for ($level = 13; $level -le 20; $level++) {
    $pathPassives = $heroPassives | Where-Object { 
        $_.granted_by_subclass -match 'FuryMountainThane' -and $_.fury_unlock -eq $level 
    } | Select-Object -ExpandProperty ability_id
    
    if ($pathPassives) {
        $passives = ($pathPassives | Where-Object { $_ -and $_.Trim() }) -join ';'
        if ($passives) {
            $uuid = [guid]::NewGuid().ToString()
            $passiveLists += [PSCustomObject]@{
                Level = $level
                Spec = "FuryMountainThane"
                UUID = $uuid
                Passives = $passives
                Comment = "Fury Mountain Thane Level $level"
            }
            $uuidMapping += [PSCustomObject]@{
                Level = $level
                Spec = "FuryMountainThane"
                UUID = $uuid
                PassiveCount = ($passives -split ';').Count
            }
            Write-Host "  L$level FuryMountainThane: $($passives -split ';' | Measure-Object).Count passives" -ForegroundColor Gray
        }
    }
}

# Protection Colossus (L13-20)
for ($level = 13; $level -le 20; $level++) {
    $pathPassives = $heroPassives | Where-Object { 
        $_.granted_by_subclass -match 'ProtectionColossus' -and $_.protection_unlock -eq $level 
    } | Select-Object -ExpandProperty ability_id
    
    if ($pathPassives) {
        $passives = ($pathPassives | Where-Object { $_ -and $_.Trim() }) -join ';'
        if ($passives) {
            $uuid = [guid]::NewGuid().ToString()
            $passiveLists += [PSCustomObject]@{
                Level = $level
                Spec = "ProtectionColossus"
                UUID = $uuid
                Passives = $passives
                Comment = "Protection Colossus Level $level"
            }
            $uuidMapping += [PSCustomObject]@{
                Level = $level
                Spec = "ProtectionColossus"
                UUID = $uuid
                PassiveCount = ($passives -split ';').Count
            }
            Write-Host "  L$level ProtectionColossus: $($passives -split ';' | Measure-Object).Count passives" -ForegroundColor Gray
        }
    }
}

# Protection Mountain Thane (L13-20)
for ($level = 13; $level -le 20; $level++) {
    $pathPassives = $heroPassives | Where-Object { 
        $_.granted_by_subclass -match 'ProtectionMountainThane' -and $_.protection_unlock -eq $level 
    } | Select-Object -ExpandProperty ability_id
    
    if ($pathPassives) {
        $passives = ($pathPassives | Where-Object { $_ -and $_.Trim() }) -join ';'
        if ($passives) {
            $uuid = [guid]::NewGuid().ToString()
            $passiveLists += [PSCustomObject]@{
                Level = $level
                Spec = "ProtectionMountainThane"
                UUID = $uuid
                Passives = $passives
                Comment = "Protection Mountain Thane Level $level"
            }
            $uuidMapping += [PSCustomObject]@{
                Level = $level
                Spec = "ProtectionMountainThane"
                UUID = $uuid
                PassiveCount = ($passives -split ';').Count
            }
            Write-Host "  L$level ProtectionMountainThane: $($passives -split ';' | Measure-Object).Count passives" -ForegroundColor Gray
        }
    }
}

Write-Host "`n[3] Generating PassiveLists.lsx XML..." -ForegroundColor Yellow
Write-Host "  Total PassiveList nodes: $($passiveLists.Count)" -ForegroundColor Green

# Generate XML content
$xmlContent = @"
<?xml version="1.0" encoding="UTF-8"?>
<save>
    <version major="4" minor="0" revision="9" build="0"/>
    <region id="PassiveLists">
        <node id="root">
            <children>
"@

# Add each PassiveList node
foreach ($list in $passiveLists) {
    $xmlContent += @"

                <node id="PassiveList">
                    <attribute id="Comment" type="LSString" value="$($list.Comment)"/>
                    <attribute id="Passives" type="LSString" value="$($list.Passives)"/>
                    <attribute id="UUID" type="guid" value="$($list.UUID)"/>
                </node>
"@
}

$xmlContent += @"

            </children>
        </node>
    </region>
</save>
"@

# Write to file
Write-Host "`n[4] Writing PassiveLists.lsx..." -ForegroundColor Yellow
$xmlContent | Out-File -FilePath $OutputFile -Encoding UTF8 -NoNewline
Write-Host "  Written: $OutputFile" -ForegroundColor Green

# Export UUID mapping
Write-Host "`n[5] Exporting UUID mapping CSV..." -ForegroundColor Yellow
$uuidMapping | Export-Csv -Path $UuidMappingFile -NoTypeInformation
Write-Host "  Written: $UuidMappingFile" -ForegroundColor Green

Write-Host "`n=== GENERATION COMPLETE ===" -ForegroundColor Cyan
Write-Host "PassiveLists generated: $($passiveLists.Count) nodes" -ForegroundColor Green
Write-Host "  Warrior: $(($passiveLists | Where-Object { $_.Spec -eq 'Warrior' }).Count) levels" -ForegroundColor Gray
Write-Host "  Arms: $(($passiveLists | Where-Object { $_.Spec -eq 'Arms' }).Count) levels" -ForegroundColor Gray
Write-Host "  Fury: $(($passiveLists | Where-Object { $_.Spec -eq 'Fury' }).Count) levels" -ForegroundColor Gray
Write-Host "  Protection: $(($passiveLists | Where-Object { $_.Spec -eq 'Protection' }).Count) levels" -ForegroundColor Gray
Write-Host "  Arms-Hero: $(($passiveLists | Where-Object { $_.Spec -eq 'Arms-Hero' }).Count) levels (L13-20)" -ForegroundColor Cyan
Write-Host "  Fury-Hero: $(($passiveLists | Where-Object { $_.Spec -eq 'Fury-Hero' }).Count) levels (L13-20)" -ForegroundColor Cyan
Write-Host "  Protection-Hero: $(($passiveLists | Where-Object { $_.Spec -eq 'Protection-Hero' }).Count) levels (L13-20)" -ForegroundColor Cyan
