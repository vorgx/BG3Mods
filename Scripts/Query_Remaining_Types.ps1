$DbPath = "C:\Users\tenod\source\repos\BG3Mods\Documentation\00_SourcesOfTruth\AbilityDatabase_Warrior_FullyEnriched.csv"
$Db = Import-Csv -Path $DbPath

Write-Host "`n=== REMAINING SPELL TYPES ===" -ForegroundColor Cyan

# Spell_Shout
$Shout = $Db | Where-Object { $_.bg3_file_type -eq "Spell_Shout" }
Write-Host "`nSpell_Shout: $($Shout.Count) abilities" -ForegroundColor Yellow
$Shout | Select-Object ability_id, ability_name | Format-Table -AutoSize

# Spell_Jump
$Jump = $Db | Where-Object { $_.bg3_file_type -eq "Spell_Jump" }
Write-Host "Spell_Jump: $($Jump.Count) abilities" -ForegroundColor Yellow
$Jump | Select-Object ability_id, ability_name | Format-Table -AutoSize

# Spell_Projectile
$Projectile = $Db | Where-Object { $_.bg3_file_type -eq "Spell_Projectile" }
Write-Host "Spell_Projectile: $($Projectile.Count) abilities" -ForegroundColor Yellow
$Projectile | Select-Object ability_id, ability_name | Format-Table -AutoSize

# Status
$Status = $Db | Where-Object { $_.bg3_file_type -eq "Status" }
Write-Host "Status_BOOST: $($Status.Count) status effects" -ForegroundColor Yellow
Write-Host "(showing first 10):" -ForegroundColor Gray
$Status | Select-Object -First 10 ability_id, ability_name | Format-Table -AutoSize

Write-Host "`nTOTAL REMAINING:" -ForegroundColor Green
Write-Host "  Spell_Shout: $($Shout.Count)" -ForegroundColor Cyan
Write-Host "  Spell_Jump: $($Jump.Count)" -ForegroundColor Cyan
Write-Host "  Spell_Projectile: $($Projectile.Count)" -ForegroundColor Cyan
Write-Host "  Status_BOOST: $($Status.Count)" -ForegroundColor Cyan
Write-Host "  TOTAL: $(($Shout.Count + $Jump.Count + $Projectile.Count + $Status.Count))" -ForegroundColor Green
