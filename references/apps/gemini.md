# Gemini (com.google.gemini) — chat, images, video

Verified on iPadOS 26.5 / Gemini app, Oct 2026. Labels are what `ipad see` prints.

| Landmark | Label (type) | Where (landscape 13") |
|---|---|---|
| New chat | «New chat» (Button) | sidebar, top-left |
| Image mode | «Images» (Button) | sidebar |
| Video mode | «Videos» (Button) | sidebar |
| Prompt box | «#kROBInputTextViewAXID» (TextView) | bottom centre |
| Send | «Send query» (Button) | right of the prompt box |
| Mic | «Microphone» (Button) | next to Send |
| Model picker | e.g. «Argon High» (Button) | top bar |

## Fast path — generate an image
```bash
ipad run "open gemini; wait 1.5; see --no-shot --find chat"     # tap «New chat» from the list
ipad run "tap <New chat #>; wait 1; see --no-shot --find InputText"
ipad run "tap <prompt #>; type 'A cat astronaut sitting on the moon, cinematic, 35mm'"
ipad see --find Send                                            # «Send query» → NEEDS_APPROVAL (it contains "send")
#   ask the user once → ipad tap <Send #> --confirm
ipad run "wait 8; see"                                          # images take ~10–25 s; repeat wait+see until they appear
```
- Image results appear as image cells in the chat; long-press one (`ipad longpress N`) for Save / Share.
- Starting from «Images» in the sidebar puts the chat in image mode (prompt doesn't need "generate an image of …").

## Gotchas
- The sidebar lists Pinned/Recent chats and Notebooks — don't tap them by accident when looking for «New chat».
- «Send query» contains the word *send*, so the safety gate asks for approval. That's expected (see references/safety.md).
- If the prompt box is hidden under the keyboard of another field, tap an empty chat area first.
