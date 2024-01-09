{user, ...}: {
  services = {
    flameshot = {
      enable = true;
      settings = {
        General = {
          disabledTrayIcon = true;
          showStartupLaunchMessage = false;
          savePath = "/home/${user}/pictures/screenshots";
        };
      };
    };
  };
}
