Add-Type -AssemblyName System.Drawing

$dir = "e:\linkedinBeautUI\store-screenshots"
$raw = Join-Path $dir "raw"
$TW = 1280; $TH = 800

# ---- source -> output name, with personal-content blur regions in ORIGINAL px ----
# rect = @(x, y, w, h)
$jobs = [ordered]@{
    "1-original-cluttered.png" = @{
        out    = "1-original-cluttered.png"
        blur   = @(
            @(168, 110, 172, 186),   # own profile card (banner/photo/name/title)
            @(356, 251, 320, 44),    # "Harish Prajapat" suggested header
            @(850, 636, 122, 70),    # bottom-right promoted (first name + avatar)
            @(1146, 768, 44, 34)     # messaging launcher avatar
        )
    }
    "Compact Grid Mode.png" = @{
        out    = "2-compact-grid.png"
        blur   = @(
            @(486, 196, 240, 34),    # "Saquib Ahmad likes this"
            @(484, 248, 626, 82),    # Muniba Mazari avatar+name+headline
            @(471, 422, 700, 392),   # personal couple photo
            @(1193, 203, 536, 98),   # Ben Rycroft avatar+name+headline
            @(178, 924, 268, 34),    # "Sanyam Jain commented"
            @(484, 972, 626, 82),    # Ponnurangam avatar+name+headline
            @(1193, 928, 566, 82)    # Alexander Gomes avatar+name+headline
        )
    }
    "Zen mode with AI and TLDR screenshot.png" = @{
        out    = "3-focus-reader-insights.png"
        blur   = @(
            @(723, 193, 630, 136),   # Rushika Rai: likes-this + avatar + name + headline + services
            @(723, 1006, 268, 34),   # "Arin Verma commented"
            @(723, 1048, 630, 96)    # Yash Sharma avatar+name+headline
        )
    }
    "Zen mode with post limit reached.png" = @{
        out    = "4-daily-limit.png"
        blur   = @(
            @(398, 233, 336, 78)     # faded post author behind the break modal
        )
    }
}

$scale = 26   # blur strength (higher = stronger)

function Blur-Region([System.Drawing.Bitmap]$img, [System.Drawing.Graphics]$g, $x, $y, $w, $h) {
    $x = [int]$x; $y = [int]$y; $w = [int]$w; $h = [int]$h
    if ($x -lt 0) { $x = 0 }; if ($y -lt 0) { $y = 0 }
    if (($x + $w) -gt $img.Width) { $w = $img.Width - $x }
    if (($y + $h) -gt $img.Height) { $h = $img.Height - $y }
    if ($w -le 0 -or $h -le 0) { return }

    $region = New-Object System.Drawing.Bitmap($w, $h)
    $rg = [System.Drawing.Graphics]::FromImage($region)
    $srcRect = New-Object System.Drawing.Rectangle($x, $y, $w, $h)
    $rg.DrawImage($img, (New-Object System.Drawing.Rectangle(0, 0, $w, $h)), $srcRect, [System.Drawing.GraphicsUnit]::Pixel)
    $rg.Dispose()

    for ($pass = 0; $pass -lt 3; $pass++) {
        $sw = [Math]::Max(1, [int]($w / $scale))
        $sh = [Math]::Max(1, [int]($h / $scale))
        $small = New-Object System.Drawing.Bitmap($sw, $sh)
        $sg = [System.Drawing.Graphics]::FromImage($small)
        $sg.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBilinear
        $sg.DrawImage($region, 0, 0, $sw, $sh)
        $sg.Dispose()

        $rg2 = [System.Drawing.Graphics]::FromImage($region)
        $rg2.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBilinear
        $rg2.PixelOffsetMode = [System.Drawing.Drawing2D.PixelOffsetMode]::HighQuality
        $rg2.DrawImage($small, 0, 0, $w, $h)
        $rg2.Dispose()
        $small.Dispose()
    }

    $g.DrawImage($region, $x, $y, $w, $h)
    $wash = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(70, 255, 255, 255))
    $g.FillRectangle($wash, $x, $y, $w, $h)
    $wash.Dispose()
    $region.Dispose()
}

foreach ($file in $jobs.Keys) {
    $spec = $jobs[$file]
    $inPath = Join-Path $raw $file
    $outPath = Join-Path $dir $spec.out

    $img = [System.Drawing.Bitmap]::new($inPath)
    $g = [System.Drawing.Graphics]::FromImage($img)
    $g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBilinear
    $g.PixelOffsetMode = [System.Drawing.Drawing2D.PixelOffsetMode]::HighQuality

    foreach ($r in $spec.blur) { Blur-Region $img $g $r[0] $r[1] $r[2] $r[3] }
    $g.Dispose()

    # ---- resize: COVER, biased to keep the RIGHT edge (popup panel), crop from left ----
    $scaleF = [Math]::Max($TW / $img.Width, $TH / $img.Height)
    $sw = [int][Math]::Ceiling($img.Width * $scaleF)
    $sh = [int][Math]::Ceiling($img.Height * $scaleF)
    $ox = $TW - $sw          # keep right edge (<= 0)
    $oy = [int](($TH - $sh) / 2)

    $bmp = New-Object System.Drawing.Bitmap($TW, $TH, [System.Drawing.Imaging.PixelFormat]::Format24bppRgb)
    $bg = [System.Drawing.Graphics]::FromImage($bmp)
    $bg.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
    $bg.PixelOffsetMode = [System.Drawing.Drawing2D.PixelOffsetMode]::HighQuality
    $bg.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::HighQuality
    $bg.Clear([System.Drawing.Color]::White)
    $bg.DrawImage($img, $ox, $oy, $sw, $sh)
    $bg.Dispose()

    $tmp = Join-Path $dir ("_tmp_" + $spec.out)
    $bmp.Save($tmp, [System.Drawing.Imaging.ImageFormat]::Png)
    $bmp.Dispose(); $img.Dispose()
    Move-Item -Force $tmp $outPath
    Write-Host ("{0}  ->  {1}  ({2}x{3})" -f $file, $spec.out, $TW, $TH)
}
