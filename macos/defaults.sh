#!/usr/bin/env bash
# macOS defaults, previously declared in nix-darwin's system.defaults.
# Idempotent: safe to re-run.
#
#   ./macos/defaults.sh
#   ./macos/defaults.sh --no-restart

set -euo pipefail

RESTART=1
for arg in "$@"; do
  case "$arg" in
    --no-restart) RESTART=0 ;;
    -h | --help)
      sed -n '2,6p' "$0" | sed 's/^# \{0,1\}//'
      exit 0
      ;;
    *)
      echo "unknown argument: $arg" >&2
      exit 1
      ;;
  esac
done

log() { echo "[macos] $*"; }

# --- Dock ------------------------------------------------------------------
log "Dock: autohide"
defaults write com.apple.dock autohide -bool true

# --- Finder ----------------------------------------------------------------
log "Finder: show all files, show extensions"
defaults write com.apple.finder AppleShowAllFiles -bool true
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# --- Keyboard --------------------------------------------------------------
log "Keyboard: fast key repeat"
defaults write NSGlobalDomain KeyRepeat -int 2
defaults write NSGlobalDomain InitialKeyRepeat -int 15

if [[ "$RESTART" == "1" ]]; then
  log "restarting Dock and Finder"
  killall Dock 2>/dev/null || true
  killall Finder 2>/dev/null || true
else
  log "skipped app restart; log out or restart Dock/Finder to apply"
fi
