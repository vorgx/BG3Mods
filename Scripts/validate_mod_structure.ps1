# validate_mod_structure.ps1
# Validates BG3Wow mod structure for UUID consistency, localization, XML syntax, and stat file format
# Run this script before packaging to catch common errors

param(
    [string]$ModRoot = "$PSScriptRoot\Data",  # Root of Data/ folder
    [switch]$Verbose                          # Show detailed pass/fail for each check
)

# Color-coded output
function Write-Header { param($text) Write-Host "`n=== $text ===" -ForegroundColor Cyan }
function Write-Pass { param($text) Write-Host "[PASS] $text" -ForegroundColor Green }
function Write-Fail { param($text) Write-Host "[FAIL] $text" -ForegroundColor Red }
function Write-Warn { param($text) Write-Host "[WARN] $text" -ForegroundColor Yellow }
function Write-Info { param($text) if ($Verbose) { Write-Host "[INFO] $text" -ForegroundColor Gray } }

$ErrorCount = 0
$WarningCount = 0
$PassCount = 0

Write-Header "BG3Wow Mod Structure Validation"
Write-Host "Validating: $ModRoot"

# Expected UUID (from project documentation)
$ExpectedUUID = "78fe4967-4e62-5491-d981-dd781acca4d7"
$ExpectedFolderSuffix = "BG3Wow_$ExpectedUUID"

# ============================================
# CHECK 1: UUID Consistency
# ============================================
Write-Header "UUID Consistency Checks"

# Check 1.1: Mods folder name
$ModsFolderPath = Join-Path $ModRoot "Mods\$ExpectedFolderSuffix"
if (Test-Path $ModsFolderPath) {
    Write-Pass "Mods folder name correct: $ExpectedFolderSuffix"
    $PassCount++
} else {
    Write-Fail "Mods folder name incorrect or missing: $ModsFolderPath"
    $ErrorCount++
}

# Check 1.2: Public folder name
$PublicFolderPath = Join-Path $ModRoot "Public\$ExpectedFolderSuffix"
if (Test-Path $PublicFolderPath) {
    Write-Pass "Public folder name correct: $ExpectedFolderSuffix"
    $PassCount++
} else {
    Write-Fail "Public folder name incorrect or missing: $PublicFolderPath"
    $ErrorCount++
}

# Check 1.3: meta.lsx UUID value
$MetaLsxPath = Join-Path $ModsFolderPath "meta.lsx"
if (Test-Path $MetaLsxPath) {
    $MetaContent = Get-Content -Path $MetaLsxPath -Raw
    
    # Search for ModuleInfo UUID attribute specifically (not Dependencies)
    # Use regex to find ModuleInfo node and its UUID
    if ($MetaContent -match '<node id="ModuleInfo">[\s\S]*?attribute id="UUID"[^>]+value="([^"]+)"') {
        $FoundUUID = $Matches[1]
        if ($FoundUUID -eq $ExpectedUUID) {
            Write-Pass "meta.lsx ModuleInfo UUID correct: $ExpectedUUID"
            $PassCount++
        } else {
            Write-Fail "meta.lsx ModuleInfo UUID mismatch! Expected: $ExpectedUUID, Found: $FoundUUID"
            $ErrorCount++
        }
    } else {
        Write-Fail "meta.lsx ModuleInfo UUID attribute not found or malformed"
        $ErrorCount++
    }
    
    # Check for ModuleInfo Folder attribute match
    if ($MetaContent -match '<node id="ModuleInfo">[\s\S]*?attribute id="Folder"[^>]+value="([^"]+)"') {
        $FoundFolder = $Matches[1]
        if ($FoundFolder -eq $ExpectedFolderSuffix) {
            Write-Pass "meta.lsx ModuleInfo Folder attribute correct: $ExpectedFolderSuffix"
            $PassCount++
        } else {
            Write-Fail "meta.lsx ModuleInfo Folder mismatch! Expected: $ExpectedFolderSuffix, Found: $FoundFolder"
            $ErrorCount++
        }
    }
} else {
    Write-Fail "meta.lsx not found at: $MetaLsxPath"
    $ErrorCount++
}

# ============================================
# CHECK 2: XML Syntax Validation
# ============================================
Write-Header "XML Syntax Validation"

$XmlFiles = @(
    @{ Path = $MetaLsxPath; Name = "meta.lsx" }
    @{ Path = Join-Path $PublicFolderPath "ClassDescriptions\ClassDescriptions.lsx"; Name = "ClassDescriptions.lsx" }
    @{ Path = Join-Path $PublicFolderPath "Progressions.lsx"; Name = "Progressions.lsx" }
    @{ Path = Join-Path $PublicFolderPath "ActionResourceDefinitions\ActionResourceDefinitions.lsx"; Name = "ActionResourceDefinitions.lsx" }
)

