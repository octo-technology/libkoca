#!/usr/bin/env bash
# $Id: isIp.sh 1153 2012-12-12 15:31:33Z gab $
source $(cd $(dirname "$0") ; pwd)/bootstrap.sh
testisIp() {
	for ip in 1.2.3.4 001.2.3.004 255.255.255.255 fe80::20c:6eff:feca:45a4 ::1 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
	do
		isIp $ip ; r=$?
		assertTrue "$ip is not an ip" "$r"
	done
	for ip in 1 1.2 1.2.3 1.2.3.4.5 1111.1.1.1 1.1111.1.1111 300.2.3.4 001.256.2.3 plop fe80::20c:6eff:feca:45g4
	do
		isIp $ip ; r=$?
		assertFalse "$ip is not an ip" "$r"
	done
}
source $(cd $(dirname "$0") ; pwd)/footer.sh
