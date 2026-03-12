#!/bin/bash
set -e

current_dir="$(cd "$(dirname "$0")" && pwd)"

echo "==> Setting up dot-files from $current_dir"

# ---------------------------------------------------------------------------
# Package installation
# ---------------------------------------------------------------------------
if [[ "$OSTYPE" == "darwin"* ]]; then
    if ! command -v brew &>/dev/null; then
        echo "==> Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        [[ -f /opt/homebrew/bin/brew ]] && eval "$(/opt/homebrew/bin/brew shellenv)"
    fi
    echo "==> Installing packages (brew)..."
    brew install eza powerlevel10k tmux fzf neovim
    brew install --cask ghostty

elif command -v pacman &>/dev/null; then
    echo "==> Installing packages (pacman)..."
    sudo pacman -S --needed --noconfirm eza tmux fzf neovim zsh git ghostty

    # powerlevel10k — in AUR, needs an AUR helper
    if ! pacman -Q zsh-theme-powerlevel10k &>/dev/null; then
        if command -v yay &>/dev/null; then
            yay -S --needed --noconfirm zsh-theme-powerlevel10k
        elif command -v paru &>/dev/null; then
            paru -S --needed --noconfirm zsh-theme-powerlevel10k
        else
            echo "Warning: No AUR helper found. Install zsh-theme-powerlevel10k manually."
        fi
    fi

    # Set zsh as default shell if not already
    if [ "$SHELL" != "$(which zsh)" ]; then
        echo "==> Setting zsh as default shell..."
        chsh -s "$(which zsh)"
    fi
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
link "$current_dir/scripts"       "$HOME/scripts"
link "$current_dir/nvim"          "$HOME/.config/nvim"
link "$current_dir/tmux"          "$HOME/.config/tmux"
link "$current_dir/ghostty"       "$HOME/.config/ghostty"
link "$current_dir/zsh/.zshrc"    "$HOME/.zshrc"
link "$current_dir/zsh/.zshrc"    "$HOME/.bashrc"
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
