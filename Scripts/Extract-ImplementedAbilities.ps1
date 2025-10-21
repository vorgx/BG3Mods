# Extract-ImplementedAbilities.ps1
# Scans BG3 stat files to identify implemented abilities

param(
    [string]$StatsPath = "Data\Public\Warrior_Wow_78fe4967-4e62-5491-d981-dd781acca4d7\Stats\Generated\Data"
)

$ErrorActionPreference = "Stop"

Write-Host "[INFO] Scanning BG3 stat files for implemented abilities..." -ForegroundColor Cyan
Write-Host ""

# File types to scan
$fileTypes = @(
    "Spell_Target.txt",
    "Spell_Zone.txt", 
    "Spell_Shout.txt",
    "Spell_Projectile.txt",
    "Spell_Jump.txt",
    "Passive.txt",
    "Status_BOOST.txt"
)

$results = @()

foreach ($fileType in $fileTypes) {
    $filePath = Join-Path $StatsPath $fileType
    
    if (Test-Path $filePath) {
        Write-Host "[SCAN] $fileType..." -ForegroundColor Yellow
        
        $lines = Get-Content $filePath
        
        foreach ($line in $lines) {
            if ($line -match '^new entry "(.+?)"') {
                $entryName = $matches[1]
                
                # Only include WAR_ prefixed entries
                if ($entryName -like "WAR_*" -or $entryName -like "Target_WAR_*" -or $entryName -like "Shout_WAR_*" -or $entryName -like "Zone_WAR_*" -or $entryName -like "Projectile_WAR_*" -or $entryName -like "Jump_WAR_*") {
                    $results += [PSCustomObject]@{
                        AbilityID = $entryName
                        FileType = $fileType
                        Status = "Complete"
                    }
                }
            }
        }
        
        $warCount = ($results | Where-Object {$_.FileType -eq $fileType}).Count
        Write-Host "   Found $warCount Warrior abilities" -ForegroundColor Gray
    }
}

Write-Host ""
Write-Host "[DONE] Total Warrior abilities found: $($results.Count)" -ForegroundColor Green
Write-Host ""

# Group by file type
Write-Host "[STATS] Breakdown by file type:" -ForegroundColor Cyan
$results | Group-Object FileType | ForEach-Object {
    Write-Host "   $($_.Name): $($_.Count) abilities" -ForegroundColor Gray
}

Write-Host ""

# Export to CSV for reference
$outputPath = "Documentation\00_SourcesOfTruth\ImplementedAbilities_Scan.csv"
$results | Export-Csv -Path $outputPath -NoTypeInformation -Encoding UTF8

Write-Host "[SAVE] Results saved to: $outputPath" -ForegroundColor Green
Write-Host ""

# Display first 20 for verification
Write-Host "[SAMPLE] Sample abilities (first 20):" -ForegroundColor Cyan
$results | Select-Object -First 20 | ForEach-Object {
    Write-Host "   $($_.AbilityID) [$($_.FileType)]" -ForegroundColor Gray
}

if ($results.Count -gt 20) {
    Write-Host "   ... and $($results.Count - 20) more" -ForegroundColor Gray
}

Write-Host ""
Write-Host "[COMPLETE] Scan complete!" -ForegroundColor Green
