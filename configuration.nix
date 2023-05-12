{
  config,
  pkgs,
  ...
}: let
  dwmblocks = pkgs.dwmblocks.overrideAttrs (old: {
    src = ./packages/dwmblocks;
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

  nix-gaming = import (builtins.fetchTarball "https://github.com/fufexan/nix-gaming/archive/master.tar.gz");
in {
  imports = [
    ./hardware-configuration.nix
    "${nix-gaming}/modules/pipewireLowLatency.nix"
  ];

  nix.settings.experimental-features = ["nix-command" "flakes"];
  nix.settings = {
    substituters = [
      "https://nix-gaming.cachix.org"
      "https://cache.vedenemo.dev"
      "https://cache.nixos.org/"
    ];
    trusted-public-keys = [
      "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="
      "cache.vedenemo.dev:RGHheQnb6rXGK5v9gexJZ8iWTPX6OcSeS56YeXYzOcg="
    ];
    trusted-users = ["${user}"];
  };

  powerManagement.enable = true;

  fonts = {
    fonts = with pkgs; [
      cantarell-fonts
      fira-code
      twitter-color-emoji
      material-icons
      sarasa-gothic
      (nerdfonts.override {fonts = ["FiraCode"];})
    ];
    fontconfig.defaultFonts = {
      emoji = ["Twitter Color Emoji"];
      monospace = ["Fira Code" "Material Icons" "Sarasa Gothic"];
      sansSerif = ["Cantarell" "Sarasa Gothic"];
    };
  };

  virtualisation = {
    docker.enable = true;
  };

  environment.etc = {
    nixos.source = "/persist/etc/nixos";
    "NetworkManager/system-connections".source = "/persist/etc/NetworkManager/system-connections";
    adjtime.source = "/persist/etc/adjtime";
    shadow.source = "/persist/etc/shadow";
    machine-id.source = "/persist/etc/machine-id";
    openfortivpn.source = "/persist/etc/openfortivpn";
  };

  systemd.tmpfiles.rules = [
    "L /var/lib/NetworkManager/secret_key - - - - /persist/var/lib/NetworkManager/secret_key"
    "L /var/lib/NetworkManager/seen-bssids - - - - /persist/var/lib/NetworkManager/seen-bssids"
    "L /var/lib/NetworkManager/timestamps - - - - /persist/var/lib/NetworkManager/timestamps"
    "L /var/lib/docker - - - - /persist/var/lib/docker"
    "L /var/lib/hydra - - - - /persist/var/lib/hydra"
    "L /var/lib/bluetooth/78:AF:08:BF:C6:8C/58:A6:39:22:AD:A3 - - - - /persist/var/lib/bluetooth/78:AF:08:BF:C6:8C/58:A6:39:22:AD:A3"
  ];

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

  security.polkit.enable = true;

  # Note `lib.mkBefore` is used instead of `lib.mkAfter` here.
  boot.initrd.postDeviceCommands = pkgs.lib.mkBefore ''
    mkdir -p /mnt

    # We first mount the btrfs root to /mnt
    # so we can manipulate btrfs subvolumes.

    mount -o subvol=/ /dev/mapper/enc /mnt

    btrfs subvolume list -o /mnt/root |
    cut -f9 -d' ' |
    while read subvolume; do
      echo "deleting /$subvolume subvolume..."
      btrfs subvolume delete "/mnt/$subvolume"
    done &&
    echo "deleting /root subvolume..." &&
    btrfs subvolume delete /mnt/root

    echo "restoring blank /root subvolume..."
    btrfs subvolume snapshot /mnt/root-blank /mnt/root

    # Once we're done rolling back to a blank snapshot,
    # we can unmount /mnt and continue on the boot process.

    umount /mnt
  '';

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

  nixpkgs.config.allowUnfree = true;

  networking = {
    hostName = "unixie";
    networkmanager.enable = true;
  };

  time.timeZone = "Europe/Helsinki";

  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    useXkbConfig = true; # use xkbOptions in tty.
  };

  services.hydra = {
    enable = true;
    hydraURL = "http://localhost:3333"; # externally visible URL
    notificationSender = "hydra@localhost"; # e-mail of hydra service
    # a standalone hydra will require you to unset the buildMachinesFiles list to avoid using a nonexistant /etc/nix/machines
    buildMachinesFiles = [];
    # you will probably also want, otherwise *everything* will be built from scratch
    useSubstitutes = true;
  };

  services.xserver = {
    enable = true;
    libinput = {
      enable = true;
      touchpad = {
        tapping = true;
      };
    };
    displayManager = {
      startx.enable = true;
      defaultSession = "none+dwm";
    };
    autorun = false;
    windowManager.dwm = {
      enable = true;
      package = pkgs.dwm.overrideAttrs (oldAttrs: {
        src = ./packages/dwm;
        nativeBuildInputs = with pkgs; [
          xorg.libX11
          xorg.libX11.dev
          xorg.libXft
          xorg.libXinerama
          yajl
        ];
      });
    };
    layout = "us";
    xkbOptions = "caps:super";
    extraLayouts.usfi = {
      description = "US layout with finnish letters";
      languages = ["eng" "fin"];
      symbolsFile = ./symbols/usfi;
    };
    #videoDrivers = ["intel"];
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

  services.gnome.gnome-keyring.enable = true;

  environment.systemPackages = with pkgs; [
    (python3.withPackages (p:
      with p; [
        requests
        flake8
        beautifulsoup4
      ]))
    cosign
    pipenv
    binutils
    kitty
    git
    neovim
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
    discord
    spotify
    nixpkgs-fmt
    neofetch
    xclip
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
    lutris
    nix-gaming.packages.${pkgs.hostPlatform.system}.wine-tkg
    winetricks
    steam
  ];

  programs.gamemode.enable = true;
  programs.java.enable = true;

  programs = {
    zsh.enable = true;
    light.enable = true;
  };

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;

    lowLatency = {
      # enable this module
      enable = true;
    };
  };

  # Steam needs this, see https://nixos.org/nixpkgs/manual/#sec-steam-play
  hardware.opengl.driSupport32Bit = true;
  hardware.opengl.driSupport = true;
  hardware.pulseaudio.support32Bit = true;
  hardware.opengl.extraPackages = with pkgs; [
    # Work around "A game file appears to be missing or corrupted" in Steam.
    # See https://www.reddit.com/r/DotA2/comments/e24l6q/a_game_file_appears_to_be_missing_or_corrupted/
    intel-media-driver
    vaapiVdpau
    libvdpau-va-gl
  ];

  services.picom.enable = true;

  users = {
    defaultUserShell = pkgs.zsh;
    users.${user} = {
      isNormalUser = true;
      extraGroups = ["wheel" "docker" "mlocate"];
      initialPassword = "changeme";
      shell = pkgs.zsh;
    };
  };

  systemd.timers."low-battery" = {
    wantedBy = ["timers.target"];
    timerConfig = {
      OnBootSec = "1m";
      OnUnitActiveSec = "1m";
      Unit = "low-battery.service";
    };
  };

  systemd.services."low-battery" = {
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

  environment.shells = with pkgs; [zsh];

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  system.copySystemConfiguration = true;

  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.11";
}
