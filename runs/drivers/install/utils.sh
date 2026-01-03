#!/usr/bin/env bash

install_utils() {
	sudo pacman -S --needed \
	    pciutils usbutils hwinfo \
	    dmidecode lsb-release \
	    acpi lm_sensors
}
