#Requires -Version 5.1
<#
.SYNOPSIS
    Extracts Slayer hero talent data from Wowhead HTML file.

.DESCRIPTION
    Parses the Arms Warrior DPS Guide HTML to extract Slayer talent tree structure,
    spell IDs, talent names, and prerequisites. Creates a structured document for
    BG3 mod implementation.

.PARAMETER HtmlFilePath
    Path to the Wowhead HTML file to parse.

.PARAMETER OutputPath
    Path where the markdown document will be saved.

.EXAMPLE
    .\Extract-SlayerTalents.ps1 -HtmlFilePath "c:\WowSource\Arms Warrior DPS Guide - The War Within 11.2 - Wowhead - Slayer.html" -OutputPath "c:\Users\tenod\source\repos\BG3Mods\Documentation\08_WoWSourceMaterial\SLAYER_HERO_TALENTS_EXTRACTED.md"
#>

param(
    [Parameter(Mandatory=$true)]
    [string]$HtmlFilePath,
    
    [Parameter(Mandatory=$true)]
    [string]$OutputPath
)

Write-Host "[INFO] Loading HTML file..." -ForegroundColor Cyan
$html = Get-Content $HtmlFilePath -Raw -Encoding UTF8

Write-Host "[INFO] Extracting talent tree structure..." -ForegroundColor Cyan

# Extract talent links with their grid positions
$talentPattern = '<a class="dragonflight-talent-tree-talent"[^>]+data-row="(\d+)"[^>]+data-column="(\d+)"[^>]+href="https://www\.wowhead\.com/spell=(\d+)/([^"]+)"[^>]*aria-label="([^"]+)"'

$talents = [regex]::Matches($html, $talentPattern) | ForEach-Object {
    [PSCustomObject]@{
        Row = [int]$_.Groups[1].Value
        Column = [int]$_.Groups[2].Value
        SpellID = $_.Groups[3].Value
        URLSlug = $_.Groups[4].Value
        Name = [System.Web.HttpUtility]::HtmlDecode($_.Groups[5].Value)
    }
} | Sort-Object Row, Column

Write-Host "[PASS] Found $($talents.Count) talents" -ForegroundColor Green

# Extract tooltip data (if embedded in HTML)
Write-Host "[INFO] Searching for tooltip descriptions..." -ForegroundColor Cyan
$tooltips = @{}

foreach ($talent in $talents) {
    # Try to find tooltip description near the talent name
    $searchPattern = [regex]::Escape($talent.Name) + '[\s\S]{0,1000}?<div class="q">(.*?)</div>'
    if ($html -match $searchPattern) {
        $description = [System.Web.HttpUtility]::HtmlDecode($matches[1])
        # Clean up HTML tags
        $description = $description -replace '<[^>]+>', ''
        $description = $description -replace '\s+', ' '
        $description = $description.Trim()
        $tooltips[$talent.Name] = $description
    }
}

Write-Host "[PASS] Extracted $($tooltips.Count) tooltip descriptions" -ForegroundColor Green

# Group talents by row
$rowGroups = $talents | Group-Object Row | Sort-Object { [int]$_.Name }

# Create output document
Write-Host "[INFO] Creating markdown document..." -ForegroundColor Cyan

$markdown = @"
# Slayer Hero Talents - WoW Source Data

**Extracted From**: Arms Warrior DPS Guide - The War Within 11.2 - Wowhead  
**Hero Spec**: Slayer (Arms + Fury)  
**Extraction Date**: $(Get-Date -Format "MMMM dd, yyyy")  
**Total Talents**: $($talents.Count)

---

## 📊 Talent Tree Structure

### Row Overview

"@

foreach ($rowGroup in $rowGroups) {
    $rowNum = $rowGroup.Name
    $rowLabel = switch ($rowNum) {
        "1" { "Keystone" }
        "2" { "Tier 1" }
        "3" { "Tier 2" }
        "4" { "Tier 3" }
        "5" { "Capstone" }
        default { "Row $rowNum" }
    }
    
    $markdown += @"

**Row $rowNum ($rowLabel)**: $($rowGroup.Count) talent(s)
"@
}

$markdown += @"


---

## 🎯 Complete Talent List

"@

