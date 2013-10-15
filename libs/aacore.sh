# Lib of useful function, for shell addicts
# Inclusions of function depend on wether it as succeeded to shunit or not
# Brought to you under GPL Licence, by Gab

_outdated() {
    eval alias $1="\"echo '[__libname__] Please use koca_$1, instead of $1'; koca_$1\""
}
