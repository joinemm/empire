{
  lib,
  inputs,
  outputs,
  config,
  pkgs,
  modulesPath,
  ...
}: let
  user = "joonas";
in {
  imports = lib.flatten [
    (modulesPath + "/installer/scan/not-detected.nix")
    (modulesPath + "/profiles/qemu-guest.nix")
    (with outputs.nixosModules; [
      (common {inherit user pkgs outputs;})
      (syncthing {inherit user config lib;})
      (ssh-access {inherit user;})
      (docker {inherit user;})
      nginx
    ])
    inputs.disko.nixosModules.disko
    ./disk-config.nix
  ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  time.timeZone = lib.mkForce "UTC";

  boot = {
    initrd.availableKernelModules = ["ata_piix" "virtio_pci" "virtio_scsi" "xhci_pci" "sd_mod" "sr_mod"];
    loader.grub = {
      # no need to set devices, disko will add all devices that have a EF02 partition to the list already
      # devices = [ ];
      efiSupport = true;
      efiInstallAsRemovable = true;
    };
  };

  security.sudo.wheelNeedsPassword = false;
  networking.hostName = "hetzner";

  systemd.network = {
    enable = true;
    networks."10-wan" = {
      matchConfig.Name = "ens3";
      networkConfig.DHCP = "ipv4";
    };
  };

  environment.systemPackages = with pkgs; [
    neovim
    wget
    git
  ];

  services.syncthing = {
    dataDir = "/mnt/volume/sync";
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

  services.nginx.virtualHosts = {
    "git.joinemm.dev" = {
      #enableACME = true;
      #forceSSL = true;
      locations."~ (?<repo>[^/\\s]+)" = {
        return = "301 https://github.com/joinemm/$repo";
      };
    };

    "traffic.joinemm.dev" = {
      #enableACME = true;
      #forceSSL = true;
      locations."/" = {
        proxyPass = "http://127.0.0.1:8000";
        extraConfig = "proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;";
      };
      locations."/visit.js" = {
        proxyPass = "http://127.0.0.1:8000/js/script.outbound-links.js";
        extraConfig = "proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;";
      };
    };

    "sync.joinemm.dev" = {
      #enableACME = true;
      #forceSSL = true;
      locations."/" = {
        proxyPass = "http://127.0.0.1:8384";
      };
    };

    "cdn.joinemm.dev" = {
      #enableACME = true;
      #forceSSL = true;
      locations."/" = {
        proxyPass = "http://127.0.0.1:8055";
      };
      extraConfig = "client_max_body_size 100M;";
    };

    "digitalocean.joinemm.dev" = {
      #enableACME = true;
      #forceSSL = true;
      locations."/" = {
        return = "302 https://m.do.co/c/7251aebbc5e0";
      };
    };

    "vultr.joinemm.dev" = {
      #enableACME = true;
      #forceSSL = true;
      locations."/" = {
        return = "302 https://vultr.com/?ref=8569244-6G";
      };
    };

    "hetzner.joinemm.dev" = {
      #enableACME = true;
      #forceSSL = true;
      locations."/" = {
        return = "302 https://hetzner.cloud/?ref=JkprBlQwg9Kp";
      };
    };
  };
}
