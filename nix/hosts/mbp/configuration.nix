{ pkgs, ... }:

# This file handles system-level tools - packages, homebrew casks and macOs preferences

{
  system.primaryUser = "yourname";

  # CLI tools (replaces brew install)
  environment.systemPackages = with pkgs; [
    bash
    bat
    bc
    coreutils
    delta
    docker
    elixir
    exercism
    fd
    fnm
    fzf
    gawk
    gh
    gnused
    k9s
    lazygit
    lsd
    neovim
    nmap
    pipx
    ripgrep
    stow
    tealdeer
    tree
    xh
    zoxide
    zplug
  ];

  # GUI apps (declarative Homebrew)
  homebrew = {
    enable = true;
    onActivation.cleanup = "zap"; # This will remove all packages that are not listed here
    casks = [
      "1password"
      "aerospace"
      "brave-browser"
      "discord"
      "dotnet-sdk"
      "emacs-app"
      "font-monaspace-nerd-font"
      "font-monaspice-nerd-font"
      "font-noto-sans"
      "font-sf-mono"
      "font-sf-pro"
      "font-symbols-only-nerd-font"
      "ghostty"
      "kitty"
      "linear-linear"
      "notion"
      "raycast"
      "readdle-spark"
      "sf-symbols"
      "slack"
      "spotify"
      "steam"
      "visual-studio-code"
      "warp"
      "wezterm"
      "whatsapp"
      "zoom"
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
