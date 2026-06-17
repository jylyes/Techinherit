$encoding = New-Object System.Text.UTF8Encoding $false
$files = Get-ChildItem -Filter "*.html"

$broken = "if (e.target.closest('.fa-chevron-down')) {`n                        return;`n                    }`n                    e.preventDefault();`n                    var parent = this.closest('.nav-dropdown');`n                    if (parent)"

$fixed = "if (e.target.closest('.fa-chevron-down')) {`n                        e.preventDefault();`n                        var parent = this.closest('.nav-dropdown');`n                        if (parent)"

$n = 0
foreach ($f in $files) {
    $c = [System.IO.File]::ReadAllText($f.FullName, $encoding)
    if ($c.Contains($broken)) {
        $c = $c.Replace($broken, $fixed)
        [System.IO.File]::WriteAllText($f.FullName, $c, $encoding)
        Write-Host "FIXED: $($f.Name)"
        $n++
    }
}
Write-Host "Done: $n files"