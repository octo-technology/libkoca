#!/usr/bin/env bash
# $Id: getConf.sh 1149 2012-12-10 02:52:45Z gab $
source $(cd $(dirname "$0") ; pwd)/bootstrap.sh
# assert <message> <valeur voulue> <valeur retournée>
conf=/tmp/test.cfg
TMPDIR=${TMPDIR:=/tmp}
oneTimeSetUp() {
	echo 'global.ssh=plop' > $conf
}
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
testGetconfReturnAllSectionsOfProvidedKey() {
	echo 's1.k=1' >$conf
	echo 's2.k=2' >>$conf
	echo 's3.kk=2' >>$conf
	echo 's4.a-k=2' >>$conf
	v=$(conf=$conf getConfAllSections k)
	assertEquals "Ploup" 's1 s2' "$v"
	v=$(conf=$conf getConfAllSections k kk)
	assertEquals "Ploup" 's1 s2 s3' "$v"
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
