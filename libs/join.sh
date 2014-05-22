function koca_join {
	cat | sed -e ":a;N;\$!ba;s/\n/$1/g"
}
