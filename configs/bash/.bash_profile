#! /usr/bin/env bash

export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/neovim/bin:$PATH"
export EDITOR="nvim"
export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/ssh-agent.socket"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

[[ -z $DISPLAY && $XDG_VTNR -eq 1 ]] && exec startx

bind -x '"\C-f": "tmux-sessionizer.sh"'
