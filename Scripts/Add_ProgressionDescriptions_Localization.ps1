# Generate Localization Handles for ProgressionDescriptions.lsx
# Adds 66 new localization strings (33 rows × 2 handles each)

$LocalizationFile = "C:\Users\tenod\source\repos\BG3Mods\Data\Mods\Warrior_Wow_78fe4967-4e62-5491-d981-dd781acca4d7\Localization\English\english.xml"

# Warrior Class Talent Rows (L2-L10)
$WarriorClassRows = @(
    @{Row=1; DisplayName="Warrior Training I"; Description="Choose a fundamental warrior technique to master."},
    @{Row=2; DisplayName="Warrior Training II"; Description="Expand your martial prowess with advanced techniques."},
    @{Row=3; DisplayName="Warrior Training III"; Description="Further develop your combat capabilities."},
    @{Row=4; DisplayName="Warrior Training IV"; Description="Master additional battlefield tactics."},
    @{Row=5; DisplayName="Warrior Training V"; Description="Refine your warrior skills with specialized training."},
    @{Row=6; DisplayName="Warrior Training VI"; Description="Unlock powerful combat techniques."},
    @{Row=7; DisplayName="Warrior Training VII"; Description="Enhance your martial capabilities further."},
    @{Row=8; DisplayName="Warrior Training VIII"; Description="Gain access to elite warrior abilities."},
    @{Row=9; DisplayName="Warrior Training IX"; Description="Perfect your combat mastery with advanced techniques."}
)

# Arms Spec Talent Rows (L3-L10)
$ArmsRows = @(
    @{Row=1; DisplayName="Arms Specialization I"; Description="Choose an Arms warrior technique to enhance your two-handed weapon mastery."},
    @{Row=2; DisplayName="Arms Specialization II"; Description="Further specialize your Arms techniques."},
    @{Row=3; DisplayName="Arms Specialization III"; Description="Master additional Arms warrior abilities."},
    @{Row=4; DisplayName="Arms Specialization IV"; Description="Unlock powerful Arms techniques."},
    @{Row=5; DisplayName="Arms Specialization V"; Description="Perfect your Arms specialization."},
    @{Row=6; DisplayName="Arms Specialization VI"; Description="Enhance your Arms mastery further."},
    @{Row=7; DisplayName="Arms Specialization VII"; Description="Gain elite Arms warrior capabilities."},
    @{Row=8; DisplayName="Arms Specialization VIII"; Description="Achieve Arms warrior perfection."}
)

# Fury Spec Talent Rows (L3-L10)
$FuryRows = @(
    @{Row=1; DisplayName="Fury Specialization I"; Description="Choose a Fury warrior technique to unleash berserker rage."},
    @{Row=2; DisplayName="Fury Specialization II"; Description="Further specialize your Fury techniques."},
    @{Row=3; DisplayName="Fury Specialization III"; Description="Master additional Fury warrior abilities."},
    @{Row=4; DisplayName="Fury Specialization IV"; Description="Unlock powerful Fury techniques."},
    @{Row=5; DisplayName="Fury Specialization V"; Description="Perfect your Fury specialization."},
    @{Row=6; DisplayName="Fury Specialization VI"; Description="Enhance your Fury mastery further."},
    @{Row=7; DisplayName="Fury Specialization VII"; Description="Gain elite Fury warrior capabilities."},
    @{Row=8; DisplayName="Fury Specialization VIII"; Description="Achieve Fury warrior perfection."}
)

# Protection Spec Talent Rows (L2-L10)
$ProtectionRows = @(
    @{Row=1; DisplayName="Protection Specialization I"; Description="Choose a Protection warrior technique to bolster your defenses."},
    @{Row=2; DisplayName="Protection Specialization II"; Description="Further specialize your Protection techniques."},
    @{Row=3; DisplayName="Protection Specialization III"; Description="Master additional Protection warrior abilities."},
    @{Row=4; DisplayName="Protection Specialization IV"; Description="Unlock powerful Protection techniques."},
    @{Row=5; DisplayName="Protection Specialization V"; Description="Perfect your Protection specialization."},
    @{Row=6; DisplayName="Protection Specialization VI"; Description="Enhance your Protection mastery further."},
    @{Row=7; DisplayName="Protection Specialization VII"; Description="Gain elite Protection warrior capabilities."},
    @{Row=8; DisplayName="Protection Specialization VIII"; Description="Achieve Protection warrior perfection."}
)

# Generate XML content list entries
$XmlEntries = ""
$Counter = 1

# Warrior Class Rows
foreach ($Row in $WarriorClassRows) {
    $HandleNum1 = "{0:D4}" -f ($Counter * 2 - 1)
    $HandleNum2 = "{0:D4}" -f ($Counter * 2)
    
    $XmlEntries += @"
    <content contentuid="h78fe4967g0001g0001g0001g$HandleNum1" version="1">$($Row.Description)</content>
    <content contentuid="h78fe4967g0001g0001g0001g$HandleNum2" version="1">$($Row.DisplayName)</content>

"@
    $Counter++
}

# Arms Rows
foreach ($Row in $ArmsRows) {
    $HandleNum1 = "{0:D4}" -f ($Counter * 2 - 1)
    $HandleNum2 = "{0:D4}" -f ($Counter * 2)
    
    $XmlEntries += @"
    <content contentuid="h78fe4967g0002g0002g0002g$HandleNum1" version="1">$($Row.Description)</content>
    <content contentuid="h78fe4967g0002g0002g0002g$HandleNum2" version="1">$($Row.DisplayName)</content>

"@
    $Counter++
}

# Fury Rows
foreach ($Row in $FuryRows) {
    $HandleNum1 = "{0:D4}" -f ($Counter * 2 - 1)
    $HandleNum2 = "{0:D4}" -f ($Counter * 2)
    
    $XmlEntries += @"
    <content contentuid="h78fe4967g0003g0003g0003g$HandleNum1" version="1">$($Row.Description)</content>
    <content contentuid="h78fe4967g0003g0003g0003g$HandleNum2" version="1">$($Row.DisplayName)</content>

"@
    $Counter++
}

# Protection Rows
foreach ($Row in $ProtectionRows) {
    $HandleNum1 = "{0:D4}" -f ($Counter * 2 - 1)
    $HandleNum2 = "{0:D4}" -f ($Counter * 2)
    
    $XmlEntries += @"
    <content contentuid="h78fe4967g0004g0004g0004g$HandleNum1" version="1">$($Row.Description)</content>
    <content contentuid="h78fe4967g0004g0004g0004g$HandleNum2" version="1">$($Row.DisplayName)</content>

"@
    $Counter++
}

# Read existing localization file
$XmlContent = Get-Content -Path $LocalizationFile -Raw

# Find insertion point (before </contentList>)
if ($XmlContent -match '(.*</contentList>)') {
    $InsertionPoint = $XmlContent.LastIndexOf('</contentList>')
    $Before = $XmlContent.Substring(0, $InsertionPoint)
    $After = $XmlContent.Substring($InsertionPoint)
    
    # Insert new entries
    $NewContent = $Before + "`n    <!-- ProgressionDescriptions.lsx Talent Row Names -->`n" + $XmlEntries + $After
    
    # Write back
    $NewContent | Set-Content -Path $LocalizationFile -Encoding UTF8
    
    Write-Host "[SUCCESS] Added 66 localization handles to english.xml!" -ForegroundColor Green
    Write-Host "Total handles added: $(($Counter - 1) * 2)" -ForegroundColor Cyan
} else {
    Write-Host "[ERROR] Could not find </contentList> in english.xml" -ForegroundColor Red
}
