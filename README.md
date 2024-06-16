# Lev's Personal Dotfiles
Personal dotfiles, these will be managed by GNU Stow

- iTerm2 config in .json [deprecated, actively using kitty term instead]
- kitty terminal configuration
- .zshrc
- setup.sh
- nvim setup
- k9s tokyo night skyn

# Usage

Each bundle of files is stored in its own module with the desired installation path.
To signal `stow` to move the files to the desired location Usage

```
stow <module-name>
```
# Setup script

Run `sh setup.sh` to install all dependencies and tools.

