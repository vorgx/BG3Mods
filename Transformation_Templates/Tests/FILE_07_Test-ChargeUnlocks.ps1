param(
    [Parameter(Mandatory=$true)][string]$PassiveFilePath,
    [Parameter(Mandatory=$true)][string]$StatusFilePath
)

$ErrorActionPreference = "Stop"
$FailCount = 0

function Write-Pass { param([string]$Message) Write-Host "[PASS] $Message" -ForegroundColor Green }
function Write-Fail { param([string]$Message) Write-Host "[FAIL] $Message" -ForegroundColor Red; $script:FailCount++ }
function Write-Warn { param([string]$Message) Write-Host "[WARN] $Message" -ForegroundColor Yellow }
function Write-Info { param([string]$Message) Write-Host "[INFO] $Message" -ForegroundColor Cyan }

if (-not (Test-Path $PassiveFilePath)) {
    Write-Fail "Passive file not found: $PassiveFilePath"
    exit 1
}

if (-not (Test-Path $StatusFilePath)) {
    Write-Fail "Status file not found: $StatusFilePath"
    exit 1
}

$passiveContentRaw = Get-Content -Path $PassiveFilePath -Raw
$passiveContent = $passiveContentRaw -replace '(?s)<!--.*?-->', ''

$statusContentRaw = Get-Content -Path $StatusFilePath -Raw
$statusContent = $statusContentRaw -replace '(?s)<!--.*?-->', ''

$expectedUnlocks = @{
    "WAR_Unlock_Charge"        = @("UnlockSpell(Jump_WAR_Charge)", "ActionResource(MobilityCharge,2,0)")
    "WAR_Unlock_Overpower"     = @("UnlockSpell(Target_WAR_Overpower)", "ActionResource(OverpowerCharge,2,0)")
    "WAR_Unlock_ShieldWall"    = @("UnlockSpell(Shout_WAR_Shield_Wall)", "ActionResource(DefensiveCharge,1,0)", "ActionResource(TankCooldown,1,0)")
    "WAR_Unlock_HeroicLeap"    = @("UnlockSpell(Jump_WAR_Heroic_Leap)", "ActionResource(MobilityCharge,2,0)")
    "WAR_Unlock_BerserkerRage" = @("UnlockSpell(Shout_WAR_Berserker_Rage)", "ActionResource(DefensiveCharge,1,0)")
    "WAR_Unlock_DieBytheSword" = @("UnlockSpell(Shout_WAR_Die_by_the_Sword)", "ActionResource(DefensiveCharge,1,0)")
    "WAR_Unlock_Intervene"     = @("UnlockSpell(Jump_WAR_Intervene)", "ActionResource(MobilityCharge,2,0)")
    "WAR_Unlock_LastStand"     = @("UnlockSpell(Shout_WAR_Last_Stand)", "ActionResource(DefensiveCharge,1,0)", "ActionResource(TankCooldown,1,0)")
}

foreach ($entry in $expectedUnlocks.GetEnumerator()) {
    $name = [regex]::Escape($entry.Key)
    $pattern = '(?s)new entry "{0}".*?data "Boosts" "(?<boosts>[^"]*)"' -f $name
    $match = [regex]::Match($passiveContent, $pattern)

    if (-not $match.Success) {
        Write-Fail "Passive '$($entry.Key)' not found or missing Boosts block"
        continue
    }

    $boosts = $match.Groups['boosts'].Value
    Write-Info "Boosts ($($entry.Key)): $boosts"

    $missing = @()
    foreach ($expectedFragment in $entry.Value) {
        if ($boosts -notlike "*$expectedFragment*") {
            $missing += $expectedFragment
        }
    }

    if ($missing.Count -eq 0) {
        Write-Pass "Passive '$($entry.Key)' grants expected unlock + charge resources"
    } else {
        Write-Fail "Passive '$($entry.Key)' missing fragments: $($missing -join ', ')"
    }
}

# Validate Overpower generation functor and limiter wiring
$opPattern = '(?s)new entry "WAR_Overpower_Generation".*?data "StatsFunctors" "(?<functors>[^"]*)"'
$opMatch = [regex]::Match($passiveContent, $opPattern)
if (-not $opMatch.Success) {
    Write-Fail "Passive 'WAR_Overpower_Generation' missing StatsFunctors definition"
} else {
    $functors = $opMatch.Groups['functors'].Value
    Write-Info "StatsFunctors (WAR_Overpower_Generation): $functors"
    $expectedFunctors = @("RestoreResource(SELF,OverpowerCharge,1,0)", "ApplyStatus(SELF,WAR_OVERPOWER_PROC_THIS_TURN,100,1)")
    $missingFunctors = $expectedFunctors | Where-Object { $functors -notlike "*$_*" }
    if ($missingFunctors.Count -eq 0) {
        Write-Pass "Overpower generation functors include resource restore + limiter status"
    } else {
        Write-Fail "Overpower generation functors missing: $($missingFunctors -join ', ')"
    }
}

$opConditionPattern = '(?s)new entry "WAR_Overpower_Generation".*?data "Conditions" "(?<conditions>[^"]*)"'
$opConditionMatch = [regex]::Match($passiveContent, $opConditionPattern)
if ($opConditionMatch.Success) {
    $conditions = $opConditionMatch.Groups['conditions'].Value
    Write-Info "Conditions (WAR_Overpower_Generation): $conditions"
    if ($conditions -like "*WAR_OVERPOWER_PROC_THIS_TURN*") {
        Write-Pass "Overpower generation condition checks limiter status"
    } else {
        Write-Fail "Overpower generation condition missing limiter status guard"
    }
} else {
    Write-Fail "Passive 'WAR_Overpower_Generation' missing Conditions block"
}

# Validate limiter status definition
$statusPattern = '(?s)new entry "WAR_OVERPOWER_PROC_THIS_TURN"(?<block>.*?)(?=\nnew entry |\Z)'
$statusMatch = [regex]::Match($statusContent, $statusPattern)
if (-not $statusMatch.Success) {
    Write-Fail "Status 'WAR_OVERPOWER_PROC_THIS_TURN' not found"
} else {
    $statusBlock = $statusMatch.Groups['block'].Value

    $expectedStatusFields = @{
        "StatusType"          = "BOOST"
        "StackId"             = "WAR_OVERPOWER_PROC_LIMIT"
        "StatusPropertyFlags" = "DisableCombatlog;DisableOverhead"
        "RemoveEvents"        = "OnTurn"
        "RemoveConditions"    = "IsTurn(context.Source)"
    }

    foreach ($field in $expectedStatusFields.GetEnumerator()) {
    $fieldPattern = 'data "{0}" "(?<value>[^"]*)"' -f $field.Key
    $fieldMatch = [regex]::Match($statusBlock, $fieldPattern)
        if ($fieldMatch.Success) {
            $value = $fieldMatch.Groups['value'].Value
            Write-Info "$($field.Key): $value"
            if ($value -like "*$($field.Value)*") {
                Write-Pass "Status field '$($field.Key)' matches expected value"
            } else {
                Write-Fail "Status field '$($field.Key)' expected '$($field.Value)' but found '$value'"
            }
        } else {
            Write-Fail "Status field '$($field.Key)' missing"
        }
    }
}

if ($FailCount -gt 0) {
    exit 1
}

exit 0
