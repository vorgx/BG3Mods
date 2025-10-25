param(
    [switch]$Verbose
)

$StatsFolder = "C:\Users\tenod\source\repos\BG3Mods\Data\Public\Warrior_Wow_78fe4967-4e62-5491-d981-dd781acca4d7\Stats\Generated\Data"
$DbPath = "C:\Users\tenod\source\repos\BG3Mods\Documentation\00_SourcesOfTruth\AbilityDatabase_Warrior_FullyEnriched.csv"

# Color helpers
function Write-Pass { param($Message) Write-Host "[PASS] $Message" -ForegroundColor Green }
function Write-Fail { param($Message) Write-Host "[FAIL] $Message" -ForegroundColor Red; $script:FailCount++ }
function Write-Warn { param($Message) Write-Host "[WARN] $Message" -ForegroundColor Yellow }
function Write-Info { param($Message) Write-Host "[INFO] $Message" -ForegroundColor Cyan }

$script:FailCount = 0

Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host "WARRIOR STAT FILES VALIDATION" -ForegroundColor Cyan
Write-Host "========================================`n" -ForegroundColor Cyan

# Load database for expected counts
Write-Info "Loading database: $DbPath"
$Db = Import-Csv -Path $DbPath

# Define expected structure
$StatFiles = @(
    @{
        Name = "Passive.txt"
        Type = "PassiveData"
        Pattern = '^new entry "WAR_'
        ExpectedCount = 160  # 160 from database (161 including base entry is acceptable)
        DbFileType = "Passive"
    },
    @{
        Name = "Spell_Target.txt"
        Type = "SpellData"
        Pattern = '^new entry "Target_WAR_'
        ExpectedCount = 19
        DbFileType = "Spell_Target"
    },
    @{
        Name = "Spell_Zone.txt"
        Type = "SpellData"
        Pattern = '^new entry "Zone_WAR_'
        ExpectedCount = 12
        DbFileType = "Spell_Zone"
    },
    @{
        Name = "Spell_Shout.txt"
        Type = "SpellData"
        Pattern = '^new entry "Shout_WAR_'
        ExpectedCount = 21
        DbFileType = "Spell_Shout"
    },
    @{
        Name = "Spell_Jump.txt"
        Type = "SpellData"
        Pattern = '^new entry "Jump_WAR_'
        ExpectedCount = 3
        DbFileType = "Spell_Jump"
    },
    @{
        Name = "Spell_Projectile.txt"
        Type = "SpellData"
        Pattern = '^new entry "Projectile_WAR_'
        ExpectedCount = 6
        DbFileType = "Spell_Projectile"
    },
    @{
        Name = "Status_BOOST.txt"
        Type = "StatusData"
        Pattern = '^new entry "WAR_'
        ExpectedCount = 25
        DbFileType = $null  # Status effects not in database as separate entries
    }
)

$TotalExpected = ($StatFiles | Measure-Object -Property ExpectedCount -Sum).Sum
$TotalFound = 0

