# Fix Classification Algorithm - Properly detect Class/Spec/Hero talents
# Date: October 20, 2025

param(
    [Parameter(Mandatory=$false)]
    [string]$InputFile = "Documentation\00_SourcesOfTruth\AbilityDatabase_Warrior.csv",
    [Parameter(Mandatory=$false)]
    [string]$SourceFile = "Documentation\00_SourcesOfTruth\Warrior Progression for all subclasses.csv",
    [Parameter(Mandatory=$false)]
    [string]$OutputFile = "Documentation\00_SourcesOfTruth\AbilityDatabase_Warrior_Reclassified.csv"
)

Write-Host "[INFO] Starting classification fix..." -ForegroundColor Cyan
Write-Host "[INFO] Current database: $InputFile" -ForegroundColor Cyan
Write-Host "[INFO] Source data: $SourceFile" -ForegroundColor Cyan

# Import both files
$db = Import-Csv $InputFile -Encoding UTF8
$source = Import-Csv $SourceFile -Encoding UTF8 -WarningAction SilentlyContinue

Write-Host "[INFO] Loaded $($db.Count) abilities from database" -ForegroundColor Cyan
Write-Host "[INFO] Loaded $($source.Count) rows from source" -ForegroundColor Cyan

# Build a mapping of ability names to their correct classification
$abilityClassification = @{}

foreach ($row in $source) {
    # Skip rows without level data
    if ([string]::IsNullOrWhiteSpace($row.Level) -or $row.Level -notmatch '^\d+$') {
        continue
    }
    
    $level = $row.Level
    
    # Process all properties in the row
    foreach ($prop in $row.PSObject.Properties) {
        $colName = $prop.Name
        $value = $prop.Value
        
        # Skip if empty or just whitespace
        if ([string]::IsNullOrWhiteSpace($value)) {
            continue
        }
        
        # Skip the Level column itself
        if ($colName -eq 'Level') {
            continue
        }
        
        # Extract ability name from value (remove descriptions)
        # Pattern 1: "Name (Abbrev) - description"
        if ($value -match '^(.+?)\s*\(([^)]+)\)\s*-\s*(.+)$') {
            $abilityName = $matches[1].Trim() -replace [char]0xFFFD, '' -replace [char]0x201C, '' -replace [char]0x201D, ''
        }
        # Pattern 2: "Name - description"
        elseif ($value -match '^(.+?)\s*-\s*(.+)$') {
            $abilityName = $matches[1].Trim() -replace [char]0xFFFD, '' -replace [char]0x201C, '' -replace [char]0x201D, ''
        }
        else {
            $abilityName = $value.Trim() -replace [char]0xFFFD, '' -replace [char]0x201C, '' -replace [char]0x201D, ''
        }
        
        # Skip if name is too short or numeric
        if ($abilityName.Length -le 1 -or $abilityName -match '^\d+$') {
            continue
        }
        
        # Determine classification based on column name patterns
        $unlockSource = "Baseline"
        $subclassFilter = "All"
        
        # Class Talents
        if ($colName -like "*Warrior Class Talents*") {
            $unlockSource = "Class Talent"
            $subclassFilter = "All"
        }
        # Arms Spec Talents
        elseif ($colName -like "*Arms Spec Talents*") {
            $unlockSource = "Spec Talent"
            $subclassFilter = "Arms"
        }
        # Fury Spec Talents
        elseif ($colName -like "*Fury Spec Talents*") {
            $unlockSource = "Spec Talent"
            $subclassFilter = "Fury"
        }
        # Protection Spec Talents
        elseif ($colName -like "*Protection*Spec Talents*") {
            $unlockSource = "Spec Talent"
            $subclassFilter = "Protection"
        }
        # Mountain Thane (Protection, Fury)
        elseif ($colName -like "*Mountain Thane*") {
            $unlockSource = "Hero Talent"
            $subclassFilter = "Protection,Fury"
        }
        # Colossus (Arms, Protection)
        elseif ($colName -like "*Colossus*") {
            $unlockSource = "Hero Talent"
            $subclassFilter = "Arms,Protection"
        }
        # Slayers (Arms, Fury)
        elseif ($colName -like "*Slayers*") {
            $unlockSource = "Hero Talent"
            $subclassFilter = "Arms,Fury"
        }
        # Baseline Arms
        elseif ($colName -like "*Baseline Arms*") {
            $unlockSource = "Baseline"
            $subclassFilter = "Arms"
        }
        # Baseline Protection
        elseif ($colName -like "*Baseline Protection*") {
            $unlockSource = "Baseline"
            $subclassFilter = "Protection"
        }
        # Baseline Fury
        elseif ($colName -like "*Baseline Fury*") {
            $unlockSource = "Baseline"
            $subclassFilter = "Fury"
        }
        
        # Store classification
        $abilityClassification[$abilityName] = @{
            unlock_source = $unlockSource
            subclass_filter = $subclassFilter
            unlock_level = $level
        }
    }
}

Write-Host "[INFO] Built classification map for $($abilityClassification.Count) unique abilities" -ForegroundColor Cyan

# Update database with correct classifications
$fixedCount = 0
$notFoundCount = 0

foreach ($ability in $db) {
    $cleanName = $ability.ability_name.Trim()
    
    if ($abilityClassification.ContainsKey($cleanName)) {
        $classification = $abilityClassification[$cleanName]
        
        # Update if different
        if ($ability.unlock_source -ne $classification.unlock_source -or 
            $ability.subclass_filter -ne $classification.subclass_filter) {
            
            Write-Host "[FIX] $cleanName : $($ability.unlock_source)/$($ability.subclass_filter) -> $($classification.unlock_source)/$($classification.subclass_filter)" -ForegroundColor Yellow
            
            $ability.unlock_source = $classification.unlock_source
            $ability.subclass_filter = $classification.subclass_filter
            $ability.unlock_level = $classification.unlock_level
            
            $fixedCount++
        }
    }
    else {
        Write-Host "[WARN] No classification found for: $cleanName" -ForegroundColor Magenta
        $notFoundCount++
    }
}

Write-Host "" -ForegroundColor White
Write-Host "[DONE] Classification fix complete!" -ForegroundColor Green
Write-Host "[INFO] Abilities reclassified: $fixedCount" -ForegroundColor Cyan
Write-Host "[WARN] Abilities not found in source: $notFoundCount" -ForegroundColor Yellow

# Show new statistics
Write-Host "" -ForegroundColor White
Write-Host "[INFO] New classification breakdown:" -ForegroundColor Cyan
$db | Group-Object unlock_source | Sort-Object Count -Descending | ForEach-Object {
    Write-Host "  $($_.Name): $($_.Count) abilities" -ForegroundColor White
}

Write-Host "" -ForegroundColor White
Write-Host "[INFO] New subclass breakdown:" -ForegroundColor Cyan
$db | Group-Object subclass_filter | Sort-Object Count -Descending | ForEach-Object {
    Write-Host "  $($_.Name): $($_.Count) abilities" -ForegroundColor White
}

# Export reclassified database
$db | Export-Csv $OutputFile -NoTypeInformation -Encoding UTF8

Write-Host "" -ForegroundColor White
Write-Host "[INFO] Output: $OutputFile" -ForegroundColor Cyan
Write-Host "[DONE] Reclassification complete!" -ForegroundColor Green
