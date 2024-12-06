{
  services.xserver = {
    # enable AMD Freesync
    deviceSection = ''
      Option "VariableRefresh" "true"
    '';

    # Use 144hz refresh rate
    xrandrHeads = [
      {
        output = "DP-1";
        primary = true;
        monitorConfig = ''
          Modeline "3440x1440_144.00"  1086.75  3440 3744 4128 4816  1440 1443 1453 1568 -hsync +vsync
          Option "PreferredMode" "3440x1440_144.00"
        '';
      }
    ];
  };
}
