# ==========================================
# COMPLETE LOCALIZATION GENERATION
# ==========================================
# Purpose: Generate all 494 localization handles for 247 stat entries
# Strategy: Extract from stat files, generate unique handles, create english.xml
# Created: October 25, 2025

param(
    [switch]$DryRun = $false
)

Write-Host "`n==================== COMPLETE LOCALIZATION GENERATION ====================" -ForegroundColor Cyan

# ==========================================
# CONFIGURATION
# ==========================================

$StatsFolder = "C:\Users\tenod\source\repos\BG3Mods\Data\Public\Warrior_Wow_78fe4967-4e62-5491-d981-dd781acca4d7\Stats\Generated\Data"
$LocalizationPath = "C:\Users\tenod\source\repos\BG3Mods\Data\Mods\Warrior_Wow_78fe4967-4e62-5491-d981-dd781acca4d7\Localization\English\english.xml"
$DatabasePath = "C:\Users\tenod\source\repos\BG3Mods\Documentation\00_SourcesOfTruth\AbilityDatabase_Warrior_FullyEnriched.csv"
$OutputCsvPath = "C:\Users\tenod\source\repos\BG3Mods\Scripts\Generated_Localization_Handles.csv"

# Warrior UUID prefix for handles
$HandlePrefix = "h78fe4967"

# ==========================================
# STEP 1: Extract all entries from stat files
# ==========================================

Write-Host "`n[STEP 1] Extracting entries from stat files..." -ForegroundColor Yellow

$StatFiles = @{
    "Status_BOOST" = "$StatsFolder\Status_BOOST.txt"
    "Spell_Zone" = "$StatsFolder\Spell_Zone.txt"
    "Spell_Shout" = "$StatsFolder\Spell_Shout.txt"
    "Spell_Jump" = "$StatsFolder\Spell_Jump.txt"
    "Spell_Target" = "$StatsFolder\Spell_Target.txt"
    "Spell_Projectile" = "$StatsFolder\Spell_Projectile.txt"
    "Passive" = "$StatsFolder\Passive.txt"
}

$AllEntries = @()
$Counter = 1

foreach ($FileType in $StatFiles.Keys) {
    $FilePath = $StatFiles[$FileType]
    
    if (-not (Test-Path $FilePath)) {
        Write-Warning "Stat file not found: $FilePath"
        continue
    }
    
    Write-Host "  Processing $FileType..." -ForegroundColor Gray
    
    $Content = Get-Content $FilePath -Raw
    $Matches = [regex]::Matches($Content, 'new entry "([^"]+)"')
    
    for ($i = 0; $i -lt $Matches.Count; $i++) {
        $EntryName = $Matches[$i].Groups[1].Value
        $StartIndex = $Matches[$i].Index
        $EndIndex = if ($i -lt $Matches.Count - 1) { $Matches[$i + 1].Index } else { $Content.Length }
        $BlockLength = $EndIndex - $StartIndex
        $Block = $Content.Substring($StartIndex, $BlockLength)

        $DataMap = @{}
        $DataMatches = [regex]::Matches($Block, 'data "([^"]+)" "([^"]*)"')
        foreach ($DataMatch in $DataMatches) {
            $Key = $DataMatch.Groups[1].Value
            $Value = $DataMatch.Groups[2].Value
            $DataMap[$Key] = $Value
        }

        $EntryTypeMatch = [regex]::Match($Block, 'type "([^"]+)"')
        $EntryType = if ($EntryTypeMatch.Success) { $EntryTypeMatch.Groups[1].Value } else { $null }

        # Generate unique handles for DisplayName and Description using compact BG3 format (hUUIDg####)
        $HandleHex = '{0:x4}' -f $Counter
        $HandleName = "${HandlePrefix}g$HandleHex"
        $Counter++

        $HandleHex = '{0:x4}' -f $Counter
        $HandleDesc = "${HandlePrefix}g$HandleHex"
        $Counter++
        
        $AllEntries += [PSCustomObject]@{
            EntryName = $EntryName
            FileType = $FileType
            HandleName = $HandleName
            HandleDesc = $HandleDesc
            DisplayName = ""  # Will populate from database
            Description = ""  # Will populate from database
            DataMap = $DataMap
            EntryType = $EntryType
        }
    }
}

