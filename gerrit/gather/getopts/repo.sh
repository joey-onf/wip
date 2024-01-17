#!/bin/bash
## -----------------------------------------------------------------------
## -----------------------------------------------------------------------

## -----------------------------------------------------------------------
## Intent: Determine if a given --repo stirng is a valid repository name
## -----------------------------------------------------------------------
## GIVEN:
##   o name  (scalar)   repository name to validate
##   o conf  (file)     path to file containing a list of valid strings
## -----------------------------------------------------------------------
## RETURN:
##   o $?    $?=0 if a valid string was found else ($? != 0)
## -----------------------------------------------------------------------
function verify_repo_name()
{
    local name="$1"; shift
    local conf="$1"; shift

    readarray -t repositories < <(
        awk -F'#' '{print $1}' "$conf"  \
            | grep '^[a-z]'
    )

    [[ ! " ${repositories[*]} " =~ " ${name} " ]] \
        && { declare -i ans=1; } \
        || { declare -i ans=0; }

    [[ $ans -eq 0 ]] && { true; } || { false; }
    return
}

: # ($?==0) for source $script

# [EOF]
