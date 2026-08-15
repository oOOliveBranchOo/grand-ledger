Add-Type -AssemblyName System.Drawing
$dir = Join-Path $PSScriptRoot '..\icons'
if (!(Test-Path $dir)) { New-Item -ItemType Directory -Path $dir | Out-Null }
foreach ($size in @(192, 512)) {
  $bmp = New-Object System.Drawing.Bitmap $size, $size
  $g = [System.Drawing.Graphics]::FromImage($bmp)
  $g.SmoothingMode = 'AntiAlias'
  $g.Clear([System.Drawing.Color]::FromArgb(255, 30, 74, 70))
  $pad = [int]($size * 0.18)
  $bw = $size - $pad * 2
  $bh = [int]($size * 0.55)
  $by = [int]($size * 0.22)
  $page = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(255, 253, 240, 238))
  $g.FillRectangle($page, $pad, $by, $bw, $bh)
  $pen = New-Object System.Drawing.Pen ([System.Drawing.Color]::FromArgb(255, 192, 112, 104)), ([float]($size * 0.018))
  $g.DrawRectangle($pen, $pad, $by, $bw, $bh)
  $spine = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(255, 232, 168, 160))
  $g.FillRectangle($spine, $pad, $by, [int]($size * 0.07), $bh)
  $line = New-Object System.Drawing.Pen ([System.Drawing.Color]::FromArgb(255, 142, 205, 200)), ([float]($size * 0.018))
  $line.StartCap = [System.Drawing.Drawing2D.LineCap]::Round
  $line.EndCap = [System.Drawing.Drawing2D.LineCap]::Round
  $lx = $pad + [int]($size * 0.14)
  $g.DrawLine($line, $lx, ($by + [int]($bh * 0.28)), ($pad + $bw - [int]($size * 0.1)), ($by + [int]($bh * 0.28)))
  $line2 = New-Object System.Drawing.Pen ([System.Drawing.Color]::FromArgb(255, 168, 196, 192)), ([float]($size * 0.014))
  $g.DrawLine($line2, $lx, ($by + [int]($bh * 0.45)), ($pad + $bw - [int]($size * 0.16)), ($by + [int]($bh * 0.45)))
  $g.DrawLine($line2, $lx, ($by + [int]($bh * 0.62)), ($pad + $bw - [int]($size * 0.2)), ($by + [int]($bh * 0.62)))
  $coinR = [int]($size * 0.09)
  $cx = $pad + $bw - $coinR - [int]($size * 0.06)
  $cy = $by + $bh - $coinR - [int]($size * 0.06)
  $coin = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(255, 200, 232, 228))
  $g.FillEllipse($coin, ($cx - $coinR), ($cy - $coinR), ($coinR * 2), ($coinR * 2))
  $g.DrawEllipse($pen, ($cx - $coinR), ($cy - $coinR), ($coinR * 2), ($coinR * 2))
  $font = New-Object System.Drawing.Font ('Georgia', [single]($size * 0.08), [System.Drawing.FontStyle]::Bold, [System.Drawing.GraphicsUnit]::Pixel)
  $brush = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(255, 30, 74, 70))
  $sf = New-Object System.Drawing.StringFormat
  $sf.Alignment = 'Center'
  $sf.LineAlignment = 'Center'
  $rect = New-Object System.Drawing.RectangleF ($cx - $coinR), ($cy - $coinR), ($coinR * 2), ($coinR * 2)
  $g.DrawString('$', $font, $brush, $rect, $sf)
  $path = Join-Path $dir ("icon-$size.png")
  $bmp.Save($path, [System.Drawing.Imaging.ImageFormat]::Png)
  $g.Dispose()
  $bmp.Dispose()
  Write-Output "Created $path"
}
