# POPULATE_UNLOCK_LEVELS.ps1
# Populates warrior_unlock, arms_unlock, fury_unlock, protection_unlock columns in AbilityDatabase
# from Warrior Progression CSV

param(
    [string]$ProgressionCSV = "Documentation\00_SourcesOfTruth\Warrior Progression for all subclasses and Default hero structure.csv",
    [string]$DatabasePath = "Documentation\00_SourcesOfTruth\AbilityDatabase_Warrior_FullyEnriched.csv",
    [string]$OutputPath = "Documentation\00_SourcesOfTruth\AbilityDatabase_Warrior_FullyEnriched.csv"
)

Write-Host "`n=== POPULATING UNLOCK LEVELS FROM PROGRESSION CSV ===" -ForegroundColor Magenta
Write-Host "Date: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')`n" -ForegroundColor Cyan

# Import database
Write-Host "Loading database..." -ForegroundColor Yellow
$db = Import-Csv $DatabasePath

# Import progression CSV
Write-Host "Loading progression CSV..." -ForegroundColor Yellow
$progression = Import-Csv $ProgressionCSV

# Create ability name to unlock level mapping
$abilityUnlocks = @{}

Write-Host "`nParsing progression data..." -ForegroundColor Yellow

foreach ($row in $progression) {
    $level = $row.Level
    
    # Skip header rows and invalid levels
    if ([string]::IsNullOrWhiteSpace($level) -or $level -eq "Level" -or -not ($level -match '^\d+$')) {
        continue
    }
    
    $levelNum = [int]$level
    
    # Parse Arms abilities (columns: "Offensive Abilities (Auto Grant)", "Utility Abilities (Auto Grant)")
    # These are in columns with index based on header structure
    $armsOffensive = $row.'Offensive Abilities (Auto Grant)'
    $armsUtility = $row.'Utility Abilities (Auto Grant)'
    
    # Parse Protection abilities (next set of columns)
    $protOffensive = $row.PSObject.Properties | Where-Object { $_.Name -like "*Offensive Abilities (Auto Grant)*" } | Select-Object -Skip 1 -First 1
    $protUtility = $row.PSObject.Properties | Where-Object { $_.Name -like "*Utility Abilities (Auto Grant)*" } | Select-Object -Skip 1 -First 1
    $protPassive = $row.PSObject.Properties | Where-Object { $_.Name -like "*Passives (Auto Grant)*" } | Select-Object -First 1
    
    # Parse Fury abilities (third set)
    $furyOffensive = $row.PSObject.Properties | Where-Object { $_.Name -like "*Offensive Abilities (Auto Grant)*" } | Select-Object -Skip 2 -First 1
    $furyUtility = $row.PSObject.Properties | Where-Object { $_.Name -like "*Utility Abilities (Auto Grant)*" } | Select-Object -Skip 2 -First 1
    
    # Parse Class Talents (Stance column)
    $stance1 = $row.Stance
    $stance2 = $row.PSObject.Properties | Where-Object { $_.Name -eq "Stance" } | Select-Object -Skip 1 -First 1
    
    # Parse Spec Talents
    $armsPassive = $row.'Passive'
    $armsAbility = $row.'Arms Ability'
    
    $furyPassive = $row.PSObject.Properties | Where-Object { $_.Name -eq "Passive" } | Select-Object -Skip 1 -First 1
    $furyAbility = $row.'Fury Ability'
    
    $protAbility = $row.'Protection Ability'
    
    # Parse Hero Talents
    $mountainThane = @(
        $row.'Mountain Thane Talents',
        $row.PSObject.Properties | Where-Object { $_.Name -like "Mountain Thane Talents*" } | Select-Object -Skip 1 -First 2 | ForEach-Object { $_.Value }
    ) | Where-Object { $_ }
    
    $colossus = @(
        $row.'Colossus Talents',
        $row.PSObject.Properties | Where-Object { $_.Name -like "Colossus Talents*" } | Select-Object -Skip 1 -First 2 | ForEach-Object { $_.Value }
    ) | Where-Object { $_ }
    
    $slayer = @(
        $row.'Slayers Talents',
        $row.PSObject.Properties | Where-Object { $_.Name -like "Slayers Talents*" } | Select-Object -Skip 1 -First 2 | ForEach-Object { $_.Value }
    ) | Where-Object { $_ }
    
    # Function to extract ability name from description
    function Extract-AbilityName {
        param([string]$text)
        
        if ([string]::IsNullOrWhiteSpace($text)) { return $null }
        
        # Remove leading/trailing symbols
        $text = $text.Trim().TrimStart('�', '�', ' ').TrimEnd(' ', '.')
        
        # Check for ability format: "Ability Name (Abbr) - description" or just "Ability Name - description"
        if ($text -match '^([^(�]+?)(\s*\([^)]+\))?\s*[-�]') {
            return $matches[1].Trim()
        }
        
        # Check for simple format: "Ability Name"
        if ($text -match '^([A-Za-z\s:'']+)') {
            return $matches[1].Trim()
        }
        
        return $null
    }
    
    # Process all abilities for this level
    $allAbilities = @()
    
    # Arms baseline
    if ($armsOffensive) { 
        $name = Extract-AbilityName $armsOffensive
        if ($name) { $allAbilities += @{ Name = $name; Arms = $levelNum; Prot = $null; Fury = $null; Warrior = $levelNum } }
    }
    if ($armsUtility) { 
        $name = Extract-AbilityName $armsUtility
        if ($name) { $allAbilities += @{ Name = $name; Arms = $levelNum; Prot = $null; Fury = $null; Warrior = $levelNum } }
    }
    
    # Protection baseline
    if ($protOffensive -and $protOffensive.Value) { 
        $name = Extract-AbilityName $protOffensive.Value
        if ($name) { 
            # Check if already added by Arms (baseline shared)
            $existing = $allAbilities | Where-Object { $_.Name -eq $name }
            if ($existing) {
                $existing.Prot = $levelNum
            } else {
                $allAbilities += @{ Name = $name; Arms = $null; Prot = $levelNum; Fury = $null; Warrior = $levelNum }
            }
        }
    }
    if ($protUtility -and $protUtility.Value) { 
        $name = Extract-AbilityName $protUtility.Value
        if ($name) { 
            $existing = $allAbilities | Where-Object { $_.Name -eq $name }
            if ($existing) {
                $existing.Prot = $levelNum
            } else {
                $allAbilities += @{ Name = $name; Arms = $null; Prot = $levelNum; Fury = $null; Warrior = $levelNum }
            }
        }
    }
    if ($protPassive -and $protPassive.Value) { 
        $name = Extract-AbilityName $protPassive.Value
        if ($name) { 
            $existing = $allAbilities | Where-Object { $_.Name -eq $name }
            if ($existing) {
                $existing.Prot = $levelNum
            } else {
                $allAbilities += @{ Name = $name; Arms = $null; Prot = $levelNum; Fury = $null; Warrior = $levelNum }
            }
        }
    }
    
    # Fury baseline
    if ($furyOffensive -and $furyOffensive.Value) { 
        $name = Extract-AbilityName $furyOffensive.Value
        if ($name) { 
            $existing = $allAbilities | Where-Object { $_.Name -eq $name }
            if ($existing) {
                $existing.Fury = $levelNum
            } else {
                $allAbilities += @{ Name = $name; Arms = $null; Prot = $null; Fury = $levelNum; Warrior = $levelNum }
            }
        }
    }
    if ($furyUtility -and $furyUtility.Value) { 
        $name = Extract-AbilityName $furyUtility.Value
        if ($name) { 
            $existing = $allAbilities | Where-Object { $_.Name -eq $name }
            if ($existing) {
                $existing.Fury = $levelNum
            } else {
                $allAbilities += @{ Name = $name; Arms = $null; Prot = $null; Fury = $levelNum; Warrior = $levelNum }
            }
        }
    }
    
    # Class talents (stances, etc.)
    if ($stance1) {
        $name = Extract-AbilityName $stance1
        if ($name) { $allAbilities += @{ Name = $name; Arms = $levelNum; Prot = $levelNum; Fury = $levelNum; Warrior = $levelNum } }
    }
    if ($stance2 -and $stance2.Value) {
        $name = Extract-AbilityName $stance2.Value
        if ($name) { $allAbilities += @{ Name = $name; Arms = $levelNum; Prot = $levelNum; Fury = $levelNum; Warrior = $levelNum } }
    }
    
    # Spec talents
    if ($armsPassive) {
        $name = Extract-AbilityName $armsPassive
        if ($name) { $allAbilities += @{ Name = $name; Arms = $levelNum; Prot = $null; Fury = $null; Warrior = $null } }
    }
    if ($armsAbility) {
        $name = Extract-AbilityName $armsAbility
        if ($name) { $allAbilities += @{ Name = $name; Arms = $levelNum; Prot = $null; Fury = $null; Warrior = $null } }
    }
    if ($furyPassive -and $furyPassive.Value) {
        $name = Extract-AbilityName $furyPassive.Value
        if ($name) { $allAbilities += @{ Name = $name; Arms = $null; Prot = $null; Fury = $levelNum; Warrior = $null } }
    }
    if ($furyAbility) {
        $name = Extract-AbilityName $furyAbility
        if ($name) { $allAbilities += @{ Name = $name; Arms = $null; Prot = $null; Fury = $levelNum; Warrior = $null } }
    }
    if ($protAbility) {
        $name = Extract-AbilityName $protAbility
        if ($name) { $allAbilities += @{ Name = $name; Arms = $null; Prot = $levelNum; Fury = $null; Warrior = $null } }
    }
    
    # Hero talents
    foreach ($talent in $mountainThane) {
        $name = Extract-AbilityName $talent
        if ($name) { 
            $allAbilities += @{ Name = $name; Arms = $null; Prot = $levelNum; Fury = $levelNum; Warrior = $null }
        }
    }
    foreach ($talent in $colossus) {
        $name = Extract-AbilityName $talent
        if ($name) { 
            $allAbilities += @{ Name = $name; Arms = $levelNum; Prot = $levelNum; Fury = $null; Warrior = $null }
        }
    }
    foreach ($talent in $slayer) {
        $name = Extract-AbilityName $talent
        if ($name) { 
            $allAbilities += @{ Name = $name; Arms = $levelNum; Prot = $null; Fury = $levelNum; Warrior = $null }
        }
    }
    
    # Store all abilities with their unlock levels
    foreach ($ability in $allAbilities) {
        $key = $ability.Name.ToLower().Trim()
        
        if (-not $abilityUnlocks.ContainsKey($key)) {
            $abilityUnlocks[$key] = @{
                Name = $ability.Name
                Warrior = $ability.Warrior
                Arms = $ability.Arms
                Fury = $ability.Fury
                Protection = $ability.Prot
            }
        } else {
            # Merge with existing entry (take earliest level for each spec)
            if ($ability.Warrior -and (-not $abilityUnlocks[$key].Warrior -or $ability.Warrior -lt $abilityUnlocks[$key].Warrior)) {
                $abilityUnlocks[$key].Warrior = $ability.Warrior
            }
            if ($ability.Arms -and (-not $abilityUnlocks[$key].Arms -or $ability.Arms -lt $abilityUnlocks[$key].Arms)) {
                $abilityUnlocks[$key].Arms = $ability.Arms
            }
            if ($ability.Fury -and (-not $abilityUnlocks[$key].Fury -or $ability.Fury -lt $abilityUnlocks[$key].Fury)) {
                $abilityUnlocks[$key].Fury = $ability.Fury
            }
            if ($ability.Prot -and (-not $abilityUnlocks[$key].Protection -or $ability.Prot -lt $abilityUnlocks[$key].Protection)) {
                $abilityUnlocks[$key].Protection = $ability.Prot
            }
        }
    }
}

