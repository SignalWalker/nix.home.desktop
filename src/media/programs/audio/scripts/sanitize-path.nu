#! /usr/bin/env nu

let CHARMAP = {
	# unsupported by exfat
	':': '-',
	'\': '-',
	'/': '-',
	'*': '_',
	'?': '_',
	'"': '_',
	'<': '_',
	'>': '_',
	# path length
	' ': '',
	# compat
	`'`: '_',
	# paranoia
	';': '-',
	'&': '_',
	'$': '_',
	'%': '_'
}

def sanitize-str [] {
	each { |str|
		if $str == '/' {
			$str
		} else {
			$CHARMAP | transpose from to | reduce --fold $str {|rep, acc| $acc | str replace -a -s $rep.from $rep.to}
		}
	}
}

def sanitize-path [inPath: string] {
	$inPath |
	path split |
	sanitize-str |
	path join
}

def main [inPath: string, --relative-to: string] {
	let res = sanitize-path ($inPath | str trim)
	if $relative_to != null {
		$res | path relative-to $relative_to
	} else {
		$res
	}
}
