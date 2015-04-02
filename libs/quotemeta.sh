function koca_quotemeta { # Escape meta character
	local s="$1"
	# Is it cheating ?
	echo "$s" | perl  '-ple$_=quotemeta'
}
