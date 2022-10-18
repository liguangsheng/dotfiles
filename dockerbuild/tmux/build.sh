#!/bin/bash

if [ -d build ]; then rm -rf build; fi
BUILDKIT_PROGRESS=plain DOCKER_BUILDKIT=1 docker build --file Dockerfile --output . .
cp ./build/tmux $HOME/.local/bin
which tmux
if [ -d build ]; then rm -rf build; fi
