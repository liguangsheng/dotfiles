#!/bin/sh

# requirements:
# - xsetroot
# - feh
# - pip install psutil requests

WALLPAPER=$HOME/dotfiles/suckless/wallpaper.jpg

function init_wallpaper() {
    if command -v feh &> /dev/null; then
        if [[ -f $HOME/dotfiles/suckless/wallpaper.jpg ]]; then
            feh --bg-scale $WALLPAPER
            return
        fi

        if [[ -f $HOME/.fehbg ]]; then
            . $HOME/.fehbg
            return
        fi

        feh --bg-scale --randomize $HOME/dotfiles/wallpapers/
    fi

    if command -v nitrogen &> /dev/null; then
        nitrogen --set-scaled $WALLPAPER
    fi

    if command -v xsetbg &> /dev/null; then
        xsetbg $WALLPAPER
    fi

    notify-send "warning from startdwm.sh" "command feh not found"
}

function init_status() {
    python3 $HOME/dotfiles/suckless/dwmblocks.py &
    # or use shell version status
    # $HOME/dotfiles/suckless/dwmstatus.sh &
}

function init_process() {
	local binary_name=$1
	local start_command=$2

	# 检查二进制文件是否存在
	if ! command -v $binary_name > /dev/null; then
		echo "Error: $binary_name not found."
		return 1
	fi

	# 检查进程是否已经在运行
	if pgrep $binary_name > /dev/null; then
		echo "$binary_name is already running."
		return 0
	fi

	# 启动进程
	echo "Starting $binary_name..."
	eval "$start_command"
}

init_status
init_wallpaper
init_process vmware-user 'vmware-user &'
init_process dunst 'dunst &'
init_process nm-applet 'nm-applet &'

exec dwm

