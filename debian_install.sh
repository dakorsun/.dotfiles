#!/usr/bin/env bash

# --- Variables ---
NEOVIM_VERSION="stable"  # Set 'stable' for the latest release, or specify a version (e.g., 'v0.9.0')
NEOVIM_DIR="$HOME/neovim"
DOTFILES="$HOME/.dotfiles"
STOW_FOLDERS="bin,nvim,tmux,debian,zsh"
OH_MY_ZSH_INSTALL_URL="https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh"

# --- Font Variables ---
FONT_DIR="$HOME/.fonts"
FONT_CONFIG_DIR="$HOME/.config/fontconfig/conf.d"
NERD_FONTS_DIR="$FONT_DIR/Nerd_Fonts"
NERD_FONTS_VERSION="v2.3.3"
NERD_FONTS=("3270" "FiraCode" "Hack" "RobotoMono")  # Add more fonts to the array if needed
POWERLINE_FONT_URL="https://github.com/powerline/powerline/raw/develop/font/PowerlineSymbols.otf"
POWERLINE_CONF_URL="https://github.com/powerline/powerline/raw/develop/font/10-powerline-symbols.conf"


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
    if ! command -v stow &> /dev/null
    then
        echo "Stow is not installed. Installing Stow..."
        sudo apt update
        sudo apt install -y stow
    else
        echo "Stow is already installed."
    fi

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

install_node() {
# --- Install NVM (Node Version Manager) ---
if [ ! -d "$HOME/.nvm" ]; then
    echo "Installing NVM..."
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash

    # Load NVM into the current shell session
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

    echo "NVM installed."
else
    echo "NVM is already installed."
fi

# --- Install Node.js via NVM (Latest 18.x) ---
if ! command -v node &> /dev/null; then
    echo "Installing Node.js (latest 18.x)..."
    nvm install 18
    nvm use 18
else
    echo "Node.js is already installed."
fi
}

setup_folders() {
    echo "Creating necessary directories..."
    mkdir -p ~/personal/junk ~/personal/tutors ~/projects ~/work ~/.config/fontconfig/conf.d
}
# --- Functions ---

install_powerline_fonts() {
    echo "Installing Powerline fonts and configuration..."

    # Download Powerline font and configuration
    wget $POWERLINE_FONT_URL -O PowerlineSymbols.otf
    wget $POWERLINE_CONF_URL -O 10-powerline-symbols.conf

    # Create necessary directories
    mkdir -p "$FONT_DIR" "$FONT_CONFIG_DIR"

    # Move files to appropriate directories
    mv PowerlineSymbols.otf "$FONT_DIR/"
    mv 10-powerline-symbols.conf "$FONT_CONFIG_DIR/"

    echo "Powerline fonts installed."
}

install_nerd_fonts() {
    echo "Installing Nerd Fonts..."

    # Create fonts directory if it doesn't exist
    mkdir -p "$NERD_FONTS_DIR"

    # Loop through the selected Nerd Fonts to download and install each
    for font in "${NERD_FONTS[@]}"; do
        FONT_ZIP_URL="https://github.com/ryanoasis/nerd-fonts/releases/download/$NERD_FONTS_VERSION/${font}.zip"
        FONT_ZIP_PATH="$HOME/Downloads/Nerd_${font}.zip"

        # Download the Nerd Font
        echo "Downloading $font font..."
        wget "$FONT_ZIP_URL" -O "$FONT_ZIP_PATH"

        # Unzip the font to the fonts directory
        echo "Unzipping $font to $NERD_FONTS_DIR..."
        unzip -o "$FONT_ZIP_PATH" -d "$NERD_FONTS_DIR"

        # Cleanup
        rm "$FONT_ZIP_PATH"
    done

    echo "Nerd Fonts installed."
}

rebuild_font_cache() {
    echo "Rebuilding font cache..."
    fc-cache -fv
    echo "Font cache rebuilt."
}

verify_fonts_installed() {
    echo "Verifying installed fonts..."

    # List installed fonts to check if Powerline and Nerd Fonts are available
    if fc-list | grep -q "PowerlineSymbols"; then
        echo "Powerline symbols installed successfully."
    else
        echo "Powerline symbols installation failed."
    fi

    for font in "${NERD_FONTS[@]}"; do
        if fc-list | grep -q "$font"; then
            echo "$font Nerd Font installed successfully."
        else
            echo "Failed to install $font Nerd Font."
        fi
    done
}

install_fonts(){
# --- Main Logic ---

# Install Powerline fonts and Nerd Fonts
install_powerline_fonts
install_nerd_fonts

# Rebuild the font cache to apply changes
rebuild_font_cache

# Verify the installation of fonts
verify_fonts_installed
}

# --- Main Setup Logic ---
if [ "$SHELL" != "$(which zsh)" ]; then
    echo "Zsh is not the current shell. Starting with Zsh installation..."
    install_zsh
    exit 0  # Stop the script so the user can reopen the terminal in Zsh
else
    echo "Zsh is already the default shell. Continuing with Neovim installation and stow setup..."
    run_stow
    install_node
    install_neovim
    setup_folders
    install_fonts
    echo "Setup complete! Please restart your terminal for changes to take full effect."
fi
