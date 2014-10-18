#!/usr/bin/env bash
# $Id: checkNeededFiles.sh 1132 2012-09-06 15:00:07Z gab $
source $(cd $(dirname "$0") ; pwd)/bootstrap.sh
testCNF() {
	checkNeededFiles may kbash 2>/dev/null; r=$?
	assertEquals "Should return code 1 on 1 failed may" "1" "$r"
	checkNeededFiles must kbash 2>/dev/null; r=$?
	assertEquals "Should return code 1 on 1 failed must" "1" "$r"
	checkNeededFiles must kbash may bash 2>/dev/null; r=$?
	assertEquals "Should return code 1 on 1 failed must" "1" "$r"
	checkNeededFiles must kbash may bash ls 2>/dev/null; r=$?
	assertEquals "Should return code 1 on 1 failed must and 2 ok may" "1" "$r"
	checkNeededFiles may kbash must bash ls may plop 2>/dev/null; r=$?
	assertEquals "Should return code 2 on 2 failed mixed may and 1 ok must" "2" "$r"
	checkNeededFiles may kbash must kbash may plop 2>/dev/null; r=$?
	assertEquals "Should return code 3 on 3 failed mixed may and must" "3" "$r"
	checkNeededFiles may bash ; r=$?
    assertEquals "Should return the path in the variable" "$(which bash)" "$bash"
	checkNeededFiles may dfghj ; r=$?
    assertEquals "Should return the echo in the variable" "echo dfghj" "$dfghj"
	mess=$(checkNeededFiles -q may dfghj) ; r=$?
    assertEquals "Should return the echo in the variable" "" "$mess"

}
source $(cd $(dirname "$0") ; pwd)/footer.sh
