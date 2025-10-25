$DbPath = "C:\Users\tenod\source\repos\BG3Mods\Documentation\00_SourcesOfTruth\AbilityDatabase_Warrior_FullyEnriched.csv"
$Db = Import-Csv -Path $DbPath

Write-Host "`n=== DATABASE STATUS EFFECT ANALYSIS ===" -ForegroundColor Cyan

# 1. Check bg3_file_type column for status-related values
Write-Host "`n[1] Checking bg3_file_type column for Status entries:" -ForegroundColor Yellow
$fileTypes = $Db | Group-Object bg3_file_type | Sort-Object Count -Descending
$fileTypes | Select-Object Name, Count | Format-Table -AutoSize

# 2. Check for entries with status_applied values
Write-Host "`n[2] Checking status_applied column (non-empty values):" -ForegroundColor Yellow
$withStatus = $Db | Where-Object { $_.status_applied -ne "" -and $_.status_applied -ne $null }
Write-Host "Found $($withStatus.Count) abilities that apply status effects" -ForegroundColor Green
if ($withStatus.Count -gt 0) {
    Write-Host "`nSample (first 15):" -ForegroundColor Gray
    $withStatus | Select-Object -First 15 ability_id, ability_name, status_applied, bg3_file_type | Format-Table -AutoSize
}

# 3. Extract unique status effect names
Write-Host "`n[3] Extracting unique status effect names from status_applied column:" -ForegroundColor Yellow
$allStatuses = @()
foreach ($row in $withStatus) {
    $statusList = $row.status_applied -split ',' | ForEach-Object { $_.Trim() }
    $allStatuses += $statusList
}
$uniqueStatuses = $allStatuses | Where-Object { $_ -ne "" -and $_ -ne "None - Damage Only" -and $_ -ne "None" } | Sort-Object -Unique
Write-Host "Found $($uniqueStatuses.Count) unique status effects referenced:" -ForegroundColor Green
$uniqueStatuses | ForEach-Object { Write-Host "  - $_" -ForegroundColor Cyan }

# 4. Check bg3_mechanic_equivalent for status references
Write-Host "`n[4] Checking bg3_mechanic_equivalent column for ApplyStatus functors:" -ForegroundColor Yellow
$withApplyStatus = $Db | Where-Object { $_.bg3_mechanic_equivalent -like "*ApplyStatus*" }
Write-Host "Found $($withApplyStatus.Count) abilities with ApplyStatus functors" -ForegroundColor Green
if ($withApplyStatus.Count -gt 0) {
    Write-Host "`nSample (first 10):" -ForegroundColor Gray
    $withApplyStatus | Select-Object -First 10 ability_id, ability_name, bg3_mechanic_equivalent | Format-Table -AutoSize -Wrap
}

# 5. Check ability_type for status-like categories
Write-Host "`n[5] Checking ability_type column for status-related types:" -ForegroundColor Yellow
$abilityTypes = $Db | Group-Object ability_type | Sort-Object Count -Descending
$abilityTypes | Select-Object Name, Count | Format-Table -AutoSize

# 6. Export status effect list for Status_BOOST generation
Write-Host "`n[6] Exporting unique status effects to CSV:" -ForegroundColor Yellow
$statusExport = $uniqueStatuses | ForEach-Object { 
    [PSCustomObject]@{
        StatusName = $_
        SourceAbilities = ($withStatus | Where-Object { $_.status_applied -like "*$_*" }).ability_id -join ", "
    }
}
$statusExport | Export-Csv -Path "C:\Users\tenod\source\repos\BG3Mods\Scripts\Status_Effects_List.csv" -NoTypeInformation
Write-Host "Exported to: Scripts\Status_Effects_List.csv" -ForegroundColor Green

Write-Host "`n=== SUMMARY ===" -ForegroundColor Cyan
Write-Host "Total abilities in database: $($Db.Count)" -ForegroundColor White
Write-Host "Abilities applying status effects: $($withStatus.Count)" -ForegroundColor White
Write-Host "Unique status effects found: $($uniqueStatuses.Count)" -ForegroundColor White
Write-Host "Abilities with ApplyStatus functors: $($withApplyStatus.Count)" -ForegroundColor White
