#!/usr/bin/env bash

# --- Variables ---
NEOVIM_VERSION="stable" # Set 'stable' for the latest release, or specify a version (e.g., 'v0.9.0')
NEOVIM_DIR="$HOME/neovim"
DOTFILES="$HOME/.dotfiles"
STOW_FOLDERS="bin,nvim,tmux,debian,zsh"
OH_MY_ZSH_INSTALL_URL="https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh"

# --- Font Variables ---
FONT_DIR="$HOME/.fonts"
FONT_CONFIG_DIR="$HOME/.config/fontconfig/conf.d"
NERD_FONTS_DIR="$FONT_DIR/Nerd_Fonts"
NERD_FONTS_VERSION="v2.3.3"
NERD_FONTS=("3270" "FiraCode" "Hack" "RobotoMono") # Add more fonts to the array if needed
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
#
install_node() {
    echo ''
    echo 'Install NVM, Node, pnpm'
    # --- Install NVM (Node Version Manager) ---
    # Ensure NVM is installed
    if ! command -v nvm &>/dev/null; then
        echo "nvm not found. Installing nvm..."
        curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.5/install.sh | bash

        # Load nvm into current shell session
        export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
        [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    else
        echo "nvm already installed."
    fi

    if ! nvm list | grep "v18.16" &>/dev/null; then
        echo "Installing Node.js version 18.16..."
        nvm install 18.16
        nvm alias default 18.16
        nvm use 18.16
    else
        echo "Node.js version 18.16 is already installed."
    fi
    # Ensure pnpm version 9 is installed
    if ! command -v pnpm &>/dev/null; then
        echo "pnpm not found. Installing pnpm version 9..."
        npm install -g pnpm@9
    else
        installed_pnpm_version=$(pnpm --version)
        if [[ "$installed_pnpm_version" == 9* ]]; then
            echo "pnpm version 9 is already installed."
        else
            echo "Updating pnpm to version 9..."
            npm install -g pnpm@9
        fi
    fi
}

# Ensure Lua is installed
install_lua() {
    echo ''
    echo 'Install Lua'
    if ! command -v lua &>/dev/null; then
        echo "Lua not found. Installing Lua 5.1..."

        # Update package list and install required dependencies
        sudo apt update
        sudo apt install -y build-essential libreadline-dev

        # Download and install Lua 5.1
        LUA_VERSION="5.1.5"
        wget http://www.lua.org/ftp/lua-$LUA_VERSION.tar.gz
        tar -zxf lua-$LUA_VERSION.tar.gz
        cd lua-$LUA_VERSION || exit
        make linux test
        sudo make install
        cd .. || exit
        rm -rf lua-$LUA_VERSION*

        echo "Lua installed successfully."

    else
        lua_version=$(lua -v 2>&1 | grep -oP 'Lua \K\d+\.\d+')
        echo "Lua is already installed. Version: $lua_version"

        if [[ "$lua_version" != "5.1" ]]; then
            echo "Please install Lua version 5.1."
            exit 1
        fi
    fi
}

# Ensure LuaRocks is installed
install_luarocks() {
    echo ''
    echo 'Install LuaRocks'
    if ! command -v luarocks &>/dev/null; then
        echo "LuaRocks not found. Installing LuaRocks..."

        # Download and install LuaRocks for Lua 5.1
        LUAROCKS_VERSION="3.9.2" # Adjust this to the latest version if needed
        wget https://luarocks.github.io/luarocks/releases/luarocks-$LUAROCKS_VERSION.tar.gz
        tar -xzf luarocks-$LUAROCKS_VERSION.tar.gz
        cd luarocks-$LUAROCKS_VERSION || exit

        # Configure LuaRocks
        ./configure --with-lua=/usr/local
        make
        sudo make install

        cd .. || exit
        rm -rf luarocks-$LUAROCKS_VERSION*

        echo "LuaRocks installed successfully."
    else
        echo "LuaRocks is already installed. Version: $(luarocks --version)"
    fi
}

install_go() {
    echo ''
    echo 'Install Go'
    # Ensure Go is installed
    if ! command -v go &>/dev/null; then
        echo "Go not found. Installing Go..."
        GO_VERSION="1.20.6" # Change this to the latest version if needed
        wget https://go.dev/dl/go$GO_VERSION.linux-amd64.tar.gz
        sudo tar -C /usr/local -xzf go$GO_VERSION.linux-amd64.tar.gz
        rm go$GO_VERSION.linux-amd64.tar.gz

    else
        echo "Go is already installed. Version: $(go version)"
    fi
}

install_neovim() {
    echo ''
    echo 'Install Neovim'
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

    # --- Clean up any old 'nvim' alias ---
    # Remove alias from .zshrc, .bashrc, etc.
    # sed -i '/alias nvim/d' "$HOME/.zshrc"
    # sed -i '/alias nvim/d' "$HOME/.bashrc"

    # Set Neovim alias to point to the version built from source
    # if ! grep -q "alias nvim=" "$HOME/.zshrc"; then
    #     echo "alias nvim='/usr/local/bin/nvim'" >>"$HOME/.zshrc"
    #     source "$HOME/.zshrc"
    # fi

    # --- Remove Packer.nvim if exists ---
    if [ -d "$HOME/.local/share/nvim/site/pack/packer" ]; then
        echo "Removing existing Packer.nvim installation..."
        rm -rf "$HOME/.local/share/nvim/site/pack/packer"
    fi
    # --- Remove LazyVim if exists ---
    if [ -d "$HOME/.config/nvim/lazy.nvim" ]; then
        echo "Removing existing LazyVim installation..."
        rm -rf "$HOME/.config/nvim/lazy.nvim"
    fi

    echo "Neovim setup complete!"
}

install_lazygit() {
    echo ''
    echo 'Install LazyGit'
    # Ensure lazygit is installed
    if ! command -v lazygit &>/dev/null; then
        echo "lazygit not found. Installing lazygit..."

        # If Go is installed, use Go to install lazygit
        if command -v go &>/dev/null; then
            go install github.com/jesseduffield/lazygit@latest
            # echo 'export PATH=$PATH:$HOME/go/bin' >>~/.zshrc
            # export PATH=$PATH:$HOME/go/bin
        else
            echo "Go is required for lazygit installation. Please install Go first."
        fi
    else
        echo "lazygit is already installed. Version: $(lazygit --version)"
    fi
}

install_tmux() {
    echo ''
    echo 'Install Tmux'
    # --- Install tmux ---
    if ! command -v tmux &>/dev/null; then
        echo "Installing tmux..."
        sudo apt install -y tmux
    else
        echo "tmux is already installed."
    fi
}

run_stow() {
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

install_fonts() {
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
    exit 0 # Stop the script so the user can reopen the terminal in Zsh
else
    echo "Zsh is already the default shell. Continuing with Neovim installation and stow setup..."
    install_node
    install_lua
    install_luarocks
    install_go
    install_neovim
    install_lazygit
    install_tmux
    # run_stow
    # setup_folders
    install_fonts
    echo "Setup complete! Please restart your terminal for changes to take full effect."
fi
