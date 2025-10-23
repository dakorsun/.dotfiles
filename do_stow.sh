#!/usr/bin/env zsh

DOTFILES="$HOME/.dotfiles"
STOW_FOLDERS="bin,nvim,tmux,debian,zsh,lazygit"

echo ''
echo 'Run stow'
if ! command -v stow &>/dev/null; then
    echo "Stow is not installed. Installing Stow..."
    sudo apt update
    sudo apt install -y stow
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
