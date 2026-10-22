# Notes (com.apple.mobilenotes)

| Landmark | Label (type) | Where |
|---|---|---|
| New note | «New note» (Button) | top bar, ~ (702,54) |
| Search | «Search» (SearchField) | top of the note list |
| Folders | «Notes», «Quick Notes» (Cell) | left sidebar |
| Checklist / table / attach | «Checklist», «Table», «Attachment» (Button) | note toolbar |

## Fast paths
- **Write a note** (2 steps): `ipad run "open notes; wait 1; see --no-shot --find 'New note'"` → `ipad run "tap N; wait 0.8; type 'Title\nBody line 1\nline 2'"`.
  The first line becomes the title. Use `\n` inside the text — never `--enter` here.
- **Even faster** with the bundled Shortcut: `ipad shortcut "iPad Use Note" --input "…"` (see references/shortcuts.md).
- **Find a note**: tap the search field, `type 'keyword'`, then `see`.

## Gotchas
- After typing, the keyboard stays up; `see` still lists hidden elements behind it.
- Locked notes need the user's password — never type it.
