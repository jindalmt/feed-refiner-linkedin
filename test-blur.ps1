Add-Type -AssemblyName System.Drawing
$dir = "e:\linkedinBeautUI\store-screenshots"
$img = [System.Drawing.Bitmap]::new((Join-Path $dir "3-focus-reader-insights.png"))
# Rushika name row
$x=298;$y=143;$w=348;$h=54
$region = New-Object System.Drawing.Bitmap($w,$h)
$rg=[System.Drawing.Graphics]::FromImage($region)
$rg.DrawImage($img,(New-Object System.Drawing.Rectangle(0,0,$w,$h)),(New-Object System.Drawing.Rectangle($x,$y,$w,$h)),[System.Drawing.GraphicsUnit]::Pixel)
$rg.Dispose()
# strong pixelate: down to 12px wide, nearest neighbor both ways
$dw=12;$dh=[int]($h*$dw/$w)
$small=New-Object System.Drawing.Bitmap($dw,$dh)
$sg=[System.Drawing.Graphics]::FromImage($small)
$sg.InterpolationMode=[System.Drawing.Drawing2D.InterpolationMode]::NearestNeighbor
$sg.PixelOffsetMode=[System.Drawing.Drawing2D.PixelOffsetMode]::Half
$sg.DrawImage($region,0,0,$dw,$dh);$sg.Dispose()
$g=[System.Drawing.Graphics]::FromImage($img)
$g.InterpolationMode=[System.Drawing.Drawing2D.InterpolationMode]::NearestNeighbor
$g.PixelOffsetMode=[System.Drawing.Drawing2D.PixelOffsetMode]::Half
$g.DrawImage($small,$x,$y,$w,$h)
$g.Dispose()
$img.Save((Join-Path $dir "_test_pixelate.png"),[System.Drawing.Imaging.ImageFormat]::Png)
$img.Dispose()
Write-Host "test written"
