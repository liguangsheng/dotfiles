#!/bin/sh

# requirements:
# - xdotool
# - stalonetray
# - feh

if command -v feh &> /dev/null; then
    feh --bg-scale $HOME/.config/xmonad/wallpaper.png
else
    notify-send "warning from startxmonad.sh" "command feh not found"
fi

# trayer --transparent true --edge top --alpha 0 --align right --expand true --SetDockType true --SetPartialStrut false --width 1 --widthtype request --tint 0x1f2227 --height 12 --distance 6 &
stalonetray -bg "#282c37" --icon-size 12 --geometry 1x1+1896+6 --max-geometry 10x1 --grow-gravity E &

binaries=(
    "$HOME/.cache/xmonad/xmonad-x86_64-linux"
    "$HOME/.local/bin/xmonad"
    "/usr/bin/xmonad"
)

for binary in "${binaries[@]}"; do
    if [ -x "$binary" ]; then
        exec "$binary"
        # 如果找到一个可执行文件并执行后退出脚本
        break
    fi
done
