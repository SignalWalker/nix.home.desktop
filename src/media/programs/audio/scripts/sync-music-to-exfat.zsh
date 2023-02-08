#! /usr/bin/env zsh

SCRIPT_DIR=$(dirname "$(realpath $0)")

sanitizePath="$SCRIPT_DIR/sanitize-path.nu"
syncFileToExfat="$SCRIPT_DIR/sync-file-to-exfat.zsh"

echo $SCRIPT_DIR
echo $sanitizePath
echo $syncFileToExfat

fd '.' $1 -t f | parallel --bar --halt now,fail=1 \
	"$syncFileToExfat $1 $2 {}"
