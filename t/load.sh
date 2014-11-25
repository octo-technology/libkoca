#!/usr/bin/env bash
source $(cd $(dirname "$0") ; pwd)/bootstrap.sh
testload() {
	koca_load a 2>/dev/null ; r=$?
	assertEquals "Load accepts non int/float" "2" "$r"
	koca_load 10 ;r=$?
	assertTrue "Load is less than 10" "$r"
	koca_load -1 ;r=$?
	assertFalse "Load is less than 0" "$r"
}
source $(cd $(dirname "$0") ; pwd)/footer.sh
