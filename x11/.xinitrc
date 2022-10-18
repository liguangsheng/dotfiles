#!/usr/bin/env bash
# vim:ft=sh

[ -f "$HOME/.xprofile" ] && . "$HOME/.xprofile"

WM="${WM:-qtile}"
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

