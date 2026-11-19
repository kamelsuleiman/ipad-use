# WhatsApp — storage audit and clean-up (iPhone)

Verified on iPhone 16 Pro Max, iOS 26.5, WhatsApp (bundle `net.whatsapp.WhatsApp`; Business is `net.whatsapp.WhatsAppSMB`).
Scope of this playbook: **storage only**. Do not open chats, read messages or send anything.

## Before you start
- **App lock — have the user unlock WhatsApp on the phone BEFORE you start.** While the `WhatsApp Locked` screen is
  in front, WhatsApp answers accessibility queries very slowly: measured ~6 s for the foreground-app query, ~20 s for
  the window size, and `see` timed out after 60 s. Requests then queue up inside WebDriverAgent until even
  `button home` stops answering and the runner has to be restarted. So: if `iphone status` takes more than a few
  seconds or `see` times out right after `open`, stop sending commands, tell the user "WhatsApp is locked — please
  unlock it with Face ID on the phone", and wait. Tapping `Unlock WhatsApp` yourself only works if the owner's face is
  in front of the phone (seen once: `Face Not Recognized`). Never type a passcode.
- Turn on Do Not Disturb first: a banner tapped by accident switches apps.
- Deleting media in WhatsApp is **permanent** (no Recently Deleted). Every delete needs the user's explicit yes
  for that specific chat. Report sizes first; delete nothing during the audit.

## Fastest path to the numbers
| Step | Do | You should see |
|---|---|---|
| 1 | `iphone open net.whatsapp.WhatsApp` | tab bar: Updates · Calls · Communities · Chats · You |
| 2 | tap `Button «You»` | settings list (cells are named `SettingsView_…`) |
| 3 | swipe up once, tap the row `StaticText «Storage and data»` (cell `SettingsView_DataAndStorageUsageCell`) | Storage and data |
| 4 | tap the row `Free up storage` (cell `DataAndStorageUsageView_StorageUsage`) | Free up storage |
| 5 | wait: `Used` shows `Calculating...` for 10–25 s, and the chat list is incomplete until it finishes | `Used 54.2 GB`, `… GB free` |

The cells in steps 2–4 have internal ids as labels, so `see --find Storage` returns the StaticText, not the cell:
tap its coordinates (`iphone tap X Y --why "Storage and data"`).

## What the screen gives you
- `Used` (WhatsApp media) and device free space.
- `Larger than 5 MB` and `Forwarded many times`, each with a size: the two quickest wins.
- `Storage details`: chats sorted by size. Name and size are separate texts on consecutive rows; scroll and pair them.
  Filter chips: All · Chats · Channels · Status.

## Clean-up of one chat (only after the user says yes for that chat)
Verified on a real run (one news group, 1,067 items, 2.52 GB, about 5½ minutes end to end):
1. Tap the chat row → grid of its items, largest first, total at the bottom (`Button «2.52 GB»`), `Select` top right.
2. `Select` → `Select all` → the header shows `1,067 Selected`.
3. Tap the delete control → the safety gate prints `NEEDS_APPROVAL`. Tell the user what will be deleted (chat, count,
   size) and run the same command with `--confirm` only after their yes.
4. WhatsApp shows a sheet `Delete selected items?` with two choices: `Delete items` and `Delete items and any copies`.
   **Ask the user which one** — "and any copies" also removes copies of the same files shared in other chats.
5. The chat then shows `No media in this chat`. Go back; `Used` recalculates (54.2 GB → 51.7 GB on the verified run).
   Report the before/after figure you actually see.

Good first candidates to propose: news/report/broadcast groups and `Forwarded many times`. Family, personal and work
chats: list them with sizes and let the user decide — never suggest deleting them wholesale.

## Privacy
Chat names, profile pictures and media thumbnails are personal data. Do not copy them into logs or summaries beyond
what the user needs to decide, and blur them in any recording that will be published.
