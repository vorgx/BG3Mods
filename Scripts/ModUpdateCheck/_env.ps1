# Shared setup for the ModUpdateCheck commands: creates the Python venv on first use and defines Invoke-Py.
# Dot-source it:  . (Join-Path $PSScriptRoot '_env.ps1')

# Windows PowerShell 5.1 turns native stderr (pip notices, Python warnings) into errors under 'Stop',
# so failures are detected from exit codes instead.
$ErrorActionPreference = 'Continue'

$script:McHere = $PSScriptRoot
$script:McWork = Join-Path $PSScriptRoot 'work'
$script:McPy = Join-Path $McWork 'venv\Scripts\python.exe'
New-Item -ItemType Directory -Force $McWork | Out-Null

if (-not (Test-Path $McPy)) {
    Write-Host '[INFO] Creating Python environment (first run only)...'
    python -m venv (Join-Path $McWork 'venv')
    if ($LASTEXITCODE) { throw 'python -m venv failed. Is Python 3.10+ on PATH?' }
    & $McPy -m pip install -q --disable-pip-version-check -r (Join-Path $McHere 'requirements.txt')
    if ($LASTEXITCODE) { throw 'pip install failed.' }
}
$env:BG3MC_WORK = $McWork

function Invoke-Py([string]$script, [string[]]$scriptArgs = @()) {
    & $script:McPy -I (Join-Path $script:McHere $script) @scriptArgs
    if ($LASTEXITCODE) { throw "$script failed (exit $LASTEXITCODE)." }
}
