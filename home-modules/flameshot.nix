{ user, ... }:
{
  services = {
    flameshot = {
      enable = true;
      settings = {
        General = {
          disabledTrayIcon = true;
          showStartupLaunchMessage = false;
          checkForUpdates = false;
          savePath = "${user.home}/pictures/screenshots";
        };
      };
    };
  };
}
