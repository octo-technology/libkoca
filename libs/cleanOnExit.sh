#$Id: cleanOnExit.sh 1161 2013-01-03 10:28:56Z gab $
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
