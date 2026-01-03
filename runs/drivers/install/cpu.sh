#!/usr/bin/env bash

install_cpu_drivers() {
	case "$CPU_VENDOR" in
	    intel)
	        sudo pacman -S --needed intel-ucode thermald
	        sudo systemctl enable --now thermald
	        ;;
	    amd)
	        sudo pacman -S --needed amd-ucode
	        ;;
	esac 
}
