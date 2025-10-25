# PHASE 2 - STEP 2: Add granted_by_subclass Column to Database
# Purpose: Map 33 hero talents to their granting subclasses

param(
    [switch]$DryRun = $false,
    [switch]$Force = $false
)

$ErrorActionPreference = "Stop"

# Color helpers
function Write-Pass { param($Message) Write-Host "[PASS] $Message" -ForegroundColor Green }
function Write-Fail { param($Message) Write-Host "[FAIL] $Message" -ForegroundColor Red; $script:FailCount++ }
function Write-Warn { param($Message) Write-Host "[WARN] $Message" -ForegroundColor Yellow }
function Write-Info { param($Message) Write-Host "[INFO] $Message" -ForegroundColor Cyan }
function Write-Title { param($Message) Write-Host "`n=== $Message ===" -ForegroundColor Cyan }

# Paths
$DatabasePath = "C:\Users\tenod\source\repos\BG3Mods\Documentation\00_SourcesOfTruth\AbilityDatabase_Warrior_FullyEnriched.csv"
$BackupPath = $DatabasePath -replace '\.csv$', "_BACKUP_$(Get-Date -Format 'yyyyMMdd_HHmmss').csv"

Write-Title "PHASE 2 STEP 2: Add granted_by_subclass Column"

# Hero Talent Tree Assignments (from SOURCE_OF_TRUTH.md)
# Mountain Thane (11 talents) → FuryMountainThane, ProtectionMountainThane
# Colossus (11 talents) → ArmsColossus, ProtectionColossus
# Slayers (11 talents) → ArmsSlayers, FurySlayers

$HeroTalentMappings = @{
    # Mountain Thane Tree (Fury + Protection)
    "WAR_Strength_of_the_Mountain" = "FuryMountainThane,ProtectionMountainThane"
    "WAR_Thunder_Blast" = "FuryMountainThane,ProtectionMountainThane"
    "WAR_Avatar_of_the_Storm" = "FuryMountainThane,ProtectionMountainThane"
    "WAR_Keep_your_feet_on_the_Ground" = "FuryMountainThane,ProtectionMountainThane"
    "WAR_Flashing_Skies" = "FuryMountainThane,ProtectionMountainThane"
    "WAR_Ground_Current" = "FuryMountainThane,ProtectionMountainThane"
    "WAR_Crashing_Thunder" = "FuryMountainThane,ProtectionMountainThane"
    "WAR_Storm_Bolts" = "FuryMountainThane,ProtectionMountainThane"
    "WAR_Thorim_s_Might" = "FuryMountainThane,ProtectionMountainThane"
    "WAR_Lightning_Strikes" = "FuryMountainThane,ProtectionMountainThane"
    "WAR_Burst_of_Power" = "FuryMountainThane,ProtectionMountainThane"
    
    # Colossus Tree (Arms + Protection)
    "WAR_Demolish" = "ArmsColossus,ProtectionColossus"
    "WAR_Dominance_of_the_Colossus" = "ArmsColossus,ProtectionColossus"
    "WAR_Colossal_Might" = "ArmsColossus,ProtectionColossus"
    "WAR_Earthquake" = "ArmsColossus,ProtectionColossus"
    "WAR_Arterial_Bleed" = "ArmsColossus,ProtectionColossus"
    "WAR_Practiced_Strikes" = "ArmsColossus,ProtectionColossus"
    "WAR_Precise_Might" = "ArmsColossus,ProtectionColossus"
    "WAR_Mountain_of_Muscle_and_Scars" = "ArmsColossus,ProtectionColossus"
    "WAR_Tide_of_Battle" = "ArmsColossus,ProtectionColossus"
    "WAR_No_Stranger_to_Pain" = "ArmsColossus,ProtectionColossus"
    "WAR_Martial_Expert" = "ArmsColossus,ProtectionColossus"
    
    # Slayers Tree (Arms + Fury)
    "WAR_Slayer_s_Dominance" = "ArmsSlayers,FurySlayers"
    "WAR_Imminent_Demise" = "ArmsSlayers,FurySlayers"
    "WAR_Death_Drive" = "ArmsSlayers,FurySlayers"
    "WAR_Relentless_Pursuit" = "ArmsSlayers,FurySlayers"
    "WAR_Show_No_Mercy" = "ArmsSlayers,FurySlayers"
    "WAR_Overwhelming_Blades" = "ArmsSlayers,FurySlayers"
    "WAR_Unrelenting_Onslaught" = "ArmsSlayers,FurySlayers"
    "WAR_Brutal_Finish" = "ArmsSlayers,FurySlayers"
    "WAR_Opportunist" = "ArmsSlayers,FurySlayers"
    "WAR_Reap_the_Storm" = "ArmsSlayers,FurySlayers"
    "WAR_Slayer_s_Malice" = "ArmsSlayers,FurySlayers"
}

