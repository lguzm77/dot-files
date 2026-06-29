{ config, pkgs, lib, ... }:

# handles user-level config—your shell, git, and dotfiles:
{
  programs.zsh = {
    enable = true;
    shellAliases = {
      cat = "bat --style=header,grid";
      ls = "lsd";
      lg = "lazygit";
    };
    # TODO: migrate /zsh config to here
    initContent = ''
      eval "$(fnm env --use-on-cd --shell zsh)"
      # ... rest of your shell config
    '';
  };

# TODO: migrate our .gitconfig settings here
  programs.git = {
    enable = true;
    settings = {
      user.name = "lguzmm77";
      user.email = "code@technolev.work";
      push.autoSetupRemote = true;
    };
  };

  programs.starship.enable = true; # 

  home.stateVersion = "24.11";
}
