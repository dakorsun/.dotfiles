#!/usr/bin/env bash

# git default stuff 
apt install git vim curl wget unzip stow ;

# ZSH + OH MY ZSH and around
apt install zsh ; 

wget "https://github.com/ryanoasis/nerd-fonts/releases/download/v2.3.3/3270.zip" -O $USER_HOME/Downloads/Nerd_3270.zip ;
mkdir $USER_HOME/.fonts && mkdir $USER_HOME/.fonts/Nerd_Fonts ;
unzip $USER_HOME/Downloads/Nerd_3270.zip -d $USER_HOME/.fonts/Nerd_Fonts ;
fc-cache -fv ;

sh -c "$(wget -O- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" ;

chsh -s /bin/zsh ;

# Neovim
apt install neovim ;
git clone --depth 1 https://github.com/wbthomason/packer.nvim $USER_HOME/.local/share/nvim/site/pack/packer/start/packer.nvim ;
apt install ripgrep fzf ;
