# Transform ProgressionDescriptions.lsx from Warlock to Warrior
# Creates ProgressionDescription nodes for all Warrior talent choice rows

$TargetFile = "C:\Users\tenod\source\repos\BG3Mods\Data\Public\Warrior_Wow_78fe4967-4e62-5491-d981-dd781acca4d7\Progressions\ProgressionDescriptions.lsx"

# Warrior Class Talent Rows (L2-L10, shared by all specs)
$WarriorClassRows = @(
    @{Level=2; Row=1; DisplayName="Warrior Training I"; Description="Choose a fundamental warrior technique to master."},
    @{Level=3; Row=2; DisplayName="Warrior Training II"; Description="Expand your martial prowess with advanced techniques."},
    @{Level=4; Row=3; DisplayName="Warrior Training III"; Description="Further develop your combat capabilities."},
    @{Level=5; Row=4; DisplayName="Warrior Training IV"; Description="Master additional battlefield tactics."},
    @{Level=6; Row=5; DisplayName="Warrior Training V"; Description="Refine your warrior skills with specialized training."},
    @{Level=7; Row=6; DisplayName="Warrior Training VI"; Description="Unlock powerful combat techniques."},
    @{Level=8; Row=7; DisplayName="Warrior Training VII"; Description="Enhance your martial capabilities further."},
    @{Level=9; Row=8; DisplayName="Warrior Training VIII"; Description="Gain access to elite warrior abilities."},
    @{Level=10; Row=9; DisplayName="Warrior Training IX"; Description="Perfect your combat mastery with advanced techniques."}
)

# Arms Spec Talent Rows (L3-L10)
$ArmsRows = @(
    @{Level=3; Row=1; DisplayName="Arms Specialization I"; Description="Choose an Arms warrior technique to enhance your two-handed weapon mastery."},
    @{Level=4; Row=2; DisplayName="Arms Specialization II"; Description="Further specialize your Arms techniques."},
    @{Level=5; Row=3; DisplayName="Arms Specialization III"; Description="Master additional Arms warrior abilities."},
    @{Level=6; Row=4; DisplayName="Arms Specialization IV"; Description="Unlock powerful Arms techniques."},
    @{Level=7; Row=5; DisplayName="Arms Specialization V"; Description="Perfect your Arms specialization."},
    @{Level=8; Row=6; DisplayName="Arms Specialization VI"; Description="Enhance your Arms mastery further."},
    @{Level=9; Row=7; DisplayName="Arms Specialization VII"; Description="Gain elite Arms warrior capabilities."},
    @{Level=10; Row=8; DisplayName="Arms Specialization VIII"; Description="Achieve Arms warrior perfection."}
)

# Fury Spec Talent Rows (L3-L10)
$FuryRows = @(
    @{Level=3; Row=1; DisplayName="Fury Specialization I"; Description="Choose a Fury warrior technique to unleash berserker rage."},
    @{Level=4; Row=2; DisplayName="Fury Specialization II"; Description="Further specialize your Fury techniques."},
    @{Level=5; Row=3; DisplayName="Fury Specialization III"; Description="Master additional Fury warrior abilities."},
    @{Level=6; Row=4; DisplayName="Fury Specialization IV"; Description="Unlock powerful Fury techniques."},
    @{Level=7; Row=5; DisplayName="Fury Specialization V"; Description="Perfect your Fury specialization."},
    @{Level=8; Row=6; DisplayName="Fury Specialization VI"; Description="Enhance your Fury mastery further."},
    @{Level=9; Row=7; DisplayName="Fury Specialization VII"; Description="Gain elite Fury warrior capabilities."},
    @{Level=10; Row=8; DisplayName="Fury Specialization VIII"; Description="Achieve Fury warrior perfection."}
)

# Protection Spec Talent Rows (L2-L10)
$ProtectionRows = @(
    @{Level=2; Row=1; DisplayName="Protection Specialization I"; Description="Choose a Protection warrior technique to bolster your defenses."},
    @{Level=3; Row=2; DisplayName="Protection Specialization II"; Description="Further specialize your Protection techniques."},
    @{Level=4; Row=3; DisplayName="Protection Specialization III"; Description="Master additional Protection warrior abilities."},
    @{Level=5; Row=4; DisplayName="Protection Specialization IV"; Description="Unlock powerful Protection techniques."},
    @{Level=6; Row=5; DisplayName="Protection Specialization V"; Description="Perfect your Protection specialization."},
    @{Level=7; Row=6; DisplayName="Protection Specialization VI"; Description="Enhance your Protection mastery further."},
    @{Level=8; Row=7; DisplayName="Protection Specialization VII"; Description="Gain elite Protection warrior capabilities."},
    @{Level=9; Row=8; DisplayName="Protection Specialization VIII"; Description="Achieve Protection warrior perfection."}
)

# Generate XML content
$XmlContent = @'
<?xml version="1.0" encoding="UTF-8"?>
<save>
    <version major="4" minor="8" revision="0" build="200"/>
    <region id="ProgressionDescriptions">
        <node id="root">
            <children>