Write-Host "[INFO] Total entries extracted: $($AllEntries.Count)" -ForegroundColor Cyan
Write-Host "[INFO] Total handles generated: $($Counter - 1)" -ForegroundColor Cyan

# ==========================================
# STEP 2: Load ability database for names/descriptions
# ==========================================

Write-Host "`n[STEP 2] Loading ability database..." -ForegroundColor Yellow

if (Test-Path $DatabasePath) {
    $Database = Import-Csv $DatabasePath
    Write-Host "[INFO] Database loaded: $($Database.Count) abilities" -ForegroundColor Cyan
    
    # Create lookup dictionary
    $DbLookup = @{}
    foreach ($Row in $Database) {
        if ($Row.ability_id) {
            $DbLookup[$Row.ability_id] = $Row
        }
    }
    
    Write-Host "[INFO] Database lookup created: $($DbLookup.Count) entries" -ForegroundColor Cyan
} else {
    Write-Warning "Database not found: $DatabasePath"
    $Database = @()
    $DbLookup = @{}
}

function Sanitize-LocalizationText {
    param([string]$Value)

    if ([string]::IsNullOrWhiteSpace($Value)) { return $Value }

    $Clean = [regex]::Replace($Value, 'https://www\.wowhead\.com\S*', '')
    $Clean = [regex]::Replace($Clean, 'Wowhead:\s*', '', 'IgnoreCase')
    $Clean = [regex]::Replace($Clean, ' +', ' ')
    $Clean = [regex]::Replace($Clean, ' \n', "`n")
    $Clean = [regex]::Replace($Clean, '\n ', "`n")

    return $Clean.Trim()
}

function Get-DescriptionText {
    param([Parameter(Mandatory = $true)][pscustomobject]$Row)

    $Candidates = @(
        $Row.description_full,
        $Row.description_short,
        $Row.implementation_notes
    )

    foreach ($Candidate in $Candidates) {
        if ($Candidate -and -not [string]::IsNullOrWhiteSpace($Candidate)) {
            return (Sanitize-LocalizationText $Candidate)
        }
    }

    return $null
}

function Resolve-ContextLabel {
    param([string]$Value)

    if ([string]::IsNullOrWhiteSpace($Value)) { return "" }

    $Trimmed = $Value.Trim().Trim("'")

    switch -regex ($Trimmed) {
        '^context\.Source$' { return 'self' }
        '^context\.Target$' { return 'target' }
        '^SELF$' { return 'self' }
        '^TARGET$' { return 'target' }
        '^NEARBY_ENEMIES$' { return 'nearby enemies' }
        default { return $Trimmed }
    }
}

function Format-ActionCostLabel {
    param([string]$Label, [string]$Amount)

    if ([string]::IsNullOrWhiteSpace($Amount) -or $Amount -eq '1') {
        return $Label
    }

    return "$Amount $Label"
}

function Format-ResourceCostLabel {
    param([string]$Label, [string]$Amount)

    if ([string]::IsNullOrWhiteSpace($Amount)) {
        return $Label
    }

    if ($Amount.StartsWith('-')) {
        $Absolute = $Amount.TrimStart('-')
        return "Restore $Absolute $Label"
    }

    return "$Label $Amount"
}

function Parse-UseCosts {
    param([string]$Value)

    if ([string]::IsNullOrWhiteSpace($Value)) {
        return [PSCustomObject]@{ Action = $null; Resources = $null }
    }

    if ($Value -notmatch ':') {
        return [PSCustomObject]@{ Action = $null; Resources = $null }
    }

    $Segments = $Value -split ';' | Where-Object { -not [string]::IsNullOrWhiteSpace($_) }
    if ($Segments.Count -eq 0) {
        return [PSCustomObject]@{ Action = $null; Resources = $null }
    }

    $Actions = @()
    $Resources = @()

    foreach ($Segment in $Segments) {
        $Parts = $Segment.Split(':')
        $Key = $Parts[0].Trim()
        $Amount = if ($Parts.Count -gt 1) { $Parts[1].Trim() } else { $null }

        switch ($Key) {
            'ActionPoint'       { $Actions += Format-ActionCostLabel 'Action' $Amount }
            'BonusActionPoint'  { $Actions += Format-ActionCostLabel 'Bonus Action' $Amount }
            'ReactionActionPoint' { $Actions += Format-ActionCostLabel 'Reaction' $Amount }
            'FreeActionPoint'   { $Actions += Format-ActionCostLabel 'Free Action' $Amount }
            default {
                if (-not [string]::IsNullOrWhiteSpace($Key)) {
                    $Resources += Format-ResourceCostLabel $Key $Amount
                }
            }
        }
    }

    $ActionText = if ($Actions.Count -gt 0) { ($Actions | Select-Object -Unique) -join ', ' } else { $null }
    $ResourceText = if ($Resources.Count -gt 0) { ($Resources | Select-Object -Unique) -join ', ' } else { $null }

    return [PSCustomObject]@{
        Action = $ActionText
        Resources = $ResourceText
    }
}

