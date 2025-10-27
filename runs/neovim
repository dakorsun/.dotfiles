#! /usr/bin/env bash

sudo pacman -S base-devel cmake ninja curl git lua51 luarocks lazygit go

rm -rf $HOME/downloads/neovim
git clone -b v0.10.4 https://github.com/neovim/neovim.git $HOME/downloads/neovim
cd $HOME/downloads/neovim

rm -r build/ # clear the CMake cache
#make CMAKE_BUILD_TYPE=Release
make CMAKE_BUILD_TYPE=Release CMAKE_EXTRA_FLAGS="-DCMAKE_INSTALL_PREFIX=$HOME/neovim"
make install

export PATH="$HOME/neovim/bin:$PATH"
