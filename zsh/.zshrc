# ;; -*- mode: shell-script; -*-
# vim:ft=sh

function include() { [[ -f "$1" ]] && source "$1" }

export XDG_BIN_HOME="$HOME/.local/bin"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"
export ZSH_CACHE_DIR="$HOME/.cache/zsh"
export EDITOR="vi"
export PATH=/sbin:/usr/local/bin:$XDG_BIN_HOME:$HOME/dotfiles/bin:$ZSH_CACHE_DIR/completions/:$PATH

mkdir -p $XDG_STATE_HOME/zsh
mkdir -p $ZSH_CACHE_DIR/completions/

HISTFILE=$XDG_STATE_HOME/zsh/zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt NO_NOMATCH
setopt BANG_HIST                 # Treat the '!' character specially during expansion.
setopt EXTENDED_HISTORY          # Write the history file in the ":start:elapsed;command" format.
setopt INC_APPEND_HISTORY        # Write to the history file immediately, not when the shell exits.
setopt SHARE_HISTORY             # Share history between all sessions.
setopt HIST_EXPIRE_DUPS_FIRST    # Expire duplicate entries first when trimming history.
setopt HIST_IGNORE_DUPS          # Don't record an entry that was just recorded again.
setopt HIST_IGNORE_ALL_DUPS      # Delete old recorded entry if new entry is a duplicate.
setopt HIST_FIND_NO_DUPS         # Do not display a line previously found.
setopt HIST_IGNORE_SPACE         # Don't record an entry starting with a space.
setopt HIST_SAVE_NO_DUPS         # Don't write duplicate entries in the history file.
setopt HIST_REDUCE_BLANKS        # Remove superfluous blanks before recording entry.
setopt HIST_VERIFY               # Don't execute immediately upon history expansion.
setopt HIST_BEEP                 # Beep when accessing nonexistent history.

bindkey -e
# autoload -Uz compinit
# compinit

include $HOME/dotfiles/zsh/.zimsetup

alias dus='sudo du -h -d 1 | sort -h'
alias dur='sudo du -h -d 1 --exclude=proc | sort -h'

# `starship' as prompt
if [[ -n $DISPLAY ]]; then
    export STARSHIP_CONFIG=~/dotfiles/starship/starship_gui.toml
else
    export STARSHIP_CONFIG=~/dotfiles/starship/starship_tty.toml
fi
command -v starship &> /dev/null &&  eval "$(starship init zsh)"

# `zoxide' as better `cd'
command -v zoxide &> /dev/null && eval "$(zoxide init zsh)"

# `lsd' or `exa' as better ls
alias gls='/usr/bin/ls'
if command -v lsd &> /dev/null; then
    alias l='lsd -l'
    alias ls='lsd'
    alias ll='lsd -lA --header'
    alias l1='lsd -1'
    alias la='lsd -la'
    alias tree='lsd --tree --depth=2'
elif command -v exa &> /dev/null; then
    alias ls='exa'
    alias ll='exa -labF --git'
    alias l1='exa -1'
    alias la='exa -lbhHigUmuSa --time-style=long-iso --git --color-scale'
    alias tree='exa --tree --level=2'
else
    alias ls='ls --color'
    alias ll='ls -l'
    alias l1='ls -1'
    alias la='ls -la'
fi

# `bat' as better cat
if command -v bat &> /dev/null; then
    alias _cat='/usr/bin/cat'
    alias cat='bat'
fi

# thefuck
if command -v thefuck &> /dev/null; then
    eval $(thefuck --alias)
fi

# Translate caser
alias upper='tr "a-z" "A-Z"'
alias lower='tr "A-Z" "a-z"'

# vim
if command -v vim &> /dev/null; then
    alias vi='vim'
    export EDITOR='vim'
fi

# neovim
if command -v nvim &> /dev/null; then
    alias vi='nvim'
    export EDITOR='nvim'
fi

# emacs
export EMACS_SOCKET_NAME="$HOME/.emacs.d/var/server/server"
alias e='emacsclient --no-wait'

# aliases
alias sudo='sudo env PATH=$PATH'
alias proxy="http_proxy=http://127.0.0.1:1081 https_proxy=http://127.0.0.1:1081 "
alias cclip="xclip -selection c"

# git
function gcof() {git checkout `git diff --name-only | fzf`}
alias git_proxy="git -c https.proxy='127.0.0.1:1081' -c https.proxy='127.0.0.1:1081'"
alias gacn!="git add --all && git commit -v --amend --no-edit"
alias gac.="git add --all && git commit -m ."
alias gac.p="git add --all && git commit -m . && git push -f"
alias gacp!="git add --all && git commit -v --amend --no-edit && git push -f"
unalias g
g() { [ "$#" -eq 0 ] && git status || git "$@"; }

# kubectl
export KUBECONFIG="$HOME/.kube/config"

# stern
alias stern0='stern --tail 0'

# rust
export RUSTUP_DIST_SERVER=https://mirrors.ustc.edu.cn/rust-static
export RUSTUP_UPDATE_ROOT=https://mirrors.ustc.edu.cn/rust-static/rustup
export RUST_BACKTRACE=1
export PATH="$HOME/.cargo/bin:$HOME/.rustup/toolchains/stable-x86_64-unknown-linux-gnu/bin:$PATH"
include $HOME/.cargo/env

# go
alias goproxy="GOPROXY=https://goproxy.cn/ "
export GOROOT="$HOME/.go/current"
export GOPATH="$HOME/go"
export GOBIN="$GOPATH/bin"
export GO111MODULE="on"
export PATH="$PATH:$GOBIN"
include $HOME/.go/env

# haskell
include $HOME/.ghcup/env

# lua
export PATH="$PATH:$HOME/.luarocks/bin"

# nvm
export NVM_DIR="$HOME/.nvm"
include $NVM_DIR/nvm.sh
include $NVM_DIR/bash_completion

# envman(docker)
include $HOME/.config/envman/load.sh

# private
include $HOME/private/env
include $HOME/private/party/env

# p4 command
export PATH=$PATH:/opt/p4

alias code="flatpak run com.visualstudio.code"

typeset -U PATH