function Format-SingleEffect {
    param([string]$Effect)

    if ([string]::IsNullOrWhiteSpace($Effect)) { return $null }

    $Clean = $Effect.Trim()

    if ($Clean -match '^DealDamage\(([^,]+),([^,]+)(?:,([^\)]+))?\)$') {
        $Dice = $Matches[1].Trim()
        $DamageType = $Matches[2].Trim()
        $Source = if ($Matches[3]) { $Matches[3].Trim() } else { $null }
        $Text = "Deal $Dice $DamageType damage"
        if ($Source -and $Source -notin @('Magical', 'Physical')) {
            $Text += " ($Source)"
        }
        return $Text
    }

    if ($Clean -match '^ApplyStatus\(([^,]+),([^,]+),([^,]+),([^\)]+)\)$') {
        $Target = Resolve-ContextLabel $Matches[1].Trim()
        $Status = $Matches[2].Trim().Trim("'")
        $Chance = $Matches[3].Trim()
        $Duration = $Matches[4].Trim()

        $ChanceText = if ($Chance -eq '100') { '' } else { " at $Chance% chance" }
        $DurationText = switch ($Duration) {
            '-1' { ' indefinitely' }
            '0'  { '' }
            default { " for $Duration turn(s)" }
        }

        $TargetText = if ($Target) { $Target } else { 'target' }
        return "Apply $Status to $TargetText$DurationText$ChanceText".Trim()
    }

    if ($Clean -match '^RestoreResource\(([^,]+),([^,]+),([^,]+),([^\)]+)\)$') {
        $Target = Resolve-ContextLabel $Matches[1].Trim()
        $Resource = $Matches[2].Trim()
        $Amount = $Matches[3].Trim()
        $TargetText = if ($Target) { $Target } else { 'self' }
        return "Restore $Amount $Resource to $TargetText"
    }

    if ($Clean -match '^RegainHitPoints\(([^\)]+)\)$') {
        return "Heal $($Matches[1].Trim())"
    }

    if ($Clean -match '^RemoveStatus\(([^\)]+)\)$') {
        $Status = $Matches[1].Trim().Trim("'")
        return "Remove status $Status"
    }

    if ($Clean -match '^Interrupt\(\)$') {
        return 'Interrupt the target'
    }

    if ($Clean -match '^TeleportSource\(\)$') {
        return 'Teleport self'
    }

    if ($Clean -match '^TeleportSelf\(\)$') {
        return 'Teleport self'
    }

    $Fallback = $Clean.Replace('context.Source', 'self').Replace('context.Target', 'target')
    return $Fallback
}

function Format-EffectsList {
    param([string]$Value)

    if ([string]::IsNullOrWhiteSpace($Value)) { return $null }

    $Parts = $Value -split ';' | Where-Object { -not [string]::IsNullOrWhiteSpace($_) }
    if ($Parts.Count -eq 0) { return $null }

    $Formatted = foreach ($Part in $Parts) {
        Format-SingleEffect $Part
    }

    $Formatted = $Formatted | Where-Object { -not [string]::IsNullOrWhiteSpace($_) }
    if ($Formatted.Count -eq 0) { return $null }

    return ($Formatted -join '; ')
}

