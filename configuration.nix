{
  config,
  pkgs,
  ...
}: let
  dwmblocks = pkgs.dwmblocks.overrideAttrs (old: {
    src = pkgs.fetchFromGitHub {
      owner = "joinemm";
      repo = "dwmblocks";
      rev = "master";
      sha256 = "0FJlH9lcORjulhcEX7EDOAzvWKCf+Fq9IX1AMRT/gaY=";
    };
    nativeBuildInputs = with pkgs; [
      xorg.libX11
      xorg.libX11.dev
      xorg.libXft
      xorg.libXinerama
    ];
    installPhase = ''make PREFIX=$out DESTDIR="" install'';
    unpackPhase = ''cp -r $src/* .'';
  });

  # need to build from source to get newest features
  # see https://github.com/google/xsecurelock/issues/163
  xsecurelock = pkgs.xsecurelock.overrideAttrs (old: {
    src = pkgs.fetchFromGitHub {
      owner = "google";
      repo = "xsecurelock";
      rev = "15e9b01b02f64cc40f02184f001849971684ce15";
      sha256 = "sha256-k7xkM53hLJtjVDkv4eklvOntAR7n1jsxWHEHeRv5GJU=";
    };
  });

  user = "joonas";
in {
  system.stateVersion = "22.11";

  imports = [
    ./hardware-configuration.nix
  ];

  nixpkgs.config.allowUnfree = true;
  nix.settings = {
    substituters = [
      "https://cache.vedenemo.dev"
      "https://cache.nixos.org"
    ];
    trusted-public-keys = [
      "cache.vedenemo.dev:RGHheQnb6rXGK5v9gexJZ8iWTPX6OcSeS56YeXYzOcg="
    ];
    trusted-users = ["${user}"];
    experimental-features = ["nix-command" "flakes"];
  };

  users = {
    defaultUserShell = pkgs.zsh;
    users.${user} = {
      isNormalUser = true;
      extraGroups = ["wheel" "docker" "mlocate" "networkmanager"];
      initialPassword = "asdf";
      shell = pkgs.zsh;
    };
  };

  systemd.timers = {
    "low-battery" = {
      wantedBy = ["timers.target"];
      timerConfig = {
        OnBootSec = "1m";
        OnUnitActiveSec = "1m";
        Unit = "low-battery.service";
      };
    };
  };

  systemd.services = {
    "low-battery" = {
      script = ''
        set -eu
        export PATH="$PATH:/run/current-system/sw/bin"
        /home/${user}/bin/low-battery
      '';
      serviceConfig = {
        Type = "oneshot";
        User = "${user}";
      };
    };
  };

  fonts = {
    packages = with pkgs; [
      (nerdfonts.override {fonts = ["FiraCode"];})
      cantarell-fonts
      twitter-color-emoji
      sarasa-gothic
    ];
    fontconfig.defaultFonts = {
      emoji = ["Twitter Color Emoji"];
      monospace = ["Fira Code Nerd Font" "Sarasa Gothic"];
      sansSerif = ["Cantarell" "Sarasa Gothic"];
    };
  };

  powerManagement.enable = true;

  virtualisation.docker.enable = true;

  security.sudo = {
    extraConfig = ''
      Defaults lecture = never
      Defaults passwd_timeout=0
    '';
    extraRules = [
      {
        groups = ["wheel"];
        commands = [
          {
            command = "/run/current-system/sw/bin/light";
            options = ["NOPASSWD"];
          }
          {
            command = "/run/current-system/sw/bin/rfkill";
            options = ["NOPASSWD"];
          }
        ];
      }
    ];
  };

  security = {
    polkit.enable = true;
    rtkit.enable = true;
  };

  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    supportedFilesystems = ["btrfs"];
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };

  hardware = {
    enableAllFirmware = true;
    bluetooth = {
      enable = true;
      powerOnBoot = false;
    };
  };

  networking = {
    hostName = "unixie";
    networkmanager.enable = true;
    nameservers = ["9.9.9.9"];
    firewall.enable = true;
    # syncthing ports
    firewall.allowedTCPPorts = [8384 22000];
    firewall.allowedUDPPorts = [22000 21027];
  };

  time.timeZone = "Europe/Helsinki";
  i18n.defaultLocale = "en_US.UTF-8";

  console = {
    font = "Lat2-Terminus16";
    useXkbConfig = true; # use xkbOptions in tty.
  };

  services.xserver = {
    enable = true;
    autorun = false;
    layout = "us";
    xkbOptions = "caps:super";

    libinput = {
      enable = true;
      touchpad = {
        tapping = true;
        disableWhileTyping = true;
      };
    };

    displayManager = {
      startx.enable = true;
      defaultSession = "none+dwm";
    };

    windowManager.dwm = {
      enable = true;
      package = pkgs.dwm.overrideAttrs (oldAttrs: {
        src = pkgs.fetchFromGitHub {
          owner = "joinemm";
          repo = "dwm";
          rev = "master";
          sha256 = "XzZE6DTp0gUoRnJGKcFYXCo3288u/F1ImgHfcGX9O5A=";
        };
        nativeBuildInputs = with pkgs; [
          xorg.libX11
          xorg.libX11.dev
          xorg.libXft
          xorg.libXinerama
          yajl
        ];
      });
    };
  };

  services.syncthing = {
    enable = true;
    user = "${user}";
    group = "users";
    openDefaultPorts = true;
    dataDir = "/home/${user}/";
    configDir = "/home/${user}/.config/syncthing";
    overrideDevices = true; # overrides any devices added or deleted through the WebUI
    overrideFolders = true; # overrides any folders added or deleted through the WebUI
    settings = {
      devices = {
        "andromeda" = {id = "4MCSVP2-W73RUXE-XIJ6IML-T6IAHWP-HH2LR2V-SRZIM52-4TSGSDQ-FTPWDAA";};
        "cerberus" = {id = "5XBGVON-NGKWPQR-45P3KVV-VOJ2L6A-AWFANXU-JIOY2FW-6ROII4V-6L4Z7QC";};
      };
      folders = {
        "work" = {
          path = "/home/${user}/work"; # Which folder to add to Syncthing
          id = "meugk-eipcy";
          devices = ["andromeda" "cerberus"]; # Which devices to share the folder with
        };
      };
    };
  };

  services = {
    gnome.gnome-keyring.enable = true;

    picom.enable = true;

    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };

    openvpn.servers = {
      ficoloVPN = {
        autoStart = false;
        config = "config /home/${user}/work/tii/credentials/ficolo_vpn.ovpn";
      };
    };
  };

  programs = {
    zsh.enable = true;
    light.enable = true;
    gamemode.enable = true;
    java.enable = true;
    neovim.enable = true;
  };

  environment = {
    shells = with pkgs; [zsh];
    systemPackages = with pkgs; [
      (python3.withPackages (p:
        with p; [
          requests
          flake8
          beautifulsoup4
        ]))
      envsubst
      memray
      cosign
      pipenv
      ruff
      binutils
      kitty
      git
      firefox
      rofi
      vscode
      flameshot
      dunst
      picom
      feh
      starship
      dwmblocks
      pulseaudio
      acpi
      wirelesstools
      qogir-icon-theme
      spotify
      webcord
      nixpkgs-fmt
      xclip
      fastfetch
      wget
      arc-theme
      mons
      ffmpegthumbnailer
      file
      bottom
      peek
      xdotool
      xcolor
      yadm
      ueberzug
      rofimoji
      rustup
      playerctl
      vivid
      slack
      gcc
      lua
      nodejs
      unzip
      rust-analyzer
      xorg.libX11
      pre-commit
      nodePackages.gitmoji-cli
      nodePackages.yarn
      stylua
      shfmt
      black
      alejandra
      openfortivpn
      libnotify
      pcmanfm
      pavucontrol
      lf
      bat
      xorg.xev
      xsecurelock
      xss-lock
      alsa-utils
      jq
      hsetroot
      dig
      asdf-vm
      lxappearance
      dracula-theme
      fd
      libstdcxx5
      wezterm
    ];
  };
}
