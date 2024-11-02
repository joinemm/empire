{
  services.xserver = {
    # enable AMD Freesync
    deviceSection = ''
      Option "VariableRefresh" "true"
    '';

    xrandrHeads = [
      {
        # Force 144hz on primary display
        output = "DisplayPort-0";
        primary = true;
        monitorConfig = ''
          Modeline "3440x1440_144.00"  1086.75  3440 3744 4128 4816  1440 1443 1453 1568 -hsync +vsync
          Option "PreferredMode" "3440x1440_144.00"
        '';
      }
      {
        # LG TV should be off by default.
        output = "HDMI-A-0";
        monitorConfig = ''
          Option "Disable" "true"
          Option "RightOf" "DisplayPort-0"
        '';
      }
    ];
  };
}