foreach ($XmlFile in $XmlFiles) {
    $XmlPath = $XmlFile.Path
    $XmlName = $XmlFile.Name
    
    if (-not (Test-Path $XmlPath)) {
        Write-Warn "$XmlName not found: $XmlPath"
        $WarningCount++
        continue
    }
    
    try {
        [xml]$null = Get-Content -Path $XmlPath -Raw
        Write-Pass "$XmlName XML syntax valid"
        $PassCount++
        
        # Additional checks for specific files
        if ($XmlName -eq "Progressions.lsx") {
            # Check for common malformed patterns (orphaned attributes, unclosed nodes)
            $Content = Get-Content -Path $XmlPath -Raw
            
            # Count opening vs closing <node> tags
            $OpenNodes = ([regex]::Matches($Content, '<node')).Count
            $CloseNodes = ([regex]::Matches($Content, '</node>')).Count
            
            if ($OpenNodes -eq $CloseNodes) {
                Write-Pass "Progressions.lsx node tags balanced ($OpenNodes open, $CloseNodes close)"
                $PassCount++
            } else {
                Write-Fail "Progressions.lsx node tags unbalanced! $OpenNodes open, $CloseNodes close"
                $ErrorCount++
            }
        }
        
    } catch {
        Write-Fail "$XmlName XML syntax error: $_"
        $ErrorCount++
    }
}

# ============================================
# CHECK 3: Localization Handles
# ============================================
Write-Header "Localization Handle Validation"

# BG3Wow has localization in Mods folder, not Public folder (non-standard but valid)
$LocalizationModsPath = Join-Path $ModsFolderPath "Localization\English\English.loca.xml"
$LocalizationPublicPath = Join-Path $PublicFolderPath "Localization\English\English.loca.xml"

# Check both locations
$LocaPath = if (Test-Path $LocalizationModsPath) { 
    $LocalizationModsPath 
} elseif (Test-Path $LocalizationPublicPath) { 
    $LocalizationPublicPath 
} else { 
    $null 
}

if ($LocaPath) {
    Write-Info "Found localization at: $LocaPath"
    try {
        $LocaContent = Get-Content -Path $LocaPath -Raw
        
        # Check for handle format: h[8 hex chars][2 digit counter]
        # Example: h125abc01, h125abc02
        $HandleMatches = [regex]::Matches($LocaContent, 'contentuid="(h[0-9a-f]{8}\d{2})"')
        
        if ($HandleMatches.Count -gt 0) {
            Write-Pass "Found $($HandleMatches.Count) localization handles"
            $PassCount++
            
            # Check for duplicates
            $Handles = $HandleMatches | ForEach-Object { $_.Groups[1].Value }
            $UniqueHandles = $Handles | Select-Object -Unique
            
            if ($Handles.Count -eq $UniqueHandles.Count) {
                Write-Pass "No duplicate localization handles"
                $PassCount++
            } else {
                $DuplicateCount = $Handles.Count - $UniqueHandles.Count
                Write-Fail "Found $DuplicateCount duplicate localization handle(s)"
                $ErrorCount++
                
                # Report duplicates
                $Handles | Group-Object | Where-Object { $_.Count -gt 1 } | ForEach-Object {
                    Write-Info "  Duplicate: $($_.Name) appears $($_.Count) times"
                }
            }
            
            # Check for invalid format (not matching h[8hex][2digit])
            $InvalidHandles = [regex]::Matches($LocaContent, 'contentuid="(h[^"]+)"') | 
                Where-Object { $_.Groups[1].Value -notmatch '^h[0-9a-f]{8}\d{2}$' }
            
            if ($InvalidHandles.Count -eq 0) {
                Write-Pass "All handles follow correct format: h[8hex][2digit]"
                $PassCount++
            } else {
                Write-Fail "Found $($InvalidHandles.Count) handle(s) with invalid format"
                $ErrorCount++
                $InvalidHandles | ForEach-Object {
                    Write-Info "  Invalid: $($_.Groups[1].Value)"
                }
            }
            
        } else {
            Write-Warn "No localization handles found (file may be empty or binary .lxa)"
            $WarningCount++
        }
        
    } catch {
        Write-Fail "Error reading localization file: $_"
        $ErrorCount++
    }
} else {
    Write-Warn "Localization file not found at: $LocalizationPath or $LocalizationXmlPath"
    $WarningCount++
}

# ============================================
# CHECK 4: Stat File Format (.txt files)
# ============================================
Write-Header "Stat File Format Validation"

$StatsFolder = Join-Path $PublicFolderPath "Stats\Generated\Data"
$StatFiles = @(
    "Spell_Target.txt",
    "Spell_Shout.txt",
    "Spell_Jump.txt",
    "Spell_Zone.txt",
    "Spell_Projectile.txt",
    "Status_BOOST.txt",
    "Passive.txt"
)

