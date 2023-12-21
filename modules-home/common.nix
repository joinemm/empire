{
  home.stateVersion = "23.11";
  dconf.enable = true;
  systemd.user.startServices = "sd-switch";
  programs.home-manager.enable = true;
}
