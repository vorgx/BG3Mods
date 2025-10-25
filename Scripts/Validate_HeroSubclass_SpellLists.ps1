param(
    [Parameter(Mandatory=$true)]
    [string]$FilePath,
    
    [Parameter(Mandatory=$false)]
    [string]$CsvPath = ".\SpellList_UUID_Mapping.csv"
)

Write-Host "`n[PHASE 3 SPELLLISTS VALIDATION]" -ForegroundColor Cyan
Write-Host "=" * 80 -ForegroundColor Cyan

$FailCount = 0

# Helper functions
function Write-Pass { param($Message) Write-Host "[PASS] $Message" -ForegroundColor Green }
function Write-Fail { param($Message) Write-Host "[FAIL] $Message" -ForegroundColor Red; $script:FailCount++ }
function Write-Info { param($Message) Write-Host "[INFO] $Message" -ForegroundColor Cyan }

# Step 1: Parse XML
Write-Host "`n[STEP 1] Loading SpellLists.lsx..." -ForegroundColor Yellow
try {
    $RawContent = Get-Content $FilePath -Raw
    # Don't remove comments - BG3 XML parser handles them fine
    [xml]$Xml = $RawContent
    Write-Pass "XML parsed successfully"
} catch {
    Write-Fail "XML parse error: $_"
    exit 1
}

# Step 2: Get all SpellList nodes
$RootNode = $Xml.save.region.node
$AllSpellLists = $RootNode.children.node | Where-Object { $_.id -eq 'SpellList' }
Write-Info "Found $($AllSpellLists.Count) total SpellList nodes"

# Step 3: Load expected UUIDs from CSV
Write-Host "`n[STEP 2] Loading expected UUIDs from CSV..." -ForegroundColor Yellow
$Csv = Import-Csv $CsvPath
$HeroEntries = $Csv | Where-Object { 
    [int]$_.Level -ge 13 -and $_.Spec -match "(Colossus|Slayers|MountainThane)"
}
Write-Info "Expected $($HeroEntries.Count) hero subclass SpellLists"

if ($HeroEntries.Count -ne 30) {
    Write-Fail "CSV should have 30 hero subclass entries, found $($HeroEntries.Count)"
}

# Step 4: Validate each hero subclass SpellList
Write-Host "`n[STEP 3] Validating hero subclass SpellLists..." -ForegroundColor Yellow

$HeroSubclasses = @{
    "ArmsColossus" = "6a1b8c3d-7e9f-4a5b-8c6d-9e0f1a2b3c4d"
    "ArmsSlayers" = "5e34e41a-f929-47d5-aecb-3f48df5167c6"
    "FuryMountainThane" = "20d4f33d-b5f4-4f85-9039-715341d2fa83"
    "FurySlayers" = "c79e7ba2-a49e-4d16-a611-1fa5f4dc7190"
    "ProtectionMountainThane" = "0e5f2g7h-1i3j-8e9f-2g0h-3i4j5e6f7g8h"
    "ProtectionColossus" = "edf56aa2-5f99-4971-ae64-6ac26f3cf004"
}

$PassedChecks = 0
$TotalChecks = 0

foreach ($SubclassName in $HeroSubclasses.Keys) {
    Write-Host "`n  Testing: $SubclassName" -ForegroundColor Cyan
    $ExpectedUUID = $HeroSubclasses[$SubclassName]
    $ExpectedLevels = @(13, 15, 17, 19, 20)
    
    foreach ($Level in $ExpectedLevels) {
        $TotalChecks++
        $ExpectedComment = "$SubclassName Level $Level Spells"
        
        # Find matching SpellList node
        $MatchingNodes = @($AllSpellLists | Where-Object {
            $CommentAttr = $_.attribute | Where-Object { $_.id -eq 'Comment' }
            $CommentAttr.value -eq $ExpectedComment
        })
        
        if ($MatchingNodes.Count -eq 0) {
            Write-Fail "  L$Level - SpellList not found (Comment: '$ExpectedComment')"
            continue
        } elseif ($MatchingNodes.Count -gt 1) {
            Write-Fail "  L$Level - Duplicate SpellList found ($($MatchingNodes.Count) matches)"
            continue
        }
        
        $Node = $MatchingNodes[0]
        
        # Debug: Show all attributes
        if ($Level -eq 13 -and $SubclassName -eq "ArmsColossus") {
            Write-Host "    [DEBUG] Node attributes:" -ForegroundColor Magenta
            $Node.attribute | ForEach-Object {
                Write-Host "      $($_.id) = $($_.value)" -ForegroundColor Gray
            }
        }
        
        # Validate UUID (explicit string conversion to avoid array indexing issue)
        $UUIDAttr = $Node.attribute | Where-Object { $_.id -eq 'UUID' }
        $ActualUUID = if ($UUIDAttr) { [string]$UUIDAttr.value } else { "" }
        
        if ($ActualUUID -eq $ExpectedUUID) {
            Write-Pass "  L$Level - UUID correct"
            $PassedChecks++
        } else {
            Write-Fail "  L$Level - UUID mismatch (expected: $ExpectedUUID, got: '$ActualUUID')"
        }
        
        # Validate Spells attribute (should be empty for Zero SpellList approach)
        $SpellsAttr = $Node.attribute | Where-Object { $_.id -eq 'Spells' }
        if ($SpellsAttr) {
            $Spells = [string]$SpellsAttr.value
            if ([string]::IsNullOrEmpty($Spells)) {
                Write-Host "    [INFO] Spells attribute empty (Zero SpellList pattern)" -ForegroundColor Gray
            } else {
                Write-Host "    [WARN] Spells attribute not empty: '$Spells'" -ForegroundColor Yellow
            }
        }
    }
}

# Step 5: Summary
Write-Host "`n" + ("=" * 80) -ForegroundColor Cyan
Write-Host "[SUMMARY]" -ForegroundColor Cyan
Write-Host "  Total hero subclass SpellLists: $($TotalChecks)" -ForegroundColor White
Write-Host "  Validation checks passed: $PassedChecks / $TotalChecks" -ForegroundColor $(if ($PassedChecks -eq $TotalChecks) { "Green" } else { "Yellow" })
Write-Host "  Validation checks failed: $FailCount" -ForegroundColor $(if ($FailCount -eq 0) { "Green" } else { "Red" })

if ($FailCount -eq 0) {
    Write-Host "`n[SUCCESS] Phase 3 SpellLists validation complete! All hero subclass SpellLists are correct." -ForegroundColor Green
    exit 0
} else {
    Write-Host "`n[FAILED] Validation errors detected. Please review above." -ForegroundColor Red
    exit 1
}