foreach ($StatFileName in $StatFiles) {
    $StatFilePath = Join-Path $StatsFolder $StatFileName
    
    if (-not (Test-Path $StatFilePath)) {
        Write-Warn "$StatFileName not found: $StatFilePath"
        $WarningCount++
        continue
    }
    
    $StatContent = Get-Content -Path $StatFilePath -Raw
    
    # Check for basic stat file structure
    # Format: new entry "EntryName"
    #         type "SpellData" (or StatusData, PassiveData)
    #         data "key" "value"
    
    $EntryMatches = [regex]::Matches($StatContent, 'new entry "([^"]+)"')
    
    if ($EntryMatches.Count -gt 0) {
        Write-Pass "$StatFileName : Found $($EntryMatches.Count) entries"
        $PassCount++
        
        # Check for missing type declarations
        $TypeMatches = [regex]::Matches($StatContent, 'type "([^"]+)"')
        
        if ($TypeMatches.Count -eq $EntryMatches.Count) {
            Write-Pass "$StatFileName : All entries have type declarations"
            $PassCount++
        } else {
            Write-Fail "$StatFileName : Entry/type count mismatch ($($EntryMatches.Count) entries, $($TypeMatches.Count) types)"
            $ErrorCount++
        }
        
        # Check for malformed data lines (missing quotes)
        $MalformedLines = [regex]::Matches($StatContent, '(?m)^data [^"]*$')
        
        if ($MalformedLines.Count -eq 0) {
            Write-Pass "$StatFileName : No malformed data lines detected"
            $PassCount++
        } else {
            Write-Fail "$StatFileName : Found $($MalformedLines.Count) malformed data line(s)"
            $ErrorCount++
        }
        
    } else {
        Write-Warn "$StatFileName : No entries found (file may be empty)"
        $WarningCount++
    }
}

# ============================================
# CHECK 5: Cross-Reference Validation
# ============================================
Write-Header "Cross-Reference Validation"

# This is a lighter check - just verify files exist
# Full cross-reference checking (Progressions.lsx AddSpells vs Spell_*.txt entries) 
# would require more complex parsing

$RequiredFiles = @(
    @{ Path = Join-Path $PublicFolderPath "ClassDescriptions\ClassDescriptions.lsx"; Name = "ClassDescriptions.lsx" }
    @{ Path = Join-Path $PublicFolderPath "Progressions.lsx"; Name = "Progressions.lsx" }
    @{ Path = Join-Path $PublicFolderPath "ActionResourceDefinitions\ActionResourceDefinitions.lsx"; Name = "ActionResourceDefinitions.lsx" }
    @{ Path = Join-Path $StatsFolder "Spell_Target.txt"; Name = "Spell_Target.txt" }
    @{ Path = Join-Path $StatsFolder "Status_BOOST.txt"; Name = "Status_BOOST.txt" }
    @{ Path = Join-Path $StatsFolder "Passive.txt"; Name = "Passive.txt" }
)

foreach ($RequiredFile in $RequiredFiles) {
    if (Test-Path $RequiredFile.Path) {
        Write-Info "$($RequiredFile.Name) exists"
    } else {
        Write-Fail "Required file missing: $($RequiredFile.Name)"
        $ErrorCount++
    }
}

# ============================================
# SUMMARY
# ============================================
Write-Header "Validation Summary"

$TotalChecks = $PassCount + $ErrorCount + $WarningCount
Write-Host ""
Write-Host "Total Checks: $TotalChecks" -ForegroundColor Cyan
Write-Pass "Passed: $PassCount"
if ($ErrorCount -gt 0) {
    Write-Fail "Failed: $ErrorCount"
} else {
    Write-Host "[OK] Failed: 0" -ForegroundColor Green
}
if ($WarningCount -gt 0) {
    Write-Warn "Warnings: $WarningCount"
}

Write-Host ""

if ($ErrorCount -eq 0) {
    Write-Pass "=== VALIDATION PASSED ==="
    Write-Host "Mod structure is ready for packaging!" -ForegroundColor Green
    Write-Host ""
    Write-Host "Next steps:"
    Write-Host "  1. Review pre_package_checklist.md for release workflow"
    Write-Host "  2. Package with LSLib: .\LsLib\ConverterApp.exe --source Data --destination Package\BG3Wow.pak ..."
    Write-Host "  3. Test in-game via BG3 Mod Manager"
    exit 0
} else {
    Write-Fail "=== VALIDATION FAILED ==="
    Write-Host "Fix $ErrorCount error(s) before packaging." -ForegroundColor Red
    Write-Host ""
    Write-Host "Common fixes:"
    Write-Host "  - UUID mismatch: Rename folders or update meta.lsx UUID attribute"
    Write-Host "  - XML syntax: Check for unclosed tags, orphaned attributes"
    Write-Host "  - Localization: Fix duplicate handles, ensure h[8hex][2digit] format"
    Write-Host "  - Stat files: Verify 'new entry' and 'type' declarations, check quote syntax"
    exit 1
}
