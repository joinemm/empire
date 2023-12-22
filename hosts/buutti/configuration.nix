{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: let
  user = "joonas";
in {
  imports = lib.flatten [
    (with outputs.nixosModules; [
      (common {inherit user pkgs outputs;})
      (syncthing {inherit user;})
      laptop
      bluetooth
      gui
      work-vpn
    ])
    (with inputs.nixos-hardware.nixosModules; [
      common-cpu-amd
      common-cpu-amd-pstate
      common-pc-ssd
      common-gpu-amd
    ])
    (import ./home.nix {inherit inputs outputs pkgs user;})
    ./hardware-configuration.nix
  ];

  boot = {
    # zfs requires this
    kernelPackages = config.boot.zfs.package.latestCompatibleLinuxPackages;
    # force S3 sleep mode
    kernelParams = ["mem_sleep_default=deep"];

    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };

  networking = {
    hostName = "buutti";
    # zfs requires hostId to be set.
    hostId = "4d0256d9";
  };

  services.syncthing = {
    settings = {
      folders = {
        "work" = {
          path = "/home/${user}/work";
          id = "meugk-eipcy";
          devices = ["andromeda" "cerberus"];
          ignorePerms = false;
        };
        "pictures" = {
          path = "/home/${user}/pictures";
          id = "zuaps-ign9t";
          devices = ["andromeda" "cerberus" "samsung"];
        };
        "code" = {
          path = "/home/${user}/code";
          id = "asqhs-gxzl4";
          devices = ["andromeda" "cerberus"];
          ignorePerms = false;
        };
        "notes" = {
          path = "/home/${user}/notes";
          id = "jmdvx-nzh9p";
          devices = ["andromeda" "cerberus"];
        };
      };
    };
  };

  # TEMP fix:
  # allow old electron for obsidian version <= 1.4.16"
  nixpkgs.config.permittedInsecurePackages = [
    "electron-25.9.0"
  ];

  environment.systemPackages = with pkgs; [
    (python3.withPackages (p:
      with p; [
        requests
        beautifulsoup4
        aiohttp
      ]))
    ffmpeg-full
    glow
    slop
    darktable
    pipenv
    binutils
    firefox
    rofi
    feh
    acpi
    wirelesstools
    spotify
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
    ffmpegthumbnailer
    rofimoji
    rustup
    playerctl
    vivid
    slack
    gcc
    lua
    unzip
    xorg.libX11
    xorg.xev
    pre-commit
    nodejs
    nodePackages.gitmoji-cli
    nodePackages.yarn
    libnotify
    pcmanfm
    pavucontrol
    lf
    bat
    jq
    dig
    fd
    gimp
    obsidian
    rsync
    chromium
    statix
  ];
}
