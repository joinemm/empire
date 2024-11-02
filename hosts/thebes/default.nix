{
  self,
  lib,
  inputs,
  pkgs,
  config,
  ...
}:
{
  imports = lib.flatten [
    (with self.profiles; [
      core
      server
    ])
    (with self.nixosModules; [
      locale
      tailscale
      systemd-boot
    ])
    inputs.disko.nixosModules.disko
    inputs.sops-nix.nixosModules.sops
    ./disk-config.nix
  ];

  networking.hostName = "thebes";
  networking.useDHCP = true;
  nixpkgs.hostPlatform = "x86_64-linux";
  system.stateVersion = "24.11";

  sops = {
    defaultSopsFile = ./secrets.yaml;
    secrets = { };
  };

  boot.initrd.availableKernelModules = [
    "xhci_pci"
    "ahci"
    "nvme"
    "usbhid"
    "usb_storage"
    "sd_mod"
  ];

  boot.kernelModules = [ "kvm-intel" ];

  environment.systemPackages = with pkgs; [
    mergerfs
    smartmontools
  ];

  # MOUNTS

  systemd.tmpfiles.rules = [
    "d /data 0755 root root"
    "d /srv/nfs 0775 nfs users"
  ];

  fileSystems = {

    # Storage drives are formatted by hand
    "/mnt/disk1" = {
      device = "/dev/disk/by-uuid/f8527518-67e5-45a2-b2d2-f4c197b9d80f";
      fsType = "xfs";
    };

    "/mnt/disk2" = {
      device = "/dev/disk/by-uuid/757bbc28-5fd7-4a46-8be0-3082bb5fd52c";
      fsType = "xfs";
    };

    # Merge all disks to a fuse mount at /data
    "/data" = {
      device = "/mnt/disk*";
      fsType = "fuse.mergerfs";
      options = [
        "cache.files=partial"
        "dropcacheonclose=true"
        "category.create=mfs"
        "func.getattr=newest"
      ];
    };

    # Bind mount /data into /srv/nfs
    "/srv/nfs" = {
      device = "/data";
      options = [ "bind" ];
    };
  };

  # NFS

  users.users.nfs = {
    isNormalUser = true;
    uid = 1001;
  };

  services.nfs.server = {
    enable = true;
    exports = ''
      /srv/nfs  192.168.1.0/24(rw,sync,no_subtree_check,root_squash,all_squash,anonuid=1001,anongid=100,fsid=0)
    '';
    statdPort = 4000;
    lockdPort = 4001;
    mountdPort = 4002;
  };

  networking.firewall = rec {
    allowedTCPPorts =
      [
        111
        2049
      ]
      ++ lib.attrVals [
        "statdPort"
        "lockdPort"
        "mountdPort"
      ] config.services.nfs.server;

    allowedUDPPorts = allowedTCPPorts;
  };

  # SERVICES

  services.scrutiny = {
    enable = true;
    openFirewall = true;
    collector.enable = true;
  };

  services.vnstat.enable = true;
}
