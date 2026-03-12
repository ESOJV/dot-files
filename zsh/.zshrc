# Enable Powerlevel10k instant prompt (zsh only)
if [ -n "$ZSH_VERSION" ]; then
    if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
        source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
    fi
fi

export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"
export PATH="$PATH:$HOME/go/bin"
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/scripts:$PATH"

# Aliases
alias ls='eza -l --icons --group-directories-first --no-user --no-permissions'
alias c='clear'
alias get-idf='. $HOME/esp/esp-idf/export.sh'

# Scripts dispatcher
function scripts() {
  if [ -z "$1" ]; then
    echo "Usage: scripts <name>"
    echo "Available scripts:"
    find "$HOME/scripts" -type f -name "*.sh" | sed "s|$HOME/scripts/||" | sed "s|.sh||" | sed "s|.*/||"
    return 0
  fi

  local found
  found=$(find "$HOME/scripts" -type f -name "$1.sh" 2>/dev/null | head -1)

  if [ -z "$found" ]; then
    echo "scripts: '$1' not found"
    return 1
  fi

  bash "$found" "${@:2}"
}

# tmux wrapper — intercepts new -p and ls
function tmux() {
    if [[ "$1" == "new" ]]; then
        shift
        local name=""
        local args=()
        while [[ $# -gt 0 ]]; do
            case "$1" in
                -p) name="$2"; shift 2 ;;
                *) args+=("$1"); shift ;;
            esac
        done
        if [[ -n "$name" ]]; then
            bash "$HOME/scripts/tmux-helpers/tmux-create.sh" "$name"
        else
            command tmux new "${args[@]}"
        fi
    elif [[ "$1" == "ls" ]]; then
        bash "$HOME/scripts/tmux-pick.sh"
    else
        command tmux "$@"
    fi
}

# Powerlevel10k (zsh only)
if [ -n "$ZSH_VERSION" ]; then
    [[ -f /opt/homebrew/share/powerlevel10k/powerlevel10k.zsh-theme ]] && source /opt/homebrew/share/powerlevel10k/powerlevel10k.zsh-theme
    [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
fi

# conda init — run 'conda init zsh' (or 'conda init bash') after installing conda
