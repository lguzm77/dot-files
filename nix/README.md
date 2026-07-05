# Nix Configuration.

## Building and Activating

```zsh

nix build ".#darwinConfigurations.mbp.system"

sudo ./result/sw/bin/darwin-rebuild switch --flake .#mbp
```


