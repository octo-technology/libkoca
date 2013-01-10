here=$(cd $(dirname "$0") ; pwd)
bn=$(basename "$0")
if [ -e $here/../libs/$bn ]
then
	source $here/../libs/$bn
else
	echo "Can't include $bn"
	exit 1
fi
