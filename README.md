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

