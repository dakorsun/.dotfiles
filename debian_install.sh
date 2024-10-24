#!/usr/bin/env bash

# --- Variables ---
NEOVIM_VERSION="stable"  # Set 'stable' for the latest release, or specify a version (e.g., 'v0.9.0')
NEOVIM_DIR="$HOME/neovim"
DOTFILES="$HOME/.dotfiles"
STOW_FOLDERS="bin,nvim,tmux,debian,zsh"
OH_MY_ZSH_INSTALL_URL="https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh"

# --- Functions ---
install_zsh() {
    echo "Installing Zsh and setting it as the default shell..."
    sudo apt update
    sudo apt install -y zsh

    # Install Oh My Zsh
    if [ ! -d "$HOME/.oh-my-zsh" ]; then
        echo "Installing Oh My Zsh..."
        sh -c "$(curl -fsSL $OH_MY_ZSH_INSTALL_URL)" --unattended
    else
        echo "Oh My Zsh is already installed."
    fi

    # Change the default shell to Zsh
    chsh -s $(which zsh)

    # Symlink Zsh config from dotfiles
    if [ -f "$HOME/.zshrc" ]; then
        mv "$HOME/.zshrc" "$HOME/.zshrc.backup"
        echo "Existing .zshrc moved to .zshrc.backup"
    fi
    ln -s "$DOTFILES/zsh/.zshrc" "$HOME/.zshrc"
    ln -s "$DOTFILES/zsh/.zsh_profile" "$HOME/.zsh_profile"

    echo -e "\nZsh is installed and set as the default shell."
    echo -e "\nPlease close this terminal and open a new one for Zsh to take effect."
    echo -e "\nAfter reopening, rerun this script to continue with Neovim installation and stow setup.\n"
}

install_neovim() {
    echo "Installing dependencies for building Neovim..."
    sudo apt install -y ninja-build gettext cmake unzip curl git build-essential libtool libtool-bin autoconf automake pkg-config

    # Clone and Build Neovim
    echo "Cloning Neovim repository..."
    if [ -d "$NEOVIM_DIR" ]; then
        echo "Neovim directory already exists, pulling latest changes..."
        cd "$NEOVIM_DIR" && git pull
    else
        git clone https://github.com/neovim/neovim.git "$NEOVIM_DIR"
        cd "$NEOVIM_DIR"
    fi
    git checkout $NEOVIM_VERSION
    make CMAKE_BUILD_TYPE=Release
    sudo make install

    # Alias Neovim
    if ! grep -q "alias nvim=" ~/.zshrc; then
        echo "alias nvim='/usr/local/bin/nvim'" >> ~/.zshrc
        echo "Neovim alias added to ~/.zshrc"
        source ~/.zshrc
    fi

    # Install dependencies for Neovim plugins
    echo "Installing dependencies for Neovim plugins..."
    sudo apt install -y ripgrep fzf nodejs python3-pip
    sudo npm install -g neovim
    pip3 install --user pynvim

    # Install LazyVim (plugin manager)
    echo "Setting up LazyVim plugin manager..."
    if [ ! -d "$HOME/.local/share/nvim/site/pack/packer/start/packer.nvim" ]; then
        git clone --depth 1 https://github.com/wbthomason/packer.nvim ~/.local/share/nvim/site/pack/packer/start/packer.nvim
    fi

    # Clone LazyVim starter config
    if [ ! -d "$HOME/.config/nvim" ]; then
        git clone https://github.com/LazyVim/starter ~/.config/nvim
    fi
    echo "Neovim setup complete!"
}

run_stow() {
    echo "Running Stow for configuration files..."
    pushd "$DOTFILES"
    for folder in $(echo $STOW_FOLDERS | sed "s/,/ /g")
    do
        echo "Stowing $folder"
        stow $folder
    done
    popd
    echo "Stow configuration complete!"
}

setup_folders() {
    echo "Creating necessary directories..."
    mkdir -p ~/personal/junk ~/personal/tutors ~/projects ~/work ~/.config/fontconfig/conf.d
}

# --- Main Setup Logic ---
if [ "$SHELL" != "$(which zsh)" ]; then
    echo "Zsh is not the current shell. Starting with Zsh installation..."
    install_zsh
    exit 0  # Stop the script so the user can reopen the terminal in Zsh
else
    echo "Zsh is already the default shell. Continuing with Neovim installation and stow setup..."
    setup_folders
    install_neovim
    run_stow
    echo "Setup complete! Please restart your terminal for changes to take full effect."
fi