foreach ($rowGroup in $rowGroups) {
    $rowNum = $rowGroup.Name
    $rowLabel = switch ($rowNum) {
        "1" { "Keystone" }
        "2" { "Tier 1" }
        "3" { "Tier 2" }
        "4" { "Tier 3" }
        "5" { "Capstone" }
        default { "Row $rowNum" }
    }
    
    $markdown += @"

### Row $rowNum - $rowLabel

"@
    
    foreach ($talent in $rowGroup.Group | Sort-Object Column) {
        $markdown += @"

#### $($talent.Name)

- **Spell ID**: $($talent.SpellID)
- **Position**: Row $($talent.Row), Column $($talent.Column)
- **Wowhead URL**: https://www.wowhead.com/spell=$($talent.SpellID)/$($talent.URLSlug)

"@
        
        if ($tooltips.ContainsKey($talent.Name)) {
            $markdown += @"
**Description**:  
$($tooltips[$talent.Name])

"@
        } else {
            $markdown += @"
**Description**: *(Not found in HTML - visit Wowhead URL manually)*

"@
        }
    }
}

$markdown += @"

---

## 🔗 Tree Structure & Prerequisites

"@

# Try to extract connection lines (prerequisites)
Write-Host "[INFO] Analyzing talent prerequisites..." -ForegroundColor Cyan

$markdown += @"

### Visual Grid

``````
     Col:  1    2    3    4    5    6    7    8    9   10   11   12
Row 1:                                              [Keystone]
Row 2:
Row 3:
Row 4:
Row 5:                                              [Capstone]
``````

"@

# Add actual positions
$markdown += "`n### Talent Positions`n`n"

foreach ($talent in $talents | Sort-Object Row, Column) {
    $markdown += "- **$($talent.Name)**: Row $($talent.Row), Column $($talent.Column)`n"
}

$markdown += @"


---

## 📝 Implementation Notes

### For BG3 Mod

1. **Keystone (L13)**: Auto-granted when player chooses Slayer at Level 13
2. **Tier 1-3 (L15, L17, L19)**: Auto-granted (no player choice in this implementation)
3. **Capstone (L20)**: Auto-granted final talent

### File Locations

- `Data/Public/BG3Wow_.../ClassDescriptions/ClassDescriptions.lsx` - Add Slayer subclass
- `Data/Public/BG3Wow_.../Progressions.lsx` - Add L13-L20 progression nodes
- `Data/Public/BG3Wow_.../Stats/Generated/Data/Passive.txt` - Implement passives
- `Data/Public/BG3Wow_.../Stats/Generated/Data/Spell_*.txt` - Implement any new spells
- `Data/Public/BG3Wow_.../Stats/Generated/Data/Status_BOOST.txt` - Implement status effects
- `Data/Public/BG3Wow_.../Localization/English/English.loca.xml` - Add localization handles

### Next Steps

1. ✅ Extract talent data (this document)
2. ⏸️ Visit each Wowhead URL to get full tooltip descriptions
3. ⏸️ Map WoW mechanics → BG3 equivalent mechanics
4. ⏸️ Implement Section 5 (Hero Talents) following SECTION_5_HERO_TALENTS_PLAN.md

---

## 🔍 Raw Extraction Data

### All Talents (Alphabetical)

"@

foreach ($talent in $talents | Sort-Object Name) {
    $markdown += "- **$($talent.Name)** (Spell ID: $($talent.SpellID), Row $($talent.Row), Col $($talent.Column))`n"
}

$markdown += @"


### Tooltips Found

"@

if ($tooltips.Count -gt 0) {
    foreach ($key in $tooltips.Keys | Sort-Object) {
        $markdown += @"

**$key**:  
$($tooltips[$key])

"@
    }
} else {
    $markdown += "`n*(No embedded tooltips found - descriptions must be retrieved manually from Wowhead)*`n"
}

$markdown += @"


---

**Generated By**: Extract-SlayerTalents.ps1  
**Source File**: $HtmlFilePath  
**Timestamp**: $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")

"@

# Write output
Write-Host "[INFO] Writing markdown document..." -ForegroundColor Cyan
$markdown | Out-File $OutputPath -Encoding UTF8

Write-Host "`n[SUCCESS] Document created at: $OutputPath" -ForegroundColor Green
Write-Host "[INFO] Total talents extracted: $($talents.Count)" -ForegroundColor Cyan
Write-Host "[INFO] Tooltips found: $($tooltips.Count)" -ForegroundColor Cyan

if ($tooltips.Count -lt $talents.Count) {
    Write-Host "`n[WARN] Not all tooltips were found in HTML" -ForegroundColor Yellow
    Write-Host "[WARN] You may need to visit Wowhead URLs manually to get full descriptions" -ForegroundColor Yellow
}

Write-Host "`n[INFO] Next steps:" -ForegroundColor Cyan
Write-Host "  1. Review generated document: $OutputPath" -ForegroundColor White
Write-Host "  2. Visit Wowhead URLs for missing tooltips" -ForegroundColor White
Write-Host "  3. Create similar scripts for Mountain Thane and Colossus" -ForegroundColor White
Write-Host "  4. Implement Section 5 (Hero Talents)" -ForegroundColor White
