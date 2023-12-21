{
  pkgs,
  lib,
  inputs,
  outputs,
  config,
  hardware,
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
    (with hardware; [
      common-cpu-amd
      common-cpu-amd-pstate
      common-pc-ssd
      common-gpu-amd
    ])
    ./hardware-configuration.nix
  ];

  networking.hostName = "unikie";

  boot = {
    kernelPackages = pkgs.linuxPackages_6_1;
    supportedFilesystems = ["btrfs"];
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
