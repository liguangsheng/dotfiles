#!/bin/bash

LANG=C.UTF-8

# Get the total and free memory
total=$(free -m | awk '/^Mem:/{print $2}')
used=$(free -m | awk '/^Mem:/{print $3}')

# Calculate the used memory in percentage
percent=$(awk "BEGIN {printf \"%.0f\",${used}/${total}*100}")

# Print the used memory and percentage
echo "${used}M(${percent}%)"
