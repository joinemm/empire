{
  lib,
  inputs,
  outputs,
  pkgs,
  config,
  ...
}: let
  domain = "monitoring.misobot.xyz";
in {
  imports = lib.flatten [
    (with outputs.nixosModules; [
      common
      hetzner
      nginx
      ssh-access
    ])
    inputs.disko.nixosModules.disko
    ../disk-root.nix
  ];

  nixpkgs.hostPlatform = "x86_64-linux";

  networking.hostName = "monitoring";

  environment.systemPackages = with pkgs; [
    busybox
  ];

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
