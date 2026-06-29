# Nix Configuration.

## Building and Activating

```
nix build .#darwinConfigurations.mbp.system
sudo ./result/sw/bin/darwin-rebuild switch --flake .#mbp
```


