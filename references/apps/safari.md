# Safari (com.apple.mobilesafari)

| Landmark | Label (type) | Where |
|---|---|---|
| Address bar | «Address» (Button → becomes TextField) | top centre |
| New tab / Tabs | «New tab», «Tabs» (Button) | top right |
| Back | «Back» (Button) | top left |
| Share | «Share» (Button) | top right — share targets may send data: careful |
| Tab | «#TabBarTab» (Button) | tab strip |

## Fast paths
- **Open a site**: `ipad url "https://example.com"` (opens the default browser!) or force Safari: `ipad url "x-safari-https://example.com"`.
- **Search**: `ipad run "open safari; wait 1; see --no-shot --find Address"` → `ipad run "tap N; wait 0.6; type 'query' --enter; wait 3; see"`.
- **Read a page**: `see --limit 120` lists links/headings as elements; scroll with `swipe up` and `see` again.

## Gotchas
- If the user's default browser is Chrome, `https://` links open there, not in Safari.
- iPadOS 26 may keep several Safari windows; `open safari` returns to the last one used.
- Web forms: never type passwords or card numbers — hand over to the user.
