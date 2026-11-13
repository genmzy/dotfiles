#!/usr/bin/env python3
"""Keep kitty's font size in sync with the niri output its window is on.

Listens to the niri event stream and, whenever a window or workspace changes,
looks up which output each kitty process lives on, then sets that instance's
font size over kitty's remote-control socket (listen_on unix:/tmp/kitty-{pid}).
"""

import fcntl
import json
import os
import shutil
import subprocess
import sys
import time

NIRI = shutil.which("niri") or "niri"
KITTY = shutil.which("kitty") or os.path.expanduser("~/.local/kitty.app/bin/kitty")

FONT_SIZES = {
    "eDP-1": 16.4,
    "HDMI-A-1": 17.3,
}
DEFAULT_SIZE = 17.3

EVENTS = {
    "WindowsChanged",
    "WindowOpenedOrChanged",
    "WindowClosed",
    "WorkspacesChanged",
    "WorkspaceActivated",
}


def niri_json(*args):
    try:
        result = subprocess.run(
            [NIRI, "msg", "--json", *args],
            capture_output=True,
            text=True,
            timeout=5,
        )
    except (OSError, subprocess.TimeoutExpired):
        return None
    if result.returncode != 0:
        return None
    try:
        return json.loads(result.stdout)
    except json.JSONDecodeError:
        return None


def kitty_outputs():
    windows = niri_json("windows") or []
    workspaces = niri_json("workspaces") or []
    output_of_workspace = {ws["id"]: ws.get("output") for ws in workspaces}

    result = {}
    for window in windows:
        if window.get("app_id") != "kitty" or window.get("pid") is None:
            continue
        output = output_of_workspace.get(window.get("workspace_id"))
        if not output:
            continue
        entry = result.setdefault(window["pid"], {"outputs": set(), "focused": None})
        entry["outputs"].add(output)
        if window.get("is_focused"):
            entry["focused"] = output
    return result


def apply_font_sizes(verbose=False, last=None):
    for pid, entry in kitty_outputs().items():
        output = entry["focused"] or next(iter(entry["outputs"]))
        size = FONT_SIZES.get(output, DEFAULT_SIZE)
        if last is not None and last.get(pid) == size:
            continue

        sock = f"/tmp/kitty-{pid}"
        if not os.path.exists(sock):
            if verbose:
                print(f"kitty pid {pid} on {output}: no socket {sock}", file=sys.stderr)
            continue

        try:
            result = subprocess.run(
                [KITTY, "@", "--to", f"unix:{sock}", "set-font-size", "--all", str(size)],
                capture_output=True,
                text=True,
                timeout=5,
            )
        except (OSError, subprocess.TimeoutExpired) as exc:
            if verbose:
                print(f"kitty pid {pid}: {exc}", file=sys.stderr)
            continue

        if result.returncode != 0:
            if verbose:
                print(f"kitty pid {pid}: {result.stderr.strip()}", file=sys.stderr)
            continue

        if last is not None:
            last[pid] = size
        if verbose:
            print(f"kitty pid {pid} on {output}: font size -> {size}", file=sys.stderr)


def stream_events():
    process = subprocess.Popen(
        [NIRI, "msg", "--json", "event-stream"],
        stdout=subprocess.PIPE,
        stderr=subprocess.DEVNULL,
        text=True,
        bufsize=1,
    )
    stdout = process.stdout
    assert stdout is not None
    try:
        while True:
            line = stdout.readline()
            if not line:
                break
            line = line.strip()
            if not line:
                continue
            try:
                yield next(iter(json.loads(line)))
            except (StopIteration, json.JSONDecodeError):
                continue
    finally:
        process.kill()
        process.wait()


def acquire_lock():
    path = os.path.join(os.environ.get("XDG_RUNTIME_DIR", "/tmp"), "kitty_font_by_output.lock")
    handle = open(path, "w")
    try:
        fcntl.flock(handle, fcntl.LOCK_EX | fcntl.LOCK_NB)
    except OSError:
        handle.close()
        return None
    return handle


def main():
    if "--once" in sys.argv:
        apply_font_sizes(verbose=True)
        return

    lock = acquire_lock()
    if lock is None:
        print("kitty_font_by_output: another instance is already running", file=sys.stderr)
        return

    verbose = "--verbose" in sys.argv
    last = {}
    while True:
        try:
            for event in stream_events():
                if event in EVENTS:
                    apply_font_sizes(verbose=verbose, last=last)
        except Exception as exc:
            print(f"kitty_font_by_output: {exc}", file=sys.stderr)
        time.sleep(1)


if __name__ == "__main__":
    main()
