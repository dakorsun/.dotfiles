#!/usr/bin/env bash

sudo pacman -S --needed \
    xorg-server xorg-xinit xorg-xrandr \
    xterm xclip xorg-xdpyinfo


DPI=$(xdpyinfo | awk '/resolution:/ {split($2,a,"x"); print a[1]}')

if [[ $DPI =~ ^[0-9]+$ ]]; then
  echo "DPI = $DPI"
  xrandr --dpi $DPI
else
  echo "DPI not detected"
fi
