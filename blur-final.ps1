Add-Type -AssemblyName System.Drawing

$dir = "e:\linkedinBeautUI\store-screenshots"
$scale = 22   # blur strength

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
        @(185, 124, 115, 16),    # "Saquib Ahmad likes this"
        @(178, 152, 340, 42),    # Muniba Mazari name+headline
        @(143, 283, 420, 180),   # personal couple photo
        @(148, 462, 40, 20),     # reaction avatar
        @(598, 128, 340, 42),    # Ben Rycroft name+headline
        @(175, 574, 120, 18),    # "Sanyam Jain commented"
        @(178, 602, 340, 42),    # Ponnurangam name+headline
        @(598, 578, 380, 42)     # Alexander Gomes name+headline
    )
    "3-focus-reader-insights.png" = @(
        @(298, 119, 118, 16),    # "Santanu Singha likes this"
        @(300, 145, 340, 45),    # Rushika Rai name+headline+services
        @(303, 564, 34, 20),     # reaction avatar
        @(345, 613, 120, 18),    # "Arin Verma commented"
        @(300, 645, 340, 40),    # Yash Sharma name+headline
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
    $wash = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(60, 255, 255, 255))
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
