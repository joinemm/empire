{pkgs, ...}: {
  # show what package provides a commands when it's not found
  programs = {
    nix-index = {
      enable = true;
      enableZshIntegration = true;
    };

    # run commands without installing them
    # , <cmd>
    nix-index-database.comma.enable = true;
    fzf = {
      enable = true;
      enableZshIntegration = true;
    };
  };

  programs.zsh = {
    enable = true;

    dotDir = ".config/zsh";
    autosuggestion.enable = true;
    enableCompletion = true;

    syntaxHighlighting.enable = true;
    historySubstringSearch = {
      enable = true;
      searchUpKey = ["^[j" "^[[A"];
      searchDownKey = ["^[k" "^[[B"];
    };

    shellAliases = {
      ls = "ls --color=auto --hyperlink";
      mv = "mv -iv";
      rm = "rm -I";
      cp = "cp -iv";
      ln = "ln -iv";
      please = "sudo $(fc -ln -1)";
      lf = "lfub";
      gs = "git status";
      gd = "git diff";
      ga = "git add";
      ssh = "TERM=xterm-256color ssh";
      "cd ..." = "cd ../..";
      "cd ...." = "cd ../../..";
      ".." = "cd ..";
      "..." = "cd ../..";
      copy = "xclip -selection clipboard";
      dev = "nix develop --impure -c $SHELL";
      git-branch-cleanup = "git branch -vv | grep gone | awk '{print $1}' | xargs git branch -D";
    };

    envExtra = ''
      typeset -U path PATH
      path+=$HOME/bin
      path+=$HOME/bin/rofi
      path+=$HOME/bin/status
      export PATH
    '';

    sessionVariables = {
      TERMINAL = "wezterm";
      EDITOR = "nvim";
      LS_COLORS = "$(${pkgs.vivid}/bin/vivid generate dracula)";
    };

    history = {
      size = 1000000;
      save = 1000000;
      ignorePatterns = ["cd ..*" "ls"];
      extended = true;
      ignoreDups = true;
    };

    defaultKeymap = "emacs";
    initExtra = ''
      bindkey "^[[1;5D" backward-word
      bindkey "^[[1;5C" forward-word

      setopt no_nomatch

      zstyle ':completion:*' list-colors "''${(s.:.)LS_COLORS}"
    '';

    profileExtra = ''
      if [[ -z $DISPLAY ]] && [[ $(tty) = /dev/tty1 ]]; then
        startx
      fi
    '';
  };
}
