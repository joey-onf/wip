#!/bin/bash

[ $# -eq 0 ] && set -- --fail

while [ $# -gt 0 ]; do
    arg="$1"; shift

    case "$arg" in
	-*fail)
	    echo "FAIL"
	    /bin/false
	    ;;
	-*pass)
	    echo "PASS"
	    /bin/true
	    ;;
	-*exit)
	    rc=$1; shift
	    echo "EXIT: $rc"
	    exit $rc
	    ;;
    esac
done

# EOF
