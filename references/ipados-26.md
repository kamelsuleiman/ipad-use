# iPadOS 26 field notes — what trips agents up

Learned on a real iPad Pro 13" (M5), iPadOS 26.5. Add yours by PR.

## Geometry
- Landscape 13": **1376 × 1032 points**; screenshots are 2× pixels (2752 × 2064). `ipad see` scales its JPEG to 1100 px
  wide, so **pixel-in-that-JPEG × 1.25 ≈ points**. Prefer `tap N` and you never convert anything.
- The status bar (time/battery) and the top **app "breadcrumb"** («◀ Safari» back-to-previous-app link) live at y < 20.

## Windows & multitasking
- iPadOS 26 can show **several windows of the same app**. Activating an app brings back its *last* window — not
  necessarily the one you want. Close stray windows (long-press the app icon → Show All Windows) for reliable runs.
- `open <app>` uses *activate* first (brings the running app forward), then *launch*.
- A web page that asked for **full screen** leaves it when another app opens; it does not come back by itself.

## Keyboard & text
- Tap the field first, then `type`. Arabic/RTL, emoji and Hebrew type fine.
- The on-screen keyboard covers the bottom ~45%. Elements under it still appear in `see` but taps hit the keyboard.
  Dismiss with the keyboard's hide key, a tap on an empty area above, or `swipe down` inside the content.
- `type … --enter` sends a Return. In Notes that's a new line; in Safari's address bar it searches; in chat apps it SENDS.

## Things `see` cannot see
- **Shortcuts privacy sheets** ("Allow 'X' to output…"), some system sheets and the share sheet often **don't appear in
  the element tree** and not in `alert text`. Look at the screenshot and tap by coordinates (`tap X Y --why "Always Allow"`).
- Canvas apps (Procreate, Freeform canvas, games) expose few/no elements → screenshot + coordinates.
- Web views expose the page's accessibility tree — good sites are easy, canvas-heavy sites are not.

## Files app
- Tapping a file/folder **name** can start a **rename** — tap the **icon**.
- iCloud Drive files may show a cloud badge: the first tap downloads, the second opens.

## URLs and schemes that save many taps
- `ipad url "https://…"` opens the **default browser** (may be Chrome!). Force Safari with `x-safari-https://…`.
- `shortcuts://run-shortcut?name=<n>&input=text&text=<t>` runs any Shortcut with text input (see references/shortcuts.md).
- `maps://?q=Haifa`, `mailto:`, `tel:` (approval), `music://`, `photos-redirect://`, `prefs:` (often blocked).
- First time an app opens a URL of another app, iPadOS may ask "Open in …?" → `ipad alert accept`.

## Permissions prompts
- First use of camera/mic/photos/location/notifications → a system alert. `ipad alert text` shows it; accept only what
  the user's task needs.

## Locks and sleep
- WDA cannot unlock a passcode. `ipad doctor` tells you if the screen is locked. Keep Auto-Lock on Never while charging.

## System alerts (permissions) — use `alert`, not `tap`
- Permission prompts ("Allow “Maps” to use your location?") belong to **SpringBoard**. In landscape, `see` lists their
  buttons with **portrait coordinates** (e.g. «Don’t Allow» (164,688)) — a coordinate tap misses.
  Use `ipad alert buttons` → `ipad alert dismiss --button "Don’t Allow"` / `ipad alert accept --button "Allow Once"`.
- Default to the most privacy-preserving choice unless the user's task needs the permission.

## Settings
- Fastest path is the **Search** field at the top of the sidebar: `tap` it, `type 'About'`, `see --find About`.
  Results read like «Model Name, General → About».
