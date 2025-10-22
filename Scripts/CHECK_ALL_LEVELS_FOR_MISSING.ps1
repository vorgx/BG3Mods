# CHECK_ALL_LEVELS_FOR_MISSING.ps1
# Systematically check all 20 levels for missing warrior class talents
# that should have warrior_unlock populated
#
# Date: October 22, 2025

param(
    [string]$ProgressionCsv = "C:\Users\tenod\source\repos\BG3Mods\Documentation\00_SourcesOfTruth\Warrior Progression for all subclasses and Default hero structure.csv",
    [string]$DatabaseCsv = "C:\Users\tenod\source\repos\BG3Mods\Documentation\00_SourcesOfTruth\AbilityDatabase_Warrior_FullyEnriched.csv"
)

Write-Host "`n=== SCANNING ALL 20 LEVELS FOR MISSING WARRIOR CLASS TALENTS ===" -ForegroundColor Cyan
Write-Host "Warrior Class Talents should populate warrior_unlock (all specs get them)`n" -ForegroundColor Gray

# Load database
$Database = Import-Csv $DatabaseCsv

# Parse CSV with proper handling
Add-Type -AssemblyName Microsoft.VisualBasic
$parser = New-Object Microsoft.VisualBasic.FileIO.TextFieldParser($ProgressionCsv)
$parser.TextFieldType = [Microsoft.VisualBasic.FileIO.FieldType]::Delimited
$parser.SetDelimiters(",")
$parser.HasFieldsEnclosedInQuotes = $true

# Read headers
$headers = $parser.ReadFields()

# Find Warrior Class Talents column range (Column 10 and surrounding empty headers belong to it)
$warriorClassStartCol = -1
$warriorClassEndCol = -1

for ($i = 0; $i -lt $headers.Count; $i++) {
    if ($headers[$i] -match 'Warrior Class Talents.*All subclasses') {
        $warriorClassStartCol = $i
        # Find end of this section (next non-empty header)
        for ($j = $i + 1; $j -lt $headers.Count; $j++) {
            if (-not [string]::IsNullOrWhiteSpace($headers[$j])) {
                $warriorClassEndCol = $j - 1
                break
            }
        }
        break
    }
}

Write-Host "[INFO] Warrior Class Talents span columns $warriorClassStartCol to $warriorClassEndCol" -ForegroundColor Cyan
Write-Host "[INFO] Will scan these columns for talents at each level`n" -ForegroundColor Cyan

# Skip subheader rows
$parser.ReadFields() | Out-Null
$parser.ReadFields() | Out-Null

# Function to extract ability name
function Extract-AbilityName {
    param([string]$CellValue)
    
    if ([string]::IsNullOrWhiteSpace($CellValue)) {
        return $null
    }
    
    $clean = $CellValue -replace '^[\s·"]+', ''
    
    # Pattern 1: Name (Abbr) - description
    if ($clean -match '^([^(]+?)\s*\([^)]+\)\s*-') {
        return $matches[1].Trim()
    }
    # Pattern 2: Name - description
    elseif ($clean -match '^([^-]+?)\s*-' -and $clean -notmatch '^(Auto Grant|AutoGrant|Offensive|Defensive|Utility|Stance|Passive|Pick one|Choose one|Row \d+)') {
        return $matches[1].Trim()
    }
    # Pattern 3: Just Name (Abbr)
    elseif ($clean -match '^([^(]+?)\s*\([^)]+\)$') {
        return $matches[1].Trim()
    }
    
    return $null
}

# Scan each level
$level = 1
$missingAbilities = @()
$foundAbilities = @()

while (-not $parser.EndOfData -and $level -le 20) {
    $fields = $parser.ReadFields()
    
    Write-Host "--- Level $level ---" -ForegroundColor Yellow
    
    # Check Warrior Class Talents columns
    for ($colIdx = $warriorClassStartCol; $colIdx -le $warriorClassEndCol; $colIdx++) {
        if ($colIdx -ge $fields.Count) {
            continue
        }
        
        $cellValue = $fields[$colIdx]
        $abilityName = Extract-AbilityName -CellValue $cellValue
        
        if (-not $abilityName -or $abilityName.Length -lt 3) {
            continue
        }
        
        # Find in database
        $dbAbility = $Database | Where-Object { $_.ability_name -eq $abilityName }
        
        if (-not $dbAbility) {
            Write-Host "  [NOT IN DB] '$abilityName'" -ForegroundColor Red
            $missingAbilities += [PSCustomObject]@{
                Level = $level
                AbilityName = $abilityName
                Reason = "Not found in database"
            }
            continue
        }
        
        # Check if warrior_unlock is set
        if ([string]::IsNullOrWhiteSpace($dbAbility.warrior_unlock)) {
            Write-Host "  [MISSING] '$abilityName' - exists in DB but warrior_unlock is empty" -ForegroundColor Magenta
            $missingAbilities += [PSCustomObject]@{
                Level = $level
                AbilityName = $abilityName
                Reason = "warrior_unlock not set"
            }
        }
        elseif ($dbAbility.warrior_unlock -ne $level) {
            Write-Host "  [MISMATCH] '$abilityName' - warrior_unlock=$($dbAbility.warrior_unlock) but CSV shows Level $level" -ForegroundColor Yellow
            $missingAbilities += [PSCustomObject]@{
                Level = $level
                AbilityName = $abilityName
                Reason = "Level mismatch (DB:$($dbAbility.warrior_unlock) vs CSV:$level)"
            }
        }
        else {
            Write-Host "  [OK] '$abilityName' - warrior_unlock=$($dbAbility.warrior_unlock)" -ForegroundColor Green
            $foundAbilities += [PSCustomObject]@{
                Level = $level
                AbilityName = $abilityName
            }
        }
    }
    
    $level++
}

$parser.Close()

# Summary
Write-Host "`n=== SUMMARY ===" -ForegroundColor Cyan
Write-Host "Levels scanned: 1-$($level - 1)" -ForegroundColor Gray
Write-Host "Warrior Class Talents found (correctly populated): $($foundAbilities.Count)" -ForegroundColor Green
Write-Host "Missing or incorrect: $($missingAbilities.Count)" -ForegroundColor $(if ($missingAbilities.Count -gt 0) { "Red" } else { "Green" })

if ($missingAbilities.Count -gt 0) {
    Write-Host "`n=== MISSING/INCORRECT ABILITIES ===" -ForegroundColor Red
    $missingAbilities | Format-Table -AutoSize
    
    # Group by reason
    Write-Host "`n=== GROUPED BY REASON ===" -ForegroundColor Yellow
    $missingAbilities | Group-Object Reason | ForEach-Object {
        Write-Host "`n$($_.Name) ($($_.Count) abilities):" -ForegroundColor Yellow
        $_.Group | Select-Object Level, AbilityName | Format-Table -AutoSize
    }
}
else {
    Write-Host "`n✅ All Warrior Class Talents correctly populated!" -ForegroundColor Green
}
