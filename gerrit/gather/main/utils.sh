#!/bin/bash

## -----------------------------------------------------------------------
## Intent: Derive program paths
## -----------------------------------------------------------------------
function __anonymous()
{
    declare -g pgm="$(readlink --canonicalize-existing "$0")"
    declare -g pgmbin="${pgm%/*}"
    declare -g pgmroot="${pgmbin%/*}"
    declare -g pgmname="${pgm%%*/}"

    declare -g pgmsrc
    pgmsrc="$(readlink --canonicalize-existing "${BASH_SOURCE[0]}")"
    readonly pgmsrc

    readonly pgm
    readonly pgmbin
    readonly pgmroot
    readonly pgmname

    declare -g start_pwd="$(realpath --canonicalize-existing '.')"
    readonly start_pwd

    return
}
__anonymous

: # ($?==0) for source $script

# [EOF]
