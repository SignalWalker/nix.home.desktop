import os

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
