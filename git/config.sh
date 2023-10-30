#!/usr/bin/env bash

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

if command -v nvim &> /dev/null; then
    git config --global core.editor "nvim"
fi

