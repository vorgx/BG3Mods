$DbPath = "C:\Users\tenod\source\repos\BG3Mods\Documentation\00_SourcesOfTruth\AbilityDatabase_Warrior_FullyEnriched.csv"
$Db = Import-Csv -Path $DbPath

# Filter for abilities with actual WAR_* status effects
$validStatuses = $Db | Where-Object { $_.status_applied -like 'WAR_*' }

Write-Host "`n=== ABILITIES WITH WAR_* STATUS EFFECTS ===" -ForegroundColor Cyan
Write-Host "Found $($validStatuses.Count) abilities" -ForegroundColor Green

$validStatuses | Select-Object ability_id, ability_name, status_applied, bg3_file_type | Format-Table -AutoSize

# Extract unique WAR_* status names
$warStatuses = @()
foreach ($row in $validStatuses) {
    $statusList = $row.status_applied -split ',' | ForEach-Object { $_.Trim() } | Where-Object { $_ -like 'WAR_*' }
    $warStatuses += $statusList
}
$uniqueWarStatuses = $warStatuses | Sort-Object -Unique

Write-Host "`n=== UNIQUE WAR_* STATUS EFFECTS ===" -ForegroundColor Yellow
Write-Host "Total: $($uniqueWarStatuses.Count)" -ForegroundColor Green
$uniqueWarStatuses | ForEach-Object { Write-Host "  $_" -ForegroundColor Cyan }

# Create detailed status info
$statusDetails = @()
foreach ($status in $uniqueWarStatuses) {
    $sources = $validStatuses | Where-Object { $_.status_applied -like "*$status*" }
    $statusDetails += [PSCustomObject]@{
        StatusName = $status
        SourceCount = $sources.Count
        SourceAbilities = ($sources.ability_id -join ", ")
        SourceNames = ($sources.ability_name -join ", ")
    }
}

Write-Host "`n=== STATUS DETAILS ===" -ForegroundColor Yellow
$statusDetails | Format-Table -AutoSize -Wrap

# Export for generation
$statusDetails | Export-Csv -Path "C:\Users\tenod\source\repos\BG3Mods\Scripts\WAR_Status_Effects.csv" -NoTypeInformation
Write-Host "`nExported to: Scripts\WAR_Status_Effects.csv" -ForegroundColor Green
