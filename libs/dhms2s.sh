#$Id: dhms2s.sh 1127 2012-08-31 15:39:56Z gab $
function dhms2s {	# day hour min sec to seconds
	# can be specified in any order :
	# 1d1s is the same as 1s1d
	w=$1
	echo "$w" | sed -e 's/\([0-9]*\)d/\1*86400 + /' -e 's/\([0-9]*\)h/\1*3600 + /' -e 's/\([0-9]*\)min/\1*60 + /' -e 's/\([0-9]*\)s/\1 + /' -e 's/+ $//' -e 's/$/+0/'| bc
}
