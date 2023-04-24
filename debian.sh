#!/usr/bin/env bash

USER_HOME=$(getent passwd ${SUDO_USER:-$USER} | cut -d: -f6)

if [[ -z $STOW_FOLDERS ]]; then
    STOW_FOLDERS="bin,nvim,tmux,debian,zsh"
fi

if [[ -z $DOTFILES ]]; then
    DOTFILES=$USER_HOME/.dotfiles
fi

STOW_FOLDERS=$STOW_FOLDERS DOTFILES=$DOTFILES $DOTFILES/debian_install.sh && $DOTFILES/stow.sh
