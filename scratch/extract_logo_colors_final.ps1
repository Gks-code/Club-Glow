Add-Type -AssemblyName System.Drawing
$logoPath = "C:/Users/gross/.gemini/antigravity/brain/ec2dd0d0-be52-437c-8b9b-a2a543fea1b7/.user_uploaded/media_1795136046783_c41e8559.jpg"
if (-not (Test-Path $logoPath)) { Write-Error "File not found: $logoPath"; exit 1 }
$img = [System.Drawing.Bitmap]::FromFile($logoPath)
$w = $img.Width
$h = $img.Height
# Sample step to limit to ~100x100 pixels for performance
$maxSamples = 100
$stepX = [Math]::Max(1, [Math]::Floor($w / $maxSamples))
$stepY = [Math]::Max(1, [Math]::Floor($h / $maxSamples))
$colorCounts = @{}
for ($x = 0; $x -lt $w; $x += $stepX) {
    for ($y = 0; $y -lt $h; $y += $stepY) {
        $c = $img.GetPixel($x, $y)
        $hex = ("#{0:x2}{1:x2}{2:x2}" -f $c.R, $c.G, $c.B)
        if ($colorCounts.ContainsKey($hex)) { $colorCounts[$hex]++ } else { $colorCounts[$hex] = 1 }
    }
}
$top = $colorCounts.GetEnumerator() | Sort-Object Value -Descending | Select-Object -First 5
$top | ConvertTo-Json -Depth 3