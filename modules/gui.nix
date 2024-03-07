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
    xdgOpenUsePortal = false;
    extraPortals = with pkgs; [xdg-desktop-portal-gtk];
    config.common.default = "*";
  };

  xdg.mime = {
    enable = true;
    defaultApplications = let
      file-manager = "pcmanfm.desktop";
      editor = "nvim.desktop";
      browser = "firefox.desktop";
      video-player = "mpv.desktop";
      image-viewer = "imv-dir.desktop";
    in {
      "application/pdf" = ["org.pwmt.zathura-pdf-mupdf.desktop"];
      "image/gif" = [image-viewer];
      "image/jpeg" = [image-viewer];
      "image/png" = [image-viewer];
      "image/webp" = [image-viewer];
      "inode/directory" = [file-manager];
      "text/csv" = [editor];
      "text/html" = [browser];
      "text/plain" = [editor];
      "video/mp4" = [video-player];
      "video/webm" = [video-player];
      "video/x-matroska" = [video-player];
      "x-scheme-handler/http" = [browser];
      "x-scheme-handler/https" = [browser];
      "x-scheme-handler/chrome" = [browser];
      "application/x-extension-htm" = [browser];
      "application/x-extension-html" = [browser];
      "application/x-extension-shtml" = [browser];
      "application/xhtml+xml" = [browser];
      "application/x-extension-xhtml" = [browser];
      "application/x-extension-xht" = [browser];
      "x-scheme-handler/magnet" = ["transmission-magnet.desktop"];
    };
  };

  # use X11 keyboard settings in tty
  console.useXkbConfig = true;

  services = {
    gnome.gnome-keyring.enable = true;

    # compositor
    picom.enable = true;

    # use X11
    xserver = {
      enable = true;

      # keyboard settings
      xkb.layout = "eu";
      autoRepeatDelay = 300;
      autoRepeatInterval = 25;

      # use startx as a display manager
      displayManager.startx.enable = true;
      libinput = {
        enable = true;
        mouse.accelProfile = "flat";
      };
    };
  };

  programs = {
    dconf.enable = true;
  };

  environment.systemPackages = with pkgs; [
    libnotify
  ];
}
