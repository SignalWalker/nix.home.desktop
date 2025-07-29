#!/usr/bin/env python3

import pprint

import sys
import json
import re
from subprocess import PIPE, run

def epprint(object):
	pprint.pprint(object, stream=sys.stderr)

def eprint(*objects, **kwargs):
	print(*objects, file=sys.stderr, **kwargs)

def wpctl(*args) -> str | None:
	cmd = ["wpctl"]
	cmd.extend(args)
	try:
		res = run(cmd, stdout=PIPE, stderr=PIPE, encoding="utf-8")
		err = res.stderr.strip()
		if err != "":
			eprint(f"wpctl error: {err}")
			return None
		return res.stdout.strip()
	except subprocess.CalledProcessError:
		return None

class State:
	def __init__(self):
		self.value = float(0)
		self.muted = False
		self.icon =  '?'

	def to_dict(self):
		return {
				'value': self.value,
				'muted': self.muted,
				'icon': self.icon
		}

	def print(self):
		print(json.dumps(self.to_dict()), sep='', end='\n', file=sys.stdout, flush=True)


volume_reg = re.compile(r"^Volume: (?P<value>\S+)\s*(?P<status>\[MUTED\])?")
def main() -> int:
	state = State()

	state_str = wpctl('get-volume', '@DEFAULT_AUDIO_SINK@')
	if state_str is None:
		state.print()
		return 0

	fmatch = volume_reg.fullmatch(state_str)
	if fmatch is None:
		state.print()
		return 0

	state.value = float(fmatch['value'])
	match fmatch['status']:
		case '[MUTED]': state.muted = True
		case _: state.muted = False

	if state.muted:
		state.icon = '󰝟'
	elif state.value <= 0.33:
		state.icon = '󰕿'
	elif state.value <= 0.66:
		state.icon = '󰖀'
	else:
		state.icon = '󰕾'

	state.print()

	return 0

if __name__ == '__main__':
	sys.exit(main())
