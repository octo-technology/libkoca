# Return true is the name of the script is test.sh (which should be the name of the test's script
# run the script under
# Return false if not
# usage : underTest <fileName>
# Ideally filename should be `basename $0`, unless you want to do something weird (like testing the function itself)
function underTest {
	local me=$1
	if [  "$me"  == "test.sh" ]
	then
		true
	else
		false
	fi
}
