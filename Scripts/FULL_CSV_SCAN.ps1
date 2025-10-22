# FULL_CSV_SCAN.ps1
# Comprehensive scan of progression CSV
# Analyzes structure, columns, rows, and all abilities
#
# Date: October 22, 2025

param(
    [string]$CsvPath = "C:\Users\tenod\source\repos\BG3Mods\Documentation\00_SourcesOfTruth\Warrior Progression for all subclasses and Default hero structure.csv"
)

Write-Host "`n=== FULL PROGRESSION CSV SCAN ===" -ForegroundColor Cyan
Write-Host "File: $CsvPath`n" -ForegroundColor Gray

# Parse CSV properly
Add-Type -AssemblyName Microsoft.VisualBasic
$parser = New-Object Microsoft.VisualBasic.FileIO.TextFieldParser($CsvPath)
$parser.TextFieldType = [Microsoft.VisualBasic.FileIO.FieldType]::Delimited
$parser.SetDelimiters(",")
$parser.HasFieldsEnclosedInQuotes = $true

# Read all rows
$allRows = @()
while (-not $parser.EndOfData) {
    $allRows += ,($parser.ReadFields())
}
$parser.Close()

Write-Host "=== FILE STRUCTURE ===" -ForegroundColor Yellow
Write-Host "Total rows: $($allRows.Count)" -ForegroundColor Cyan
Write-Host "Total columns: $($allRows[0].Count)" -ForegroundColor Cyan

# Analyze header structure
Write-Host "`n=== HEADER STRUCTURE ===" -ForegroundColor Yellow
$headerRow = $allRows[0]
$subHeaderRow1 = $allRows[1]
$subHeaderRow2 = $allRows[2]

Write-Host "`nRow 1 (Main Headers) - Column categories:" -ForegroundColor Cyan
$currentCategory = ""
$categoryStart = 0
for ($i = 0; $i -lt $headerRow.Count; $i++) {
    if (-not [string]::IsNullOrWhiteSpace($headerRow[$i])) {
        if ($currentCategory) {
            Write-Host "  Columns $categoryStart-$($i-1): $currentCategory" -ForegroundColor Gray
        }
        $currentCategory = $headerRow[$i]
        if ($currentCategory.Length -gt 80) {
            $currentCategory = $currentCategory.Substring(0, 77) + "..."
        }
        $categoryStart = $i
    }
}
if ($currentCategory) {
    Write-Host "  Columns $categoryStart-$($headerRow.Count-1): $currentCategory" -ForegroundColor Gray
}

Write-Host "`nRow 2 (Sub-headers) - Notable entries:" -ForegroundColor Cyan
for ($i = 0; $i -lt $subHeaderRow1.Count; $i++) {
    if (-not [string]::IsNullOrWhiteSpace($subHeaderRow1[$i])) {
        Write-Host "  Column $i`: $($subHeaderRow1[$i])" -ForegroundColor Gray
    }
}

Write-Host "`nRow 3 (Types) - Notable entries:" -ForegroundColor Cyan
for ($i = 0; $i -lt $subHeaderRow2.Count; $i++) {
    if (-not [string]::IsNullOrWhiteSpace($subHeaderRow2[$i])) {
        $display = $subHeaderRow2[$i]
        if ($display.Length -gt 60) {
            $display = $display.Substring(0, 57) + "..."
        }
        Write-Host "  Column $i`: $display" -ForegroundColor Gray
    }
}

# Analyze data rows (4-23 = levels 1-20)
Write-Host "`n=== DATA ROWS (Levels 1-20) ===" -ForegroundColor Yellow

function Extract-AbilityName {
    param([string]$CellValue)
    
    if ([string]::IsNullOrWhiteSpace($CellValue)) {
        return $null
    }
    
    $clean = $CellValue -replace '^[\s·"]+', ''
    
    if ($clean -match '^([^(]+?)\s*\([^)]+\)\s*-') {
        return $matches[1].Trim()
    }
    elseif ($clean -match '^([^-]+?)\s*-' -and $clean -notmatch '^(Auto Grant|AutoGrant|Offensive|Defensive|Utility|Stance|Passive|Pick one|Choose one|Row \d+|Grant|Add)') {
        return $matches[1].Trim()
    }
    elseif ($clean -match '^([^(]+?)\s*\([^)]+\)$') {
        return $matches[1].Trim()
    }
    
    return $null
}

# Count abilities per level
$levelData = @{}
for ($rowIdx = 3; $rowIdx -lt [Math]::Min(23, $allRows.Count); $rowIdx++) {
    $row = $allRows[$rowIdx]
    $level = $row[0]
    
    if ([string]::IsNullOrWhiteSpace($level)) {
        continue
    }
    
    $abilities = @()
    for ($colIdx = 1; $colIdx -lt $row.Count; $colIdx++) {
        $abilityName = Extract-AbilityName -CellValue $row[$colIdx]
        if ($abilityName) {
            $abilities += [PSCustomObject]@{
                Column = $colIdx
                Name = $abilityName
                FullText = $row[$colIdx].Substring(0, [Math]::Min(100, $row[$colIdx].Length))
            }
        }
    }
    
    $levelData[$level] = $abilities
}

