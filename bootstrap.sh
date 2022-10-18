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
	_stoh "$HOME/dotfiles/.Xresources" "$HOME/.Xresources"
	_stoh "$HOME/dotfiles/.bashrc" "$HOME/.bashrc"
	_stoh "$HOME/dotfiles/.config/alacritty" "$HOME/.config/alacritty"
	_stoh "$HOME/dotfiles/.config/awesome" "$HOME/.config/awesome"
	_stoh "$HOME/dotfiles/.config/xmonad" "$HOME/.config/xmonad"
	_stoh "$HOME/dotfiles/.config/xmobar" "$HOME/.config/xmobar"
	_stoh "$HOME/dotfiles/.config/kitty" "$HOME/.config/kitty"
	_stoh "$HOME/dotfiles/.config/neofetch" "$HOME/.config/neofetch"
	_stoh "$HOME/dotfiles/.config/nvim" "$HOME/.config/nvim"
	_stoh "$HOME/dotfiles/.config/picom" "$HOME/.config/picom"
	_stoh "$HOME/dotfiles/.config/qtile" "$HOME/.config/qtile"
	_stoh "$HOME/dotfiles/.config/ranger" "$HOME/.config/ranger"
	_stoh "$HOME/dotfiles/.config/rofi" "$HOME/.config/rofi"
	_stoh "$HOME/dotfiles/.config/wezterm" "$HOME/.config/wezterm"
	_stoh "$HOME/dotfiles/.ctags.d" "$HOME/.ctags.d"
	_stoh "$HOME/dotfiles/.vimrc" "$HOME/.vimrc"
	_stoh "$HOME/dotfiles/.xinitrc" "$HOME/.xinitrc"
	_stoh "$HOME/dotfiles/zsh/.zimrc" "$HOME/.zimrc"
	_stoh "$HOME/dotfiles/zsh/.zshrc" "$HOME/.zshrc"
}

function bootstrap_packages() {
	if command -v go >/dev/null; then
		go install github.com/cweill/gotests/gotests@latest
		go install github.com/daixiang0/gci@v0.4.2
		go install github.com/davidrjenni/reftools/cmd/fillstruct@latest
		go install github.com/fatih/gomodifytags@latest
		go install github.com/go-delve/delve/cmd/dlv@latest
		go install github.com/josharian/impl@latest
		go install github.com/sqs/goreturns@latest
		go install golang.org/x/lint/golint@latest
		go install golang.org/x/tools/cmd/goimports@latest
		go install golang.org/x/tools/cmd/gomvpkg@latest
		go install golang.org/x/tools/cmd/gorename@latest
		go install golang.org/x/tools/cmd/stringer@latest
		go install golang.org/x/tools/gopls@latest
		go install mvdan.cc/sh/v3/cmd/shfmt@latest
		go install mvdan.cc/gofumpt@latest
	else
		echo "go not found"
	fi

	if command -v pip >/dev/null; then
		pip install --user psutil requests beautysh
	else
		echo "pip not found"
	fi

	if command -v cargo >/dev/null; then
		cargo install du-dust fselect
	else
		echo "cargo not found"
	fi
}


function bootstrap_gitconfig() {
	echo "bootstrap git config"
	git config --global alias.aa 'add -all'
	git config --global alias.br branch
	git config --global alias.ci commit
	git config --global alias.cm 'commit -m'
	git config --global alias.co checkout
	git config --global alias.df 'diff'
	git config --global alias.last 'log -1 HEAD --stat'
	git config --global alias.ll 'log --oneline'
	git config --global alias.pr 'pull --rebase'
	git config --global alias.rh 'reset --hard'
	git config --global alias.rv 'remote -v'
	git config --global alias.sb 'status -sb'
	git config --global alias.se '!git rev-list --all | xargs git grep -F'
	git config --global alias.st status
	git config --global core.autocrlf false
	git config --global credential.helper store
	git config --global help.autocorrect 20
	git config --global init.defaultBranch main
	git config --global pull.ff only
	git config --global push.autoSetupRemote true
	git config --global user.name liguangsheng
}

bootstrap_config
bootstrap_gitconfig
_install_font https://github.com/ryanoasis/nerd-fonts/releases/download/v2.3.3/JetBrainsMono.zip
_install_font https://github.com/ryanoasis/nerd-fonts/releases/download/v2.3.3/Ubuntu.zip
_install_font https://github.com/lxgw/LxgwWenKai/releases/download/v1.300/lxgw-wenkai-v1.300.zip 
