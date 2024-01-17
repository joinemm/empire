{pkgs, ...}: {
  home.packages = [
    (pkgs.polybar.override {
      pulseSupport = true;
    })
  ];

  xdg.configFile = {
    "polybar/config.ini".source = ./polybar.ini;
    "polybar/redshift.sh".source = pkgs.writeShellScript "redshift.sh" ''
      #!/bin/sh

      checkIfRunning() {
        if [ $(systemctl --user is-active redshift) == "active" ]; then
          return 0
        else
          return 1
        fi
      }

      changeModeToggle() {
        if checkIfRunning ; then
          systemctl --user stop redshift
        else
          systemctl --user start redshift
        fi
      }

      case $1 in
        toggle)
          changeModeToggle
          ;;
        temperature)
          if checkIfRunning ; then
            CURRENT_TEMP=$(redshift -p 2> /dev/null  | grep "Color temperature" | sed 's/.*: //')
            echo "$CURRENT_TEMP"
          else
            echo "off"
          fi
          ;;
      esac
    '';
  };
}
