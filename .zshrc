# Zprof to measure execution time
if [[ "$ZPROF" = true ]]; then
  zmodload zsh/zprof
fi

export ZSH="$HOME/.oh-my-zsh"


# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
  evalcache
  git
  zsh-autosuggestions
  zsh-syntax-highlighting
  fast-syntax-highlighting
  zsh-autocomplete)

source $ZSH/oh-my-zsh.sh

# For a full list of active aliases, run `alias`.
alias brewupgrade="brew update && brew upgrade"
alias projects="cd ~/Projects"
alias config="cd ~/.config/"
alias nvimconf="cd ~/.config/nvim"
alias f="fzf"

# Generated for envman. Do not edit.
[ -s "$HOME/.config/envman/load.sh" ] && source "$HOME/.config/envman/load.sh"
_evalcache starship init zsh

export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border'
_evalcache fzf --zsh

if [[ "$ZPROF" = true ]]; then
  zprof
fi

