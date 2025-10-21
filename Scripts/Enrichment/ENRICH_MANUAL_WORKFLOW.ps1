# MANUAL ENRICHMENT WORKFLOW - Interactive Ability Research
# Date: October 20, 2025
# Purpose: Systematic enrichment of remaining 131 abilities

param(
    [Parameter(Mandatory=$false)]
    [string]$DatabaseFile = "Documentation\00_SourcesOfTruth\AbilityDatabase_Warrior_FullyEnriched.csv",
    [Parameter(Mandatory=$false)]
    [int]$BatchSize = 20,
    [Parameter(Mandatory=$false)]
    [string]$FilterType = "All" # All, Passive, Offensive, Defensive, Utility
)

Write-Host "========================================" -ForegroundColor Cyan
Write-Host " MANUAL ENRICHMENT WORKFLOW" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Load database
$db = Import-Csv $DatabaseFile -Encoding UTF8
$unenriched = $db | Where-Object { -not ($_.bg3_file_type -and $_.archetype_tags) }

# Filter by type if requested
if ($FilterType -ne "All") {
    $unenriched = $unenriched | Where-Object { $_.ability_type -eq $FilterType }
}

Write-Host "[TOTAL] $($unenriched.Count) unenriched abilities" -ForegroundColor Yellow
if ($FilterType -ne "All") {
    Write-Host "[FILTER] Showing only: $FilterType" -ForegroundColor Cyan
}
Write-Host ""

# Group by type for statistics
$byType = $unenriched | Group-Object ability_type | Sort-Object Count -Descending
Write-Host "[BREAKDOWN] Unenriched by type:" -ForegroundColor Yellow
foreach ($group in $byType) {
    Write-Host "  - $($group.Name): $($group.Count)" -ForegroundColor White
}
Write-Host ""

# Show first batch
$batch = $unenriched | Select-Object -First $BatchSize
Write-Host "[BATCH] Next $($batch.Count) abilities to research:" -ForegroundColor Green
Write-Host "================================" -ForegroundColor Green
Write-Host ""

$counter = 1
foreach ($ability in $batch) {
    Write-Host "[$counter/$($batch.Count)] $($ability.ability_name)" -ForegroundColor Cyan
    Write-Host "  Type: $($ability.ability_type)" -ForegroundColor White
    Write-Host "  Level: $($ability.level_learned)" -ForegroundColor White
    Write-Host "  Classification: $($ability.classification)" -ForegroundColor White
    
    # Show what we already know
    if ($ability.description_short) {
        Write-Host "  Desc: $($ability.description_short.Substring(0, [Math]::Min(80, $ability.description_short.Length)))..." -ForegroundColor Gray
    }
    if ($ability.wow_cost_rage) {
        Write-Host "  Rage: $($ability.wow_cost_rage)" -ForegroundColor Yellow
    }
    
    # Research suggestions
    Write-Host "  Research URLs:" -ForegroundColor Green
    
    # Icy-Veins search
    $abilitySearchName = $ability.ability_name -replace '\s+', '-' -replace "'", ''
    $spec = if ($ability.ability_name -match "Arms|Colossus|Slayer") { "arms" }
            elseif ($ability.ability_name -match "Fury|Mountain") { "fury" }
            elseif ($ability.ability_name -match "Protection|Shield") { "protection" }
            else { "arms" }
    
    Write-Host "    Icy-Veins: https://www.icy-veins.com/wow/$spec-warrior-pve-dps-guide" -ForegroundColor Blue
    
    # Wowhead search
    Write-Host "    Wowhead: https://www.wowhead.com/spell=$($ability.ability_name -replace '\s+', '-')" -ForegroundColor Blue
    
    Write-Host ""
    $counter++
}

Write-Host "================================" -ForegroundColor Green
Write-Host ""
Write-Host "[RESOURCES] Available offline HTML files:" -ForegroundColor Yellow
Write-Host "  1. Documentation\08_WoWSourceMaterial\OfflineHTMLSources\Arms Warrior DPS Spell Summary and Rotation - Icy Veins.html" -ForegroundColor Cyan
Write-Host "  2. Documentation\08_WoWSourceMaterial\OfflineHTMLSources\Fury Warrior DPS Spell Summary and Rotation - Icy Veins.html" -ForegroundColor Cyan
Write-Host "  3. Documentation\08_WoWSourceMaterial\OfflineHTMLSources\Protection Warrior Tank Spell Summary and Rotation - Icy Veins.html" -ForegroundColor Cyan
Write-Host "  4-9. Wowhead hero talent guides (Colossus, Slayer, Mountain Thane)" -ForegroundColor Cyan
Write-Host ""

Write-Host "[NEXT STEPS] To enrich these abilities:" -ForegroundColor Green
Write-Host "  1. Research each ability from offline HTML or online sources" -ForegroundColor White
Write-Host "  2. Record findings in a text file or spreadsheet" -ForegroundColor White
Write-Host "  3. Use ENRICH_FROM_SOURCE_OF_TRUTH.ps1 as template to add new entries" -ForegroundColor White
Write-Host "  4. Run enrichment script to update database" -ForegroundColor White
Write-Host ""
Write-Host "[TIP] Focus on Passives first (71 remaining) - many are simple stat boosts" -ForegroundColor Yellow
Write-Host ""

# Export batch to CSV for easy tracking
$batchFile = "Documentation\00_SourcesOfTruth\ENRICHMENT_BATCH_$(Get-Date -Format 'yyyyMMdd_HHmmss').csv"
$batch | Export-Csv $batchFile -NoTypeInformation -Encoding UTF8
Write-Host "[EXPORTED] Research batch saved to: $batchFile" -ForegroundColor Green
Write-Host ""
