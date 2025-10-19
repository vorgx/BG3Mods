# Template Validation Test: meta.lsx (FILE 1)
# Validates mod metadata, UUIDs, folder naming, dependencies

param(
    [Parameter(Mandatory=$true)]
    [string]$ModPath,
    
    [Parameter(Mandatory=$false)]
    [string]$ModUUID
)

# Color output helpers
function Write-Pass { param($Message) Write-Host "[PASS] $Message" -ForegroundColor Green }
function Write-Fail { param($Message) Write-Host "[FAIL] $Message" -ForegroundColor Red; $script:FailCount++ }
function Write-Warn { param($Message) Write-Host "[WARN] $Message" -ForegroundColor Yellow }
function Write-Info { param($Message) Write-Host "[INFO] $Message" -ForegroundColor Cyan }

$FailCount = 0

Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host "FILE 1 VALIDATION: meta.lsx" -ForegroundColor Cyan
Write-Host "========================================`n" -ForegroundColor Cyan

# Test 1: ModPath exists
Write-Info "Checking mod path..."
if (-not (Test-Path $ModPath)) {
    Write-Fail "Mod path not found: $ModPath"
    exit 1
}
Write-Pass "Mod path exists"

# Test 2: Find meta.lsx
Write-Info "Searching for meta.lsx..."
$ModsFolders = Get-ChildItem -Path (Join-Path $ModPath "Mods") -Directory -ErrorAction SilentlyContinue
if (-not $ModsFolders) {
    Write-Fail "No mod folders found in Mods directory"
    exit 1
}

$MetaFiles = $ModsFolders | ForEach-Object { 
    Get-ChildItem -Path $_.FullName -Filter "meta.lsx" -File -ErrorAction SilentlyContinue 
} | Select-Object -First 1

if (-not $MetaFiles) {
    Write-Fail "meta.lsx not found"
    exit 1
}

$MetaPath = $MetaFiles.FullName
$ModFolder = Split-Path $MetaPath -Parent
$ModFolderName = Split-Path $ModFolder -Leaf

Write-Pass "Found meta.lsx"
Write-Info "Mod folder: $ModFolderName"

# Test 3: Parse XML
try {
    [xml]$MetaXml = Get-Content $MetaPath -Raw -ErrorAction Stop
    Write-Pass "XML parsed successfully"
} catch {
    Write-Fail "Failed to parse XML: $($_.Exception.Message)"
    exit 1
}

# Extract ModuleInfo
$ModuleInfo = $MetaXml.save.region.node.children.node | Where-Object { $_.id -eq "ModuleInfo" }
if (-not $ModuleInfo) {
    Write-Fail "ModuleInfo node not found"
    exit 1
}

# Helper to get attribute
function Get-Attr {
    param($Node, $Name)
    $attr = $Node.attribute | Where-Object { $_.id -eq $Name }
    return $attr.value
}

# Extract values
$MetaUUID = Get-Attr $ModuleInfo "UUID"
$MetaFolder = Get-Attr $ModuleInfo "Folder"
$MetaName = Get-Attr $ModuleInfo "Name"
$MetaAuthor = Get-Attr $ModuleInfo "Author"
$MetaVersion64 = Get-Attr $ModuleInfo "Version64"
$MetaPublishVersion = Get-Attr $ModuleInfo "PublishVersion"

Write-Info "UUID: $MetaUUID"
Write-Info "Name: $MetaName"
Write-Info "Version: $MetaVersion64"

# Test UUID
if ([string]::IsNullOrWhiteSpace($MetaUUID)) {
    Write-Fail "UUID is empty"
} elseif ($MetaUUID -notmatch '^[a-f0-9]{8}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{12}$') {
    Write-Fail "UUID format invalid: $MetaUUID"
} else {
    Write-Pass "UUID valid"
}

# Test UUID matches expected
if ($ModUUID -and ($MetaUUID -ne $ModUUID)) {
    Write-Fail "UUID mismatch! Expected: $ModUUID, Found: $MetaUUID"
} elseif ($ModUUID) {
    Write-Pass "UUID matches expected"
}

# Test UUID in folder name
if ($ModFolderName -notlike "*$MetaUUID*") {
    Write-Fail "UUID not in folder name"
} else {
    Write-Pass "UUID in folder name"
}

# Test Folder attribute
if ($MetaFolder -ne $ModFolderName) {
    Write-Fail "Folder attribute mismatch"
} else {
    Write-Pass "Folder attribute matches"
}

# Test Public folder
$PublicPath = Join-Path $ModPath "Public\$ModFolderName"
if (-not (Test-Path $PublicPath)) {
    Write-Fail "Public folder not found"
} else {
    Write-Pass "Public folder found"
}

# Test Name
if ([string]::IsNullOrWhiteSpace($MetaName)) {
    Write-Fail "Name is empty"
} else {
    Write-Pass "Name populated"
}

# Test Author
if ([string]::IsNullOrWhiteSpace($MetaAuthor)) {
    Write-Fail "Author is empty"
} else {
    Write-Pass "Author populated"
}

# Test versions match
# Note: PublishVersion may be in ModuleInfo attribute OR in child PublishVersion node
$MetaPublishAttr = Get-Attr $ModuleInfo "PublishVersion"
if ($MetaPublishAttr) {
    # PublishVersion as direct attribute
    if ($MetaVersion64 -ne $MetaPublishAttr) {
        Write-Fail "Version mismatch: Version64=$MetaVersion64, PublishVersion=$MetaPublishAttr"
    } else {
        Write-Pass "Versions match"
    }
} else {
    # PublishVersion in child node (Warlock template pattern)
    $PubVerNode = $ModuleInfo.children.node | Where-Object { $_.id -eq "PublishVersion" }
    if ($PubVerNode) {
        $PubVer = Get-Attr $PubVerNode "Version64"
        if ($MetaVersion64 -ne $PubVer) {
            Write-Fail "Version mismatch: Version64=$MetaVersion64, PublishVersion=$PubVer"
        } else {
            Write-Pass "Versions match (child node pattern)"
        }
    } else {
        Write-Warn "No PublishVersion found (neither attribute nor child node)"
    }
}

# Test Dependencies
$Dependencies = $MetaXml.save.region.node.children.node | Where-Object { $_.id -eq "Dependencies" }
if (-not $Dependencies) {
    Write-Fail "Dependencies node not found"
} else {
    $DepCount = ($Dependencies.children.node | Measure-Object).Count
    Write-Pass "Dependencies found: $DepCount"
    
    $DepNames = $Dependencies.children.node.attribute | Where-Object { $_.id -eq "Name" } | Select-Object -ExpandProperty value
    
    if ($DepNames -notcontains "Gustav") {
        Write-Fail "Missing Gustav dependency"
    } else {
        Write-Pass "Gustav dependency present"
    }
}

# Final summary
Write-Host "`n========================================" -ForegroundColor Cyan
if ($FailCount -eq 0) {
    Write-Host "[SUCCESS] ALL TESTS PASSED" -ForegroundColor Green
    Write-Host "========================================" -ForegroundColor Cyan
    exit 0
} else {
    Write-Host "[FAILED] $FailCount test(s) failed" -ForegroundColor Red
    Write-Host "========================================" -ForegroundColor Cyan
    exit 1
}
