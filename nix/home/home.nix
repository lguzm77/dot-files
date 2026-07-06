{ config, pkgs, lib, ... }:

# handles user-level config—your shell, git, and dotfiles:
{
  xdg.enable = true;

  programs.zsh = {
    enable = true;

    shellAliases = {
      cat = "bat --style=header,grid";
      ls  = "lsd";
      lg  = "lazygit";
      v   = "nvim";
      e   = "exit";
    };

    setOptions = [
      "append_history" "inc_append_history" "share_history"
      "auto_menu" "menu_complete"
      "autocd"
      "auto_param_slash"
      "no_case_glob" "no_case_match"
      "globdots"
      "extended_glob"
      "interactive_comments"
    ];

    history = {
      size   = 1000000;
      save   = 1000000;
      path   = "${config.xdg.cacheHome}/zsh_history";
      share  = true;
      append = true;
      ignoreDups  = true;
      ignoreSpace = true;
    };

    enableCompletion = true;
    completionInit = ''
      zmodload zsh/complist
      zstyle ':completion:*' menu select
      zstyle ':completion:*' special-dirs true
      zstyle ':completion:*' squeeze-slashes false
    '';

    dotDir = "${config.home.homeDirectory}/.config/zsh";

    sessionVariables = {
      EDITOR            = "nvim";
      ZDOTDIR           = "${config.xdg.configHome}/zsh";
      LESSHISTFILE      = "${config.xdg.cacheHome}/less_history";
      PYTHON_HISTORY    = "${config.xdg.dataHome}/python/history";
      CARGO_HOME        = "${config.xdg.dataHome}/cargo";
      GOPATH            = "${config.xdg.dataHome}/go";
      GOBIN             = "$GOPATH/bin";
      GOMODCACHE        = "${config.xdg.cacheHome}/go/mod";
      NPM_CONFIG_USERCONFIG = "${config.xdg.configHome}/npm/npmrc";
      GNUPGHOME         = "${config.xdg.dataHome}/gnupg";
      WGETRC            = "${config.xdg.configHome}/wget/wgetrc";
      PYTHONSTARTUP     = "${config.xdg.configHome}/python/pythonrc";
      FZF_DEFAULT_OPTS  = "--style minimal --color 16 --layout=reverse --height 30% --preview='bat -p --color=always {}'";
      FZF_CTRL_R_OPTS   = "--style minimal --color 16 --info inline --no-sort --no-preview";
      MANPAGER          = "less -R --use-color -Dd+r -Du+b";
      LESS              = "R --use-color -Dd+r -Du+b";
    };

    initExtraFirst = ''
      export PATH="${config.xdg.configHome}/scripts:$PATH"
    '';

    initExtra = ''
      source <(fzf --zsh)
      eval "$(fnm env --use-on-cd --shell zsh)"

      bindkey "^a" beginning-of-line
      bindkey "^e" end-of-line
      bindkey "^k" kill-line
      bindkey "^H" backward-kill-word
      bindkey "^J" history-search-forward
      bindkey "^K" history-search-backward
      bindkey '^R' fzf-history-widget

      autoload -Uz edit-command-line
      zle -N edit-command-line
      bindkey '^X^E' edit-command-line

      export LESS_TERMCAP_mb=$(printf '%b' '\033[1;31m')
      export LESS_TERMCAP_md=$(printf '%b' '\033[1;36m')
      export LESS_TERMCAP_me=$(printf '%b' '\033[0m')
      export LESS_TERMCAP_so=$(printf '%b' '\033[01;44;33m')
      export LESS_TERMCAP_se=$(printf '%b' '\033[0m')
      export LESS_TERMCAP_us=$(printf '%b' '\033[1;32m')
      export LESS_TERMCAP_ue=$(printf '%b' '\033[0m')

      stty stop undef
    '';
  };

  programs.git = {
    enable = true;
    settings = {
      user.name = "lguzmm77";
      user.email = "code@technolev.work";
      push.autoSetupRemote = true;

      alias.undo = "reset --soft HEAD^";
      rerere.enabled = true;

      core = {
        compression = 9;
        whitespace = "error";
      };

      diff = {
        tool = "kitty";
        guitool = "kitty.gui";
      };

      difftool = {
        prompt = false;
        trustExitCode = true;
        kitty = { cmd = "kitten diff $LOCAL $REMOTE"; };
        "kitty.gui" = { cmd = "kitten diff $LOCAL $REMOTE"; };
      };
    };
  };

  programs.starship.enable = true;

  home.stateVersion = "24.11";
}
