{ config, pkgs, ... }:

let
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
  user = "joonas";
in
{
  imports =
    [
      ./hardware-configuration.nix
    ];

  fonts = {
    fonts = with pkgs; [
      cantarell-fonts
      fira-code
      twitter-color-emoji
      material-icons
    ];
    fontconfig.defaultFonts = {
      emoji = [ "Twitter Color Emoji" ];
      monospace = [ "Fira Code" "Material Icons" ];
      sansSerif = [ "Cantarell" ];
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

  };

  systemd.tmpfiles.rules = [
    "L /var/lib/NetworkManager/secret_key - - - - /persist/var/lib/NetworkManager/secret_key"
    "L /var/lib/NetworkManager/seen-bssids - - - - /persist/var/lib/NetworkManager/seen-bssids"
    "L /var/lib/NetworkManager/timestamps - - - - /persist/var/lib/NetworkManager/timestamps"
    "L /var/lib/docker - - - - /persist/var/lib/docker"
  ];

  security.sudo = {
    extraConfig = ''
      	Defaults lecture = never
        Defaults passwd_timeout=0
    '';
    extraRules = [
      {
        groups = [ "wheel" ];
        commands = [
          { command = "/run/current-system/sw/bin/light"; options = [ "NOPASSWD" ]; }
          { command = "/run/current-system/sw/bin/rfkill"; options = [ "NOPASSWD" ]; }
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
    supportedFilesystems = [ "btrfs" ];
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };
  hardware = {
    enableAllFirmware = true;
    bluetooth.enable = true;
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
        ];
      });
    };
    layout = "us";
    xkbOptions = "caps:super";

  };

  services = {
    syncthing = {
      enable = true;
      user = "${user}";
      group = "users";
      openDefaultPorts = true;
      dataDir = "/home/${user}/";
      configDir = "/home/${user}/.config/syncthing";
      # overrideDevices = true; # overrides any devices added or deleted through the WebUI
      # overrideFolders = true; # overrides any folders added or deleted through the WebUI
      # devices = {
      #   "device1" = { id = "DEVICE-ID-GOES-HERE"; };
      #   "device2" = { id = "DEVICE-ID-GOES-HERE"; };
      # };
      # folders = {
      #   "Documents" = {
      #     # Name of folder in Syncthing, also the folder ID
      #     path = "/home/myusername/Documents"; # Which folder to add to Syncthing
      #     devices = [ "device1" "device2" ]; # Which devices to share the folder with
      #   };
      #   "Example" = {
      #     path = "/home/myusername/Example";
      #     devices = [ "device1" ];
      #     ignorePerms = false; # By default, Syncthing doesn't sync file permissions. This line enables it for this folder.
      #   };
      # };
    };
  };


  environment.systemPackages = with pkgs; [
    python3
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
    light
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
  ];

  programs.zsh = {
    enable = true;
  };

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  services.picom.enable = true;

  users = {
    defaultUserShell = pkgs.zsh;
    users.${user} = {
      isNormalUser = true;
      extraGroups = [ "wheel" "docker" ];
      initialPassword = "changeme";
      shell = pkgs.zsh;
    };
  };

  environment.shells = with pkgs; [ zsh ];

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  system.copySystemConfiguration = true;

  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.11";
}

