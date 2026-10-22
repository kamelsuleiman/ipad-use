# Settings (com.apple.Preferences)

## Fast path: search, don't scroll
```bash
ipad run "open settings; wait 1.2; see --no-shot --find Search"     # «Search» (SearchField), top of the sidebar
ipad run "tap N; wait 0.5; type 'About'; wait 1.2; see --no-shot --find About"
ipad run "tap <«About, General»>; wait 1; see --no-shot --find 'iPadOS'"   # → «iPadOS Version, 26.5»
```
Results are labelled «<Item>, <Section → Page>».

## Read-only is safe; changes need care
- Reading values (version, storage, battery health) — fine.
- Toggling Wi-Fi/Bluetooth/Airplane, Focus, display — only when the user asked.
- Never: Apple ID, passcode, Face ID, Erase/Reset, VPN & Device Management, Developer Mode. Ask the user to do those.
