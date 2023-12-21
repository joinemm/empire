{
  pkgs,
  lib,
  inputs,
  outputs,
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
    ./hardware-configuration.nix
  ];

  networking.hostName = "unikie";

  boot = {
    kernelPackages = pkgs.linuxPackages_6_1;
    supportedFilesystems = ["btrfs"];
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };

  services.syncthing = {
    settings = {
      folders = {
        "work" = {
          path = "/home/${user}/work";
          id = "meugk-eipcy";
          devices = ["andromeda" "cerberus" "buutti"];
        };
      };
    };
  };
}