function Format-Conditions {
    param([string]$Value)

    if ([string]::IsNullOrWhiteSpace($Value)) { return $null }

    $Text = $Value.Trim()
    $Text = $Text.Replace('context.Source', 'self').Replace('context.Target', 'target')
    $Text = [regex]::Replace($Text, "HealthPercentage\(target\) <= ([0-9]+)", 'target HP <= $1%')
    $Text = [regex]::Replace($Text, "HasStatus\\('([^']+)'\\,self\\)", 'self has status $1')
    $Text = [regex]::Replace($Text, "HasStatus\\('([^']+)'\\,target\\)", 'target has status $1')
    $Text = [regex]::Replace($Text, "HasPassive\\('([^']+)'\\,self\\)", 'self has passive $1')
    $Text = [regex]::Replace($Text, "HasStringInSpellRoll\\('([^']+)'\\)", 'spell roll contains $1')
    $Text = $Text.Replace('Character()', 'character').Replace('AreaTarget()', 'area target').Replace('MeleeRange()', 'melee range')
    $Text = $Text.Replace('not Dead()', 'not dead').Replace('Dead()', 'dead')
    $Text = $Text -replace '\s+', ' '
    return $Text.Trim()
}

function Is-MeaningfulValue {
    param([string]$Value)

    if ([string]::IsNullOrWhiteSpace($Value)) { return $false }

    $Trimmed = $Value.Trim()
    $Invalid = @(
        'None',
        'N/A',
        'N/A - Passive',
        'N/A - Passive Effect',
        'Placeholder()',
        'Pending'
    )

    return -not ($Invalid -contains $Trimmed)
}

