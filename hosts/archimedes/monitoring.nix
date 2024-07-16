{
  config,
  pkgs,
  lib,
  ...
}: {
  networking.firewall = let
    allowed = [
      config.services.prometheus.port
      config.services.grafana.settings.server.http_port
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
