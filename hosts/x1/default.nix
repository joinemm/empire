{
  inputs,
  user,
  modules,
  lib,
  pkgs,
  ...
}: {
  imports = lib.flatten [
    (with modules; [
      bluetooth
      common
      desktop
      docker
      gaming
      home
      keyd
      laptop
      locale
      remotebuild
      syncthing
      tailscale
      transmission
      work
      yubikey
    ])
    (with inputs.nixos-hardware.nixosModules; [
      lenovo-thinkpad-x1-11th-gen
    ])
    ./hardware-configuration.nix
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
      "camera".enable = true;
      "code".enable = true;
      "notes".enable = true;
      "pictures".enable = true;
      "work".enable = true;
      "documents".enable = true;
      "share".enable = true;
    };
  };

  home-manager.users."${user.name}" = {
    services.poweralertd.enable = true;
    programs.wezterm.fontSize = "11.0";
  };

  system.stateVersion = "23.11";
}
