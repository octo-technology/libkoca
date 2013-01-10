#$Id: fclone.sh 1127 2012-08-31 15:39:56Z gab $
function fclone { # Clone a function
	local ffrom=$1
	local fto=$2
	local fcom=$3
	eval "$fto() {
	$(type -a $ffrom | tail -n +4 )"
	falias="$(echo $falias)$fto $fcom"
}
#fclone "z_copy" "z_move" '# copy, and delete'
