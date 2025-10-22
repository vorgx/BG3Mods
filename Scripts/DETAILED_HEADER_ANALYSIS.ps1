# DETAILED_HEADER_ANALYSIS.ps1
# Comprehensive header structure analysis with exact column mappings
# Shows all 3 header rows and their relationships
#
# Date: October 22, 2025

param(
    [string]$CsvPath = "C:\Users\tenod\source\repos\BG3Mods\Documentation\00_SourcesOfTruth\Warrior Progression for all subclasses and Default hero structure.csv"
)

Write-Host "`n=== DETAILED HEADER & COLUMN ANALYSIS ===" -ForegroundColor Cyan
Write-Host "File: $CsvPath`n" -ForegroundColor Gray

# Parse CSV properly
Add-Type -AssemblyName Microsoft.VisualBasic
$parser = New-Object Microsoft.VisualBasic.FileIO.TextFieldParser($CsvPath)
$parser.TextFieldType = [Microsoft.VisualBasic.FileIO.FieldType]::Delimited
$parser.SetDelimiters(",")
$parser.HasFieldsEnclosedInQuotes = $true

# Read header rows
$row1 = $parser.ReadFields()  # Main category headers
$row2 = $parser.ReadFields()  # Sub-headers (Auto Grant, Pick one, etc.)
$row3 = $parser.ReadFields()  # Column types (Offensive, Utility, Passive, etc.)

$parser.Close()

Write-Host "=== COMPLETE HEADER STRUCTURE ===" -ForegroundColor Yellow
Write-Host "Total Columns: $($row1.Count)`n" -ForegroundColor Cyan

# Create detailed column table
Write-Host "Column | Row 1 (Category)                              | Row 2 (Grant Type)         | Row 3 (Ability Type)" -ForegroundColor White
Write-Host "-------|-----------------------------------------------|----------------------------|----------------------------------" -ForegroundColor Gray

for ($i = 0; $i -lt $row1.Count; $i++) {
    $r1 = $row1[$i]
    $r2 = $row2[$i]
    $r3 = $row3[$i]
    
    # Truncate for display
    if ($r1.Length -gt 45) { $r1 = $r1.Substring(0, 42) + "..." }
    if ($r2.Length -gt 26) { $r2 = $r2.Substring(0, 23) + "..." }
    if ($r3.Length -gt 33) { $r3 = $r3.Substring(0, 30) + "..." }
    
    # Only show if at least one row has content
    if (-not [string]::IsNullOrWhiteSpace($r1) -or -not [string]::IsNullOrWhiteSpace($r2) -or -not [string]::IsNullOrWhiteSpace($r3)) {
        Write-Host ("{0,6} | {1,-45} | {2,-26} | {3,-33}" -f $i, $r1, $r2, $r3) -ForegroundColor White
    }
}

Write-Host "`n=== CATEGORY SPAN MAPPING ===" -ForegroundColor Yellow
Write-Host "Shows which columns each Row 1 category header spans`n" -ForegroundColor Gray

# Identify category spans
$categorySpans = @()
$currentCategory = $null
$currentStart = -1

for ($i = 0; $i -lt $row1.Count; $i++) {
    if (-not [string]::IsNullOrWhiteSpace($row1[$i])) {
        # Save previous category
        if ($currentCategory -ne $null) {
            $categorySpans += [PSCustomObject]@{
                Category = $currentCategory
                StartCol = $currentStart
                EndCol = $i - 1
                Span = $i - $currentStart
            }
        }
        # Start new category
        $currentCategory = $row1[$i]
        $currentStart = $i
    }
}
# Add last category
if ($currentCategory -ne $null) {
    $categorySpans += [PSCustomObject]@{
        Category = $currentCategory
        StartCol = $currentStart
        EndCol = $row1.Count - 1
        Span = $row1.Count - $currentStart
    }
}

Write-Host "Category                                           | Start | End | Span | Database Column(s)" -ForegroundColor White
Write-Host "---------------------------------------------------|-------|-----|------|----------------------------------" -ForegroundColor Gray

