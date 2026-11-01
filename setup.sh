#!/usr/bin/env bash
# Bootstrap and re-sync this dotfiles repo.
#
# The repo mirrors $HOME, so every package is stowed with one target and the
# layout tells you where a file ends up:
#
#   nvim/.config/nvim/...      -> ~/.config/nvim/...
#   kitty/.config/kitty/...    -> ~/.config/kitty/...
#   k9s/.config/k9s/...        -> ~/.config/k9s/...
#   starship/.config/starship.toml -> ~/.config/starship.toml
#   zsh/.zshenv                -> ~/.zshenv
#   zsh/.config/zsh/...        -> ~/.config/zsh/...
#   git/.gitconfig             -> ~/.gitconfig
#   fonts/Library/Fonts/*.otf  -> ~/Library/Fonts/*.otf
#
# Written for bash 3.2 so it runs with the bash macOS ships.

set -euo pipefail

DOTFILES="${DOTFILES_DIR:-$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)}"
TARGET="${HOME}"
DRY_RUN=0
NVIM_CONFIG="${NVIM_CONFIG:-nvim}"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

log() { echo -e "${GREEN}[ ok ]${NC} $*"; }
warn() { echo -e "${YELLOW}[warn]${NC} $*"; }
err() { echo -e "${RED}[fail]${NC} $*" >&2; }
step() { echo -e "\n${BLUE}==>${NC} $*"; }
die() {
  err "$*"
  exit 1
}

run() {
  if [[ "$DRY_RUN" == "1" ]]; then
    echo -e "       ${YELLOW}dry-run:${NC} $*"
    return 0
  fi
  "$@"
}

backup() {
  local path="$1" dest
  dest="${path}.backup-$(date +%Y%m%d-%H%M%S)"
  run mv "$path" "$dest"
  warn "backed up $path -> $dest"
}

