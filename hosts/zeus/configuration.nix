{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: let
  user = "joonas";
  system = "x86_64-linux";
in {
  imports = lib.flatten [
    (with outputs.nixosModules; [
      (common {inherit user pkgs outputs;})
      (syncthing {inherit user config lib;})
      (docker {inherit user;})
      bluetooth
      gui
      work-vpn
      keyd
      (bin {inherit inputs system;})
    ])
    (with inputs.nixos-hardware.nixosModules; [
      common-cpu-amd
      common-gpu-amd
      common-pc-ssd
      common-pc
    ])
    (import ./home.nix {inherit inputs outputs pkgs user lib;})
    ./hardware-configuration.nix
  ];

  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };

  networking = {
    hostName = "zeus";
    hostId = "c5a9072d";
  };

  services = {
    syncthing = {
      settings.folders = {
        "code".enable = true;
        "notes".enable = true;
        "pictures".enable = true;
        "work".enable = true;
      };
    };
  };

  # Enable firmware update
  services.fwupd.enable = true;

  services.transmission = {
    enable = true;
    settings = {
      ratio-limit = 0;
      ratio-limit-enabled = true;
    };
  };

  # better for steam proton games
  systemd.extraConfig = "DefaultLimitNOFILE=1048576";

  programs.gamemode.enable = true;

  # Add opengl/vulkan support
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
    extraPackages = with pkgs; [
      libva
    ];
  };

  hardware.pulseaudio.daemon.config = {
    default-sample-format = "float32le";
  };

  services.xserver = {
    imwheel = {
      enable = true;
      rules = {
        "^discord$" = ''
          None, Up, Button4, 3
          None, Down, Button5, 3
        '';
      };
    };

    libinput = {
      enable = true;
      mouse.accelProfile = "flat";
    };

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

  environment.systemPackages = lib.flatten [
    (
      with pkgs; [
        # languages and dev tools
        python3
        rustup
        lua
        nodejs
        statix
        (haskellPackages.ghcWithPackages (hpkgs:
          with hpkgs; [
            xmobar
            xmonad
            xmonad-contrib
          ]))

        # apps
        spotify
        darktable
        slack
        pavucontrol
        pcmanfm
        obsidian
        dwmblocks
        gimp
        firefox
        chromium
        keyd

        # cli tools
        ffmpeg-full
        fastfetch
        wget
        mons
        file
        bottom
        xdotool
        playerctl
        pulseaudio
        alsa-utils
        jq # json parser
        fd # faster find
        dig
        rsync
        glow # render markdown on the cli
        xclip
        pciutils
        usbutils
        vulkan-tools
        mangohud
        gitmoji-cli

        # libs
        libnotify
      ]
    )
  ];
}
