#$Id: zzfooter.sh 1165 2013-01-08 11:09:52Z gab $
# Parenthese guarantee that my variables won't pollute the calling shell

(

me=$(basename -- "$0")
# __libname__ will be replaced by the filename
libname='__libname__'
# exit if I'am sourced from a shell
[ "$me" == "$libname" ] || exit 0
here=$(cd $(dirname "$0") ; pwd)
# full path to me
fp2me=${here}/$me
if [ $# -eq 0 ]
then
    echo "$me "'$Rev: 1122 $'
    echo "Librairy of useful functions to import in a shell script"
    echo
    echo "Import all the functions :"
    echo " $ . $me"
    echo "List all the functions that can be imported :"
    echo " $ $me list"
    echo "Import only some functions :"
	echo " $ eval \"\$(sh $me function [ function [ ... ] ])\""
    exit
fi
[ "$1" == "list" ] && grep -E '^function' $0 | sed -e 's/function *//' -e 's/{\(\)//g' && exit
[ "$1" == "version" ] && echo "$(echo '$Id: zzfooter.sh 1165 2013-01-08 11:09:52Z gab $' | awk '{print $3}')" && exit
while [ "$1" != "" ]
do
	# Print code of the function
	# plus linking
	[ "$(type -t $1)" == "function" ] && type -a $1 | sed -e "s#__libkoca__#$fp2me#g" | tail -n +2
	shift
done
)
