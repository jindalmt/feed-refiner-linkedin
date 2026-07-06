Add-Type -AssemblyName System.Drawing
$p = 'e:\linkedinBeautUI\store-screenshots\1-original-cluttered.png'
$img = [System.Drawing.Bitmap]::new($p)
$g = [System.Drawing.Graphics]::FromImage($img)
$x = 836; $y = 689; $w = 64; $h = 18
$r = New-Object System.Drawing.Bitmap($w, $h)
$rg = [System.Drawing.Graphics]::FromImage($r)
$rg.DrawImage($img, (New-Object System.Drawing.Rectangle(0, 0, $w, $h)), (New-Object System.Drawing.Rectangle($x, $y, $w, $h)), [System.Drawing.GraphicsUnit]::Pixel)
$rg.Dispose()
for ($i = 0; $i -lt 3; $i++) {
    $sw = [Math]::Max(1, [int]($w / 18)); $sh = [Math]::Max(1, [int]($h / 18))
    $s = New-Object System.Drawing.Bitmap($sw, $sh)
    $sg = [System.Drawing.Graphics]::FromImage($s); $sg.DrawImage($r, 0, 0, $sw, $sh); $sg.Dispose()
    $rg2 = [System.Drawing.Graphics]::FromImage($r); $rg2.DrawImage($s, 0, 0, $w, $h); $rg2.Dispose(); $s.Dispose()
}
$g.DrawImage($r, $x, $y, $w, $h)
$wash = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(60, 255, 255, 255))
$g.FillRectangle($wash, $x, $y, $w, $h); $wash.Dispose(); $r.Dispose(); $g.Dispose()
$tmp = 'e:\linkedinBeautUI\store-screenshots\_t1.png'
$img.Save($tmp, [System.Drawing.Imaging.ImageFormat]::Png); $img.Dispose()
Move-Item -Force $tmp $p
Write-Host 'patched name'
