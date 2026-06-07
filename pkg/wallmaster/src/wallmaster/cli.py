import typer
import os
import random
from typing import Annotated
from pathlib import Path
from enum import Enum
from PIL import Image
from .awww import awww_query, awww
from .log import eprint, LogLevel
from .system import recursive_scandir
from .battery import is_battery_charged

class AnimationLevel(str, Enum):
    disable = "disable"
    allow_while_charged = "allow_while_charged"
    allow = "allow"
    prefer = "prefer"

STATIC_EXTENSIONS = { 'png', 'jpg', 'jpeg', 'pnm', 'tga', 'tiff', 'bmp', 'ff', 'svg' }
ANIMATED_EXTENSIONS = { 'avif', 'webp', 'gif' }

def get_allowed_extensions(animation: AnimationLevel) -> set[str]:
    match animation:
        case AnimationLevel.disable:
            return STATIC_EXTENSIONS
        case AnimationLevel.allow_while_charged:
            if is_battery_charged():
                return STATIC_EXTENSIONS | ANIMATED_EXTENSIONS
            else:
                return STATIC_EXTENSIONS
        case AnimationLevel.allow:
            return STATIC_EXTENSIONS | ANIMATED_EXTENSIONS
        case AnimationLevel.prefer:
            return ANIMATED_EXTENSIONS

def get_images(directory: Path, animation: AnimationLevel) -> list[Path]:
    _, images = recursive_scandir(directory, get_allowed_extensions(animation))
    return images


state = { "log_level": LogLevel.INFO, "bin_path": "awww" }
app = typer.Typer(no_args_is_help=True)

@app.callback()
def base(log_level: LogLevel = LogLevel.INFO, bin_path: str = "awww"):
    state["log_level"] = log_level
    state["bin_path"] = bin_path

dir_arg = typer.Argument(
            envvar = "XDG_WALLPAPERS_DIR",
            exists = True,
            file_okay = False,
            dir_okay = True,
            readable = True,
            resolve_path = True
            )

@app.command("list")
def list_all(directory: Annotated[Path, dir_arg], animation: AnimationLevel = AnimationLevel.allow_while_charged):
    try:
        images = get_images(directory, animation)
    except Exception as error:
        eprint(f"failed to find images; error: {error}", LogLevel.ERROR)
        return 1
    for img in images:
        print(img)

@app.command()
def select(directory: Annotated[Path, dir_arg], animation: AnimationLevel = AnimationLevel.allow_while_charged):
    try:
        images = get_images(directory, animation)
    except Exception as error:
        eprint(f"failed to find images; error: {error}", LogLevel.ERROR)
        return 1
    print(random.choice(images))

@app.command()
def list_outputs() -> int:
    outputs = awww_query(bin_path = state["bin_path"])
    if outputs is None:
        return 1
    for id, [width, height] in outputs.items():
        print(f"{id}, {width}x{height}")
    return 0

def display_img(image: Path, output: str, width: int, height: int, resize: bool, max_variance: float, dry_run: bool = False):
    resize_arg = "no"
    if resize:
        with Image.open(image) as img:
            img_w, img_h = img.size
            img_ratio = img_w / img_h
            scr_ratio = width / height
            variance = abs(scr_ratio - img_ratio)
            eprint(f"image dimensions: {img_w}x{img_h} ({img_ratio})")
            eprint(f"screen dimensions: {width}x{height} ({scr_ratio})")
            eprint(f"variance: {variance}")
            if variance > max_variance:
                eprint("resizing with `crop`")
                resize_arg = "crop"
            else:
                eprint("resizing with `fit`")
                resize_arg = "fit"
    awww_args = ["img", "--transition-type=random", "--filter=Nearest", f"--outputs={output}", f"--resize={resize_arg}", str(image)]
    if dry_run:
        eprint(awww_args)
    else:
        awww(*awww_args, bin_path = state["bin_path"], stdout=None, stderr=None)

@app.command("set")
def set_wallpaper(image: Annotated[Path, typer.Argument(exists=True,
            file_okay = True,
            dir_okay = False,
            readable = True,
            resolve_path = True
        )],
        outputs: list[str] = [],
        resize: bool = True,
        max_variance: float = 0.1,
        dry_run: bool = False
        ):
    outputs = [o.lower().strip() for o in outputs]
    found_outputs = awww_query(bin_path = state["bin_path"])
    if found_outputs is None:
        eprint("awww returned no outputs")
        return 1
    for id, [width, height] in found_outputs.items():
        if len(outputs) == 0 or id.lower().strip() in outputs:
            eprint(f"displaying image on output {id}")
            display_img(image, id, width, height, resize, max_variance, dry_run = dry_run)
    pass

@app.command()
def randomize(directory: Annotated[Path, dir_arg], outputs: list[str] = [], dry_run: bool = False, resize: bool = True, animation: AnimationLevel = AnimationLevel.allow_while_charged, max_variance: float = 0.1):
    try:
        images = get_images(directory, animation)
    except Exception as error:
        eprint(f"failed to find images; error: {error}", LogLevel.ERROR)
        return 1

    outputs = [o.lower().strip() for o in outputs]

    found_outputs = awww_query(bin_path = state["bin_path"])
    if found_outputs is None:
        eprint("awww returned no outputs")
        return 1
    for id, [width, height] in found_outputs.items():
        image = random.choice(images)
        if len(outputs) == 0 or id.lower().strip() in outputs:
            eprint(f"displaying image on output {id}")
            display_img(image, id, width, height, resize, max_variance, dry_run = dry_run)
            print(image)

if __name__ == "__main__":
    app()
