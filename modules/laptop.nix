{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    brightnessctl
    physlock
    mons
    acpi
  ];

  # use S3 sleep mode
  boot.kernelParams = ["mem_sleep_default=deep"];

  # battery life improvements
  powerManagement = {
    enable = true;
    powertop.enable = true;
  };

  # turn off wifi without sudo
  security.sudo.extraRules = [
    {
      groups = ["wheel"];
      commands = [
        {
          command = "/run/current-system/sw/bin/rfkill";
          options = ["NOPASSWD"];
        }
      ];
    }
  ];

  services = {
    xserver.xkb.options = "caps:super";

    libinput.touchpad = {
      tapping = true;
      disableWhileTyping = true;
    };

    upower = {
      enable = true;
      percentageLow = 10;
      percentageCritical = 5;
      percentageAction = 2;
      # zfs doesn't support Hibernation
      criticalPowerAction = "HybridSleep";
    };

    # Enable the auto-cpufreq daemon
    auto-cpufreq.enable = true;
    # Enable thermald, the temperature management daemon
    thermald.enable = true;

    # screen locker service
    physlock = {
      enable = true;
      allowAnyUser = true;
    };

    # lock screen automatically after inactivity
    xserver.xautolock = let
      cmd = "/run/wrappers/physlock -dm";
    in {
      enable = true;
      locker = cmd;
      nowlocker = cmd;
      time = 5;
      killtime = 15;
    };
  };
}