function Build-DetailedDescription {
    param(
        [Parameter(Mandatory = $true)][pscustomobject]$Entry,
        [pscustomobject]$DbEntry,
        [string]$BaseDescription
    )

    $Sections = @()
    $Primary = if ($BaseDescription) { $BaseDescription.Trim() } else { "$($Entry.EntryName) - Warrior ability" }
    $Sections += $Primary

    $Details = @()

    if ($DbEntry) {
        if (Is-MeaningfulValue $DbEntry.ability_type) { $Details += "Role: $($DbEntry.ability_type)" }
        if (Is-MeaningfulValue $DbEntry.ability_subtype) { $Details += "Subtype: $($DbEntry.ability_subtype)" }
        if (Is-MeaningfulValue $DbEntry.archetype_tags) { $Details += "Tags: $($DbEntry.archetype_tags -replace ',', ', ')" }
    }

    $SpellType = $null
    if ($Entry.DataMap -and $Entry.DataMap.ContainsKey('SpellType')) {
        $SpellType = $Entry.DataMap['SpellType']
    }
    elseif ($DbEntry -and $DbEntry.bg3_spell_type) {
        $SpellType = $DbEntry.bg3_spell_type
    }
    $IsPassive = $false
    if ($DbEntry -and $DbEntry.ability_type -and $DbEntry.ability_type -match 'Passive') { $IsPassive = $true }
    if (-not $IsPassive -and $DbEntry -and $DbEntry.bg3_spell_type -and $DbEntry.bg3_spell_type -match 'Passive') { $IsPassive = $true }
    if (-not $IsPassive -and $Entry.EntryType -and $Entry.EntryType -match 'Passive') { $IsPassive = $true }

    if ($IsPassive) { $SpellType = $null }

    if (Is-MeaningfulValue $SpellType) {
        $Details += "BG3 Spell Type: $SpellType"
    }

    $UseCostInfo = $null
    if ($Entry.DataMap -and $Entry.DataMap.ContainsKey('UseCosts')) {
        $UseCostInfo = Parse-UseCosts $Entry.DataMap['UseCosts']
    }
    elseif ($DbEntry -and (Is-MeaningfulValue $DbEntry.bg3_resource_cost) -and $DbEntry.bg3_resource_cost -match ':') {
        $UseCostInfo = Parse-UseCosts $DbEntry.bg3_resource_cost
    }

    if ($UseCostInfo) {
        if (-not $IsPassive -and (Is-MeaningfulValue $UseCostInfo.Action)) { $Details += "Action Cost: $($UseCostInfo.Action)" }
        if (Is-MeaningfulValue $UseCostInfo.Resources) { $Details += "Resources: $($UseCostInfo.Resources)" }
    }
    elseif (-not $IsPassive -and $DbEntry -and (Is-MeaningfulValue $DbEntry.bg3_action_cost)) {
        $Details += "Action Cost: $($DbEntry.bg3_action_cost)"
    }

    $Cooldown = $null
    if ($Entry.DataMap -and $Entry.DataMap.ContainsKey('Cooldown')) {
        $Cooldown = $Entry.DataMap['Cooldown']
    }
    elseif ($DbEntry -and (Is-MeaningfulValue $DbEntry.bg3_cooldown)) {
        $Cooldown = $DbEntry.bg3_cooldown
    }
    if (Is-MeaningfulValue $Cooldown) { $Details += "Cooldown: $Cooldown" }

    $Damage = $null
    if ($DbEntry -and (Is-MeaningfulValue $DbEntry.damage_formula_bg3)) {
        $Damage = $DbEntry.damage_formula_bg3
    }
    elseif ($Entry.DataMap -and $Entry.DataMap.ContainsKey('TooltipDamageList') -and (Is-MeaningfulValue $Entry.DataMap['TooltipDamageList'])) {
        $Damage = $Entry.DataMap['TooltipDamageList']
    }
    if (Is-MeaningfulValue $Damage) { $Details += "Damage Roll: $Damage" }

    $EffectsSource = $null
    if ($DbEntry -and $DbEntry.bg3_spell_success) {
        $EffectsSource = $DbEntry.bg3_spell_success
    }
    elseif ($Entry.DataMap -and $Entry.DataMap.ContainsKey('SpellSuccess')) {
        $EffectsSource = $Entry.DataMap['SpellSuccess']
    }
    if ($EffectsSource) {
        $FormattedEffects = Format-EffectsList $EffectsSource
        if (Is-MeaningfulValue $FormattedEffects) { $Details += "Effects: $FormattedEffects" }
    }

    if (-not $IsPassive) {
        $ConditionsSource = $null
        if ($DbEntry -and $DbEntry.bg3_target_conditions) {
            $ConditionsSource = $DbEntry.bg3_target_conditions
        }
        elseif ($Entry.DataMap -and $Entry.DataMap.ContainsKey('TargetConditions')) {
            $ConditionsSource = $Entry.DataMap['TargetConditions']
        }
        if ($ConditionsSource) {
            $FormattedConditions = Format-Conditions $ConditionsSource
            if (Is-MeaningfulValue $FormattedConditions) { $Details += "Target Requirements: $FormattedConditions" }
        }
    }

    if ($DbEntry -and (Is-MeaningfulValue $DbEntry.status_applied)) {
        $Details += "Statuses Applied: $($DbEntry.status_applied -replace ';', ', ')"
    }

    if ($DbEntry -and (Is-MeaningfulValue $DbEntry.implementation_notes)) {
        $Notes = $DbEntry.implementation_notes.Trim()
        if ($Notes) { $Details += "Notes: $Notes" }
    }

    if ($Details.Count -gt 0) {
        $Sections += ""
        $Sections += ($Details | ForEach-Object { "- $($_.Trim())" })
    }

    $Combined = ($Sections -join "`n")
    return (Sanitize-LocalizationText $Combined)
}

# ==========================================
# STEP 3: Populate DisplayName and Description
# ==========================================

Write-Host "`n[STEP 3] Populating names and descriptions..." -ForegroundColor Yellow

$PopulatedCount = 0
$MissingCount = 0

