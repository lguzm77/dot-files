# Lev's Personal Dotfiles

Personal dotfiles, managed via Nix and GNU Stow.

# Bootstrapping

If installing in a fresh environment:

```zsh
nix build ".#darwinConfigurations.mbp.system"
sudo ./result/sw/bin/darwin-rebuild switch --flake .#mbp
```

That's it, you now have an environment ready for development.

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

This Nix config runs alongside the remaining Stow-managed configs (Neovim, terminal emulators, etc.). The old `setup.sh` bootstrap script has been removed — Nix now handles everything it used to (zsh config, XDG compliance, packages). The Stow packages are still activated via `stow .` for anything not yet migrated.

### Todos

- Migrate all Stow-managed configs (Neovim, terminal emulators, etc.) into Nix to eliminate the dual-management approach.