Write-Host "`nAbilities per level:" -ForegroundColor Cyan
foreach ($level in 1..20) {
    $levelStr = $level.ToString()
    if ($levelData.ContainsKey($levelStr)) {
        $count = $levelData[$levelStr].Count
        Write-Host "  Level $level`: $count abilities" -ForegroundColor $(if ($count -gt 0) { "Green" } else { "Gray" })
    }
    else {
        Write-Host "  Level $level`: 0 abilities (no data row)" -ForegroundColor Red
    }
}

# Analyze column usage
Write-Host "`n=== COLUMN USAGE ANALYSIS ===" -ForegroundColor Yellow

$columnUsage = @{}
for ($rowIdx = 3; $rowIdx -lt [Math]::Min(23, $allRows.Count); $rowIdx++) {
    $row = $allRows[$rowIdx]
    for ($colIdx = 0; $colIdx -lt $row.Count; $colIdx++) {
        if (-not [string]::IsNullOrWhiteSpace($row[$colIdx])) {
            if (-not $columnUsage.ContainsKey($colIdx)) {
                $columnUsage[$colIdx] = 0
            }
            $columnUsage[$colIdx]++
        }
    }
}

Write-Host "`nColumns with data (showing header and usage count):" -ForegroundColor Cyan
foreach ($colIdx in $columnUsage.Keys | Sort-Object) {
    $header = $headerRow[$colIdx]
    if ([string]::IsNullOrWhiteSpace($header)) {
        $header = "(continuation of previous header)"
    }
    else {
        if ($header.Length -gt 50) {
            $header = $header.Substring(0, 47) + "..."
        }
    }
    Write-Host "  Column $colIdx`: $($columnUsage[$colIdx]) rows - $header" -ForegroundColor Gray
}

# Extract all unique abilities
Write-Host "`n=== ALL UNIQUE ABILITIES FOUND ===" -ForegroundColor Yellow

$allAbilities = @{}
foreach ($level in $levelData.Keys) {
    foreach ($ability in $levelData[$level]) {
        $name = $ability.Name
        if (-not $allAbilities.ContainsKey($name)) {
            $allAbilities[$name] = @()
        }
        $allAbilities[$name] += [PSCustomObject]@{
            Level = $level
            Column = $ability.Column
        }
    }
}

Write-Host "Total unique abilities: $($allAbilities.Count)" -ForegroundColor Cyan
Write-Host "`nAbilities appearing at multiple levels:" -ForegroundColor Cyan
$multiLevel = $allAbilities.GetEnumerator() | Where-Object { $_.Value.Count -gt 1 } | Sort-Object { $_.Value.Count } -Descending
foreach ($entry in $multiLevel) {
    $levels = ($entry.Value | ForEach-Object { "L$($_.Level)" }) -join ", "
    Write-Host "  $($entry.Key): $levels" -ForegroundColor Yellow
}

# Detailed level-by-level breakdown
Write-Host "`n=== DETAILED LEVEL-BY-LEVEL BREAKDOWN ===" -ForegroundColor Yellow

foreach ($level in 1..20) {
    $levelStr = $level.ToString()
    if (-not $levelData.ContainsKey($levelStr)) {
        continue
    }
    
    $abilities = $levelData[$levelStr]
    if ($abilities.Count -eq 0) {
        continue
    }
    
    Write-Host "`n--- Level $level ($($abilities.Count) abilities) ---" -ForegroundColor Cyan
    
    # Group by column ranges to identify categories
    $grouped = $abilities | Group-Object { 
        if ($_.Column -le 9) { "Baseline/BG3" }
        elseif ($_.Column -le 22) { "Warrior Class Talents" }
        elseif ($_.Column -le 35) { "Arms Spec Talents" }
        elseif ($_.Column -le 47) { "Fury Spec Talents" }
        elseif ($_.Column -le 54) { "Protection Spec Talents" }
        else { "Hero Talents" }
    }
    
    foreach ($group in $grouped) {
        Write-Host "  $($group.Name):" -ForegroundColor Gray
        foreach ($ability in $group.Group) {
            Write-Host "    [Col $($ability.Column)] $($ability.Name)" -ForegroundColor White
        }
    }
}

# Summary statistics
Write-Host "`n=== SUMMARY STATISTICS ===" -ForegroundColor Yellow
Write-Host "Total rows: $($allRows.Count)" -ForegroundColor Cyan
Write-Host "Header rows: 3" -ForegroundColor Cyan
Write-Host "Data rows (levels 1-20): $($levelData.Count)" -ForegroundColor Cyan
Write-Host "Total columns: $($allRows[0].Count)" -ForegroundColor Cyan
Write-Host "Columns with data: $($columnUsage.Count)" -ForegroundColor Cyan
Write-Host "Total unique abilities: $($allAbilities.Count)" -ForegroundColor Cyan
Write-Host "Abilities appearing multiple times: $($multiLevel.Count)" -ForegroundColor Cyan

$totalAbilityInstances = ($levelData.Values | ForEach-Object { $_.Count } | Measure-Object -Sum).Sum
Write-Host "Total ability instances (with duplicates): $totalAbilityInstances" -ForegroundColor Cyan

Write-Host "`n=== SCAN COMPLETE ===" -ForegroundColor Green
