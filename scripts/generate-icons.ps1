Add-Type -AssemblyName System.Drawing
$dir = Join-Path $PSScriptRoot '..\icons'
if (!(Test-Path $dir)) { New-Item -ItemType Directory -Path $dir | Out-Null }

function New-RoundedRect([int]$x, [int]$y, [int]$w, [int]$h, [int]$r) {
  $path = New-Object System.Drawing.Drawing2D.GraphicsPath
  $d = $r * 2
  $path.AddArc($x, $y, $d, $d, 180, 90)
  $path.AddArc(($x + $w - $d), $y, $d, $d, 270, 90)
  $path.AddArc(($x + $w - $d), ($y + $h - $d), $d, $d, 0, 90)
  $path.AddArc($x, ($y + $h - $d), $d, $d, 90, 90)
  $path.CloseFigure()
  return $path
}

foreach ($size in @(192, 512)) {
  $bmp = New-Object System.Drawing.Bitmap $size, $size
  $g = [System.Drawing.Graphics]::FromImage($bmp)
  $g.SmoothingMode = 'AntiAlias'
  $g.PixelOffsetMode = 'HighQuality'
  $g.TextRenderingHint = 'AntiAliasGridFit'

  $blush = [System.Drawing.Color]::FromArgb(255, 242, 196, 192)
  $mint = [System.Drawing.Color]::FromArgb(255, 158, 207, 200)
  $grad = New-Object System.Drawing.Drawing2D.LinearGradientBrush (
    (New-Object System.Drawing.Point 0, 0),
    (New-Object System.Drawing.Point $size, $size),
    $blush, $mint
  )
  $g.FillRectangle($grad, 0, 0, $size, $size)

  $pad = [int]($size * 0.20)
  $bw = $size - $pad * 2
  $bh = [int]($size * 0.54)
  $by = [int]($size * 0.21)
  $radius = [int]($size * 0.045)

  $cream = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(255, 253, 240, 238))
  $page = New-RoundedRect $pad $by $bw $bh $radius
  $g.FillPath($cream, $page)
  $rosePen = New-Object System.Drawing.Pen ([System.Drawing.Color]::FromArgb(255, 192, 112, 104)), ([float]($size * 0.016))
  $g.DrawPath($rosePen, $page)

  $spineW = [int]($size * 0.075)
  $spine = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(255, 232, 168, 160))
  $spinePath = New-RoundedRect $pad $by $spineW $bh ([int]($radius * 0.7))
  $g.FillPath($spine, $spinePath)

  $lx = $pad + [int]($size * 0.14)
  $line1 = New-Object System.Drawing.Pen ([System.Drawing.Color]::FromArgb(255, 142, 205, 200)), ([float]($size * 0.018))
  $line1.StartCap = [System.Drawing.Drawing2D.LineCap]::Round
  $line1.EndCap = [System.Drawing.Drawing2D.LineCap]::Round
  $g.DrawLine($line1, $lx, ($by + [int]($bh * 0.28)), ($pad + $bw - [int]($size * 0.12)), ($by + [int]($bh * 0.28)))

  $line2 = New-Object System.Drawing.Pen ([System.Drawing.Color]::FromArgb(255, 168, 196, 192)), ([float]($size * 0.014))
  $line2.StartCap = [System.Drawing.Drawing2D.LineCap]::Round
  $line2.EndCap = [System.Drawing.Drawing2D.LineCap]::Round
  $g.DrawLine($line2, $lx, ($by + [int]($bh * 0.46)), ($pad + $bw - [int]($size * 0.18)), ($by + [int]($bh * 0.46)))
  $g.DrawLine($line2, $lx, ($by + [int]($bh * 0.62)), ($pad + $bw - [int]($size * 0.24)), ($by + [int]($bh * 0.62)))

  $coinR = [int]($size * 0.095)
  $cx = $pad + $bw - $coinR - [int]($size * 0.04)
  $cy = $by + $bh - $coinR - [int]($size * 0.04)
  $coin = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(255, 200, 232, 228))
  $g.FillEllipse($coin, ($cx - $coinR), ($cy - $coinR), ($coinR * 2), ($coinR * 2))
  $g.DrawEllipse($rosePen, ($cx - $coinR), ($cy - $coinR), ($coinR * 2), ($coinR * 2))

  $font = New-Object System.Drawing.Font ('Georgia', [single]($size * 0.085), [System.Drawing.FontStyle]::Bold, [System.Drawing.GraphicsUnit]::Pixel)
  $dollar = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(255, 192, 112, 104))
  $sf = New-Object System.Drawing.StringFormat
  $sf.Alignment = 'Center'
  $sf.LineAlignment = 'Center'
  $rect = New-Object System.Drawing.RectangleF ($cx - $coinR), ($cy - $coinR + ($size * 0.004)), ($coinR * 2), ($coinR * 2)
  $g.DrawString('$', $font, $dollar, $rect, $sf)

  $path = Join-Path $dir ("icon-$size.png")
  $bmp.Save($path, [System.Drawing.Imaging.ImageFormat]::Png)
  $g.Dispose()
  $bmp.Dispose()
  Write-Output "Created $path"
}
