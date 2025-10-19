# Validation Script: Check All Referenced Spells Exist

$ErrorActionPreference = "Stop"

Write-Host "`n╔═══════════════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║  SPELL REFERENCE VALIDATION                      ║" -ForegroundColor Cyan
Write-Host "╚═══════════════════════════════════════════════════╝`n" -ForegroundColor Cyan

$progressions = "Data\Public\BG3Wow_78fe4967-4e62-5491-d981-dd781acca4d7\Progressions\Progressions.lsx"
$statsPath = "Data\Public\BG3Wow_78fe4967-4e62-5491-d981-dd781acca4d7\Stats\Generated\Data"

# Extract all spells
$lines = Select-String -Path $progressions -Pattern 'AddSpells' | Select-Object -ExpandProperty Line
$allSpells = @()
$lines | ForEach-Object {
    if ($_ -match 'value="([^"]+)"') {
        $spells = $matches[1] -split ';'
        $allSpells += $spells
    }
}

$uniqueSpells = $allSpells | Sort-Object -Unique

Write-Host "📊 Total unique spells referenced: $($uniqueSpells.Count)`n" -ForegroundColor Yellow

# Check each spell
$found = @()
$missing = @()

foreach ($spell in $uniqueSpells) {
    $exists = $false
    
    # Check all Spell_*.txt files
    Get-ChildItem "$statsPath\Spell_*.txt" | ForEach-Object {
        if (Select-String -Path $_.FullName -Pattern "^new entry `"$spell`"" -Quiet) {
            $exists = $true
            $found += [PSCustomObject]@{
                Spell = $spell
                File = $_.Name
            }
        }
    }
    
    if (-not $exists) {
        $missing += $spell
    }
}

# Report
Write-Host "✅ FOUND ($($found.Count) spells):" -ForegroundColor Green
$found | Sort-Object File,Spell | Format-Table -AutoSize

if ($missing.Count -gt 0) {
    Write-Host "`n❌ MISSING ($($missing.Count) spells):" -ForegroundColor Red
    $missing | ForEach-Object { 
        Write-Host "  - $_" -ForegroundColor Red 
    }
    Write-Host "`n🔥 THIS IS LIKELY THE CRASH CAUSE!" -ForegroundColor Red
    Write-Host "The game tries to grant these spells but can't find them in stat files.`n" -ForegroundColor Yellow
} else {
    Write-Host "`n✅ ALL SPELLS FOUND! Spells are not the problem.`n" -ForegroundColor Green
}

Write-Host "═══════════════════════════════════════════════════`n" -ForegroundColor Cyan
