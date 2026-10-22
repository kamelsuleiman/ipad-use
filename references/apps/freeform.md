# Freeform (com.apple.freeform) — boards, drawing

| Landmark | Label (type) | Where |
|---|---|---|
| New board | «New Board» (Button) | top right |
| Drawing tools | «Drawing and Handwriting Tools» (Button) | top bar centre → opens the palette |
| Tools | «Pen», «Marker», «Eraser», «Lasso», «Ruler» (Button) | bottom palette |
| Colours | «Black», «Blue», «Green», «Yellow», «Red», «Color picker» | bottom palette |
| Insert | «Add text box», «Add shape», «Add sticky note», «Add table», «Media» | top bar centre |
| Undo | «Undo» (Button) | top right |

## Fast paths
- **Draw**: `ipad run "open freeform; wait 2; see --no-shot --find 'New Board'"` → tap → close tips (`see` → «Close») →
  tap «Drawing and Handwriting Tools» → `ipad draw … --tool Pen --color Black` (references/drawing.md).
- **Sticky note with text**: «Add sticky note» → `type '…'`.

## Gotchas
- First launch shows *Welcome* and *What's New* sheets → «Continue» twice.
- A «Browse the Content Hub» tip may cover the top right on a new board → its «Close».
- The palette covers y ≈ 880–1000 — keep drawings above it (the default `draw` box does).
