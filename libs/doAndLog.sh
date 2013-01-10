# Do something, and print if it has been well terminated
# Usage: doAndLog <message> <command line>
# Command line should be enclosed by '
function doAndLog {
	echo -n $1
	eval "$2"
	if [ $? -eq 0 ]
	then
		echo ' ..'
	else
		echo ' !!'
	fi
}
# Return true is the name of the script is test.sh (which should be the name of the test's script
# run the script under
# Return false if not
# usage : underTest <fileName>
# Ideally filename should be `basename $0`, unless you want to do something weird (like testing the function itself)
