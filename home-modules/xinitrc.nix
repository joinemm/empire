{
  home.file.".xinitrc".text = ''
    #!/usr/bin/env bash

    systemctl --user import-environment DISPLAY XAUTHORITY PATH
    if command -v dbus-update-activation-environment > /dev/null 2>&1; then
      dbus-update-activation-environment DISPLAY XAUTHORITY
    fi
    systemctl --user start startx.target

    xrdb -merge ~/.Xresources

    [[ -f ~/.fehbg ]] && ~/.fehbg

    xsetroot -cursor_name left_ptr
    exec xmonad
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
