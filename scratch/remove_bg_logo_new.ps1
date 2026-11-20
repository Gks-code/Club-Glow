Add-Type -AssemblyName System.Drawing
$srcPath = "C:/Users/gross/OneDrive/Documentos/GlowClub/LOGO NEW.png"
$dstPath = "C:/Users/gross/OneDrive/Documentos/GlowClub/imgs/logo-new.png"

$bmp = [System.Drawing.Bitmap]::FromFile($srcPath)
$out = New-Object System.Drawing.Bitmap($bmp.Width, $bmp.Height, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)

$threshold = 40

for ($x = 0; $x -lt $bmp.Width; $x++) {
    for ($y = 0; $y -lt $bmp.Height; $y++) {
        $c = $bmp.GetPixel($x, $y)
        $brightness = $c.R + $c.G + $c.B
        if ($brightness -lt $threshold) {
            $out.SetPixel($x, $y, [System.Drawing.Color]::FromArgb(0, 0, 0, 0))
        } else {
            $out.SetPixel($x, $y, $c)
        }
    }
}

$out.Save($dstPath, [System.Drawing.Imaging.ImageFormat]::Png)
$out.Dispose()
$bmp.Dispose()
Write-Host "Done: $dstPath"
