{
  lib,
  outputs,
  pkgs,
  config,
  modulesPath,
  ...
}: let
  user = "joonas";
in {
  imports = [
    (with outputs.nixosModules; [
      (common {inherit user pkgs;})
      (syncthing {inherit user;})
      (ssh-access {inherit user;})
    ])
    (modulesPath + "/profiles/qemu-guest.nix")
  ];

  boot = {
    initrd.availableKernelModules = ["ata_piix" "virtio_pci" "virtio_scsi" "xhci_pci" "sd_mod" "sr_mod"];
    loader.grub = {
      enable = true;
      efiSupport = false;
      device = "/dev/sda";
    };
  };

  networking = {
    hostName = "hetzner";
    firewall.allowedTCPPorts = [80 443];
  };

  systemd.network = {
    enable = true;
    networks."10-wan" = {
      matchConfig.Name = "ens3";
      networkConfig.DHCP = "ipv4";
    };
  };

  time.timeZone = lib.mkForce "UTC";

  virtualisation.docker.enable = true;

  services.syncthing = let
    syncDir = "/mnt/volume/sync";
  in {
    dataDir = lib.mkForce "${syncDir}";
    settings = {
      folders = {
        "camera" = {
          path = "${syncDir}/camera";
          id = "25yyh-2i2sq";
          devices = ["samsung" "andromeda" "cerberus" "windows"];
        };
        "code" = {
          path = "${syncDir}/code";
          id = "asqhs-gxzl4";
          ignorePerms = false;
          devices = ["andromeda" "cerberus" "buutti"];
        };
        "documents" = {
          path = "${syncDir}/documents";
          id = "rg3sy-y9wvv";
          devices = ["samsung" "andromeda" "cerberus" "windows"];
        };
        "mobile-downloads" = {
          path = "${syncDir}/mobile-downloads";
          id = "m7oev-edqfh";
          devices = ["samsung" "andromeda" "cerberus" "windows"];
        };
        "mobile-screenshots" = {
          path = "${syncDir}/mobile-screenshots";
          id = "6517n-x3hlt";
          devices = ["samsung" "andromeda" "cerberus" "windows"];
        };
        "notes" = {
          path = "${syncDir}/notes";
          id = "jmdvx-nzh9p";
          devices = ["andromeda" "cerberus" "buutti" "unikie"];
        };
        "pictures" = {
          path = "${syncDir}/pictures";
          id = "zuaps-ign9t";
          devices = ["andromeda" "cerberus" "samsung" "buutti"];
        };
        "videos" = {
          path = "${syncDir}/videos";
          id = "hmrxy-xkgrb";
          devices = ["andromeda" "cerberus" "samsung" "buutti"];
        };
        "work" = {
          path = "${syncDir}/work";
          id = "meugk-eipcy";
          ignorePerms = false;
          devices = ["andromeda" "cerberus" "buutti" "unikie"];
        };
      };
    };
  };

  security.acme = {
    acceptTerms = true;
    defaults.email = "joonas@rautiola.co";
  };

  # TODO: what is this
  security.dhparams = {
    enable = true;
    params.nginx = {};
  };

  services.nginx = {
    enable = true;

    recommendedGzipSettings = true;
    recommendedOptimisation = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;
    resolver.addresses = config.networking.nameservers;
    sslDhparam = config.security.dhparams.params.nginx.path;

    virtualHosts = {
      "git.joinemm.dev" = {
        enableACME = true;
        forceSSL = true;
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
  };

  environment.systemPackages = with pkgs; [
    neovim
    wget
    git
  ];
}
