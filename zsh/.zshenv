# Read by every zsh: login, interactive and scripts.
# Keep this file small and fast -- it runs before anything else.
#
# zsh looks for .zshenv in ~ first, then reads .zprofile/.zshrc/.zlogin from
# whatever $ZDOTDIR points at, so setting ZDOTDIR here is enough to move the
# rest of the config into ~/.config/zsh without touching /etc/zsh/zshenv.

# XDG Base Directory
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
export XDG_STATE_HOME="${XDG_STATE_HOME:-$HOME/.local/state}"

# All remaining zsh config lives here
export ZDOTDIR="$XDG_CONFIG_HOME/zsh"
