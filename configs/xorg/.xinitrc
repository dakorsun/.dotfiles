#!/usr/bin/env bash

[[ -f ~/.Xresources ]] && xrbd -merge ~/.Xresources

setxkbmap -layout "us,ua" -option "grp:win_space_toggle" -variant "colemak,"

exec awesome
