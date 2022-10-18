#!/usr/bin/env bash

if command -v paru &> /dev/null; then
    echo "--> Installing paru packages"
    paru -S --needed stow curl wget unzip \
        git \
        ttf-roboto-mono-nerd \
        ttf-jetbrains-mono-nerd \
        ttf-arimo-nerd \
        ttf-lxgw-wenkai-mono \
        ttf-arphic-ukai
fi


if command -v stow &> /dev/null; then
    echo "--> Applying stow"
    list=(
        x11
        zsh
        bash
        vim
        ctags
        alacritty
        conky
        dunst
        kitty
        fastfetch
        neofetch
        nvim
        picom
        qtile
        ranger
        rofi
        wezterm
        xmobar
        xmonad
        awesome
    )
    for i in ${list[*]}; do
        echo "  stow -t $HOME $i"
        stow -t $HOME $i || exit -1
    done
else
    echo "  stow command not found, skipped"

fi

echo "--> Applying git config"
if command -v git &> /dev/null; then
    . git/config.sh
else
    echo "  git command not found, skipped"
fi
