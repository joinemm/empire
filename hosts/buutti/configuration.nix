{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: let
  user = "joonas";
in {
  imports = [
    ./hardware-configuration.nix
    ../../common.nix
    ./../../type/laptop.nix
    ../../home.nix
  ];

  nixpkgs.overlays = [
    (import ../../overlays/dwm.nix {inherit pkgs;})
    (import ../../overlays/dwmblocks.nix {inherit pkgs;})
    (import ../../overlays/discord.nix {inherit pkgs;})
    (import ../../overlays/xsecurelock.nix {inherit pkgs;})
    (import ../../overlays/rsync.nix {inherit pkgs;})
  ];

  boot = {
    # zfs requires this
    kernelPackages = config.boot.zfs.package.latestCompatibleLinuxPackages;
    # Ensures lid-close leads to a sleep I actually expect, that doesn't drain my battery.
    # Force "S3" sleep mode which refers to Suspend-to-Ram of Intel's si0x documentation:
    # https://www.intel.com/content/www/us/en/develop/documentation/vtune-help/top/reference/energy-analysis-metrics-reference/s0ix-states.html
    # Lines below taken from https://github.com/NixOS/nixos-hardware/blob/488931efb69a50307fa0d71e23e78c8706909416/dell/xps/13-9370/default.nix
    kernelParams = ["mem_sleep_default=deep"];
  };

  hardware = {
    enableAllFirmware = true;
  };

  networking = {
    hostName = "buutti";
    # zfs requires hostId to be set
    hostId = "4d0256d9";
  };

  services.syncthing = {
    settings = {
      devices = {
        "andromeda" = {id = "4MCSVP2-W73RUXE-XIJ6IML-T6IAHWP-HH2LR2V-SRZIM52-4TSGSDQ-FTPWDAA";};
        "cerberus" = {id = "5XBGVON-NGKWPQR-45P3KVV-VOJ2L6A-AWFANXU-JIOY2FW-6ROII4V-6L4Z7QC";};
        "samsung" = {id = "MYTJZ44-XIVPKFG-KHROGEB-ZRUQVCC-TQXJK3A-566XQKK-QWQW44T-QSBBMAQ";};
      };
      folders = {
        "work" = {
          path = "/home/${user}/work";
          id = "meugk-eipcy";
          ignorePerms = false; # perms are ignored by default
          devices = ["andromeda" "cerberus"];
        };
        "pictures" = {
          path = "/home/${user}/pictures";
          id = "zuaps-ign9t";
          devices = ["andromeda" "cerberus" "samsung"];
        };
        "code" = {
          path = "/home/${user}/code";
          id = "asqhs-gxzl4";
          devices = ["andromeda" "cerberus"];
        };
        "notes" = {
          path = "/home/${user}/notes";
          id = "jmdvx-nzh9p";
          devices = ["andromeda" "cerberus"];
        };
      };
    };
  };

  environment = {
    # fix for openfortivpn "Refused to agree to IP address"
    etc."ppp/options".text = "ipcp-accept-remote";

    systemPackages = with pkgs; [
      # for office vpn
      openfortivpn
    ];
  };

  services = {
    openvpn.servers = {
      ficoloVPN = {
        autoStart = false;
        config = "config /home/${user}/work/tii/credentials/ficolo_vpn.ovpn";
      };
    };
  };
}
