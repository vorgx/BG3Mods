<#
.SYNOPSIS
    Due diligence on a mod you might add: requirements, which of your mods do the same job, and (with -Download)
    which of your mods' game data it would override. -Install then installs it.

.DESCRIPTION
    Needs a recent Run-ModCheck.ps1 run. With -Download the mod is downloaded into work\newmods\ for inspection
    only. With -Install (implies -Download) it asks you to type YES, backs up modsettings.lsx, copies the pak into
    Mods and adds it right after its dependencies (or above Compatibility Framework). Undo with Restore-ModCheck.ps1.
    Writes Reports\New_Mod_Check_<name>_<date>.html.

.EXAMPLE
    .\Check-NewMod.ps1 https://mod.io/g/baldursgate3/m/ancient-mega-pack-plus
    .\Check-NewMod.ps1 https://www.nexusmods.com/baldursgate3/mods/12345 -Download
    .\Check-NewMod.ps1 https://mod.io/g/baldursgate3/m/ancient-mega-pack-plus -Install
#>
param(
    [Parameter(Mandatory = $true, Position = 0)][string]$Url,
    [switch]$Download,
    [switch]$Install,
    [switch]$Yes
)
. (Join-Path $PSScriptRoot '_env.ps1')

$a = @($Url)
if ($Download -or $Install) { $a += '--download' }
Invoke-Py 'newmod.py' $a
if ($Install) {
    if (-not $Yes) {
        $answer = Read-Host 'Type YES to install it (modsettings.lsx is backed up first)'
        if ($answer -cne 'YES') { Write-Host '[INFO] Not installed.'; return }
    }
    Invoke-Py 'newmod.py' @($Url, '--download', '--install', '--yes')
}
