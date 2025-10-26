#! /usr/bin/env bash
[[ -f ~/.bashrc ]] && . ~/.bashrc

[[ -z $DISPLAY && $XDG_VTNR -eq 1 ]] && exec startx

export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/ssh-agent.socket"

# ssh-agent auto-start
if [ -z "$SSH_AUTH_SOCK" ]; then
    echo "Starting ssh-agent"
    eval "$(ssh-agent -s)" > /dev/null
fi
