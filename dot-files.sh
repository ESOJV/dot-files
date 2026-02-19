#!/bin/bash

#just symlinks everything into same folder so I can push to git easily

root_config_dir="$HOME/.config"

nvim_dir="$root_config_dir/nvim"
tmux_dir="$root_config_dir/tmux"
ghostty_dir="$root_config_dir/ghostty"

current_dir="$(cd "$(dirname "$0")" && pwd)"

if [ -d "$nvim_dir" ] && [ ! -L "$nvim_dir" ]; then
    mv "$nvim_dir" "${nvim_dir}.bak"
    echo "Backed up $nvim_dir to ${nvim_dir}.bak"
fi
ln -sf "$current_dir/nvim" "$nvim_dir"
echo "Linked: $nvim_dir -> $current_dir/nvim"

if [ -d "$tmux_dir" ] && [ ! -L "$tmux_dir" ]; then
    mv "$tmux_dir" "${tmux_dir}.bak"
    echo "Backed up $tmux_dir to ${tmux_dir}.bak"
fi
ln -sf "$current_dir/tmux" "$tmux_dir"
echo "Linked: $tmux_dir -> $current_dir/tmux"

if [ -d "$ghostty_dir" ] && [ ! -L "$ghostty_dir" ]; then
    mv "$ghostty_dir" "${ghostty_dir}.bak"
    echo "Backed up $ghostty_dir to ${ghostty_dir}.bak"
fi
ln -sf "$current_dir/ghostty" "$ghostty_dir"
echo "Linked: $ghostty_dir -> $current_dir/ghostty"
