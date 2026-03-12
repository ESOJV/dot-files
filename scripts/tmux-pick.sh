#!/usr/bin/env bash


# tmux quick picker

# Build list with a hidden tab-delimited target prefix:
#   <session>:<window_index>  TAB  <display line>
list=$(tmux ls)

selection=$(echo "$list" \
    | fzf \
        --pointer="▶" \
        --height=40% \
        --reverse \
        --border=rounded \
        --info=inline )  

[ -z "$selection" ] && exit 0

selected="${selection%%:*}"

if [ -n "$TMUX" ]; then
    # Already inside tmux — just switch
    tmux switch-client -t "$selected"
else
    # Outside tmux — attach and jump directly to the chosen window
    tmux attach-session -t "$selected"
fi
