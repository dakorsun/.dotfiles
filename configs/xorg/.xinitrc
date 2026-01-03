#!/usr/bin/env bash

[[ -f ~/.Xresources ]] && xrbd -merge ~/.Xresources

setxkbmap -layout "us,ua" -option "grp:win_space_toggle" -variant "colemak,"

DPI=$(xdpyinfo | awk '/resolution:/ {split($2,a,"x"); print a[1]}')

if [[ $DPI =~ ^[0-9]+$ ]]; then
  echo "DPI = $DPI"
  xrandr --dpi $DPI
else
  echo "DPI not detected"
fi

eval "$(ssh-agent -s)"

exec awesome