'@

# Add Warrior Class Rows
$Counter = 1
foreach ($Row in $WarriorClassRows) {
    $HandleNum1 = "{0:D4}" -f ($Counter * 2 - 1)
    $HandleNum2 = "{0:D4}" -f ($Counter * 2)
    $UuidSuffix = "{0:D12}" -f $Counter
    
    $XmlContent += @"
                <!-- Level $($Row.Level): Warrior Class Talent Row $($Row.Row) -->
                <node id="ProgressionDescription">
                    <attribute id="Description" type="TranslatedString" handle="h78fe4967g0001g0001g0001g$HandleNum1" version="1"/>
                    <attribute id="DisplayName" type="TranslatedString" handle="h78fe4967g0001g0001g0001g$HandleNum2" version="1"/>
                    <attribute id="SelectorId" type="FixedString" value="WarriorClassTalentRow$($Row.Row)"/>
                    <attribute id="UUID" type="guid" value="78fe4967-0001-0001-0001-$UuidSuffix"/>
                </node>

"@
    $Counter++
}

# Add Arms Rows
foreach ($Row in $ArmsRows) {
    $HandleNum1 = "{0:D4}" -f ($Counter * 2 - 1)
    $HandleNum2 = "{0:D4}" -f ($Counter * 2)
    $UuidSuffix = "{0:D12}" -f $Counter
    
    $XmlContent += @"
                <!-- Level $($Row.Level): Arms Spec Talent Row $($Row.Row) -->
                <node id="ProgressionDescription">
                    <attribute id="Description" type="TranslatedString" handle="h78fe4967g0002g0002g0002g$HandleNum1" version="1"/>
                    <attribute id="DisplayName" type="TranslatedString" handle="h78fe4967g0002g0002g0002g$HandleNum2" version="1"/>
                    <attribute id="SelectorId" type="FixedString" value="ArmsSpecTalentRow$($Row.Row)"/>
                    <attribute id="UUID" type="guid" value="78fe4967-0002-0002-0002-$UuidSuffix"/>
                </node>

"@
    $Counter++
}

# Add Fury Rows
foreach ($Row in $FuryRows) {
    $HandleNum1 = "{0:D4}" -f ($Counter * 2 - 1)
    $HandleNum2 = "{0:D4}" -f ($Counter * 2)
    $UuidSuffix = "{0:D12}" -f $Counter
    
    $XmlContent += @"
                <!-- Level $($Row.Level): Fury Spec Talent Row $($Row.Row) -->
                <node id="ProgressionDescription">
                    <attribute id="Description" type="TranslatedString" handle="h78fe4967g0003g0003g0003g$HandleNum1" version="1"/>
                    <attribute id="DisplayName" type="TranslatedString" handle="h78fe4967g0003g0003g0003g$HandleNum2" version="1"/>
                    <attribute id="SelectorId" type="FixedString" value="FurySpecTalentRow$($Row.Row)"/>
                    <attribute id="UUID" type="guid" value="78fe4967-0003-0003-0003-$UuidSuffix"/>
                </node>

"@
    $Counter++
}

# Add Protection Rows
foreach ($Row in $ProtectionRows) {
    $HandleNum1 = "{0:D4}" -f ($Counter * 2 - 1)
    $HandleNum2 = "{0:D4}" -f ($Counter * 2)
    $UuidSuffix = "{0:D12}" -f $Counter
    
    $XmlContent += @"
                <!-- Level $($Row.Level): Protection Spec Talent Row $($Row.Row) -->
                <node id="ProgressionDescription">
                    <attribute id="Description" type="TranslatedString" handle="h78fe4967g0004g0004g0004g$HandleNum1" version="1"/>
                    <attribute id="DisplayName" type="TranslatedString" handle="h78fe4967g0004g0004g0004g$HandleNum2" version="1"/>
                    <attribute id="SelectorId" type="FixedString" value="ProtectionSpecTalentRow$($Row.Row)"/>
                    <attribute id="UUID" type="guid" value="78fe4967-0004-0004-0004-$UuidSuffix"/>
                </node>

"@
    $Counter++
}

$XmlContent += @'
            </children>
        </node>
    </region>
</save>
'@

# Write to file
$XmlContent | Set-Content -Path $TargetFile -Encoding UTF8

Write-Host "[SUCCESS] ProgressionDescriptions.lsx transformed!" -ForegroundColor Green
Write-Host "Total ProgressionDescription nodes created: $($Counter - 1)" -ForegroundColor Cyan
Write-Host "  - Warrior Class Rows: $($WarriorClassRows.Count)" -ForegroundColor Yellow
Write-Host "  - Arms Spec Rows: $($ArmsRows.Count)" -ForegroundColor Yellow
Write-Host "  - Fury Spec Rows: $($FuryRows.Count)" -ForegroundColor Yellow
Write-Host "  - Protection Spec Rows: $($ProtectionRows.Count)" -ForegroundColor Yellow
Write-Host ""
Write-Host "[NEXT STEP] Add localization handles to english.xml" -ForegroundColor Magenta
