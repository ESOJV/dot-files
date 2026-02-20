# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi


export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/Users/josevelasco/opt/anaconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/Users/josevelasco/opt/anaconda3/etc/profile.d/conda.sh" ]; then
        . "/Users/josevelasco/opt/anaconda3/etc/profile.d/conda.sh"
    else
        export PATH="/Users/josevelasco/opt/anaconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

source /opt/homebrew/share/powerlevel10k/powerlevel10k.zsh-theme

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
export PATH=$PATH:$HOME/go/bin
export PATH=$PATH:$HOME/go/bin
export PATH="/opt/homebrew/opt/postgresql@15/bin:$PATH"



#ls
alias ls='eza -l --icons --group-directories-first --no-user --no-permissions'
export EZA_COLORS="di=38;2;0;255;0:da=38;2;0;255;0:sn=38;2;0;255;0:sb=38;2;0;255;0:*.go=38;2;245;86;97:*.py=38;2;245;86;97:*.js=38;2;245;86;97:*.ts=38;2;245;86;97:*.rs=38;2;245;86;97:*.c=38;2;245;86;97:*.cpp=38;2;245;86;97:*.lua=38;2;245;86;97:*.sh=38;2;245;86;97:*.java=38;2;245;86;97:*.rb=38;2;245;86;97"

export PATH="$HOME/.local/bin:$PATH"
source ~/.cargo/env
source ~/.cargo/env
