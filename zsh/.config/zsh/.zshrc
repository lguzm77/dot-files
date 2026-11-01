# Interactive zsh. Environment lives in .zprofile.
# Keep this file plugin-free: everything optional is guarded by command -v.

[[ -o interactive ]] || return

# ---------------------------------------------------------------------------
# Completion
# ---------------------------------------------------------------------------
zmodload zsh/complist
autoload -U compinit && compinit
autoload -U colors && colors

zstyle ':completion:*' menu select                    # tab opens the menu
zstyle ':completion:*' special-dirs true              # show . and .. in menus
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS} # colorize completions
zstyle ':completion:*' squeeze-slashes false          # keep /*/ expansion working

# ---------------------------------------------------------------------------
# Options
# ---------------------------------------------------------------------------
setopt append_history inc_append_history share_history
setopt auto_menu menu_complete
setopt autocd
setopt auto_param_slash
setopt no_case_glob no_case_match
setopt globdots
setopt extended_glob
setopt interactive_comments
unsetopt prompt_sp
[[ -t 0 ]] && stty stop undef

# ---------------------------------------------------------------------------
# History
# ---------------------------------------------------------------------------
HISTSIZE=1000000
SAVEHIST=1000000
HISTFILE="$XDG_CACHE_HOME/zsh_history"
HISTCONTROL=ignoreboth

# ---------------------------------------------------------------------------
# Aliases
# ---------------------------------------------------------------------------
command -v bat >/dev/null 2>&1 && alias cat='bat --style=header,grid'
command -v lsd >/dev/null 2>&1 && alias ls='lsd'
command -v lazygit >/dev/null 2>&1 && alias lg='lazygit'

alias v='nvim'
alias e='exit'
alias gdiff='git difftool --no-symlinks --dir-diff' # kitty diff tool

# ---------------------------------------------------------------------------
# Integrations
# ---------------------------------------------------------------------------
if command -v fzf >/dev/null 2>&1; then
  source <(fzf --zsh)
fi

if command -v zoxide >/dev/null 2>&1; then
  eval "$(zoxide init zsh)"
fi

if command -v fnm >/dev/null 2>&1; then
  eval "$(fnm env --use-on-cd --shell zsh)"
fi

if command -v wt >/dev/null 2>&1; then
  eval "$(wt config shell init zsh)"
fi

# ---------------------------------------------------------------------------
# Prompt
# ---------------------------------------------------------------------------
if command -v starship >/dev/null 2>&1; then
  eval "$(starship init zsh)"
else
  PROMPT='%F{cyan}%~%f %# '
fi

# ---------------------------------------------------------------------------
# Key bindings
# ---------------------------------------------------------------------------
bindkey "^a" beginning-of-line
bindkey "^e" end-of-line
bindkey "^k" kill-line
bindkey "^H" backward-kill-word
bindkey "^J" history-search-forward
bindkey "^K" history-search-backward

command -v fzf >/dev/null 2>&1 && bindkey '^R' fzf-history-widget

# Ctrl+X Ctrl+E opens the current command in $EDITOR
autoload -Uz edit-command-line
zle -N edit-command-line
bindkey '^X^E' edit-command-line
