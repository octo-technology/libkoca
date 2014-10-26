#http://is.gd/qQc5ab
function koca_spin {	# Display a spinning cursor
	koca_spin=(/ - \\ \| / - \\ \| ) 
	printf "\b"${koca_spin[$koca_spin_pos]} 
    (( koca_spin_pos=(koca_spin_pos +1)%8 ))
}
