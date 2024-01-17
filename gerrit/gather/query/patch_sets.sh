#!/bin/bash
## -----------------------------------------------------------------------
## -----------------------------------------------------------------------

## -----------------------------------------------------------------------
## Intent: Query for gerrit --patch-sets
## -----------------------------------------------------------------------
function patch_sets_query()
{
    local path="$1"; shift
    local repo="$1"; shift
    local -n gargs=$1; shift
    local -n logs=$1; shift

    # declare -g report_json
    # declare -g report_paths
    banner 'Gather patch json'
    
    path+="/${repo}/${FUNCNAME}"
    mkdir -p "$path"
    
    local data_prefix="${path}/${repo}"
    local data_json="${data_prefix}.json"
    [[ -f "$data_json" ]] && { return; }
    
    declare -a query_args=() 
    query_args+=('--patch-sets')
    query_args+=("${gargs[@]}")   #    foo+=("${gerrit_args[@]}")
    query_args+=('--format=JSON')
    query_args+=('--patch-sets')
    query_args+=('--format=JSON')
    query_args+=("projects:${repo}" 'AND' 'status:open')

    ssh gerrit.opencord.org gerrit query "${query_args[@]}" > "$data_json"
    logs+=("$data_json")

    jq '.url' < "$data_json" > "${data_prefix}.url.txt"
    logs+=("${data_prefix}.url.txt")

    jq '.commitMessage' < "$data_json" > "${data_prefix}.cm.txt"
    logs+=("${data_prefix}.cm.txt")
    return
}

: # ($?==0) for source $script

# [EOF]
