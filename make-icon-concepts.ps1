Add-Type -AssemblyName System.Drawing
Add-Type -AssemblyName System.Drawing.Drawing2D

$dir = "e:\linkedinBeautUI\icon-concepts"
if (-not (Test-Path $dir)) { New-Item -ItemType Directory -Path $dir | Out-Null }
$S = 128

function New-Canvas {
    $bmp = New-Object System.Drawing.Bitmap($S, $S, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
    $g = [System.Drawing.Graphics]::FromImage($bmp)
    $g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
    $g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
    return @($bmp, $g)
}

function Add-RoundedGradient([System.Drawing.Graphics]$g, [int]$radius, $c1, $c2) {
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

function Bar([System.Drawing.Graphics]$g, $brush, $x, $y, $w, $h) {
    $rr = $h
    $p = New-Object System.Drawing.Drawing2D.GraphicsPath
    $p.AddArc($x, $y, $rr, $rr, 90, 180)
    $p.AddArc($x + $w - $rr, $y, $rr, $rr, 270, 180)
    $p.CloseFigure()
    $g.FillPath($brush, $p); $p.Dispose()
}

$blueTop = [System.Drawing.Color]::FromArgb(255, 14, 118, 214)
$blueBot = [System.Drawing.Color]::FromArgb(255, 6, 74, 150)
$white = [System.Drawing.Color]::White

# ---------- Concept A: Funnel (filter) + droplet ----------
$r = New-Canvas; $bmp = $r[0]; $g = $r[1]
Add-RoundedGradient $g 28 $blueTop $blueBot
$wb = New-Object System.Drawing.SolidBrush($white)
$fun = New-Object System.Drawing.Drawing2D.GraphicsPath
$pts = @(
    (New-Object System.Drawing.PointF(32, 38)),
    (New-Object System.Drawing.PointF(96, 38)),
    (New-Object System.Drawing.PointF(72, 72)),
    (New-Object System.Drawing.PointF(72, 90)),
    (New-Object System.Drawing.PointF(56, 90)),
    (New-Object System.Drawing.PointF(56, 72))
)
$fun.AddPolygon($pts)
$g.FillPath($wb, $fun)
$g.FillEllipse($wb, 57, 98, 14, 16)
$bmp.Save((Join-Path $dir "concept-A-funnel.png"), [System.Drawing.Imaging.ImageFormat]::Png)
$wb.Dispose(); $g.Dispose(); $bmp.Dispose()

# ---------- Concept B: Refined feed lines (taper) + sparkle ----------
$r = New-Canvas; $bmp = $r[0]; $g = $r[1]
Add-RoundedGradient $g 28 $blueTop $blueBot
$wb = New-Object System.Drawing.SolidBrush($white)
Bar $g $wb 32 44 62 12
Bar $g $wb 32 64 46 12
Bar $g $wb 32 84 30 12
$spx = 92; $spy = 42
$sp = New-Object System.Drawing.Drawing2D.GraphicsPath
$spts = @(
    (New-Object System.Drawing.PointF($spx, ($spy - 13))),
    (New-Object System.Drawing.PointF(($spx + 4), ($spy - 4))),
    (New-Object System.Drawing.PointF(($spx + 13), $spy)),
    (New-Object System.Drawing.PointF(($spx + 4), ($spy + 4))),
    (New-Object System.Drawing.PointF($spx, ($spy + 13))),
    (New-Object System.Drawing.PointF(($spx - 4), ($spy + 4))),
    (New-Object System.Drawing.PointF(($spx - 13), $spy)),
    (New-Object System.Drawing.PointF(($spx - 4), ($spy - 4)))
)
$sp.AddPolygon($spts); $g.FillPath($wb, $sp); $sp.Dispose()
$bmp.Save((Join-Path $dir "concept-B-refined-lines.png"), [System.Drawing.Imaging.ImageFormat]::Png)
$wb.Dispose(); $g.Dispose(); $bmp.Dispose()

# ---------- Concept C: Funnel built from feed lines ----------
$r = New-Canvas; $bmp = $r[0]; $g = $r[1]
Add-RoundedGradient $g 28 $blueTop $blueBot
$wb = New-Object System.Drawing.SolidBrush($white)
$cx = 64
$widths = @(66, 50, 34, 20)
$y = 38
foreach ($w in $widths) {
    Bar $g $wb ($cx - $w / 2) $y $w 11
    $y += 17
}
$g.FillRectangle($wb, ($cx - 5), $y, 10, 8)
$g.FillEllipse($wb, ($cx - 7), ($y + 11), 14, 15)
$bmp.Save((Join-Path $dir "concept-C-funnel-lines.png"), [System.Drawing.Imaging.ImageFormat]::Png)
$wb.Dispose(); $g.Dispose(); $bmp.Dispose()

Write-Host "Wrote 3 concepts to $dir"
