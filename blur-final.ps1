Add-Type -AssemblyName System.Drawing

$dir = "e:\linkedinBeautUI\store-screenshots"
$scale = 26   # pixelation: block size ~ region/scale (lower = bigger blocks)

# blur regions in FINAL 1280x800 coords; rect = @(x, y, w, h)
$jobs = [ordered]@{
    "1-original-cluttered.png" = @(
        @(166, 108, 176, 176),   # own profile card (banner/photo/name/title)
        @(363, 120, 38, 36),     # composer own avatar
        @(404, 254, 205, 22),    # "Harish Prajapat" suggested name
        @(363, 363, 40, 22),     # reaction row avatar
        @(864, 636, 62, 48),     # Wizards promoted avatar
        @(1147, 769, 42, 30)     # messaging launcher avatar
    )
    "2-compact-grid.png" = @(
        @(173, 120, 215, 22),    # "Saquib Ahmad likes this"
        @(175, 150, 348, 46),    # Muniba Mazari name+headline
        @(143, 283, 420, 180),   # personal couple photo
        @(148, 462, 40, 20),     # reaction avatar
        @(596, 126, 348, 46),    # Ben Rycroft name+headline
        @(170, 570, 205, 24),    # "Sanyam Jain commented"
        @(175, 600, 348, 46),    # Ponnurangam name+headline
        @(596, 576, 388, 46)     # Alexander Gomes name+headline
    )
    "3-focus-reader-insights.png" = @(
        @(296, 116, 130, 22),    # "Santanu Singha likes this"
        @(298, 143, 348, 54),    # Rushika Rai name+headline+services
        @(303, 564, 34, 20),     # reaction avatar
        @(316, 611, 195, 28),    # "Arin Verma commented"
        @(298, 643, 348, 48),    # Yash Sharma name+headline
        @(300, 768, 270, 32)     # bottom preview face
    )
    # 4-daily-limit.png: background already faded by break overlay -> no blur
}

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

    # 1) pixelate with NearestNeighbor (destroys text detail reliably)
    $bw = [Math]::Max(2, [int]($w / $scale))
    $bh = [Math]::Max(2, [int]($h / $scale))
    $small = New-Object System.Drawing.Bitmap($bw, $bh)
    $sg = [System.Drawing.Graphics]::FromImage($small)
    $sg.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::NearestNeighbor
    $sg.PixelOffsetMode = [System.Drawing.Drawing2D.PixelOffsetMode]::Half
    $sg.DrawImage($region, 0, 0, $bw, $bh)
    $sg.Dispose()

    # upscale back with NearestNeighbor -> solid mosaic blocks (guaranteed unreadable)
    $rg2 = [System.Drawing.Graphics]::FromImage($region)
    $rg2.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::NearestNeighbor
    $rg2.PixelOffsetMode = [System.Drawing.Drawing2D.PixelOffsetMode]::Half
    $rg2.DrawImage($small, (New-Object System.Drawing.Rectangle(0, 0, $w, $h)), (New-Object System.Drawing.Rectangle(0, 0, $bw, $bh)), [System.Drawing.GraphicsUnit]::Pixel)
    $rg2.Dispose()
    $small.Dispose()

    $g.DrawImage($region, $x, $y, $w, $h)
    $wash = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(40, 255, 255, 255))
    $g.FillRectangle($wash, $x, $y, $w, $h)
    $wash.Dispose()
    $region.Dispose()
}

foreach ($file in $jobs.Keys) {
    $path = Join-Path $dir $file
    $img = [System.Drawing.Bitmap]::new($path)
    $g = [System.Drawing.Graphics]::FromImage($img)
    foreach ($r in $jobs[$file]) { Blur-Region $img $g $r[0] $r[1] $r[2] $r[3] }
    $g.Dispose()

    $tmp = Join-Path $dir ("_b_" + $file)
    $img.Save($tmp, [System.Drawing.Imaging.ImageFormat]::Png)
    $img.Dispose()
    Move-Item -Force $tmp $path
    Write-Host ("blurred {0}" -f $file)
}
