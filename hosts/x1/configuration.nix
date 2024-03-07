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
}
