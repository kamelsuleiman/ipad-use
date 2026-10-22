# Drawing — `ipad draw`

Real finger strokes (W3C touch actions through WebDriverAgent) on any canvas that accepts finger drawing:
**Freeform**, **Notes** (markup), Procreate (enable finger painting), whiteboard apps.

```bash
ipad draw logo.svg --tool Pen --color Black            # any SVG: path, polyline, polygon, line, rect, circle, ellipse
ipad draw --shape star|circle|heart|spiral|wave
ipad draw --text "HELLO 2026" --color Blue             # built-in single-stroke font: A–Z, 0–9, - . ! ?
ipad draw logo.svg --box 430,120,520,560               # where to draw (x,y,w,h in points); default = safe canvas area
ipad draw logo.svg --dry-run                           # strokes, points, time estimate + preview SVG — nothing drawn
```

## How it works
1. SVG → polylines (transforms applied, Bézier curves flattened; elliptical arcs are approximated by chords).
2. Fit into the box, keep aspect ratio.
3. Ramer–Douglas–Peucker simplification (`--detail`, points; default 1.5 — higher = fewer points, faster).
4. Split into strokes of **≤ 28 points**, one touch-down → moves → touch-up per stroke.
5. `--tool` / `--color` tap the palette buttons by their labels (Freeform/Notes: «Pen», «Marker», «Black», «Blue»…).

## Measured (iPad Pro 13" M5, iPadOS 26.5, Freeform)
| Drawing | Strokes · points | Time |
|---|---|---|
| Star (shape) | 1 · 11 | 6 s |
| Circle | 1 · 24 | 13 s |
| NAWA logo (SVG, 3 Bézier subpaths) | 7 · 127 | 70 s |
| Text "NAWA" | 6 · 19 | 12 s |

- Every point costs **~0.55 s** regardless of the move duration (XCTest event synthesis) → time ≈ points × 0.55 s.
- A single stroke with ~70+ points can be **dropped** by Freeform (it left a dot). Hence the 28-point chunks.
- Freeform smooths ink nicely; slight corner rounding is expected.

## Tips
- Open the canvas and the drawing palette first: Freeform → «Drawing and Handwriting Tools» (top bar) → palette.
- Use `--dry-run` and look at the preview SVG before a long drawing. Outline-traced logos (filled shapes) draw as outlines.
- For a video: record the iPad (or `ipad live`, coming) and speed it up — "Claude draws on my iPad" in 10 seconds.
