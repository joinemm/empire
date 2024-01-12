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
    };
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
