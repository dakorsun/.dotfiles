#! /usr/bin/env bash

RED='\[\033[0;31m\]'
GREEN='\[\033[0;32m\]'
YELLOW='\[\033[0;33m\]'
BLUE='\[\033[0;34m\]'
MAGENTA='\[\033[0;35m\]'
CYAN='\[\033[0;36m\]'
RESET='\[\033[0m\]'

# Функція для виводу гілки Git
parse_git_branch() {
  git branch --show-current
}

# Промпт
PS1="\n${BLUE}\u${RESET}@${MAGENTA}\h${RESET}:${CYAN}\w${RESET}\$(
  branch=$(parse_git_branch)
  [ -n \"$branch\" ] && echo \" ${YELLOW} $branch${RESET}\"
)\n\[$(tput sgr0)\]\[$(tput setaf 3)\]\$(date +%H:%M:%S)\[$(tput sgr0)\] \$([ \$? != 0 ] && echo '💥') \$ "

# ~/.bashrc
alias ll='ls -la --color=auto'
alias gs='git status'
alias gc='git commit -m'
alias gp='git push'
alias gd='git diff'
alias v='nvim'
alias ..='cd ..'
alias ...='cd ../..'

alias glg='git log --stats'
alias glgp='git log --stats -p'
alias glgg='git log --graph'
alias glgga='git log --graph --decorate --all'
alias glgm='git log --graph --max-count=10'
alias glo='git log --oneline --decorate'
alias glol="git log --graph --pretty='%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ar) %C(bold blue)<%an>%Creset'"
alias glols="git log --graph --pretty='%Cred%h%Creset -%C(auto)%d%Creset %s%Cgreen(%ar) %C(bold blue)<%an>%Creset' --stat"
alias glod="git log --graph --pretty='%Cred%h%Creset -%C(auto)%d%Creset %s%Cgreen(%ad) %C(bold blue)<%an>%Creset'"
alias glods="git log --graph --pretty='%Cred%h%Creset -%C(auto)%d%Creset %s%Cgreen(%ad) %C(bold blue)<%an>%Creset' --date=short"
alias glola="git log --graph --pretty='%Cred%h%Creset -%C(auto)%d%Creset %s%Cgreen(%ar) %C(bold blue)<%an>%Creset' --all"
alias glog='git log --oneline --decorate  --graph'
alias gloga='git log --oneline --decorate --graph --all'
alias glp='git log --pretty=<format>'

bind -x '"\C-f": "tmux-sessionizer.sh"'
