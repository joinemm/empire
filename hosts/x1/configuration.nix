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
      laptop
      bluetooth
      gui
      work-vpn
      keyd
      trackpoint
      (bin {inherit inputs system;})
    ])
    (with inputs.nixos-hardware.nixosModules; [
      lenovo-thinkpad-x1-11th-gen
    ])
    (import ./home.nix {inherit inputs outputs pkgs user lib;})
    ./hardware-configuration.nix
  ];

  boot = {
    # force S3 sleep mode
    kernelParams = ["mem_sleep_default=deep"];

    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };

  hardware.trackpoint.device = "TPPS/2 Elan TrackPoint";

  networking = {
    hostName = "x1";
    hostId = "c08d7d71";
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

    tailscale.enable = true;
    fwupd.enable = true;

    # fingerprint scanner daemon
    # to enroll a finger, use sudo fprintd-enroll $USER
    fprintd.enable = true;
  };

  environment.systemPackages = lib.flatten [
    (
      with pkgs; [
        # languages and dev tools
        python3
        pipenv
        rustup
        lua
        nodejs
        statix

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
        acpi
        fastfetch
        wget
        mons
        file
        bottom
        xdotool
        playerctl
        pulseaudio
        alsa-utils
        pre-commit
        wirelesstools
        jq # json parser
        fd # faster find
        dig
        rsync
        glow # render markdown on the cli
        xclip
        pciutils
        usbutils

        # libs
        libnotify
      ]
    )
  ];
}
