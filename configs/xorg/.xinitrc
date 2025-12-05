#!/usr/bin/env bash

[[ -f ~/.Xresources ]] && xrbd -merge ~/.Xresources

setxkbmap -layout "us,ua" -option "grp:win_space_toggle" -variant "colemak,"

eval "$(ssh-agent -s)"
~/.ssh/agent_startup.sh &

exec awesome
