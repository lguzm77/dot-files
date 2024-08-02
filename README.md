# Lev's Personal Dotfiles
Personal dotfiles, these will be managed by GNU Stow. Some goodies include

- Some nice fonts 
- Kitty terminal configuration
- Personal neovim configuration
- Personal .zshrc configuration 
- k9s tokyo night skyn
- Personal setup script (cross platform!)

# Usage

Each bundle of files is stored in its own module with the desired installation path.
To signal `stow` to move the files to the desired location Usage

```
stow <module-name>
```
# Setup script

Run `sh setup.sh` to install all dependencies and tools.

# Improvements backlog

- setup.sh 
    - Migrate package manager from homebrew to nix.
- Migrate all configuration to a single .config folder for easier management
