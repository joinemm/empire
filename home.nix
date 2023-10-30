{
  config,
  pkgs,
  lib,
  ...
}: let
  # nixpkgs is not updated because there has been no new release
  # see https://github.com/google/xsecurelock/issues/163
  xsecurelock = pkgs.xsecurelock.overrideAttrs (old: {
    src = pkgs.fetchFromGitHub {
      owner = "google";
      repo = "xsecurelock";
      rev = "15e9b01b02f64cc40f02184f001849971684ce15";
      sha256 = "sha256-k7xkM53hLJtjVDkv4eklvOntAR7n1jsxWHEHeRv5GJU=";
    };
  });
  dwmblocks = pkgs.callPackage ./derivations/dwmblocks.nix {};
  gpg_key = "F0FE53B94A92DCAB";
  user = "joonas";
in {
  home = {
    username = "${user}";
    homeDirectory = "/home/${user}";
    stateVersion = "23.05";
    packages = with pkgs; [
      qogir-icon-theme
      dracula-theme
      vivid
      xsecurelock
      dwmblocks
    ];
    pointerCursor = {
      package = pkgs.qogir-icon-theme;
      name = "Qogir";
      x11.enable = true;
      gtk.enable = true;
    };
    file.".xinitrc".text = ''
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

      while true; do
        dwm 2>  ~/.dwm.log
      done
    '';
  };

  dconf = {
    enable = true;
    settings = {
      "org/gtk/Settings/FileChooser" = {
        window-size = lib.hm.gvariant.mkTuple [300 50];
      };
      "org/virt-manager/virt-manager/connections" = {
        autoconnect = ["qemu:///system"];
        uris = ["qemu:///system"];
      };
    };
  };

  xresources.properties = {
    "Xft.dpi" = 128;
    "*.gappih" = 20;
    "*.gappiv" = 20;
    "*.gappoh" = 20;
    "*.gappov" = 20;
    "*.smartgaps" = 0;
    "*.bordercolor" = "#000000";
    "*.selbordercolor" = "#eaeaea";
    "*.selbgcolor" = "#81a2be";
    "*.selfgcolor" = "#000000";
    "*.foreground" = "#eaeaea";
    "*.background" = "#000000";
    "*.cursorColor" = "#aeafad";
    "*.color0" = "#000000";
    "*.color1" = "#912226";
    "*.color2" = "#778900";
    "*.color3" = "#ae7b00";
    "*.color4" = "#1d2594";
    "*.color5" = "#682a9b";
    "*.color6" = "#2b6651";
    "*.color7" = "#929593";
    "*.color8" = "#666666";
    "*.color9" = "#cc6666";
    "*.color10" = "#b5bd68";
    "*.color11" = "#f0c674";
    "*.color12" = "#81a2be";
    "*.color13" = "#b294bb";
    "*.color14" = "#8abeb7";
    "*.color15" = "#ecebec";
  };

  xdg = {
    enable = true;
    userDirs = {
      enable = true;
      desktop = "${config.home.homeDirectory}";
      templates = "${config.home.homeDirectory}";
      publicShare = "${config.home.homeDirectory}";
      documents = "${config.home.homeDirectory}/documents";
      download = "${config.home.homeDirectory}/downloads";
      music = "${config.home.homeDirectory}/music";
      pictures = "${config.home.homeDirectory}/pictures";
      videos = "${config.home.homeDirectory}/videos";
    };
    mimeApps = {
      defaultApplications = {
        "image/gif" = ["imv-dir.desktop"];
        "image/jpeg" = ["imv-dir.desktop"];
        "image/png" = ["imv-dir.desktop"];
        "image/webp" = ["imv-dir.desktop"];
        "video/mp4" = ["mpv.desktop"];
        "video/webm" = ["mpv.desktop"];
        "video/x-matroska" = ["mpv.desktop"];
        "inode/directory" = ["pcmanfm.desktop"];
        "application/pdf" = ["org.pwmt.zathura-pdf-mupdf.desktop"];
        "text/plain" = ["nvim.desktop"];
        "text/csv" = ["nvim.desktop"];
        "text/html" = ["firefox.desktop"];
        # TODO: make this desktop file somehow
        "x-scheme-handler/magnet" = ["transmission-magnet.desktop"];
      };
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
          savePath = "${config.home.homeDirectory}/pictures/screenshots";
        };
      };
    };

    dunst = {
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

    easyeffects = {
      enable = true;
    };

    picom = {
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

    batsignal = {
      enable = true;
      extraArgs = [];
    };
  };

  systemd.user = {
    targets = {
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
          Description = "startx test";
        };
      };
    };

    services = {
      dwmblocks = {
        Unit = {
          Description = "DWM statusbar service";
          PartOf = ["graphical-session.target"];
        };
        Install = {
          WantedBy = ["graphical-session.target"];
        };
        Service = {
          ExecStart = "${dwmblocks}/bin/dwmblocks-wrapped";
        };
      };

      xss-lock = {
        Unit = {
          Description = "Screenlocker service";
          PartOf = ["graphical-session.target"];
        };
        Install = {
          WantedBy = ["graphical-session.target"];
        };
        Service = {
          Environment = [
            "XSECURELOCK_COMPOSITE_OBSCURER=0"
            "XSECURELOCK_PASSWORD_PROMPT=asterisks"
            "XSECURELOCK_SHOW_HOSTNAME=0"
            "XSECURELOCK_SHOW_KEYBOARD_LAYOUT=0"
          ];
          ExecStart = "${pkgs.xss-lock}/bin/xss-lock --session \${XDG_SESSION_ID} -- ${xsecurelock}/bin/xsecurelock";
        };
      };
    };
  };

  programs = {
    home-manager.enable = true;

    zsh = {
      enable = true;
      shellAliases = {
        ls = "ls --color=auto";
        mv = "mv -iv";
        rm = "rm -I";
        cp = "cp -iv";
        ln = "ln -iv";
        please = "sudo $(fc -ln -1)";
        lf = "lfub";
        gs = "git status";
        gd = "git diff";
        ga = "git add";
        neofetch = "fastfetch";
        ssh = "TERM=xterm-256color ssh";
      };
      enableAutosuggestions = true;
      enableCompletion = true;
      historySubstringSearch.enable = true;
      syntaxHighlighting.enable = true;
      dotDir = ".config/zsh";
      envExtra = ''
        typeset -U path PATH
        path+=$HOME/bin
        path+=$HOME/bin/rofi
        path+=$HOME/bin/status
        export PATH
      '';
      sessionVariables = {
        TERMINAL = "wezterm";
        EDITOR = "nvim";
        BROWSER = "firefox";
        FM = "pcmanfm";
        LS_COLORS = "$(${pkgs.vivid}/bin/vivid generate dracula)";
      };
      history = {
        size = 1000000;
        save = 1000000;
        ignorePatterns = ["cd ..*"];
        extended = true;
      };
    };

    starship = {
      enable = true;
      settings = {
        character = {
          format = "$symbol ";
          success_symbol = "[](bold green)";
          error_symbol = "[](bold red)";
          vicmd_symbol = "[vim ](bold purple)";
        };
        add_newline = true;
        battery.disabled = true;
        git_metrics.disabled = false;
        directory.repo_root_style = "bold underline italic blue";
      };
    };

    ssh = {
      enable = true;
      includes = [
        "${config.home.homeDirectory}/work/tii/ssh_config"
      ];
      matchBlocks = {
        miso = {
          hostname = "5.161.128.99";
          user = "root";
        };
        andromeda = {
          hostname = "65.21.184.54";
          user = "captain";
        };
      };
    };

    git = {
      enable = true;

      userName = "Joinemm";
      userEmail = "joonas@rautiola.co";
      signing.key = gpg_key;

      includes = [
        {
          condition = "gitdir:${config.home.homeDirectory}/work/tii/";
          path = "${config.home.homeDirectory}/work/tii/.gitconfig_include";
        }
      ];

      diff-so-fancy.enable = true;
      extraConfig = {
        init.defaultBranch = "master";
        color = {
          status = "auto";
          diff = "auto";
          branch = "auto";
          interactive = "auto";
          ui = "auto";
          sh = "auto";
        };
        merge = {
          conflictstyle = "diff3";
          stat = true;
          tool = "vimdiff";
        };
        push.autoSetupRemote = true;
        fetch.prune = true;
      };
    };

    gpg = {
      enable = true;
      homedir = "${config.home.homeDirectory}/gnupg";
      settings = {
        default-key = gpg_key;
        auto-key-locate = "keyserver";
        keyserver = "keys.openpgp.org";
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

    wezterm = {
      enable = true;
      enableZshIntegration = true;
      extraConfig = ''
        local theme = "Dracula (Official)"
        local scheme = wezterm.color.get_builtin_schemes()[theme]
        scheme.background = "#101116"

        return {
          hide_tab_bar_if_only_one_tab = true,
          font = wezterm.font_with_fallback({
            "Fira Code Nerd Font",
            "Twemoji",
            "Twitter Color Emoji",
            "Symbols Nerd Font",
          }),
          front_end = "WebGpu",
          visual_bell = {
            fade_in_duration_ms = 75,
            fade_out_duration_ms = 75,
            target = "CursorColor",
          },
          audible_bell = "Disabled",
          font_size = 11.0,
          color_schemes = {
            [theme] = scheme,
          },
          color_scheme = theme,
          window_background_opacity = 0.8,
          keys = { {
            mods = "CTRL|SHIFT",
            key = "Enter",
            action = wezterm.action.SpawnWindow,
          } },
        }
      '';
    };
  };
}
