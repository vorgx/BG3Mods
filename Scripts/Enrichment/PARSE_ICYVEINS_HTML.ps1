# PARSE ICY-VEINS HTML - Extract All Ability Data
# Date: October 20, 2025
# Purpose: Parse offline Icy-Veins HTML files to extract WoW ability mechanics for enrichment

param(
    [Parameter(Mandatory=$false)]
    [string]$HTMLFolder = "Documentation\08_WoWSourceMaterial\OfflineHTMLSources",
    [Parameter(Mandatory=$false)]
    [string]$OutputFolder = "Documentation\08_WoWSourceMaterial\ExtractedData"
)

Write-Host "========================================" -ForegroundColor Cyan
Write-Host " ICY-VEINS HTML PARSER" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Create output folder
New-Item -ItemType Directory -Path $OutputFolder -Force | Out-Null

# Get HTML files
$icyVeinsFiles = @(
    "$HTMLFolder\Arms Warrior DPS Spell List and Glossary - The War Within (11.2.5) - World of Warcraft - Icy Veins.html",
    "$HTMLFolder\Fury Warrior DPS Spell List and Glossary - The War Within (11.2.5) - World of Warcraft - Icy Veins.html",
    "$HTMLFolder\Protection Warrior Tank Spell List and Glossary - The War Within (11.2.5) - World of Warcraft - Icy Veins.html"
)

$allAbilities = @()

foreach ($file in $icyVeinsFiles) {
    if (-not (Test-Path $file)) {
        Write-Host "[WARN] File not found: $file" -ForegroundColor Yellow
        continue
    }
    
    $specName = if ($file -like "*Arms*") { "Arms" } 
                elseif ($file -like "*Fury*") { "Fury" } 
                elseif ($file -like "*Protection*") { "Protection" }
                else { "Unknown" }
    
    Write-Host "[PARSING] $specName Warrior..." -ForegroundColor Cyan
    
    # Read HTML content
    $html = Get-Content $file -Raw -Encoding UTF8
    
    # Extract ability names and descriptions using regex patterns
    # Icy-Veins uses <h3> tags for ability names and <p> tags for descriptions
    
    # Pattern 1: Find all <h3> headers (ability names)
    $abilityHeaders = [regex]::Matches($html, '<h3[^>]*>([^<]+)</h3>')
    
    Write-Host "  Found $($abilityHeaders.Count) ability headers" -ForegroundColor White
    
    foreach ($match in $abilityHeaders) {
        $abilityName = $match.Groups[1].Value.Trim()
        
        # Skip non-ability headers
        if ($abilityName -match "^(Active Abilities|Passive Abilities|Cooldowns|Rotation|Introduction|Notes|Summary)") {
            continue
        }
        
        # Find the description following this header
        $headerPos = $match.Index + $match.Length
        $nextHeaderMatch = [regex]::Match($html.Substring($headerPos), '<h[23][^>]*>')
        
        $descEndPos = if ($nextHeaderMatch.Success) {
            $headerPos + $nextHeaderMatch.Index
        } else {
            $html.Length
        }
        
        $sectionHTML = $html.Substring($headerPos, $descEndPos - $headerPos)
        
        # Extract paragraph text (descriptions)
        $paragraphs = [regex]::Matches($sectionHTML, '<p[^>]*>([^<]+(?:<[^/][^>]*>[^<]*</[^>]+>[^<]*)*)</p>')
        $description = ($paragraphs | ForEach-Object { $_.Groups[1].Value }) -join " "
        
        # Clean HTML tags from description
        $description = $description -replace '<[^>]+>', ''
        $description = $description -replace '&nbsp;', ' '
        $description = $description -replace '\s+', ' '
        $description = $description.Trim()
        
        # Extract rage cost if mentioned
        $rageCost = $null
        if ($description -match '(\d+)\s+Rage') {
            $rageCost = $matches[1]
        }
        
        # Extract cooldown if mentioned
        $cooldown = $null
        if ($description -match '(\d+(?:\.\d+)?)\s+(second|minute|min|sec)(?:\s+cooldown)?') {
            $cooldown = $matches[0]
        }
        
        # Create ability object
        $ability = [PSCustomObject]@{
            Spec = $specName
            AbilityName = $abilityName
            Description = if ($description.Length -gt 0) { $description } else { "No description found" }
            RageCost = $rageCost
            Cooldown = $cooldown
            SourceFile = Split-Path $file -Leaf
        }
        
        $allAbilities += $ability
        
        Write-Host "    ✓ $abilityName" -ForegroundColor Green
    }
    
    Write-Host ""
}

# Export results
Write-Host "[EXPORT] Exporting extracted data..." -ForegroundColor Cyan

# CSV export
$csvFile = "$OutputFolder\IcyVeins_AllAbilities_Extracted.csv"
$allAbilities | Export-Csv $csvFile -NoTypeInformation -Encoding UTF8
Write-Host "  CSV: $csvFile" -ForegroundColor White

# Markdown report
$mdFile = "$OutputFolder\IcyVeins_AllAbilities_Extracted.md"
$mdLines = @()
$mdLines += "# Icy-Veins Ability Data - Extracted from Offline HTML"
$mdLines += ""
$mdLines += "**Generated**: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"
$mdLines += "**Source Files**: 3 Icy-Veins spell summary pages"
$mdLines += "**Total Abilities Extracted**: $($allAbilities.Count)"
$mdLines += ""
$mdLines += "---"
$mdLines += ""
$mdLines += "## Summary by Spec"
$mdLines += ""

$allAbilities | Group-Object Spec | ForEach-Object {
    $specName = $_.Name
    $count = $_.Count
    $mdLines += "### $specName Warrior - $count abilities"
    $mdLines += ""
    
    $_.Group | ForEach-Object {
        $desc = $_.Description.Substring(0, [Math]::Min(150, $_.Description.Length))
        if ($_.Description.Length -gt 150) { $desc += "..." }
        $mdLines += "**$($_.AbilityName)**"
        if ($_.RageCost) { $mdLines += "- Rage: $($_.RageCost)" }
        if ($_.Cooldown) { $mdLines += "- Cooldown: $($_.Cooldown)" }
        $mdLines += "- Description: $desc"
        $mdLines += ""
    }
    $mdLines += "---"
    $mdLines += ""
}

$mdLines | Out-File $mdFile -Encoding UTF8
Write-Host "  Markdown: $mdFile" -ForegroundColor White

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host " EXTRACTION COMPLETE" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Total abilities extracted: $($allAbilities.Count)" -ForegroundColor Green
Write-Host ""
Write-Host "Breakdown by spec:" -ForegroundColor White
$allAbilities | Group-Object Spec | ForEach-Object {
    Write-Host "  $($_.Name): $($_.Count)" -ForegroundColor Cyan
}
Write-Host ""
Write-Host "Output files:" -ForegroundColor White
Write-Host "  CSV: $csvFile" -ForegroundColor Cyan
Write-Host "  MD: $mdFile" -ForegroundColor Cyan
Write-Host ""
