{
  user,
  lib,
  inputs,
  modules,
  pkgs,
  config,
  ...
}: let
  volumePath = "/mnt/data";
in {
  imports = lib.flatten [
    (with modules; [
      common
      hetzner
      headless
      docker
      nginx
      node-exporter
      ssh-access
      syncthing
    ])
    inputs.disko.nixosModules.disko
    inputs.sops-nix.nixosModules.sops
    inputs.attic.nixosModules.atticd
    (import ../../disko/hetzner-osdisk.nix {
      pci = "0000:06:00.0";
    })
    (import ../../disko/hetzner-block-storage.nix {
      id = "100958858";
      mountpoint = volumePath;
    })
  ];

  networking.hostName = "apollo";
  nixpkgs.hostPlatform = "x86_64-linux";
  system.stateVersion = "24.05";

  sops = {
    defaultSopsFile = ./secrets.yaml;
    secrets = {
      plausible_password.owner = "root";
      plausible_secret_key_base.owner = "root";
      spotify_client_secret.owner = "root";
      attic_env.owner = "root";
    };
  };

  users.users."${user.name}".extraGroups = [
    "headscale"
    "atticd"
  ];

  environment.systemPackages = with pkgs; [
    busybox
    inputs.attic.packages.${pkgs.system}.attic-client
    config.services.headscale.package
  ];

  services.your_spotify = let
    domain = "fm.joinemm.dev";
  in {
    enable = true;
    settings = {
      PORT = 8081;
      SPOTIFY_PUBLIC = "8e870cbcc8d54fb8ad1ae8c33878b7f6";
      CLIENT_ENDPOINT = "https://${domain}";
      API_ENDPOINT = "https://${domain}/api";
    };
    spotifySecretFile = config.sops.secrets.spotify_client_secret.path;
    enableLocalDB = true;
    nginxVirtualHost = domain;
  };

  services.postgresql = {
    enable = true;
    authentication = lib.mkForce ''
      local all all trust
    '';
    ensureDatabases = ["atticd" "headscale"];
    ensureUsers = [
      {
        name = "atticd";
        ensureDBOwnership = true;
      }
      {
        name = "headscale";
        ensureDBOwnership = true;
      }
    ];
  };

  services.atticd = {
    enable = true;
    package = inputs.attic.packages.${pkgs.system}.attic-server;
    credentialsFile = config.sops.secrets.attic_env.path;

    settings = {
      listen = "127.0.0.1:8080";
      database.url = "postgresql:///atticd?host=/run/postgresql";

      storage = {
        type = "s3";
        endpoint = "https://s3.us-west-004.backblazeb2.com";
        bucket = "binarycache";
        region = "us-west-004";
      };

      chunking = {
        nar-size-threshold = 64 * 1024; # 64 KiB
        min-size = 16 * 1024; # 16 KiB
        avg-size = 64 * 1024; # 64 KiB
        max-size = 256 * 1024; # 256 KiB
      };

      compression.type = "zstd";
      garbage-collection.interval = "12 hours";
    };
  };

  services.plausible = {
    enable = true;
    server = {
      port = 8000;
      baseUrl = "https://traffic.joinemm.dev";
      secretKeybaseFile = config.sops.secrets.plausible_secret_key_base.path;
    };
    adminUser = {
      activate = true;
      inherit (user) email;
      passwordFile = config.sops.secrets.plausible_password.path;
    };
  };

  services.syncthing = {
    dataDir = "${volumePath}/syncthing";
    guiAddress = "0.0.0.0:8384";
    settings.gui = {
      user = "admin";
      # bcrypt hash until https://github.com/NixOS/nixpkgs/pull/290485 is merged
      password = "$2b$05$K03dR3Dhq92nHU6wpyH5f.4VYAnry8eDzvXiYfcRf1qZhsI4DymxO";
    };
    settings.folders = {
      "camera".enable = true;
      "code".enable = true;
      "documents".enable = true;
      "notes".enable = true;
      "pictures".enable = true;
      "videos".enable = true;
      "work".enable = true;
      "share".enable = true;
    };
  };

  services.headscale = {
    enable = true;
    port = 8085;
    package = pkgs.callPackage ../../pkgs/headscale {};
    settings = {
      server_url = "https://portal.joinemm.dev";
      metrics_listen_addr = "127.0.0.1:8095";
      prefixes = {
        v4 = "100.64.0.0/10";
        v6 = "fd7a:115c:a1e0::/48";
      };
      database = {
        type = "postgres";
        postgres = {
          host = "/run/postgresql";
          name = "headscale";
          user = "headscale";
        };
      };
      dns_config = {
        override_local_dns = true;
        base_domain = "portal.joinemm.dev";
        magic_dns = true;
        nameservers = ["100.64.0.3"];
      };
      unix_socket_permission = "0770";
      disable_check_updates = true;
    };
  };

  services.nginx.virtualHosts = let
    ssl = {
      enableACME = true;
      forceSSL = true;
    };
    mkRedirect = to:
      {
        locations."/" = {
          return = "302 ${to}";
        };
      }
      // ssl;
  in {
    "git.joinemm.dev" =
      {
        serverAliases = ["github.joinemm.dev"];
        locations = {
          "/" = {
            return = "302 https://github.com/joinemm";
          };
          "~ (?<repo>[^/\\s]+)" = {
            return = "302 https://github.com/joinemm/$repo";
          };
        };
      }
      // ssl;

    "traffic.joinemm.dev" = let
      plausibleAddr = "http://127.0.0.1:${toString config.services.plausible.server.port}";
      extraConfig = "proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;";
    in
      {
        serverAliases = ["plausible.joinemm.dev"];
        locations."/" = {
          proxyPass = plausibleAddr;
          inherit extraConfig;
        };
        locations."/visit.js" = {
          proxyPass = "${plausibleAddr}/js/script.outbound-links.js";
          inherit extraConfig;
        };
      }
      // ssl;

    "sync.joinemm.dev" =
      {
        serverAliases = ["syncthing.joinemm.dev"];
        locations."/" = {
          proxyPass = "http://127.0.0.1:8384";
        };
      }
      // ssl;

    "fm.joinemm.dev" =
      {
        # imported spotify history files can be very large
        extraConfig = ''
          client_max_body_size 500M;
        '';
        locations."/api/" = {
          proxyPass = "http://127.0.0.1:${toString config.services.your_spotify.settings.PORT}/";
          extraConfig = ''
            proxy_set_header X-Script-Name /api;
            proxy_pass_header Authorization;
          '';
        };
      }
      // ssl;

    "attic.joinemm.dev" =
      {
        extraConfig = ''
          client_header_buffer_size 64k;
          client_max_body_size 2G;
        '';
        locations."/" = {
          proxyPass = "http://127.0.0.1:8080";
        };
      }
      // ssl;

    "portal.joinemm.dev" =
      {
        locations."/" = {
          proxyPass = "http://127.0.0.1:${toString config.services.headscale.port}";
          proxyWebsockets = true;
        };
        locations."/metrics" = {
          proxyPass = "http://${config.services.headscale.settings.metrics_listen_addr}/metrics";
        };
      }
      // ssl;

    "digitalocean.joinemm.dev" = mkRedirect "https://m.do.co/c/7251aebbc5e0";

    "vultr.joinemm.dev" = mkRedirect "https://vultr.com/?ref=8569244-6G";

    "hetzner.joinemm.dev" = mkRedirect "https://hetzner.cloud/?ref=JkprBlQwg9Kp";
  };
}
