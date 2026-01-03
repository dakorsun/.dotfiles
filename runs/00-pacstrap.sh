#!/usr/bin/env bash
set -e

rm -rf /mnt/.dotfiles
git clone -b feature/new-version https://github.com/dakorsun/.dotfiles.git /mnt/.dotfiles

mapfile -t PACKAGES < <(grep -vE '^\s*(#|$)' "$PWD/pacstrap.list")

pacstrap /mnt base linux linux-firmware \
    $"${PACKAGES[@]}"

genfstab -U /mnt >>/mnt/etc/fstab

cp /mnt/.dotfiles/runs/01-postpacstrap.sh /mnt/root/
chmod +x /mnt/root/01-postpacstrap.sh

echo ""
echo "Pacstrap done. Now run:"
echo "arch-chroot /mnt"
echo "and then set the root password: "
echo "passwd"
echo "then generate locales and run ~/01-postpacstrap.sh"
