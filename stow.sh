#!/usr/bin/env bash

mkdir ~/personal/ ~/personal/junk/ ~/personal/tutors/ ;
mkdir ~/projects/ ;
mkdir ~/work/ ;
mkdir ~/.config/fontconfig/ ~/.config/fontconfig/conf.d/ ;


# --- Check and install Stow ---
if ! command -v stow &> /dev/null
then
    echo "Stow is not installed. Installing Stow..."
    sudo apt update
    sudo apt install -y stow
else
    echo "Stow is already installed."
fi

# --- Proceed with dotfiles stowing ---
STOW_FOLDERS="bin,nvim,tmux,debian,zsh"
DOTFILES="$HOME/.dotfiles"

echo "Stowing dotfiles from $DOTFILES"

pushd $DOTFILES
for folder in $(echo $STOW_FOLDERS | sed "s/,/ /g")
do
    echo "stow $folder"
    # stow -D $folder
    stow $folder
done
popd
