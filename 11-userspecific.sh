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
  systemd-timesyncd
  fstrim.timer
  tlp
  sshd
)

# ---- OPTION B: iwd + dhcpcd (comment out above block and enable this instead) ----
# enable_services=(
#   iwd
#   dhcpcd
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
    if systemctl list-unit-files | grep -q "^${svc}.service"; then
        echo "  - enabling: ${svc}.service"
        systemctl enable "${svc}.service"
    else
        echo "  - WARNING: ${svc}.service not found, skipping"
    fi
done

echo ">> All systemd services configured."

