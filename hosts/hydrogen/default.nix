{
  lib,
  inputs,
  self,
  pkgs,
  config,
  ...
}:
let
  domain = "monitoring.misobot.xyz";
in
{
  imports = lib.flatten [
    (with self.profiles; [
      core
      server
    ])
    (with self.nixosModules; [
      hetzner
      nginx
    ])
    inputs.disko.nixosModules.disko
    ../../disko/hetzner-osdisk.nix
  ];

  disko.devices.disk.sda.device = "/dev/disk/by-path/pci-0000:00:04.0-scsi-0:0:0:0";

  nixpkgs.hostPlatform = "x86_64-linux";
  networking.hostName = "hydrogen";

  environment.systemPackages = with pkgs; [ busybox ];

  services.grafana = {
    enable = true;

    settings = {
      server = {
        http_port = 3000;
        http_addr = "127.0.0.1";
      };

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
        url = "http://${config.services.prometheus.listenAddress}:${toString config.services.prometheus.port}/prometheus";
      }
    ];
  };

  services.prometheus = {
    enable = true;

    port = 9090;
    listenAddress = "0.0.0.0";
    webExternalUrl = "/prometheus/";
    checkConfig = true;

    globalConfig.scrape_interval = "15s";

    scrapeConfigs = [
      {
        job_name = "miso";
        static_configs = [
          {
            targets = [
              "api.misobot.xyz"
              "api.misobot.xyz:9100"
            ];
          }
        ];
      }
      {
        job_name = "servers";
        static_configs = [
          {
            targets = [
              "65.21.249.145:9100"
              "127.0.0.1:9100"
            ];
          }
        ];
      }
    ];
  };

  services.nginx.virtualHosts = {
    "${domain}" = {
      enableACME = true;
      forceSSL = true;
      locations."/prometheus/" = {
        proxyPass = "http://127.0.0.1:${toString config.services.prometheus.port}";
      };

      locations."/" = {
        proxyPass = "http://127.0.0.1:${toString config.services.grafana.settings.server.http_port}";
        proxyWebsockets = true;
      };
    };
  };

  system.stateVersion = "23.11";
}
