# Clean up Ability Database - Remove junk entries and fix encoding
# Date: October 20, 2025

param(
    [Parameter(Mandatory=$false)]
    [string]$InputFile = "Documentation\00_SourcesOfTruth\AbilityDatabase_Warrior.csv",
    [Parameter(Mandatory=$false)]
    [string]$OutputFile = "Documentation\00_SourcesOfTruth\AbilityDatabase_Warrior_Cleaned.csv"
)

Write-Host "[INFO] Starting database cleanup..." -ForegroundColor Cyan
Write-Host "[INFO] Input: $InputFile" -ForegroundColor Cyan

# Import the database
$db = Import-Csv $InputFile -Encoding UTF8

Write-Host "[INFO] Loaded $($db.Count) abilities" -ForegroundColor Cyan

# Track statistics
$removedJunk = 0
$fixedEncoding = 0
$keptAbilities = 0

# Clean up abilities
$cleanedDb = $db | ForEach-Object {
    $ability = $_
    
    # Skip junk entries:
    # 1. ability_name is just a number (WAR_1, WAR_2, etc.)
    # 2. ability_name is "Add Feat"
    # 3. ability_name is empty
    # 4. ability_name matches level numbers (4, 5, 6, etc.)
    
    $isJunk = $false
    
    # Check if ability_name is just digits
    if ($ability.ability_name -match '^\d+$') {
        Write-Host "[REMOVE] Junk entry: ability_name='$($ability.ability_name)' (digits only)" -ForegroundColor Yellow
        $isJunk = $true
        $removedJunk++
    }
    # Check if ability_name contains "Add Feat"
    elseif ($ability.ability_name -like "*Add Feat*") {
        Write-Host "[REMOVE] Junk entry: ability_name='$($ability.ability_name)' (Add Feat)" -ForegroundColor Yellow
        $isJunk = $true
        $removedJunk++
    }
    # Check if ability_name is empty or just whitespace
    elseif ([string]::IsNullOrWhiteSpace($ability.ability_name)) {
        Write-Host "[REMOVE] Junk entry: ability_name is empty, ability_id='$($ability.ability_id)'" -ForegroundColor Yellow
        $isJunk = $true
        $removedJunk++
    }
    # Check if ability_id matches WAR_\d+ pattern (WAR_1, WAR_2, etc.)
    elseif ($ability.ability_id -match '^WAR_\d+$') {
        Write-Host "[REMOVE] Junk entry: ability_id='$($ability.ability_id)' (WAR_digits only)" -ForegroundColor Yellow
        $isJunk = $true
        $removedJunk++
    }
    
    # Skip if junk
    if ($isJunk) {
        return
    }
    
    # Fix encoding - remove � characters and other special Unicode characters from all string fields
    $needsEncodingFix = $false
    
    foreach ($prop in $ability.PSObject.Properties) {
        if ($prop.Value -is [string]) {
            $originalValue = $prop.Value
            # Remove the � character (U+FFFD - replacement character)
            # Also remove any other common encoding artifacts
            $prop.Value = $prop.Value -replace [char]0xFFFD, ''
            $prop.Value = $prop.Value -replace [char]0x201C, ''  # Left double quotation mark
            $prop.Value = $prop.Value -replace [char]0x201D, ''  # Right double quotation mark
            $prop.Value = $prop.Value -replace [char]0x2018, ''  # Left single quotation mark
            $prop.Value = $prop.Value -replace [char]0x2019, ''  # Right single quotation mark
            
            if ($originalValue -ne $prop.Value) {
                $needsEncodingFix = $true
            }
        }
    }
    
    if ($needsEncodingFix) {
        $fixedEncoding++
    }
    
    $keptAbilities++
    
    # Return cleaned ability
    $ability
}

Write-Host "" -ForegroundColor White
Write-Host "[DONE] Cleanup complete!" -ForegroundColor Green
Write-Host "[INFO] Abilities kept: $keptAbilities" -ForegroundColor Cyan
Write-Host "[INFO] Junk entries removed: $removedJunk" -ForegroundColor Yellow
Write-Host "[INFO] Abilities with encoding fixed: $fixedEncoding" -ForegroundColor Yellow

# Export cleaned database
$cleanedDb | Export-Csv $OutputFile -NoTypeInformation -Encoding UTF8

Write-Host "[INFO] Output: $OutputFile" -ForegroundColor Cyan
Write-Host "[INFO] New file size: $($cleanedDb.Count) abilities" -ForegroundColor Cyan

# Show sample of cleaned data
Write-Host "" -ForegroundColor White
Write-Host "[INFO] Sample of cleaned abilities:" -ForegroundColor Cyan
$cleanedDb | Select-Object -First 5 | ForEach-Object {
    Write-Host "  - $($_.ability_name) ($($_.ability_abbreviation)) - L$($_.unlock_level) $($_.unlock_source)" -ForegroundColor White
}

Write-Host "" -ForegroundColor White
Write-Host "[DONE] Cleanup script finished successfully!" -ForegroundColor Green
Write-Host "[INFO] Review the cleaned file and then replace the original if satisfied." -ForegroundColor Cyan
