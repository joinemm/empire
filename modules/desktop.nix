{ user, ... }:
{
  services = {
    # don’t shutdown when power button is short-pressed
    logind.extraConfig = ''
      HandlePowerKey=ignore
    '';

    # login automatically to my user
    # the desktop will not leave my house so it's ok
    getty = {
      autologinUser = user.name;
      helpLine = "";
    };

    libinput = {
      enable = true;
      mouse.accelProfile = "flat";
    };
  };
}
