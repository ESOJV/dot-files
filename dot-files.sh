#!/bin/bash
set -e

current_dir="$(cd "$(dirname "$0")" && pwd)"

echo "==> Setting up dot-files from $current_dir"

# ---------------------------------------------------------------------------
# Homebrew (macOS)
# ---------------------------------------------------------------------------
if [[ "$OSTYPE" == "darwin"* ]]; then
    if ! command -v brew &>/dev/null; then
        echo "==> Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        # Add brew to PATH for Apple Silicon
        [[ -f /opt/homebrew/bin/brew ]] && eval "$(/opt/homebrew/bin/brew shellenv)"
    fi

    echo "==> Installing packages..."
    brew install eza powerlevel10k tmux
    brew install --cask ghostty
fi

# ---------------------------------------------------------------------------
# Symlink helper
# ---------------------------------------------------------------------------
link() {
    local src="$1" dst="$2"
    if [ -e "$dst" ] && [ ! -L "$dst" ]; then
        mv "$dst" "${dst}.bak"
        echo "Backed up $dst -> ${dst}.bak"
    fi
    mkdir -p "$(dirname "$dst")"
    ln -sf "$src" "$dst"
    echo "Linked: $dst -> $src"
}

# ---------------------------------------------------------------------------
# Config symlinks
# ---------------------------------------------------------------------------
link "$current_dir/nvim"        "$HOME/.config/nvim"
link "$current_dir/tmux"        "$HOME/.config/tmux"
link "$current_dir/ghostty"     "$HOME/.config/ghostty"
link "$current_dir/zsh/.zshrc"  "$HOME/.zshrc"
link "$current_dir/zsh/.p10k.zsh" "$HOME/.p10k.zsh"

# ---------------------------------------------------------------------------
# tpm (tmux plugin manager)
# ---------------------------------------------------------------------------
if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
    echo "==> Installing tpm..."
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi

# ---------------------------------------------------------------------------
# Catppuccin tmux (manual install — required for cyberdream flavor)
# ---------------------------------------------------------------------------
catppuccin_dir="$HOME/.config/tmux/plugins/catppuccin/tmux"
if [ ! -d "$catppuccin_dir" ]; then
    echo "==> Installing catppuccin tmux..."
    mkdir -p "$HOME/.config/tmux/plugins/catppuccin"
    git clone -b v2.1.3 https://github.com/catppuccin/tmux.git "$catppuccin_dir"
fi
cp "$current_dir/tmux/cyberdream.conf" "$catppuccin_dir/themes/catppuccin_cyberdream_tmux.conf"
echo "Installed cyberdream theme for catppuccin"

# ---------------------------------------------------------------------------
echo ""
echo "Done! Next steps:"
echo "  1. Restart your terminal (or source ~/.zshrc)"
echo "  2. Open tmux and press prefix + I to install plugins"
echo "  3. If using conda, run: conda init zsh"
