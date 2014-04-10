#!/usr/bin/env bash
# $Id: isIp.sh 1153 2012-12-12 15:31:33Z gab $
source $(cd $(dirname "$0") ; pwd)/bootstrap.sh
testIsNum() {
	for n in 1 01 1.3 01.0 
	do
		isNumeric $n ; r=$?
		assertTrue "$n is not numeric" "$r"
	done
	for n in 1,2 j
	do
		isNumeric $n ; r=$?
		assertFalse "$n is not numeric" "$r"
	done
}
source $(cd $(dirname "$0") ; pwd)/footer.sh
