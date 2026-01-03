#!/usr/bin/env bash

install_gpu_drivers() {
	if echo "$GPU" | grep -qi intel; then
	    sudo pacman -S --needed mesa vulkan-intel
	fi
	
	if echo "$GPU" | grep -qi amd; then
	    sudo pacman -S --needed mesa vulkan-radeon
	fi
	
	if echo "$GPU" | grep -qi nvidia; then
	    sudo pacman -S --needed nvidia nvidia-utils
	fi
}
