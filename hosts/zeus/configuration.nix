{
  inputs,
  outputs,
  lib,
  pkgs,
  ...
}: {
  imports = lib.flatten [
    (with outputs.nixosModules; [
      common
      syncthing
      docker
      bootloader
      bluetooth
      gui
      work-vpn
      keyd
      bin
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
    syncthing = {
      settings.folders = {
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
    };
  }; 

  services.xserver = {
    videoDrivers = ["amdgpu"];
    xrandrHeads = [
      {
        output = "DisplayPort-0";
        primary = true;
        monitorConfig = ''
          Modeline "3440x1440_144.00"  1086.75  3440 3744 4128 4816  1440 1443 1453 1568 -hsync +vsync
          Option "PreferredMode" "3440x1440_144.00"
        '';
      }
    ];
  };
}
