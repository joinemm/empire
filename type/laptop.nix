{
  config,
  pkgs,
  ...
}: {
  hardware = {
    bluetooth = {
      enable = true;
      powerOnBoot = false;
      settings.General = {
        Enable = "Source,Sink,Media,Socket";
      };
    };
  };

  services.xserver = {
    xkbOptions = "caps:super";

    libinput = {
      enable = true;
      touchpad = {
        tapping = true;
        disableWhileTyping = true;
      };
    };
  };

  powerManagement.enable = true;

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
}
