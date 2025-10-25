# ==========================================
# UPDATE STAT FILES WITH LOCALIZATION HANDLES
# ==========================================
# Purpose: Replace placeholder handles in all stat files with generated handles
# Strategy: Use Generated_Localization_Handles.csv mapping
# Created: October 25, 2025

param(
    [switch]$DryRun = $false
)

Write-Host "`n==================== UPDATE STAT FILES WITH HANDLES ====================" -ForegroundColor Cyan

# ==========================================
# CONFIGURATION
# ==========================================

$StatsFolder = "C:\Users\tenod\source\repos\BG3Mods\Data\Public\Warrior_Wow_78fe4967-4e62-5491-d981-dd781acca4d7\Stats\Generated\Data"
$HandleCsvPath = "C:\Users\tenod\source\repos\BG3Mods\Scripts\Generated_Localization_Handles.csv"

$UpdatedCount = 0
$ErrorCount = 0

# ==========================================
# STEP 1: Load handle mappings
# ==========================================

Write-Host "`n[STEP 1] Loading handle mappings..." -ForegroundColor Yellow

if (-not (Test-Path $HandleCsvPath)) {
    Write-Host "[ERROR] Handle CSV not found: $HandleCsvPath" -ForegroundColor Red
    Write-Host "[INFO] Run Generate_Complete_Localization.ps1 first!" -ForegroundColor Yellow
    exit 1
}

$HandleMappings = Import-Csv $HandleCsvPath
Write-Host "[INFO] Loaded $($HandleMappings.Count) handle mappings" -ForegroundColor Cyan

# Create lookup dictionary by EntryName
$HandleLookup = @{}
foreach ($Mapping in $HandleMappings) {
    $HandleLookup[$Mapping.EntryName] = $Mapping
}

# ==========================================
# STEP 2: Process each stat file
# ==========================================

Write-Host "`n[STEP 2] Processing stat files..." -ForegroundColor Yellow

$StatFiles = @(
    "Passive.txt",
    "Spell_Target.txt",
    "Spell_Zone.txt",
    "Spell_Shout.txt",
    "Spell_Jump.txt",
    "Spell_Projectile.txt",
    "Status_BOOST.txt"
)

foreach ($FileName in $StatFiles) {
    $FilePath = Join-Path $StatsFolder $FileName
    
    if (-not (Test-Path $FilePath)) {
        Write-Host "[WARN] File not found: $FileName" -ForegroundColor Yellow
        continue
    }
    
    Write-Host "`n  Processing $FileName..." -ForegroundColor Gray
    
    # Read file content line-by-line to allow entry-scoped replacements
    $OriginalContent = Get-Content $FilePath -Raw
    $Lines = Get-Content $FilePath
    $UpdatedLines = @()
    $CurrentEntry = $null
    $CurrentHandles = $null
    $FileHandleUpdates = 0
    $UpdatedEntries = New-Object System.Collections.Generic.HashSet[string]
    $EntryCount = ($Lines | Where-Object { $_ -match '^new entry "' }).Count
    
    Write-Host "    Found $EntryCount entries" -ForegroundColor Gray
    
    foreach ($Line in $Lines) {
        $UpdatedLine = $Line
        $EntryChanged = $false
        
        # Detect entry boundaries and cache handle info if available
        if ($Line -match '^new entry "([^"]+)"') {
            $CurrentEntry = $Matches[1]
            if ($HandleLookup.ContainsKey($CurrentEntry)) {
                $CurrentHandles = $HandleLookup[$CurrentEntry]
            } else {
                $CurrentHandles = $null
            }
        }
        
        if ($null -ne $CurrentHandles) {
            if ($UpdatedLine -match 'data "DisplayName" "h123abc01;1"') {
                $UpdatedLine = $UpdatedLine -replace 'h123abc01;1', "$($CurrentHandles.HandleName);1"
                $FileHandleUpdates++
                $EntryChanged = $true
                if ($DryRun) {
                    Write-Host "      [DRY RUN] $CurrentEntry - DisplayName -> $($CurrentHandles.HandleName)" -ForegroundColor Yellow
                } else {
                    Write-Host "      [UPDATE] $CurrentEntry - DisplayName -> $($CurrentHandles.HandleName)" -ForegroundColor Green
                }
            }
            if ($UpdatedLine -match 'data "Description" "h123abc02;1"') {
                $UpdatedLine = $UpdatedLine -replace 'h123abc02;1', "$($CurrentHandles.HandleDesc);1"
                $FileHandleUpdates++
                $EntryChanged = $true
                if ($DryRun) {
                    Write-Host "      [DRY RUN] $CurrentEntry - Description -> $($CurrentHandles.HandleDesc)" -ForegroundColor Yellow
                } else {
                    Write-Host "      [UPDATE] $CurrentEntry - Description -> $($CurrentHandles.HandleDesc)" -ForegroundColor Green
                }
            }
        }
        
        if ($EntryChanged) {
            $null = $UpdatedEntries.Add($CurrentEntry)
        }
        
        $UpdatedLines += $UpdatedLine
    }
    
    $NormalizedOriginal = (($OriginalContent -split "`r?`n") -join "`n")
    $NormalizedUpdated = ($UpdatedLines -join "`n")
    
    if ($NormalizedUpdated -ne $NormalizedOriginal) {
        if ($DryRun) {
            Write-Host "    [DRY RUN] Would update $($UpdatedEntries.Count) entries ($FileHandleUpdates handles) in $FileName" -ForegroundColor Yellow
        } else {
            $Directory = Split-Path $FilePath -Parent
            $BaseName = [System.IO.Path]::GetFileNameWithoutExtension($FilePath)
            $Timestamp = Get-Date -Format 'yyyyMMdd_HHmmss'
            $BackupFileName = "{0}_BACKUP_{1}.txt" -f $BaseName, $Timestamp
            $BackupPath = Join-Path $Directory $BackupFileName
            Copy-Item -Path $FilePath -Destination $BackupPath
            $UpdatedLines | Set-Content -Path $FilePath -Encoding UTF8
            Write-Host "    [SUCCESS] Updated $($UpdatedEntries.Count) entries ($FileHandleUpdates handles) in $FileName" -ForegroundColor Green
            Write-Host "    [BACKUP] $BackupPath" -ForegroundColor Cyan
            $UpdatedCount += $UpdatedEntries.Count
        }
    } else {
        Write-Host "    [INFO] No changes needed for $FileName" -ForegroundColor Gray
    }
}

# ==========================================
# STEP 3: Summary
# ==========================================

Write-Host "`n[SUMMARY]" -ForegroundColor Yellow
Write-Host "Files processed: $($StatFiles.Count)" -ForegroundColor White
Write-Host "Entries updated: $UpdatedCount" -ForegroundColor Green
Write-Host "Errors: $ErrorCount" -ForegroundColor $(if ($ErrorCount -eq 0) { "Green" } else { "Red" })

Write-Host "`n=====================================================================" -ForegroundColor Cyan

if ($DryRun) {
    Write-Host "[DRY RUN COMPLETE] Run without -DryRun to apply changes" -ForegroundColor Yellow
} else {
    Write-Host "[SUCCESS] Stat files updated with localization handles!" -ForegroundColor Green
    Write-Host "[NEXT] Run Audit_Localization_Coverage.ps1 to verify 100% coverage" -ForegroundColor Yellow
}
