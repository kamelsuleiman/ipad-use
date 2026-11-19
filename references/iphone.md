# iPhone field notes (verified on iPhone 16 Pro Max, iOS 26.5)

Use `scripts/iphone` — the same CLI as `ipad`, with its own home (`~/.ipad-use-iphone`).

## What is different from the iPad
- **Portrait, small screen** (440×956 pt on a Pro Max). `see` prints the real size and orientation; an app can switch
  to landscape (the header then says so) — always use the coordinates from the latest `see`.
- **Horizontal shelves** (Photos utilities, Control Center pages): elements with `x` larger than the screen width are
  off-screen. Swipe the shelf sideways, `see` again, then tap.
- **Settings-style rows**: the row's name and its value are separate texts on the same line (`Waze` … `While Using`),
  and some cells carry internal ids as labels. Pair texts by their `y`, and tap a row by its coordinates with `--why`.
- **Control Center**: `iphone swipe 400 4 400 320` from the Home Screen opens it; icons are labelled
  (`Screen Recording`, `Focus`, …).

## Locks you cannot and must not pass
- Lock screen: `locked: true` in `iphone status` → ask the user to unlock. Never type a passcode.
- App locks (WhatsApp, banking, notes): a screen with only an `Unlock …` button. Tap it, then the owner's face must be
  in front of the phone for Face ID. Ask the user to look at the phone; if it does not open, stop and say so.
  A locked app can also answer accessibility queries very slowly (commands hang for 20–60 s). Do not retry in a
  loop — requests pile up in WebDriverAgent. Ask the user to unlock the app on the phone, then continue.

## Keep the run clean
- Ask for Do Not Disturb before a long task. A notification banner at the top can be tapped by accident and switch
  apps; the CLI stops blind sequences when the foreground app changes, but single taps still land where you aim them.
- Auto-Lock → Never while the task runs, otherwise WebDriverAgent stops when the screen locks.
- A personal phone is full of private data. Open only what the task needs; do not open chats, photos, Health, Wallet
  or mail unless the user asked for exactly that, and keep names out of your summaries when sizes or counts are enough.

## Keeping WebDriverAgent running
On a personal iPhone prefer starting WebDriverAgent on demand (the phone must be unlocked at start). A keep-alive
service that retries while the phone is locked makes iOS ask for the passcode again and again.
