# Zprof to measure execution time
if [[ "$ZPROF" = true ]]; then
  zmodload zsh/zprof
fi

# install zsnap
[[ -r ~/Repos/znap/znap.zsh ]] ||
    git clone --depth 1 -- \
        https://github.com/marlonrichert/zsh-snap.git ~/Repos/znap
source ~/Repos/znap/znap.zsh  # Start Znap, we need to call source here

export STARSHIP_CONFIG=~/.config/starship/starship.toml
znap eval starship 'starship init zsh'
znap prompt # enable fast prompt

# Install fast node version manager with zsnap
[[ -r ~/.fnm/fnm ]] || [[ -r /opt/homebrew/bin/fnm ]] || 
  curl -fsSL https://fnm.vercel.app/install | zsh -s -- --install-dir "./.fnm" --skip-shell
# Completions need to be loaded before fzf-tab
znap eval fnm 'fnm env'
znap fpath _fnm 'fnm completions --shell zsh'
znap eval fzfint "fzf --zsh" # enabled by ctrl-r
export FZF_DEFAULT_OPTS='--height 80% --layout=reverse --border'
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
bindkey jj vi-cmd-mode
bindkey '^p' history-beginning-search-backward
bindkey '^n' history-beginning-search-forward
bindkey '^f' autosuggest-accept

# history 
HISTSIZE=1000000
SAVEHIST=1000000
HISTFILE="$XDG_CACHE_HOME/zsh_history" # move histfile to cache
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space # do not append a command to the history log if it has a space at the beginning
setopt hist_ignore_all_dups
setopt hist_save_no_dups # do not save duplicates in the history log
setopt hist_ignore_dups
setopt hist_find_no_dups

# Completion styling 
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no # disable default menu and replace with fzf
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'

# Aliases 
alias http="xh" # route http calls to xh

alias l="eza -l --icons --git -a"
alias lt="eza --tree --level=2 --long --icons --git"
alias ltree="eza --tree --level=2  --icons --git"
alias ls="ls --color"

alias cd="z"

alias brewupgrade="brew update && brew upgrade"
alias cat="bat"
alias f="fzf"

alias air='$(go env GOPATH)/bin/air'

alias lg="lazygit"
alias ld="lazydocker"

alias gs="git switch"
alias gu="git undo" # git alias for git reset --soft HEAD^
alias gp="git pull --rebase"
alias gr="git restore"
alias gst="git status"

alias v="nvim"
alias c="clear"
alias m="mmdc"
alias p="python3"
alias e="exit"
alias t="touch"

# shell integrations
znap eval zoxide "zoxide init zsh"
znap eval _kubectl 'kubectl completion zsh'

# Use this block to import any additinonal configurations
# . my-config.zshrc 

# Generated for envman. Do not edit.
[ -s "$HOME/.config/envman/load.sh" ] && source "$HOME/.config/envman/load.sh"

if [[ "$ZPROF" = true ]]; then
  zprof
fi


