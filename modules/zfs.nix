{ pkgs, ... }:
{
  boot = {
    kernelPackages = pkgs.linuxPackages_6_11;
    zfs.package = pkgs.zfsUnstable;
  };

  # zfs doesn't support Hibernation
  services.upower.criticalPowerAction = "HybridSleep";
}
