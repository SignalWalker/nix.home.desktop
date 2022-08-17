#! /usr/bin/env zsh

# input

touchpad=""
keyboard=""

riverctl input $touchpad accel-profile adaptive
riverctl input $touchpad pointer-accel "1.0"
riverctl input $touchpad click-method clickfinger
riverctl input $touchpad drag enabled
riverctl input $touchpad drag-lock disabled
riverctl input $touchpad disable-while-typing disabled
riverctl input $touchpad natural-scroll enabled
riverctl input $touchpad left-handed disabled
riverctl input $touchpad tap enabled
riverctl input $touchpad tap-button-map left-right-middle
riverctl input $touchpad scroll-method two-finger

riverctl focus-follows-cursor normal
riverctl set-cursor-warp disabled

riverctl set-repeat 4 1000

# appearance

riverctl background-color 0x000000
riverctl border-color-focused 0xCCFFDD
riverctl border-color-unfocused 0xDDDDDD
riverctl border-color-urgent 0xFFCCDD
riverctl border-width 1

# keymap

## meta

riverctl map normal Super+Alt+Shift Q exit

## app management

riverctl map normal Super Return spawn kitty
riverctl map normal Super+Shift Q close

## layout management


riverctl map normal Super+Shift Space toggle-float
riverctl map normal Super F toggle-fullscreen

riverctl map normal Super Space zoom

riverctl default-layout rivercarro

## tag management

# 11111111 11000000 00000000 00000000
# ^---------^^----------------------^
# workspaces scratchpads

### sticky windows
tag_pinned=$((1 << 31))

riverctl map normal Super P toggle-focused-tags $tag_pinned
riverctl map normal Super+Shift P toggle-view-tags $tag_pinned

### workspaces

for ws in $(seq 0 9); do
    ws_tag=$((1 << $ws))
    riverctl map normal Super $ws set-focused-tags $(($ws_tag + $tag_pinned))
    riverctl map normal Super+Shift $ws set-view-tags $ws_tag
done

### scratchpads

sp_general=$((1 << 10))
sp_terminal=$((1 << 11))
sp_explorer=$((1 << 12))
sp_browser=$((1 << 13))
sp_discord=$((1 << 14))
sp_media=$((1 << 15))
sp_volume=$((1 << 16))
sp_matrix=$((1 << 17))
sp_irc=$((1 << 18))
sp_notes=$((1 << 19))
sp_config=$((1 << 20))
sp_editor=$((1 << 21))
sp_email=$((1 << 22))
sp_auth=$((1 << 23))
sp_monitor=$((1 << 24))

riverctl map normal Super minus toggle-focused-tags $sp_general
riverctl map normal Super+Shift minus toggle-view-tags $sp_general

riverctl map normal Super Grave toggle-focused-tags $sp_terminal
riverctl map normal Super+Shift T toggle-focused-tags $sp_monitor
riverctl map normal Super+Shift Slash toggle-focused-tags $sp_explorer
riverctl map normal Super+Shift F toggle-focused-tags $sp_browser
riverctl map normal Super+Shift D toggle-focused-tags $sp_discord
riverctl map normal Super+Shift W toggle-focused-tags $sp_media
riverctl map normal Super+Shift V toggle-focused-tags $sp_volume
riverctl map normal Super+Shift M toggle-focused-tags $sp_matrix
riverctl map normal Super+Shift I toggle-focused-tags $sp_irc
riverctl map normal Super+Shift N toggle-focused-tags $sp_notes
riverctl map normal Super+Shift C toggle-focused-tags $sp_config
riverctl map normal Super E toggle-focused-tags $sp_editor
riverctl map normal Super+Shift E toggle-focused-tags $sp_email
riverctl map normal Super+Shift A toggle-focused-tags $sp_auth

# meta

# only assign workspace tags to new windows
riverctl spawn-tagmask $(((1 << 11) - 1))

# finalize

rivercarro -inner-gaps 2 -outer-gaps 4 -main-location left -main-count 1 -main-ratio '0.6' -width-ratio '1.0'
