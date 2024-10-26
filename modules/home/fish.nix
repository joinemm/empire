{
  programs.fish = {
    enable = true;

    shellAbbrs = {
      gs = "git status";
      gd = "git diff";
      ga = "git add";
    };

    shellAliases = {
      ls = "ls --color=auto --hyperlink";
      mv = "mv -iv";
      rm = "rm -I";
      cp = "cp -iv";
      ln = "ln -iv";

      ".." = "cd ..";
      "..." = "cd ../..";
      "...." = "cd ../../..";

      please = "sudo $history[1]";
      copy = "xclip -selection clipboard";
      dev = "nix develop --impure -c $SHELL";
      git-branch-cleanup = "git branch -vv | grep gone | awk '{print $1}' | xargs git branch -D";
    };

    shellInit = # fish
      ''
        set fish_greeting

        # Start X at login
        if status is-login
            if test -z "$DISPLAY" -a "$XDG_VTNR" = 1
                exec startx -- -keeptty
            end
        end

        function starship_transient_rprompt_func
          starship module time
        end
      '';
  };
}
