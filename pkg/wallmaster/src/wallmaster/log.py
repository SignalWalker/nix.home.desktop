from enum import IntEnum
import sys

class LogLevel(IntEnum):
    OFF = 0
    ERROR = 1
    WARNING = 2
    INFO = 3
    DEBUG = 4
    TRACE = 5

# for pretty printing to stderr
class Color:
    RED = '\033[31m'
    YELLOW = '\033[33m'
    GREEN = '\033[32m'
    BLUE = '\033[34m'
    PURPLE = '\033[35m'
    GREY = '\033[37m'
    ENDC = '\033[m'

def eprint(*objects, level: LogLevel = LogLevel.INFO, **kwargs):
	color = Color.ENDC
	if level == LogLevel.ERROR: color = Color.RED
	elif level == LogLevel.WARNING: color = Color.YELLOW
	elif level == LogLevel.INFO: color = Color.GREEN
	elif level == LogLevel.DEBUG: color = Color.BLUE
	elif level == LogLevel.TRACE: color = Color.PURPLE
	print(f"{color}[wallmaster]{Color.ENDC}", *objects, file=sys.stderr, **kwargs)
