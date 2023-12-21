{user, ...}: {
  home = {
    stateVersion = "23.11";
    username = user;
    homeDirectory = "/home/${user}";
  };

  dconf.enable = true;

  systemd.user.startServices = "sd-switch";

  programs.home-manager.enable = true;
}
