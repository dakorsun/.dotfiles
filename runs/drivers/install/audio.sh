#!/usr/bin/env bash

install_audio_drivers() {
	sudo pacman -S --needed \
	    pipewire pipewire-alsa pipewire-pulse \
	    wireplumber alsa-utils
}
