{
  config,
  pkgs,
  ...
}: let
  user = "joonas";
in {
  system.stateVersion = "23.11";

  nixpkgs.config.allowUnfree = true;

  nix.settings = {
    substituters = [
      "https://nix-community.cachix.org"
    ];
    trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
    trusted-users = ["${user}"];
    experimental-features = ["nix-command" "flakes"];
    auto-optimise-store = true;
  };

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

  virtualisation = {
    docker.enable = true;
    libvirtd.enable = true;
  };

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
      package = pkgs.dwm;
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
      discord
    ];
  };
}
