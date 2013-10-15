#!/bin/bash
tlib=$(mktemp)
mkdir -p logs
cat libs/aacore.sh > $tlib
for i in libs/*.sh
do
	bn=$(basename "$i")
	echo -n "$bn ... "
	if ./t/$(basename "$i") > logs/$bn.log
	then
		# test ok
		echo "ok. Adding"
		cat libs/$bn >> $tlib
	else
		# test failed
		echo "failed"
	fi
done
sed -i  -e "s/__libname__/$1/" $tlib
echo "# built on $(date +%Y-%m-%d)" >> $tlib
mv $tlib $1
echo "Testing inclusion of :"
sh $1 list | awk '{print $1}' | while read f
do
	echo -n "> $f"
	eval "$(sh $1 "$f")" ; _r=$?
	if [ $_r -eq 0 ]
	then
		echo " ... ok"
	else
		echo " ... fail"
	fi
done
