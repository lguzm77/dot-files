# Login-shell environment. Interactive settings live in .zshrc.
# Sourced by zsh -- no shebang needed.

# Homebrew (Apple Silicon). Safe to skip on machines without brew.
if [[ -x /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# Default programs
export EDITOR="nvim"
export VISUAL="nvim"
export PAGER="less"

# History files
export LESSHISTFILE="$XDG_CACHE_HOME/less_history"
export PYTHON_HISTORY="$XDG_DATA_HOME/python/history"

# Keep tool state out of $HOME
export CARGO_HOME="$XDG_DATA_HOME/cargo"
export GOPATH="$XDG_DATA_HOME/go"
export GOBIN="$GOPATH/bin"
export GOMODCACHE="$XDG_CACHE_HOME/go/mod"
export NPM_CONFIG_USERCONFIG="$XDG_CONFIG_HOME/npm/npmrc"
export GNUPGHOME="$XDG_DATA_HOME/gnupg"
export WGETRC="$XDG_CONFIG_HOME/wget/wgetrc"
export PYTHONSTARTUP="$XDG_CONFIG_HOME/python/pythonrc"

# Local scripts
export PATH="$XDG_CONFIG_HOME/scripts:$PATH"

# LM Studio CLI (previously the only line in a stray ~/.zshrc)
if [[ -d "$HOME/.lmstudio/bin" ]]; then
  export PATH="$PATH:$HOME/.lmstudio/bin"
fi

# fzf
export FZF_DEFAULT_OPTS="--style minimal --color 16 --layout=reverse --height 30% --preview='bat -p --color=always {}'"
export FZF_CTRL_R_OPTS="--style minimal --color 16 --info inline --no-sort --no-preview"

# Colored man pages
export MANPAGER="less -R --use-color -Dd+r -Du+b"
export LESS="R --use-color -Dd+r -Du+b"

# Colored less via termcap
export LESS_TERMCAP_mb="$(printf '%b' '\033[1;31m')"
export LESS_TERMCAP_md="$(printf '%b' '\033[1;36m')"
export LESS_TERMCAP_me="$(printf '%b' '\033[0m')"
export LESS_TERMCAP_so="$(printf '%b' '\033[01;44;33m')"
export LESS_TERMCAP_se="$(printf '%b' '\033[0m')"
export LESS_TERMCAP_us="$(printf '%b' '\033[1;32m')"
export LESS_TERMCAP_ue="$(printf '%b' '\033[0m')"
