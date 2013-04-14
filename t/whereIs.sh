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
source $(cd $(dirname "$0") ; pwd)/footer.sh