foreach ($span in $categorySpans) {
    $category = $span.Category
    if ($category.Length -gt 50) {
        $category = $category.Substring(0, 47) + "..."
    }
    
    # Determine database column mapping
    $dbCols = ""
    if ($span.Category -match "Baseline Arms") {
        $dbCols = "arms_unlock"
    }
    elseif ($span.Category -match "Baseline Protection") {
        $dbCols = "protection_unlock"
    }
    elseif ($span.Category -match "Baseline Fury") {
        $dbCols = "fury_unlock"
    }
    elseif ($span.Category -match "Warrior Class Talents.*All") {
        $dbCols = "warrior_unlock ⭐"
    }
    elseif ($span.Category -match "Arms Spec Talents") {
        $dbCols = "arms_unlock"
    }
    elseif ($span.Category -match "Fury Spec Talents") {
        $dbCols = "fury_unlock"
    }
    elseif ($span.Category -match "Protection.*Spec Talents") {
        $dbCols = "protection_unlock"
    }
    elseif ($span.Category -match "Mountain Thane") {
        $dbCols = "protection_unlock + fury_unlock"
    }
    elseif ($span.Category -match "Colossus") {
        $dbCols = "arms_unlock + protection_unlock"
    }
    elseif ($span.Category -match "Slayers") {
        $dbCols = "arms_unlock + fury_unlock"
    }
    else {
        $dbCols = "(N/A)"
    }
    
    Write-Host ("{0,-50} | {1,5} | {2,3} | {3,4} | {4}" -f $category, $span.StartCol, $span.EndCol, $span.Span, $dbCols) -ForegroundColor $(if ($dbCols -match "warrior_unlock") { "Yellow" } else { "White" })
}

Write-Host "`n=== WARRIOR CLASS TALENTS DETAILED BREAKDOWN ===" -ForegroundColor Yellow
Write-Host "Category: Warrior Class Talents (All subclasses has these abilities)" -ForegroundColor Cyan
$warriorSpan = $categorySpans | Where-Object { $_.Category -match "Warrior Class Talents" }
Write-Host "Column Range: $($warriorSpan.StartCol) - $($warriorSpan.EndCol) (Total: $($warriorSpan.Span) columns)`n" -ForegroundColor Cyan

Write-Host "Detailed column breakdown:" -ForegroundColor White
for ($i = $warriorSpan.StartCol; $i -le $warriorSpan.EndCol; $i++) {
    $r2val = $row2[$i]
    $r3val = $row3[$i]
    
    if ([string]::IsNullOrWhiteSpace($r2val)) { $r2val = "(empty)" }
    if ([string]::IsNullOrWhiteSpace($r3val)) { $r3val = "(empty)" }
    
    Write-Host "  Column $i`: Row2='$r2val' | Row3='$r3val'" -ForegroundColor Gray
}

Write-Host "`n=== SPEC TALENTS BREAKDOWN ===" -ForegroundColor Yellow

# Arms
$armsSpan = $categorySpans | Where-Object { $_.Category -match "Arms Spec Talents" }
Write-Host "`nArms Spec Talents:" -ForegroundColor Cyan
Write-Host "  Columns: $($armsSpan.StartCol) - $($armsSpan.EndCol) (Span: $($armsSpan.Span))" -ForegroundColor White
Write-Host "  Row 2 Grant Types:" -ForegroundColor Gray
for ($i = $armsSpan.StartCol; $i -le $armsSpan.EndCol; $i++) {
    if (-not [string]::IsNullOrWhiteSpace($row2[$i])) {
        Write-Host "    Column $i`: $($row2[$i])" -ForegroundColor White
    }
}

# Fury
$furySpan = $categorySpans | Where-Object { $_.Category -match "Fury Spec Talents" }
Write-Host "`nFury Spec Talents:" -ForegroundColor Cyan
Write-Host "  Columns: $($furySpan.StartCol) - $($furySpan.EndCol) (Span: $($furySpan.Span))" -ForegroundColor White
Write-Host "  Row 2 Grant Types:" -ForegroundColor Gray
for ($i = $furySpan.StartCol; $i -le $furySpan.EndCol; $i++) {
    if (-not [string]::IsNullOrWhiteSpace($row2[$i])) {
        Write-Host "    Column $i`: $($row2[$i])" -ForegroundColor White
    }
}

