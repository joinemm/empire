{pkgs, ...}: {
  home.file.".xinitrc".text = ''
    #!/bin/sh

    ~/.fehbg

    xset b off
    xset b 0 0 0

    xrdb -merge ~/.Xresources

    systemctl --user import-environment DISPLAY XAUTHORITY PATH

    if command -v dbus-update-activation-environment > /dev/null 2>&1; then
      dbus-update-activation-environment DISPLAY XAUTHORITY
    fi

    systemctl --user start startx.target

    ${pkgs.dwmblocks}/bin/dwmblocks-wrapped &

    while true; do
      dwm 2>  ~/.dwm.log
    done
  '';
  systemd.user. targets = {
    tray = {
      Unit = {
        Description = "Home Manager system tray";
        Requires = ["graphical-session-pre.target"];
      };
    };

    graphical-session = {
      Install = {
        WantedBy = ["startx.target"];
      };
    };

    startx = {
      Unit = {
        Description = "Starts graphical-session.target without a display manager";
      };
    };
  };
}
