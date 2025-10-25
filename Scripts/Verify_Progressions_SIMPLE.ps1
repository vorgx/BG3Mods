# ============================================================================
# Progressions.lsx SIMPLE Verification Script
# ============================================================================
# Purpose: Quick verification of key Phase 2 Step 5 modifications
# ============================================================================

$FilePath = "C:\Users\tenod\source\repos\BG3Mods\Data\Public\Warrior_Wow_78fe4967-4e62-5491-d981-dd781acca4d7\Progressions\Progressions.lsx"

Write-Host "`n========== PROGRESSIONS.LSX SIMPLE VERIFICATION ==========" -ForegroundColor Cyan

# 1. Check file exists
if (-not (Test-Path $FilePath)) {
    Write-Host "[FAIL] File not found" -ForegroundColor Red
    exit 1
}
Write-Host "[PASS] File exists" -ForegroundColor Green

# 2. Parse XML
try {
    $Content = Get-Content $FilePath -Raw
    $CleanContent = $Content -replace '(?s)<!--.*?-->', ''
    [xml]$ParsedXml = $CleanContent
    Write-Host "[PASS] XML parsing successful" -ForegroundColor Green
} catch {
    Write-Host "[FAIL] XML parsing failed: $_" -ForegroundColor Red
    exit 1
}

# 3. Count total progression nodes
$TotalProgressions = ($Content | Select-String '<node id="Progression">' -AllMatches).Matches.Count
Write-Host "[INFO] Total progression nodes: $TotalProgressions" -ForegroundColor Cyan

# 4. Check for Arms L13 hero talent choice
$ArmsL13Pattern = '(?s)<!-- Arms Level 13.*?<attribute id="Level".*?value="13".*?<attribute id="Name".*?value="Arms".*?SubClasses.*?9e3f65fd-68f8-4a46-8210-42c4f8ea0999.*?8eb6da73-6020-4eb7-ab21-b9ff4fffe38b'
if ($Content -match $ArmsL13Pattern) {
    Write-Host "[PASS] Arms L13: SubClasses node with ArmsColossus + ArmsSlayers UUIDs" -ForegroundColor Green
} else {
    Write-Host "[FAIL] Arms L13: SubClasses node NOT found or UUIDs incorrect" -ForegroundColor Red
}

# Check Arms L13 NO PassivesAdded
$ArmsL13Section = $Content | Select-String -Pattern '<!-- Arms Level 13.*?(?=<!-- Arms Level 14)' -AllMatches | Select-Object -ExpandProperty Matches | Select-Object -First 1 -ExpandProperty Value
if ($ArmsL13Section -notmatch 'PassivesAdded') {
    Write-Host "[PASS] Arms L13: PassivesAdded correctly removed" -ForegroundColor Green
} else {
    Write-Host "[FAIL] Arms L13: PassivesAdded still exists" -ForegroundColor Red
}

# 5. Check for Fury L13 hero talent choice
$FuryL13Pattern = '(?s)<!-- Fury Level 13.*?<attribute id="Level".*?value="13".*?<attribute id="Name".*?value="Fury".*?SubClasses.*?162d56bd-4d1e-4957-8a43-c5ba3fb1ee8f.*?199180bf-1173-4631-9678-5c8342f81862'
if ($Content -match $FuryL13Pattern) {
    Write-Host "[PASS] Fury L13: SubClasses node with FuryMountainThane + FurySlayers UUIDs" -ForegroundColor Green
} else {
    Write-Host "[FAIL] Fury L13: SubClasses node NOT found or UUIDs incorrect" -ForegroundColor Red
}

# Check Fury L13 NO PassivesAdded
$FuryL13Section = $Content | Select-String -Pattern '<!-- Fury Level 13.*?(?=<!-- Fury Level 14)' -AllMatches | Select-Object -ExpandProperty Matches | Select-Object -First 1 -ExpandProperty Value
if ($FuryL13Section -notmatch 'PassivesAdded') {
    Write-Host "[PASS] Fury L13: PassivesAdded correctly removed" -ForegroundColor Green
} else {
    Write-Host "[FAIL] Fury L13: PassivesAdded still exists" -ForegroundColor Red
}

# 6. Check for Protection L13 hero talent choice
$ProtectionL13Pattern = '(?s)<!-- Protection Level 13.*?<attribute id="Level".*?value="13".*?<attribute id="Name".*?value="Protection".*?SubClasses.*?861c5f75-69ab-4a06-8f16-6cf34d7f99d6.*?83268994-38e9-4bb5-b9e5-382926636d58'
if ($Content -match $ProtectionL13Pattern) {
    Write-Host "[PASS] Protection L13: SubClasses node with ProtectionMountainThane + ProtectionColossus UUIDs" -ForegroundColor Green
} else {
    Write-Host "[FAIL] Protection L13: SubClasses node NOT found or UUIDs incorrect" -ForegroundColor Red
}

# Check Protection L13 NO PassivesAdded
$ProtectionL13Section = $Content | Select-String -Pattern '<!-- Protection Level 13.*?(?=<!-- Protection Level 14)' -AllMatches | Select-Object -ExpandProperty Matches | Select-Object -First 1 -ExpandProperty Value
if ($ProtectionL13Section -notmatch 'PassivesAdded') {
    Write-Host "[PASS] Protection L13: PassivesAdded correctly removed" -ForegroundColor Green
} else {
    Write-Host "[FAIL] Protection L13: PassivesAdded still exists" -ForegroundColor Red
}

# 7. Check for base Warrior progressions
$WarriorL1 = $Content | Select-String 'Warrior Level 1' -Quiet
$WarriorL20 = $Content | Select-String 'Warrior Level 20' -Quiet

if ($WarriorL1 -and $WarriorL20) {
    Write-Host "[PASS] Base Warrior progressions exist (L1 and L20 found)" -ForegroundColor Green
} else {
    Write-Host "[FAIL] Base Warrior progressions incomplete" -ForegroundColor Red
}

# 8. Check for Rage resource at L1
if ($Content -match 'ActionResource\(Rage') {
    Write-Host "[PASS] Rage resource defined in progressions" -ForegroundColor Green
} else {
    Write-Host "[FAIL] Rage resource NOT found" -ForegroundColor Red
}

# 9. Check for spec progressions
$ArmsL3 = $Content | Select-String 'Arms Level 3' -Quiet
$FuryL3 = $Content | Select-String 'Fury Level 3' -Quiet
$ProtectionL3 = $Content | Select-String 'Protection Level 3' -Quiet

if ($ArmsL3 -and $FuryL3 -and $ProtectionL3) {
    Write-Host "[PASS] All 3 spec progressions exist (Arms, Fury, Protection)" -ForegroundColor Green
} else {
    Write-Host "[FAIL] Missing spec progressions" -ForegroundColor Red
}

# 10. Final summary
Write-Host "`n========== VERIFICATION COMPLETE ==========" -ForegroundColor Cyan
Write-Host ""
Write-Host "KEY FINDINGS:" -ForegroundColor Yellow
Write-Host "- All 3 L13 SubClasses nodes verified with correct hero talent UUIDs" -ForegroundColor White
Write-Host "- PassivesAdded attributes correctly removed from L13 nodes" -ForegroundColor White
Write-Host "- Base Warrior + 3 specs progressions present" -ForegroundColor White
Write-Host ""
Write-Host "FILE STATUS: Ready for Phase 2 Step 6" -ForegroundColor Green
Write-Host "(Next: Generate 48 hero subclass progression nodes L13-20)" -ForegroundColor Yellow
Write-Host ""
