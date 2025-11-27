#!/usr/bin/env bash
ln -sf /usr/share/zoneinfo/Europe/Kyiv /etc/localtime
hwclock --systohc

echo "KEYMAP=colemak" > /etc/vconsole.conf
echo "deeznuts" > /etc/hostname

set -e

user="danylo"

if id "$user" &>/dev/null; then
    pkill -u "$user" || true
    userdel -r "$user" || true
    groupdel "$user" 2>/dev/null || true
fi

useradd -m -G wheel -s /bin/bash "$user"
echo "$user:password" | chpasswd

pacman -S --noconfirm git vim sudo networkmanager

sed -i 's/^# %wheel/%wheel/' /etc/sudoers

su - "$user" -c 'git clone https://aur.archlinux.org/paru.git ~/paru && cd ~/paru && makepkg -si --noconfirm'

su - "$user" -c 'git clone -b feature/new-version https://github.com/dakorsun/.dotfiles.git ~/.dotfiles || (cd ~/.dotfiles && git pull)'
