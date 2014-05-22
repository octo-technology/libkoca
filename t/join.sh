#!/usr/bin/env bash
# $Id: isIp.sh 1153 2012-12-12 15:31:33Z gab $
source $(cd $(dirname "$0") ; pwd)/bootstrap.sh
testJoin() {
	j=$(echo -e "a\nb"| koca_join ',') ; assertEquals "a,b" "$j"
	j=$(echo -e "a\nb"| koca_join ';') ; assertEquals "a;b" "$j"
}
source $(cd $(dirname "$0") ; pwd)/footer.sh
