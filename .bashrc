shopt -s histappend
shopt -s checkwinsize
shopt -s globstar

HISTCONTROL=ignoredups
HISTSIZE=5000
HISTFILESIZE=10000

function include() {
    [[ -f "$1" ]] && source "$1"
}

alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias l='ls -la'
alias ll='ls -l'
alias ls='ls --color=auto'
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
alias ..="cd .."

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

export PATH="$PATH:$HOME/.local/bin"

# 16 color prompt
# export PS1='[\[\033[31m\]\u@\[\033[34m\]\h \[\033[36m\]\w]$ '
# 256 color prompt
export PS1='[\[\e[38;5;135m\]\u\[\e[0m\]@\[\e[38;5;166m\]\h\[\e[0m\] \[\e[38;5;118m\]\w\[\e[0m\]] $ '

# editor
export EDITOR='vim'

# thefuck
command -v thefuck &> /dev/null && eval "$(thefuck --alias)"

# zoxide as better "cd"
command -v zoxide &> /dev/null && eval "$(zoxide init bash)"

# starship as better prompt
# command -v starship &> /dev/null && eval "$(starship init bash)"

# git
alias g='git'
alias gst='git status'
alias gco='git checkout'
alias gpl='git pull --rebase'
alias gcn!='git add --all && git commit --amend --no-edit'
alias gacp!='git add --all && git commit --amend --no-edit && git push -f'
alias grb='git rebase'
alias gpf='git push -f'

# golang
export GOPATH="$HOME/.go/current"
export GOROOT="$HOME/go"
export PATH="$PATH:$GOROOT/bin"
include $HOME/.go/env

# rust
include $HOME/.cargo/env

# emacs
export EMACS_SERVER_FILE='$HOME/.emacs.d/server/server'
export ALTERNATE_EDITOR='vim'
alias e='emacsclient --no-wait'

# kubectl
alias k='kubectl'
alias kps='kubectl get pods'
alias kcgc='kubectl config get-contexts'
alias kcuc='kubectl config use-context $1'
function kexec {
    pod=`kps | tail -n +2 | fzf | awk '{print $1}'`
    kubectl exec -it $pod -- /bin/bash
}
function klogs {
    pod=`kubectl get pods | tail -n +2 | fzf | awk '{print $1}'`
    kubectl logs -f $pod
}

# print colors
function list_colors {
  for C in {0..255}; do
    tput setab $C
    echo -n "$C "
  done
  tput sgr0
  echo
}

# Generated for envman. Do not edit.
[ -s "$HOME/.config/envman/load.sh" ] && source "$HOME/.config/envman/load.sh"

include $HOME/.ghcup/env
