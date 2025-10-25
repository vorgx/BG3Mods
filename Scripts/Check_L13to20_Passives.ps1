# Check if L13-20 Passives are in Progressions.lsx

$progressionsFile = 'C:\Users\tenod\source\repos\BG3Mods\Data\Public\Warrior_Wow_78fe4967-4e62-5491-d981-dd781acca4d7\Progressions\Progressions.lsx'

Write-Host "=== CHECKING L13-20 PASSIVES IN PROGRESSIONS ===" -ForegroundColor Cyan

$content = Get-Content $progressionsFile

$currentLevel = $null
$currentClass = $null
$passivesFound = @()

for ($i = 0; $i -lt $content.Count; $i++) {
    $line = $content[$i]
    
    # Check for level comment
    if ($line -match '<!-- (\w+) Level (\d+) -->') {
        $currentClass = $matches[1]
        $currentLevel = [int]$matches[2]
    }
    
    # Check for PassivesAdded in L13-20 range
    if ($currentLevel -ge 13 -and $currentLevel -le 20 -and $line -match 'PassivesAdded.*value="([^"]+)"') {
        $passives = $matches[1]
        $passivesFound += [PSCustomObject]@{
            Level = $currentLevel
            Class = $currentClass
            Passives = $passives
            PassiveCount = ($passives -split ';').Count
        }
        
        Write-Host "`nLevel $currentLevel ($currentClass): FOUND PASSIVES!" -ForegroundColor Green
        Write-Host "  Passives: $passives" -ForegroundColor Gray
        Write-Host "  Count: $(($passives -split ';').Count)" -ForegroundColor Gray
    }
}

Write-Host "`n=== SUMMARY ===" -ForegroundColor Cyan

if ($passivesFound.Count -eq 0) {
    Write-Host "❌ NO PASSIVES found in L13-20 progressions!" -ForegroundColor Red
    Write-Host "`nThis means hero talents (L13-20) won't unlock automatically." -ForegroundColor Yellow
    Write-Host "Database shows passive unlocks for these levels, but they're not in Progressions.lsx" -ForegroundColor Yellow
} else {
    Write-Host "✅ Found $($passivesFound.Count) progression nodes with passives in L13-20" -ForegroundColor Green
    
    Write-Host "`nBreakdown by class:" -ForegroundColor Yellow
    $groupedByClass = $passivesFound | Group-Object -Property Class
    foreach ($group in $groupedByClass) {
        $totalPassives = ($group.Group | Measure-Object -Property PassiveCount -Sum).Sum
        Write-Host "  $($group.Name): $($group.Count) levels, $totalPassives total passives" -ForegroundColor Gray
    }
}

Write-Host "`n=== CHECKING DATABASE FOR L13-20 PASSIVE UNLOCKS ===" -ForegroundColor Cyan

$db = Import-Csv 'C:\Users\tenod\source\repos\BG3Mods\Documentation\00_SourcesOfTruth\AbilityDatabase_Warrior_FullyEnriched.csv'

$dbL13to20 = $db | Where-Object { 
    $_.bg3_file_type -eq 'Passive' -and (
        $_.warrior_unlock -ge 13 -or 
        $_.arms_unlock -ge 13 -or 
        $_.fury_unlock -ge 13 -or 
        $_.protection_unlock -ge 13
    )
}

Write-Host "Database shows $($dbL13to20.Count) passives with L13-20 unlocks" -ForegroundColor Gray

if ($dbL13to20.Count -gt 0) {
    Write-Host "`nSample passives from database (L13-20):" -ForegroundColor Yellow
    $dbL13to20 | Select-Object -First 10 | ForEach-Object {
        $unlock = if ($_.warrior_unlock -ge 13) { "Warrior L$($_.warrior_unlock)" }
                  elseif ($_.arms_unlock -ge 13) { "Arms L$($_.arms_unlock)" }
                  elseif ($_.fury_unlock -ge 13) { "Fury L$($_.fury_unlock)" }
                  elseif ($_.protection_unlock -ge 13) { "Protection L$($_.protection_unlock)" }
        
        Write-Host "  $($_.ability_id) ($($_.ability_name)) - $unlock" -ForegroundColor Gray
    }
}

Write-Host "`n=== DIAGNOSIS ===" -ForegroundColor Cyan

if ($passivesFound.Count -eq 0 -and $dbL13to20.Count -gt 0) {
    Write-Host "⚠️ PROBLEM DETECTED:" -ForegroundColor Red
    Write-Host "  - Database has $($dbL13to20.Count) passives for L13-20" -ForegroundColor Yellow
    Write-Host "  - Progressions.lsx has 0 passive grants for L13-20" -ForegroundColor Yellow
    Write-Host "`nSOLUTION: Re-run Generate_Progressions.ps1 - it should pick up these passives" -ForegroundColor Green
} elseif ($passivesFound.Count -gt 0) {
    Write-Host "✅ Hero talents should unlock correctly at L13-20!" -ForegroundColor Green
}
