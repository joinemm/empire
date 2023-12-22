{
  config,
  lib,
  modulesPath,
  ...
}: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot = {
    initrd = {
      availableKernelModules = ["xhci_pci" "thunderbolt" "nvme"];
      kernelModules = [];
      luks.devices."enc".device = "/dev/disk/by-uuid/8791ca62-8018-41fd-b881-d59e6d008ed8";
    };
    kernelModules = ["kvm-intel"];
    extraModulePackages = [];
  };

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/466bfd75-72b4-4795-9648-996c3dc5f49f";
      fsType = "btrfs";
      options = ["subvol=root"];
    };

    "/nix" = {
      device = "/dev/disk/by-uuid/466bfd75-72b4-4795-9648-996c3dc5f49f";
      fsType = "btrfs";
      options = ["subvol=nix"];
    };

    "/var/log" = {
      device = "/dev/disk/by-uuid/466bfd75-72b4-4795-9648-996c3dc5f49f";
      fsType = "btrfs";
      options = ["subvol=log"];
      neededForBoot = true;
    };

    "/home" = {
      device = "/dev/disk/by-uuid/466bfd75-72b4-4795-9648-996c3dc5f49f";
      fsType = "btrfs";
      options = ["subvol=home"];
    };

    "/persist" = {
      device = "/dev/disk/by-uuid/466bfd75-72b4-4795-9648-996c3dc5f49f";
      fsType = "btrfs";
      options = ["subvol=persist"];
      neededForBoot = true;
    };

    "/boot" = {
      device = "/dev/disk/by-uuid/890D-72FC";
      fsType = "vfat";
    };
  };

  swapDevices = [];

  networking.useDHCP = lib.mkDefault true;
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
