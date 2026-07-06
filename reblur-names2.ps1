Add-Type -AssemblyName System.Drawing

$dir = "e:\linkedinBeautUI\store-screenshots"
$scale = 40

$jobs = [ordered]@{
    "3-focus-reader-insights.png" = @(
        @(318, 612, 185, 26)     # "Arin Verma commented" (wider + repositioned)
    )
}

function Blur-Region([System.Drawing.Bitmap]$img, [System.Drawing.Graphics]$g, $x, $y, $w, $h) {
    $x = [int]$x; $y = [int]$y; $w = [int]$w; $h = [int]$h
    if ($x -lt 0) { $x = 0 }; if ($y -lt 0) { $y = 0 }
    if (($x + $w) -gt $img.Width) { $w = $img.Width - $x }
    if (($y + $h) -gt $img.Height) { $h = $img.Height - $y }
    if ($w -le 0 -or $h -le 0) { return }
    $region = New-Object System.Drawing.Bitmap($w, $h)
    $rg = [System.Drawing.Graphics]::FromImage($region)
    $rg.DrawImage($img, (New-Object System.Drawing.Rectangle(0, 0, $w, $h)), (New-Object System.Drawing.Rectangle($x, $y, $w, $h)), [System.Drawing.GraphicsUnit]::Pixel)
    $rg.Dispose()
    for ($pass = 0; $pass -lt 4; $pass++) {
        $sw = [Math]::Max(1, [int]($w / $scale)); $sh = [Math]::Max(1, [int]($h / $scale))
        $small = New-Object System.Drawing.Bitmap($sw, $sh)
        $sg = [System.Drawing.Graphics]::FromImage($small)
        $sg.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBilinear
        $sg.DrawImage($region, 0, 0, $sw, $sh); $sg.Dispose()
        $rg2 = [System.Drawing.Graphics]::FromImage($region)
        $rg2.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBilinear
        $rg2.DrawImage($small, 0, 0, $w, $h); $rg2.Dispose(); $small.Dispose()
    }
    $g.DrawImage($region, $x, $y, $w, $h)
    $wash = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(95, 255, 255, 255))
    $g.FillRectangle($wash, $x, $y, $w, $h); $wash.Dispose(); $region.Dispose()
}

foreach ($file in $jobs.Keys) {
    $path = Join-Path $dir $file
    $img = [System.Drawing.Bitmap]::new($path)
    $g = [System.Drawing.Graphics]::FromImage($img)
    foreach ($r in $jobs[$file]) { Blur-Region $img $g $r[0] $r[1] $r[2] $r[3] }
    $g.Dispose()
    $tmp = Join-Path $dir ("_y_" + $file)
    $img.Save($tmp, [System.Drawing.Imaging.ImageFormat]::Png); $img.Dispose()
    Move-Item -Force $tmp $path
    Write-Host ("touched up {0}" -f $file)
}
