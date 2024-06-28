{
  programs.git = {
    enable = true;

    userName = "Joonas Rautiola";
    userEmail = "joonas@rautiola.co";
    signing.key = "0x090EB48A4669AA54";

    diff-so-fancy.enable = true;
    extraConfig = {
      init.defaultBranch = "master";
      commit.gpgsign = true;
      color = {
        status = "auto";
        diff = "auto";
        branch = "auto";
        interactive = "auto";
        ui = "auto";
        sh = "auto";
      };
      merge = {
        stat = true;
        tool = "nvimdiff2";
      };
      pull = {
        rebase = true;
      };
      push.autoSetupRemote = true;
      fetch.prune = true;
    };

    includes = [
      {
        condition = "gitdir:~/work/tii/";
        path = "~/work/tii/.gitconfig_include";
      }
    ];
  };
}
