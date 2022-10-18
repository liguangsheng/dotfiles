#!/bin/bash

# usage=$(grep 'cpu ' /proc/stat | awk '{usage=($2+$4)*100/($2+$4+$5)} END {printf "%.0f",usage}\')
# echo "${usage}"

echo $(top -bn1 -i -c | awk '/^%Cpu/ {usage += 100 - $8} END {print usage}')

