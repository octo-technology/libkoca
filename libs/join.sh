function koca_join { # join lines from STDIN whith $1
	cat | sed -e ":a;N;\$!ba;s/\n/$1/g"
}
