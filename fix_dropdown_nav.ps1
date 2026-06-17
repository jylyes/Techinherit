$encoding = [System.Text.Encoding]::UTF8
$path = Join-Path (Get-Location) "raw-materials.html"
$c = [System.IO.File]::ReadAllText($path, $encoding)

$wrong = 'if (window.innerWidth > 992 && !e.target.closest(''.fa-chevron-down'')) {
                        e.preventDefault();
                        var parent = this.closest(''.nav-dropdown'');
                    }
                    if (parent) {
                        parent.classList.toggle(''is-open'');
                    }'

$correct = 'if (e.target.closest(''.fa-chevron-down'')) {
                        e.preventDefault();
                        var parent = this.closest(''.nav-dropdown'');
                        if (parent) {
                            parent.classList.toggle(''is-open'');
                        }
                    }'

$c = $c.Replace($wrong, $correct)
[System.IO.File]::WriteAllText($path, $c, $encoding)
Write-Host "Fixed"