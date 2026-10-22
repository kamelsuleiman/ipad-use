#!/usr/bin/env python3
"""Builds + signs the ipad-use starter Shortcuts on your Mac. Output: assets/shortcuts/signed/*.shortcut (MIT)"""
import plistlib
import subprocess
from pathlib import Path

BASE = Path(__file__).resolve().parent.parent / "assets" / "shortcuts"
RAW, SIGNED = BASE / "raw", BASE / "signed"
RAW.mkdir(parents=True, exist_ok=True)
SIGNED.mkdir(parents=True, exist_ok=True)

INPUT_TEXT = {"Value": {"attachmentsByRange": {"{0, 1}": {"Type": "ExtensionInput"}}, "string": "￼"},
              "WFSerializationType": "WFTextTokenString"}
INPUT_ATTACH = {"Value": {"Type": "ExtensionInput"}, "WFSerializationType": "WFTextTokenAttachment"}


def act(ident, **params):
    return {"WFWorkflowActionIdentifier": ident, "WFWorkflowActionParameters": params}


LIBRARY = {
    "iPad Use Speak": (59511, [act("is.workflow.actions.speaktext", WFText=INPUT_TEXT)]),
    "iPad Use Reminder": (59446, [act("is.workflow.actions.addnewreminder", WFCalendarItemTitle=INPUT_TEXT)]),
    "iPad Use Note": (59772, [act("com.apple.mobilenotes.SharingExtension", WFCreateNoteInput=INPUT_TEXT, ShowWhenRun=False)]),
    "iPad Use Clipboard": (61440, [act("is.workflow.actions.setclipboard", WFInput=INPUT_ATTACH)]),
}

for name, (glyph, actions) in LIBRARY.items():
    wf = {
        "WFWorkflowActions": actions,
        "WFWorkflowClientVersion": "2607.0.2",
        "WFWorkflowMinimumClientVersion": 900,
        "WFWorkflowMinimumClientVersionString": "900",
        "WFWorkflowIcon": {"WFWorkflowIconStartColor": 463140863, "WFWorkflowIconGlyphNumber": glyph},
        "WFWorkflowImportQuestions": [],
        "WFWorkflowInputContentItemClasses": ["WFStringContentItem", "WFGenericFileContentItem"],
        "WFWorkflowHasShortcutInputVariables": True,
        "WFWorkflowTypes": [],
        "WFQuickActionSurfaces": [],
        "WFWorkflowOutputContentItemClasses": [],
    }
    raw = RAW / f"{name}.shortcut"
    raw.write_bytes(plistlib.dumps(wf, fmt=plistlib.FMT_BINARY))
    out = SIGNED / f"{name}.shortcut"
    r = subprocess.run(["shortcuts", "sign", "--mode", "anyone", "--input", str(raw), "--output", str(out)],
                       capture_output=True, text=True, timeout=120)
    print(name, "signed" if out.exists() and r.returncode == 0 else f"FAILED: {r.stderr.strip()[:200]}")
