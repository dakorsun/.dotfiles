# ! /usr/bin/env bash
# --- Variables ---
FONT_DIR="$HOME/.fonts"
FONT_CONFIG_DIR="$HOME/.config/fontconfig/conf.d"
NERD_FONTS_DIR="$FONT_DIR/Nerd_Fonts"
NERD_FONTS_VERSION="v2.3.3"
NERD_FONTS=("3270" "FiraCode" "Hack" "RobotoMono")  # Add more fonts to the array if needed
POWERLINE_FONT_URL="https://github.com/powerline/powerline/raw/develop/font/PowerlineSymbols.otf"
POWERLINE_CONF_URL="https://github.com/powerline/powerline/raw/develop/font/10-powerline-symbols.conf"

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

# --- Main Logic ---

# Install Powerline fonts and Nerd Fonts
install_powerline_fonts
install_nerd_fonts

# Rebuild the font cache to apply changes
rebuild_font_cache

# Verify the installation of fonts
verify_fonts_installed
