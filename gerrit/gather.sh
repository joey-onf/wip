#!/bin/bash
## -----------------------------------------------------------------------
## -----------------------------------------------------------------------

##----------------##
##---]  INIT  [---##
##----------------##
declare -g WORK="/tmp/${BASH_SOURCE##*/}.$$"
case "$USER" in
    joey)
        source ~/.sandbox/trainlab-common/common.sh '--common-args-begin--'

        common_tempdir_mkdir WORK
        ;;
esac
mkdir -p "$WORK"

##-------------------##
##---]  GLOBALS  [---##
##-------------------##

##--------------------##
##---]  INCLUDES  [---##
##--------------------##
source "${BASH_SOURCE::-3}/main/utils.sh"
source "${BASH_SOURCE::-3}/getopts/repo.sh"
source "${BASH_SOURCE::-3}/query/patch_sets.sh"
source "${BASH_SOURCE::-3}/view/patch_sets.sh"

## -----------------------------------------------------------------------
## -----------------------------------------------------------------------
function error()
{
    cat <<EOF

** -----------------------------------------------------------------------
** ERROR: $@
** -----------------------------------------------------------------------

EOF
    exit 1
}

## -----------------------------------------------------------------------
## -----------------------------------------------------------------------
function banner()
{
    local iam="${FUNCNAME[1]}"

    cat <<EOF

** -----------------------------------------------------------------------
** IAM: ${iam}
** PWD: ${PWD}
** -----------------------------------------------------------------------
** $@
** -----------------------------------------------------------------------

EOF
    return
}

## -----------------------------------------------------------------------
## -----------------------------------------------------------------------
function usage()
{
    cat <<EOH

Usage: $0
  --preserve [subdir]  Copy generated content into a local subdir

  --repo [r]           Gather patch URLs for named repository
  --view [r]           View gathered patches for named repository

  --query []
    patch-sets

  --patch-sets         Gather & view patch set data (URL, commitMessage)

  --view-query [v]     View query data
     patch-sets        URLS and commit messages

[MODIFIERS ]
  --status  s={o,c}    Query by ticket status
     s=[open|closed]

[FORMAT]
  --json               Output data formatted as JSON records

  --help               Dispaly this message
EOH

    return
}
    
##----------------##
##---]  MAIN  [---##
##----------------##
rm -fr tmp
mkdir -p tmp
mkdir -p repositories

declare -a gerrit_args=()

declare -a repos=()
while [[ $# -gt 0 ]]; do
    arg="$1"; shift
    case "$arg" in
        --help) usage; exit 0 ;;

        --json) gerrit_args+=('--format=JSON') ;;
        
        --patch-sets)
            declare -g -i argv_patch_sets=1
            declare -a args=()
            args+=('--json')
            # args+=('--view-query' 'patch-sets')
            set -- "${args[@]}" "$@"
            ;;

        --preserve)
            argv="$1"; shift
            declare argv_preserve="${start_pwd}/preserve/$argv"
            readonly argv_preserve
            ;;

        --query)
            arg="$1"; shift
            case "$arg" in
                patch-sets) set -- '--patch-sets' "$@" ;;
                *) error "Detected invalid arg: --query [$arg]" ;;
            esac

            ## TODO
            [[ ! -v queries ]] && { declare -g -a queries=(); }
            queries+=("$arg")
            ;;

        --status)
            local arg="$1"; shift
            case "$arg" in
                c*) arg='closed' ;;
                o*) arg='open'   ;;
                *) error "Detected unknown --status [$arg]" ;;
            esac

            [[ ! -v argv_status ]] && { declare -g -a argv_status=(); }
            # status:open
            argv_status+=("status:${arg}")
            ;;
        
#@ topic:MY-TOPIC status:open project:xxx
        
        --repo)
            arg="$1"; shift
            verify_repo_name "$arg" 'repos/voltha' \
                || { error "Detected invalid arg: --repo [$arg]"; }
            repos+=("$arg")
            ;;

        --view)
            [[ ! -v views ]] && { declare -g -a views=(); }
            declare repo="$1"; shift
            repos+=("$repo")
            views+=("$repo")
            ;;

        --view-query)
            arg="$1"; shift
            case "$arg" in
                patch-sets) declare -g -i argv_view_patch_sets=1 ;;
                *) error "Detected invalid --argv_view_query[$arg]" ;;
            esac

            # [[ ! -v argv_view_query ]] && { declare -g -a argv_view_query=(); }
            # argv_view_querys+=("$arg")
            ;;

        *) error "Detected invalid arg [$arg]" ;;
    esac
done

## -----------------
## Add argv defaults
## -----------------
[[ ! -v repos ]] && { error "--repo is required"; }

#[[ -v argv_status ]] \
#    && { gerrit_args+=("${argv_status[@]}"); } \
#    || { gerrit_args+=('status:open'); }

## -----------------------------------------------------------------------
## Query gerrit, output json data files
## -----------------------------------------------------------------------
for repo in "${repos[@]}";
do
    repo_prefix="repositories/${repo}"

    ## TODO: Iterate, query and view
    # local query
    for query in "${queries[@]}";
    do
        ## TODO
        case "$query" in
            patch-sets)
                patch_sets_query "${WORK}" "$repo" gerrit_args reports
                ## [[ -v argv_view_queries ]] && { patch_sets_view reports; }
                ;;
        esac
    done

    ## dir=${WORK}/${FUNCNAME}/${repo}
    if [[ -v argv_patch_sets ]]; then
        patch_sets_query "${WORK}" "$repo" gerrit_args reports
        [[ -v argv_view_patch_sets ]] && { patch_sets_view reports; }
    fi
done

if [[ -v argv_preserve ]]; then
    mkdir -p "$argv_preserve"
    rsync -rv --checksum "$WORK/." "$argv_preserve/."
fi

if [[ -v views ]]; then
    declare -a urls=()
    for view in "${views[@]}";
    do
        repo_prefix="repositories/${view}"
        path="${repo_prefix}.url.json"
        readarray -t buffer < "$path"
        urls+=("${buffer[@]}")
    done

    [[ ${#urls[@]} -gt 0 ]] && { firefox "${urls[@]}"; }
fi
