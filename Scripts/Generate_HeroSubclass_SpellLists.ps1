param(
    [Parameter(Mandatory=$false)]
    [string]$CsvPath = ".\SpellList_UUID_Mapping.csv",
    
    [Parameter(Mandatory=$false)]
    [string]$OutputPath = ".\HeroSubclass_SpellLists_Generated.xml"
)

Write-Host "`n[GENERATE HERO SUBCLASS SPELLLISTS]" -ForegroundColor Cyan
Write-Host "=" * 80 -ForegroundColor Cyan

# Read CSV
Write-Host "`n[STEP 1] Reading SpellList_UUID_Mapping.csv..." -ForegroundColor Yellow
$Csv = Import-Csv $CsvPath

# Filter for hero subclasses only (levels 13+)
$HeroEntries = $Csv | Where-Object { 
    [int]$_.Level -ge 13 -and $_.Spec -match "(Colossus|Slayers|MountainThane)"
}

Write-Host "[INFO] Found $($HeroEntries.Count) hero subclass entries" -ForegroundColor Cyan

if ($HeroEntries.Count -ne 30) {
    Write-Host "[WARN] Expected 30 entries, found $($HeroEntries.Count)" -ForegroundColor Yellow
}

# Group by subclass for organized output
$GroupedBySubclass = $HeroEntries | Group-Object -Property Spec

Write-Host "`n[STEP 2] Generating SpellList XML nodes..." -ForegroundColor Yellow

$XmlContent = @()

foreach ($Subclass in $GroupedBySubclass) {
    $SubclassName = $Subclass.Name
    Write-Host "`n  Processing: $SubclassName" -ForegroundColor Cyan
    
    # Add comment header for subclass
    $XmlContent += "                <!-- $SubclassName Hero Subclass Spell Lists -->"
    
    # Sort entries by level
    $SortedEntries = $Subclass.Group | Sort-Object { [int]$_.Level }
    
    foreach ($Entry in $SortedEntries) {
        $Level = $Entry.Level
        $UUID = $Entry.UUID
        $SpellCount = [int]$Entry.SpellCount
        
        Write-Host "    L$Level - UUID: $UUID (SpellCount: $SpellCount)" -ForegroundColor Gray
        
        # Generate Comment
        $Comment = "$SubclassName Level $Level Spells"
        
        # Generate Spells attribute (empty for Zero SpellList approach)
        # Hero talents are auto-granted via PassivesAdded in Progressions.lsx
        $Spells = ""
        
        # Build XML node
        $XmlContent += "                <node id=`"SpellList`">"
        $XmlContent += "                    <attribute id=`"Comment`" type=`"LSString`" value=`"$Comment`"/>"
        $XmlContent += "                    <attribute id=`"Spells`" type=`"LSString`" value=`"$Spells`"/>"
        $XmlContent += "                    <attribute id=`"UUID`" type=`"guid`" value=`"$UUID`"/>"
        $XmlContent += "                </node>"
    }
}

Write-Host "`n[STEP 3] Writing to $OutputPath..." -ForegroundColor Yellow

# Add XML structure for context (will be extracted for insertion)
$FullXml = @"
<?xml version="1.0" encoding="UTF-8"?>
<save>
    <version major="4" minor="0" revision="9" build="0"/>
    <region id="SpellLists">
        <node id="root">
            <children>
$($XmlContent -join "`n")
            </children>
        </node>
    </region>
</save>
"@

$FullXml | Out-File -FilePath $OutputPath -Encoding UTF8

Write-Host "[SUCCESS] Generated $($HeroEntries.Count) SpellList nodes" -ForegroundColor Green
Write-Host "[OUTPUT] $OutputPath" -ForegroundColor Cyan

Write-Host "`n[SUMMARY]" -ForegroundColor Cyan
Write-Host "=" * 80 -ForegroundColor Cyan
Write-Host "  Hero Subclasses: $($GroupedBySubclass.Count)" -ForegroundColor White
foreach ($Subclass in $GroupedBySubclass) {
    Write-Host "    $($Subclass.Name): $($Subclass.Count) spell lists" -ForegroundColor Gray
}
Write-Host "  Total SpellList nodes: $($HeroEntries.Count)" -ForegroundColor Green
Write-Host "`n[NEXT] Insert nodes into SpellLists.lsx after Protection Level 12" -ForegroundColor Yellow
