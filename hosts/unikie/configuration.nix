{
  pkgs,
  lib,
  outputs,
  config,
  ...
}: let
  user = "joonas";
in {
  imports = lib.flatten [
    (with outputs.nixosModules; [
      (common {inherit user pkgs outputs;})
      (syncthing {inherit user config lib;})
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
    settings.folders = {
      "work".enable = true;
    };
  };
}
