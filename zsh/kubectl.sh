function _kubectl_select_pod() {
    if [ -n "$1" ]; then
        local lines=$(kubectl get pods | tail -n +2 | grep "$1" )
        local num_lines=$(echo "$lines" | wc -l)
        if [ "$num_lines" -eq 1 ];then
            line=$lines
        else
            line=$(echo $lines | fzf --query="$1" --exit-0)
        fi
    else
        line=$(kubectl get pods | tail -n +2 | fzf --exit-0)
    fi
    local podname=$(echo $line | awk '{print $1}')
    echo $podname
}

function _kubectl_log_tail() {
    kubectl logs -f $(_kubectl_select_pod)
}


