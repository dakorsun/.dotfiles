#! /usr/bin/env bash

cd $HOME
rm -rf ./.nvm
rm -rf ./.npm
rm -rf ./.bower
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.2/install.sh | bash

source ~/.bashrc

nvm install 18
nvm install 20 
nvm install 22
nvm alias default 18
