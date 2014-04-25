#!/usr/bin/env bash
# $Id: dhms2s.sh 1128 2012-08-31 15:44:45Z gab $
source $(cd $(dirname "$0") ; pwd)/bootstrap.sh
testdhms2s() {
	d=$(dhms2s 1d)
	assertEquals "dhms badly parsed" "86400" "$d"
	d=$(dhms2s 1h)
	assertEquals "dhms badly parsed" "3600" "$d"
	d=$(dhms2s 1min)
	assertEquals "dhms badly parsed" "60" "$d"
	d=$(dhms2s 1d1s)
	assertEquals "dhms badly parsed" "86401" "$d"
	d=$(dhms2s 1d1min1s)
	assertEquals "dhms badly parsed" "86461" "$d"
	d=$(dhms2s 1d1h1min1s)
	assertEquals "dhms badly parsed" "90061" "$d"
	d=$(dhms2s 1min1s)
	assertEquals "dhms badly parsed" "61" "$d"
	d=$(dhms2s 1h1min1s)
	assertEquals "dhms badly parsed" "3661" "$d"
	d=$(dhms2s 1s1min)
	# trop intelligent, mon script !
	assertEquals "dhms badly parsed" "61" "$d"
	d=$(dhms2s 1s1d)
	assertEquals "dhms badly parsed" "86401" "$d"
	d=$(echo 1s1d | dhms2s)
	assertEquals "dhms doesn't accept dat on standard input" "86401" "$d"
	d=$(dhms2s k)
	assertEquals "dhms doesn't return -1 on bad formatted string" "-1" "$d"

}
source $(cd $(dirname "$0") ; pwd)/footer.sh