foreach ($Entry in $AllEntries) {
    # Try to find in database
    $CleanEntryName = $Entry.EntryName -replace '^(Target_|Zone_|Shout_|Jump_|Projectile_|WAR_)', 'WAR_'
    $DbEntry = $null
    
    if ($DbLookup.ContainsKey($CleanEntryName)) {
        $DbEntry = $DbLookup[$CleanEntryName]
    }
    elseif ($DbLookup.ContainsKey($Entry.EntryName)) {
        $DbEntry = $DbLookup[$Entry.EntryName]
    }

    if ($DbEntry) {
        if ($DbEntry.ability_name -and -not [string]::IsNullOrWhiteSpace($DbEntry.ability_name)) {
            $Entry.DisplayName = $DbEntry.ability_name.Trim()
        } else {
            $Entry.DisplayName = ($Entry.EntryName -replace '^WAR_', '' -replace '_', ' ').Trim()
        }

        $ResolvedDescription = Get-DescriptionText -Row $DbEntry
        if ($ResolvedDescription) {
            $Entry.Description = $ResolvedDescription
        } else {
            $Entry.Description = "$($Entry.DisplayName) - Warrior ability"
        }
        $PopulatedCount++
    }
    else {
        # Generate placeholder from entry name
        $Entry.DisplayName = ($Entry.EntryName -replace '^(Target_|Zone_|Shout_|Jump_|Projectile_)', '' -replace 'WAR_', '' -replace '_', ' ')
        $Entry.Description = "$($Entry.DisplayName) - Warrior ability"
        $MissingCount++
    }

    $Entry.DisplayName = Sanitize-LocalizationText $Entry.DisplayName
    $Entry.Description = Sanitize-LocalizationText $Entry.Description

    $BaseDescription = $Entry.Description
    $Entry.Description = Build-DetailedDescription -Entry $Entry -DbEntry $DbEntry -BaseDescription $BaseDescription
    $Entry.Description = Sanitize-LocalizationText $Entry.Description
}

Write-Host "[INFO] Populated from database: $PopulatedCount" -ForegroundColor Green
Write-Host "[WARN] Generated placeholders: $MissingCount" -ForegroundColor Yellow

# ==========================================
# STEP 4: Export to CSV for reference
# ==========================================

Write-Host "`n[STEP 4] Exporting to CSV..." -ForegroundColor Yellow

$ExportEntries = $AllEntries | Select-Object EntryName, FileType, HandleName, HandleDesc, DisplayName, Description
$ExportEntries | Export-Csv -Path $OutputCsvPath -NoTypeInformation -Encoding UTF8
Write-Host "[INFO] CSV exported: $OutputCsvPath" -ForegroundColor Cyan

# ==========================================
# STEP 5: Generate english.xml content
# ==========================================

Write-Host "`n[STEP 5] Generating english.xml content..." -ForegroundColor Yellow

$XmlContent = @"
<?xml version="1.0" encoding="utf-8"?>
<contentList>
    
    <!-- ========================================
         WARRIOR MOD LOCALIZATION
         Generated: $(Get-Date -Format "MMMM dd, yyyy")
         Total Entries: $($AllEntries.Count)
         Total Handles: $($Counter - 1)
         ========================================
    -->
    
    <!-- ========================================
         CLASS AND SUBCLASS DESCRIPTIONS
         ========================================
    -->
    
    <!-- Warrior Base Class -->
    <content contentuid="h2192a15fgd3c6g47c8g8f2ag887078521591" version="1">Warrior</content>
    <content contentuid="hec9f49b2g20fbg427bgb437gfd4041ffd5ec" version="1">Masters of martial combat who harness Rage to fuel devastating abilities. Warriors excel with both massive two-handed weapons and sword-and-board tactics, adapting to any battle.</content>
    
    <!-- Arms Warrior Subclass -->
    <content contentuid="h0ae71f9cgcb9ag4eb9g8bedgdc08c872bccc" version="1">Arms Warrior</content>
    <content contentuid="h5300bf31g2077g4482g80dfg06112305b4d5" version="1">A master of two-handed weapons who delivers crushing blows and mortal strikes. Arms Warriors specialize in controlled, powerful attacks that tear through armor and leave enemies bleeding.</content>
    
    <!-- Fury Warrior Subclass -->
    <content contentuid="h8d2875a5g4c2ag482fg9158g98f8d100d978" version="1">Fury Warrior</content>
    <content contentuid="h151545dbg38fdg42d8gbfe8g784683acd258" version="1">A relentless berserker who dual-wields weapons with reckless abandon. Fury Warriors thrive in extended combat, building rage through a flurry of strikes and entering an enraged state of unstoppable fury.</content>
    
    <!-- Protection Warrior Subclass -->
    <content contentuid="hc4f8321dgffefg447fgb8fagd3f964cc05d8" version="1">Protection Warrior</content>
    <content contentuid="hd276f0e5g1198g4d05g9a64ga3a38e97aea2" version="1">An indomitable defender who uses shield and heavy armor to protect allies. Protection Warriors generate rage through absorbing and blocking attacks, becoming an immovable wall between their party and danger.</content>
    
    <!-- ========================================
         RAGE RESOURCE
         ========================================
    -->
    
    <content contentuid="hdffb5cfegff1fg4209gb239ga15ec5d929ee" version="1">Rage</content>
    <content contentuid="h2483ce0dg3709g4983g8aacg8dde1c406c97" version="1">The warrior's burning fury, fueling their most powerful abilities. Maximum 100 Rage.</content>
    
    <!-- ========================================
         STAT FILE ABILITIES ($($AllEntries.Count) entries)
         ========================================
    -->
    