# Protection
$protSpan = $categorySpans | Where-Object { $_.Category -match "Protection.*Spec Talents" }
Write-Host "`nProtection Spec Talents:" -ForegroundColor Cyan
Write-Host "  Columns: $($protSpan.StartCol) - $($protSpan.EndCol) (Span: $($protSpan.Span))" -ForegroundColor White
Write-Host "  Row 2 Grant Types:" -ForegroundColor Gray
for ($i = $protSpan.StartCol; $i -le $protSpan.EndCol; $i++) {
    if (-not [string]::IsNullOrWhiteSpace($row2[$i])) {
        Write-Host "    Column $i`: $($row2[$i])" -ForegroundColor White
    }
}

Write-Host "`n=== HERO TALENTS BREAKDOWN ===" -ForegroundColor Yellow

# Mountain Thane
$mtSpan = $categorySpans | Where-Object { $_.Category -match "Mountain Thane" }
Write-Host "`nMountain Thane (Protection + Fury):" -ForegroundColor Cyan
Write-Host "  Columns: $($mtSpan.StartCol) - $($mtSpan.EndCol) (Span: $($mtSpan.Span))" -ForegroundColor White

# Colossus
$colSpan = $categorySpans | Where-Object { $_.Category -match "Colossus" }
Write-Host "`nColossus (Arms + Protection):" -ForegroundColor Cyan
Write-Host "  Columns: $($colSpan.StartCol) - $($colSpan.EndCol) (Span: $($colSpan.Span))" -ForegroundColor White

# Slayers
$slaySpan = $categorySpans | Where-Object { $_.Category -match "Slayers" }
Write-Host "`nSlayers (Arms + Fury):" -ForegroundColor Cyan
Write-Host "  Columns: $($slaySpan.StartCol) - $($slaySpan.EndCol) (Span: $($slaySpan.Span))" -ForegroundColor White

Write-Host "`n=== SUMMARY FOR SCRIPT MAPPING ===" -ForegroundColor Yellow
Write-Host "`nColumns that should populate warrior_unlock:" -ForegroundColor Cyan
Write-Host "  ⭐ Columns $($warriorSpan.StartCol)-$($warriorSpan.EndCol): Warrior Class Talents (All subclasses)" -ForegroundColor Green

Write-Host "`nColumns that should populate arms_unlock:" -ForegroundColor Cyan
Write-Host "  • Columns 3-4: Baseline Arms abilities" -ForegroundColor White
Write-Host "  • Columns $($armsSpan.StartCol)-$($armsSpan.EndCol): Arms Spec Talents" -ForegroundColor White
Write-Host "  • Columns $($colSpan.StartCol)-$($colSpan.EndCol): Colossus (Arms + Protection)" -ForegroundColor White
Write-Host "  • Columns $($slaySpan.StartCol)-$($slaySpan.EndCol): Slayers (Arms + Fury)" -ForegroundColor White

Write-Host "`nColumns that should populate fury_unlock:" -ForegroundColor Cyan
Write-Host "  • Columns 8-9: Baseline Fury abilities" -ForegroundColor White
Write-Host "  • Columns $($furySpan.StartCol)-$($furySpan.EndCol): Fury Spec Talents" -ForegroundColor White
Write-Host "  • Columns $($mtSpan.StartCol)-$($mtSpan.EndCol): Mountain Thane (Protection + Fury)" -ForegroundColor White
Write-Host "  • Columns $($slaySpan.StartCol)-$($slaySpan.EndCol): Slayers (Arms + Fury)" -ForegroundColor White

Write-Host "`nColumns that should populate protection_unlock:" -ForegroundColor Cyan
Write-Host "  • Columns 5-7: Baseline Protection abilities" -ForegroundColor White
Write-Host "  • Columns $($protSpan.StartCol)-$($protSpan.EndCol): Protection Spec Talents" -ForegroundColor White
Write-Host "  • Columns $($mtSpan.StartCol)-$($mtSpan.EndCol): Mountain Thane (Protection + Fury)" -ForegroundColor White
Write-Host "  • Columns $($colSpan.StartCol)-$($colSpan.EndCol): Colossus (Arms + Protection)" -ForegroundColor White

Write-Host "`n=== ANALYSIS COMPLETE ===" -ForegroundColor Green
