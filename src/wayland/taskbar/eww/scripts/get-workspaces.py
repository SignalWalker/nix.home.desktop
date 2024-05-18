#! /usr/bin/env python3

import sys
import json

import asyncio

from i3ipc import Event
from i3ipc.aio import Connection

def ws_to_dict(ws) -> dict:
    return {
        'num': ws.num,
        'name': ws.name,
        # 'visible': ws.visible, # TODO :: re-add when i3ipc is updated
        'focused': ws.focused,
        # 'urgent': ws.urgent,
        # 'output': ws.output
    }


async def main():
    workspaces: dict[dict] = {}

    def init_ws(ws):
        workspaces[ws.name] = ws_to_dict(ws)

    def print_state():
        print(json.dumps([workspaces[key] for key in sorted(workspaces.keys(), key = lambda key: 'zzz' if key == '0' else key)]), sep='', end='\n', file=sys.stdout, flush=True)

    def on_workspace(sway, e):
        match e.change:
            case 'init':
                init_ws(e.current)
                print_state()
            case 'focus':
                if e.old is not None:
                    if e.old.name in workspaces:
                        workspaces[e.old.name]['focused'] = False
                if e.current is not None:
                    workspaces[e.current.name]['focused'] = True
                print_state()
            case 'empty':
                if e.current.name in workspaces:
                    del workspaces[e.current.name]
                    print_state()
            case change: pass

    sway = await Connection(auto_reconnect=True).connect()

    for ws in await sway.get_workspaces():
        init_ws(ws)

    print_state()

    sway.on(Event.WORKSPACE, on_workspace)

    await sway.main()

if __name__ == '__main__':
    asyncio.run(main())


