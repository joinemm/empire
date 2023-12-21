{
  programs.git = {
    enable = true;

    userName = "Joinemm";
    userEmail = "joonas@rautiola.co";
    signing.key = "F0FE53B94A92DCAB";

    includes = [
      {
        condition = "gitdir:~/work/tii/";
        path = "~/work/tii/.gitconfig_include";
      }
    ];

    diff-so-fancy.enable = true;
    extraConfig = {
      init.defaultBranch = "master";
      color = {
        status = "auto";
        diff = "auto";
        branch = "auto";
        interactive = "auto";
        ui = "auto";
        sh = "auto";
      };
      merge = {
        conflictstyle = "diff3";
        stat = true;
        tool = "vimdiff";
      };
      push.autoSetupRemote = true;
      fetch.prune = true;
    };
  };
}
