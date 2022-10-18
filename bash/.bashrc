shopt -s histappend
shopt -s checkwinsize
shopt -s globstar

HISTCONTROL=ignoredups
HISTSIZE=5000
HISTFILESIZE=10000

function include() {
    [[ -s "$1" ]] && source "$1"
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
export PS1='[\[\e[38;5;135m\]\u\[\e[0m\]@\[\e[38;5;166m\]\h\[\e[0m\]:\[\e[38;5;118m\]\w\[\e[0m\]] $ '

# editor
export EDITOR='vi'
command -v vim &> /dev/null && alias vi='vim'
command -v nvim &> /dev/null && alias vi='nvim'

# thefuck
command -v thefuck &> /dev/null && eval "$(thefuck --alias)"

# zoxide as better "cd"
command -v zoxide &> /dev/null && eval "$(zoxide init bash)"

# starship as better prompt
command -v starship &> /dev/null && eval "$(starship init bash)"

# git
alias g='git'
alias ga='git add'
alias gaa='git add --all'
alias gacp!='git add --all && git commit --amend --no-edit && git push -f'
alias gc!='git commit --verbose --amend'
alias gcB='git checkout -B'
alias gcb='git checkout -b'
alias gclean='git clean --interactive -d'
alias gcn!='git add --all && git commit --amend --no-edit'
alias gcn!='git commit --verbose --no-edit --amend'
alias gco='git checkout'
alias gcor='git checkout --recurse-submodules'
alias gcpa='git cherry-pick --abort'
alias gcpc='git cherry-pick --continue'
alias gpf='git push -f'
alias gpr='git pull --rebase'
alias grb='git rebase'
alias grba='git rebase --abort'
alias grbc='git rebase --continue'
alias grbi='git rebase --interactive'
alias grhh='git reset --hard'
alias gst='git status'

# golang
export GOPATH="$HOME/.go/current"
export GOROOT="$HOME/go"
export PATH="$PATH:$GOROOT/bin"
include $HOME/.go/env

# rust
include $HOME/.cargo/env

# haskell
include $HOME/.ghcup/env

# emacs
export EMACS_SERVER_FILE='$HOME/.emacs.d/server/server'
export ALTERNATE_EDITOR='vi'
alias e='emacsclient --no-wait'

# docker
include "$HOME/.config/envman/load.sh"

# kubectl
alias k=kubectl
alias kca='_kca(){ kubectl "$@" --all-namespaces;  unset -f _kca; }; _kca'
alias kaf='kubectl apply -f'
alias keti='kubectl exec -t -i'
alias kcuc='kubectl config use-context'
alias kcsc='kubectl config set-context'
alias kcdc='kubectl config delete-context'
alias kccc='kubectl config current-context'
alias kcgc='kubectl config get-contexts'
alias kdel='kubectl delete'
alias kdelf='kubectl delete -f'
alias kgp='kubectl get pods'
alias kgpa='kubectl get pods --all-namespaces'
alias kgpw='kgp --watch'
alias kgpwide='kgp -o wide'
alias kep='kubectl edit pods'
alias kdp='kubectl describe pods'
alias kdelp='kubectl delete pods'
alias kgpall='kubectl get pods --all-namespaces -o wide'
alias kgpl='kgp -l'
alias kgpn='kgp -n'
alias kgs='kubectl get svc'
alias kgsa='kubectl get svc --all-namespaces'
alias kgsw='kgs --watch'
alias kgswide='kgs -o wide'
alias kes='kubectl edit svc'
alias kds='kubectl describe svc'
alias kdels='kubectl delete svc'
alias kgi='kubectl get ingress'
alias kgia='kubectl get ingress --all-namespaces'
alias kei='kubectl edit ingress'
alias kdi='kubectl describe ingress'
alias kdeli='kubectl delete ingress'
alias kgns='kubectl get namespaces'
alias kens='kubectl edit namespace'
alias kdns='kubectl describe namespace'
alias kdelns='kubectl delete namespace'
alias kcn='kubectl config set-context --current --namespace'
alias kgcm='kubectl get configmaps'
alias kgcma='kubectl get configmaps --all-namespaces'
alias kecm='kubectl edit configmap'
alias kdcm='kubectl describe configmap'
alias kdelcm='kubectl delete configmap'
alias kgsec='kubectl get secret'
alias kgseca='kubectl get secret --all-namespaces'
alias kdsec='kubectl describe secret'
alias kdelsec='kubectl delete secret'
alias kgd='kubectl get deployment'
alias kgda='kubectl get deployment --all-namespaces'
alias kgdw='kgd --watch'
alias kgdwide='kgd -o wide'
alias ked='kubectl edit deployment'
alias kdd='kubectl describe deployment'
alias kdeld='kubectl delete deployment'
alias ksd='kubectl scale deployment'
alias krsd='kubectl rollout status deployment'
alias kgrs='kubectl get replicaset'
alias kdrs='kubectl describe replicaset'
alias kers='kubectl edit replicaset'
alias krh='kubectl rollout history'
alias kru='kubectl rollout undo'
alias kgss='kubectl get statefulset'
alias kgssa='kubectl get statefulset --all-namespaces'
alias kgssw='kgss --watch'
alias kgsswide='kgss -o wide'
alias kess='kubectl edit statefulset'
alias kdss='kubectl describe statefulset'
alias kdelss='kubectl delete statefulset'
alias ksss='kubectl scale statefulset'
alias krsss='kubectl rollout status statefulset'
alias kpf="kubectl port-forward"
alias kga='kubectl get all'
alias kgaa='kubectl get all --all-namespaces'
alias kl='kubectl logs'
alias kl1h='kubectl logs --since 1h'
alias kl1m='kubectl logs --since 1m'
alias kl1s='kubectl logs --since 1s'
alias klf='kubectl logs -f'
alias klf1h='kubectl logs --since 1h -f'
alias klf1m='kubectl logs --since 1m -f'
alias klf1s='kubectl logs --since 1s -f'
alias kcp='kubectl cp'
alias kgno='kubectl get nodes'
alias keno='kubectl edit node'
alias kdno='kubectl describe node'
alias kdelno='kubectl delete node'
alias kgpvc='kubectl get pvc'
alias kgpvca='kubectl get pvc --all-namespaces'
alias kgpvcw='kgpvc --watch'
alias kepvc='kubectl edit pvc'
alias kdpvc='kubectl describe pvc'
alias kdelpvc='kubectl delete pvc'
alias kdsa="kubectl describe sa"
alias kdelsa="kubectl delete sa"
alias kgds='kubectl get daemonset'
alias kgdsa='kubectl get daemonset --all-namespaces'
alias kgdsw='kgds --watch'
alias keds='kubectl edit daemonset'
alias kdds='kubectl describe daemonset'
alias kdelds='kubectl delete daemonset'
alias kgcj='kubectl get cronjob'
alias kecj='kubectl edit cronjob'
alias kdcj='kubectl describe cronjob'
alias kdelcj='kubectl delete cronjob'
alias kgj='kubectl get job'
alias kej='kubectl edit job'
alias kdj='kubectl describe job'
alias kdelj='kubectl delete job'
function kres(){
  kubectl set env $@ REFRESHED_AT=$(date +%Y%m%d%H%M%S)
}

