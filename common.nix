{
  config,
  pkgs,
  ...
}: let
  user = "joonas";
  # fix for https://github.com/NixOS/nixpkgs/issues/265014
  rsync = pkgs.rsync.overrideAttrs (_: _: {
    hardeningDisable = ["fortify"];
  });
in {
  system.stateVersion = "23.11";
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

  imports = [
    ./modules/discord.nix
  ];

  users = {
    defaultUserShell = pkgs.zsh;
    users.${user} = {
      isNormalUser = true;
      extraGroups = ["wheel" "docker" "mlocate" "networkmanager" "libvirtd"];
      initialPassword = "asdf";
      shell = pkgs.zsh;
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

  virtualisation.docker.enable = true;
  virtualisation.libvirtd.enable = true;

  security.sudo = {
    extraConfig = ''
      Defaults lecture = never
      Defaults passwd_timeout=0
    '';
  };

  security = {
    polkit.enable = true;
    # for pipewire
    rtkit.enable = true;
  };

  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };

  networking = {
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
    useXkbConfig = true; # use xkbOptions in tty.
  };

  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = true;
    extraPortals = [pkgs.xdg-desktop-portal-gtk];
  };

  services.xserver = {
    enable = true;
    autorun = true;

    autoRepeatDelay = 300;
    autoRepeatInterval = 25;

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
          rev = "6dc953fe30ff5109e8282277e29eddff3437d064";
          sha256 = "XzZE6DTp0gUoRnJGKcFYXCo3288u/F1ImgHfcGX9O5A=";
        };
        nativeBuildInputs = with pkgs; [
          xorg.libX11
          xorg.libX11.dev
          xorg.libXft
          xorg.libXinerama
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
    # overrides any folders added or deleted through the WebUI
    overrideDevices = true;
    overrideFolders = true;
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
    blueman.enable = true;
  };

  programs = {
    zsh.enable = true;
    light.enable = true;
    gamemode.enable = true;
    java.enable = true;
    neovim.enable = true;
    dconf.enable = true;
    steam.enable = true;
  };

  hardware.opengl.driSupport32Bit = true;

  environment = {
    shells = with pkgs; [zsh];
    # zsh completions
    pathsToLink = ["/share/zsh"];
    systemPackages = with pkgs; [
      (python3.withPackages (p:
        with p; [
          requests
          flake8
          beautifulsoup4
        ]))
      virt-manager
      ffmpeg-full
      glow
      slop
      powertop
      darktable
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
      picom
      feh
      starship
      pulseaudio
      acpi
      wirelesstools
      spotify
      nixpkgs-fmt
      xclip
      fastfetch
      wget
      mons
      file
      bottom
      peek
      xdotool
      xcolor
      yadm
      ueberzug
      imv
      ffmpegthumbnailer
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
      libnotify
      pcmanfm
      pavucontrol
      lf
      bat
      xorg.xev
      alsa-utils
      jq
      hsetroot
      dig
      lxappearance
      fd
      libstdcxx5
      wezterm
      gimp
      obsidian
      rsync
    ];
  };
}
