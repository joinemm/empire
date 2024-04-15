{
  pkgs,
  user,
  ...
}: {
  programs.zsh.enable = true;

  environment = {
    pathsToLink = ["/share/zsh"];
    shells = [pkgs.zsh];
  };

  users = {
    defaultUserShell = pkgs.zsh;

    users."${user}" = {
      isNormalUser = true;
      extraGroups = ["wheel" "plugdev"];
      initialPassword = "asdf";
    };
  };
}
