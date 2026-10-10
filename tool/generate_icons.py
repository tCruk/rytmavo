#!/usr/bin/env python3
"""Generates every launcher icon from assets/icon/app_icon_source.png.

Run from the repo root after replacing the source image:
    python3 tool/generate_icons.py
Needs Pillow (pip install pillow). The artwork is a rounded square on a
black canvas; we crop to the square so Android/iOS apply their own masks.
"""
import json
import os
from PIL import Image, ImageDraw

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
SRC = os.path.join(ROOT, 'assets/icon/app_icon_source.png')
IOS = os.path.join(ROOT, 'ios/Runner/Assets.xcassets/AppIcon.appiconset')
RES = os.path.join(ROOT, 'android/app/src/main/res')

src = Image.open(SRC).convert('RGB')
w, h = src.size

# Bounding box of the rounded square: everything brighter than near-black.
mask = src.convert('L').point(lambda v: 255 if v > 10 else 0)
left, top, right, bottom = mask.getbbox()
side = min(right - left, bottom - top)
cx, cy = (left + right) // 2, (top + bottom) // 2
# Inset a little so the anti-aliased edge of the artwork never shows.
inset = int(side * 0.015)
box = (cx - side // 2 + inset, cy - side // 2 + inset,
       cx + side // 2 - inset, cy + side // 2 - inset)
cropped = src.crop(box)
S = cropped.size[0]

# The artwork's own rounded corners leave black outside them; iOS and
# Android apply their own masks, so fill those corners with a blurred
# extension of the artwork (dark navy) to get a full-bleed square.
inside = cropped.convert('L').point(lambda v: 255 if v > 10 else 0)
extended = cropped.resize((6, 6), Image.BOX).resize((S, S), Image.BILINEAR)
square = Image.composite(cropped, extended, inside)


def rgb(size):
    return square.resize((size, size), Image.LANCZOS)


def rounded(size, radius_ratio=0.2):
    img = rgb(size).convert('RGBA')
    m = Image.new('L', (size, size), 0)
    ImageDraw.Draw(m).rounded_rectangle(
        (0, 0, size - 1, size - 1), radius=int(size * radius_ratio), fill=255)
    img.putalpha(m)
    return img


# --- iOS: every entry of Contents.json, no alpha ---------------------------
with open(os.path.join(IOS, 'Contents.json')) as f:
    contents = json.load(f)
for entry in contents['images']:
    pt = float(entry['size'].split('x')[0])
    scale = int(entry['scale'].rstrip('x'))
    px = int(round(pt * scale))
    rgb(px).save(os.path.join(IOS, entry['filename']), optimize=True)

# --- Android ---------------------------------------------------------------
densities = {'mdpi': 1, 'hdpi': 1.5, 'xhdpi': 2, 'xxhdpi': 3, 'xxxhdpi': 4}
for name, d in densities.items():
    folder = os.path.join(RES, f'mipmap-{name}')
    os.makedirs(folder, exist_ok=True)
    # Legacy icon (API < 26): rounded square with transparency.
    rounded(int(48 * d)).save(os.path.join(folder, 'ic_launcher.png'),
                              optimize=True)
    # Adaptive icon: 108dp canvas; the ring of the artwork (~85 % of its
    # width) must fit the 66dp safe zone, so the artwork is 76dp. The
    # background layer is the blurred extension, so no square edge shows
    # whatever mask the launcher applies.
    canvas = int(108 * d)
    art = int(76 * d)
    fg = Image.new('RGBA', (canvas, canvas), (0, 0, 0, 0))
    fg.paste(rgb(art), ((canvas - art) // 2, (canvas - art) // 2))
    fg.save(os.path.join(folder, 'ic_launcher_foreground.png'), optimize=True)
    extended.resize((canvas, canvas), Image.BILINEAR).save(
        os.path.join(folder, 'ic_launcher_background.png'), optimize=True)

os.makedirs(os.path.join(RES, 'mipmap-anydpi-v26'), exist_ok=True)
with open(os.path.join(RES, 'mipmap-anydpi-v26/ic_launcher.xml'), 'w') as f:
    f.write('''<?xml version="1.0" encoding="utf-8"?>
<adaptive-icon xmlns:android="http://schemas.android.com/apk/res/android">
    <background android:drawable="@mipmap/ic_launcher_background" />
    <foreground android:drawable="@mipmap/ic_launcher_foreground" />
</adaptive-icon>
''')
print(f'source {w}x{h}, square {S}px from {box}')
