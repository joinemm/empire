{
  pkgs,
  lib,
  outputs,
  ...
}: {
  imports = lib.flatten [
    (with outputs.nixosModules; [
      common
      syncthing
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
