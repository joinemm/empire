{
  inputs,
  outputs,
  lib,
  pkgs,
  ...
}: {
  imports = lib.flatten [
    (with outputs.nixosModules; [
      common
      syncthing
      docker
      bootloader
      laptop
      bluetooth
      gui
      work-vpn
      keyd
      bin
    ])
    (with inputs.nixos-hardware.nixosModules; [
      lenovo-thinkpad-x1-11th-gen
    ])
    ./hardware-configuration.nix
    ./home.nix
  ];

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
        "documents".enable = true;
      };
    };

    tailscale.enable = true;
  };

  environment.systemPackages = lib.flatten [
    (
      with pkgs; [
        # languages and dev tools
        (python3.withPackages (ps:
          with ps; [
            requests
          ]))
        pipenv
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
