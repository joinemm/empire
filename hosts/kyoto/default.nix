{
  lib,
  modules,
  inputs,
  pkgs,
  user,
  modulesPath,
  ...
}:
{
  imports = lib.flatten [
    (with modules; [
      common
      locale
      node-exporter
      ssh-access
      headless
    ])
    inputs.nixos-hardware.nixosModules.raspberry-pi-4
    (modulesPath + "/installer/sd-card/sd-image-aarch64.nix")
    ./sdcard.nix
    ./rpi-exporter.nix
    ./unifi.nix
    ./blocky.nix
    ./monitoring.nix
  ];

  hardware = {
    raspberry-pi."4" = {
      apply-overlays-dtmerge.enable = true;
    };
    deviceTree = {
      enable = true;
      filter = "*rpi-4-*.dtb";
    };
  };

  services.tailscale = {
    enable = true;
    useRoutingFeatures = "server";
  };

  nixpkgs.hostPlatform = "aarch64-linux";
  networking.hostName = "kyoto";
  system.stateVersion = "24.05";
  console.enable = false;

  users.users.${user.name}.extraGroups = [
    "gpio"
    "vcio"
  ];
  users.groups.gpio = { };

  # Allow access to GPIO pins for gpio group
  services.udev.packages = [
    (pkgs.writeTextFile {
      name = "gpio-udev-rules";
      destination = "/etc/udev/rules.d/99-gpio.rules";
      text = ''
        SUBSYSTEM=="bcm2835-gpiomem", KERNEL=="gpiomem", GROUP="gpio",MODE="0660"
        SUBSYSTEM=="gpio", KERNEL=="gpiochip*", ACTION=="add", RUN+="${pkgs.bash}/bin/bash -c 'chown root:gpio /sys/class/gpio/export /sys/class/gpio/unexport ; chmod 220 /sys/class/gpio/export /sys/class/gpio/unexport'"
        SUBSYSTEM=="gpio", KERNEL=="gpio*", ACTION=="add",RUN+="${pkgs.bash}/bin/bash -c 'chown root:gpio /sys%p/active_low /sys%p/direction /sys%p/edge /sys%p/value ; chmod 660 /sys%p/active_low /sys%p/direction /sys%p/edge /sys%p/value'"
      '';
    })
  ];

  environment.systemPackages = with pkgs; [
    busybox
    libraspberrypi
    raspberrypi-eeprom
  ];
}
