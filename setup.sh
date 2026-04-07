#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="${DOTFILES_DIR:-$PWD}"
SKIP_PROMPT="${SKIP_PROMPT:-false}"
DRY_RUN="${DRY_RUN:-0}"

run() {
  if [[ "$DRY_RUN" == "1" ]]; then
    echo -e "${YELLOW}[DRY]${NC} $*"
    return 0
  fi
  "$@"
}

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

log() { echo -e "${GREEN}[INFO]${NC} $*"; }
warn() { echo -e "${YELLOW}[WARN]${NC} $*"; }
err() { echo -e "${RED}[ERROR]${NC} $*" >&2; }

check_deps() {
  local missing=()
  for cmd in zsh git stow; do
    command -v "$cmd" >/dev/null || missing+=("$cmd")
  done

  if ((${#missing[@]} > 0)); then
    err "Missing dependencies: ${missing[*]}"
    err "Install them with your package manager:"
    case "$(uname)" in
      Darwin) echo "  brew install ${missing[*]}" ;;
      Linux)
        if command -v apt >/dev/null 2>&1; then
          echo "  sudo apt install ${missing[*]}"
        elif command -v dnf >/dev/null 2>&1; then
          echo "  sudo dnf install ${missing[*]}"
        elif command -v pacman >/dev/null 2>&1; then
          echo "  sudo pacman -S ${missing[*]}"
        fi
        ;;
    esac
    exit 1
  fi

  if ! zsh -c '[[ $ZSH_VERSION == 5.* || $ZSH_VERSION == 5.8 || $ZSH_VERSION == 6.* ]]' 2>/dev/null; then
    warn "zsh 5.8+ recommended for full feature support"
  fi

  log "All dependencies satisfied"
}

backup_file() {
  local file="$1"
  if [[ -e "$file" ]] || [[ -L "$file" ]]; then
    local backup="${file}.backup-$(date +%Y%m%d-%H%M%S)"

    run mv "$file" "$backup"
    warn "Backed up existing $file -> $backup"
  fi
}

symlink() {
  local src="$1" dst="$2"
  local dst_dir
  dst_dir="$(dirname "$dst")"

  if [[ -e "$dst" ]] || [[ -L "$dst" ]]; then
    local dst_target src_target
    dst_target="$(readlink -f "$dst" 2>/dev/null)" || true
    src_target="$(readlink -f "$src" 2>/dev/null)" || true
    if [[ "$dst_target" == "$src_target" ]]; then
      log "Already linked: $dst -> $src"
      return
    fi
    backup_file "$dst"
  fi

  if [[ ! -d "$dst_dir" ]]; then

    run mkdir -p "$dst_dir"
  fi


  run ln -s "$src" "$dst"
  log "Linked: $dst -> $src"
}

zsh_setup() {
  log "Setting up zsh configuration..."

  symlink "$DOTFILES_DIR/zsh/.zprofile" "$HOME/.zprofile"
  symlink "$DOTFILES_DIR/zsh/.zshrc" "$HOME/.config/zsh/.zshrc"

  if [[ -f "$DOTFILES_DIR/zsh/.p10k.zsh" ]]; then
    symlink "$DOTFILES_DIR/zsh/.p10k.zsh" "$HOME/.config/zsh/.p10k.zsh"
  fi

  for module in "$DOTFILES_DIR/zsh/modules"/*.zsh; do
    [[ -f "$module" ]] || continue
    symlink "$module" "$HOME/.config/zsh/modules/$(basename "$module")"
  done

  if [[ -d "$DOTFILES_DIR/zsh/.zsh_sessions" ]]; then
    symlink "$DOTFILES_DIR/zsh/.zsh_sessions" "$HOME/.config/zsh/.zsh_sessions"
  fi

  log "Zsh setup complete"
}

brew_packages() {
  if ! command -v brew >/dev/null; then
    warn "Homebrew not found, skipping package installation"
    return
  fi

  log "Installing Homebrew packages..."

  if [[ -f "$DOTFILES_DIR/homebrew/leaves.txt" ]]; then
    local pkgs
    pkgs=$(tr '\n' ' ' < "$DOTFILES_DIR/homebrew/leaves.txt")

    run brew install $pkgs
  fi

  log "Homebrew packages installed"
}

linux_packages() {
  case "$(uname)" in
    Linux)
      if command -v apt >/dev/null; then
        local pkgs=(
          zsh git stow curl wget fzf bat exa zoxide
          python3 python3-pip python3-venv
          man-db man-pages
        )

        run sudo apt install -y "${pkgs[@]}"
      elif command -v dnf >/dev/null; then
        local pkgs=(zsh git stow curl wget fzf bat python3)

        run sudo dnf install -y "${pkgs[@]}"
      elif command -v pacman >/dev/null; then
        local pkgs=(zsh git stow fzf bat python expac)

        run sudo pacman -S --noconfirm "${pkgs[@]}"
      fi
      ;;
  esac
}

packages() {
  log "Installing system packages..."

  case "$(uname)" in
    Darwin) brew_packages ;;
    Linux) linux_packages ;;
    *)
      warn "Unknown platform: $(uname)"
      ;;
  esac

  log "Package installation complete"
}

stow_all() {
  log "Stowing dotfile packages..."

  cd "$DOTFILES_DIR"

  for pkg in */; do
    pkg="${pkg%/}"
    [[ -f "$pkg/.stow-local-ignore" ]] && continue

    run stow -v -R -t "$HOME" "$pkg" 2>/dev/null || true
  done

  log "Stow complete"
}

render_gitconfig() {
  if [[ ! -f "$DOTFILES_DIR/git/.gitconfig.template" ]]; then
    warn "No git template found, skipping"
    return
  fi

  local email name
  if [[ -f "$HOME/.gitconfig" ]] && ! $SKIP_PROMPT; then
    warn ".gitconfig exists, skipping (use SKIP_PROMPT=1 to auto-skip)"
    return
  fi

  if $SKIP_PROMPT; then
    email="${GIT_EMAIL:-}"
    name="${GIT_NAME:-}"
  else
    echo -n "Git email: "; read -r email
    echo -n "Git name: "; read -r name
  fi

  if [[ -z "$email" ]] || [[ -z "$name" ]]; then
    warn "Email or name empty, skipping gitconfig render"
    return
  fi

  sed "s/{{ GITHUB_EMAIL }}/$email/g" "$DOTFILES_DIR/git/.gitconfig.template" |
    sed "s/{{ GITHUB_NAME }}/$name/g" > "$DOTFILES_DIR/git/.gitconfig"

  log "Rendered git config"
}

help() {
  cat <<EOF
Dotfiles Setup Script

Usage: ./setup.sh [command] [options]

Commands:
  all         Run full setup (zsh, packages, stow)
  zsh         Setup zsh configuration only
  packages    Install system packages
  stow        Stow all dotfile packages
  gitconfig   Render git config template

Options:
  --dry-run       Show what would be done without making changes
  --skip-prompt   Skip interactive prompts (for automation)
  -h, --help      Show this help

Environment Variables:
  DOTFILES_DIR    Override dotfiles directory (default: \$PWD)
  DRY_RUN         Set to 1 for dry-run mode
  SKIP_PROMPT     Set to 1 to skip prompts
  GIT_EMAIL       Git email for gitconfig render
  GIT_NAME        Git name for gitconfig render

Examples:
  ./setup.sh all
  DRY_RUN=1 ./setup.sh all
  ./setup.sh zsh --dry-run
  SKIP_PROMPT=1 ./setup.sh gitconfig
EOF
}

main() {
  local cmd="all"

  while (($# > 0)); do
    case "$1" in
      --dry-run|-n)
        DRY_RUN=1
        shift
        ;;
      --skip-prompt|-y)
        SKIP_PROMPT=true
        shift
        ;;
      --help|-h)
        help
        exit 0
        ;;
      all|zsh|packages|stow|gitconfig)
        cmd="$1"
        shift
        ;;
      *)
        err "Unknown argument: $1"
        help
        exit 1
        ;;
    esac
  done

  cd "$DOTFILES_DIR"

  case "$cmd" in
    all)
      check_deps
      zsh_setup
      packages
      stow_all
      render_gitconfig
      ;;
    zsh)
      zsh_setup
      ;;
    packages)
      check_deps
      packages
      ;;
    stow)
      check_deps
      stow_all
      ;;
    gitconfig)
      render_gitconfig
      ;;
  esac
}

main "$@"
