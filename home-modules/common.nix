{
  home.stateVersion = "23.11";
  programs.home-manager.enable = true;
  dconf.enable = true;
  nixpkgs.config.allowUnfree = true;
  systemd.user.startServices = "sd-switch";

  services = {
    easyeffects.enable = true;
    udiskie.enable = true;
  };
}
