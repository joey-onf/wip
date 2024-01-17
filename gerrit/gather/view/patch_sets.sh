#!/bin/bash
## -----------------------------------------------------------------------
## -----------------------------------------------------------------------

## -----------------------------------------------------------------------
## -----------------------------------------------------------------------
function patch_sets_view()
{
    local -n logs=$1; shift

    local cmd="$WORK/view_urls.sh"
    cat <<EOC>"$cmd"
#!/bin/bash

firefox \\
EOC
    
    local log
    for log in "${logs[@]}"; do
        case "$log" in
            # *.url.txt) cat "$log" ;;
            # *.url.txt) firefox $(awk -F\" '/:\/\//{print $2}' "${log}") & ;;
            *.url.txt)
                awk -F\" '/:\/\//{print $2}' "${log}" \
                    | xargs -I'{}' printf " '{}'" >> "$cmd"
                echo ' >/dev/null 2>/dev/null &' >> "$cmd"
                # cat "$cmd"
                chmod +x "$cmd"
                "$cmd"
                ;;
        esac
    done
              
#    local what='urls'
#    case "$what" in
 #       *) error "NOT YET IMPLEMENTED: patch_sets_view[$what]" ;;
    #    *)  ## FORMAT AS A TABLE
     #       paste --delimiter='|||' "${data_prefix}.url.json" "${data_prefix}.cm.json" > "${repo}.md"
      #      ;;

    ## jq query to assemble into a table
#    | jq -r '["URL" "Description"], ["--","-----------"], (.[] | [.url, .commitMessage]) | @tsv' \
#    | column -ts $'\t'
#     | jq '.url,.commitMessage' 
#    esac
    return
}

: # ($?==0) for source $script

# [EOF]
