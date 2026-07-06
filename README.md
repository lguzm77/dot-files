# Lev's Personal Dotfiles

Personal dotfiles, symlinks managed by GNU Stow.

# Bootstrapping

If installing in a fresh environment

- Run `sh setup.sh` to configure environment variables, text editor, shell, dependencies and symlinks

That's it, you now have an environment ready for development.

# Leaving a machine

When leaving a machine you can persist any new dependencies in `/homebrew/leaves.txt` 

```zsh
brew leaves > ./homebrew/leaves.txt
```

## Nix Configuration

The `./nix/` directory contains a Nix flake-based system configuration for macOS (Apple Silicon), managed alongside the Stow-based dotfiles.

### Structure

| Path | Purpose |
|------|---------|
| `flake.nix` | Entry point — ties all modules together |
| `hosts/mbp/configuration.nix` | **System-level** config: CLI packages (nixpkgs), Homebrew casks, macOS defaults |
| `home/home.nix` | **User-level** config via home-manager: shell, git, prompt, XDG environment variables |
| `flake.lock` | Pins exact revisions of nixpkgs, nix-darwin, and home-manager |

### Architecture

`flake.nix` defines a single `darwinConfiguration` named `"mbp"` for `aarch64-darwin`. It loads two module files:

1. **`./hosts/mbp/configuration.nix`** — manages system packages (`bat`, `neovim`, `ripgrep`, etc.), Homebrew casks (`brave-browser`, `raycast`), and macOS preferences (Dock auto-hide, Finder show all files).

2. **`./home/home.nix`** — managed via home-manager's `users.levguzman`, configures Zsh (aliases, history, FZF), Git (name/email, difftool), Starship prompt, and full XDG Base Directory compliance.

### Relationship to Stow

This Nix config runs alongside the Stow-managed configs in the rest of the repo. Nix handles CLI packages and macOS system settings, while Stow manages complex editor/terminal configs (Neovim, Wezterm, Ghostty, etc.).

### Build & Activate

```zsh
nix build ".#darwinConfigurations.mbp.system"
sudo ./result/sw/bin/darwin-rebuild switch --flake .#mbp
```

### Todos

- `home/home.nix:49` — Migrate hand-coded XDG environment variables (`XDG_CONFIG_HOME`, `XDG_DATA_HOME`, `XDG_CACHE_HOME`, etc.) to home-manager's built-in `xdg` module.
- Migrate all Stow-managed configs (Neovim, terminal emulators, etc.) into Nix to eliminate the dual-management approach.

