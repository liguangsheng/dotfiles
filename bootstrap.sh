#!/usr/bin/env bash

XDG_BIN_HOME="$HOME/.local/bin"
XDG_CACHE_HOME="$HOME/.cache"
XDG_CONFIG_HOME="$HOME/.config"
XDG_DATA_HOME="$HOME/.local/share"
XDG_STATE_HOME="$HOME/.local/state"
USER_FONTS_HOME=$XDG_DATA_HOME/fonts

# colors
NC='\033[0m'
BLACK='\033[0;30m'
RED='\033[0;31m'
GREEN='\033[0;32m'
ORANGE='\033[0;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
LIGHT_GRAY='\033[0;37m'
DARK_GRAY='\033[1;30m'
LIGHT_RED='\033[1;31m'
LIGHT_GREEN='\033[1;32m'
YELLOW='\033[1;33m'
LIGHT_BLUE='\033[1;34m'
LIGHT_PURPLE='\033[1;35m'
LIGHT_CYAN='\033[1;36m'
WHITE='\033[1;37m'

BACKUP_DIR=$HOME/dotfiles/.backup/$(date +%F-%H-%M-%S)

function _install_font() {
    tmpfile=$(mktemp)
    fname=$(basename $1)
    fbname=${fname%.*}

    if [ -d "$USER_FONTS_HOME/$fbname" ]; then
        echo "$USER_FONTS_HOME/$fbname already exists. Installation aborted."
        return
    fi

    wget "$1" -O $tmpfile
    mkdir -p $USER_FONTS_HOME
    case $1 in
        *.zip) unzip -o -d $USER_FONTS_HOME/$fbname $tmpfile ;;
    esac
    rm $tmpfile
}

function _stoh() {
    if [ -L $2 ]; then
        if [ $(readlink -f $2) == $1 ]; then
            echo -e "$2 ${GREEN}already exists${NC}"
            return 1
        else
            _backup $2
        fi
    fi

    if [ -e $2 ]; then
        _backup $2
    fi

    if [[ ! -e $1 ]]; then
        echo -e "$1 not exists"
        return
    fi

    ln -s $1 $2
    echo -e "link $1 -> $2 ${GREEN}ok${NC}"
}

function _backup() {
    mkdir -p $BACKUP_DIR
    echo "backup $1 to ${BACKUP_DIR}"
    mv $1 $BACKUP_DIR
}

function bootstrap_config() {
    mkdir -p $XDG_CONFIG_HOME
    _stoh "$HOME/dotfiles/alacritty" "$HOME/.config/alacritty"
    _stoh "$HOME/dotfiles/awesome" "$HOME/.config/awesome"
    _stoh "$HOME/dotfiles/bash/.bashrc" "$HOME/.bashrc"
    _stoh "$HOME/dotfiles/ctags/.ctags.d" "$HOME/.ctags.d"
    _stoh "$HOME/dotfiles/kitty" "$HOME/.config/kitty"
    _stoh "$HOME/dotfiles/neofetch" "$HOME/.config/neofetch"
    _stoh "$HOME/dotfiles/nvim" "$HOME/.config/nvim"
    _stoh "$HOME/dotfiles/picom" "$HOME/.config/picom"
    _stoh "$HOME/dotfiles/qtile" "$HOME/.config/qtile"
    _stoh "$HOME/dotfiles/ranger" "$HOME/.config/ranger"
    _stoh "$HOME/dotfiles/rofi" "$HOME/.config/rofi"
    _stoh "$HOME/dotfiles/vim/.vimrc" "$HOME/.vimrc"
    _stoh "$HOME/dotfiles/wezterm" "$HOME/.config/wezterm"
    _stoh "$HOME/dotfiles/x11/.Xresources" "$HOME/.Xresources"
    _stoh "$HOME/dotfiles/x11/.xinitrc" "$HOME/.xinitrc"
    _stoh "$HOME/dotfiles/xmobar" "$HOME/.config/xmobar"
    _stoh "$HOME/dotfiles/xmonad" "$HOME/.config/xmonad"
    _stoh "$HOME/dotfiles/zsh/.zimrc" "$HOME/.zimrc"
    _stoh "$HOME/dotfiles/zsh/.zshrc" "$HOME/.zshrc"
}

bootstrap_config
./git/config.sh
_install_font https://github.com/ryanoasis/nerd-fonts/releases/download/v2.3.3/JetBrainsMono.zip
_install_font https://github.com/ryanoasis/nerd-fonts/releases/download/v2.3.3/Ubuntu.zip
_install_font https://github.com/lxgw/LxgwWenKai/releases/download/v1.300/lxgw-wenkai-v1.300.zip 
