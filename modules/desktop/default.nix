{ pkgs, user, ... }:
{
  imports = [
    ./bootloader.nix
    ./sound.nix
    ./fonts.nix
    ./scripts.nix
    ./networking.nix
    ./x11.nix
  ];

  zramSwap.enable = true;

  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = false;
    extraPortals = with pkgs; [ xdg-desktop-portal-gtk ];
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

  programs.dconf.enable = true;

  programs.zsh.enable = true;
  users.users."${user.name}".shell = pkgs.zsh;

  environment.variables = {
    GOPATH = "${user.home}/.local/share/go";
  };

  environment.systemPackages = with pkgs; [
    libnotify
    xdotool
    xclip
    mesa
  ];
}
