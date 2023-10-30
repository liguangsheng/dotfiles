#!/usr/bin/env bash

echo "--> Installing paru packages"
if command -v paru &> /dev/null; then
    paru -S --needed stow curl wget unzip \
        git \
        ttf-roboto-mono-nerd \
        ttf-jetbrains-mono-nerd \
        ttf-arimo-nerd \
        ttf-lxgw-wenkai-mono \
        ttf-arphic-ukai
fi


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

echo "--> Applying git config"
if command -v git &> /dev/null; then
    . git/config.sh
else
    echo "  git command not found, skipped"
fi
