{
  pkgs,
  user,
  ...
}: {
  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = false;
    extraPortals = with pkgs; [xdg-desktop-portal-gtk];
    config.common.default = "*";
  };

  # use X11 keyboard settings in tty
  console.useXkbConfig = true;

  services = {
    gnome.gnome-keyring.enable = true;

    # login automatically to my user
    # this is fine because the hard drive is encrypted anyway
    getty = {
      autologinUser = user;
      helpLine = "";
    };

    picom.enable = true;

    libinput = {
      enable = true;
      mouse.accelProfile = "flat";
    };

    # use X11
    xserver = {
      enable = true;

      # keyboard settings
      xkb.layout = "eu";
      autoRepeatDelay = 300;
      autoRepeatInterval = 25;

      # I don't need xterm
      excludePackages = [pkgs.xterm];

      # use startx as a display manager
      displayManager.startx.enable = true;
    };
  };

  programs = {
    dconf.enable = true;
  };

  environment.systemPackages = with pkgs; [
    libnotify
    xdotool
    xclip
    mesa
  ];
}
