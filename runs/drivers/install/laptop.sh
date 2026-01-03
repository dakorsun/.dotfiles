#!/usr/bin/env bash

install_laptop_tools() {
    sudo pacman -S --needed \
        tlp tlp-rdw \
        powertop acpid

    paru -S laptop-mode-tools

    sudo systemctl enable --now tlp
    sudo systemctl enable --now acpid
}
