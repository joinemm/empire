{
  services.dunst = {
    enable = true;
    settings = {
      global = {
        width = "(0, 500)";
        offset = "8x32";
        font = "monospace 11";
        gap_size = 8;
        icon_position = "right";
        frame_width = 0;
        foreground = "#bdbdbd";
        background = "#080808";
      };
      urgency_low = {
        timeout = 5;
      };
      urgency_normal = {
        timeout = 10;
      };
      urgency_critical = {
        background = "#ff6e6e";
        foreground = "#080808";
        timeout = 15;
      };
      Spotify = {
        appname = "Spotify";
        format = "Now playing\n<b>%s</b>\n%b";
      };
    };
  };
}
