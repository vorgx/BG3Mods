# Analyze Hero Talents from LINKED CSV (L13-20)

$linkedCsv = 'C:\Users\tenod\source\repos\BG3Mods\Documentation\00_SourcesOfTruth\Warrior Progression LINKED - Main.csv'

Write-Host "=== ANALYZING HERO TALENTS FROM LINKED CSV (L13-20) ===" -ForegroundColor Cyan

# Read the file manually to handle the complex multi-row header
$lines = Get-Content $linkedCsv

# Parse column positions for hero talent columns (3-row header structure)
# Mountain Thane: columns 53-57
# Colossus: columns 58-62
# Slayers: columns 63-67

Write-Host "`nHero Talent Column Groups:" -ForegroundColor Yellow
Write-Host "  Mountain Thane (Protection & Fury): Columns 53-57" -ForegroundColor Gray
Write-Host "  Colossus (Arms & Protection): Columns 58-62" -ForegroundColor Gray
Write-Host "  Slayers (Arms & Fury): Columns 63-67" -ForegroundColor Gray

# Process L13-20 rows
Write-Host "`n=== LEVEL 13-20 HERO TALENT GRANTS ===" -ForegroundColor Cyan

for ($i = 3; $i -lt $lines.Count; $i++) {
    $row = $lines[$i] -split ','
    $level = $row[1]
    
    if ($level -match 'Level (\d+)') {
        $levelNum = [int]$matches[1]
        
        if ($levelNum -ge 13 -and $levelNum -le 20) {
            Write-Host "`n--- LEVEL $levelNum ---" -ForegroundColor Green
            
            # Mountain Thane talents (columns 53-57)
            $mtTalents = @()
            for ($j = 53; $j -le 57; $j++) {
                if ($row[$j] -and $row[$j].Trim()) {
                    $mtTalents += $row[$j].Trim()
                }
            }
            if ($mtTalents.Count -gt 0) {
                Write-Host "  Mountain Thane (Protection & Fury):" -ForegroundColor Yellow
                foreach ($talent in $mtTalents) {
                    Write-Host "    - $talent" -ForegroundColor Gray
                }
            }
            
            # Colossus talents (columns 58-62)
            $colossusTalents = @()
            for ($j = 58; $j -le 62; $j++) {
                if ($row[$j] -and $row[$j].Trim()) {
                    $colossusTalents += $row[$j].Trim()
                }
            }
            if ($colossusTalents.Count -gt 0) {
                Write-Host "  Colossus (Arms & Protection):" -ForegroundColor Yellow
                foreach ($talent in $colossusTalents) {
                    Write-Host "    - $talent" -ForegroundColor Gray
                }
            }
            
            # Slayers talents (columns 63-67)
            $slayersTalents = @()
            for ($j = 63; $j -le 67; $j++) {
                if ($row[$j] -and $row[$j].Trim()) {
                    $slayersTalents += $row[$j].Trim()
                }
            }
            if ($slayersTalents.Count -gt 0) {
                Write-Host "  Slayers (Arms & Fury):" -ForegroundColor Yellow
                foreach ($talent in $slayersTalents) {
                    Write-Host "    - $talent" -ForegroundColor Gray
                }
            }
            
            if ($mtTalents.Count -eq 0 -and $colossusTalents.Count -eq 0 -and $slayersTalents.Count -eq 0) {
                Write-Host "  (No hero talents this level)" -ForegroundColor DarkGray
            }
        }
    }
}

Write-Host "`n=== WHAT SHOULD BE IN PROGRESSIONS.LSX ===" -ForegroundColor Cyan
Write-Host "`nProtection Subclass (L13-20):" -ForegroundColor Yellow
Write-Host "  - Should have Mountain Thane talents" -ForegroundColor Gray
Write-Host "  - Should have Colossus talents" -ForegroundColor Gray
Write-Host "  - Should NOT have Slayers talents" -ForegroundColor Gray

Write-Host "`nFury Subclass (L13-20):" -ForegroundColor Yellow
Write-Host "  - Should have Mountain Thane talents" -ForegroundColor Gray
Write-Host "  - Should have Slayers talents" -ForegroundColor Gray
Write-Host "  - Should NOT have Colossus talents" -ForegroundColor Gray

Write-Host "`nArms Subclass (L13-20):" -ForegroundColor Yellow
Write-Host "  - Should have Colossus talents" -ForegroundColor Gray
Write-Host "  - Should have Slayers talents" -ForegroundColor Gray
Write-Host "  - Should NOT have Mountain Thane talents" -ForegroundColor Gray

Write-Host "`n⚠️ PROBLEM: The database unlock columns are wrong!" -ForegroundColor Red
Write-Host "The LINKED CSV has the CORRECT hero talent assignments per spec." -ForegroundColor Yellow
Write-Host "The database needs hero_talent_tree column to properly assign talents." -ForegroundColor Yellow
