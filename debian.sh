#!/usr/bin/env bash

mkdir ~/personal/ ~/personal/junk/ ~/personal/tutors/ ;
mkdir ~/projects/ ;
mkdir ~/work/ ;
mkdir ~/.config/fontconfig/ ~/.config/fontconfig/conf.d/ ;

# USER_HOME=$(getent passwd ${SUDO_USER:-$USER} | cut -d: -f7)

if [[ -z $STOW_FOLDERS ]]; then
    STOW_FOLDERS="bin,nvim,tmux,debian,zsh"
fi

if [[ -z $DOTFILES ]]; then
    DOTFILES=$USER_HOME/.dotfiles
fi

STOW_FOLDERS=$STOW_FOLDERS DOTFILES=$DOTFILES $DOTFILES/debian_install.sh && $DOTFILES/stow.sh
