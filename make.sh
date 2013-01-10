#!/bin/bash
rm -f $1
mkdir -p logs
for i in libs/*.sh
do
	bn=$(basename "$i")
	echo -n "$bn ... "
	if ./t/$(basename "$i") > logs/$bn.log
	then
		echo "ok. Adding"
		cat libs/$bn >> $1
	else
		echo "failed"
	fi
done
sed -i -e "s/__libname__/$1/" $1
echo "# built on $(date +%Y-%m-%d)" >> $1
