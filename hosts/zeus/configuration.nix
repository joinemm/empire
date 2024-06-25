{
  inputs,
  outputs,
  lib,
  ...
}: {
  imports = lib.flatten [
    (with outputs.nixosModules; [
      bin
      bluetooth
      bootloader
      common
      docker
      fonts
      gaming
      gui
      keyd
      locale
      networking
      nix
      remotebuild
      sound
      syncthing
      transmission
      users
      work-vpn
    ])
    (with inputs.nixos-hardware.nixosModules; [
      common-cpu-amd
      common-gpu-amd
      common-pc-ssd
      common-pc
    ])
    ./hardware-configuration.nix
    ./home.nix
  ];

  networking = {
    hostName = "zeus";
    hostId = "c5a9072d";
  };

  services = {
    syncthing.settings.folders = {
      "camera".enable = true;
      "code".enable = true;
      "documents".enable = true;
      "mobile-downloads".enable = true;
      "mobile-screenshots".enable = true;
      "notes".enable = true;
      "pictures".enable = true;
      "videos".enable = true;
      "work".enable = true;
    };

    xserver = {
      deviceSection = ''
        Option "VariableRefresh" "true"
      '';
      xrandrHeads = [
        {
          output = "DisplayPort-0";
          primary = true;
          monitorConfig = ''
            Modeline "3440x1440_144.00"  1086.75  3440 3744 4128 4816  1440 1443 1453 1568 -hsync +vsync
            Option "PreferredMode" "3440x1440_144.00"
          '';
        }
        {
          # LG TV that should be off by default
          output = "HDMI-A-0";
          monitorConfig = ''
            Option "Enable" "false"
            Option "RightOf" "DisplayPort-0"
          '';
        }
      ];
    };

    # for keyboard config using via
    udev.extraRules = ''
      KERNEL=="hidraw*", ATTRS{idVendor}=="6582", ATTRS{idProduct}=="075c", MODE="0666", GROUP="plugdev"
    '';
  };

  hardware.amdgpu = {
    initrd.enable = true;
    amdvlk = {
      enable = true;
      support32Bit.enable = true;
      supportExperimental.enable = true;
    };
  };
}
