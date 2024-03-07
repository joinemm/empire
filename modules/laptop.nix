{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    brightnessctl
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

  # battery life improvements
  powerManagement.enable = true;
  powerManagement.powertop.enable = true;
  services.tlp.enable = true;

  # able to change backlight or turn off wifi without sudo
  security.sudo = {
    extraRules = [
      {
        groups = ["wheel"];
        commands = [
          {
            command = "/run/current-system/sw/bin/light";
            options = ["NOPASSWD"];
          }
          {
            command = "/run/current-system/sw/bin/rfkill";
            options = ["NOPASSWD"];
          }
        ];
      }
    ];
  };

  services.physlock = {
    enable = true;
    allowAnyUser = true;
  };
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
