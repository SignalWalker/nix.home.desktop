#! /usr/bin/env python3

import inspect

import pprint

import sys
import json
from datetime import timedelta

from urllib.parse import unquote, urlparse

import gi
gi.require_version('Playerctl', '2.0')
from gi.repository import Playerctl, GLib, GObject


def epprint(object):
    pprint.pprint(object, stream=sys.stderr)

def eprint(*objects, **kwargs):
    print(*objects, file=sys.stderr, **kwargs)

player_state = { }

def print_state():
    print(json.dumps(list(player_state.values())), sep='', end='\n', file=sys.stdout, flush=True)

def update_playback_status(player, status):
    status = status.casefold()
    player_name = player.props.player_name
    player_state[player_name]['status'] = status

    status_icon = "?"
    match status:
        case "playing": status_icon = ""
        case "paused": status_icon = ""
        case "stopped": status_icon = "⏹"
        case _: status_icon = "?"

    player_state[player_name]['status_icon'] = status_icon


def on_playback_status(player, status, manager):
    update_playback_status(player, status.value_nick)
    print_state()

def update_metadata(player, metadata):
    metadata = dict(metadata)

    if 'mpris:artUrl' in metadata:
        metadata['mpris:artUrl'] = unquote(urlparse(metadata['mpris:artUrl']).path)
    if 'xesam:artist' in metadata:
        metadata['xesam:artist'] = ', '.join(metadata['xesam:artist'])

    player_state[player.props.player_name]['metadata'] = metadata

def on_metadata(player, metadata, manager):
    update_metadata(player, metadata)
    print_state()

def update_volume(player, volume):
    player_state[player.props.player_name]['volume'] = volume

def on_volume(player, volume, manager):
    update_volume(player, volume)
    print_state()

# format microseconds as [H:]M:S
def strfmtms(ms) -> str:
    seconds = ms / 1000000
    hours, remainder = divmod(seconds, 3600)
    minutes, seconds = divmod(remainder, 60)
    if hours > 0:
        return f"{int(hours)}:{int(minutes):02}:{int(seconds):02}"
    else:
        return f"{int(minutes)}:{int(seconds):02}"

def update_position(player) -> bool:
    name = player.props.player_name
    prev = player_state[name].get('position')
    if prev is None or player.props.position != prev:
        player_state[name]['position'] = player.props.position
        metadata = player_state[name].get('metadata')
        if not metadata is None:
            length = metadata.get('mpris:length')
            if not length is None:
                player_state[name]['elapsed'] = strfmtms(player.props.position)
                player_state[name]['length'] = strfmtms(length)
        return True
    else:
        return False

def on_update_timeout(player):
    if not player.props.player_name in player_state:
        return False

    if update_position(player):
        print_state()

    return True

# def on_play(player, play):
#     epprint(dir(play))

# def on_seeked(player, seeked, manager):
#     epprint(dir(seeked))

def init_player(manager, name):
    eprint(f"initializing player: {name.name}")

    player = Playerctl.Player.new_from_name(name)

    # epprint(GObject.signal_list_names(Playerctl.Player))

    player_state[name.name] = { "player": name.name }

    update_playback_status(player, player.props.status)
    update_metadata(player, player.props.metadata)
    update_volume(player, player.props.volume)
    update_position(player)

    player.connect('playback-status', on_playback_status, manager)
    player.connect('metadata', on_metadata, manager)
    player.connect('volume', on_volume, manager)
    # player.connect('play', on_play, manager)
    # player.connect('seeked', on_seeked, manager)

    manager.manage_player(player)

    GLib.timeout_add(1000, on_update_timeout, player)


def on_name_appeared(manager, name):
    init_player(manager, name)
    print_state()

def on_player_vanished(manager, player):
    eprint(f"removing vanished player from state: {player.props.player_name}")
    del player_state[player.props.player_name]
    print_state()

def main() -> int:

    manager = Playerctl.PlayerManager()

    manager.connect('name-appeared', on_name_appeared)
    manager.connect('player-vanished', on_player_vanished)

    for name in manager.props.player_names:
        init_player(manager, name)

    print_state()

    main = GLib.MainLoop()
    main.run()
    return 0

if __name__ == '__main__':
    sys.exit(main())
