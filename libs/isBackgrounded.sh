function koca_isBackgrounded() { # Return true is process is backgrounded
	case $(ps -o stat= -p $$) in
		*+*) return 1;;
		*) return 0;;
esac
}
