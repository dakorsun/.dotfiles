#!/usr/bin/env bash

# git vim curl wget unzip 
apt install git vim curl wget unzip ;

# ZSH + OH MY ZSH and around
apt install zsh ; 

wget "https://github.com/ryanoasis/nerd-fonts/releases/download/v2.3.3/3270.zip" -O $USER_HOME/Downloads/Nerd_3270.zip ;
mkdir ~/.fonts && mkdir ~/.fonts/Nerd_Fonts ;
unzip ~/Downloads/Nerd_3270.zip -d ~/.fonts/Nerd_Fonts ;
fc-cache -fv ;

sh -c "$(wget -O- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" ;

chsh -s /bin/zsh ;

# Neovim
(cd $USER_HOME && curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim.appimage) ;
chmod u+x $USER_HOME/nvim.appimage ;
alias nvim='$USER_HOME/nvim.appimage' ;

