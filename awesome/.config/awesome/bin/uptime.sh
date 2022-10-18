#!/bin/bash

uptime=$(cat /proc/uptime | awk -F '.' '{print $1}')
days=$((${uptime}/86400))
hours=$(((${uptime}%86400)/3600))
minutes=$(((${uptime}%3600)/60))
seconds=$((${uptime}%60))

if [[ ${days} -gt 0 ]]; then
    echo "${days}d ${hours}h ${minutes}m ${seconds}s"
elif [[ ${hours} -gt 0 ]]; then
    echo "${hours}h ${minutes}m ${seconds}s"
elif [[ ${minutes} -gt 0 ]]; then
    echo "${minutes}m ${seconds}s"
else
    echo "${seconds}s"
fi

