#!/usr/bin/env bash
# $Id: fclone.sh 1128 2012-08-31 15:44:45Z gab $
source $(cd $(dirname "$0") ; pwd)/bootstrap.sh
testLogRetrunCode1IfVerbosityIsNotAnInt() {
	koca_log d "plop" ; _e=$?
	assertEquals 1 $_e
}
testLogRespectVerbosity() {
	export KOCA_LOG_MAX_VERBOSITY=1
	assertEquals "plop" "$(koca_log 0 "plop")"
	assertEquals "plop" "$(koca_log 1 "plop")"
	assertEquals "" "$(koca_log 2 "plop")"
}
source $(cd $(dirname "$0") ; pwd)/footer.sh
