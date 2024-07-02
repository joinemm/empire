{pkgs, ...}: {
  services = {
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

  # use X11 keyboard settings in tty
  console.useXkbConfig = true;
}
