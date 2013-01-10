# Lib of useful function, for shell addicts
# Inclusions of function depend on wether it as succeeded to shunit or not
# Brought to you under GPL Licence, by Gab

_outdated() {
    local statfile=$HOME/libkoca-outdated/stats
    echo "[__libname__] Please use $2, instead of $1. This will be logged to $statfile"
	mkdir -p $(dirname $statfile)
	echo "$(date -u +%Y%m%d%H%M%SZ) : In $(cd $(dirname "$0") ; pwd)/$(basename $0) : $1 should be replaced by $2" >> $statfile
}
