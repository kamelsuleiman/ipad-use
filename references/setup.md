# Setup — one time, ~10 minutes

## You need
- A Mac with **Xcode** (26+ recommended) and **Python 3.9+** (macOS ships one).
- An **iPad** on iPadOS 17+ (tested on iPad Pro 13" M5, iPadOS 26.5) and a USB-C cable for the first pairing.
- An **Apple ID signed in to Xcode** (Xcode → Settings → Accounts). A paid developer account keeps the signature for
  1 year; a free Apple ID works but must be re-signed every **7 days** (just re-run `setup.sh`).

## Steps
1. Plug the iPad in, unlock it, tap **Trust This Computer**.
2. Open Xcode → **Window → Devices and Simulators** so the iPad shows up (this also reveals Developer Mode on the iPad).
3. iPad → **Settings → Privacy & Security → Developer Mode → On** → it restarts → tap **Turn On**.
4. In Devices and Simulators tick **Connect via network** (Wi-Fi control afterwards — same network, or Tailscale).
5. Find your **Team ID**: Xcode → Settings → Accounts → your team (10 characters, e.g. `AB12CD34EF`).
6. Run:
   ```bash
   scripts/setup.sh --team AB12CD34EF            # optional: --bundle-prefix com.yourname
   scripts/ipad doctor
   ```
   `setup.sh` finds the iPad, clones `appium/WebDriverAgent`, builds and signs it with your team, registers the device in
   your account, installs a **launchd keep-alive** (`com.ipad-use.wda`) and writes `~/.ipad-use/config.json`.
7. iPad → Settings → Display & Brightness → **Auto-Lock → Never** while it charges. A locked iPad can't be driven.

## Troubleshooting
| Symptom | Fix |
|---|---|
| `Device "iPad" isn't registered in your developer account` | `setup.sh` already passes `-allowProvisioningDeviceRegistration`; make sure Xcode is signed in to that team. |
| `No profiles for '…xctrunner'` | Same as above, or the bundle prefix is taken — use `--bundle-prefix com.<you>.<something>`. |
| `Unlock iPad to Continue` in `~/.ipad-use/wda.log` | Unlock the iPad; the runner waits and continues by itself. |
| `ipad doctor` says WDA unreachable | iPad asleep/locked, or Wi-Fi changed. `launchctl kickstart -k gui/$(id -u)/com.ipad-use.wda` |
| "Untrusted Developer" on the iPad (free account) | Settings → General → VPN & Device Management → trust your Apple ID. |
| Taps land in the wrong place | Coordinates are **points** (1376×1032 landscape on 13"), not screenshot pixels. Prefer `tap N`. |
| Several Safari windows (iPadOS 26) | `open safari` brings back *a* window, maybe not yours. Close extra windows, or open URLs with `x-safari-https://`. |

## Uninstall
```bash
launchctl bootout gui/$(id -u)/com.ipad-use.wda; rm ~/Library/LaunchAgents/com.ipad-use.wda.plist; rm -rf ~/.ipad-use
```
Then delete "WebDriverAgentRunner" from the iPad home screen.
