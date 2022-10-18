#!/bin/sh

# requirements:
# - xdotool
# - stalonetray
# - feh

if command -v feh &> /dev/null; then
    if [[ -f $HOME/.fehbg ]]; then
        . $HOME/.fehbg
    else
        feh --bg-scale $HOME/.config/xmonad/wallpaper.jpg
    fi
else
    notify-send "warning from startxmonad.sh" "command feh not found"
fi

# trayer --transparent true --edge top --alpha 0 --align right --expand true --SetDockType true --SetPartialStrut false --width 1 --widthtype request --tint 0x1f2227 --height 12 --distance 6 &
stalonetray -bg "#1f2227" --icon-size 12 --geometry 1x1+1896+6 --max-geometry 10x1 --grow-gravity E &

exec $HOME/.cache/xmonad/xmonad-x86_64-linux
# exec $HOME/.local/bin/xmonad
# exec /usr/bin/xmonad
