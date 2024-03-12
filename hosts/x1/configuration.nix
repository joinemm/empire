{
  inputs,
  outputs,
  lib,
  pkgs,
  ...
}: {
  imports = lib.flatten [
    (with outputs.nixosModules; [
      bin
      bluetooth
      bootloader
      common
      docker
      fonts
      gui
      keyd
      laptop
      networking
      sound
      syncthing
      users
      work-vpn
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

  hardware = {
    opengl = {
      extraPackages = with pkgs; [
        intel-compute-runtime
        intel-media-driver
      ];
    };
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
}