foreach ($file in $StatFiles) {
    $filePath = Join-Path $StatsFolder $file.Name
    
    Write-Host "`n----------------------------------------" -ForegroundColor Gray
    Write-Info "Validating: $($file.Name)"
    
    # Check file exists
    if (-not (Test-Path $filePath)) {
        Write-Fail "File not found: $filePath"
        continue
    }
    Write-Pass "File exists"
    
    # Read file content
    $content = Get-Content $filePath -Raw
    $lines = Get-Content $filePath
    
    Write-Info "File size: $($lines.Count) lines"
    
    # 1. Check for "new entry" declarations
    $entries = Select-String -Path $filePath -Pattern $file.Pattern -AllMatches
    $entryCount = $entries.Matches.Count
    $TotalFound += $entryCount
    
    Write-Info "Found $entryCount entries (expected: $($file.ExpectedCount))"
    
    if ($entryCount -eq $file.ExpectedCount) {
        Write-Pass "Entry count matches expected"
    } elseif ($file.Name -eq "Passive.txt" -and $entryCount -eq 161 -and $file.ExpectedCount -eq 160) {
        Write-Pass "Entry count is 161 (160 + 1 base entry - acceptable)"
    } else {
        Write-Fail "Entry count mismatch: expected $($file.ExpectedCount), got $entryCount"
    }
    
    # 2. Check for type declarations
    $typeMatches = Select-String -Path $filePath -Pattern "^type `"$($file.Type)`"" -AllMatches
    $typeCount = $typeMatches.Matches.Count
    
    if ($typeCount -eq $entryCount) {
        Write-Pass "All entries have correct type declaration ($($file.Type))"
    } else {
        Write-Fail "Type declaration mismatch: $typeCount type declarations for $entryCount entries"
    }
    
    # 3. Check for basic required fields
    $requiredFields = @("DisplayName", "Description", "Icon")
    
    foreach ($field in $requiredFields) {
        $fieldMatches = Select-String -Path $filePath -Pattern "data `"$field`"" -AllMatches
        $fieldCount = $fieldMatches.Matches.Count
        
        if ($fieldCount -ge $entryCount) {
            Write-Pass "All entries have '$field' field"
        } else {
            Write-Warn "'$field' field found $fieldCount times (expected at least $entryCount)"
        }
    }
    
    # 4. Check for TODO markers (expected in template files)
    $todoCount = ($content | Select-String -Pattern "TODO:" -AllMatches).Matches.Count
    if ($todoCount -gt 0) {
        Write-Info "Found $todoCount TODO markers (template placeholders)"
    }
    
    # 5. Validate against database (if applicable)
    if ($file.DbFileType) {
        $dbEntries = $Db | Where-Object { $_.bg3_file_type -eq $file.DbFileType }
        $dbCount = $dbEntries.Count
        
        Write-Info "Database has $dbCount entries for $($file.DbFileType)"
        
        if ($dbCount -eq $entryCount -or ($file.Name -eq "Passive.txt" -and $dbCount -eq 160 -and $entryCount -eq 161)) {
            Write-Pass "Entry count matches database"
        } else {
            Write-Warn "Entry count differs from database: DB=$dbCount, File=$entryCount"
        }
        
        # Check for missing entries
        if ($Verbose) {
            Write-Info "Checking for missing entries..."
            $fileEntries = [regex]::Matches($content, $file.Pattern) | ForEach-Object { $_.Value -replace '^new entry "', '' -replace '"$', '' }
            
            foreach ($dbEntry in $dbEntries) {
                $expectedName = switch ($file.DbFileType) {
                    "Spell_Target" { "Target_$($dbEntry.ability_id)" }
                    "Spell_Zone" { "Zone_$($dbEntry.ability_id)" }
                    "Spell_Shout" { "Shout_$($dbEntry.ability_id)" }
                    "Spell_Jump" { "Jump_$($dbEntry.ability_id)" }
                    "Spell_Projectile" { "Projectile_$($dbEntry.ability_id)" }
                    "Passive" { $dbEntry.ability_id }
                    default { $dbEntry.ability_id }
                }
                
                if ($fileEntries -notcontains $expectedName) {
                    Write-Warn "Missing entry: $expectedName ($($dbEntry.ability_name))"
                }
            }
        }
    }
    
    # 6. Check for syntax errors (basic)
    $newEntryCount = ($content | Select-String -Pattern '^new entry "' -AllMatches).Matches.Count
    $typeLineCount = ($content | Select-String -Pattern '^type "' -AllMatches).Matches.Count
    
    if ($newEntryCount -eq $typeLineCount) {
        Write-Pass "Syntax check: 'new entry' and 'type' declarations match"
    } else {
        Write-Fail "Syntax error: $newEntryCount 'new entry' lines but $typeLineCount 'type' lines"
    }
    
    # 7. Check for orphaned data lines (lines starting with 'data' not preceded by 'new entry' or 'type')
    $dataLineCount = ($content | Select-String -Pattern '^data "' -AllMatches).Matches.Count
    if ($dataLineCount -gt 0) {
        Write-Info "Found $dataLineCount data field declarations"
        
        # Check for minimum data lines per entry (at least 3: DisplayName, Description, Icon)
        $minDataLines = $entryCount * 3
        if ($dataLineCount -ge $minDataLines) {
            Write-Pass "Sufficient data fields (at least 3 per entry)"
        } else {
            Write-Warn "Low data field count: $dataLineCount lines for $entryCount entries (expected at least $minDataLines)"
        }
    }
}

# Summary
Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host "VALIDATION SUMMARY" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan

Write-Info "Total files validated: $($StatFiles.Count)"
Write-Info "Total entries expected: $TotalExpected"
Write-Info "Total entries found: $TotalFound"

if ($TotalFound -ge $TotalExpected) {
    Write-Pass "Total entry count: $TotalFound (expected: $TotalExpected)"
} else {
    Write-Fail "Total entry count mismatch: found $TotalFound, expected $TotalExpected"
}

Write-Host ""

if ($script:FailCount -eq 0) {
    Write-Host "========================================" -ForegroundColor Green
    Write-Host "ALL VALIDATIONS PASSED!" -ForegroundColor Green
    Write-Host "========================================" -ForegroundColor Green
    Write-Host ""
    Write-Host "All 7 stat files validated successfully." -ForegroundColor Green
    Write-Host "Ready to proceed to FILE 11 and FILE 12." -ForegroundColor Green
    exit 0
} else {
    Write-Host "========================================" -ForegroundColor Red
    Write-Host "VALIDATION FAILED: $script:FailCount error(s)" -ForegroundColor Red
    Write-Host "========================================" -ForegroundColor Red
    Write-Host ""
    Write-Host "Please review errors above before proceeding." -ForegroundColor Yellow
    exit 1
}
