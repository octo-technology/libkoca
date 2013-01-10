#$Id: checkNeededFiles.sh 1163 2013-01-08 10:05:12Z gab $
# Check wether specified file can be found, and warn according it's a MAY or a MUST
# checkNeededFiles may [ file [ file [ ... ] ]
# checkNeededFiles must [ file [ file [ ... ] ]
function checkNeededFiles {
	_ec=0
	while [ -n "$1" ]
	do
		case $1 in
			may)
				type=may
				;;
			must)
				type=must
				;;
			*)
				if ! which "$1" >/dev/null 2>&1
				then
					[ "$type" = "may" ] && echo "[__libname__] '$1' not found. Bad things may happen" >&2 && _ec=1
					[ "$type" = "must" ] && echo "[__libname__] '$1' not found. Bad things WILL happen" >&2 && _ec=2
				fi
				;;
		esac
		shift
	done
	return $_ec
}
