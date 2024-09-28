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

  networking = {
    hostName = "athens";
    hostId = "c08d7d71";
  };

  boot.kernelPackages = lib.mkForce pkgs.linuxPackages_6_10;

  hardware.graphics = {
    extraPackages = with pkgs; [
      intel-compute-runtime
      intel-media-driver
    ];
  };

  # the laptop cpu is not powerful enough and low quantum causes garbled audio
  services.pipewire.extraConfig.pipewire."92-fix-quantum" = {
    context.properties = {
      default.clock.rate = 48000;
      default.clock.quantum = 1024;
      default.clock.min-quantum = 512;
      default.clock.max-quantum = 4092;
    };
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

  home-manager.users."${user.name}" = {
    services.poweralertd.enable = true;
    programs.wezterm.fontSize = "11.0";
  };

  system.stateVersion = "23.11";
}
