<#
.SYNOPSIS
    Downloads and installs the updates found by Run-ModCheck.ps1, then re-checks and fixes the load order.

.DESCRIPTION
    1. Shows the download plan (mod, old -> new version, source, size).
    2. Asks you to type YES (or pass -Yes).
    3. Backs up modsettings.lsx, moves each old pak to Backups\ModCheck\<time>_update\paks, installs the new pak and
       updates its version in modsettings.lsx. Nexus downloads use your Premium API key; mods installed through
       the in-game mod manager are updated from mod.io. Downgrades and changed mod UUIDs are refused.
    4. Re-runs the check (with cached online data) and applies the recommended load order (backed up again).
    Undo with Restore-ModCheck.ps1. Close Baldur's Gate 3 first.

.EXAMPLE
    .\Update-Mods.ps1                              # everything flagged "Update available"
    .\Update-Mods.ps1 -Only Rebalance,Goon         # just these
    .\Update-Mods.ps1 -RemoveObsolete              # also remove paks marked obsolete
#>
param(
    [string[]]$Only = @(),
    [switch]$RemoveObsolete,
    [switch]$Yes,
    [switch]$SkipLoadOrderFix
)
. (Join-Path $PSScriptRoot '_env.ps1')

$sel = @()
if ($Only.Count) { $sel += '--only'; $sel += $Only }
if ($RemoveObsolete) { $sel += '--remove-obsolete' }

Invoke-Py 'update.py' $sel
if (-not $Yes) {
    $answer = Read-Host 'Type YES to download and install these (old paks are backed up)'
    if ($answer -cne 'YES') { Write-Host '[INFO] Cancelled. Nothing was downloaded.'; return }
}
Invoke-Py 'update.py' ($sel + @('--apply', '--yes'))

Write-Host '[INFO] Re-checking with the new paks...'
& (Join-Path $PSScriptRoot 'Run-ModCheck.ps1') -UseCache
if (-not $SkipLoadOrderFix) {
    Invoke-Py 'fix_order.py' @('--apply')
}
