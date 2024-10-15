{
  inputs,
  lib,
  user,
  pkgs,
  self,
  ...
}:
{
  imports = lib.flatten [
    (with self.nixosModules; [
      attic
      bluetooth
      common
      desktop
      docker
      gaming
      home
      locale
      remotebuild
      syncthing
      tailscale
      transmission
      virtualization
      work
      yubikey
    ])
    (with inputs.nixos-hardware.nixosModules; [
      common-cpu-amd
      common-gpu-amd
      common-pc-ssd
      common-pc
    ])
    inputs.sops-nix.nixosModules.sops
    ./hardware-configuration.nix
  ];

  system.stateVersion = "23.11";

  sops = {
    defaultSopsFile = ./secrets.yaml;
    age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
  };

  networking = {
    hostName = "rome";
    hostId = "c5a9072d";
  };

  # latest ZFS compatible kernel
  boot.kernelPackages = lib.mkForce pkgs.linuxPackages_6_10;

  services.xserver = {
    # enable AMD Freesync
    deviceSection = ''
      Option "VariableRefresh" "true"
    '';

    xrandrHeads = [
      {
        # Force 144hz on primary display
        output = "DisplayPort-0";
        primary = true;
        monitorConfig = ''
          Modeline "3440x1440_144.00"  1086.75  3440 3744 4128 4816  1440 1443 1453 1568 -hsync +vsync
          Option "PreferredMode" "3440x1440_144.00"
        '';
      }
      {
        # LG TV should be off by default.
        output = "HDMI-A-0";
        monitorConfig = ''
          Option "Disable" "true"
          Option "RightOf" "DisplayPort-0"
        '';
      }
    ];
  };

  # Sample rates for Topping D10 USB DAC
  services.pipewire.extraConfig = {
    pipewire."99-topping-D10" = {
      "context.properties"."default.clock.allowed-rates" = [
        44100
        48000
        88200
        96000
        176400
        192000
        352800
        384000
      ];
    };
  };

  hardware.amdgpu = {
    initrd.enable = true;
    amdvlk = {
      enable = true;
      support32Bit.enable = true;
      supportExperimental.enable = true;
    };
  };

  services.syncthing.settings.folders = {
    "camera".enable = true;
    "code".enable = true;
    "documents".enable = true;
    "notes".enable = true;
    "pictures".enable = true;
    "videos".enable = true;
    "work".enable = true;
    "share".enable = true;
  };

  # overclocking
  boot.kernelParams = [ "amdgpu.ppfeaturemask=0xfffd7fff" ];
  environment.systemPackages = with pkgs; [ lact ];
  systemd.packages = with pkgs; [ lact ];
  systemd.services.lact.enable = true;

  # extra home-manager configuration
  home-manager.users."${user.name}" = { };
}
