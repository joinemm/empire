{user, ...}: {
  services = {
    flameshot = {
      enable = true;
      settings = {
        General = {
          disabledTrayIcon = true;
          showStartupLaunchMessage = false;
          # breaks clipboard..
          # useJpgForClipboard = true;
          checkForUpdates = false;
          savePath = "/home/${user}/pictures/screenshots";
        };
      };
    };
  };
}
