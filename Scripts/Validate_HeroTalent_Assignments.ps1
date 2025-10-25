# Validate Hero Talent Assignments
# Cross-references generated progressions with database granted_by_subclass column

Write-Host "[INFO] Loading ability database..." -ForegroundColor Cyan
$DatabasePath = "C:\Users\tenod\source\repos\BG3Mods\Documentation\00_SourcesOfTruth\AbilityDatabase_Warrior_FullyEnriched.csv"
$AllAbilities = Import-Csv $DatabasePath

Write-Host "[INFO] Loading generated progressions..." -ForegroundColor Cyan
$GeneratedXmlPath = "C:\Users\tenod\source\repos\BG3Mods\Reports\HeroSubclass_Progressions_Generated.xml"
$GeneratedContent = Get-Content $GeneratedXmlPath -Raw
[xml]$GeneratedXml = $GeneratedContent

# Extract all PassivesAdded values from generated XML
$Progressions = $GeneratedXml.root.ChildNodes | Where-Object { $_.Name -eq 'node' -and $_.id -eq 'Progression' }

Write-Host "`n[VALIDATION REPORT]`n" -ForegroundColor Yellow
Write-Host "="*80 -ForegroundColor Yellow

$FailCount = 0
$SuccessCount = 0

# Group progressions by subclass
$SubclassGroups = @{
    'ArmsColossus' = @()
    'ArmsSlayers' = @()
    'FuryMountainThane' = @()
    'FurySlayers' = @()
    'ProtectionMountainThane' = @()
    'ProtectionColossus' = @()
}

foreach ($Progression in $Progressions) {
    $SubclassName = ($Progression.Attributes | Where-Object { $_.name -eq 'Name' }).value
    $PassivesAdded = ($Progression.Attributes | Where-Object { $_.name -eq 'PassivesAdded' }).value
    
    if ($PassivesAdded) {
        $Talents = $PassivesAdded -split ';'
        $SubclassGroups[$SubclassName] += $Talents
    }
}

# Validate each subclass
foreach ($Subclass in $SubclassGroups.Keys | Sort-Object) {
    Write-Host "`nValidating: $Subclass" -ForegroundColor Cyan
    Write-Host ("-"*80) -ForegroundColor Gray
    
    $AllTalents = $SubclassGroups[$Subclass] | Select-Object -Unique
    
    foreach ($Talent in $AllTalents) {
        $AbilityData = $AllAbilities | Where-Object { $_.ability_id -eq $Talent }
        
        if (-not $AbilityData) {
            Write-Host "  [FAIL] $Talent - NOT FOUND IN DATABASE" -ForegroundColor Red
            $FailCount++
            continue
        }
        
        $GrantedBy = $AbilityData.granted_by_subclass
        
        if ($GrantedBy -match $Subclass) {
            Write-Host "  [PASS] $Talent - Correctly assigned" -ForegroundColor Green
            $SuccessCount++
        } else {
            Write-Host "  [FAIL] $Talent - Should belong to: $GrantedBy (NOT $Subclass)" -ForegroundColor Red
            $FailCount++
        }
    }
}

Write-Host "`n" -ForegroundColor Yellow
Write-Host "="*80 -ForegroundColor Yellow
Write-Host "[SUMMARY]" -ForegroundColor Yellow
Write-Host "  Passed: $SuccessCount" -ForegroundColor Green
Write-Host "  Failed: $FailCount" -ForegroundColor Red

if ($FailCount -eq 0) {
    Write-Host "`n[SUCCESS] All talent assignments are correct!" -ForegroundColor Green
    exit 0
} else {
    Write-Host "`n[FAILED] $FailCount incorrect talent assignments detected!" -ForegroundColor Red
    exit 1
}
