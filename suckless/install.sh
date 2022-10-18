#!/bin/bash

# Function to build and install the specified program in the given directory
build_and_install() {
    local directory=$1
    if [ -d "$directory" ]; then
        (cd "$directory" && rm -f config.h && sudo make install clean)
    else
        echo "Directory $directory does not exist."
    fi
}

# If no arguments provided, install all 5 programs
if [ $# -eq 0 ]; then
    build_and_install "dmenu"
    build_and_install "dwm"
    build_and_install "st"
    build_and_install "scroll"
    build_and_install "tabbed"
    build_and_install "xsetbg"
else
    # If the first argument is provided, install only that program
    build_and_install "$1"
fi
