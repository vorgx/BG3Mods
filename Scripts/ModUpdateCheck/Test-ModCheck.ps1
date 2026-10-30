<#
.SYNOPSIS
    Runs the sandbox tests for the mod-check tool. Never touches the live game and makes no network calls.

.DESCRIPTION
    Each test builds small synthetic paks and a CRLF modsettings.lsx under work\test-sandbox\, points the tools there
    with BG3MC_MODS, BG3MC_MODSETTINGS, BG3MC_BACKUPS, BG3MC_WORK and BG3MC_CONF, and runs them with downloads and
    the bg3.exe check stubbed. A tool refuses to start if any of those paths is unset or outside the sandbox.
    Afterwards the run fails if the live modsettings.lsx, the live Mods folder, Backups\ModCheck or work\*.json changed.

.PARAMETER Filter
    Only run tests whose name contains this text, e.g. fix_order or lootpatch.

.EXAMPLE
    .\Test-ModCheck.ps1
    .\Test-ModCheck.ps1 -Filter update -Detailed
#>
param(
    [string]$Filter,
    [switch]$Detailed
)
. (Join-Path $PSScriptRoot '_env.ps1')

$a = @()
if ($Filter) { $a += '-k'; $a += $Filter }
if ($Detailed) { $a += '-v' }
& $McPy -I (Join-Path $McHere 'tests\run_tests.py') @a
exit $LASTEXITCODE