Write-Host "Found $($abilityUnlocks.Count) unique abilities in progression CSV" -ForegroundColor Green

# Update database with unlock levels
Write-Host "`nUpdating database..." -ForegroundColor Yellow
$updateCount = 0
$notFoundCount = 0
$notFoundAbilities = @()

foreach ($row in $db) {
    $abilityName = $row.ability_name
    $key = $abilityName.ToLower().Trim()
    
    if ($abilityUnlocks.ContainsKey($key)) {
        $unlock = $abilityUnlocks[$key]
        
        # Update unlock columns
        $row.warrior_unlock = if ($unlock.Warrior) { $unlock.Warrior } else { "" }
        $row.arms_unlock = if ($unlock.Arms) { $unlock.Arms } else { "" }
        $row.fury_unlock = if ($unlock.Fury) { $unlock.Fury } else { "" }
        $row.protection_unlock = if ($unlock.Protection) { $unlock.Protection } else { "" }
        
        $updateCount++
        Write-Host "  ✅ Updated: $abilityName" -ForegroundColor Green
    } else {
        # Try fuzzy matching
        $fuzzyMatch = $abilityUnlocks.Keys | Where-Object { 
            $_ -like "*$($abilityName.ToLower())*" -or $abilityName.ToLower() -like "*$_*"
        } | Select-Object -First 1
        
        if ($fuzzyMatch) {
            $unlock = $abilityUnlocks[$fuzzyMatch]
            $row.warrior_unlock = if ($unlock.Warrior) { $unlock.Warrior } else { "" }
            $row.arms_unlock = if ($unlock.Arms) { $unlock.Arms } else { "" }
            $row.fury_unlock = if ($unlock.Fury) { $unlock.Fury } else { "" }
            $row.protection_unlock = if ($unlock.Protection) { $unlock.Protection } else { "" }
            
            $updateCount++
            Write-Host "  ✅ Fuzzy matched: $abilityName → $($abilityUnlocks[$fuzzyMatch].Name)" -ForegroundColor Cyan
        } else {
            $notFoundCount++
            $notFoundAbilities += $abilityName
            Write-Host "  ⚠️ Not found in CSV: $abilityName" -ForegroundColor Yellow
        }
    }
}

# Export updated database
Write-Host "`nExporting updated database..." -ForegroundColor Yellow
$db | Export-Csv -Path $OutputPath -NoTypeInformation -Encoding UTF8

Write-Host "`n=== SUMMARY ===" -ForegroundColor Magenta
Write-Host "Total abilities in database: $($db.Count)" -ForegroundColor Cyan
Write-Host "Updated with unlock levels: $updateCount" -ForegroundColor Green
Write-Host "Not found in progression CSV: $notFoundCount" -ForegroundColor Yellow

if ($notFoundAbilities.Count -gt 0) {
    Write-Host "`nAbilities not found (may be talent choices, not baseline):" -ForegroundColor Yellow
    $notFoundAbilities | ForEach-Object { Write-Host "  - $_" -ForegroundColor Gray }
}

Write-Host "`n✅ Database updated: $OutputPath" -ForegroundColor Green
Write-Host "Populate unlock levels complete!`n" -ForegroundColor Magenta

exit 0
