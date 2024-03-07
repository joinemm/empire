{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    # backlight brightness utility
    brightnessctl

    # screen locker
    physlock

    # manage displays when docking
    mons
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
  powerManagement.enable = true;
  powerManagement.powertop.enable = true;
  services.tlp.enable = true;

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
