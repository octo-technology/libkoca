#!/usr/bin/env bash
# $Id: aacore.sh 1128 2012-08-31 15:44:45Z gab $
source $(cd $(dirname "$0") ; pwd)/bootstrap.sh
source $here/../libs/lockMe.sh
testLibkocaExitWith0WhenRan() {
	bash $here/../libs/aacore.sh >/dev/null ; r=$?
	assertTrue "libkoca didn't return true" "$r"
}
testLibkocaDoesntImportAnythingWhenRan() {
	unset koca_lockMe
	bash $here/../libkoca.sh >/dev/null
	type -t koca_lockMe >/dev/null ; r=$?
	assertFalse "libkoca export something when run" "$r"
}
testLibkocaExportWantedFunctionWhenRan() {
	unset koca_lockMe
	eval "$(bash $here/../libkoca.sh koca_lockMe)" >/dev/null
	r=$(type -t koca_lockMe)
	assertEquals "libkoca didn't export me the function I want" "function" "$r"
}
testLibkocaExportMoreThanOneFunction() {
	unset koca_lockMe koca_cleanOnExit
	eval "$(bash $here/../libkoca.sh koca_lockMe koca_cleanOnExit)" >/dev/null
	type -t koca_lockMe >/dev/null ; r1=$?
	type -t koca_cleanOnExit >/dev/null ; r2=$?
	[ $r1 -eq 0 -a $r2 -eq 0 ] ; r=$?
	assertTrue "libkoca didn't export me the 2 functions I want" "$r"
}
source $(cd $(dirname "$0") ; pwd)/footer.sh
