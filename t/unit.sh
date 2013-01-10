#!/usr/bin/env bash
# $Id: unit.sh 1153 2012-12-12 15:31:33Z gab $
. ../libkoca.sh
# assert <message> <valeur voulue> <valeur retournée>
export lock=/tmp/$$
conf=/tmp/test.cfg
TMPDIR=${TMPDIR:=/tmp}
oneTimeSetUp() {
	echo 'global.ssh=plop' > $conf
}
testCleanStacking() {
	#o=$(trap -p 0)
	trap 0
	cleanOnExit $$
	cleanOnExit $$
	t=`trap -p 0`
	assertEquals 'Bad stacking' "trap -- ' rm -f $$ ; rm -f $$' EXIT" "$t"
	#trap "$o" 0
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
	source $(cd $(dirname "$0") ; pwd)/../libkoca.sh
	lockMe /tmp/p$$
	sleep 3
	EOF
	chmod +x $fn
	$fn > /dev/null &
	bash $fn | grep -q 'instance is running'
	assertTrue "An instance was not detected, whereas is should be, even if shell seems different (bash vs /bin/bash)" $?
	rm -f $fn
}
oneTimeTearDown() {
	unlockMe $lock
	trap 0
	rm -f $conf
}
testDoAndLogWhenExecOk() {
	mess=`doAndLog 'plop' 'echo -n 1'`
	assertEquals 'plop1 ..' "$mess"
}
testDoAndLogWhenExecNOk() {
	tmp=`mktemp`
	rm -f $tmp
	mess=`doAndLog 'plop' "rm $tmp" 2>/dev/null`
	assertEquals 'plop !!' "$mess"
}
testUnderTestIsTrueRanUnderTestShell() {
	underTest test.sh
	assertTrue "Should return true : I'm test.sh" $?
}
testUnderTestIsFalse() {
	underTest plop
	assertFalse "Should return false : I'm not under tests" "$?"
}
testWhereIsIsFalseIfFileNotFound() {
	whereIs plop
	assertFalse 'File plop should not have been found' "$?"
}
testWhereIsIsTrueIfFileIsInPath() {
	w=`whereIs ls`
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
	val=` whereIs bash`
	w=`echo $val | wc -l`
	assertEquals "whereIs returned more than one line" "1" "$w"
}
#####
testGetconfReturnCorrectValues() {
	val=$(getConfValue global ssh)
	ret=$?
	assertEquals "getConfValue doesn't return value" 'plop' "$val"
	assertTrue "getConfValue doesn't return true" "$ret"
}
testGetconfReturnFalseonUnfoundConfFile() {
	val=$(conf=/etc/gna getConfValue plop plop 2>&1)
	ret=$?
	assertFalse "getConfValue doesn't return false ($ret)" "$ret"
	assertEquals "getConfValue doesn't return 1 (was $ret)" "1" "$ret"
}
testGetconfReturnFalseOnNotReadableConfFile() {
	echo 'plop.gna=1' > $conf
	chmod a-r $conf
	val=$(getConfValue plop gna 2>/dev/null)
	ret=$?
	# root peut tour lire ...
	[ "$(id -u)" -eq "0" ] && ret=1
	assertFalse "getConfValue doesn't return false ($ret)" "$ret"
	rm -f $conf
}
testGetconfReturn2onUnfoundEntry() {
	touch $conf
	val=$(getConfValue plop plop)
	ret=$?
	assertFalse "getConfValue doesn't return false (was $ret)" "$ret"
	assertEquals "getConfValue doesn't return 2 (was $ret)" "2" "$ret"
}
testGetconfReturn2onCommentedEntry() {
	echo '#com.plop=gna' >> $conf
	val=$(getConfValue com ssh)
	ret=$?
	assertEquals "getConfValue doesn't return 2 (was $ret)" "2" "$ret"
}
testGetconfReturnCorrectValuesWhenDoubleEquals() {
	echo 'com.sshdouble=plop=gna' > $conf
	val=$(getConfValue com sshdouble)
	ret=$?
	assertEquals "getConfValue doesn't return correct value " "plop=gna" "$val"
}
testGetconfReturnCorrectValuesWhenTripleEquals() {
	echo 'com.sshdouble=plop=gna=bou' >> $conf
	val=$(getConfValue com sshdouble)
	ret=$?
	assertEquals "getConfValue doesn't return correct value " "plop=gna=bou" "$val"
}
testGetconfCorrectlyHandleSpaces() {
	echo 'com.sshspace = plop = gna' > $conf
	val=$(getConfValue com sshspace)
	ret=$?
	assertEquals "getConfValue doesn't return correct value $val " "plop = gna" "$val"
}
testGetconfReturneLastKeyOnDoubleKeys() {
	echo 'com.sshdouble=plop=one' > $conf
	val=$(getConfValue com sshdouble)
	ret=$?
	assertEquals "getConfValue doesn't return correct value $val" "plop=one" "$val"
}
testGetconfReturnFalseIfConfVarNotProvided() {
	#export conf=''
	val=$(conf="" getConfValue plop gna 2>/dev/null)
	ret=$?
	assertEquals "getConfValue should return 1" "1" "$ret"
}
testGetconfReturnFalseIfConfFileDoesntExists() {
	#export conf=$RANDOM
	val=$(conf=$RANDOM getConfValue plop gna 2>/dev/null)
	ret=$?
	assertEquals "getConfValue should return 1" "1" "$ret"
}
testGetconfReturnOneResultOnAmbiguousRequest() {
	echo 'com.ssh1=one' > $conf
	echo 'com.ssh2=one' >> $conf
	val=$(getConfValue com ssh)
	ret=$?
	assertFalse "getConfValue should return false" "$ret"
	rm -f $conf
}
testGetconfReturnAllTheIndexOfASection() {
	echo 'com.ssh1=one' > $conf
	echo 'com.ssh2=one' >> $conf
	echo 'com.ssh3=one' >> /tmp/1
	val=$(conf="$conf /tmp/1" getConfAllKeys com)
	ret=$?
	assertEquals "Not all values have been returned" "ssh1 ssh2 ssh3" "$val"
	rm -f /tmp/1
}
testGetconfReturnAllTheSections() {
	echo 'com1.ssh1=one' > $conf
	echo 'com2.ssh2=one' >> $conf
	echo 'com1.ssh2=*' >> $conf
	echo 'com3.ssh2=*' >> /tmp/1
	echo '# toupidou.plop=one' >> $conf
	echo ' # toupidou.plop=one' >> $conf
	echo '  # toupidou.plop=one' >> $conf
	sections=`conf="$conf /tmp/1" getConfAllSections`
	ret=$?
	assertEquals "Not all sections have been returned" "com1 com2 com3" "$sections"
	rm -f /tmp/1
}
testGetconfCorrectlyHandleStars() {
	echo 'a.b=*' > $conf
	v=$(getConfValue a b)
	ret=$?
	assertEquals "Wrong handling of stars" '*' "$v"
	rm -f $conf
}
testGetconfCorrectlyHandleThirdParameter() {
	echo 'a.b=2' > $conf
	v=$(conf=$conf getConfValue a c 1)
	ret=$?
	assertEquals "Do not correctly handle third parameter" '1' "$v"
	rm -f $conf
}
######
testGetColorReturn1onBadNumberOfArgument() {
	getColor plop 2>/dev/null ; r=$?
	assertEquals "getColor should return 1" "1" "$r"
}
testLibkocaExitWith0WhenRan() {
	bash ../libkoca.sh >/dev/null ; r=$?
	assertTrue "libkoca didn't return true" "$r"
}
testLibkocaDoesntImportAnythingWhenRan() {
	unset lockMe
	bash ../libkoca.sh >/dev/null
	type -t lockMe >/dev/null ; r=$?
	assertFalse "libkoca export something when run" "$r"
}
testLibkocaExportWantedFunctionWhenRan() {
	unset lockMe
	eval "`bash ../libkoca.sh lockMe`" >/dev/null
	r=`type -t lockMe`
	assertEquals "libkoca didn't export me the function I want" "function" "$r"
}
testLibkocaExportMoreThanOneFunction() {
	unset lockMe cleanOnExit
	eval "`bash ../libkoca.sh lockMe cleanOnExit`" >/dev/null
	type -t lockMe >/dev/null ; r1=$?
	type -t cleanOnExit >/dev/null ; r2=$?
	[ $r1 -eq 0 -a $r2 -eq 0 ] ; r=$?
	assertTrue "libkoca didn't export me the 2 functions I want" "$r"
}
testWhereAmI() {
	cd $(dirname "$0")
	a$(`pwd)
	b=$(whereAmI)
	assertEquals "whereAmI doesn't know where I am" "$b" "$a"
}
# non testé :
# late linking (flemme)
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
tests2dhms()  {
	d=$(s2dhms 60)
	assertEquals "Seconds badly parsed" "1min" "$d"
	d=$(s2dhms 59)
	assertEquals "Seconds badly parsed" "59s" "$d"
	d=$(s2dhms 3600)
	assertEquals "Seconds badly parsed" "1h" "$d"
	d=$(s2dhms 86400)
	assertEquals "Seconds badly parsed" "1d" "$d"
	d=$(s2dhms 86401)
	assertEquals "Seconds badly parsed" "1d1s" "$d"
	d=$(s2dhms 86461)
	assertEquals "Seconds badly parsed" "1d1min1s" "$d"
	d=$(s2dhms 90061)
	assertEquals "Seconds badly parsed" "1d1h1min1s" "$d"
	d=$(s2dhms 3661)
	assertEquals "Seconds badly parsed" "1h1min1s" "$d"
	d=$(s2dhms 61)
	assertEquals "Seconds badly parsed" "1min1s" "$d"
}
testdhms2s() {
	d=$(dhms2s 1d)
	assertEquals "dhms badly parsed" "86400" "$d"
	d=$(dhms2s 1h)
	assertEquals "dhms badly parsed" "3600" "$d"
	d=$(dhms2s 1min)
	assertEquals "dhms badly parsed" "60" "$d"
	d=$(dhms2s 1d1s)
	assertEquals "dhms badly parsed" "86401" "$d"
	d=$(dhms2s 1d1min1s)
	assertEquals "dhms badly parsed" "86461" "$d"
	d=$(dhms2s 1d1h1min1s)
	assertEquals "dhms badly parsed" "90061" "$d"
	d=$(dhms2s 1min1s)
	assertEquals "dhms badly parsed" "61" "$d"
	d=$(dhms2s 1h1min1s)
	assertEquals "dhms badly parsed" "3661" "$d"
	d=$(dhms2s 1s1min)
	# trop intelligent, mon script !
	assertEquals "dhms badly parsed" "61" "$d"
	d=$(dhms2s 1s1d)
	assertEquals "dhms badly parsed" "86401" "$d"
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
