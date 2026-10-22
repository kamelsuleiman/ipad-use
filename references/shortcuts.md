# Shortcuts bridge — structured actions instead of 10 taps

Any Shortcut can be run from the agent: `ipad shortcut "<Name>" --input "<text>"` (it opens
`shortcuts://run-shortcut?name=…&input=text&text=…`). One call, no UI hunting — use it whenever a Shortcut can do the job.

## The bundled starter set
`scripts/make_shortcuts.py` builds and **signs on your Mac** (`shortcuts sign`, needs macOS 12+ and iCloud) four tiny
Shortcuts that take text input:

| Name | Does |
|---|---|
| iPad Use Speak | the iPad speaks the text aloud |
| iPad Use Note | creates an Apple Note with the text (first line = title) |
| iPad Use Reminder | adds a reminder with the text |
| iPad Use Clipboard | puts the text on the iPad clipboard (then paste anywhere) |

Install: run the script, copy `assets/shortcuts/signed/*.shortcut` to iCloud Drive (or AirDrop), open each on the iPad in
**Files** (tap the icon) → **Add Shortcut**. The agent can do this itself: open Files → navigate → tap icon → tap «Add Shortcut».

## First-run prompts
The first time a Shortcut writes to Notes/Reminders, iPadOS asks "Allow '…' to output …?". This sheet is usually **not**
in `see` — read the screenshot and tap «Always Allow» by coordinates (only if the user wants that Shortcut).

## Write your own
Build it in the Shortcuts app with **Receive Text input from Shortcut**, give it a unique name, and call it with
`ipad shortcut "<name>" --input "…"`. Unknown Shortcuts may do anything — treat running a Shortcut you didn't write
like any other risky action and ask the user first.
