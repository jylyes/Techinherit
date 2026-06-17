$encoding = New-Object System.Text.UTF8Encoding $false
$files = Get-ChildItem -Filter "*.html"

$n = 0
foreach ($f in $files) {
    $c = [System.IO.File]::ReadAllText($f.FullName, $encoding)
    
    $startMarker = "document.querySelectorAll('.dropdown-trigger').forEach(function(trigger) {"
    $endMarker = "document.addEventListener('click', function(e) {"
    
    $startIdx = $c.IndexOf($startMarker)
    $endIdx = $c.IndexOf($endMarker)
    
    if ($startIdx -ge 0 -and $endIdx -gt $startIdx) {
        $lineStart = $c.LastIndexOf("`n", $startIdx) + 1
        $indent = $startIdx - $lineStart
        $s = " " * $indent
        
        $newBlock = $s + "document.querySelectorAll('.dropdown-trigger').forEach(function(trigger) {`r`n"
        $newBlock += $s + "    trigger.addEventListener('click', function(e) {`r`n"
        $newBlock += $s + "        if (e.target.closest('.fa-chevron-down')) {`r`n"
        $newBlock += $s + "            e.preventDefault();`r`n"
        $newBlock += $s + "            var parent = this.closest('.nav-dropdown');`r`n"
        $newBlock += $s + "            if (parent) {`r`n"
        $newBlock += $s + "                parent.classList.toggle('is-open');`r`n"
        $newBlock += $s + "            }`r`n"
        $newBlock += $s + "        }`r`n"
        $newBlock += $s + "    });`r`n"
        $newBlock += $s + "});"
        
        # Find first `});` after startIdx
        $firstClose = $c.IndexOf("});", $startIdx)
        if ($firstClose -lt 0) { continue }
        # Find second `});` after firstClose
        $secondClose = $c.IndexOf("});", $firstClose + 1)
        if ($secondClose -lt 0) { continue }
        
        $before = $c.Substring(0, $startIdx)
        $after = $c.Substring($secondClose + 3)
        $c = $before + $newBlock + $after
        
        [System.IO.File]::WriteAllText($f.FullName, $c, $encoding)
        Write-Host "FIXED: $($f.Name)"
        $n++
    }
}
Write-Host "Done: $n files"