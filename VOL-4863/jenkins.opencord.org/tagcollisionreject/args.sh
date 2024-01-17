#!/bin/bash

# TEMP=`getopt -o f:s::d:a:: --long file-name:,source::,destination:,action:: -- "$@"`
declare -a getopt_args=()
getopt_args+=('--options' 'f:s::d:a::')
# --long file-name:,source::,destination:,action:: -- "$@")
# getopt_args+=('--longoptions' 'file-name:,source::,destination:,action::')

# ':'  - required arg
# '::' - optional arg
getopt_args+=('--long' 'file-name:,source::')
getopt_args+=('--long' 'destination:,action::')
getopt_args+=('--')
getopt_args+=("$@")


# read the options
TEMP=$(getopt "${getopt_args[@]}")
eval set -- "$TEMP"

# extract options and their arguments into variables.
while true ; do
    case "$1" in
        -f|--file-name)
            fileName=$2 ; shift 2 ;;
        -s|--source)
            case "$2" in
                "") sourceDir='.' ; shift 2 ;;
                 *) sourceDir=$2 ; shift 2 ;;
            esac ;;
        -d|--destination)
            destinationDir=$2 ; shift 2;;
        -a|--action)
            case "$2" in
                "copy"|"move") action=$2 ; shift 2 ;;
                            *) action="copy" ; shift 2 ;;
            esac ;;
        --) shift ; break ;;
        *) echo "Internal error!" ; exit 1 ;;
    esac
done

# Now take action
echo "$action file $fileName from $sourceDir to $destinationDir"

# [EOF]
