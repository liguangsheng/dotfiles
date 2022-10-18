#!/bin/bash

# Read the contents of /proc/meminfo into a variable
meminfo=$(cat /proc/meminfo)

# Extract the values for MemTotal, MemFree, Buffers, Cached, SReclaimable, and Shmem
memtotal=$(echo "$meminfo" | awk '/^MemTotal:/ {print $2}')
memfree=$(echo "$meminfo" | awk '/^MemFree:/ {print $2}')
buffers=$(echo "$meminfo" | awk '/^Buffers:/ {print $2}')
cached=$(echo "$meminfo" | awk '/^Cached:/ {print $2}')
sreclaimable=$(echo "$meminfo" | awk '/^SReclaimable:/ {print $2}')
shmem=$(echo "$meminfo" | awk '/^Shmem:/ {print $2}')

# Convert the values to a lua table string
lua_string=$(printf '{MemTotal=%d, MemFree=%d, Buffers=%d, Cached=%d, SReclaimable=%d, Shmem=%d}' $memtotal $memfree $buffers $cached $sreclaimable $shmem)

# Output the lua table string
echo "$lua_string"

