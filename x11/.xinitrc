#!/usr/bin/env bash
# vim:ft=sh

export XDG_CONFIG_HOME=$HOME/.config export XDG_DATA_HOME=$HOME/.local/share
export XDG_CACHE_HOME=$HOME/.cache

export LANG=zh_CN.UTF-8
export LC_CTYPE=zh_CN.UTF-8
export LIBGL_ALWAYS_SOFTWARE=true
export MESA_GL_VERSION_OVERRIDE=4.3
export MESA_GLSL_VERSION_OVERRIDE=430
export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
export XMODIFIERS=@im=fcitx
export SDL_IM_MODULE=fcitx
export GLFW_IM_MODULE=ibus
eval "$(dbus-launch --sh-syntax --exit-with-session)"

function init_process() {
    local binary_name=$1
    local start_command=$2

    # 检查二进制文件是否存在
    if ! command -v $binary_name > /dev/null; then
        echo "Error: $binary_name not found."
        return 1
    fi

    sleep 3s

    # 检查进程是否已经在运行
    if pgrep $binary_name > /dev/null; then
        echo "$binary_name is already running."
        return 0
    fi

    # 启动进程
    echo "Starting $binary_name..."
    eval "$start_command"
}

init_process vmware-user "vmware-user &" &
init_process dunst "dunst &" &
init_process nm-applet "nm-applet &" &
init_process pnmixer "pnmixer &" &
init_process fcitx5 "fcitx5 -d" &

WM="${WM:-awesomewm}"

case "$WM" in
    dwm)
        $HOME/dotfiles/suckless/startdwm.sh
        ;;
    xmonad)
        $HOME/.config/xmonad/startxmonad.sh
        ;;
    qtile)
        exec qtile start
        ;;
    awesomewm)
        exec awesome
        ;;
    gnome)
        exec gnome-session
        ;;
    kde)
        exec startplasma-x11
        ;;
    *)
        echo "Invalid WM value: $WM"
        ;;
esac

