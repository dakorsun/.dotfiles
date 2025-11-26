#!/usr/bin/env bash
set -e

rm -rf /mnt/.dotfiles
git clone -b feature/new-version https://github.com/dakorsun/.dotfiles.git /mnt/.dotfiles

pacstrap /mnt base linux linux-firmware $(cat /mnt/.dotfiles/pacstrapList.txt)

genfstab -U /mnt >> /mnt/etc/fstab

cp /mnt/.dotfiles/10-postpacstrap.sh /mnt/root/
chmod +x /mnt/root/10-postpacstrap.sh

echo ""
echo "Pacstrap done. Now run:"
echo "arch-chroot /mnt"
echo "and then set the root password: "
echo "passwd"
echo "then generate locales and run ~/10-postpacstrap.sh"

