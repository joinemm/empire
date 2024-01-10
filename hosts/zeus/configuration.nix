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
      (syncthing {inherit user config lib;})
      (docker {inherit user;})
      bluetooth
      gui
      work-vpn
      keyd
    ])
    # (with inputs.nixos-hardware.nixosModules; [
    # ])
    (import ./home.nix {inherit inputs outputs pkgs user;})
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
        # "notes".enable = true;
        # "pictures".enable = true;
        # "work".enable = true;
      };
    };
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
        jq # json parser
        fd # faster find
        dig
        rsync
        glow # render markdown on the cli
        xclip

        # libs
        libnotify
      ]
    )
    inputs.bin.all
  ];
}
