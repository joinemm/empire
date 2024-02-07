{pkgs, ...}: {
  services.picom = {
    enable = true;
    package = pkgs.picom-next;
    backend = "glx";
    vSync = true;
    fade = false;
    fadeDelta = 5;
    shadow = true;
    shadowOpacity = 0.6;
    shadowOffsets = [(-10) (-10)];
    shadowExclude = [
      "_GTK_FRAME_EXTENTS@:c"
      "class_g = 'Polybar'"
      "class_g = 'dwm'"
      "class_g = 'dwmsystray'"
      "class_g = 'xmobar'"
      "window_type *= 'normal' && ! name ~= ''"
    ];
    fadeExclude = [
      "class_g = 'xsecurelock'"
    ];
    # disable vsync for fullscreen applications
    # settings = {
    #   unredir-if-possible = true;
    # };
    # # and notifications that may draw over them
    # wintypes = {
    #   notification.redir-ignore = true;
    #   notify.redir-ignore = true;
    # };
    extraArgs = ["--no-frame-pacing"];
  };
}
