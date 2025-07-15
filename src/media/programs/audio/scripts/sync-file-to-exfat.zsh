#! /usr/bin/env zsh

set -e

SCRIPT_DIR=$(dirname "$(realpath $0)")

sanitizePath="$SCRIPT_DIR/sanitize-path.nu"

sanitizedBaseName=$($sanitizePath "$3" --relative-to $1)
sanitized="$2/$sanitizedBaseName"
sanitizedDir=$(dirname $sanitized)

if [[ -f "$sanitized" ]]; then
	echo "Skipping $sanitized"
	return 0
fi

extension=$(echo $3 | rev | cut -f 2- -d '.' --complement | rev)
if [[ "$extension" != "flac" ]]; then
	mkdir -p $sanitizedDir \
		&& cp $3 $sanitized
	return 0
fi

sanitizedFilename=$(basename $sanitized | rev | cut -f 2- -d '.' | rev)

tmpfile=$(mktemp XXXXXXXXX.ogg)
dstPath="$sanitizedDir/$sanitizedFilename.ogg"

mkdir -p $sanitizedDir \
	&& opusenc --music $3 $tmpfile \
	&& cp $tmpfile $dstPath \
	; rm $tmpfile
