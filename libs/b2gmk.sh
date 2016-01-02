function koca_b2gmk {	# seconds to day hour min sec
	w=$1
	[ -z "$w" ] && read w
	symbols=(o ko Mo Go To Po ) # Eo, Zo and Yo are too big. 'o' is never used ;)
	for i in $(seq 0 ${#symbols[*]})
	do
		values[$i]=$(echo 1024^$i|bc)
	done
	for i in $(seq ${#symbols[*]} -1 0)
	do
		if [ $w -ge ${values[$i]} ]
		then
			pw=$(echo "scale=1;$w/${values[$i]}" | bc)
			[ "$pw" != "0" ] && echo "${pw}${symbols[$i]}" && return
		fi
		w=$(echo "scale=0;$w%${values[$i]}" | bc)
	done

	echo "${w}"
}
