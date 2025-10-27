#!/bin/usr/env bash

RED='\[\033[0;31m\]'
GREEN='\[\033[0;32m\]'
YELLOW='\[\033[0;33m\]'
BLUE='\[\033[0;34m\]'
MAGENTA='\[\033[0;35m\]'
CYAN='\[\033[0;36m\]'
RESET='\[\033[0m\]'

# Функція для виводу гілки Git
parse_git_branch() {
  git branch --show-current 2>/dev/null
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
