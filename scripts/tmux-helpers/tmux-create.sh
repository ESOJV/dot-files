#!/usr/bin/env bash

# Creates new dev environment in standard folder
[ -z "$1" ] && echo "Usage: $0 <project-name>" && exit 1

target="$HOME/repos/$1"

if [ -d "$target" ]; then
	tmux attach -t "$1"
else
	mkdir -p "$target"
	tmux new-session -s "$1" -c "$target"
	tmux send-keys -t "$1" "nvim ." Enter
	tmux new-window -t "$1"
fi
