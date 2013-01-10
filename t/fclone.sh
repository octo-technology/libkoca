#!/usr/bin/env bash
# $Id: fclone.sh 1128 2012-08-31 15:44:45Z gab $
source $(cd $(dirname "$0") ; pwd)/bootstrap.sh
testFCloneIsActuallyCloning() {
	function bou() {
	echo 'a'
	}
	fclone bou plop '# zoubida'
	r=$(plop)
	assertEquals "fclone doesn't clone" "a" "$r"
	assertEquals "fclone doesn't handle comments" "plop # zoubida" "$falias"
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
