set -e

pacman -S --needed noto-fonts

FONT_DIR="$HOME/.local/share/fonts"
mkdir -p "$FONT_DIR"

TMP_DIR=$(mktemp -d)
cd "$TMP_DIR"

echo ""
echo "Downloading Mononoke Nerd Font"
FONT_URL="https://github.com/ryanoasis/nerd-fonts/releases/latest/download/Mononoki.tar.xz"
curl -OL "$FONT_URL"

tar -xz Mononoki.tar.xz

fc-cache -fv

cd ~
rm -rf "$TMP_DIR"

echo "Mononoke Nerd Font, gotcha!"

 
