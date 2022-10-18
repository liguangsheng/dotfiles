#!/usr/bin/env bash

function install {
  if [[ -f $1 ]]; then 
    mkdir -p $2
    mv -f $1 $2
    echo $1 moved to $2
  else
    echo $1 not found.
  fi
}

BUILDKIT_PROGRESS=plain DOCKER_BUILDKIT=1 docker build --file Dockerfile --output . .

install bin/xmonad              $HOME/.local/bin
install bin/xmonad-x86_64-linux $HOME/.cache/xmonad
