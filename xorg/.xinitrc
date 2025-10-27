#!/usr/bin/env bash

# export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/ssh-agent.socket"

[[ -f ~/.Xresources ]] && xrbd -merge ~/.Xresources

setxkbmap -layout "us,ua" -option "grp:win_space_toggle" -variant "colemak,"

exec i3
