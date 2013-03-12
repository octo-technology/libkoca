# Search a given file in path. If not found, search in common locations
# return true and the full path if found
# else return false
function whereIs {
	local w=$(type -p "$1")
	[ -n "$w" ] && echo $w && return 0
	[ -e "$1" ] && echo $1 && return 0
	for path in /bin /sbin /usr/bin /usr/sbin /usr/local/bin /usr/local/sbin /usr/libexec /usr/local/libexec
	do
		[ -e "$path/$1" ] && echo "$path/$1" && return 0
	done
	false
}
