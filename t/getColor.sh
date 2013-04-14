#!/usr/bin/env bash
# $Id: getColor.sh 1164 2013-01-08 10:15:48Z gab $
source $(cd $(dirname "$0") ; pwd)/bootstrap.sh
testGetColorReturn1onBadNumberOfArgument() {
	getColor plop 2>/dev/null ; r=$?
	assertEquals "getColor should return 1" "1" "$r"
}
testGetColorReturnACode() {
	unset a
	allcolors=$(getColor list| grep '#' | cut -d ' ' -f 2)
	#local code=$(tput el1)$(tput cr)
	local r=$(tput sgr0)
	for c in $allcolors
	do
		getColor a $c
		echo -n "$code$a$c$r "
		assertNotEquals "GetColor $c returned an empty string" "" "$a"
	done
	echo $(tput sgr0)
}
testGetColorReturnAugmentedVar() {
	a=a
	getColor a+ red
	b=$"$(tput setaf 1)"
	assertEquals "GetColor failed to return previous variable" "a$b" "$a"
}
testGetColorReturnClearedVar() {
	a=a
	getColor a red
	b=$"$(tput setaf 1)"
	assertEquals "GetColor failed to return clean variable" "$b" "$a"
}
testGetColorReturnAugmentedVarDoubleColored() {
	a=a
	getColor a+ red reset
	b=$"$(tput setaf 1)$(echo -e "\033[0m")"
	assertEquals "GetColor failed to return previous variable double colored" "a$b" "$a"
}
testGetColorReturnCleanVarDoubleColored() {
	a=a
	getColor a red reset
	b=$"$(tput setaf 1)"$(echo -e "\033[0m")
	assertEquals "GetColor failed to return a clean variable when double colored " "$b" "$a"
}
testGetColorWorksEvenIfItsC() {
	getColor c red
	b=$"$(tput setaf 1)"
	assertEquals "Bad code returned" "$b" "$c"
}
source $(cd $(dirname "$0") ; pwd)/footer.sh
