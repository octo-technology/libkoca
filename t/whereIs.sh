#!/usr/bin/env bash
source $(cd $(dirname "$0") ; pwd)/bootstrap.sh
testWhereIsIsFalseIfFileNotFound() {
	whereIs plop
	assertFalse 'File plop should not have been found' "$?"
}
testWhereIsIsTrueIfFileIsInPath() {
	w=$(whereIs ls)
	assertTrue 'File ls should have been found' "$?"
}
testWhereIsIsTrueIfFileIsNotInPath() {
	p=$PATH
	PATH='/usr/bin'
	w=`whereIs ls`
	assertTrue 'File ls should have been found, even if not in path' "$?"
	PATH=$p
}
testWhereIsReturnOnlyOneLine() {
	val=$(whereIs bash)
	w=$(echo $val | wc -l)
	assertEquals "whereIs returned more than one line" "1" "$w"
}
testWhereIsReturnFileWhenAbsolutePathIsGiven() {
	t=/tmp/$$
	touch $t
	val=$(whereIs $t)
	assertEquals "whereIs did not return true despite absolute path was given" "$t" "$val"
	rm -f $t
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
