#!/usr/bin/env bash
# $Id: doAndLog.sh 1128 2012-08-31 15:44:45Z gab $
source $(cd $(dirname "$0") ; pwd)/bootstrap.sh
testDoAndLogWhenExecOk() {
	mess=$(doAndLog 'plop' 'echo -n 1')
	assertEquals 'plop1 ..' "$mess"
}
testDoAndLogWhenExecNOk() {
	tmp=$(mktemp)
	rm -f $tmp
	mess=$(doAndLog 'plop' "rm $tmp" 2>/dev/null)
	assertEquals 'plop !!' "$mess"
}
source $(cd $(dirname "$0") ; pwd)/footer.sh
