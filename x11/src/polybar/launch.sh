#! /usr/bin/env zsh

alias syscat=systemd-cat

function psyscat() {
	syscat -t "polybar::launch" $@
}

function plog() {
	echo $@
}

plog "-- $(date) --"

cfg_dir=${XDG_CONFIG_HOME:-$HOME/.config}/polybar
plog "checking config dir: $cfg_dir"
test -d $cfg_dir || (plog "config dir not found"; exit 1)

plog "ending running polybars..."
psyscat polybar-msg cmd quit; psyscat killall -e polybar

plog "launching bars..."
for bar in $(basename -s .ini $cfg_dir/bars.d/*.ini); do
	plog "starting polybar: $bar"
	syscat -t "polybar::$bar" polybar -cr $cfg_dir/config.ini $bar &
done
