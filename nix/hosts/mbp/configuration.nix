{ pkgs, ... }:

# This file handles system-level tools - packages, homebrew casks and macOs preferences

{
  system.primaryUser = "levguzman";

  # CLI tools (replaces brew install)
  environment.systemPackages = with pkgs; [
    bash
    bat
    coreutils
    delta
    docker
    fd
    fzf
    gh
    k9s
    lazygit
    lsd
    neovim
    ripgrep
    stow
    tealdeer
    tree
    xh
    zoxide
    opencode
  ];

  # GUI apps (declarative Homebrew)
  homebrew = {
    enable = true;
    onActivation.cleanup = "zap"; # This will remove all packages that are not listed here
    casks = [
      "brave-browser"
      "raycast"
    ];
  };

  # macOS preferences
  system.defaults = {
    dock.autohide = true;
    finder.AppleShowAllFiles = true;
    NSGlobalDomain.KeyRepeat = 2;
  };

  # Determinate installer manages Nix itself
  nix.enable = false;

  system.stateVersion = 6;
  nixpkgs.hostPlatform = "aarch64-darwin";
}
