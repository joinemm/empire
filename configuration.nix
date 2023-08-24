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
  #
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
  imports = [
    ./hardware-configuration.nix
  ];

  nix.settings = {
    substituters = [
      "https://cache.vedenemo.dev"
      "https://cache.nixos.org/"
    ];
    trusted-public-keys = [
      "cache.vedenemo.dev:RGHheQnb6rXGK5v9gexJZ8iWTPX6OcSeS56YeXYzOcg="
    ];
    trusted-users = ["${user}"];
    experimental-features = ["nix-command" "flakes"];
  };

  powerManagement.enable = true;

  fonts = {
    packages = with pkgs; [
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

  programs.neovim.enable = true;

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
    autorun = false;
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
    layout = "us";
    xkbOptions = "caps:super";
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

  services.gnome.gnome-keyring.enable = true;

  services.openvpn.servers = {
    ficoloVPN = {
      autoStart = false;
      config = "config /home/${user}/work/tii/credentials/ficolo_vpn.ovpn";
    };
  };

  environment.systemPackages = with pkgs; [
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
      extraGroups = ["wheel" "docker" "mlocate" "networkmanager" "netdev"];
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

  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.11";
}
