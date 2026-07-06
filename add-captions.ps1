Add-Type -AssemblyName System.Drawing

$dir = "e:\linkedinBeautUI\store-screenshots"

# caption per file: main headline + smaller sub
$caps = [ordered]@{
    "1-original-cluttered.png"    = @{ title = "Your LinkedIn feed today"; sub = "Ads, promos, puzzles, endless clutter." }
    "2-compact-grid.png"          = @{ title = "Compact Grid"; sub = "Dense reading, sidebars gone, TL;DR on long posts." }
    "3-focus-reader-insights.png" = @{ title = "Focus Reader + on-device insights"; sub = "AI & spam flags, TL;DR summaries, zero distractions." }
    "4-daily-limit.png"           = @{ title = "Set a daily post limit"; sub = "A gentle nudge to close the tab and log off." }
}

$brand = [System.Drawing.Color]::FromArgb(255, 10, 102, 194)   # LinkedIn blue
$BH = 96   # banner height

foreach ($file in $caps.Keys) {
    $path = Join-Path $dir $file
    $img = [System.Drawing.Bitmap]::new($path)
    $g = [System.Drawing.Graphics]::FromImage($img)
    $g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
    $g.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::ClearTypeGridFit

    # gradient banner at bottom
    $rect = New-Object System.Drawing.Rectangle(0, ($img.Height - $BH), $img.Width, $BH)
    $c1 = [System.Drawing.Color]::FromArgb(235, 8, 74, 143)
    $c2 = [System.Drawing.Color]::FromArgb(235, 12, 120, 220)
    $lg = New-Object System.Drawing.Drawing2D.LinearGradientBrush($rect, $c1, $c2, 0.0)
    $g.FillRectangle($lg, $rect); $lg.Dispose()

    # accent line on top of banner
    $accent = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 120, 200, 255))
    $g.FillRectangle($accent, 0, ($img.Height - $BH), $img.Width, 3); $accent.Dispose()

    $titleFont = New-Object System.Drawing.Font("Segoe UI Semibold", 24, [System.Drawing.FontStyle]::Bold, [System.Drawing.GraphicsUnit]::Pixel)
    $subFont = New-Object System.Drawing.Font("Segoe UI", 17, [System.Drawing.FontStyle]::Regular, [System.Drawing.GraphicsUnit]::Pixel)
    $white = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::White)
    $soft = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(230, 224, 240, 255))

    $tx = 40
    $g.DrawString($caps[$file].title, $titleFont, $white, $tx, ($img.Height - $BH + 20))
    $g.DrawString($caps[$file].sub, $subFont, $soft, $tx, ($img.Height - $BH + 56))

    $titleFont.Dispose(); $subFont.Dispose(); $white.Dispose(); $soft.Dispose(); $g.Dispose()

    $tmp = Join-Path $dir ("_c_" + $file)
    $img.Save($tmp, [System.Drawing.Imaging.ImageFormat]::Png); $img.Dispose()
    Move-Item -Force $tmp $path
    Write-Host ("captioned {0}" -f $file)
}
