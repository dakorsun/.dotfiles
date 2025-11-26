#!/usr/bin/env bash
set -e

user="danylo"

useradd -m -G wheel -s /bin/zsh "$user"
echo "$user:password" | chpasswd

pacman -S --noconfirm git vim sudo networkmanager

sed -i 's/^# %wheel/%wheel/' /etc/sudoers

su - "$user" -c 'git clone https://aur.archlinux.org/paru.git ~/paru && cd ~/paru && makepkg -si --noconfirm'

su - "$user" -c 'git clone https://github.com/dakorsun/.dotfiles.git ~/.dotfiles || (cd ~/.dotfiles && git pull)'
