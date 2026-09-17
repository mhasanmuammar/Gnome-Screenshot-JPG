#!/usr/bin/env python3
import os
import glob
from PIL import Image

TARGET_DIR = os.path.expanduser("~/Pictures/Screenshots")
SIZE_THRESHOLD = 1000 * 1024  # 1000 KB in bytes

# Process any new PNG screenshots
for png_path in glob.glob(os.path.join(TARGET_DIR, "*.png")):
    if not os.path.exists(png_path):
        continue

    print(f"Processing new screenshot: {os.path.basename(png_path)}")
    jpg_path = os.path.splitext(png_path)[0] + ".jpg"

    try:
        # Open the original PNG
        with Image.open(png_path) as img:
            # Handle transparency layers cleanly (GNOME screenshots use alpha layers)
            if img.mode in ('RGBA', 'LA') or (img.mode == 'P' and 'transparency' in img.info):
                background = Image.new('RGB', img.size, '#ffffff')
                img_rgba = img.convert('RGBA')
                background.paste(img_rgba, mask=img_rgba.split()[-1])
                img_rgb = background
            else:
                img_rgb = img.convert('RGB')

            # Baseline export at high quality
            img_rgb.save(jpg_path, "JPEG", quality=85, optimize=True)

            # Iterative shrinkage loop if it exceeds 1000KB (e.g. 4K / High-DPI screens)
            scale = 0.90
            quality = 80
            while os.path.exists(jpg_path) and os.path.getsize(jpg_path) > SIZE_THRESHOLD and scale >= 0.40:
                new_size = (int(img_rgb.width * scale), int(img_rgb.height * scale))
                resized_img = img_rgb.resize(new_size, Image.Resampling.LANCZOS)
                resized_img.save(jpg_path, "JPEG", quality=quality, optimize=True)
                
                scale -= 0.10   # Reduce size by 10% more if it's still too large
                quality -= 5    # Reduce compression quality slightly

        # Only delete the original bloated PNG if the compressed JPG was generated successfully
        if os.path.exists(jpg_path):
            os.remove(png_path)
            print(f"Successfully optimized: {os.path.basename(jpg_path)} ({os.path.getsize(jpg_path) // 1024} KB)")

    except Exception as e:
        print(f"Error handling {png_path}: {e}")
