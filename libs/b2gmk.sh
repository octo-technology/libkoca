function koca_b2gmk {	# seconds to day hour min sec
	w=$1
	[ -z "$w" ] && read w

	pw=$(echo "scale=1;$w/1125899906842624" | bc)
	[ "$pw" != "0" ] && echo "${pw}Po" && return
	w=$(echo "scale=0;$w%1125899906842624" | bc)

	tw=$(echo "scale=1;$w/1099511627776" | bc)
	[ "$tw" != "0" ] && echo "${tw}To" && return
	w=$(echo "scale=0;$w%1099511627776" | bc)

	gw=$(echo "scale=1;$w/1073741824" | bc)
	[ "$gw" != "0" ] && echo "${gw}Go" && return 
	w=$(echo "scale=0;$w%1073741824" | bc)

	mw=$(echo "scale=1;$w/1048576" | bc)
	[ "$mw" != "0" ] && echo "${mw}Mo" && return
	w=$(echo "scale=0;$w%1048576" | bc)

	kw=$(echo "scale=1;$w/1024" | bc)
	[ "$kw" != "0" ] && echo "${kw}ko" && return
	w=$(echo "scale=0;$w%1024" | bc)

	echo "${w}"
}
