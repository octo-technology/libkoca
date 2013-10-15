function koca_log()
{
	local pref="(${FUNCNAME[1]}:${BASH_LINENO[0]})"
	if ! [[ $1 =~ [0-9]+ ]]
	then
		return 1
	fi
	if [ $KOCA_LOG_VERBOSITY -ge $1 ]
	then
		shift
		echo "$*" 
	fi
}
