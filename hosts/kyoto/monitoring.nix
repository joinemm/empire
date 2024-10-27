{
  config,
  ...
}:
{
  networking.firewall =
    let
      allowed = [
        config.services.prometheus.port
        config.services.grafana.settings.server.http_port
      ];
    in
    {
      allowedTCPPorts = allowed;
      allowedUDPPorts = allowed;
    };

  services.prometheus.exporters.node.enable = true;

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
              "127.0.0.1:${toString config.services.prometheus.exporters.node.port}"
              "127.0.0.1:9110" # rpi_exporter
              "127.0.0.1:9100" # node_exporter
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

      # allow html for blocky panel with buttons
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
}
