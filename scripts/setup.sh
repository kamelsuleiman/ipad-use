#!/bin/zsh
# ipad-use setup — builds, signs and installs WebDriverAgent on YOUR iPad (or iPhone), then starts it.
# Usage:  scripts/setup.sh --team <APPLE_TEAM_ID> [--iphone] [--bundle-prefix com.yourname] [--udid <hardware udid>]
# Needs: macOS + Xcode (signed in to your Apple ID in Xcode → Settings → Accounts), the device connected by cable once,
#        "Trust This Computer", Developer Mode ON (Settings → Privacy & Security). Free Apple ID = re-run every 7 days.
# iPad: WebDriverAgent is kept running by launchd.  iPhone (--iphone): started on demand, no keep-alive service
# (a keep-alive that retries while a personal phone is locked makes iOS ask for the passcode again and again).
set -euo pipefail
TEAM="" ; PREFIX="" ; UDID="" ; KIND="iPad"
while [[ $# -gt 0 ]]; do case "$1" in
  --team) TEAM="$2"; shift 2;; --bundle-prefix) PREFIX="$2"; shift 2;; --udid) UDID="$2"; shift 2;;
  --iphone) KIND="iPhone"; shift;;
  *) echo "unknown arg $1"; exit 1;; esac; done
[[ -z "$TEAM" ]] && { echo "❌ --team <TEAM_ID> is required (Xcode → Settings → Accounts → your team, or developer.apple.com → Membership)"; exit 1; }
PREFIX="${PREFIX:-com.ipaduse.$USER}"
if [[ "$KIND" == "iPhone" ]]; then
  HOMEDIR="${IPHONE_USE_HOME:-$HOME/.ipad-use-iphone}"; CLI="iphone"
else
  HOMEDIR="${IPAD_USE_HOME:-$HOME/.ipad-use}"; CLI="ipad"
fi
mkdir -p "$HOMEDIR"
command -v xcodebuild >/dev/null || { echo "❌ Xcode not found"; exit 1; }

echo "① Finding your $KIND…"
J="$HOMEDIR/devices.json"
xcrun devicectl list devices --json-output "$J" >/dev/null 2>&1 || true
read -r CORE HW NAME <<<"$(/usr/bin/python3 - "$J" "$UDID" "$KIND" <<'PY'
import json,sys
d=json.load(open(sys.argv[1]))["result"]["devices"]; want=sys.argv[2]; kind=sys.argv[3]
for x in d:
    hp=x.get("hardwareProperties",{}); dp=x.get("deviceProperties",{})
    if hp.get("deviceType")==kind and (not want or hp.get("udid")==want):
        print(x["identifier"], hp.get("udid"), (dp.get("name") or kind).replace(" ","_")); break
PY
)"
[[ -z "${CORE:-}" ]] && { echo "❌ No paired $KIND found. Connect it by cable, unlock, tap Trust, then: xcrun devicectl manage pair --device <id>"; exit 1; }
echo "   → $NAME · $HW"
xcrun devicectl manage pair --device "$CORE" >/dev/null 2>&1 || true
DM=$(xcrun devicectl device info details --device "$CORE" 2>/dev/null | awk -F': ' '/developerModeStatus/{print $2}')
[[ "$DM" != "enabled" ]] && { echo "❌ Developer Mode is '$DM'. $KIND → Settings → Privacy & Security → Developer Mode → On (restarts)."; exit 1; }

echo "② Getting WebDriverAgent…"
WDA="$HOMEDIR/WebDriverAgent"
[[ -d "$WDA" ]] || git clone --depth 1 https://github.com/appium/WebDriverAgent.git "$WDA"

echo "③ Building + signing (team $TEAM)… (first time takes a few minutes)"
cd "$WDA"
xcodebuild build-for-testing -project WebDriverAgent.xcodeproj -scheme WebDriverAgentRunner \
  -destination "id=$HW" -derivedDataPath "$HOMEDIR/wda-build" \
  -allowProvisioningUpdates -allowProvisioningDeviceRegistration \
  DEVELOPMENT_TEAM="$TEAM" CODE_SIGN_STYLE=Automatic CODE_SIGN_IDENTITY="Apple Development" \
  PRODUCT_BUNDLE_IDENTIFIER="$PREFIX.WebDriverAgentRunner" > "$HOMEDIR/build.log" 2>&1 \
  || { echo "❌ build failed — last lines:"; grep -E "error:" "$HOMEDIR/build.log" | tail -5; exit 1; }

RUN="$HOMEDIR/run-wda.sh"
cat > "$RUN" <<EOF
#!/bin/zsh
export PATH="/usr/bin:/bin:/usr/sbin:/sbin"
if ! xcrun devicectl list devices 2>/dev/null | grep "$CORE" | grep -v unavailable | grep -qE "available|connected"; then sleep 45; exit 1; fi
[ -f "$HOMEDIR/wda.log" ] && [ \$(stat -f%z "$HOMEDIR/wda.log") -gt 5000000 ] && mv "$HOMEDIR/wda.log" "$HOMEDIR/wda.log.1"
cd "$WDA"
exec xcodebuild test-without-building -project WebDriverAgent.xcodeproj -scheme WebDriverAgentRunner \\
  -destination "id=$HW" -derivedDataPath "$HOMEDIR/wda-build" >> "$HOMEDIR/wda.log" 2>&1
EOF
chmod +x "$RUN"
echo "{\"udid\": \"$HW\", \"core_id\": \"$CORE\", \"team\": \"$TEAM\", \"bundle\": \"$PREFIX.WebDriverAgentRunner\"}" > "$HOMEDIR/config.json"
if [[ "$KIND" == "iPhone" ]]; then
echo "④ Starting WebDriverAgent on demand (no keep-alive on a phone)…"
nohup "$RUN" >/dev/null 2>&1 &
else
echo "④ Installing the keep-alive runner (launchd: com.ipad-use.wda)…"
PL="$HOME/Library/LaunchAgents/com.ipad-use.wda.plist"
cat > "$PL" <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0"><dict>
  <key>Label</key><string>com.ipad-use.wda</string>
  <key>ProgramArguments</key><array><string>$RUN</string></array>
  <key>RunAtLoad</key><true/><key>KeepAlive</key><true/><key>ThrottleInterval</key><integer>20</integer>
  <key>StandardOutPath</key><string>$HOMEDIR/runner.log</string><key>StandardErrorPath</key><string>$HOMEDIR/runner.log</string>
</dict></plist>
EOF
launchctl bootout gui/$(id -u)/com.ipad-use.wda 2>/dev/null || true
launchctl bootstrap gui/$(id -u) "$PL"
fi

echo "⑤ Waiting for WebDriverAgent (keep the $KIND UNLOCKED)…"
for i in {1..40}; do
  URL=$(grep -o "ServerURLHere->[^<]*" "$HOMEDIR/wda.log" 2>/dev/null | tail -1 | sed 's/ServerURLHere->//')
  [[ -n "$URL" ]] && curl -s -m 3 "$URL/status" | grep -q '"ready" : true' && { echo "✅ Ready at $URL"; break; }
  sleep 3
done
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
echo
"$SCRIPT_DIR/$CLI" doctor || true
echo
if [[ "$KIND" == "iPhone" ]]; then
  echo "Next time: unlock the iPhone, then start WebDriverAgent with:  $RUN &"
  echo "Tip: Auto-Lock → Never and Do Not Disturb on while a task runs; set Auto-Lock back afterwards."
else
  echo "Tip: iPad → Settings → Display & Brightness → Auto-Lock → Never (while charging), so the agent can always reach it."
fi
