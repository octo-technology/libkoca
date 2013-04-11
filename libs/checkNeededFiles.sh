# Check wether specified file can be found, warn or exit according it's a MAY or a MUST
# And initialiaze the variable with the path of the correspondant file
# checkNeededFiles may [ file [ file [ ... ] ]
# checkNeededFiles must [ file [ file [ ... ] ]
# Example : checkNeededFiles may bash
# > echo $bash
# > /bin/bash
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
					eval export $1="'echo $1'"
                else
                    eval export $1=$(which "$1")
				fi
				;;
		esac
		shift
	done
	return $_ec
}
