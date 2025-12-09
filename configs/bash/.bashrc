#!/bin/usr/env bash

source ~/.bash_profile

export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/neovim/bin:$PATH"
export EDITOR="nvim"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

