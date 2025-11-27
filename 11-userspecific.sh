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
cat > /etc/iwd/main.conf <<EOF
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
echo ">> Patching rfkill for TLP stability..."
systemctl mask systemd-rfkill.service 2>/dev/null || true
systemctl mask systemd-rfkill.socket 2>/dev/null || true



###############################################
# --- SSH CONFIG ---
###############################################

echo ">> Creating minimal secure sshd_config..."

mkdir -p /etc/ssh
cat > /etc/ssh/sshd_config <<EOF
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
            systemctl enable --now iwd.service
            ;;

        dhcpcd)
            echo "    > enabling and starting dhcpcd.service"
            systemctl enable --now dhcpcd.service
            ;;

        systemd-resolved)
            echo "    > enabling and starting systemd-resolved.service"
            systemctl enable --now systemd-resolved.service

            echo "    > fixing resolv.conf -> stub resolver"
            ln -sf /run/systemd/resolve/stub-resolv.conf /etc/resolv.conf
            ;;

        fstrim.timer)
            echo "    > enabling and starting fstrim.timer"
            systemctl enable --now fstrim.timer
            ;;

        *)
            # generic services
            if systemctl list-unit-files | grep -q "^${svc}.service"; then
                echo "    > enabling ${svc}.service"
                systemctl enable --now "${svc}.service"
            else
                echo "    > WARNING: ${svc}.service not found, skipping"
            fi
            ;;
    esac
done

echo ">> All systemd services configured."
