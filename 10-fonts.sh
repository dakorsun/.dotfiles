set -e

pacman -S --needed noto-fonts

FONT_DIR="$HOME/.local/share/fonts"
mkdir -p "$FONT_DIR"

TMP_DIR=$(mktemp -d)
cd "$TMP_DIR"

ARCHIVE_NAME="Mononoki.tar.xz"

echo ""
echo "Downloading Mononoki Nerd Font"
FONT_URL="https://github.com/ryanoasis/nerd-fonts/releases/latest/download/$ARCHIVE_NAME"
curl -OL "$FONT_URL"

tar -xf $ARCHIVE_NAME -O "$FONT_DIR"

fc-cache -fv

cd ~
rm -rf "$TMP_DIR"

echo "Mononoki Nerd Font, gotcha!"
