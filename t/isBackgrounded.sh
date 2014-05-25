#!/usr/bin/env bash
# $Id: isIp.sh 1153 2012-12-12 15:31:33Z gab $
source $(cd $(dirname "$0") ; pwd)/bootstrap.sh
testIsBack() {
	koca_isBackgrounded ; r=$?
	assertFalse "Should not be backgrounded" "$r"
}
source $(cd $(dirname "$0") ; pwd)/footer.sh
