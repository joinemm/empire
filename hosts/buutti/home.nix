{
  inputs,
  outputs,
  pkgs,
  user,
  ...
}: let
  # homeDir = config.users.users.${user}.home;
  homeDir = "/home/${user}";
in {
  imports = [
    inputs.home-manager.nixosModules.home-manager
  ];

  home-manager.users."${user}" = {
    imports = pkgs.lib.flatten [
      (with outputs.homeManagerModules; [
        common
        xresources
        (neovim {inherit pkgs user;})
        zsh
        wezterm
        xinitrc
        mimeapps
        picom
        git
        ssh-personal
        ssh-work
        dunst
      ])
      inputs.nixvim.homeManagerModules.nixvim
    ];

    home = {
      packages = with pkgs; [
        qogir-icon-theme
        dracula-theme
        xsecurelock
      ];

      pointerCursor = {
        package = pkgs.qogir-icon-theme;
        name = "Qogir";
        x11.enable = true;
        gtk.enable = true;
      };
    };

    xdg = {
      enable = true;
      userDirs = {
        enable = true;
        desktop = homeDir;
        templates = homeDir;
        publicShare = homeDir;
        documents = "${homeDir}/documents";
        download = "${homeDir}/downloads";
        music = "${homeDir}/music";
        pictures = "${homeDir}/pictures";
        videos = "${homeDir}/videos";
      };
    };

    gtk = {
      enable = true;
      theme.name = "Dracula";
      iconTheme.name = "Qogir";
    };

    services = {
      flameshot = {
        enable = true;
        settings = {
          General = {
            disabledTrayIcon = true;
            showStartupLaunchMessage = false;
            savePath = "${homeDir}/pictures/screenshots";
          };
        };
      };

      easyeffects.enable = true;
      batsignal.enable = true;
    };

    programs = {
      starship = {
        enable = true;
        settings = {
          add_newline = true;
          battery.disabled = true;
          git_metrics.disabled = false;
          directory.repo_root_style = "bold underline italic blue";
        };
      };

      imv = {
        enable = true;
        settings = {
          options = {
            overlay_font = "monospace:10";
            overlay = true;
            overlay_position_bottom = true;
          };
          binds = {
            "w" = "exec setbg $imv_current_file";
            "<comma>" = "prev_frame";
          };
        };
      };
    };
  };
}
