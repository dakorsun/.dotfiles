#! /usr/bin/env bash

cd $HOME
rm -rf ./.nvm
rm -rf ./.npm
rm -rf ./.bower
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.2/install.sh | bash

export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm

nvm install 18
nvm install 20 
nvm install 22
nvm install 24
nvm alias default 18
