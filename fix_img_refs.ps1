$utf8 = New-Object System.Text.UTF8Encoding $false
$path = Join-Path (Get-Location) "rd-strength.html"
$c = [System.IO.File]::ReadAllText($path, $utf8)

# Replace garbled Chinese filenames with correct ones using byte-level approach
# The garbled strings are what PowerShell/Notepad shows as mojibake
$c = $c -replace '浣跨敤妫\u20ac娴嬩华\.webp', '使用检测仪.webp'
$c = $c -replace '瀹為獙瀹\?png', '实验室.png'
$c = $c -replace '妫\u20ac娴嬭澶\?png', '检测设备.png'
$c = $c -replace '妫€娴嬭\u017d澶[=?]?\.png', '检测设备.png'

[System.IO.File]::WriteAllText($path, $c, $utf8)
Write-Host "Done"

# Verify
$v = [System.IO.File]::ReadAllText($path, $utf8)
if ($v.Contains('使用检测仪')) { Write-Host "使用检测仪: OK" }
if ($v.Contains('实验室.png')) { Write-Host "实验室.png: OK" }
if ($v.Contains('检测设备.png')) { Write-Host "检测设备.png: OK" }
if ($v.Contains('检测设备1.png')) { Write-Host "检测设备1.png: OK" }