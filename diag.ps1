Add-Type -AssemblyName System.Drawing
$p = 'e:\linkedinBeautUI\store-screenshots\3-focus-reader-insights.png'
$img = [System.Drawing.Bitmap]::new($p)
$g = [System.Drawing.Graphics]::FromImage($img)
$brush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(180,255,0,0))
$g.FillRectangle($brush, 318, 612, 185, 26)
$brush.Dispose(); $g.Dispose()
$tmp = 'e:\linkedinBeautUI\store-screenshots\_diag.png'
$img.Save($tmp, [System.Drawing.Imaging.ImageFormat]::Png); $img.Dispose()
Move-Item -Force $tmp $p
Write-Host ('written; lastwrite=' + (Get-Item $p).LastWriteTime)
