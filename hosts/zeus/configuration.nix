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
    ];
  };

  # Configure GPU
  # Early KMS isn't helpful
  # hardware.amdgpu.loadInInitrd = false;

  # https://gitlab.freedesktop.org/drm/amd/-/issues/1974
  # systemd.services.amdgpu-overclock = {
  #   description = "Overclock AMD GPU";
  #   after = ["suspend.target" "multi-user.target" "systemd-user-sessions.service"];
  #   wantedBy = ["sleep.target" "multi-user.target"];
  #   wants = ["modprobe@amdgpu.service"];
  #   script = ''
  #     echo 'high' > /sys/class/drm/card0/device/power_dpm_force_performance_level
  #   '';
  #   serviceConfig.Type = "oneshot";
  # };
  # # https://wiki.archlinux.org/title/AMDGPU#Boot_parameter
  # boot.kernelParams = ["amdgpu.ppfeaturemask=0xfff7ffff"];
}
