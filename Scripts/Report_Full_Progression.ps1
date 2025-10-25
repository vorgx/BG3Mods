# Full L1-20 Progression Report for All Classes/Subclasses

$progressionsFile = 'C:\Users\tenod\source\repos\BG3Mods\Data\Public\Warrior_Wow_78fe4967-4e62-5491-d981-dd781acca4d7\Progressions\Progressions.lsx'
$spellListsFile = 'C:\Users\tenod\source\repos\BG3Mods\Data\Public\Warrior_Wow_78fe4967-4e62-5491-d981-dd781acca4d7\Lists\SpellLists.lsx'

Write-Host "=== WARRIOR CLASS PROGRESSION (L1-20) ===" -ForegroundColor Cyan
Write-Host "Full breakdown of what unlocks at each level`n" -ForegroundColor Gray

# Parse Progressions.lsx
[xml]$progressions = Get-Content $progressionsFile

# Parse SpellLists.lsx
[xml]$spellLists = Get-Content $spellListsFile

# Build spell list lookup
$spellListLookup = @{}
foreach ($list in $spellLists.save.region.node.children.node) {
    $uuid = $list.attribute | Where-Object { $_.id -eq 'UUID' } | Select-Object -ExpandProperty value
    $spells = $list.attribute | Where-Object { $_.id -eq 'Spells' } | Select-Object -ExpandProperty value
    $comment = $list.attribute | Where-Object { $_.id -eq 'Comment' } | Select-Object -ExpandProperty value
    $spellListLookup[$uuid] = @{
        Spells = $spells
        Comment = $comment
    }
}

# Process each class
$classes = @('Warrior', 'Arms', 'Fury', 'Protection')

foreach ($className in $classes) {
    Write-Host "`n================================================" -ForegroundColor Cyan
    Write-Host "  $className CLASS PROGRESSION" -ForegroundColor Yellow
    Write-Host "================================================`n" -ForegroundColor Cyan
    
    $classProgression = $progressions.save.region.node.children.node | Where-Object {
        ($_.attribute | Where-Object { $_.id -eq 'Name' }).value -eq $className
    } | Sort-Object { [int]($_.attribute | Where-Object { $_.id -eq 'Level' }).value }
    
    foreach ($prog in $classProgression) {
        $level = ($prog.attribute | Where-Object { $_.id -eq 'Level' }).value
        $boosts = ($prog.attribute | Where-Object { $_.id -eq 'Boosts' }).value
        $passives = ($prog.attribute | Where-Object { $_.id -eq 'PassivesAdded' }).value
        
        # Get spell list
        $spellListUuid = ($prog.children.node.children.node.attribute | Where-Object { $_.id -eq 'UUID' }).value
        $spellsGranted = if ($spellListUuid -and $spellListLookup[$spellListUuid]) {
            $spellListLookup[$spellListUuid].Spells
        } else {
            $null
        }
        
        Write-Host "LEVEL $level" -ForegroundColor Green
        Write-Host "-------" -ForegroundColor Gray
        
        # Boosts
        if ($boosts) {
            Write-Host "  Boosts:" -ForegroundColor Yellow
            foreach ($boost in ($boosts -split ';')) {
                Write-Host "    - $boost" -ForegroundColor Gray
            }
        }
        
        # Passives
        if ($passives) {
            Write-Host "  Passives Granted:" -ForegroundColor Yellow
            foreach ($passive in ($passives -split ';')) {
                Write-Host "    - $passive" -ForegroundColor Gray
            }
        }
        
        # Spells
        if ($spellsGranted) {
            Write-Host "  Spells Granted:" -ForegroundColor Yellow
            foreach ($spell in ($spellsGranted -split ';')) {
                Write-Host "    - $spell" -ForegroundColor Gray
            }
        }
        
        # Empty level indicator
        if (-not $boosts -and -not $passives -and -not $spellsGranted) {
            Write-Host "  (No new abilities this level)" -ForegroundColor DarkGray
        }
        
        Write-Host ""
    }
    
    # Summary for this class
    $totalLevels = $classProgression.Count
    $totalPassives = ($classProgression.attribute | Where-Object { $_.id -eq 'PassivesAdded' } | ForEach-Object { ($_.value -split ';').Count } | Measure-Object -Sum).Sum
    $totalSpells = 0
    foreach ($prog in $classProgression) {
        $spellListUuid = ($prog.children.node.children.node.attribute | Where-Object { $_.id -eq 'UUID' }).value
        if ($spellListUuid -and $spellListLookup[$spellListUuid]) {
            $totalSpells += ($spellListLookup[$spellListUuid].Spells -split ';').Count
        }
    }
    
    Write-Host "SUMMARY:" -ForegroundColor Cyan
    Write-Host "  Total progression levels: $totalLevels" -ForegroundColor Gray
    Write-Host "  Total passives granted: $totalPassives" -ForegroundColor Gray
    Write-Host "  Total spells granted: $totalSpells" -ForegroundColor Gray
    Write-Host ""
}

# Create summary table
Write-Host "`n================================================" -ForegroundColor Cyan
Write-Host "  OVERALL SUMMARY" -ForegroundColor Yellow
Write-Host "================================================`n" -ForegroundColor Cyan

$summaryData = @()

foreach ($className in $classes) {
    $classProgression = $progressions.save.region.node.children.node | Where-Object {
        ($_.attribute | Where-Object { $_.id -eq 'Name' }).value -eq $className
    }
    
    $levels = $classProgression.Count
    $passiveCount = ($classProgression.attribute | Where-Object { $_.id -eq 'PassivesAdded' } | ForEach-Object { ($_.value -split ';').Count } | Measure-Object -Sum).Sum
    
    $spellCount = 0
    foreach ($prog in $classProgression) {
        $spellListUuid = ($prog.children.node.children.node.attribute | Where-Object { $_.id -eq 'UUID' }).value
        if ($spellListUuid -and $spellListLookup[$spellListUuid]) {
            $spellCount += ($spellListLookup[$spellListUuid].Spells -split ';').Count
        }
    }
    
    $summaryData += [PSCustomObject]@{
        Class = $className
        Levels = $levels
        Passives = $passiveCount
        Spells = $spellCount
        Total = $passiveCount + $spellCount
    }
}

$summaryData | Format-Table -AutoSize

Write-Host "`nNOTES:" -ForegroundColor Yellow
Write-Host "  - Base Warrior class: L1-20 (all players get these)" -ForegroundColor Gray
Write-Host "  - Subclasses: L3-20 (chosen at level 3)" -ForegroundColor Gray
Write-Host "  - L1-12: Spells + Passives (core abilities)" -ForegroundColor Gray
Write-Host "  - L13-20: Passives only (hero talents)" -ForegroundColor Gray
Write-Host "  - BG3 current level cap: 12 (L13-20 ready for future expansion)" -ForegroundColor Gray
