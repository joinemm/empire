{pkgs, ...}: {
  home.stateVersion = "23.11";
  dconf.enable = true;
  systemd.user.startServices = "sd-switch";
  programs.home-manager.enable = true;

  # this needs to be done separately for home manager
  nixpkgs = {
    config.allowUnfree = true;
    overlays = import ../overlays {inherit pkgs;};
  };
}
