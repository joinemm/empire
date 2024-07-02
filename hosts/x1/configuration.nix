{
  inputs,
  outputs,
  lib,
  pkgs,
  ...
}: {
  imports = lib.flatten [
    (with outputs.nixosModules; [
      bluetooth
      common
      desktop
      docker
      gaming
      keyd
      laptop
      locale
      remotebuild
      transmission
      syncthing
      work-vpn
      yubikey
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

  hardware.graphics = {
    extraPackages = with pkgs; [
      intel-compute-runtime
      intel-media-driver
    ];
  };

  services = {
    syncthing.settings.folders = {
      "code".enable = true;
      "notes".enable = true;
      "pictures".enable = true;
      "work".enable = true;
      "documents".enable = true;
    };

    tailscale.enable = true;
  };

  system.stateVersion = "23.11";
}
