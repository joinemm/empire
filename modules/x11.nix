{ pkgs, ... }:
{
  services = {
    xserver = {
      enable = true;

      # keyboard settings
      xkb.layout = "eu";
      autoRepeatDelay = 300;
      autoRepeatInterval = 25;

      # I don't need xterm
      excludePackages = with pkgs; [
        xorg.iceauth
        xterm
      ];

      # use startx as a display manager
      displayManager.startx.enable = true;
    };
  };

  # use X11 keyboard settings in tty
  console.useXkbConfig = true;

  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = false;
    extraPortals = with pkgs; [ xdg-desktop-portal-gtk ];
    config.common.default = "*";
  };

  environment.systemPackages = with pkgs; [
    xdotool
    xclip
    libnotify
    mesa
  ];

  services.gnome.gnome-keyring.enable = true;

  programs.dconf.enable = true;
}
