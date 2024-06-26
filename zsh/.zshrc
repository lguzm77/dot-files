# Zprof to measure execution time
if [[ "$ZPROF" = true ]]; then
  zmodload zsh/zprof
fi

# Download Znap, if it's not there yet.
[[ -r ~/Repos/znap/znap.zsh ]] ||
    git clone --depth 1 -- \
        https://github.com/marlonrichert/zsh-snap.git ~/Repos/znap
source ~/Repos/znap/znap.zsh  # Start Znap

# Install fast node version manager with zsnap
[[ -r ~/.fnm/fnm ]] || [[ -r /opt/homebrew/bin/fnm ]] || 
  curl -fsSL https://fnm.vercel.app/install | zsh -s -- --install-dir "./.fnm" --skip-shell

# Completions need to be loaded before fzf-tab
znap eval fnm 'fnm env'
znap fpath _fnm 'fnm completions --shell zsh'
znap eval fzfint "fzf --zsh" # enabled by ctrl-r

# Install zsnap plugins
# znap source repo -- example 
znap source zsh-users/zsh-autosuggestions
znap source zsh-users/zsh-completions
znap source zsh-users/zsh-syntax-highlighting
znap source zdharma-continuum/fast-syntax-highlighting
znap source Aloxaf/fzf-tab

autoload -U compinit && compinit

# keybindings
# check what other keybinding options you have
bindkey -e # emacs keybindings
bindkey '^p' history-beginning-search-backward
bindkey '^n' history-beginning-search-forward

# history 
HISTSIZE=5000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space # do not append a command to the history log if it has a space at the beginning
setopt hist_save_no_dups # do not save duplicates in the history log
setopt hist_ignore_dups
setopt hist_find_no_dups

# Completion styling 
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no # disable default menu and replace with fzf

# Aliases 
alias ls="eza"
alias brewupgrade="brew update && brew upgrade"
alias cat="bat"
alias f="fzf"
alias cd="z" # zoxide
alias lg="lazygit"
alias air='$(go env GOPATH)/bin/air'
alias gs="git switch"
alias gp="git pull --rebase"
alias ...="cd .. && cd .."
alias c="clear"

# shell integrations
znap eval zoxide "zoxide init zsh"
znap eval omp "oh-my-posh --init --shell zsh --config $HOME/zen.toml"
export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border'
znap eval _kubectl 'kubectl completion zsh'

# Use this block to import any additinonal configurations
# . my-config.zshrc 

# Generated for envman. Do not edit.
[ -s "$HOME/.config/envman/load.sh" ] && source "$HOME/.config/envman/load.sh"

if [[ "$ZPROF" = true ]]; then
  zprof
fi

