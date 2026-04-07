#!/bin/sh

export EDITOR="${EDITOR:-nvim}"

export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
export ZDOTDIR="${ZDOTDIR:-$XDG_CONFIG_HOME/zsh}"

export LESSHISTFILE="$XDG_CACHE_HOME/less_history"
export PYTHON_HISTORY="$XDG_DATA_HOME/python/history"

export PATH="$XDG_CONFIG_HOME/scripts:$HOME/bin:$PATH"

# FZF defaults
export FZF_DEFAULT_OPTS="--style minimal --color 16 --layout=reverse --height 30% --preview='bat -p --color=always {}'"
export FZF_CTRL_R_OPTS="--style minimal --color 16 --info inline --no-sort --no-preview"
export MANPAGER="less -R --use-color -Dd+r -Du+b"

# colored less + termcap
export LESS_TERMCAP_mb="$(printf '%b' '[^[1;31m')"
export LESS_TERMCAP_md="$(printf '%b' '[^[1;36m')"
export LESS_TERMCAP_me="$(printf '%b' '[^[0m')"
export LESS_TERMCAP_so="$(printf '%b' '[^[01;44;33m')"
export LESS_TERMCAP_se="$(printf '%b' '[^[0m')"
export LESS_TERMCAP_us="$(printf '%b' '[^[1;32m')"
export LESS_TERMCAP_ue="$(printf '%b' '[^[0m')"

# Homebrew (macOS)
if [ -d /opt/homebrew ]; then
  export HOMEBREW_PREFIX="/opt/homebrew"
  export HOMEBREW_CELLAR="/opt/homebrew/Cellar"
  export HOMEBREW_REPOSITORY="/opt/homebrew"
  export PATH="/opt/homebrew/bin:/opt/homebrew/sbin:$PATH"
  export INFOPATH="/opt/homebrew/share/info:${INFOPATH:-}"
fi

# Linuxbrew (Linux)
if [ -d "$HOME/.linuxbrew" ] && [ -z "$HOMEBREW_PREFIX" ]; then
  export HOMEBREW_PREFIX="$HOME/.linuxbrew"
  export HOMEBREW_CELLAR="$HOME/.linuxbrew/Cellar"
  export PATH="$HOME/.linuxbrew/bin:$HOME/.linuxbrew/sbin:$PATH"
fi
