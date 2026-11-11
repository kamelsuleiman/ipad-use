# Drawing — `ipad draw`

Real finger strokes (W3C touch actions through WebDriverAgent) on any canvas that accepts finger drawing:
**Freeform**, **Notes** (markup), Procreate (enable finger painting), whiteboard apps.

```bash
ipad draw logo.svg --tool Monoline --color Black       # any SVG: path, polyline, polygon, line, rect, circle, ellipse
ipad draw --shape star|circle|heart|spiral|wave
ipad draw --text "T/W 4.0:1 = 31 MIN" --color Blue     # built-in single-stroke font: A–Z, 0–9, - . ! ? = / : +
ipad draw logo.svg --box 430,120,520,560               # where to draw (x,y,w,h in points); default = safe canvas area
ipad draw layer-blue.svg --exact --color Blue          # SVG coordinates are already screen points (see "Layers")
ipad draw logo.svg --dry-run                           # strokes, points, time estimate + preview SVG — nothing drawn
```

## How it works
1. SVG → polylines (transforms applied, Bézier curves flattened; elliptical arcs are approximated by chords).
2. Fit into the box, keep aspect ratio (`--exact` skips the fit).
3. Ramer–Douglas–Peucker simplification (`--detail`, points; default 1.5 — higher = fewer points, faster).
4. Closed shapes overlap their first segment so they really close; strokes are split at **≤ 26 points**.
5. Each stroke is sent with **dwell pauses** — this is what makes the ink crisp:

| Where | Pause | Without it |
|---|---|---|
| after touch-down | 100 ms | the first segment of the stroke is lost (a «5» loses its top bar) |
| at every corner sharper than 30° | 110 ms | corners are rounded; a rectangle becomes a blob |
| before lift-off | 200 ms | the last segment is cut — a long 2-point line stops at ~42%, a small circle stays a «C» |

   Move duration is 60–400 ms, scaled to the longest segment of the stroke.
6. `--tool` / `--color` tap the palette buttons by their labels (Freeform/Notes: «Monoline», «Pen», «Black», «Blue», «Red»…).
7. A stalled WDA request is retried up to three times instead of aborting a long drawing.

## Measured (iPad Pro 13" M5, iPadOS 26.5, Freeform, Monoline)
| Drawing | Strokes · points | Time |
|---|---|---|
| Long straight line (2 points) | 1 · 2 | 2 s |
| Text, 18 characters at 14 pt height | 19 · ~110 | 95 s |
| Survey-drone engineering sheet (see README) | 702 · ~3,000 | ~48 min |

- Cost model: **~0.58 s per pointer move** inside WDA, whatever the distance, **~0.6 s per stroke**, plus the pauses themselves
  → plan on **~0.9 s per point** for text-heavy drawings. A long line costs the same as a short one, so do not subdivide lines.
- Text is the expensive part (5–10 points per character). Keep labels short; ≥ 14 pt glyph height stays legible.
- A single stroke with ~70+ points can be dropped by Freeform — hence the 26-point chunks.

## Layers (multi-colour drawings)
One `draw` call uses one tool and one colour. For a sheet with black geometry, red centre lines and blue dimensions, generate
one SVG per layer **in screen points** (iPad Pro 13" landscape: 1376 × 1032; stay inside x 60–1320, y 105–868 in Freeform)
and draw them one after another with `--exact`, so every layer lands exactly where the others expect it:

```bash
ipad draw 1-geometry.svg --exact --tool Monoline --color Black
ipad draw 2-centre-lines.svg --exact --color Red
ipad draw 3-dimensions.svg --exact --color Blue
```

## Tips
- Open the canvas and the drawing palette first: Freeform → «Drawing and Handwriting Tools» (top bar) → palette → «Monoline».
- Use `--dry-run` and look at the preview SVG before a long drawing. Outline-traced logos (filled shapes) draw as outlines.
- Long drawings: put the iPad on its charger (a 48-minute drawing used about 40% battery), keep Auto-Lock on Never,
  and run the command inside `screen`/`tmux` so a closed terminal does not stop it.
- Recording: WDA's MJPEG stream (`http://<ipad-ip>:9100`) can be captured with ffmpeg, but it can stall silently when a request
  hangs — check that the output file is still growing. The iPad's own screen recording is the safer source.
- See `references/apps/freeform.md` for the Math Notes «Solve» popup and other Freeform gotchas.
