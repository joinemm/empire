{pkgs, ...}: {
  fonts = {
    packages = with pkgs; [
      (nerdfonts.override {fonts = ["FiraCode"];})
      cantarell-fonts
      twitter-color-emoji
      sarasa-gothic
    ];
    fontconfig.defaultFonts = {
      emoji = ["Twitter Color Emoji"];
      monospace = ["Fira Code Nerd Font" "Sarasa Gothic"];
      sansSerif = ["Cantarell" "Sarasa Gothic"];
    };
  };

  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = true;
    extraPortals = [pkgs.xdg-desktop-portal-gtk];
    config.common.default = "*";
  };

  services.xserver = {
    enable = true;
    layout = "eu";
    autoRepeatDelay = 300;
    autoRepeatInterval = 25;

    # window and display manager
    windowManager.dwm.enable = true;
    displayManager = {
      startx.enable = true;
      defaultSession = "none+dwm";
    };
  };

  security = {
    # for pipewire
    rtkit.enable = true;
  };

  # use X keyboard options in console
  console.useXkbConfig = true;

  services = {
    gnome.gnome-keyring.enable = true;
    picom.enable = true;
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
  };

  programs = {
    java.enable = true;
    dconf.enable = true;
    gamemode.enable = true;
    steam.enable = true;
  };

  hardware.opengl.driSupport32Bit = true;
}
