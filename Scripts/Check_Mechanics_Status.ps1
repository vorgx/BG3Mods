# Check Mechanics Status (Placeholder vs Real Data)

$files = @('Passive.txt', 'Spell_Target.txt', 'Spell_Zone.txt', 'Spell_Shout.txt', 'Spell_Jump.txt', 'Spell_Projectile.txt', 'Status_BOOST.txt')
$statsDir = 'C:\Users\tenod\source\repos\BG3Mods\Data\Public\Warrior_Wow_78fe4967-4e62-5491-d981-dd781acca4d7\Stats\Generated\Data'

Write-Host "=== MECHANICS STATUS ===" -ForegroundColor Cyan

foreach ($file in $files) {
    $content = Get-Content "$statsDir\$file" -Raw
    
    $placeholders = ([regex]::Matches($content, 'data "(?:SpellSuccess|StatsFunctors|Boosts)" "Placeholder\(\)"')).Count
    $hasData = ([regex]::Matches($content, 'data "(?:SpellSuccess|StatsFunctors|Boosts)" "[^"]+"')).Count - $placeholders
    
    Write-Host "`n$file :" -ForegroundColor Yellow
    Write-Host "  Placeholder() mechanics: $placeholders" -ForegroundColor Red
    Write-Host "  Real mechanics data: $hasData" -ForegroundColor Green
    
    if ($placeholders -eq 0) {
        Write-Host "  ✅ No placeholders - ready to use!" -ForegroundColor Green
    }
}
