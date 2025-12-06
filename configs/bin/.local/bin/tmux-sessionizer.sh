#!/usr/bin/env bash

if [[ $# -eq 1 ]]; then
    selected=$1
else
	selected=$({
		# gently search through bare repo
		find ~/.dotfiles.git/*  \
		-maxdepth 0 -type d  \
		-not -path '*branches*'  \
		-and -not -path '*worktrees*'  \
		-and -not -path '*info*' \
		-and -not -path '*objects*' \
		-and -not -path '*description*' \
		-and -not -path '*config*' \
		-and -not -path '*hooks*' \
		-and -not -path '*logs*' \
		-and -not -path '*refs*' ;
		find ~/.dotfiles ~/.awesomerc ~/.dotfiles.git ~/.awesomerc.git ~/.dotfiles.git/*/nvim ~/projects/* ~/personal/* -maxdepth 0 -type d ;
		find ~/projects/* ~/personal/* ~/work ~/personal ~/personal/junk ~/personal/tutors -mindepth 1 -maxdepth 1 -type d ;
	} | fzf )
fi

if [[ -z $selected ]]; then
    exit 0
fi

selected_name=$(basename "$selected" | tr . _)
tmux_running=$(pgrep tmux)

if [[ -z $TMUX ]] && [[ -z $tmux_running ]]; then
    tmux new-session -s $selected_name -c $selected
    exit 0
fi

if ! tmux has-session -t=$selected_name 2> /dev/null; then
    tmux new-session -ds $selected_name -c $selected
fi

tmux switch-client -t $selected_name
