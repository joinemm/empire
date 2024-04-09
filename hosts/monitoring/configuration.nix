{
  lib,
  inputs,
  outputs,
  pkgs,
  modulesPath,
  config,
  ...
}: let
  domain = "monitoring.joinemm.dev";
in {
  imports = lib.flatten [
    (modulesPath + "/installer/scan/not-detected.nix")
    (modulesPath + "/profiles/qemu-guest.nix")
    (with outputs.nixosModules; [
      common
      nix
      nginx
      ssh-access
      users
    ])
    inputs.disko.nixosModules.disko
    ./disk-config.nix
  ];

  nixpkgs.hostPlatform = "x86_64-linux";
  time.timeZone = "UTC";

  boot = {
    # initrd.availableKernelModules = ["ata_piix" "virtio_pci" "virtio_scsi" "xhci_pci" "sd_mod" "sr_mod"];
    loader.grub = {
      efiSupport = true;
      efiInstallAsRemovable = true;
    };
  };

  security.sudo.wheelNeedsPassword = false;

  # systemd.network = {
  #   enable = true;
  #   networks."10-wan" = {
  #     matchConfig.Name = "ens3";
  #     networkConfig.DHCP = "ipv4";
  #   };
  # };

  networking = {
    hostName = "monitoring";
    # useNetworkd = true;
  };

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
        url = "http://${config.services.prometheus.listenAddress}:${toString config.services.prometheus.port}";
      }
    ];
  };

  services.prometheus = {
    enable = true;

    port = 9090;
    listenAddress = "0.0.0.0";
    webExternalUrl = "/prometheus/";
    checkConfig = true;

    scrapeConfigs = [
      {
        job_name = "miso";
        scheme = "https";
        static_configs = [
          {
            targets = [
              "api.misobot.xyz/metrics"
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
}
