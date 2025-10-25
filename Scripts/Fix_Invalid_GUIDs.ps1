# Fix Invalid GUIDs - Oct 24, 2025
# Problem: 7 GUIDs contain invalid characters (g-z), causing BG3 to reject the mod
# Solution: Replace with valid GUIDs (0-9, a-f only)

$ErrorActionPreference = 'Stop'

# Mapping: Old GUID → New Valid GUID → Subclass Name
$GuidMapping = @{
    '7b2c9d4e-8f0g-5b6c-9d7e-0f1g2b3c4d5e' = @{ New = '5e34e41a-f929-47d5-aecb-3f48df5167c6'; Name = 'ArmsSlayers' }
    '8c3d0e5f-9g1h-6c7d-0e8f-1g2h3c4d5e6f' = @{ New = '20d4f33d-b5f4-4f85-9039-715341d2fa83'; Name = 'FuryMountainThane' }
    '9d4e1f6g-0h2i-7d8e-1f9g-2h3i4d5e6f7g' = @{ New = 'c79e7ba2-a49e-4d16-a611-1fa5f4dc7190'; Name = 'FurySlayers' }
    'e4d6b5g3-9c7f-5b2e-ad8g-3f9c6b4d2e0g' = @{ New = 'b82a148a-f506-4e34-ba56-150ce01eeeba'; Name = 'FuryWarrior' }
    '0e5f2g7h-1i3j-8e9f-2g0h-3i4j5e6f7g8h' = @{ New = 'aee4f826-ae7c-42eb-b26d-69403370b122'; Name = 'ProtectionMountainThane' }
    '1f6g3h8i-2j4k-9f0g-3h1i-4j5k6f7g8h9i' = @{ New = 'edf56aa2-5f99-4971-ae64-6ac26f3cf004'; Name = 'ProtectionColossus' }
    'f5e7c6h4-ad8g-6c3f-be9h-4g0d7c5e3f1h' = @{ New = '59d97f4c-ea6f-48cb-a284-0a4f17917afe'; Name = 'ProtectionWarrior' }
}

# Files to update
$FilesToUpdate = @(
    'Data\Public\Warrior_Wow_78fe4967-4e62-5491-d981-dd781acca4d7\ClassDescriptions\ClassDescriptions.lsx'
    'Data\Public\Warrior_Wow_78fe4967-4e62-5491-d981-dd781acca4d7\Progressions\Progressions.lsx'
    'Data\Public\Warrior_Wow_78fe4967-4e62-5491-d981-dd781acca4d7\Lists\SpellLists.lsx'
    'Scripts\Generate_HeroSubclass_Progressions.ps1'
    'Scripts\Validate_HeroSubclass_Progressions.ps1'
    'Scripts\SpellList_UUID_Mapping.csv'
    'Scripts\Validate_HeroSubclass_SpellLists.ps1'
    'Scripts\HeroSubclass_SpellLists_Generated.xml'
)

Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host "FIXING INVALID GUIDS" -ForegroundColor Yellow
Write-Host "========================================`n" -ForegroundColor Cyan

$TotalReplacements = 0

foreach ($OldGuid in $GuidMapping.Keys) {
    $NewGuid = $GuidMapping[$OldGuid].New
    $SubclassName = $GuidMapping[$OldGuid].Name
    
    Write-Host "Replacing: $SubclassName" -ForegroundColor Cyan
    Write-Host "  Old (INVALID): $OldGuid" -ForegroundColor Red
    Write-Host "  New (VALID):   $NewGuid" -ForegroundColor Green
    
    $ReplacementCount = 0
    
    foreach ($File in $FilesToUpdate) {
        if (Test-Path $File) {
            $Content = Get-Content $File -Raw
            $OccurrenceCount = ([regex]::Matches($Content, [regex]::Escape($OldGuid))).Count
            
            if ($OccurrenceCount -gt 0) {
                $Content = $Content -replace [regex]::Escape($OldGuid), $NewGuid
                Set-Content -Path $File -Value $Content -NoNewline
                $ReplacementCount += $OccurrenceCount
                Write-Host "    [OK] $File ($OccurrenceCount replacements)" -ForegroundColor White
            }
        }
    }
    
    $TotalReplacements += $ReplacementCount
    Write-Host "  Subtotal: $ReplacementCount replacements`n" -ForegroundColor Gray
}

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "[SUCCESS] COMPLETE: $TotalReplacements total replacements" -ForegroundColor Green
Write-Host "========================================`n" -ForegroundColor Cyan

# Display mapping table for documentation
Write-Host "GUID MAPPING TABLE (for documentation):`n" -ForegroundColor Yellow
Write-Host "Subclass | Old GUID | New GUID" -ForegroundColor White
Write-Host "---------|----------|----------" -ForegroundColor White
foreach ($OldGuid in $GuidMapping.Keys | Sort-Object) {
    $NewGuid = $GuidMapping[$OldGuid].New
    $Name = $GuidMapping[$OldGuid].Name
    Write-Host "$Name | $OldGuid | $NewGuid" -ForegroundColor White
}
Write-Host ""