"@

# Group by file type for organization
$GroupedEntries = $AllEntries | Group-Object -Property FileType

foreach ($Group in $GroupedEntries) {
    $XmlContent += "    <!-- ======================================== `n"
    $XmlContent += "         $($Group.Name.ToUpper()) ($($Group.Count) entries)`n"
    $XmlContent += "         ======================================== `n"
    $XmlContent += "    -->`n`n"
    
    foreach ($Entry in $Group.Group) {
        # Escape XML special characters
        $SafeDisplayName = [System.Security.SecurityElement]::Escape($Entry.DisplayName)
        $SafeDescription = [System.Security.SecurityElement]::Escape($Entry.Description)
        
        $XmlContent += "    <!-- $($Entry.EntryName) -->`n"
        $XmlContent += "    <content contentuid=`"$($Entry.HandleName)`" version=`"1`">$SafeDisplayName</content>`n"
        $XmlContent += "    <content contentuid=`"$($Entry.HandleDesc)`" version=`"1`">$SafeDescription</content>`n`n"
    }
}

$XmlContent += "</contentList>`n"

# ==========================================
# STEP 6: Write english.xml (or dry run)
# ==========================================

Write-Host "`n[STEP 6] Writing english.xml..." -ForegroundColor Yellow

if ($DryRun) {
    Write-Host "[DRY RUN] Would write to: $LocalizationPath" -ForegroundColor Yellow
    Write-Host "[DRY RUN] Preview (first 50 lines):" -ForegroundColor Yellow
    $XmlContent -split "`n" | Select-Object -First 50 | ForEach-Object { Write-Host $_ -ForegroundColor Gray }
} else {
    # Backup existing file
    if (Test-Path $LocalizationPath) {
        $BackupPath = $LocalizationPath -replace '\.xml$', "_BACKUP_$(Get-Date -Format 'yyyyMMdd_HHmmss').xml"
        Copy-Item $LocalizationPath $BackupPath
        Write-Host "[INFO] Backup created: $BackupPath" -ForegroundColor Cyan
    }
    
    # Write new file
    $XmlContent | Out-File -FilePath $LocalizationPath -Encoding UTF8 -NoNewline
    Write-Host "[SUCCESS] english.xml written: $LocalizationPath" -ForegroundColor Green
    Write-Host "[INFO] Total handles written: $($Counter - 1)" -ForegroundColor Cyan
}

# ==========================================
# STEP 7: Summary
# ==========================================

Write-Host "`n[SUMMARY]" -ForegroundColor Yellow
Write-Host "Total entries: $($AllEntries.Count)" -ForegroundColor White
Write-Host "Total handles: $($Counter - 1)" -ForegroundColor White
Write-Host "Populated from database: $PopulatedCount" -ForegroundColor Green
Write-Host "Generated placeholders: $MissingCount" -ForegroundColor Yellow
Write-Host "`nCSV export: $OutputCsvPath" -ForegroundColor Cyan
Write-Host "Localization file: $LocalizationPath" -ForegroundColor Cyan

Write-Host "`n=====================================================================" -ForegroundColor Cyan

if ($DryRun) {
    Write-Host "[DRY RUN COMPLETE] Run without -DryRun to apply changes" -ForegroundColor Yellow
} else {
    Write-Host "[SUCCESS] Localization generation complete!" -ForegroundColor Green
    Write-Host "[NEXT] Run Update_StatFiles_With_Handles.ps1 to update stat files" -ForegroundColor Yellow
}
