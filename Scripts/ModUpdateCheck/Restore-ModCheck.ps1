<#
.SYNOPSIS
    Undoes a Fix-LoadOrder.ps1 or Update-Mods.ps1 run from its backup.

.EXAMPLE
    .\Restore-ModCheck.ps1                 # list backups
    .\Restore-ModCheck.ps1 latest          # undo the most recent change
    .\Restore-ModCheck.ps1 20261030_101500_update
#>
param([string]$Backup)
. (Join-Path $PSScriptRoot '_env.ps1')

if ($Backup) { Invoke-Py 'restore.py' @($Backup) } else { Invoke-Py 'restore.py' }
