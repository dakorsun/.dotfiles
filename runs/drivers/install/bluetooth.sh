#!/usr/bin/env bash

install_bluetooth_drivers() {
	if lsusb | grep -qi bluetooth; then
	    sudo pacman -S --needed bluez bluez-utils
	    sudo systemctl enable --now bluetooth
	fi
}
