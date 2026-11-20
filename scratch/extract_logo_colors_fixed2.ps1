Add-Type -AssemblyName System.Drawing
$logoPath = "C:/Users/gross/.gemini/antigravity/brain/ec2dd0d0-be52-437c-8b9b-a2a543fea1b7/.user_uploaded/media_1795136046783_c41e8559.jpg"
if (-not (Test-Path $logoPath)) { Write-Error "File not found: $logoPath"; exit 1 }
$img = [System.Drawing.Image]::FromFile($logoPath)
# Create a thumbnail (64x64) with a dummy abort callback
$abort = [System.Drawing.Image+GetThumbnailImageAbort] { $false }
$thumb = $img.GetThumbnailImage(64,64,$abort,$null)
$bmp = New-Object System.Drawing.Bitmap $thumb
$colorCounts = @{}
for ($x = 0; $x -lt $bmp.Width; $x++) {
    for ($y = 0; $y -lt $bmp.Height; $y++) {
        $c = $bmp.GetPixel($x,$y)
        $hex = ("#{0:x2}{1:x2}{2:x2}" -f $c.R,$c.G,$c.B)
        if ($colorCounts.ContainsKey($hex)) { $colorCounts[$hex]++ } else { $colorCounts[$hex] = 1 }
    }
}
$top = $colorCounts.GetEnumerator() | Sort-Object Value -Descending | Select-Object -First 5
$top | ConvertTo-Json -Depth 3