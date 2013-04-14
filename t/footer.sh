#!/usr/bin/env bash
# $Id: getConf.sh 1149 2012-12-10 02:52:45Z gab $
for s in /usr/share/shunit2/shunit2 /usr/bin/shunit2
do
	[ -e "$s" ] && source "$s"
done
if [ -z "$SHUNIT_VERSION" ]
then
	echo '* shunit2 not found. No tests performed'
	exit 0
fi
