#!/usr/bin/env bash
ln -sf /usr/share/zoneinfo/Europe/Kyiv /etc/localtime
hwclock --systohc

echo "KEYMAP=colemak" >/etc/vconsole.conf
echo "deeznuts" >/etc/hostname

user="danylo"

# if id "$user" &>/dev/null; then
#     pkill -u "$user" || true
#     userdel -r "$user" || true
#     groupdel "$user" 2>/dev/null || true
# fi

useradd -m -G wheel -s /bin/bash "$user"
echo "$user:password" | chpasswd
passwd "$user"

pacman -S --noconfirm git vim sudo curl wget man-db man-pages
pacman -S --needed noto-fonts
pacman -S --needed iwd networkmanager

sed -i 's/^# %wheel ALL=(ALL:ALL) ALL/%wheel ALL=(ALL:ALL) ALL/' /etc/sudoers

su - "$user" -c 'git clone -b feature/new-version https://github.com/dakorsun/.dotfiles.git ~/.dotfiles || (cd ~/.dotfiles && git pull)'
chown -R "$user":"$user" /home/$user/.dotfiles
echo "dotfiles regained"

if [[ ! -d /home/$user/paru ]]; then
    su - "$user" -c 'git clone https://aur.archlinux.org/paru.git ~/paru && cd ~/paru && makepkg -si --noconfirm'
    chown -R "$user":"$user" /home/$user/paru
    echo "Paru installed"
fi

###############################################
# SYSTEMD SERVICES SETUP
###############################################

echo ">> Configuring systemd services..."

#
# --- NETWORKING ---
#

# ---- OPTION A: iwd as full network manager (no dhcpcd needed) ----
# Enable DHCP inside iwd
mkdir -p /etc/iwd
cat >/etc/iwd/main.conf <<EOF
[General]
EnableNetworkConfiguration=true
EOF

enable_services=(
    iwd
    systemd-resolved
    systemd-timesyncd
    fstrim.timer
    tlp
    sshd
)

# ---- OPTION B: iwd + dhcpcd ----
# (uncomment if using dhcpcd + remove EnableNetworkConfiguration)
# enable_services=(
#   iwd
#   dhcpcd
#   systemd-resolved
#   systemd-timesyncd
#   fstrim.timer
#   tlp
#   sshd
# )
# rm -f /etc/iwd/main.conf 2>/dev/null

###############################################
# --- TLP mask rfkill backend ---
###############################################
# echo ">> Patching rfkill for TLP stability..."
# systemctl mask systemd-rfkill.service 2>/dev/null || true
# systemctl mask systemd-rfkill.socket 2>/dev/null || true

###############################################
# --- SSH CONFIG ---
###############################################

echo ">> Creating minimal secure sshd_config..."

mkdir -p /etc/ssh
cat >/etc/ssh/sshd_config <<EOF
# Basic secure SSH configuration
PermitRootLogin no
PasswordAuthentication yes
PubkeyAuthentication yes
Subsystem sftp /usr/lib/ssh/sftp-server
EOF

###############################################
# --- ENABLE SERVICES ---
###############################################

echo ">> Enabling systemd services..."

for svc in "${enable_services[@]}"; do

    echo "  - processing: ${svc}"

    # --- special cases ---
    case "$svc" in

    iwd)
        echo "    > enabling and starting iwd.service"
        systemctl enable iwd.service
        ;;

    dhcpcd)
        echo "    > enabling and starting dhcpcd.service"
        systemctl enable dhcpcd.service
        ;;

    systemd-resolved)
        echo "    > enabling and starting systemd-resolved.service"
        systemctl enable systemd-resolved.service

        echo "    > fixing resolv.conf -> stub resolver"
        ln -sf /run/systemd/resolve/stub-resolv.conf /etc/resolv.conf
        ;;

    fstrim.timer)
        echo "    > enabling and starting fstrim.timer"
        systemctl enable fstrim.timer
        ;;

    *)
        # generic services
        if systemctl list-unit-files | grep -q "^${svc}.service"; then
            echo "    > enabling ${svc}.service"
            systemctl enable "${svc}.service"
        else
            echo "    > WARNING: ${svc}.service not found, skipping"
        fi
        ;;
    esac
done

echo ">> All systemd services configured."
