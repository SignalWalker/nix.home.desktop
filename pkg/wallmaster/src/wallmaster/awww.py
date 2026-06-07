import sys
import subprocess
import os
import re
from .log import eprint

def awww(*args, bin_path = "awww", stdout = subprocess.PIPE, stderr = subprocess.PIPE) -> tuple[str, str] | None:
    cmd = [bin_path]
    cmd.extend(args)
    eprint(f"cmd: {' '.join(cmd)}");
    try:
        res = subprocess.run(cmd, stdout=stdout, stderr=stderr, encoding="utf-8")
        return (res.stdout.strip() if stdout == subprocess.PIPE else "", res.stderr.strip() if stderr == subprocess.PIPE else "")
    except subprocess.CalledProcessError:
        return None

query_reg = re.compile(r"^(?P<name>[^:]*):\s+(?P<id>[^:]+):\s+(?P<width>\d+)x(?P<height>\d+)")
def awww_query(bin_path = "awww") -> dict[str, tuple[int, int]] | None:
    query = awww("query", bin_path = bin_path)
    if query is None: return None
    screens = {}
    out, _ = query
    for line in out.splitlines():
        fmatch = query_reg.match(line)
        if fmatch is None:
            eprint(f"couldn't find matches in `{line}`", LogLevel.ERROR)
            sys.exit(1)
        screens[fmatch['id']] = (int(fmatch['width']), int(fmatch['height']))

    return screens
