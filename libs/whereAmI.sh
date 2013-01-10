#$Id: whereAmI.sh 1161 2013-01-03 10:28:56Z gab $
function whereAmI {
	pushd . >/dev/null
	cd $(dirname "$0")
	pwd
	popd > /dev/null
}
