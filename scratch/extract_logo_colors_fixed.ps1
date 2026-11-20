Add-Type -AssemblyName System.Drawing
$path = "C:/Users/gross/.gemini/antigravity/brain/ec2dd0d0-be52-437c-8b9d-a2a543fea1b7/.user_uploaded/media_1795136046783_c41e8559.jpg"
if (-not (Test-Path $path)) { Write-Error "File not found: $path"; exit 1 }
$img = [System.Drawing.Image]::FromFile($path)
# Create thumbnail (64x64) with dummy callback
$thumb = $img.GetThumbnailImage(64,64,{ $true }, $null)
$bmp = New-Object System.Drawing.Bitmap $thumb
$hash = @{}
for ($x = 0; $x -lt $bmp.Width; $x++) {
    for ($y = 0; $y -lt $bmp.Height; $y++) {
        $c = $bmp.GetPixel($x,$y)
        $hex = ("#{0:x2}{1:x2}{2:x2}" -f $c.R,$c.G,$c.B)
        if ($hash.ContainsKey($hex)) { $hash[$hex]++ } else { $hash[$hex]=1 }
    }
}
$top = $hash.GetEnumerator() | Sort-Object Value -Descending | Select-Object -First 5
$top | ConvertTo-Json -Depth 3