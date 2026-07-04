Add-Type -AssemblyName System.Drawing

$dir = "e:\linkedinBeautUI\extension\icons"
New-Item -ItemType Directory -Force -Path $dir | Out-Null

$accent = [System.Drawing.Color]::FromArgb(10, 102, 194)  # #0A66C2
$sizes = @(16, 48, 128)

function New-RoundedPath([System.Drawing.RectangleF]$rect, [float]$radius) {
    $p = New-Object System.Drawing.Drawing2D.GraphicsPath
    $d = $radius * 2
    if ($d -gt $rect.Width) { $d = $rect.Width }
    if ($d -gt $rect.Height) { $d = $rect.Height }
    $p.AddArc($rect.X, $rect.Y, $d, $d, 180, 90)
    $p.AddArc($rect.Right - $d, $rect.Y, $d, $d, 270, 90)
    $p.AddArc($rect.Right - $d, $rect.Bottom - $d, $d, $d, 0, 90)
    $p.AddArc($rect.X, $rect.Bottom - $d, $d, $d, 90, 90)
    $p.CloseFigure()
    return $p
}

foreach ($s in $sizes) {
    $bmp = New-Object System.Drawing.Bitmap($s, $s, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
    $g = [System.Drawing.Graphics]::FromImage($bmp)
    $g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
    $g.Clear([System.Drawing.Color]::Transparent)

    $rect = New-Object System.Drawing.RectangleF(0, 0, $s, $s)
    $path = New-RoundedPath $rect ([float]($s * 0.22))
    $brush = New-Object System.Drawing.SolidBrush($accent)
    $g.FillPath($brush, $path)

    $pad = [float]($s * 0.24)
    $barH = [Math]::Max(1.0, $s * 0.09)
    $gap = [float]($s * 0.14)
    $wFull = [float]($s - $pad * 2)
    $y0 = [float]($s * 0.30)
    $widths = @(1.0, 0.62, 0.82)
    $white = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::White)
    for ($i = 0; $i -lt 3; $i++) {
        $y = [float]($y0 + $i * ($barH + $gap))
        $w = [float]($wFull * $widths[$i])
        $barRect = New-Object System.Drawing.RectangleF($pad, $y, $w, $barH)
        $bp = New-RoundedPath $barRect ([float]($barH / 2))
        $g.FillPath($white, $bp)
        $bp.Dispose()
    }

    $out = Join-Path $dir ("icon" + $s + ".png")
    $bmp.Save($out, [System.Drawing.Imaging.ImageFormat]::Png)
    $g.Dispose()
    $bmp.Dispose()
    Write-Host "wrote $out"
}
