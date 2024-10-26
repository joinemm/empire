{ user, ... }:
{
  services = {
    flameshot = {
      enable = true;
      settings = {
        General = {
          disabledTrayIcon = true;
          showStartupLaunchMessage = false;
          savePath = "${user.home}/pictures/screenshots";
        };
      };
    };
  };
}
