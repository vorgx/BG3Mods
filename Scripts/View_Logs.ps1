# BG3Wow Debug Log Viewer
# Quick access to Script Extender logs for troubleshooting

Write-Host "`n=== BG3Wow Debug Log Viewer ===" -ForegroundColor Cyan
Write-Host "Version: 2.0.0 - Equipment Fix + Debug Logging`n" -ForegroundColor Gray

$logFolder = "$env:LOCALAPPDATA\Larian Studios\Baldur's Gate 3\ScriptExtender\Logs"
$consoleLog = "$logFolder\Console.log"
$osirisLog = "$logFolder\Osiris.log"

# Check if Script Extender is installed
if (-not (Test-Path $logFolder)) {
    Write-Host "❌ Script Extender logs folder not found!" -ForegroundColor Red
    Write-Host "`nPlease install BG3 Script Extender:" -ForegroundColor Yellow
    Write-Host "1. Download from: https://github.com/Norbyte/bg3se/releases" -ForegroundColor Cyan
    Write-Host "2. Extract to BG3 game root folder" -ForegroundColor Cyan
    Write-Host "3. Launch game at least once to create logs folder`n" -ForegroundColor Cyan
    
    Write-Host "Expected location: $logFolder`n" -ForegroundColor Gray
    
    Read-Host "Press Enter to exit"
    exit
}

# Check if logs exist
if (-not (Test-Path $consoleLog)) {
    Write-Host "⚠️  Console.log not found - Game hasn't been launched yet" -ForegroundColor Yellow
    Write-Host "Location: $consoleLog`n" -ForegroundColor Gray
    
    Write-Host "Please launch BG3 at least once, then run this script again.`n" -ForegroundColor Cyan
    
    Read-Host "Press Enter to exit"
    exit
}

# Display menu
Write-Host "Choose an option:" -ForegroundColor Green
Write-Host "1. View Console.log (last 100 lines)" -ForegroundColor White
Write-Host "2. Search for [BG3WOW] messages" -ForegroundColor White
Write-Host "3. Search for errors" -ForegroundColor White
Write-Host "4. Open Console.log in Notepad" -ForegroundColor White
Write-Host "5. Open logs folder in Explorer" -ForegroundColor White
Write-Host "6. Copy all logs to Desktop" -ForegroundColor White
Write-Host "7. Clear all logs (fresh start)" -ForegroundColor White
Write-Host "8. Watch log in real-time" -ForegroundColor White
Write-Host ""

$choice = Read-Host "Enter choice (1-8)"

switch ($choice) {
    "1" {
        Write-Host "`n=== Last 100 lines of Console.log ===" -ForegroundColor Cyan
        Get-Content $consoleLog -Tail 100
    }
    
    "2" {
        Write-Host "`n=== Searching for [BG3WOW] messages ===" -ForegroundColor Cyan
        $bgwowLines = Select-String -Path $consoleLog -Pattern "\[BG3WOW\]"
        
        if ($bgwowLines) {
            Write-Host "✅ Found $($bgwowLines.Count) [BG3WOW] messages:`n" -ForegroundColor Green
            $bgwowLines | ForEach-Object { Write-Host $_.Line }
        } else {
            Write-Host "❌ No [BG3WOW] messages found!" -ForegroundColor Red
            Write-Host "This means the mod is NOT loading. Check:" -ForegroundColor Yellow
            Write-Host "  - Mod is enabled in BG3 Mod Manager" -ForegroundColor Cyan
            Write-Host "  - Config.json exists in ScriptExtender folder" -ForegroundColor Cyan
            Write-Host "  - Folder structure matches documentation" -ForegroundColor Cyan
        }
    }
    
    "3" {
        Write-Host "`n=== Searching for errors ===" -ForegroundColor Cyan
        $errors = Select-String -Path $consoleLog -Pattern "Error|Failed|Exception|Fatal" -Context 2,2
        
        if ($errors) {
            Write-Host "⚠️  Found $($errors.Count) potential errors:`n" -ForegroundColor Yellow
            $errors | ForEach-Object { 
                Write-Host "Line $($_.LineNumber):" -ForegroundColor Red
                Write-Host $_.Context.PreContext -ForegroundColor Gray
                Write-Host $_.Line -ForegroundColor Red
                Write-Host $_.Context.PostContext -ForegroundColor Gray
                Write-Host ""
            }
        } else {
            Write-Host "✅ No errors found in Console.log" -ForegroundColor Green
        }
    }
    
    "4" {
        Write-Host "`nOpening Console.log in Notepad..." -ForegroundColor Cyan
        notepad $consoleLog
    }
    
    "5" {
        Write-Host "`nOpening logs folder in Explorer..." -ForegroundColor Cyan
        explorer $logFolder
    }
    
    "6" {
        $desktop = [Environment]::GetFolderPath("Desktop")
        $backupFolder = "$desktop\BG3_Logs_$(Get-Date -Format 'yyyyMMdd_HHmmss')"
        
        Write-Host "`nCopying logs to Desktop..." -ForegroundColor Cyan
        New-Item -ItemType Directory -Path $backupFolder -Force | Out-Null
        Copy-Item "$logFolder\*" $backupFolder -Recurse -Force
        
        Write-Host "✅ Logs copied to: $backupFolder" -ForegroundColor Green
        explorer $backupFolder
    }
    
    "7" {
        Write-Host "`n⚠️  This will delete all current logs!" -ForegroundColor Yellow
        $confirm = Read-Host "Are you sure? (y/n)"
        
        if ($confirm -eq "y") {
            Remove-Item "$logFolder\*.log" -Force
            Write-Host "✅ Logs cleared. Launch game to create fresh logs." -ForegroundColor Green
        } else {
            Write-Host "Cancelled." -ForegroundColor Gray
        }
    }
    
    "8" {
        Write-Host "`n=== Watching Console.log in real-time ===" -ForegroundColor Cyan
        Write-Host "Press Ctrl+C to stop`n" -ForegroundColor Yellow
        Get-Content $consoleLog -Wait -Tail 20
    }
    
    default {
        Write-Host "`n❌ Invalid choice" -ForegroundColor Red
    }
}

Write-Host "`n"
Read-Host "Press Enter to exit"
