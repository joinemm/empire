{
  inputs,
  user,
  self,
  lib,
  pkgs,
  ...
}:
{
  imports = lib.flatten [
    (with self.nixosModules; [
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
    (with inputs.nixos-hardware.nixosModules; [ lenovo-thinkpad-x1-11th-gen ])
    ./hardware-configuration.nix
  ];

  system.stateVersion = "23.11";

  networking = {
    hostName = "athens";
    hostId = "c08d7d71";
  };

  # latest ZFS compatible kernel
  boot.kernelPackages = lib.mkForce pkgs.linuxPackages_6_10;

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
      "videos".enable = true;
      "work".enable = true;
      "documents".enable = true;
      "share".enable = true;
    };
  };

  # extra home-manager configuration
  home-manager.users."${user.name}" = {
    services.poweralertd.enable = true;
    programs.wezterm.fontSize = "11.0";
  };

}
