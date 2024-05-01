#! /usr/bin/env python3

import sys
import os
import subprocess
from subprocess import PIPE, run
import json
import re
from datetime import time, timedelta
from typing import Tuple

def playerctl(*args) -> str | None:
    cmd = ["playerctl"]
    cmd.extend(args)
    try:
        res = run(cmd, stdout=PIPE, stderr=PIPE, encoding="utf-8")
        if res.stderr.strip() != "": return None
        return res.stdout.strip()
    except subprocess.CalledProcessError:
        return None

metadata_reg = re.compile(r"^(?P<player>\S+)\s+(?P<tag>[^:]+):(?P<key>\S+)\s+(?P<value>.+)")
def get_metadata() -> Tuple[str, dict] | None:
    metadata_str = playerctl("metadata")
    if metadata_str is None: return None
    metadata = {}
    player = "<unknown>"
    for line in metadata_str.splitlines():
        fmatch = metadata_reg.fullmatch(line)
        if fmatch is None: sys.exit(1)
        player = fmatch['player']
        metadata[fmatch['key']] = fmatch['value']

    return (player, metadata)

hour = timedelta(hours = 1)
minute = timedelta(minutes = 1)
second = timedelta(seconds = 1)

def delta_to_str(delta: timedelta) -> str:
    res = ""
    hours = delta // hour
    if hours >= 1: res += f"{hours}:"
    minutes = (delta % hour) // minute
    seconds = ((delta % hour) % minute) // second
    res += f"{'0' if minutes < 10 else ''}{minutes}:{'0' if seconds < 10 else ''}{seconds}"
    return res

default_output = json.dumps({
    "text": "...",
    "tooltip": "No MPRIS player found",
    "class": "custom-playerctl"
})

def main() -> int:
    status_str = playerctl("status")
    if status_str is None:
        print(default_output)
        return 0
    status_icon = "?"
    match status_str.casefold():
        case "playing": status_icon = ""
        case "paused": status_icon = ""
        case _: status_icon = "?"

    metadata_res = get_metadata()
    if metadata_res is None:
        print(default_output)
        return 0
    (player, metadata) = metadata_res

    info_strs = []

    if "artist" in metadata: info_strs.append(metadata.get('albumArtist', metadata.get('artist')))
    # if "album" in metadata: info_strs.append(metadata['album'])
    if "title" in metadata: info_strs.append(metadata['title'])

    info_str = " - ".join(info_strs)

    percentage = None
    length = None
    position = None
    time_str = ""
    if "length" in metadata:
        position_res = playerctl("status", "-f", "{{position}}")
        if position_res is not None:
            length_int = int(metadata['length'])
            position_int = int(position_res)
            length = timedelta(microseconds = length_int)
            position = timedelta(microseconds = position_int)
            percentage = position / length
            time_str = f" {delta_to_str(position)}/{delta_to_str(length)}"

    output = {
        "text": f"{player} {status_icon}{time_str} {info_str}",
        "tooltip": info_str,
        "class": "custom-playerctl",
    }

    if percentage is not None: output['percentage'] = percentage

    print(json.dumps(output))
    return 0

if __name__ == '__main__':
    sys.exit(main())
