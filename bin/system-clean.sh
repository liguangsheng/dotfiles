#!/bin/bash

# 清理systemd日志
if command -v journalctl &> /dev/null; then
	echo "---> cleaning systemd journal"
	sudo journalctl --vacuum-time=3d
fi

# 清理pacman缓存
if command -v paru &> /dev/null; then
    echo "---> cleaning pacman"
    yes | paru -R $(pacman -Qdtq)
    yes | paru -Sccd
fi

# 清理zypper
if command -v zypper &> /dev/null; then
    echo "---> cleaning zypper"
    sudo zypper clean --all
    sudo zypper purge-kernels
fi

# 清理dnf
if command -v dnf &> /dev/null; then
    echo "---> cleaning dnf"
    sudo dnf clean all
fi

# 清理go缓存
if command -v go &> /dev/null; then
	echo "---> cleaning go cache"
	go clean -cache -testcache -modcache -fuzzcache
fi

# 清理rust缓存
if command -v rustup &> /dev/null; then
    if ! rustup toolchain list | grep "no installed toolchains"; then
        if command -v cargo &> /dev/null; then
            if ! cargo --list | grep cache &> /dev/null; then
                echo "installing cargo-cache"
                cargo install cargo-cache
            fi
            echo "---> cleaning cargo cache"
            cargo cache -a --remove-dir all
        fi

        echo "---> cleaning rustup toolchain"
        rustup toolchain remove stable
        rustup toolchain remove nightly
    fi
fi

# 清理pip
if command -v pip &> /dev/null; then
    echo "---> cleaning pip cache"
    pip cache purge
fi

# 清理npm
if command -v npm &> /dev/null; then
    echo "---> cleaning npm cache"
    npm cache clean --force
fi

# 清理docker
if command -v docker &> /dev/null; then
    echo "---> cleaning docker cache"
    docker system prune -af
fi

# 清理gopls
if [ -d $HOME/.cache/gopls ]; then
    echo "---> cleaning gopls cache"
    rm -rf $HOME/.cache/gopls
fi
