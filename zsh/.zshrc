# Enable Powerlevel10k instant prompt (must be first)
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi
# Zprof to measure execution time
if [[ "$ZPROF" = true ]]; then
  zmodload zsh/zprof
fi
# Znap (portable: XDG_DATA_HOME, conditional clone)
_znap_dir="${XDG_DATA_HOME:-$HOME/.local/share}/znap"
[[ -r $_znap_dir/znap.zsh ]] ||
  git clone --depth 1 https://github.com/marlonrichert/zsh-snap.git $_znap_dir
source $_znap_dir/znap.zsh

# FZF integration
if (( ${+commands[fzf]} )); then
  znap eval fzfint "fzf --zsh"
fi
# Plugins (load Powerlevel10k first for faster prompt)
znap source romkatv/powerlevel10k
znap source zsh-users/zsh-autosuggestions
znap source zsh-users/zsh-completions
znap source zdharma-continuum/fast-syntax-highlighting
if (( ${+commands[fzf]} )); then
  znap source Aloxaf/fzf-tab
fi
# Powerlevel10k config
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
# keybindings
bindkey jj vi-cmd-mode
bindkey '^p' history-beginning-search-backward
bindkey '^n' history-beginning-search-forward
bindkey '^f' autosuggest-accept
# Edit command buffer
autoload -Uz edit-command-line
zle -N edit-command-line
bindkey '^x^e' edit-command-line
# history
HISTSIZE=1000000
SAVEHIST=1000000
HISTFILE="${XDG_CACHE_HOME}/zsh_history"
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_dups
setopt hist_ignore_all_dups
setopt hist_find_no_dups
# Completion styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu select
if (( ${+commands[bat]} )); then
  zstyle ':fzf-tab:complete:cd:*' fzf-preview 'bat -p --color=always $realpath 2>/dev/null || ls --color $realpath'
  zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'bat -p --color=always $realpath 2>/dev/null || ls --color $realpath'
else
  zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
  zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'
fi
# Aliases (conditional on command existence)
(( ${+commands[xh]} )) && alias http="xh"
(( ${+commands[eza]} )) && alias l="eza -l --icons --git -a"
(( ${+commands[eza]} )) && alias lt="eza --tree --level=2 --long --icons --git"
(( ${+commands[eza]} )) && alias ltree="eza --tree --level=2 --icons --git"
(( ${+commands[bat]} )) && alias cat="bat"
(( ${+commands[fzf]} )) && alias f="fzf"
(( ${+commands[nvim]} )) && alias v="nvim"
(( ${+commands[kitty]} )) && alias s="kitten ssh"
(( ${+commands[brew]} )) && alias brewupgrade="brew update && brew upgrade"
# diff kitten
alias gdiff="git difftool --no-symlinks --dir-diff"
alias e="exit"
# Shell integrations
if (( ${+commands[zoxide]} )); then
  znap eval zoxide "zoxide init zsh"
fi
# Local bin
PATH="$HOME/bin:$PATH"
if [[ "$ZPROF" = true ]]; then
  zprof
fi
