{
  user,
  pkgs,
  modulesPath,
  lib,
  ...
}: {
  imports = [
    (modulesPath + "/profiles/qemu-guest.nix")
  ];

  time.timeZone = "UTC";

  networking.useDHCP = true;
  networking.nameservers = ["1.1.1.1" "8.8.8.8"];
  security.sudo.wheelNeedsPassword = false;

  users.users.${user.name}.shell = lib.mkForce pkgs.bashInteractive;

  boot = {
    # use predictable network interface names (eth0)
    kernelParams = ["net.ifnames=0"];
    loader.grub = {
      efiSupport = true;
      efiInstallAsRemovable = true;
    };
  };
}
