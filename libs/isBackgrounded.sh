function koca_isBackgrounded() { # Return true is process is backgrounded. Thanks to http://is.gd/4h3fk0
	case $(ps -o stat= -p $$) in
		*+*) return 1;;
		*) return 0;;
esac
}
