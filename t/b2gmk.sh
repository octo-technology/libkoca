#!/usr/bin/env bash
source $(cd $(dirname "$0") ; pwd)/bootstrap.sh
testB2K() {
	assertEquals 1.0ko $(koca_b2gmk 1024)
	assertEquals 1.9ko $(koca_b2gmk 2047)
	assertEquals 1.0Mo $(koca_b2gmk 1048576)
	assertEquals 1.0Mo $(koca_b2gmk 1048577)
	assertEquals 1.5Mo $(koca_b2gmk 1572864)
	assertEquals 1.0Go $(koca_b2gmk 1073741824)
	assertEquals 1.0To $(koca_b2gmk 1099511627776)
	assertEquals 1.0Po $(koca_b2gmk 1125899906842624)
	assertEquals 1.0Po $(koca_b2gmk 1125899956842624)
	assertEquals 100 $(koca_b2gmk 100)
	assertEquals 0 $(koca_b2gmk 0)
}
source $(cd $(dirname "$0") ; pwd)/footer.sh
