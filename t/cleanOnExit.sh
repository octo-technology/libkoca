#!/usr/bin/env bash
# $Id: cleanOnExit.sh 1128 2012-08-31 15:44:45Z gab $
source $(cd $(dirname "$0") ; pwd)/bootstrap.sh
# assert <message> <valeur voulue> <valeur retournée>
export lock=/tmp/$$
conf=/tmp/test.cfg
TMPDIR=${TMPDIR:=/tmp}
testCleanStacking() {
	#o=$(trap -p 0)
	trap 0
	cleanOnExit $$
	cleanOnExit $$
	t=$(trap -p 0)
	assertEquals 'Bad stacking' "trap -- ' rm -f $$ ; rm -f $$' EXIT" "$t"
	#trap "$o" 0
}
if [ -e /usr/share/shunit2/shunit2 ]
then
	. /usr/share/shunit2/shunit2
elif [ -e shunit2 ]
then
    . shunit2
else
	echo '* shunit2 not found. No tests performed'
	exit 0
fi