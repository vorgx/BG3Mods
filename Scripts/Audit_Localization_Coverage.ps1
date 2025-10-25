# ==========================================
# LOCALIZATION COVERAGE AUDIT
# ==========================================
# Purpose: Verify ALL abilities, passives, statuses have localization handles
# Created: October 25, 2025

param(
    [switch]$Detailed = $false
)

Write-Host "`n==================== LOCALIZATION COVERAGE AUDIT ====================" -ForegroundColor Cyan

$ErrorCount = 0
$WarningCount = 0
$TotalChecks = 0

# ==========================================
# HELPER FUNCTIONS
# ==========================================

function Write-Pass { param($Message) Write-Host "[PASS] $Message" -ForegroundColor Green }
function Write-Fail { param($Message) Write-Host "[FAIL] $Message" -ForegroundColor Red; $script:ErrorCount++ }
function Write-Warn { param($Message) Write-Host "[WARN] $Message" -ForegroundColor Yellow; $script:WarningCount++ }
function Write-Info { param($Message) Write-Host "[INFO] $Message" -ForegroundColor Cyan }

function Get-SanitizedHandle {
    param([string]$Handle)
    if ([string]::IsNullOrWhiteSpace($Handle)) { return $Handle }
    return ($Handle.Trim() -replace ';[0-9]+$','')
}

# ==========================================
# FILE PATHS
# ==========================================

$LocalizationPath = "C:\Users\tenod\source\repos\BG3Mods\Data\Mods\Warrior_Wow_78fe4967-4e62-5491-d981-dd781acca4d7\Localization\English\english.xml"
$StatsFolder = "C:\Users\tenod\source\repos\BG3Mods\Data\Public\Warrior_Wow_78fe4967-4e62-5491-d981-dd781acca4d7\Stats\Generated\Data"

Write-Info "Localization file: $LocalizationPath"
Write-Info "Stats folder: $StatsFolder"

# ==========================================
# STEP 1: Load localization file
# ==========================================

Write-Host "`n[STEP 1] Loading localization file..." -ForegroundColor Yellow

if (-not (Test-Path $LocalizationPath)) {
    Write-Fail "Localization file not found: $LocalizationPath"
    exit 1
}

[xml]$LocalizationXml = Get-Content $LocalizationPath -Raw
$AllHandles = $LocalizationXml.contentList.content | Select-Object -ExpandProperty contentuid
$SanitizedHandles = $AllHandles | ForEach-Object { Get-SanitizedHandle $_ }
Write-Pass "Loaded $($AllHandles.Count) localization handles"

# ==========================================
# STEP 2: Extract all stat file entries
# ==========================================

Write-Host "`n[STEP 2] Extracting stat file entries..." -ForegroundColor Yellow

$StatFiles = @{
    "Spell_Target" = "$StatsFolder\Spell_Target.txt"
    "Spell_Zone" = "$StatsFolder\Spell_Zone.txt"
    "Spell_Shout" = "$StatsFolder\Spell_Shout.txt"
    "Spell_Jump" = "$StatsFolder\Spell_Jump.txt"
    "Spell_Projectile" = "$StatsFolder\Spell_Projectile.txt"
    "Passive" = "$StatsFolder\Passive.txt"
    "Status_BOOST" = "$StatsFolder\Status_BOOST.txt"
}

$AllEntries = @{}

foreach ($FileType in $StatFiles.Keys) {
    $FilePath = $StatFiles[$FileType]
    
    if (-not (Test-Path $FilePath)) {
        Write-Warn "Stat file not found: $FilePath"
        continue
    }
    
    $Content = Get-Content $FilePath -Raw
    $Entries = [regex]::Matches($Content, 'new entry "([^"]+)"')
    
    $AllEntries[$FileType] = @()
    
    foreach ($Match in $Entries) {
        $EntryName = $Match.Groups[1].Value
        $AllEntries[$FileType] += $EntryName
    }
    
    Write-Info "$FileType`: $($AllEntries[$FileType].Count) entries"
}

$TotalEntries = ($AllEntries.Values | ForEach-Object { $_.Count } | Measure-Object -Sum).Sum
Write-Pass "Total entries across all stat files: $TotalEntries"

# ==========================================
# STEP 3: Extract DisplayName/Description handles from stat files
# ==========================================

Write-Host "`n[STEP 3] Extracting DisplayName/Description handles from stat files..." -ForegroundColor Yellow

$MissingHandles = @()
$FoundHandles = @()

