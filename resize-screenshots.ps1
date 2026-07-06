Add-Type -AssemblyName System.Drawing

$src = "e:\linkedinBeautUI"
$out = "e:\linkedinBeautUI\store-screenshots"
New-Item -ItemType Directory -Force -Path $out | Out-Null

# target -> desired output name (numbered for store ordering)
$map = [ordered]@{
    "Original Cluttered.png" = "1-original-cluttered.png"
    "zen mode.png"           = "2-zen-mode.png"
    "Executive Mode.png"     = "3-executive-mode.png"
    "extension controls.png" = "4-extension-controls.png"
}

$TW = 1280
$TH = 800

foreach ($k in $map.Keys) {
    $inPath = Join-Path $src $k
    $outPath = Join-Path $out $map[$k]

    $img = [System.Drawing.Image]::FromFile($inPath)

    # scale to COVER, then center-crop to 1280x800
    $scale = [Math]::Max($TW / $img.Width, $TH / $img.Height)
    $sw = [int][Math]::Ceiling($img.Width * $scale)
    $sh = [int][Math]::Ceiling($img.Height * $scale)
    $ox = [int](($TW - $sw) / 2)
    $oy = [int](($TH - $sh) / 2)

    $bmp = New-Object System.Drawing.Bitmap($TW, $TH, [System.Drawing.Imaging.PixelFormat]::Format24bppRgb)
    $g = [System.Drawing.Graphics]::FromImage($bmp)
    $g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
    $g.PixelOffsetMode = [System.Drawing.Drawing2D.PixelOffsetMode]::HighQuality
    $g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::HighQuality
    $g.Clear([System.Drawing.Color]::White)
    $g.DrawImage($img, $ox, $oy, $sw, $sh)

    $bmp.Save($outPath, [System.Drawing.Imaging.ImageFormat]::Png)
    $g.Dispose(); $bmp.Dispose(); $img.Dispose()
    Write-Host ("{0} -> {1} ({2}x{3})" -f $k, $map[$k], $TW, $TH)
}
