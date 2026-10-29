<#
.SYNOPSIS
    Checks every installed BG3 mod for updates (Nexus + mod.io), checks the load order, finds missing add-ons,
    then writes an HTML report.

.DESCRIPTION
    Reads the paks in %LOCALAPPDATA%\Larian Studios\Baldur's Gate 3\Mods and the load order in
    PlayerProfiles\Public\modsettings.lsx. It never changes either (Fix-LoadOrder.ps1 and Update-Mods.ps1 do that,
    with backups). The Nexus and mod.io API keys are read from BG3ModHelper's settings; none are stored here.

    Output (in -OutDir, default ..\..\Reports):
      BG3_Mod_Check_<date>.html                  the report (Updates, Load order and Add-ons tabs)
      BG3_Recommended_Load_Order_<date>.json     recommended order, importable in BG3 Mod Manager

.PARAMETER UseCache
    Reuse the Nexus data from the last run instead of fetching it again (fast re-render after editing config).

.PARAMETER OutDir
    Where to write the report. Defaults to the project's Reports folder.

.EXAMPLE
    .\Run-ModCheck.ps1
#>
param(
    [switch]$UseCache,
    [string]$OutDir = (Join-Path $PSScriptRoot '..\..\Reports')
)
. (Join-Path $PSScriptRoot '_env.ps1')

$date = Get-Date -Format 'yyyy-MM-dd'
New-Item -ItemType Directory -Force $OutDir | Out-Null
$OutDir = (Resolve-Path $OutDir).Path

# verify.json depends on this run's report; old Nexus/mod.io data would hide new updates
$stale = @('verify.json')
if (-not $UseCache) { $stale += 'nexus_cache.json', 'modio_cache.json' }
foreach ($f in $stale) { Remove-Item (Join-Path $McWork $f) -ErrorAction SilentlyContinue }

function Step([string]$label, [string]$script, [string[]]$scriptArgs = @()) {
    Write-Host "[INFO] $label"
    Invoke-Py $script $scriptArgs
}

$html = Join-Path $OutDir "BG3_Mod_Check_$date.html"
$order = Join-Path $OutDir "BG3_Recommended_Load_Order_$date.json"

Step 'Reading every pak in the Mods folder'               'scan.py'       @((Join-Path $McWork 'installed.json'))
Step 'Reading load order, dependencies and stat entries'  'lo_scan.py'    @((Join-Path $McWork 'lo_data.json'))
Step 'Fetching latest versions from Nexus and mod.io'     'fetch.py'
Step 'Comparing versions'                                 'analyze.py'
Step 'Hashing paks against Nexus download manifests'      'verify.py'
Step 'Comparing again with hash results'                  'analyze.py'
Step 'Collecting author load-order notes'                 'lo_notes.py'
Step 'Checking load order'                                'lo_analyze.py'
Step 'Looking for missing requirements and patches'       'addons.py'
Step 'Writing the report'                                 'build.py'      @($html)
Copy-Item (Join-Path $McWork 'recommended_order.json') $order -Force

Write-Host "[PASS] Report: $html"
Write-Host "[PASS] Recommended order (BG3MM: File > Import Order from File): $order"
