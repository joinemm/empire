{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    brightnessctl
    physlock
    mons
    acpi
  ];

  services.xserver = {
    # caps lock is super
    xkb.options = "caps:super";

    # touchpad
    libinput = {
      enable = true;
      touchpad = {
        tapping = true;
        disableWhileTyping = true;
      };
    };
  };

  # use S3 sleep mode
  boot.kernelParams = ["mem_sleep_default=deep"];

  # battery life improvements
  powerManagement = {
    enable = true;
    powertop.enable = true;
  };

  services.upower = {
    enable = true;
    percentageLow = 20;
    percentageCritical = 10;
    percentageAction = 5;
    criticalPowerAction = "Hibernate";
  };

  # Enable the auto-cpufreq daemon
  services.auto-cpufreq.enable = true;
  # Enable thermald, the temperature management daemon
  services.thermald.enable = true;

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

  # screen locker service
  services.physlock = {
    enable = true;
    allowAnyUser = true;
  };

  # lock screen automatically after inactivity
  services.xserver.xautolock = let
    cmd = "/run/wrappers/physlock -d";
  in {
    enable = true;
    locker = cmd;
    nowlocker = cmd;
    time = 5;
    killtime = 15;
  };
}
