$path = 'lib/screen/home_screen.dart'
$content = Get-Content $path
$newContent = @()
$found = $false
foreach ($line in $content) {
    if ($line -match 'if \(hospitalIndex !=' -and -not $found) {
        $newContent += '                                                           ),'
        $found = $true
    }
    $newContent += $line
}
$newContent | Set-Content $path
