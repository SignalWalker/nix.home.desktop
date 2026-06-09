import sys
import subprocess
import os
import re
from pathlib import Path

def noctalia(*args, bin_path: str = "noctalia", stdout = subprocess.PIPE, stderr = subprocess.PIPE) -> tuple[str, str] | None:
    cmd = [bin_path]
    cmd.extend(args)
    try:
        res = subprocess.run(cmd, stdout=stdout, stderr=stderr, encoding="utf-8")
        return (res.stdout.strip() if stdout == subprocess.PIPE else "", res.stderr.strip() if stderr == subprocess.PIPE else "")
    except subprocess.CalledProcessError:
        return None


def noctalia_set_wallpaper(output: str, path: Path, bin_path: str = "noctalia") -> tuple[str, str] | None:
    return noctalia("msg", "wallpaper-set", output, str(path), bin_path = bin_path)
