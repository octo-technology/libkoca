# Fournit un mechanisme de lock: empeche plusieurs instances 
# de tourner en meme temps.
# Efface le lock s'il est vide, ou s'il ne correspond vraisemblablement pas au processus qui essait de le créer
# Utilisation:
# lockMe [ -q ] <fichier de lock> [ timeout ]
# -q : sort silencieusement si le timeout expire
# PS: le fichier ne devrait pas etre un `mktemp`, sinon ca risque pas de marcher cm prevu :)
function koca_lockMe { # Lock the calling script on the specified file
	local src=__libkoca__ ; [ -e $src ] && eval "$(bash $src koca_cleanOnExit)"
	local quiet=0
	[ "$1" = "-q" ] && quiet=1 && shift
	if [ -z "$1" ]
	then
		local lock=/tmp/$(basename "$0").lock
	else
		local lock="$1"
	fi
	local to=60
	[ -n "$2" ] && to=$2
	local n=0
	if [ -s "$lock" ]
	then
		# replace the shell by its absolute path (bash -> /bin/bash)
		c=$(ps -o command=COMMAND $(cat "$lock") | grep -v COMMAND | awk '{print $2}' | xargs echo $SHELL )
		# Should detect that /bin/bash plop.sh is the same as /bin/bash ./plop.sh
		if [[ ! "$c" =~ $SHELL" "\.?\/?$0.* ]]
		then
			[ "$quiet" -eq 0 ] && echo "[__libname__] Stall lock ($c vs $SHELL $0). Removing."
			rm -f "$lock"
		fi
	else
		if [ -e "$lock" ]
		then
			echo "[__libname__] Empty lock $lock. Removing"
			rm -f "$lock"
		fi
	fi
	while [ -e $lock -a $n -le $to ]
	do
		[ "$quiet" -eq 0 ] && echo "[__libname__] An instance is running (pid : $(/bin/cat $lock))."
		[ "$(basename -- $0)" == "bash" ] && return
		[ $to -eq 0 ] && exit 1
		sleep 1
		(( n++ ))
		# boucler plutot que sortir ?
	done
	if [ $n -gt $to -a -e $lock ]
	then
		[ "$quiet" -eq 0 ] && echo "[__libname__] Timeout on locking. Violently exiting."
		exit 1
	else
		echo "$$" > $lock
		koca_cleanOnExit $lock
		return 0
	fi
}
function koca_unlockMe { # unlock
	rm -f "$1"
	[ ! -e "$1" ]
}
# Retourne 1 si le script a été locké par le fonction ci-dessus
# Retourne 0 sinon
function koca_isLocked {
	lock=$1
	[ -e $lock ] && return 0
	return 1
}
alias lockMe="echo '[libkoca] Better prefixed with koca_'; koca_lockMe \"$*\""
alias unlockMe="echo '[libkoca] Better prefixed with koca_'; koca_unlockMe \"$*\""
alias isLocked="echo '[libkoca] Better prefixed with koca_'; koca_isLocked \"$*\""
