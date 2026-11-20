Add-Type -AssemblyName System.Drawing

$srcPath = "C:/Users/gross/.gemini/antigravity/brain/ec2dd0d0-be52-437c-8b9b-a2a543fea1b7/.user_uploaded/media_1795136046783_c41e8559.jpg"
$dstPath = "C:/Users/gross/OneDrive/Documentos/GlowClub/imgs/logo-clubglow.png"

$bmp = [System.Drawing.Bitmap]::FromFile($srcPath)

# Create a new bitmap with same dimensions but with alpha channel (32bppArgb)
$out = New-Object System.Drawing.Bitmap($bmp.Width, $bmp.Height, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)

# Threshold: pixels darker than this RGB sum are considered "black background"
$threshold = 45

for ($x = 0; $x -lt $bmp.Width; $x++) {
    for ($y = 0; $y -lt $bmp.Height; $y++) {
        $c = $bmp.GetPixel($x, $y)
        $brightness = $c.R + $c.G + $c.B
        if ($brightness -lt $threshold) {
            # Make black pixels fully transparent
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
