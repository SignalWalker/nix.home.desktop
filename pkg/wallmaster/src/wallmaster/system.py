import sys
import subprocess
import os
from .log import eprint
from .conf import AnimationLevel
from pathlib import Path

def recursive_scandir(dir: str, ext: set[str]):    # dir: str, ext: list
    subfolders, files = [], []

    for f in os.scandir(dir):
        if f.is_dir():
            subfolders.append(f.path)
        if f.is_file():
            if os.path.splitext(f.name)[1].lower()[1:] in ext:
                files.append(f.path)


    for dir in list(subfolders):
        sf, f = recursive_scandir(dir, ext)
        subfolders.extend(sf)
        files.extend(f)

    return subfolders, files

def get_user_dir(name: str) -> str | None:
    cmd = ["xdg-user-dir", name]
    try:
        res = subprocess.run(cmd, stdout = subprocess.PIPE, encoding="utf-8")
        return res.stdout.strip()
    except subprocess.CalledProcessError:
        return None

def get_override_path() -> Path:
    runtime_dir = os.getenv("XDG_RUNTIME_DIR")
    if runtime_dir == None:
        eprint("could not read $XDG_RUNTIME_DIR", LogLevel.ERROR)
        return Path("/tmp")
    return Path(runtime_dir) / "wallmaster.conf"

def get_animation_override(default: AnimationLevel) -> AnimationLevel:
    override_file = get_override_path()
    if override_file.exists():
        override = override_file.read_text().strip().lower()
        match override:
            case "disable":
                return AnimationLevel.disable
            case "allow_while_charged":
                return AnimationLevel.allow_while_charged
            case "allow":
                return AnimationLevel.allow
            case "prefer":
                return AnimationLevel.prefer
            case _:
                eprint(f"unrecognized animation override: {override}", LogLevel.ERROR)
                return default
    else:
        return default

def set_animation_override(override: AnimationLevel | None):
    override_file = get_override_path()
    if override == None and override_file.exists():
        override_file.unlink()
    else:
        with override_file.open(mode = "w") as f:
            f.write(override)
