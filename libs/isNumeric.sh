function isNumeric { # return true if parameter is numeric
	[[ $1 =~ ^[0-9.]+$ ]]
}
