<#
.SYNOPSIS
    Launches Baldur's Gate 3 to check it accepts the current load order, then closes it again.

.DESCRIPTION
    The game quietly resets modsettings.lsx to the base game a few seconds after startup when a mod fails its checks.
    This starts the game, waits up to 45 seconds for that, and closes it (it never gets past the main menu, so saves
    are untouched). modsettings.lsx is always restored afterwards. With -Find it bisects over recently changed mods
    (since the last passing test, or the last -Days days) to name the culprit; each step is one launch of about 15-50 s.

.EXAMPLE
    .\Test-GameLoad.ps1
    .\Test-GameLoad.ps1 -Find
    .\Test-GameLoad.ps1 -Find -Days 30
#>
param([switch]$Find, [double]$Days)
. (Join-Path $PSScriptRoot '_env.ps1')

$a = @()
if ($Find) { $a += '--find' }
if ($Days) { $a += '--days'; $a += "$Days" }
Invoke-Py 'test_load.py' $a
