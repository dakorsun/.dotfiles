#!/usr/bin/env bash
ln -sf /usr/share/zoneinfo/Europe/Kyiv /etc/localtime
hwclock --systohc

echo "KEYMAP=colemak" > /etc/vconsole.conf
echo "deeznuts" > /etc/hostname

set -e

user="danylo"

# if id "$user" &>/dev/null; then
#     pkill -u "$user" || true
#     userdel -r "$user" || true
#     groupdel "$user" 2>/dev/null || true
# fi

useradd -m -G wheel -s /bin/bash "$user"
echo "$user:password" | chpasswd

pacman -S --noconfirm git vim sudo
pacman -S --needed noto-fonts

sed -i 's/^# %wheel/%wheel/' /etc/sudoers

su - "$user" -c 'git clone -b feature/new-version https://github.com/dakorsun/.dotfiles.git ~/.dotfiles || (cd ~/.dotfiles && git pull)'
chown -R "$user":"$user" /home/$user/.dotfiles
echo "dotfiles regained"

if ls $HOME/paru &>/dev/null; then
    su - "$user" -c 'git clone https://aur.archlinux.org/paru.git ~/paru && cd ~/paru && makepkg -si --noconfirm'
    chown -R "$user":"$user" /home/$user/paru
    echo "Paru installed"
fi


set -e

FONT_DIR="$HOME/.local/share/fonts"
mkdir -p "$FONT_DIR"

TMP_DIR=$(mktemp -d)
cd "$TMP_DIR"

echo ""
echo "Downloading Mononoke Nerd Font"
FONT_URL="https://github.com/ryanoasis/nerd-fonts/releases/latesst/download/Mononoke.zip"
wget -q "$FONT_URL" -O Mononoke.zip

unzip -qq Mononoke.zip -d "$FONT_DIR"

fc-cache -fv

cd ~
rm -rf "$TMP_DIR"

echo "Mononoke Nerd Font, gotcha!"

 
