{
  pkgs,
  user,
  ...
}: {
  home.stateVersion = "23.11";
  dconf.enable = true;
  systemd.user.startServices = "sd-switch";
  programs.home-manager.enable = true;

  # this needs to be done separately for home manager
  nixpkgs = {
    config.allowUnfree = true;
    overlays = import ../overlays {inherit pkgs;};
  };

  xdg = {
    enable = true;
    userDirs = {
      enable = true;
      desktop = "/home/${user}";
      templates = "/home/${user}";
      publicShare = "/home/${user}";
      documents = "/home/${user}/documents";
      download = "/home/${user}/downloads";
      music = "/home/${user}/music";
      pictures = "/home/${user}/pictures";
      videos = "/home/${user}/videos";
    };
  };
}
