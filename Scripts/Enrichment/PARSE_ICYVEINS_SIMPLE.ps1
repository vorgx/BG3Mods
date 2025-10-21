# SIMPLE ICY-VEINS HTML PARSER
# Extracts ability data from offline HTML files
# Date: October 20, 2025

param(
    [string]$HTMLFolder = "Documentation\08_WoWSourceMaterial\OfflineHTMLSources",
    [string]$OutputCSV = "Documentation\08_WoWSourceMaterial\ExtractedData\IcyVeins_Extracted.csv"
)

Write-Host "`n[INFO] Simple Icy-Veins HTML Parser`n" -ForegroundColor Cyan

# Create output directory
$outputDir = Split-Path $OutputCSV -Parent
New-Item -ItemType Directory -Path $outputDir -Force | Out-Null

# Files to parse
$files = @{
    "Arms" = "$HTMLFolder\Arms Warrior DPS Spell List and Glossary - The War Within (11.2.5) - World of Warcraft - Icy Veins.html"
    "Fury" = "$HTMLFolder\Fury Warrior DPS Spell List and Glossary - The War Within (11.2.5) - World of Warcraft - Icy Veins.html"
    "Protection" = "$HTMLFolder\Protection Warrior Tank Spell List and Glossary - The War Within (11.2.5) - World of Warcraft - Icy Veins.html"
}

$allAbilities = @()

foreach ($spec in $files.Keys) {
    $file = $files[$spec]
    
    if (-not (Test-Path $file)) {
        Write-Host "[SKIP] $spec - file not found" -ForegroundColor Yellow
        continue
    }
    
    Write-Host "[PARSE] $spec Warrior..." -ForegroundColor White
    
    # Read HTML
    $html = [System.IO.File]::ReadAllText($file, [System.Text.Encoding]::UTF8)
    
    # Find ability headers - Icy-Veins uses <h3> tags
    $h3Pattern = '<h3[^>]*>([^<]+)</h3>'
    $h3Matches = [regex]::Matches($html, $h3Pattern)
    
    $count = 0
    foreach ($match in $h3Matches) {
        $abilityName = $match.Groups[1].Value.Trim()
        
        # Skip section headers
        if ($abilityName -match '^(Active|Passive|Cooldown|Rotation|Introduction|Summary|Notes|Important|Recommended|Talent|Build)') {
            continue
        }
        
        # Get description (text after header until next header)
        $startPos = $match.Index + $match.Length
        $nextH = [regex]::Match($html.Substring($startPos), '<h[23][^>]*>')
        $endPos = if ($nextH.Success) { $startPos + $nextH.Index } else { $html.Length }
        
        $section = $html.Substring($startPos, $endPos - $startPos)
        
        # Extract text from paragraphs
        $pPattern = '<p[^>]*>([^<]+(?:<[^>]+>[^<]*)*)</p>'
        $pMatches = [regex]::Matches($section, $pPattern)
        $description = ($pMatches | ForEach-Object { $_.Groups[1].Value }) -join " "
        
        # Clean HTML
        $description = $description -replace '<[^>]+>', ''
        $description = $description -replace '&nbsp;', ' '
        $description = $description -replace '&quot;', '"'
        $description = $description -replace '&amp;', '&'
        $description = $description -replace '\s+', ' '
        $description = $description.Trim()
        
        if ($description.Length -eq 0) {
            $description = "No description found"
        }
        
        # Extract rage cost
        $rageCost = if ($description -match '(\d+)\s+Rage') { $matches[1] } else { $null }
        
        # Extract cooldown
        $cooldown = if ($description -match '(\d+(?:\.\d+)?)\s*(second|minute|min|sec)s?\s*(?:cooldown)?') { 
            $matches[0] 
        } else { $null }
        
        # Create object
        $allAbilities += [PSCustomObject]@{
            Spec = $spec
            AbilityName = $abilityName
            RageCost = $rageCost
            Cooldown = $cooldown
            Description = $description.Substring(0, [Math]::Min(500, $description.Length))
        }
        
        $count++
    }
    
    Write-Host "  Extracted: $count abilities" -ForegroundColor Green
}

# Export
$allAbilities | Export-Csv $OutputCSV -NoTypeInformation -Encoding UTF8

Write-Host "`n[DONE] Extracted $($allAbilities.Count) total abilities" -ForegroundColor Green
Write-Host "[OUT] $OutputCSV`n" -ForegroundColor Cyan

# Show summary
Write-Host "Summary by spec:" -ForegroundColor White
$allAbilities | Group-Object Spec | ForEach-Object {
    Write-Host "  $($_.Name): $($_.Count)" -ForegroundColor Cyan
}
Write-Host ""
