# Display string if first argument is lower than KOCA_LOG_MAX_VERBOSITY
# Eventually can be used to log messages.
# 
# First export KOCA_LOG_MAX_VERBOSITY, which will be the max level of verbosity
# Then use : koca_log <n> message
# If <n> is lower than KOCA_LOG_MAX_VERBOSITY, <message> will be display
function koca_log {
	local pref="(${FUNCNAME[1]}:${BASH_LINENO[0]})"
	if ! [[ $1 =~ [0-9]+ ]]
	then
		return 1
	fi
	if [ $KOCA_LOG_MAX_VERBOSITY -ge $1 ]
	then
		shift
		echo "$*" 
	fi
}
