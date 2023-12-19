{
  inputs,
  outputs,
  config,
  pkgs,
  user,
  ...
}: let
  gpg_key = "F0FE53B94A92DCAB";
  home = "${config.users.users.${user}.home}";
in {
  imports = [
    inputs.home-manager.nixosModules.home-manager
  ];

  home-manager.users."${user}" = {
    imports = [
      inputs.nixvim.homeManagerModules.nixvim
      outputs.homeModules.xresources
    ];

    home = {
      username = "${user}";
      homeDirectory = "/home/${user}";
      stateVersion = "23.11";
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

        ${pkgs.dwmblocks}/bin/dwmblocks-wrapped &

        while true; do
          dwm 2>  ~/.dwm.log
        done
      '';
    };

    dconf = {
      enable = true;
    };

    xdg = {
      enable = true;
      userDirs = {
        enable = true;
        desktop = home;
        templates = home;
        publicShare = home;
        documents = "${home}/documents";
        download = "${home}/downloads";
        music = "${home}/music";
        pictures = "${home}/pictures";
        videos = "${home}/videos";
      };
      mimeApps = {
        enable = true;
        defaultApplications = let
          file-manager = "pcmanfm.desktop";
          editor = "nvim.desktop";
          browser = "firefox.desktop";
          video-player = "mpv.desktop";
          image-viewer = "imv-dir.desktop";
        in {
          "application/pdf" = ["org.pwmt.zathura-pdf-mupdf.desktop"];
          "image/gif" = [image-viewer];
          "image/jpeg" = [image-viewer];
          "image/png" = [image-viewer];
          "image/webp" = [image-viewer];
          "inode/directory" = [file-manager];
          "text/csv" = [editor];
          "text/html" = [browser];
          "text/plain" = [editor];
          "video/mp4" = [video-player];
          "video/webm" = [video-player];
          "video/x-matroska" = [video-player];
          "x-scheme-handler/http" = [browser];
          "x-scheme-handler/https" = [browser];
          "x-scheme-handler/chrome" = [browser];
          "application/x-extension-htm" = [browser];
          "application/x-extension-html" = [browser];
          "application/x-extension-shtml" = [browser];
          "application/xhtml+xml" = [browser];
          "application/x-extension-xhtml" = [browser];
          "application/x-extension-xht" = [browser];
          # TODO: transmission magnet
          # "x-scheme-handler/magnet" = ["transmission-magnet.desktop"];
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
            savePath = "${home}/pictures/screenshots";
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

      # Nicely reload system units when changing configs
      startServices = "sd-switch";
    };

    programs = {
      home-manager.enable = true;

      nixvim = {
        enable = true;
        viAlias = true;
        vimAlias = true;
        globals.mapleader = " ";
        colorschemes.dracula = {
          enable = true;
        };
        highlight = {
          Normal.bg = "none";
          NormalFloat.bg = "none";
          WinSeparator = {
            bg = "none";
            fg = "#eaeaea";
          };
          CursorLine = {
            bg = "none";
            underline = true;
          };
          CursorLineNr.link = "CursorLine";
          VirtColumn.fg = "#000000";
          SignColumn.bg = "none";
        };
        options = {
          autoindent = true;
          number = true;
          relativenumber = true;
          shiftwidth = 2;
          tabstop = 2;
          softtabstop = 2;
          scrolloff = 8;
          expandtab = true;
          smartindent = true;
          wrap = false;
          hlsearch = false;
          incsearch = true;
          termguicolors = true;
          cursorline = true;
          signcolumn = "yes";
          colorcolumn = "81";
          backup = false;
          swapfile = false;
          undofile = true;
          undodir = "${home}/.vim/undodir";
        };
        keymaps = [
          {
            action = ":CHADopen<CR>";
            key = "t";
            mode = "n";
          }
          {
            action = "<cmd>TroubleToggle<cr>";
            key = "<leader>t";
            mode = "n";
          }
          {
            # this is here because it needs insert mode
            action = "vim.lsp.buf.signature_help";
            key = "<C-h>";
            mode = "i";
          }
          {
            action = ''"+y'';
            key = "<leader>y";
            mode = ["n" "v"];
          }
        ];
        plugins = {
          nvim-colorizer.enable = true;
          fidget.enable = true;
          lightline.enable = true;
          indent-blankline.enable = true;
          gitgutter.enable = true;
          telescope.enable = true;
          treesitter = {
            enable = true;
            indent = true;
          };
          nvim-autopairs.enable = true;
          chadtree = {
            enable = true;
            keymap = {
              windowManagement.quit = ["q" "t"];
              fileOperations.trash = ["D"];
            };
          };
          trouble.enable = true;
          lsp-format.enable = true;
          nvim-lightbulb.enable = true;
          cmp-nvim-lsp.enable = true;
          cmp-treesitter.enable = true;
          comment-nvim.enable = true;
          nvim-cmp = {
            enable = true;
            snippet.expand = "luasnip";
            preselect = "None";
            autoEnableSources = true;
            sources = [
              {
                groupIndex = 1;
                name = "luasnip";
              }
              {
                groupIndex = 1;
                name = "nvim_lsp";
              }
              {
                groupIndex = 2;
                name = "path";
              }
            ];
            mapping = {
              "<CR>" = ''
                cmp.mapping({
                  i = function(fallback)
                    if cmp.visible() and cmp.get_active_entry() then
                      cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = false })
                    else
                      fallback()
                    end
                  end,
                  s = cmp.mapping.confirm({ select = true }),
                  c = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true }),
                })
              '';

              "<C-e>" = "cmp.mapping.abort()";

              "<Tab>" = ''
                cmp.mapping(function(fallback)
                  if cmp.visible() then
                    cmp.select_next_item()
                  else
                    fallback()
                  end
                end, { "i", "s" })
              '';

              "<S-Tab>" = ''
                cmp.mapping(function(fallback)
                  if cmp.visible() then
                    cmp.select_prev_item()
                  else
                    fallback()
                  end
                end, { "i", "s" })
              '';
            };
          };
          lsp = {
            enable = true;
            keymaps = {
              diagnostic = {
                # vim.diagnostic.#
                "<leader>vd" = "open_float";
                "<leader>k" = "goto_prev";
                "<leader>j" = "goto_next";
              };
              lspBuf = {
                # vim.lsp.buf.#
                "gd" = "definition";
                "gt" = "type_definition";
                "gr" = "references";
                "gi" = "implementation";
                "K" = "hover";
                "<leader>ca" = "code_action";
                "<leader>rn" = "rename";
              };
            };
            servers = {
              nil_ls = {
                enable = true;
                settings.formatting.command = ["alejandra"];
              };
              lua-ls.enable = true;
              pylsp = {
                enable = true;
                settings.plugins = {
                  pylint.enabled = true;
                  pylsp_mypy = {
                    enabled = true;
                    live_mode = true;
                  };
                  isort.enabled = true;
                  black.enabled = true;
                };
              };
            };
          };
        };
        extraPlugins = with pkgs.vimPlugins; [
          vim-wakatime
        ];
        extraConfigLua = ''
          local cmp_autopairs = require('nvim-autopairs.completion.cmp')
          local cmp = require('cmp')
          cmp.event:on(
            'confirm_done',
            cmp_autopairs.on_confirm_done()
          )
        '';
      };

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
        historySubstringSearch = {
          enable = true;
          searchUpKey = ["^[j" "^[[A"];
          searchDownKey = ["^[k" "^[[B"];
        };
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
          ignorePatterns = ["cd ..*" "ls"];
          extended = true;
        };
        defaultKeymap = "emacs";
        initExtra = ''
          bindkey "^[h" backward-word
          bindkey "^[l" forward-word
        '';
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
          "${home}/work/tii/ssh_config"
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
            condition = "gitdir:${home}/work/tii/";
            path = "${home}/work/tii/.gitconfig_include";
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
        homedir = "${home}/gnupg";
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
  };
}
