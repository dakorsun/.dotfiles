#!/usr/bin/env bash

DOTFILES="$HOME/.dotfiles"
STOW_FOLDERS="systemd,bash,vim,nvim,X,i3"

echo ''
echo 'Run stow'
if ! pacman -Qi stow &>/dev/null; then
    echo "Stow is not installed. Installing Stow..."
   sudo pacman -S stow 
else
    echo "Stow is already installed."
fi

echo "Running Stow for configuration files..."
pushd "$DOTFILES"
for folder in $(echo $STOW_FOLDERS | sed "s/,/ /g"); do
    echo "Stowing $folder"
    stow $folder
done
popd
echo "Stow configuration complete!"
