# Check what passives are assigned to L13-20 in the database

$database = Import-Csv "C:\Users\tenod\source\repos\BG3Mods\Documentation\00_SourcesOfTruth\AbilityDatabase_Warrior_FullyEnriched.csv"
$passives = $database | Where-Object { $_.bg3_file_type -eq 'Passive' }

Write-Host "=== DATABASE PASSIVES FOR L13-20 ===" -ForegroundColor Cyan

foreach ($spec in @("arms", "fury", "protection")) {
    Write-Host "`n$($spec.ToUpper()) SUBCLASS:" -ForegroundColor Yellow
    $column = "${spec}_unlock"
    
    foreach ($level in @(13, 14, 15, 16, 17, 18, 19, 20)) {
        $levelPassives = $passives | Where-Object { $_.$column -eq $level }
        if ($levelPassives) {
            Write-Host "  L$level : $($levelPassives.Count) passives" -ForegroundColor Gray
            foreach ($p in $levelPassives) {
                Write-Host "    - $($p.ability_id)" -ForegroundColor White
            }
        } else {
            Write-Host "  L$level : NO passives in database" -ForegroundColor Green
        }
    }
}
