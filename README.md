# Lev's Personal Dotfiles

Symlinked with GNU Stow, packages from Homebrew. One `setup.sh`, no Nix.

## Bootstrap a New Mac

```zsh
git clone https://github.com/lguzm77/dot-files ~/dot-files
cd ~/dot-files

# 1. Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# 2. Packages, git identity, symlinks, fonts
GITHUB_NAME=you GITHUB_EMAIL=you@example.com ./setup.sh all

# 3. Optional: macOS defaults
./setup.sh macos

# 4. Verify
./setup.sh check
```

Open a new terminal afterwards so `~/.zshenv` is picked up.

## How It Works

The repo mirrors `$HOME`: `nvim/.config/nvim/init.lua` becomes
`~/.config/nvim/init.lua`. `./setup.sh` stows each package with
`--target="$HOME"`, so paths are self-documenting.

| Package | Lands at |
|---|---|
| `zsh/` | `~/.zshenv`, `~/.config/zsh/{.zprofile,.zshrc}` |
| `git/` | `~/.gitconfig` (rendered from `.gitconfig.template`) |
| `nvim/` | `~/.config/nvim` |
| `kitty/` | `~/.config/kitty` |
| `k9s/` | `~/.config/k9s` |
| `starship/` | `~/.config/starship.toml` |
| `fonts/` | `~/Library/Fonts` |

`./setup.sh` is idempotent: re-running only fixes what drifted, backs up real
files it would overwrite, and replaces dead symlinks.

## Neovim

`nvim/` is the canonical config. `corporate-nvim/` is an alternate for work
machines:

```zsh
NVIM_CONFIG=corporate-nvim ./setup.sh nvim
./setup.sh nvim        # back to the personal config
```

## Packages

`homebrew/Brewfile` is the single source of truth. To re-snapshot after
installing something:

```zsh
brew bundle dump --force --file homebrew/Brewfile
```

## Daily Use

```zsh
cd ~/dot-files
nvim .                  # edit configs in place; symlinks pick changes up
./setup.sh stow         # re-link after adding a package
./setup.sh check        # what's missing or dangling
```

## Layout

```
setup.sh                  bootstrap and re-sync
homebrew/Brewfile         formulae + casks
macos/defaults.sh         macOS defaults
zsh/  git/  starship/     shell, git, prompt
nvim/  corporate-nvim/    Neovim configs
kitty/  k9s/  fonts/      terminal, k9s, Nerd Font
nix/                      legacy nix-darwin config, unused
```
