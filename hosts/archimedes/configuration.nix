{
  lib,
  modules,
  inputs,
  pkgs,
  user,
  modulesPath,
  config,
  ...
}: {
  imports = lib.flatten [
    (with modules; [
      common
      locale
      ssh-access
    ])
    inputs.nixos-hardware.nixosModules.raspberry-pi-4
    (modulesPath + "/installer/sd-card/sd-image-aarch64.nix")
  ];

  nixpkgs.overlays = [
    (_: super: {
      makeModulesClosure = x:
        super.makeModulesClosure (x // {allowMissing = true;});
    })
  ];

  # makes the sdImage a .img instead of .img.zst
  sdImage.compressImage = false;

  hardware = {
    raspberry-pi."4" = {
      apply-overlays-dtmerge.enable = true;
    };
    deviceTree = {
      enable = true;
      filter = "*rpi-4-*.dtb";
    };
  };

  nixpkgs.hostPlatform = "aarch64-linux";
  networking.hostName = "archimedes";
  system.stateVersion = "24.05";

  console.enable = false;

  security.sudo.wheelNeedsPassword = false;

  users.users.${user.name} = {
    shell = lib.mkForce pkgs.bashInteractive;
    extraGroups = ["gpio"];
  };

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-label/NIXOS_SD";
      fsType = "ext4";
      options = ["noatime"];
    };
  };

  users.groups.gpio = {};

  # Use GPIO pins as non-root
  services.udev.extraRules = ''
    SUBSYSTEM=="bcm2835-gpiomem", KERNEL=="gpiomem", GROUP="gpio",MODE="0660"
    SUBSYSTEM=="gpio", KERNEL=="gpiochip*", ACTION=="add", RUN+="${pkgs.bash}/bin/bash -c 'chown root:gpio /sys/class/gpio/export /sys/class/gpio/unexport ; chmod 220 /sys/class/gpio/export /sys/class/gpio/unexport'"
    SUBSYSTEM=="gpio", KERNEL=="gpio*", ACTION=="add",RUN+="${pkgs.bash}/bin/bash -c 'chown root:gpio /sys%p/active_low /sys%p/direction /sys%p/edge /sys%p/value ; chmod 660 /sys%p/active_low /sys%p/direction /sys%p/edge /sys%p/value'"
  '';

  environment.systemPackages = with pkgs; [
    busybox
    libraspberrypi
    raspberrypi-eeprom
  ];

  networking.firewall = let
    allowed = [
      config.services.prometheus.port
      config.services.grafana.settings.server.http_port
      config.services.blocky.settings.ports.http
      config.services.blocky.settings.ports.dns
    ];
  in {
    allowedTCPPorts = allowed;
    allowedUDPPorts = allowed;
  };

  # postgresql is running on unix socket at /run/postgresql
  # only local connections are allowed
  # TCP connections are refused
  services.postgresql = {
    enable = true;
    authentication = lib.mkForce ''
      local all all trust
    '';
    # https://github.com/shizunge/blocky-postgresql/blob/main/init-scripts/blocky-pg-init.sh
    # https://gist.github.com/zaenk/2e9c1936663caae71b212f056b5dfb5f
    initialScript = pkgs.writeText "postgres-init" ''
      CREATE DATABASE blocky;
      CREATE USER blocky WITH PASSWORD 'blocky';
      GRANT ALL PRIVILEGES ON DATABASE blocky TO blocky;
      GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO blocky;
      GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO blocky;

      \c blocky postgres
      GRANT ALL ON SCHEMA public TO blocky;

      CREATE USER grafana WITH PASSWORD 'grafana';
      GRANT CONNECT ON DATABASE blocky TO grafana;
      GRANT USAGE ON SCHEMA public TO grafana;

      \c blocky blocky
      ALTER DEFAULT PRIVILEGES FOR USER blocky IN SCHEMA public GRANT SELECT ON TABLES TO grafana;
    '';
  };

  services.prometheus = {
    enable = true;
    port = 9090;
    listenAddress = "0.0.0.0";
    checkConfig = true;
    globalConfig.scrape_interval = "15s";

    scrapeConfigs = [
      {
        job_name = "local";
        static_configs = [
          {
            targets = [
              "127.0.0.1:${toString config.services.blocky.settings.ports.http}"
            ];
          }
        ];
      }
    ];
  };

  services.grafana = {
    enable = true;
    settings = {
      server = {
        http_port = 3000;
        http_addr = "0.0.0.0";
      };

      panels.disable_sanitize_html = true;

      # disable telemetry
      analytics = {
        reporting_enabled = false;
        feedback_links_enabled = false;
      };
    };

    provision.datasources.settings.datasources = [
      {
        name = "prometheus";
        type = "prometheus";
        isDefault = true;
        url = "http://${config.services.prometheus.listenAddress}:${toString config.services.prometheus.port}";
      }
      {
        name = "postgresql-blocky";
        type = "postgres";
        url = "/run/postgresql";
        user = "grafana";
        jsonData = {
          password = "grafana";
          database = "blocky";
          sslmode = "disable";
        };
      }
    ];
  };

  services.blocky = {
    enable = true;
    settings = {
      prometheus.enable = true;

      ports = {
        dns = 53;
        http = 4000;
      };

      queryLog = {
        type = "postgresql";
        target = "user=blocky password=blocky host=/run/postgresql dbname=blocky sslmode=disable";
      };

      upstreams = {
        groups = {
          default = [
            # Cloudflare DNS over TLS
            "tcp-tls:1.1.1.1:853"
            "tcp-tls:1.0.0.1:853"
          ];
        };
      };

      # Use rDNS to ask the router dnsmasq service for client hostnames
      # https://dev.to/zer0ed/install-adguard-home-on-edgerouter-x-including-local-hostname-resoluion-using-dnsmasq-2hmc
      clientLookup = {
        upstream = "192.168.1.1:5353";
        singleNameOrder = [1];
        clients = {
          router = ["192.168.1.1"];
          access-point = ["192.168.1.2"];
        };
      };

      bootstrapDns = {
        upstream = "https://one.one.one.one/dns-query";
        ips = ["1.1.1.1" "1.0.0.1"];
      };

      caching = {
        minTime = "5m";
        maxTime = "30m";
        prefetching = true;
      };

      blocking = {
        loading.refreshPeriod = "12h";

        clientGroupsBlock = {
          default = ["ads" "security" "porn"];
        };

        denylists = {
          ads = [
            "https://cdn.jsdelivr.net/gh/hagezi/dns-blocklists@latest/wildcard/pro.txt"
          ];
          security = [
            "https://cdn.jsdelivr.net/gh/hagezi/dns-blocklists@latest/wildcard/tif.medium.txt"
            "https://blocklistproject.github.io/Lists/smart-tv.txt"
          ];
          porn = [
            "https://blocklistproject.github.io/Lists/porn.txt"
          ];
        };

        allowlists = {
          ads = [
            (pkgs.writeText "whitelist.txt" ''
              # this is where whitelisted domains would go
            '')
          ];
        };
      };
    };
  };
}
