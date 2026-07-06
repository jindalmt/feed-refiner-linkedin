Add-Type -AssemblyName System.Drawing

$dir = "e:\linkedinBeautUI\store-screenshots"
$raw = Join-Path $dir "raw\Zen mode with post limit reached.png"
$out = Join-Path $dir "4-daily-limit.png"
$TW = 1280; $TH = 800
$BH = 96   # caption banner height (matches other screenshots)

$img = [System.Drawing.Bitmap]::new($raw)

# CONTAIN fit into the area ABOVE the banner, so nothing is clipped
$availH = $TH - $BH
$scaleF = [Math]::Min($TW / $img.Width, $availH / $img.Height)
$sw = [int][Math]::Round($img.Width * $scaleF)
$sh = [int][Math]::Round($img.Height * $scaleF)
$ox = [int](($TW - $sw) / 2)
$oy = [int](($availH - $sh) / 2)

$bmp = New-Object System.Drawing.Bitmap($TW, $TH, [System.Drawing.Imaging.PixelFormat]::Format24bppRgb)
$g = [System.Drawing.Graphics]::FromImage($bmp)
$g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
$g.PixelOffsetMode = [System.Drawing.Drawing2D.PixelOffsetMode]::HighQuality
$g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::HighQuality
$g.Clear([System.Drawing.Color]::White)
$g.DrawImage($img, $ox, $oy, $sw, $sh)
$img.Dispose()

# ---- caption banner (same style as add-captions.ps1) ----
$g.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::ClearTypeGridFit
$rect = New-Object System.Drawing.Rectangle(0, ($TH - $BH), $TW, $BH)
$c1 = [System.Drawing.Color]::FromArgb(235, 8, 74, 143)
$c2 = [System.Drawing.Color]::FromArgb(235, 12, 120, 220)
$lg = New-Object System.Drawing.Drawing2D.LinearGradientBrush($rect, $c1, $c2, 0.0)
$g.FillRectangle($lg, $rect); $lg.Dispose()
$accent = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 120, 200, 255))
$g.FillRectangle($accent, 0, ($TH - $BH), $TW, 3); $accent.Dispose()

$titleFont = New-Object System.Drawing.Font("Segoe UI Semibold", 24, [System.Drawing.FontStyle]::Bold, [System.Drawing.GraphicsUnit]::Pixel)
$subFont = New-Object System.Drawing.Font("Segoe UI", 17, [System.Drawing.FontStyle]::Regular, [System.Drawing.GraphicsUnit]::Pixel)
$white = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::White)
$soft = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(230, 224, 240, 255))
$g.DrawString("Set a daily post limit", $titleFont, $white, 40, ($TH - $BH + 20))
$g.DrawString("A gentle nudge to close the tab and log off.", $subFont, $soft, 40, ($TH - $BH + 56))
$titleFont.Dispose(); $subFont.Dispose(); $white.Dispose(); $soft.Dispose(); $g.Dispose()

$tmp = Join-Path $dir "_t4.png"
$bmp.Save($tmp, [System.Drawing.Imaging.ImageFormat]::Png); $bmp.Dispose()
Move-Item -Force $tmp $out
Write-Host "rebuilt 4-daily-limit.png (contain fit)"
