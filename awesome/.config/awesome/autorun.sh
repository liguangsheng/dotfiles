#!/bin/sh

function init_process() {
	local binary_name=$1
	local start_command=$2

	# 检查二进制文件是否存在
	if ! command -v $binary_name > /dev/null; then
		echo "Error: $binary_name not found."
		return 1
	fi

    sleep 8s

	# 检查进程是否已经在运行
	if pgrep $binary_name > /dev/null; then
		echo "$binary_name is already running."
		return 0
	fi

	# 启动进程
	echo "Starting $binary_name..."
	eval "$start_command"
}

init_process vmware-user 'vmware-user &' &
init_process dunst 'dunst &' &
init_process nm-applet 'nm-applet &' &
# init_process picom 'picom -bc' &

