Add-Type -AssemblyName System.Drawing

$dir = "e:\linkedinBeautUI\store-screenshots"
$raw = Join-Path $dir "raw\Zen mode with AI and TLDR screenshot.png"
$out = Join-Path $dir "3-focus-reader-insights.png"
$TW = 1280; $TH = 800; $BH = 96

# --- 1. resize (cover, keep right edge) ---
$src = [System.Drawing.Bitmap]::new($raw)
$scaleF = [Math]::Max($TW / $src.Width, $TH / $src.Height)
$sw = [int][Math]::Ceiling($src.Width * $scaleF)
$sh = [int][Math]::Ceiling($src.Height * $scaleF)
$ox = $TW - $sw
$oy = [int](($TH - $sh) / 2)
$img = New-Object System.Drawing.Bitmap($TW, $TH, [System.Drawing.Imaging.PixelFormat]::Format24bppRgb)
$g = [System.Drawing.Graphics]::FromImage($img)
$g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
$g.PixelOffsetMode = [System.Drawing.Drawing2D.PixelOffsetMode]::HighQuality
$g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::HighQuality
$g.Clear([System.Drawing.Color]::White)
$g.DrawImage($src, $ox, $oy, $sw, $sh)
$src.Dispose()

# --- 2. blur personal regions (final 1280x800 coords) ---
$regions = @(
    @(298, 117, 128, 20),    # "Santanu Singha likes this"
    @(300, 143, 344, 48),    # Rushika Rai name+headline
    @(303, 564, 34, 20),     # reaction avatar
    @(318, 612, 190, 26),    # "Arin Verma commented"
    @(300, 645, 344, 44),    # Yash Sharma name+headline
    @(300, 768, 270, 32)     # bottom preview face
)
function Blur([int]$x, [int]$y, [int]$w, [int]$h, [int]$scale, [int]$washA) {
    if ($x -lt 0) { $x = 0 }; if ($y -lt 0) { $y = 0 }
    if (($x + $w) -gt $TW) { $w = $TW - $x }
    if (($y + $h) -gt $TH) { $h = $TH - $y }
    if ($w -le 0 -or $h -le 0) { return }
    $r = New-Object System.Drawing.Bitmap($w, $h)
    $rg = [System.Drawing.Graphics]::FromImage($r)
    $rg.DrawImage($img, (New-Object System.Drawing.Rectangle(0, 0, $w, $h)), (New-Object System.Drawing.Rectangle($x, $y, $w, $h)), [System.Drawing.GraphicsUnit]::Pixel)
    $rg.Dispose()
    for ($i = 0; $i -lt 4; $i++) {
        $dw = [Math]::Max(1, [int]($w / $scale)); $dh = [Math]::Max(1, [int]($h / $scale))
        $s = New-Object System.Drawing.Bitmap($dw, $dh); $sg = [System.Drawing.Graphics]::FromImage($s)
        $sg.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBilinear
        $sg.DrawImage($r, 0, 0, $dw, $dh); $sg.Dispose()
        $rg2 = [System.Drawing.Graphics]::FromImage($r); $rg2.DrawImage($s, 0, 0, $w, $h); $rg2.Dispose(); $s.Dispose()
    }
    $g.DrawImage($r, $x, $y, $w, $h)
    $wash = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb($washA, 255, 255, 255))
    $g.FillRectangle($wash, $x, $y, $w, $h); $wash.Dispose(); $r.Dispose()
}
foreach ($rr in $regions) { Blur $rr[0] $rr[1] $rr[2] $rr[3] 35 70 }

# --- 3. caption banner ---
$g.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::ClearTypeGridFit
$rect = New-Object System.Drawing.Rectangle(0, ($TH - $BH), $TW, $BH)
$lg = New-Object System.Drawing.Drawing2D.LinearGradientBrush($rect, ([System.Drawing.Color]::FromArgb(235, 8, 74, 143)), ([System.Drawing.Color]::FromArgb(235, 12, 120, 220)), 0.0)
$g.FillRectangle($lg, $rect); $lg.Dispose()
$accent = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 120, 200, 255))
$g.FillRectangle($accent, 0, ($TH - $BH), $TW, 3); $accent.Dispose()
$tf = New-Object System.Drawing.Font("Segoe UI Semibold", 24, [System.Drawing.FontStyle]::Bold, [System.Drawing.GraphicsUnit]::Pixel)
$sf = New-Object System.Drawing.Font("Segoe UI", 17, [System.Drawing.FontStyle]::Regular, [System.Drawing.GraphicsUnit]::Pixel)
$white = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::White)
$soft = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(230, 224, 240, 255))
$g.DrawString("Focus Reader + on-device insights", $tf, $white, 40, ($TH - $BH + 20))
$g.DrawString("AI & spam flags, TL;DR summaries, zero distractions.", $sf, $soft, 40, ($TH - $BH + 56))
$tf.Dispose(); $sf.Dispose(); $white.Dispose(); $soft.Dispose(); $g.Dispose()

$tmp = Join-Path $dir "_rebuild3.png"
$img.Save($tmp, [System.Drawing.Imaging.ImageFormat]::Png); $img.Dispose()
Move-Item -Force $tmp $out
Write-Host "rebuilt 3-focus-reader-insights.png"
