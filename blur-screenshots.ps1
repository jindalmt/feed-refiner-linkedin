Add-Type -AssemblyName System.Drawing

$dir = "e:\linkedinBeautUI\store-screenshots"

# Blur regions per file: each rect = @(x, y, w, h) in 1280x800 space.
$jobs = @{
    "1-original-cluttered.png" = @(
        ,@(354, 254, 412, 46)      # Harish Prajapat header (face+name)
    )
    "2-zen-mode.png" = @(
        ,@(349, 226, 542, 574)     # entire feed post area (composer + nav stay crisp)
    )
    "3-executive-mode.png" = @(
        @(200, 92, 424, 708),      # entire left feed column
        @(626, 92, 382, 708)       # entire right feed column (stops before popup)
    )
    "4-extension-controls.png" = @(
        ,@(349, 210, 660, 590)     # entire feed post area (composer + nav + popup stay crisp)
    )
}

$scale = 26  # higher = stronger blur

foreach ($file in $jobs.Keys) {
    $path = Join-Path $dir $file
    $img = [System.Drawing.Bitmap]::new($path)
    $g = [System.Drawing.Graphics]::FromImage($img)
    $g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBilinear
    $g.PixelOffsetMode = [System.Drawing.Drawing2D.PixelOffsetMode]::HighQuality

    foreach ($r in $jobs[$file]) {
        $x = [int]$r[0]; $y = [int]$r[1]; $w = [int]$r[2]; $h = [int]$r[3]
        if ($x -lt 0) { $x = 0 }
        if ($y -lt 0) { $y = 0 }
        if (($x + $w) -gt $img.Width) { $w = $img.Width - $x }
        if (($y + $h) -gt $img.Height) { $h = $img.Height - $y }

        # copy region
        $region = New-Object System.Drawing.Bitmap($w, $h)
        $rg = [System.Drawing.Graphics]::FromImage($region)
        $srcRect = New-Object System.Drawing.Rectangle($x, $y, $w, $h)
        $rg.DrawImage($img, (New-Object System.Drawing.Rectangle(0, 0, $w, $h)), $srcRect, [System.Drawing.GraphicsUnit]::Pixel)
        $rg.Dispose()

        # iterative downscale/upscale passes to smear text into unreadable blobs
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

        # draw blurred region back
        $g.DrawImage($region, $x, $y, $w, $h)

        # frosted-glass white wash to remove any residual text contrast
        $wash = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(120, 255, 255, 255))
        $g.FillRectangle($wash, $x, $y, $w, $h)
        $wash.Dispose()

        $region.Dispose()
    }

    $g.Dispose()
    # save (need to release file handle: save to temp then move)
    $tmp = Join-Path $dir ("_tmp_" + $file)
    $img.Save($tmp, [System.Drawing.Imaging.ImageFormat]::Png)
    $img.Dispose()
    Move-Item -Force $tmp $path
    Write-Host "blurred $file"
}
