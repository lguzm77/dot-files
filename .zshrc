# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Zprof to measure execution time
if [[ "$ZPROF" = true ]]; then
  zmodload zsh/zprof
fi

# Download Znap, if it's not there yet.
[[ -r ~/Repos/znap/znap.zsh ]] ||
    git clone --depth 1 -- \
        https://github.com/marlonrichert/zsh-snap.git ~/Repos/znap
source ~/Repos/znap/znap.zsh  # Start Znap

# Install zsnap plugins
# znap source repo -- example 
znap source zsh-users/zsh-autosuggestions
znap source zsh-users/zsh-syntax-highlighting
znap source zdharma-continuum/fast-syntax-highlighting
znap source marlonrichert/zsh-autocomplete

# Install fast node version manager with zsnap
[[ -r ~/.fnm/fnm ]] || [[ -r /opt/homebrew/bin/fnm ]] || 
  curl -fsSL https://fnm.vercel.app/install | zsh -s -- --install-dir "./.fnm" --skip-shell
znap eval fnm 'fnm env'
znap fpath _fnm 'fnm completions --shell zsh'

# For a full list of active aliases, run `alias`.
alias brewupgrade="brew update && brew upgrade"
alias projects="cd ~/Projects"
alias config="cd ~/.config/"
alias nvimconf="cd ~/.config/nvim"
alias f="fzf"

# Generated for envman. Do not edit.
[ -s "$HOME/.config/envman/load.sh" ] && source "$HOME/.config/envman/load.sh"

export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border'
znap eval fzf --zsh

if [[ "$ZPROF" = true ]]; then
  zprof
fi

source /opt/homebrew/share/powerlevel10k/powerlevel10k.zsh-theme

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh