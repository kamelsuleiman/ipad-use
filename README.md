# iPad Use 🖐️📱

**An Agent Skill that lets Claude Code, Codex, Cursor, Hermes — any agent that reads `SKILL.md` — see and control a
real iPad over Wi-Fi.** Open apps, tap, type (Arabic too), run Shortcuts, generate in Gemini/ChatGPT, read the screen.

> Computer Use exists for the Mac. Browser Use exists for the web. Mobile MCPs exist for iPhone *testing*.
> **iPad Use** is for *using* your iPad: iPadOS 26-aware, safety-gated, and fast enough to feel like an assistant.

```text
you › "Ask Gemini on my iPad for an image of a cat astronaut on the moon"
agent › ipad run "open gemini; wait 1.5; see --no-shot --find chat"
agent › ipad run "tap 3; wait 1; see --no-shot --find InputText"
agent › ipad run "tap 0; type 'A cat astronaut on the moon, cinematic'"
agent › ipad see --find Send   →   NEEDS_APPROVAL «Send query»   →   "Send this prompt to Gemini?"  you › yes
agent › ipad tap 0 --confirm; ipad run "wait 12; see"   ✅
```

## Why it's different
- **Numbered elements (set-of-marks).** `ipad see` returns the screen's elements as `[7] Button «New note» (702,54)`;
  the agent taps `7`. No pixel guessing.
- **Batching.** `ipad run "tap 7; type '…'; wait 1; see"` = several steps in one tool call → far fewer model turns.
- **Shortest path first.** URL schemes and a Shortcuts bridge (`ipad shortcut "<name>" --input …`) beat 10 taps.
- **iPad-aware.** Field notes for iPadOS 26: multiple windows, hidden system sheets, permission prompts in portrait
  coordinates, the Files rename trap, default-browser surprises — see [`references/ipados-26.md`](references/ipados-26.md).
- **Safety gate built in.** Send / post / pay / delete / sign-out are held until the user says yes (`--confirm`).
- **App playbooks.** Real labels + fastest paths: Safari, Notes, Gemini, Files, Settings — more welcome by PR.
- **Zero dependencies.** One Python 3.9 stdlib script + Apple's own XCUITest via WebDriverAgent.

## Install
```bash
npx skills add kamelsuleiman/ipad-use          # or: git clone into your agent's skills folder
cd <skill folder> && scripts/setup.sh --team <YOUR_APPLE_TEAM_ID>
scripts/ipad doctor
```
Needs a Mac with Xcode, an Apple ID signed in to Xcode (paid = 1-year signature, free = re-run every 7 days),
and the iPad with Developer Mode on. Full guide: [`references/setup.md`](references/setup.md).

## Commands
`see` · `tap N` · `type` · `swipe` · `open` · `url` · `shortcut` · `alert` · `button` · `run "a; b; c"` · `doctor` · `status` ·
`do "<goal>"` (optional Gemini sub-agent). Details in [`SKILL.md`](SKILL.md).

## Evals
20 real-world tasks in [`evals/tasks.md`](evals/tasks.md) with results on an iPad Pro 13" (M5), iPadOS 26.5.
Help us fill the table — PRs with your device + results are welcome.

## Contributing
- New app playbook → `references/apps/<app>.md` (landmarks table + fastest path + gotchas, verified on a device).
- New iPadOS gotcha → `references/ipados-26.md`.
- Keep the safety gate conservative.

## Credits
Built by **Kamel Suleiman** · [NAWA Studio](https://nawa-studio.com) — with Claude.
Stands on [appium/WebDriverAgent](https://github.com/appium/WebDriverAgent) (BSD-3). MIT licensed.
