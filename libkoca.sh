# Lib of useful function, for shell addicts
# Inclusions of function depend on wether it as succeeded to shunit or not
# Brought to you under GPL Licence, by Gab

_outdated() {
    local statfile=$HOME/libkoca-outdated/stats
    echo "[libkoca.sh] Please use $2, instead of $1. This will be logged to $statfile"
	mkdir -p $(dirname $statfile)
	echo "$(date -u +%Y%m%d%H%M%SZ) : In $(cd $(dirname "$0") ; pwd)/$(basename $0) : $1 should be replaced by $2" >> $statfile
}
# Check wether specified file can be found, and warn according it's a MAY or a MUST
# checkNeededFiles may [ file [ file [ ... ] ]
# checkNeededFiles must [ file [ file [ ... ] ]
function checkNeededFiles {
	_ec=0
	while [ -n "$1" ]
	do
		case $1 in
			may)
				type=may
				;;
			must)
				type=must
				;;
			*)
				if ! which "$1" >/dev/null 2>&1
				then
					[ "$type" = "may" ] && echo "[libkoca.sh] '$1' not found. Bad things may happen" >&2 && _ec=1
					[ "$type" = "must" ] && echo "[libkoca.sh] '$1' not found. Bad things WILL happen" >&2 && _ec=2
				fi
				;;
		esac
		shift
	done
	return $_ec
}
# Efface certains fichiers a la sortie du programme
# Utilisation:
# cleanOnExit <liste de fichiers>
# Bug : si 'cleanOnExit' est utilisé dans une fonction chargé dans l'environnement du shell courant, alors rien ne sera fait à la sortie de la fonctions, ni à la sortie du shell
# En d'autres termes, dans ce cas :
# $ cat plop
# f()
#	{
#	t=`mktemp`
#	cleanOnExit $t
# }
# $ . libkoca.sh
# $ . plop
# $ f
# Le fichier temporaire ne sera jamais effacé
function cleanOnExit { # Remove specified file on script exiting
	local t=$(trap -p 0)
	[ -n "$t" ] && _oldTrap0=$(echo "$t ;" | sed -e "s/trap -- '\(.*\)' EXIT/\1/")
	trap "$_oldTrap0 rm -f $*" 0
}
function dhms2s {	# day hour min sec to seconds
	# can be specified in any order :
	# 1d1s is the same as 1s1d
	w=$1
	echo "$w" | sed -e 's/\([0-9]*\)d/\1*86400 + /' -e 's/\([0-9]*\)h/\1*3600 + /' -e 's/\([0-9]*\)min/\1*60 + /' -e 's/\([0-9]*\)s/\1 + /' -e 's/+ $//' -e 's/$/+0/'| bc
}
function dieIfNotRoot { # Exit calling script if not running under root
	! gotRoot && echo "[libkoca.sh] Actually, I should be run as root" && exit 1
	! underSudo && echo "[libkoca.sh] Actually, I should be run under sudo" && exit 1
	return 0
}
function dieIfRoot { # Exit calling script if run under root
	gotRoot && echo "[libkoca.sh] I should not be run as root" && exit 1
	underSudo && echo "[libkoca.sh] I should not be run under sudo" && exit 1
	return 0
}
function underSudo { # Return wether the calling script is run under sudo
	[ -n "$SUDO_USER" ]
}
function gotRoot { # Return wether the calling script is run under root
	[ $(id -u) -eq 0 ]
}
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
function fclone { # Clone a function
	local ffrom=$1
	local fto=$2
	local fcom=$3
	eval "$fto() {
	$(type -a $ffrom | tail -n +4 )"
	falias="$(echo $falias)$fto $fcom"
}
#fclone "z_copy" "z_move" '# copy, and delete'
# Return color code in a specified var
# getColor var[+] color [ [ var[+] ] color [ ... ] ]
# Ex : getColor r red g green
#   will put the color code red in $r, and green in $g
# Ex : getColor ok higreen bgred
#   $ok will contain green on red
# Ex : getColor a red ; a="$a*" ; getColor a+ reset ; 
#   $a will contain then the code of red, then a star, then the code of reset. Thus, echo "$a plop" will display a red star, followed by the string "plop"
# getColor list to get available colors. Output is colored only if it is a terminal.
function getColor { # Return a specified color code in a specified var
	function _getColor {
	alias echo="echo -n"
	local _bold=$(tput bold)
		case $1 in 
			black) echo $(tput setaf 0);;
			red) echo $(tput setaf 1) ;;
			green) echo $(tput setaf 2) ;;
			brown) echo $(tput setaf 3) ;;
			blue) echo $(tput setaf 4) ;;
			purple) echo $(tput setaf 5) ;;
			cyan) echo $(tput setaf 6) ;;
			gray) echo $(tput setaf 7) ;;

			bgblack) echo $(tput setab 0);;
			bgred) echo $(tput setab 1) ;;
			bggreen) echo $(tput setab 2) ;;
			bgyellow) echo $(tput setab 3) ;;
			bgblue) echo $(tput setab 4) ;;
			bgpurple) echo $(tput setab 5) ;;
			bgcyan) echo $(tput setab 6) ;;
			bgwhite) echo $(tput setab 7) ;;

			hiblack) echo $_bold$(_getColor black) ;;
			hired) echo $_bold$(_getColor red) ;;
			higreen) echo $_bold$(_getColor green) ;;
			yellow) echo $_bold$(_getColor brown) ;;
			hiblue) echo $_bold$(_getColor blue) ;;
			hipurple) echo $_bold$(_getColor purple) ;;
			hicyan) echo $_bold$(_getColor cyan) ;;
			white) echo $_bold$(_getColor gray) ;;

			bold) echo $_bold ;;
			# don't ask me why ...
			#reset) echo "$(tput sgr0)" ;;
			reset) echo -e "\033[0m";;
		esac
		unalias echo
	}
    local misccolors='reset bold '
	local alllowcolors='green brown red black blue cyan purple gray'
	local allhicolors='higreen yellow hired hiblack hiblue hicyan hipurple white'
	local allbgcolors='bggreen bgyellow bgred bgblack bgblue bgcyan bgpurple bgwhite'
	local allcolors=" $alllowcolors $allhicolors $allbgcolors $misccolors "

	if [ "$1" == "list" ]
	then
		local r=$(tput sgr0)
		local i
		for i in $allcolors
		do
			if [ -t 1 ]
			then
				echo "$r# $(_getColor $i)$i"
			else
				echo "# $i"
			fi
		done
		echo -ne $r
		echo "Usage : getColor var[+] color [ [ var[+] ] color [ ... ] ]"
		return 0
	fi
	[ $(expr ${#*}) -eq 1 ] && echo 'Bad number of arguments' >&2 && return 1
	while [ "$1" != "" ]
	do
		if ! $(echo "$allcolors" | grep -q " $1 ")
		then
			#echo "$1 is not a color, so it's a var"
			local var=$1
			augmented=0
			# If there is a '+' a the end of the var, it should be appended with color code
			if $(echo $var | grep -E -q '\+$')
			then
				augmented=1
				# strip the trailing '+'
				var=${var%%+}
			fi
			name=$2
			shift
		else
			#echo "$1 is a color"
			name=$1
			# and the variable should be in (previously set) 'var'
			augmented=1
		fi
        # '$var' is the name of the variable, for example : 'a'
        # $(echo $"$var")" return that name
        # \$$(echo $"$var")" is the "variabilized" name of that variable, for example : $a
        # eval echo \$$(echo $"$var")" return the value of that variable. If 'a' contain '1', this should return '1'
		local _val
		if [ $augmented -eq 1 ]
		then
			_val="$(eval echo \$$"$(echo $"${var%%+}")" 2>/dev/null)"
		else
			unset _val
		fi
        #echo "old value of 'var' is : $val"
		shift
        if echo " $allcolors "| grep -q " $name "
        then
			# seem to ill behave when name=reset and TERM=linux...
			eval ${var}=$"$_val"$"$(_getColor "$name")"
        else
            if [ "$name" = "" ]
            then
                echo "$FUNCNAME : Missing a color after variable '$var'"
            else
                echo "$FUNCNAME : $name is not a valid color. Try '$FUNCNAME list'"
            fi
            return
        fi
	done
}
_getConfGetSedOption() {
	local opt
	case $(uname -s) in
        Darwin|FreeBSD)
        opt=E
        ;;
        OpenBSD)
        opt=''
        ;;
        Linux|*)
        opt=r
        ;;
    esac
	echo $opt
}
_getConfIsReadable() {
	# Sauf qu'un fichier est toujours lisible par root, même s'il 
	# a le mode 0000 ...
	local flag=1
	for file in $conf
	do
		# At least one is readable
		[ -r "$file" ] && flag=0
	done
	[ $flag -eq 1 ] && echo "[libkoca] No readable conf file provided. Please put one in an env var named 'conf'" >&2 && return 1
	[ $flag -eq 0 ] && return 0
	return 2
}
# Deprecated
getConf() {
	echo "[libkoca.sh)] Please use getConfValue" >&2
	echo "$(date -u +%Y%m%d%H%M%SZ) : $(cd $(dirname \"$0\") ; pwd)/$(basename \"$0\") : getConf" >> /var/libkoca/stats
	getConfValue "$*"
}
# Return values from a configuration file passed in $conf variable
# format of conf file : section.key=value
# Usage : getConfValue <section> <key>
function getConfValue {
## link: ## _getConfGetSedOption ##
## link: ## _getConfIsReadable ##
	# hey hey, dynamic linking :)
	# If included in a script, nothing is done
	# If get by eval, then get those 2 functions
	local src=__libkoca__ ; [ -e "$src" ] && eval "$(bash "$src" _getConfGetSedOption _getConfIsReadable)"
	local opt=$(_getConfGetSedOption)
	_getConfIsReadable || return $?
	local val="$(grep -Eh "^$1\.$2[[:space:]]*=" $conf 2>/dev/null | sed -${opt}e 's/[^=*]+=\s*//'| tail -1)"
	[ -n "$val" ] && echo "$val" && return 0
	[ -n "$3" ] && echo "$3" && return 0
	return 2
}
# Return of the keys of a specified section
# Usage : getConfAllKeys <section>
function getConfAllKeys {
	local src=__libkoca__ ; [ -e "$src" ] && eval "$(bash "$src" _getConfGetSedOption _getConfIsReadable)"
	local opt=$(_getConfGetSedOption)
	_getConfIsReadable || return $?
	local val=$(grep -Eh "^$1\." $conf | sed -e "s/^$1\.\(.*\)\s*=.*/\1/")
	[ -n "$val" ] && echo $val && return 0
	return 2
}
# Return all the sections of an eventulally given keys
# Usage : getConfAllSections [ <key> [ <key> [ ... ] ]
function getConfAllSections {
	local src=__libkoca__ ; [ -e "$src" ] && eval "$(bash "$src" _getConfGetSedOption _getConfIsReadable)"
	local opt=$(_getConfGetSedOption)
	_getConfIsReadable || return $?
	local v
	if [ -z "$1" ]
    then
		v=$(grep -Eh "^[^[:space:]#].*\..*[\.\s=]" $conf | sed -e "s/^\(.*\)\..*\s*=.*/\1/" | sort -u | xargs)
    else
		while [ "$1" != "" ]
		do
			v="$v $(grep -Eh "^[^[:space:]#].*\.$1[\.\s=]" $conf | sed -e "s/^\(.*\)\..*\s*=.*/\1/" | sort -u | xargs)"
			shift
		done
    fi
	echo $v
}
function isIp { # return true if parameter is an IPv4 address
	#echo "$1" | grep -q -E '^[[:digit:]]{1,3}\.[[:digit:]]{1,3}\.[[:digit:]]{1,3}\.[[:digit:]]{1,3}$'
	echo "$1" | grep -q -E '^(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$'
}
# Fournit un mechanisme de lock: empeche plusieurs instances 
# de tourner en meme temps.
# Efface le lock s'il est vide, ou s'il ne correspond vraisemblablement pas au processus qui essait de le créer
# Utilisation:
# lockMe [ -q ] <fichier de lock> [ timeout ]
# -q : sort silencieusement si le timeout expire
# PS: le fichier ne devrait pas etre un `mktemp`, sinon ca risque pas de marcher cm prevu :)
function lockMe { # Lock the calling script on the specified file
	local src=__libkoca__ ; [ -e $src ] && eval "$(bash $src cleanOnExit)"
	local quiet=0
	[ "$1" = "-q" ] && quiet=1 && shift
	local lock="$1"
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
			[ "$quiet" -eq 0 ] && echo "[libkoca.sh] Stall lock ($c vs $SHELL $0). Removing."
			rm -f "$lock"
		fi
	else
		if [ -e "$lock" ]
		then
			echo "[libkoca.sh] Empty lock $lock. Removing"
			rm -f "$lock"
		fi
	fi
	while [ -e $lock -a $n -le $to ]
	do
		[ "$quiet" -eq 0 ] && echo "[libkoca.sh] An instance is running (pid : $(/bin/cat $lock))."
		[ "$(basename -- $0)" == "bash" ] && return
		[ $to -eq 0 ] && exit 1
		sleep 1
		(( n++ ))
		# boucler plutot que sortir ?
	done
	if [ $n -gt $to -a -e $lock ]
	then
		[ "$quiet" -eq 0 ] && echo "[libkoca.sh] Timeout on locking. Violently exiting."
		exit 1
	else
		echo "$$" > $lock
		cleanOnExit $lock
		return 0
	fi
}
function unlockMe {
	rm -f $1
	[ ! -e $1 ]
}
# Retourne 1 si le script a été locké par le fonction ci-dessus
# Retourne 0 sinon
function isLocked {
	lock=$1
	[ -e $lock ] && return 0
	return 1
}
function s2dhms {	# seconds to day hour min sec
	w=$1
	dw=$(echo "$w/86400" | bc)   # Day Warning
	sdw=$([ $dw -ne 0 ] && echo "${dw}d")    # String Day Warning
	w=$(echo "$w%86400" | bc)
	hw=$(echo "$w/3600" | bc)
	shw=$([ $hw -ne 0 ] && echo "${hw}h")
	w=$(echo "$w%3600" | bc)
	mw=$(echo "$w/60" | bc)
	smw=$([ $mw -ne 0 ] && echo "${mw}min")
	# smw=`[ $mw -ne 0 ] && echo "${mw}min")
	w=$(echo "$w%60" | bc)
	sw=$([ $w -ne 0 ] && echo "${w}s")
	tot=${sdw}${shw}${smw}${sw}
	if [ -z "$tot" ]
	then
		echo 0s
	else
		echo $tot
	fi
}
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
function whereAmI {
	pushd . >/dev/null
	cd $(dirname "$0")
	pwd
	popd > /dev/null
}
# Search a given file in path. If not found, search in common locations
# return true and the full path if found
# else return false
function whereIs {
	local w=$(type -p "$1")
	[ -n "$w" ]  && echo $w && return 0
	for path in /bin /sbin /usr/bin /usr/sbin /usr/local/bin /usr/local/sbin /usr/libexec /usr/local/libexec
	do
		[ -e "$path/$1" ] && echo "$path/$1" && return 0
	done
	false
}
# Parenthese guarantee that my variables won't pollute the calling shell

(

me=$(basename -- "$0")
# libkoca.sh will be replaced by the filename
libname='libkoca.sh'
# exit if I'am sourced from a shell
[ "$me" == "$libname" ] || exit 0
here=$(cd $(dirname "$0") ; pwd)
# full path to me
fp2me=${here}/$me
if [ $# -eq 0 ]
then
    echo "$me "
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
while [ "$1" != "" ]
do
	# Print code of the function
	# plus linking
	[ "$(type -t $1)" == "function" ] && type -a $1 | sed -e "s#__libkoca__#$fp2me#g" | tail -n +2
	shift
done
)
# built on 2013-01-10
