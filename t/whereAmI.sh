#!/usr/bin/env bash
source $(cd $(dirname "$0") ; pwd)/bootstrap.sh
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
source $(cd $(dirname "$0") ; pwd)/footer.sh
