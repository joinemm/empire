{
  pkgs,
  user,
  ...
}: {
  imports = [
    ./bootloader.nix
    ./sound.nix
    ./fonts.nix
    ./scripts.nix
    ./networking.nix
    ./x11.nix
  ];

  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = false;
    extraPortals = with pkgs; [xdg-desktop-portal-gtk];
    config.common.default = "*";
  };

  # don’t shutdown when power button is short-pressed
  services.logind.extraConfig = ''
    HandlePowerKey=ignore
  '';

  services = {
    gnome.gnome-keyring.enable = true;

    # login automatically to my user
    # this is fine because the hard drive is encrypted anyway
    getty = {
      autologinUser = user.name;
      helpLine = "";
    };

    picom.enable = true;

    libinput = {
      enable = true;
      mouse.accelProfile = "flat";
    };
  };

  environment.systemPackages = with pkgs; [
    libnotify
    xdotool
    xclip
    mesa
  ];
}
