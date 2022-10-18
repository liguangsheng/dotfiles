#!/bin/bash

if [ -d build ]; then rm -rf build; fi
BUILDKIT_PROGRESS=auto DOCKER_BUILDKIT=1 docker build --file Dockerfile --output . .
(cd build && sudo make install)
which vim
vim --version
if [ -d build ]; then rm -rf build; fi

