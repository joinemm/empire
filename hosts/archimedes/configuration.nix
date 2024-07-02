{
  lib,
  outputs,
  inputs,
  pkgs,
  ...
}: {
  imports = lib.flatten [
    (with outputs.nixosModules; [
      common
      locale
      ssh-access
    ])
    inputs.nixos-hardware.nixosModules.raspberry-pi-4
  ];

  hardware.raspberry-pi."4" = {
    fkms-3d.enable = true;
    touch-ft5406.enable = true;
  };

  nixpkgs.hostPlatform = "aarch64-linux";
  networking.hostName = "archimedes";

  boot = {
    kernelPackages = pkgs.linuxKernel.packages.linux_rpi4;
    initrd.availableKernelModules = ["xhci_pci" "usbhid" "usb_storage"];
    loader = {
      grub.enable = false;
      generic-extlinux-compatible.enable = true;
    };
  };

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-label/NIXOS_SD";
      fsType = "ext4";
      options = ["noatime"];
    };
  };

  environment.systemPackages = with pkgs; [
    busybox
  ];

  system.stateVersion = "24.05";
}
