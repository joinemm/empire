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
    (with self.profiles; [
      core
      workstation
    ])
    (with self.nixosModules; [
      laptop
      kanata
    ])
    (with inputs.nixos-hardware.nixosModules; [
      lenovo-thinkpad-x1-11th-gen
    ])
    inputs.sops-nix.nixosModules.sops
    ./hardware-configuration.nix
  ];

  system.stateVersion = "23.11";

  sops = {
    defaultSopsFile = ./secrets.yaml;
    age.sshKeyPaths = [ "/etc/ssh/host_id_ed25519" ];
  };

  networking = {
    hostName = "athens";
    hostId = "c08d7d71";
  };

  boot.kernelPackages = inputs.nixpkgs-old.legacyPackages.${pkgs.system}.linuxPackages_6_10;

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
      "videos".enable = true;
      "work".enable = true;
      "documents".enable = true;
      "projects".enable = true;
    };
  };

  # extra home-manager configuration
  home-manager.users."${user.name}" = {
    services.poweralertd.enable = true;
    programs.wezterm.fontSize = "11.0";
  };
}
