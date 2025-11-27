enable_services=(
    iwd
    dhcpcd
    systemd-timesyncd
    fstrim.timer
    tlp
    sshd
)

for svc in "${enable_services[@]}"; do
    systemctl enable "$svc".service || echo "Warning: $svc not found"
done
