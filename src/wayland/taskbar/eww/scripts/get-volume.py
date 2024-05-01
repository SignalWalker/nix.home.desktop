#!/usr/bin/env python3

import sys
import json
import re
from subprocess import PIPE, run

def wpctl(*args) -> str | None:
    cmd = ["wpctl"]
    cmd.extend(args)
    try:
        res = run(cmd, stdout=PIPE, stderr=PIPE, encoding="utf-8")
        if res.stderr.strip() != "": return None
        return res.stdout.strip()
    except subprocess.CalledProcessError:
        return None

volume_reg = re.compile(r"^Volume: (?P<value>\S+)\s*(?P<status>\[MUTED\])?")
def main() -> int:
	state_str = wpctl('get-volume', '@DEFAULT_AUDIO_SINK@')
	if state_str is None:
		return 1

	state = {}
	fmatch = volume_reg.fullmatch(state_str)
	if fmatch is None:
		return 1

	state['value'] = float(fmatch['value'])
	match fmatch['status']:
		case '[MUTED]': state['muted'] = True
		case _: state['muted'] = False

	if state['muted']:
		state['icon'] = '󰝟'
	elif state['value'] <= 0.33:
		state['icon'] = '󰕿'
	elif state['value'] <= 0.66:
		state['icon'] = '󰖀'
	else:
		state['icon'] = '󰕾'

	print(json.dumps(state))

	return 0

if __name__ == '__main__':
	sys.exit(main())
