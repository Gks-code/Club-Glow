import sys, json
from pathlib import Path
from PIL import Image

def get_palette(image_path, colors=5):
    img = Image.open(image_path).convert('RGBA')
    # Resize to speed up
    img.thumbnail((200, 200))
    # Get palette
    palette = img.convert('P', palette=Image.ADAPTIVE, colors=colors)
    palette_colors = palette.getpalette()[:colors * 3]
    # Map palette indexes to actual colors
    color_counts = sorted(palette.getcolors(), reverse=True)[:colors]
    result = []
    for count, idx in color_counts:
        r = palette_colors[idx * 3]
        g = palette_colors[idx * 3 + 1]
        b = palette_colors[idx * 3 + 2]
        hex_color = f"#{r:02x}{g:02x}{b:02x}"
        result.append({"hex": hex_color, "count": count})
    return result

if __name__ == '__main__':
    if len(sys.argv) < 2:
        print(json.dumps({"error": "path missing"}))
        sys.exit(1)
    path = Path(sys.argv[1])
    palette = get_palette(path)
    print(json.dumps({"palette": palette}, ensure_ascii=False))
