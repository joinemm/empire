{
  inputs,
  user,
  self,
  lib,
  pkgs,
  ...
}:
{
  imports = lib.flatten [
    (with self.profiles; [
      core
      workstation
    ])
    (with self.nixosModules; [
      laptop
      kanata
      zfs
    ])
    (with inputs.nixos-hardware.nixosModules; [
      lenovo-thinkpad-x1-11th-gen
    ])
    inputs.sops-nix.nixosModules.sops
    ./hardware-configuration.nix
  ];

  system.stateVersion = "23.11";

  sops = {
    defaultSopsFile = ./secrets.yaml;
    age.sshKeyPaths = [ "/etc/ssh/host_id_ed25519" ];
  };

  networking = {
    hostName = "carbon";
    hostId = "c08d7d71";
  };

  hardware.graphics = {
    extraPackages = with pkgs; [
      intel-compute-runtime
      intel-media-driver
    ];
  };

  services = {
    syncthing.settings.folders = {
      "code".enable = true;
      "notes".enable = true;
      "pictures".enable = true;
      "videos".enable = true;
      "work".enable = true;
      "documents".enable = true;
      "projects".enable = true;
    };
  };

  # extra home-manager configuration
  home-manager.users."${user.name}" = {
    services.poweralertd = {
      enable = true;
      extraArgs = [
        "-i"
        "line power"
      ];
    };
    programs.wezterm.fontSize = "11.0";

    services.screen-locker = {
      enable = true;
      lockCmd = toString (
        pkgs.writeShellScript "lock" ''
          export XSECURELOCK_PASSWORD_PROMPT=asterisks
          export XSECURELOCK_SHOW_HOSTNAME=0
          export XSECURELOCK_SHOW_KEYBOARD_LAYOUT=0
          export XSECURELOCK_FONT=monospace

          ${lib.getExe pkgs.xsecurelock} 
        ''
      );
    };

    systemd.user.services.xss-lock.Service.ExecStartPre = toString (
      pkgs.writeShellScript "xset" ''
        ${lib.getExe pkgs.xorg.xset} s 600 600
        ${lib.getExe pkgs.xorg.xset} dpms 600 600 0
      ''
    );
  };
}
