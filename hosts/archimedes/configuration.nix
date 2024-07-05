{
  lib,
  modules,
  inputs,
  pkgs,
  user,
  modulesPath,
  ...
}: {
  imports = lib.flatten [
    (with modules; [
      common
      locale
      ssh-access
    ])
    inputs.nixos-hardware.nixosModules.raspberry-pi-4
    (modulesPath + "/installer/sd-card/sd-image-aarch64.nix")
  ];

  nixpkgs.overlays = [
    (_: super: {
      makeModulesClosure = x:
        super.makeModulesClosure (x // {allowMissing = true;});
    })
  ];

  # makes the sdImage a .img instead of .img.zst
  sdImage.compressImage = false;

  hardware = {
    raspberry-pi."4" = {
      apply-overlays-dtmerge.enable = true;
    };
    deviceTree = {
      enable = true;
      filter = "*rpi-4-*.dtb";
    };
  };

  nixpkgs.hostPlatform = "aarch64-linux";
  networking.hostName = "archimedes";

  console.enable = false;

  security.sudo.wheelNeedsPassword = false;

  users.users.${user.name} = {
    shell = lib.mkForce pkgs.bashInteractive;
    extraGroups = ["gpio"];
  };

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-label/NIXOS_SD";
      fsType = "ext4";
      options = ["noatime"];
    };
  };

  users.groups.gpio = {};

  # Use GPIO pins as non-root
  services.udev.extraRules = ''
    SUBSYSTEM=="bcm2835-gpiomem", KERNEL=="gpiomem", GROUP="gpio",MODE="0660"
    SUBSYSTEM=="gpio", KERNEL=="gpiochip*", ACTION=="add", RUN+="${pkgs.bash}/bin/bash -c 'chown root:gpio /sys/class/gpio/export /sys/class/gpio/unexport ; chmod 220 /sys/class/gpio/export /sys/class/gpio/unexport'"
    SUBSYSTEM=="gpio", KERNEL=="gpio*", ACTION=="add",RUN+="${pkgs.bash}/bin/bash -c 'chown root:gpio /sys%p/active_low /sys%p/direction /sys%p/edge /sys%p/value ; chmod 660 /sys%p/active_low /sys%p/direction /sys%p/edge /sys%p/value'"
  '';

  environment.systemPackages = with pkgs; [
    busybox
    libraspberrypi
    raspberrypi-eeprom
  ];

  system.stateVersion = "24.05";
}
