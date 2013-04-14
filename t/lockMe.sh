#!/usr/bin/env bash
# $Id: lockMe.sh 1128 2012-08-31 15:44:45Z gab $
source $(cd $(dirname "$0") ; pwd)/bootstrap.sh
source $here/../libs/cleanOnExit.sh
# assert <message> <valeur voulue> <valeur retournée>
export lock=/tmp/$$
conf=/tmp/test.cfg
TMPDIR=${TMPDIR:=/tmp}
oneTimeSetUp() {
	echo 'global.ssh=plop' > $conf
}
testLocking() {
	lockMe $lock
	set +x
	assertTrue 'Lock failed' "$?"
	unlockMe "$lock"
}
testLockDetecting() {
	lockMe $lock
	isLocked $lock
	assertTrue 'Lock is not here. It should be' "$?"
	mv $lock $lock$$
	isLocked $lock
	assertFalse "Unlock is here. It shouldn't" "$?"
	mv $lock$$ $lock
}
testLockRemoving() {
	unlockMe $lock
	assertTrue 'Lock is not removed' "$?"
}
testLockMeWithMultipleTrap0() {
	trap -p 0 > /tmp/trap$$
	trap "echo ${FUNCNAME[0]}" 0
	lockMe $lock
	t=$(trap -p 0)
	assertEquals 'Trap was not replaced' "trap -- 'echo ${FUNCNAME[0]} ; rm -f $lock' EXIT" "$t"
	unlockMe $lock
	eval $(cat /tmp/trap$$)
	rm -f /tmp/trap$$
}
testLockMeRemoveEmptyLock() {
	touch "$lock"
	lockMe "$lock" 1 ; r=$?
	assertTrue 'Failed to lock if previous lock file is empty' "[ -e $lock ]"
	unlockMe "$lock"
}
testLockMeSilence() {
	lockMe "$lock"
	s="$(lockMe -q "$lock" 1)"
	assertEquals 'lockMe is not quiet' "" "$s"
	unlockMe $lock
}
testLockMeVerbose() {
	lockMe $lock
	s="$(lockMe $lock 1)"
	assertNotEquals 'lockMe is too quiet' "" "$s"
	unlockMe $lock
}
testLockMeExitImmediatelyIfTimeoutIs0() {
	lockMe $lock
	d1=$(date +%s)
	$(lockMe -q $lock 0)
	d2=$(date +%s)
	delta=$(echo $d2 - $d1 | bc )
	assertTrue "lockMe didn't return immediately" "[ $delta -le 1 ]"
	unlockMe $lock
}
testDetectLockWhenShellIsNotAnAbsolutePath() {
	local fn=$TMPDIR/plop$$
	cat <<- EOF > $fn
	#!/bin/bash
	source $(cd $(dirname "$0") ; pwd)/../libs/lockMe.sh
	source $(cd $(dirname "$0") ; pwd)/../libs/cleanOnExit.sh
	lockMe /tmp/.pid
	sleep 3
	rm -f \$0
	EOF
	chmod +x $fn
	$fn > /dev/null &
	bash $fn | grep 'instance is running'
	#assertTrue "An instance was not detected, whereas is should be, even if shell seems different (bash vs /bin/bash)" $?
	rm -f $fn
}
oneTimeTearDown() {
	unlockMe $lock
	trap 0
	rm -f $conf
}
source $(cd $(dirname "$0") ; pwd)/footer.sh