foreach ($FileType in $StatFiles.Keys) {
    $FilePath = $StatFiles[$FileType]
    
    if (-not (Test-Path $FilePath)) { continue }
    
    Write-Info "Checking $FileType..."
    
    $Content = Get-Content $FilePath -Raw
    
    # Find all entries
    $EntryBlocks = [regex]::Split($Content, 'new entry "([^"]+)"')
    
    for ($i = 1; $i -lt $EntryBlocks.Count; $i += 2) {
        $EntryName = $EntryBlocks[$i]
        $EntryContent = $EntryBlocks[$i + 1]
        
        # Extract DisplayName handle
        if ($EntryContent -match 'data "DisplayName" "([^"]+)"') {
            $DisplayHandleRaw = $Matches[1]
            $DisplayHandle = Get-SanitizedHandle $DisplayHandleRaw
            $TotalChecks++
            
            if ($SanitizedHandles -contains $DisplayHandle) {
                $FoundHandles += @{
                    Entry = $EntryName
                    Handle = $DisplayHandle
                    Type = "DisplayName"
                    File = $FileType
                }
            } else {
                $MissingHandles += @{
                    Entry = $EntryName
                    Handle = $DisplayHandle
                    Type = "DisplayName"
                    File = $FileType
                }
            }
        } else {
            $TotalChecks++
            $MissingHandles += @{
                Entry = $EntryName
                Handle = "MISSING"
                Type = "DisplayName"
                File = $FileType
            }
        }
        
        # Extract Description handle
        if ($EntryContent -match 'data "Description" "([^"]+)"') {
            $DescHandleRaw = $Matches[1]
            $DescHandle = Get-SanitizedHandle $DescHandleRaw
            $TotalChecks++
            
            if ($SanitizedHandles -contains $DescHandle) {
                $FoundHandles += @{
                    Entry = $EntryName
                    Handle = $DescHandle
                    Type = "Description"
                    File = $FileType
                }
            } else {
                $MissingHandles += @{
                    Entry = $EntryName
                    Handle = $DescHandle
                    Type = "Description"
                    File = $FileType
                }
            }
        } else {
            $TotalChecks++
            $MissingHandles += @{
                Entry = $EntryName
                Handle = "MISSING"
                Type = "Description"
                File = $FileType
            }
        }
    }
}

# ==========================================
# STEP 4: Report results
# ==========================================

Write-Host "`n[STEP 4] RESULTS" -ForegroundColor Yellow

Write-Info "Total entries checked: $TotalEntries"
Write-Info "Total handle checks: $TotalChecks"
Write-Pass "Handles found in localization: $($FoundHandles.Count)"
if ($MissingHandles.Count -eq 0) {
    Write-Pass "Handles MISSING from localization: $($MissingHandles.Count)"
} else {
    Write-Fail "Handles MISSING from localization: $($MissingHandles.Count)"
}

if ($MissingHandles.Count -gt 0) {
    Write-Host "`n[MISSING HANDLES BREAKDOWN]" -ForegroundColor Red
    
    $MissingByFile = $MissingHandles | Group-Object -Property File
    
    foreach ($Group in $MissingByFile) {
        Write-Host "`n$($Group.Name): $($Group.Count) missing handles" -ForegroundColor Yellow
        
        if ($Detailed) {
            foreach ($Item in $Group.Group) {
                Write-Host "  - Entry: $($Item.Entry) | Type: $($Item.Type) | Handle: $($Item.Handle)" -ForegroundColor Gray
            }
        }
    }
}

# ==========================================
# STEP 5: Calculate coverage percentage
# ==========================================

$CoveragePercent = [math]::Round(($FoundHandles.Count / $TotalChecks) * 100, 2)

Write-Host "`n[COVERAGE]" -ForegroundColor Cyan
Write-Host "Localization Coverage: $CoveragePercent% ($($FoundHandles.Count)/$TotalChecks)" -ForegroundColor $(if ($CoveragePercent -ge 95) { "Green" } elseif ($CoveragePercent -ge 80) { "Yellow" } else { "Red" })

# ==========================================
# EXIT
# ==========================================

Write-Host "`n=====================================================================" -ForegroundColor Cyan

if ($MissingHandles.Count -eq 0) {
    Write-Host "[SUCCESS] All entries have localization handles!" -ForegroundColor Green
    exit 0
} else {
    Write-Host "[INCOMPLETE] $($MissingHandles.Count) handles need to be added to english.xml" -ForegroundColor Red
    Write-Host "Run with -Detailed flag to see full list of missing entries" -ForegroundColor Yellow
    exit 1
}
