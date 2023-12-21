{
  services.picom = {
    enable = true;
    backend = "glx";
    vSync = true;
    fade = true;
    fadeDelta = 5;
    shadow = true;
    shadowOpacity = 0.6;
    shadowOffsets = [(-10) (-10)];
    shadowExclude = [
      "class_g = 'Polybar'"
      "_GTK_FRAME_EXTENTS@:c"
      "class_g = 'dwm'"
      "class_g = 'dwmsystray'"
      "window_type *= 'normal' && ! name ~= ''"
      "class_g = 'Peek'"
    ];
  };
}
