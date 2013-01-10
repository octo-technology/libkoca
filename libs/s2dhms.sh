function s2dhms {	# seconds to day hour min sec
	w=$1
	dw=$(echo "$w/86400" | bc)   # Day Warning
	sdw=$([ $dw -ne 0 ] && echo "${dw}d")    # String Day Warning
	w=$(echo "$w%86400" | bc)
	hw=$(echo "$w/3600" | bc)
	shw=$([ $hw -ne 0 ] && echo "${hw}h")
	w=$(echo "$w%3600" | bc)
	mw=$(echo "$w/60" | bc)
	smw=$([ $mw -ne 0 ] && echo "${mw}min")
	# smw=`[ $mw -ne 0 ] && echo "${mw}min")
	w=$(echo "$w%60" | bc)
	sw=$([ $w -ne 0 ] && echo "${w}s")
	tot=${sdw}${shw}${smw}${sw}
	if [ -z "$tot" ]
	then
		echo 0s
	else
		echo $tot
	fi
}
