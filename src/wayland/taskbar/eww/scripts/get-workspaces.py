#! /usr/bin/env python3

import sys
import json
import os

import re

import asyncio

from asyncio import StreamReader, StreamWriter

from dataclasses import dataclass

from collections.abc import Callable

from enum import Enum

class Event(Enum):
    WORKSPACE = 0
    CREATE_WORKSPACE = 1
    DESTROY_WORKSPACE = 2

@dataclass
class Workspace:
    id: int
    name: str
    focused: bool

    @classmethod
    def from_v2(Workspace, data: str, focused: bool = False):
        id, name = data.split(',')
        return Workspace(int(id), name, focused)

    def to_dict(self) -> dict:
        return {
            'num': self.id,
            'name': self.name,
            # 'visible': ws.visible, # TODO :: re-add when i3ipc is updated
            'focused': self.focused,
            # 'urgent': ws.urgent,
            # 'output': ws.output
        }

EVENT_REGEX = re.compile(r"(.+)>>(.+)")

class Hypr:
    state = None
    _events: StreamReader
    __events_writer: StreamWriter
    _ctl: StreamWriter
    __ctl_reader: StreamReader
    _callbacks: dict[Event, Callable[..., None]]

    def __init__(self, state, events: StreamReader, events_writer: StreamWriter, ctl_reader: StreamReader, ctl: StreamWriter, callbacks: dict[Event, Callable[..., None]] = {}):
        self.state = state
        self._events = events
        self.__events_writer = events_writer
        self._ctl = ctl
        self.__ctl_reader = ctl_reader
        self._callbacks = callbacks

    @classmethod
    async def connect(Hypr, state):
        runtime_dir = os.environ["XDG_RUNTIME_DIR"]
        hyprland_signature = os.environ["HYPRLAND_INSTANCE_SIGNATURE"]
        hypr_dir = f"{runtime_dir}/hypr/{hyprland_signature}"
        ctl_reader, ctl = await asyncio.open_unix_connection(f"{hypr_dir}/.socket.sock")
        events, events_writer = await asyncio.open_unix_connection(f"{hypr_dir}/.socket2.sock")
        return Hypr(state, events, events_writer, ctl_reader, ctl)

    def on(self, ev: Event, call: Callable[..., None]) -> None:
        self._callbacks[ev] = call

    async def get_workspaces(self) -> list:
        return [Workspace(1, "1", True)]

    def cb(self, ev: Event, data):
        cb = self._callbacks.get(ev)
        if cb is not None:
            cb(self, data)

    async def main(self) -> None:
        async for line in self._events:
            line = line.decode("utf-8").rstrip()
            m = EVENT_REGEX.fullmatch(line)
            if m is not None:
                name = m.group(1)
                data = m.group(2)
                try:
                    match name:
                        case 'workspacev2':
                            self.cb(Event.WORKSPACE, Workspace.from_v2(data, True))
                        case 'createworkspacev2':
                            self.cb(Event.CREATE_WORKSPACE, Workspace.from_v2(data))
                        case 'destroyworkspacev2':
                            self.cb(Event.DESTROY_WORKSPACE, int(data.split(',')[0]))
                        case name:
                            pass
                except:
                    pass

class State:
    def __init__(self):
        self.current = None
        self.workspaces = {}

    def print(self):
        print(json.dumps([self.workspaces[key].to_dict() for key in sorted(self.workspaces.keys(), key = lambda key: 999 if key == 0 else key)]), sep='', end='\n', file=sys.stdout, flush=True)

async def main():
    def on_workspace(hypr: Hypr, e: Workspace):
        if hypr.state.current is not None:
            hypr.state.workspaces[state.current].focused = False
        hypr.state.workspaces[e.id] = e
        hypr.state.current = e.id
        hypr.state.print()

    def on_create(hypr: Hypr, ws: Workspace):
        if ws.name.startswith("special"):
            return
        hypr.state.workspaces[ws.id] = ws
        hypr.state.print()

    def on_destroy(hypr: Hypr, id: int):
        if id in hypr.state.workspaces:
            del hypr.state.workspaces[id]
            hypr.state.print()

    state = State()
    hypr = await Hypr.connect(state)

    for ws in await hypr.get_workspaces():
        state.workspaces[ws.id] = ws
        if ws.focused:
            state.current = ws.id

    state.print()

    hypr.on(Event.WORKSPACE, on_workspace)
    hypr.on(Event.CREATE_WORKSPACE, on_create)
    hypr.on(Event.DESTROY_WORKSPACE, on_destroy)

    await hypr.main()

if __name__ == '__main__':
    asyncio.run(main())
