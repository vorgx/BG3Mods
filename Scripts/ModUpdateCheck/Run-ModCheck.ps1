<#
.SYNOPSIS
    Checks every installed BG3 mod for updates (Nexus + mod.io) and checks the load order, then writes an HTML report.

.DESCRIPTION
    Reads the paks in %LOCALAPPDATA%\Larian Studios\Baldur's Gate 3\Mods and the load order in
    PlayerProfiles\Public\modsettings.lsx. It never changes either. The Nexus and mod.io API keys are read from
    BG3ModHelper's settings (%LOCALAPPDATA%\BG3ModHelper\settings.json); none are stored here.

    Output (in -OutDir, default ..\..\Reports):
      BG3_Mod_Check_<date>.html                  the report (Updates tab + Load order tab)
      BG3_Recommended_Load_Order_<date>.json     recommended order, importable in BG3 Mod Manager

.PARAMETER UseCache
    Reuse the Nexus/mod.io data from the last run instead of fetching it again (fast re-render after editing config).

.PARAMETER OutDir
    Where to write the report. Defaults to the project's Reports folder.

.EXAMPLE
    .\Run-ModCheck.ps1
#>
param(
    [switch]$UseCache,
    [string]$OutDir = (Join-Path $PSScriptRoot '..\..\Reports')
)
# Windows PowerShell 5.1 turns native stderr (pip notices, Python warnings) into errors under 'Stop',
# so failures are detected from exit codes instead.
$ErrorActionPreference = 'Continue'

$work = Join-Path $PSScriptRoot 'work'
$venv = Join-Path $work 'venv'
$py = Join-Path $venv 'Scripts\python.exe'
$date = Get-Date -Format 'yyyy-MM-dd'
New-Item -ItemType Directory -Force $work | Out-Null
New-Item -ItemType Directory -Force $OutDir | Out-Null
$OutDir = (Resolve-Path $OutDir).Path

if (-not (Test-Path $py)) {
    Write-Host '[INFO] Creating Python environment (first run only)...'
    python -m venv $venv
    if ($LASTEXITCODE) { throw 'python -m venv failed. Is Python 3.10+ on PATH?' }
    & $py -m pip install -q --disable-pip-version-check -r (Join-Path $PSScriptRoot 'requirements.txt')
    if ($LASTEXITCODE) { throw 'pip install failed.' }
}

$env:BG3MC_WORK = $work
# verify.json depends on this run's report; old Nexus/mod.io data would hide new updates
$stale = @('verify.json')
if (-not $UseCache) { $stale += 'nexus_cache.json', 'modio_cache.json' }
foreach ($f in $stale) { Remove-Item (Join-Path $work $f) -ErrorAction SilentlyContinue }

function Step([string]$label, [string]$script, [string[]]$scriptArgs = @()) {
    Write-Host "[INFO] $label"
    & $py -I (Join-Path $PSScriptRoot $script) @scriptArgs
    if ($LASTEXITCODE) { throw "$script failed (exit $LASTEXITCODE)." }
}

$html = Join-Path $OutDir "BG3_Mod_Check_$date.html"
$order = Join-Path $OutDir "BG3_Recommended_Load_Order_$date.json"

Step 'Reading every pak in the Mods folder'               'scan.py'       @((Join-Path $work 'installed.json'))
Step 'Reading load order, dependencies and stat entries'  'lo_scan.py'    @((Join-Path $work 'lo_data.json'))
Step 'Fetching latest versions from Nexus and mod.io'     'fetch.py'
Step 'Comparing versions'                                 'analyze.py'
Step 'Hashing paks against Nexus download manifests'      'verify.py'
Step 'Comparing again with hash results'                  'analyze.py'
Step 'Collecting author load-order notes'                 'lo_notes.py'
Step 'Checking load order'                                'lo_analyze.py'
Step 'Writing the report'                                 'build.py'      @($html)
Copy-Item (Join-Path $work 'recommended_order.json') $order -Force

Write-Host "[PASS] Report: $html"
Write-Host "[PASS] Recommended order (BG3MM: File > Import Order from File): $order"
