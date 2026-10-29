<#
.SYNOPSIS
    Writes the recommended load order (from the last Run-ModCheck.ps1) into modsettings.lsx. Backs it up first.

.DESCRIPTION
    Without -Apply it only shows what would change. Refuses to run while Baldur's Gate 3 is open.
    Backups go to Backups\ModCheck\<time>_load-order; undo with Restore-ModCheck.ps1.

.EXAMPLE
    .\Fix-LoadOrder.ps1                                   # preview
    .\Fix-LoadOrder.ps1 -Apply                            # write the recommended order
    .\Fix-LoadOrder.ps1 -Apply -Disable ASTRLglowingeyes.pak
#>
param(
    [switch]$Apply,
    [string[]]$Disable = @(),
    [string[]]$Enable = @()
)
. (Join-Path $PSScriptRoot '_env.ps1')

$a = @()
if ($Apply) { $a += '--apply' }
if ($Disable.Count) { $a += '--disable'; $a += $Disable }
if ($Enable.Count) { $a += '--enable'; $a += $Enable }
Invoke-Py 'fix_order.py' $a
