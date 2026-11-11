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
- **Monoline** («Monoline», third tool in the palette) gives a uniform thin line — the best tool for technical drawings and small text.
- «Grid» (bottom right) toggles a dot grid; it makes a board look like engineering paper.
- The first time the drawing tools open, an *Improve Handwriting Readability* sheet appears → «Not now» (auto-refine would reshape drawn text).
- **Math Notes**: handwriting that ends in «=» (e.g. after an undo leaves `147 + 12 =`) pops a modal «Solve» menu that swallows
  the following taps. Dismiss it with a tap on an empty part of the top bar (e.g. `tap 350 54 --why "dismiss Solve"`), then continue.
- A tap on the canvas while a pen is selected draws a dot — never tap the canvas to dismiss something.
