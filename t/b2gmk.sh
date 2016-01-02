#!/usr/bin/env bash
source $(cd $(dirname "$0") ; pwd)/bootstrap.sh
testB2K() {
	assertEquals 1.0ko $(koca_b2gmk 1024)
	assertEquals 1.9ko $(koca_b2gmk $(echo 1024*2-1|bc))
	assertEquals 500.0ko $(koca_b2gmk $(echo 500*1024|bc))
	assertEquals 1.0Mo $(koca_b2gmk $(echo 1024^2|bc))
	assertEquals 1.0Mo $(koca_b2gmk $(echo 1024^2+1|bc))
	assertEquals 1.5Mo $(koca_b2gmk $(echo 1024^2+512*1024|bc))
	assertEquals 500.0Mo $(koca_b2gmk $(echo 500*1024^2|bc))
	assertEquals 1.0Go $(koca_b2gmk $(echo 1024^3|bc))
	assertEquals 500.0Go $(koca_b2gmk $(echo 500*1024^3|bc))
	assertEquals 1.0To $(koca_b2gmk $(echo 1024^4|bc))
	assertEquals 500.0To $(koca_b2gmk $(echo 500*1024^4|bc))
	assertEquals 1.0Po $(koca_b2gmk $(echo 1024^5|bc))
	assertEquals 500.0Po $(koca_b2gmk $(echo 500*1024^5|bc))
	assertEquals 1.0Po $(koca_b2gmk $(echo 1024^5+1024^3|bc))
	assertEquals 100 $(koca_b2gmk 100)
	assertEquals 300 $(koca_b2gmk 300)
	assertEquals 1.0ko $(koca_b2gmk 1025)
	assertEquals 0 $(koca_b2gmk 0)
}
source $(cd $(dirname "$0") ; pwd)/footer.sh
