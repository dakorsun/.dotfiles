#!/usr/bin/env bash
ln -sf /usr/share/zoneinfo/Europe/Kyiv /etc/localtime
hwclock --systohc

echo "KEYMAP=colemak" > /etc/vconsole.conf
echo "deeznuts" > /etc/hostname

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
