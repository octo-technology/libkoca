#!/usr/bin/env bash
# $Id: underTest.sh 1128 2012-08-31 15:44:45Z gab $
source $(cd $(dirname "$0") ; pwd)/bootstrap.sh
testUnderTestIsTrueRanUnderTestShell() {
	underTest test.sh
	assertTrue "Should return true : I'm test.sh" $?
}
testUnderTestIsFalse() {
	underTest plop
	assertFalse "Should return false : I'm not under tests" "$?"
}
source $(cd $(dirname "$0") ; pwd)/footer.sh
