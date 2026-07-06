Add-Type -AssemblyName System.Drawing
Add-Type -AssemblyName System.Drawing.Drawing2D

$dir = "e:\linkedinBeautUI\extension\icons"
if (-not (Test-Path $dir)) { New-Item -ItemType Directory -Path $dir | Out-Null }

$blueTop = [System.Drawing.Color]::FromArgb(255, 14, 118, 214)
$blueBot = [System.Drawing.Color]::FromArgb(255, 6, 74, 150)
$white = [System.Drawing.Color]::White

function Add-RoundedGradient([System.Drawing.Graphics]$g, [int]$S, [double]$radius, $c1, $c2) {
    $rect = New-Object System.Drawing.Rectangle(0, 0, $S, $S)
    $path = New-Object System.Drawing.Drawing2D.GraphicsPath
    $d = $radius * 2
    $path.AddArc(0, 0, $d, $d, 180, 90)
    $path.AddArc($S - $d, 0, $d, $d, 270, 90)
    $path.AddArc($S - $d, $S - $d, $d, $d, 0, 90)
    $path.AddArc(0, $S - $d, $d, $d, 90, 90)
    $path.CloseFigure()
    $br = New-Object System.Drawing.Drawing2D.LinearGradientBrush($rect, $c1, $c2, 55.0)
    $g.FillPath($br, $path)
    $br.Dispose()
}

function Bar([System.Drawing.Graphics]$g, $brush, [double]$x, [double]$y, [double]$w, [double]$h) {
    $rr = $h
    $p = New-Object System.Drawing.Drawing2D.GraphicsPath
    $p.AddArc($x, $y, $rr, $rr, 90, 180)
    $p.AddArc($x + $w - $rr, $y, $rr, $rr, 270, 180)
    $p.CloseFigure()
    $g.FillPath($brush, $p); $p.Dispose()
}

function Make-Icon([int]$S) {
    $bmp = New-Object System.Drawing.Bitmap($S, $S, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
    $g = [System.Drawing.Graphics]::FromImage($bmp)
    $g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
    $g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic

    $k = $S / 128.0
    Add-RoundedGradient $g $S (28 * $k) $blueTop $blueBot

    $wb = New-Object System.Drawing.SolidBrush($white)
    $cx = 64 * $k
    $widths = @(66, 50, 34, 20)
    $y = 38 * $k
    foreach ($w in $widths) {
        $ww = $w * $k
        $hh = 11 * $k
        Bar $g $wb ($cx - $ww / 2) $y $ww $hh
        $y += 17 * $k
    }
    $g.FillRectangle($wb, ($cx - 5 * $k), $y, (10 * $k), (8 * $k))
    $g.FillEllipse($wb, ($cx - 7 * $k), ($y + 11 * $k), (14 * $k), (15 * $k))

    $bmp.Save((Join-Path $dir ("icon{0}.png" -f $S)), [System.Drawing.Imaging.ImageFormat]::Png)
    $wb.Dispose(); $g.Dispose(); $bmp.Dispose()
}

foreach ($sz in @(16, 48, 128)) { Make-Icon $sz }
Write-Host "Wrote icon16/48/128 to $dir"
