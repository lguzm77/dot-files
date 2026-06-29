{ pkgs, ... }:

# This file handles system-level tools - packages, homebrew casks and macOs preferences

{
  system.primaryUser = "yourname";

  # CLI tools (replaces brew install)
  environment.systemPackages = with pkgs; [
    #TODO: migrate all non-cask packages listed in /homebrew/leaves/txt here
    bat fzf delta gh lazygit lsd ripgrep tree
  ];

  # GUI apps (declarative Homebrew)
  # TODO: migrate all cask packages listed in /homebrew/leaves/txt here
  homebrew = {
    enable = true;
    onActivation.cleanup = "zap"; # This will remove all packages that are not listed here
    casks = [ "raycast" "slack" "linear-linear" "ghostty" ];
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
