import os

POWER_DIR = "/sys/class/power_supply"

def get_battery_status(path: str) -> dict:
    res = {}
    with open(os.path.join(path, "uevent")) as uevent:
        for line in uevent:
            data = line.split("=", maxsplit=1)
            res[data[0].strip()] = data[1].strip()
    return res

def is_battery_charged(charge_min: float = 0.75) -> bool:
    bat = None
    # find first battery
    for f in os.scandir(POWER_DIR):
        if f.is_dir() and f.name.startswith("BAT"):
            bat = f
            break
    # No battery found; assume we're on desktop or something
    if bat is None:
        return True

    status = get_battery_status(bat)
    if status["POWER_SUPPLY_STATUS"] != "Discharging":
        return True # don't remember why i set it up this way

    return (float(status["POWER_SUPPLY_CHARGE_NOW"]) / max(float(status["POWER_SUPPLY_CHARGE_FULL"]), 1)) >= charge_min
