#!/usr/bin/env bash

STOW='./bin/stowsh'
echo "--> Applying stow"
list=(
    alacritty
    awesome
    bash
    conky
    ctags
    dunst
    emacs
    fastfetch
    kitty
    neofetch
    nvim
    picom
    qtile
    ranger
    rofi
    tmux
    vim
    wezterm
    x11
    xmobar
    xmonad
    zsh
)
for i in ${list[*]}; do
    echo "  stow -t $HOME $i"
    $STOW -s -t $HOME $i || exit -1
done


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


echo "--> Applying git config"
if command -v git &> /dev/null; then
    . git/config.sh
else
    echo "  git command not found, skipped"
fi
