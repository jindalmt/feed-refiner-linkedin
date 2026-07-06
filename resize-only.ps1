Add-Type -AssemblyName System.Drawing

$dir = "e:\linkedinBeautUI\store-screenshots"
$raw = Join-Path $dir "raw"
$TW = 1280; $TH = 800

# source -> output (numbered for store order)
$map = [ordered]@{
    "1-original-cluttered.png"                 = "1-original-cluttered.png"
    "Compact Grid Mode.png"                    = "2-compact-grid.png"
    "Zen mode with AI and TLDR screenshot.png" = "3-focus-reader-insights.png"
    "Zen mode with post limit reached.png"     = "4-daily-limit.png"
}

foreach ($file in $map.Keys) {
    $inPath = Join-Path $raw $file
    $outPath = Join-Path $dir $map[$file]
    $img = [System.Drawing.Bitmap]::new($inPath)

    # COVER, biased to keep the RIGHT edge (popup panel), crop from the left
    $scaleF = [Math]::Max($TW / $img.Width, $TH / $img.Height)
    $sw = [int][Math]::Ceiling($img.Width * $scaleF)
    $sh = [int][Math]::Ceiling($img.Height * $scaleF)
    $ox = $TW - $sw
    $oy = [int](($TH - $sh) / 2)

    $bmp = New-Object System.Drawing.Bitmap($TW, $TH, [System.Drawing.Imaging.PixelFormat]::Format24bppRgb)
    $bg = [System.Drawing.Graphics]::FromImage($bmp)
    $bg.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
    $bg.PixelOffsetMode = [System.Drawing.Drawing2D.PixelOffsetMode]::HighQuality
    $bg.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::HighQuality
    $bg.Clear([System.Drawing.Color]::White)
    $bg.DrawImage($img, $ox, $oy, $sw, $sh)
    $bg.Dispose()

    $tmp = Join-Path $dir ("_tmp_" + $map[$file])
    $bmp.Save($tmp, [System.Drawing.Imaging.ImageFormat]::Png)
    $bmp.Dispose(); $img.Dispose()
    Move-Item -Force $tmp $outPath
    Write-Host ("{0}  ->  {1}" -f $file, $map[$file])
}
