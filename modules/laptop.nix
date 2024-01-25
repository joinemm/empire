{pkgs, ...}: {

  environment.systemPackages = with pkgs; [
    brightnessctl
  ];

  services.xserver = {
    # caps lock is super
    xkbOptions = "caps:super";

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

  systemd.user.services.xss-lock = {
    unitConfig = {
      Description = "Screenlocker service";
      PartOf = ["graphical-session.target"];
    };
    wantedBy = ["graphical-session.target"];
    serviceConfig = {
      Environment = [
        "XSECURELOCK_COMPOSITE_OBSCURER=0"
        "XSECURELOCK_PASSWORD_PROMPT=asterisks"
        "XSECURELOCK_SHOW_KEYBOARD_LAYOUT=0"
      ];
      ExecStart = "${pkgs.xss-lock}/bin/xss-lock --session \${XDG_SESSION_ID} -- ${pkgs.xsecurelock}/bin/xsecurelock";
    };
  };
}
