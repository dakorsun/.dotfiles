#!/usr/bin/env bash

# git default stuff 
apt install git vim curl wget unzip stow ;

# ZSH + OH MY ZSH and around
apt install zsh ; 

wget "https://github.com/ryanoasis/nerd-fonts/releases/download/v2.3.3/3270.zip" -O ~/Downloads/Nerd_3270.zip ;
mkdir ~/.fonts && mkdir ~/.fonts/Nerd_Fonts ;
unzip ~/Downloads/Nerd_3270.zip -d ~/.fonts/Nerd_Fonts ;
fc-cache -fv ;

sh -c "$(wget -O- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" ;

chsh -s /bin/zsh ;

# Neovim
apt install neovim ;
git clone --depth 1 https://github.com/wbthomason/packer.nvim ~/.local/share/nvim/site/pack/packer/start/packer.nvim ;
apt install ripgrep fzf ;

# Brave
curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg ;
echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg] https://brave-browser-apt-release.s3.brave.com/ stable main"|tee /etc/apt/sources.list.d/brave-browser-release.list ; 
apt update ; 
apt install brave-browser ;