# True when $1 is a live symlink resolving into this repo (stow or a previous
# run made it). realpath is missing on very old macOS, in which case we fall
# back to the backup path, which is safe if noisier.
is_repo_path() {
  local resolved
  command -v realpath >/dev/null 2>&1 || return 1
  resolved="$(realpath "$1" 2>/dev/null)" || return 1
  case "$resolved" in
    "$DOTFILES"/*) return 0 ;;
  esac
  return 1
}

# Clear whatever sits at a managed path so stow can own it. Removes leftover
# nix-store symlinks (dead since nix was removed), unlinks stale repo links when
# switching configs, and backs up real user data. $2 is the file in the repo the
# path should resolve to; when it already does, nothing is touched -- that is
# what makes re-runs idempotent.
clear_path() {
  local path="$1" want="${2:-}" target
  if [[ -n "$want" && -e "$path" && "$path" -ef "$want" ]]; then
    return 0
  fi
  if [[ -L "$path" ]]; then
    target="$(readlink "$path")"
    case "$target" in
      /nix/store/*)
        warn "removing dead nix symlink $path"
        run rm -f "$path"
        return 0
        ;;
    esac
    if is_repo_path "$path"; then
      log "replacing stale repo link $path"
      run rm -f "$path"
      return 0
    fi
    backup "$path"
  elif [[ -e "$path" ]]; then
    backup "$path"
  fi
}

# Walk the package mirroring it onto the target and clear every path stow is
# about to create. Descends into directories that exist on both sides, which is
# how a dead ~/.config/nvim symlink gets found under a package entry .config/.
clear_tree() {
  local src="$1" dst="$2" entry name
  for entry in "$src"/* "$src"/.[!.]*; do
    [[ -e "$entry" ]] || continue
    name="$(basename "$entry")"
    case "$name" in
      README.md | LICENSE | .gitignore | .stowrc | .DS_Store | *.template) continue ;;
    esac
    if [[ -d "$entry" && ! -L "$entry" ]]; then
      if [[ -L "$dst/$name" ]]; then
        clear_path "$dst/$name" "$entry"
      elif [[ -d "$dst/$name" ]]; then
        clear_tree "$entry" "$dst/$name"
      elif [[ -e "$dst/$name" ]]; then
        clear_path "$dst/$name" "$entry"
      fi
    else
      clear_path "$dst/$name" "$entry"
    fi
  done
}

stow_pkg() {
  local pkg="$1" dir="${2:-$DOTFILES}" fold="${3:-fold}"
  local extra=""
  [[ -d "$dir/$pkg" ]] || die "package not found: $dir/$pkg"
  [[ "$fold" == "nofold" ]] && extra="--no-folding"

  clear_tree "$dir/$pkg" "$TARGET"
  run mkdir -p "$TARGET"

  # shellcheck disable=SC2086 # $extra is an intentional flag list
  if run stow --dir="$dir" --target="$TARGET" --restow $extra "$pkg"; then
    log "stowed $pkg -> $TARGET"
  else
    err "stow failed for $pkg (package: $dir/$pkg)"
    return 1
  fi
}

# ---------------------------------------------------------------------------
# Steps
# ---------------------------------------------------------------------------
install_deps() {
  step "Homebrew packages"

  if ! command -v brew >/dev/null 2>&1; then
    err "Homebrew is not installed."
    echo "  /bin/bash -c \"\$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)\""
    echo "  then re-run: ./setup.sh deps"
    return 1
  fi

  [[ -f "$DOTFILES/homebrew/Brewfile" ]] || die "missing homebrew/Brewfile"
  run brew bundle --file "$DOTFILES/homebrew/Brewfile"
  log "brew bundle complete"
}

render_gitconfig() {
  step "Render git config"

  local template="$DOTFILES/git/.gitconfig.template"
  local out="$DOTFILES/git/.gitconfig"
  [[ -f "$template" ]] || die "missing $template"

  local name="${GITHUB_NAME:-}" email="${GITHUB_EMAIL:-}"

  # Reuse whatever was rendered last time rather than prompting again.
  if [[ -z "$name" && -f "$out" ]]; then
    name="$(awk -F'= ' '/^[[:space:]]*name[[:space:]]*=/{print $2; exit}' "$out")"
  fi
  if [[ -z "$email" && -f "$out" ]]; then
    email="$(awk -F'= ' '/^[[:space:]]*email[[:space:]]*=/{print $2; exit}' "$out")"
  fi

  if [[ -z "$name" || -z "$email" ]]; then
    if [[ -t 0 ]]; then
      [[ -z "$name" ]] && read -r -p "git user.name: " name
      [[ -z "$email" ]] && read -r -p "git user.email: " email
    fi
  fi

  if [[ -z "$name" || -z "$email" ]]; then
    warn "GITHUB_NAME / GITHUB_EMAIL not set and nothing to reuse"
    warn "skipping render; ~/.gitconfig will be missing or stale"
    warn "re-run with: GITHUB_NAME=you GITHUB_EMAIL=you@example.com ./setup.sh render"
    return 1
  fi

  if [[ "$DRY_RUN" == "1" ]]; then
    echo -e "       ${YELLOW}dry-run:${NC} render $out as $name <$email>"
    return 0
  fi

  sed -e "s|{{ GITHUB_NAME }}|$name|g" \
    -e "s|{{ GITHUB_EMAIL }}|$email|g" \
    "$template" >"$out.tmp"
  mv "$out.tmp" "$out"
  chmod 600 "$out"
  log "rendered $out ($name <$email>)"
}

install_fonts() {
  step "Fonts"

  local src="$DOTFILES/fonts/Library/Fonts" name
  [[ -d "$src" ]] || {
    warn "no fonts/Library/Fonts directory"
    return 0
  }

  run mkdir -p "$TARGET/Library/Fonts"
  # Drop byte-identical copies so a first run does not leave 8MB of backups.
  for font in "$src"/*; do
    name="$(basename "$font")"
    if [[ -e "$TARGET/Library/Fonts/$name" && "$TARGET/Library/Fonts/$name" -ef "$font" ]]; then
      continue
    elif [[ -e "$TARGET/Library/Fonts/$name" ]]; then
      if cmp -s "$font" "$TARGET/Library/Fonts/$name"; then
        run rm -f "$TARGET/Library/Fonts/$name"
      else
        backup "$TARGET/Library/Fonts/$name"
      fi
    fi
  done

  stow_pkg fonts || warn "fonts package not stowed"
}

stow_all() {
  step "Symlink configs"

  local pkg
  for pkg in kitty k9s starship; do
    stow_pkg "$pkg" || warn "$pkg package not stowed"
  done

  # zsh gets file-level links because zsh writes .zcompdump into ~/.config/zsh.
  stow_pkg zsh "$DOTFILES" nofold || warn "zsh package not stowed"

  stow_git
}

stow_git() {
  if [[ ! -f "$DOTFILES/git/.gitconfig" ]]; then
    warn "git/.gitconfig not rendered yet; skipping git package"
    return 0
  fi
  stow_pkg git || warn "git package not stowed"
}

stow_nvim() {
  step "Neovim"

  case "$NVIM_CONFIG" in
    nvim) stow_pkg nvim || warn "nvim package not stowed" ;;
    corporate-nvim) stow_pkg nvim "$DOTFILES/corporate-nvim" || warn "nvim package not stowed" ;;
    *) die "NVIM_CONFIG must be 'nvim' or 'corporate-nvim' (got: $NVIM_CONFIG)" ;;
  esac
}

apply_macos_defaults() {
  step "macOS defaults"
  [[ -x "$DOTFILES/macos/defaults.sh" ]] || die "missing macos/defaults.sh"
  run "$DOTFILES/macos/defaults.sh"
}

check() {
  step "Environment check"

  local missing="" cmd
  for cmd in git stow brew; do
    if command -v "$cmd" >/dev/null 2>&1; then
      log "$cmd found"
    else
      missing="$missing $cmd"
    fi
  done

  for cmd in nvim kitty starship fzf; do
    command -v "$cmd" >/dev/null 2>&1 || missing="$missing $cmd"
  done

  [[ -n "$missing" ]] && warn "missing:$missing (run: ./setup.sh deps)"

  step "Managed paths"
  local path
  for path in \
    "$TARGET/.zshenv" \
    "$TARGET/.gitconfig" \
    "$TARGET/.config/nvim" \
    "$TARGET/.config/kitty" \
    "$TARGET/.config/k9s" \
    "$TARGET/.config/starship.toml" \
    "$TARGET/.config/zsh/.zshrc" \
    "$TARGET/Library/Fonts/DankMonoNerdFont-Regular.otf"; do
    if [[ -L "$path" && -e "$path" ]]; then
      log "$path -> $(readlink "$path")"
    elif [[ -L "$path" ]]; then
      err "$path is a dangling symlink -> $(readlink "$path")"
    elif [[ -e "$path" ]]; then
      warn "$path exists but is not managed by stow"
    else
      warn "$path is missing"
    fi
  done

  step "Git identity"
  if git config --get user.email >/dev/null 2>&1; then
    log "user.email = $(git config --get user.email)"
  else
    warn "no git identity configured (run: ./setup.sh render)"
  fi
}

help() {
  cat <<'EOF'
Dotfiles setup

Usage: ./setup.sh [command]

Commands:
  all       deps -> render -> stow -> nvim -> fonts   (default)
  deps      install Homebrew packages from homebrew/Brewfile
  render    render git/.gitconfig.template -> git/.gitconfig
  stow      symlink kitty, k9s, starship, zsh, git
  nvim      symlink only the Neovim config
  fonts     symlink fonts into ~/Library/Fonts
  macos     apply macOS defaults
  check     report missing tools and broken links

Options:
  --dry-run, -n   print what would happen, change nothing
  -h, --help      this help

Environment:
  DOTFILES_DIR    repo location (default: script directory)
  NVIM_CONFIG     nvim | corporate-nvim   (default: nvim)
  GITHUB_NAME     used by render
  GITHUB_EMAIL    used by render

Examples:
  ./setup.sh --dry-run all
  GITHUB_NAME=lev GITHUB_EMAIL=lev@example.com ./setup.sh all
  NVIM_CONFIG=corporate-nvim ./setup.sh nvim
EOF
}

main() {
  local cmd="all"

  while (($# > 0)); do
    case "$1" in
      --dry-run | -n) DRY_RUN=1 ;;
      -h | --help)
        help
        exit 0
        ;;
      all | deps | render | stow | nvim | fonts | macos | check) cmd="$1" ;;
      *)
        err "unknown argument: $1"
        help
        exit 1
        ;;
    esac
    shift
  done

  cd "$DOTFILES" || die "cannot cd to $DOTFILES"

  case "$cmd" in
    all)
      install_deps || warn "dependency install skipped"
      render_gitconfig || warn "git config render skipped"
      stow_all
      stow_nvim
      install_fonts
      step "Done"
      echo "Open a new shell, then run: ./setup.sh check"
      ;;
    deps) install_deps ;;
    render) render_gitconfig ;;
    stow) stow_all ;;
    nvim) stow_nvim ;;
    fonts) install_fonts ;;
    macos) apply_macos_defaults ;;
    check) check ;;
  esac
}

main "$@"
