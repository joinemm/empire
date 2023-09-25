{
  config,
  pkgs,
  ...
}: let
  user = "joonas";
in { 
  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    supportedFilesystems = ["btrfs"];
  };

  hardware = {
    enableAllFirmware = true;
    bluetooth = {
      enable = true;
      powerOnBoot = false;
    };
  };

  networking = {
    hostName = "unikie";
  }; 

  services.syncthing = {
    settings = {
      devices = {
        "andromeda" = {id = "4MCSVP2-W73RUXE-XIJ6IML-T6IAHWP-HH2LR2V-SRZIM52-4TSGSDQ-FTPWDAA";};
        "cerberus" = {id = "5XBGVON-NGKWPQR-45P3KVV-VOJ2L6A-AWFANXU-JIOY2FW-6ROII4V-6L4Z7QC";};
      };
      folders = {
        "work" = {
          path = "/home/${user}/work"; # Which folder to add to Syncthing
          id = "meugk-eipcy";
          devices = ["andromeda" "cerberus"]; # Which devices to share the folder with
        };
      };
    };
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
