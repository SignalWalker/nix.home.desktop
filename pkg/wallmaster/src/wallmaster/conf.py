from enum import Enum

class AnimationLevel(str, Enum):
    disable = "disable"
    allow_while_charged = "allow_while_charged"
    allow = "allow"
    prefer = "prefer"
