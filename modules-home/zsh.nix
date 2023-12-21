{pkgs, ...}: {
  programs.zsh = {
    enable = true;
    shellAliases = {
      ls = "ls --color=auto";
      mv = "mv -iv";
      rm = "rm -I";
      cp = "cp -iv";
      ln = "ln -iv";
      please = "sudo $(fc -ln -1)";
      lf = "lfub";
      gs = "git status";
      gd = "git diff";
      ga = "git add";
      neofetch = "fastfetch";
      ssh = "TERM=xterm-256color ssh";
      "cd ..." = "cd ../..";
      "cd ...." = "cd ../../..";
    };
    enableAutosuggestions = true;
    enableCompletion = true;
    historySubstringSearch = {
      enable = true;
      searchUpKey = ["^[j" "^[[A"];
      searchDownKey = ["^[k" "^[[B"];
    };
    syntaxHighlighting.enable = true;
    dotDir = ".config/zsh";
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
      BROWSER = "firefox";
      FM = "pcmanfm";
      LS_COLORS = "$(${pkgs.vivid}/bin/vivid generate dracula)";
    };
    history = {
      size = 1000000;
      save = 1000000;
      ignorePatterns = ["cd ..*" "ls"];
      extended = true;
    };
    defaultKeymap = "emacs";
    initExtra = ''
      bindkey "^[[1;5D" backward-word
      bindkey "^[[1;5C" forward-word
    '';
  };
}