Write-Info "Total hero talents to map: $($HeroTalentMappings.Count)"
Write-Info ""

# Backup database
if (-not $DryRun) {
    Write-Info "Creating backup: $BackupPath"
    Copy-Item $DatabasePath $BackupPath
    Write-Pass "Backup created"
} else {
    Write-Warn "DRY RUN - No backup created"
}

# Read database
Write-Info "Reading database..."
$Database = Import-Csv $DatabasePath -Encoding UTF8

# Check if column already exists
$FirstRow = $Database[0]
if ($FirstRow.PSObject.Properties.Name -contains "granted_by_subclass") {
    if ($Force) {
        Write-Warn "Column 'granted_by_subclass' already exists - FORCE mode, will overwrite"
    } else {
        Write-Fail "Column 'granted_by_subclass' already exists! Use -Force to overwrite"
        exit 1
    }
} else {
    Write-Info "Column 'granted_by_subclass' does not exist - will be created"
}

# Add column and populate
$UpdatedCount = 0
$SkippedCount = 0

foreach ($Row in $Database) {
    $AbilityId = $Row.ability_id
    
    # Check if this is a hero talent
    if ($HeroTalentMappings.ContainsKey($AbilityId)) {
        $SubclassMapping = $HeroTalentMappings[$AbilityId]
        
        if ($DryRun) {
            Write-Host "  [DRY RUN] Would set '$AbilityId' -> '$SubclassMapping'" -ForegroundColor Yellow
        } else {
            $Row | Add-Member -MemberType NoteProperty -Name "granted_by_subclass" -Value $SubclassMapping -Force
            Write-Host "  [UPDATE] $AbilityId -> $SubclassMapping" -ForegroundColor Green
        }
        
        $UpdatedCount++
    } else {
        # Not a hero talent - set to empty string
        if ($DryRun) {
            Write-Host "  [DRY RUN] Would clear '$AbilityId' (not a hero talent)" -ForegroundColor Gray
        } else {
            $Row | Add-Member -MemberType NoteProperty -Name "granted_by_subclass" -Value "" -Force
        }
        $SkippedCount++
    }
}

# Save database
if (-not $DryRun) {
    Write-Info "Saving database..."
    $Database | Export-Csv $DatabasePath -NoTypeInformation -Encoding UTF8
    Write-Pass "Database saved"
} else {
    Write-Warn "DRY RUN - No changes saved"
}

# Summary
Write-Title "SUMMARY"
Write-Pass "Hero talents updated: $UpdatedCount/33"
if ($SkippedCount -gt 0) {
    Write-Info "Non-hero talent entries cleared: $SkippedCount"
}

if ($DryRun) {
    Write-Warn "DRY RUN COMPLETE - No changes were made"
    Write-Info "Run without -DryRun to apply changes"
} else {
    Write-Pass "DATABASE UPDATE COMPLETE"
    Write-Info "Backup saved: $BackupPath"
}

# Validation summary
Write-Title "VALIDATION CHECKLIST"
Write-Info "[1] Mountain Thane talents (11): FuryMountainThane,ProtectionMountainThane"
Write-Info "[2] Colossus talents (11): ArmsColossus,ProtectionColossus"
Write-Info "[3] Slayers talents (11): ArmsSlayers,FurySlayers"
Write-Info "[4] All other abilities: Empty string"
Write-Info ""
Write-Info "Next Steps:"
Write-Info "  1. Run validation script (TBD - Create Validate_Database_Subclass_Mappings.ps1)"
Write-Info "  2. Verify mappings in database"
Write-Info "  3. Proceed to Step 3: Add 6 Hero Subclasses to ClassDescriptions.lsx"
