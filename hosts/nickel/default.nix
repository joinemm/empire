{
  self,
  lib,
  inputs,
  pkgs,
  config,
  user,
  ...
}:
{
  imports = lib.flatten [
    (with self.profiles; [
      core
      server
    ])
    (with self.nixosModules; [
      locale
      systemd-boot
      tailscale
      nginx
    ])
    inputs.disko.nixosModules.disko
    inputs.sops-nix.nixosModules.sops
    inputs.nixarr.nixosModules.default
    inputs.home-manager.nixosModules.home-manager
    ./disk-config.nix
  ];

  networking.hostName = "nickel";
  nixpkgs.hostPlatform = "x86_64-linux";
  system.stateVersion = "24.11";

  sops = {
    defaultSopsFile = ./secrets.yaml;
    secrets = {
      "wireguard.conf".owner = "root";
      recyclarr-secrets = {
        format = "binary";
        sopsFile = ./recyclarr_secrets;
        path = "${user.home}/.config/recyclarr/secrets.yml";
        owner = user.name;
      };
      cloudflare_env.owner = "root";
    };
  };

  # HARDWARE

  boot.initrd.availableKernelModules = [
    "xhci_pci"
    "ahci"
    "nvme"
    "usbhid"
    "usb_storage"
    "sd_mod"
  ];

  boot.kernelModules = [ "kvm-intel" ];

  networking.useDHCP = true;

  # enable vaapi on OS-level
  nixpkgs.config.packageOverrides = pkgs: {
    vaapiIntel = pkgs.vaapiIntel.override { enableHybridCodec = true; };
  };

  # hardware acceleration
  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver
      intel-vaapi-driver
      vaapiVdpau
      intel-compute-runtime # OpenCL filter support (hardware tonemapping and subtitle burn-in)
      vpl-gpu-rt # QSV on 11th gen or newer
      intel-media-sdk # QSV up to 11th gen
    ];
  };

  # MOUNTS

  systemd.tmpfiles.rules = [
    "d /data 0755 root root"
    "d /srv/nfs 0775 nfs users"
    "d '${config.nixarr.mediaDir}/torrents'             0755 torrenter media - -"
    "d '${config.nixarr.mediaDir}/torrents/.incomplete' 0755 torrenter media - -"
    "d '${config.nixarr.mediaDir}/torrents/.watch'      0755 torrenter media - -"
  ];

  fileSystems = {

    # Storage drives are formatted by hand
    "/mnt/disk1" = {
      device = "/dev/disk/by-uuid/f8527518-67e5-45a2-b2d2-f4c197b9d80f";
      fsType = "xfs";
    };

    "/mnt/disk2" = {
      device = "/dev/disk/by-uuid/757bbc28-5fd7-4a46-8be0-3082bb5fd52c";
      fsType = "xfs";
    };

    # Merge all disks to a fuse mount at /data
    "/data" = {
      device = "/mnt/disk*";
      fsType = "fuse.mergerfs";
      options = [
        "cache.files=full" # required for deluge to work
        "dropcacheonclose=true"
        "category.create=mfs"
        "func.getattr=newest" # required for jellyfin to find new files
      ];
    };

    # Bind mount /data/share into /srv/nfs
    "/srv/nfs" = {
      device = "/data/share";
      options = [ "bind" ];
    };
  };

  # NFS

  users.users.nfs = {
    isNormalUser = true;
    uid = 1001;
  };

  services.nfs.server = {
    enable = true;
    exports = ''
      /srv/nfs  192.168.1.0/24(rw,sync,no_subtree_check,root_squash,all_squash,anonuid=1001,anongid=100,fsid=0)
    '';
    statdPort = 4000;
    lockdPort = 4001;
    mountdPort = 4002;
  };

  networking.firewall = rec {
    allowedTCPPorts =
      [
        111
        2049
      ]
      ++ lib.attrVals [
        "statdPort"
        "lockdPort"
        "mountdPort"
      ] config.services.nfs.server;

    allowedUDPPorts = allowedTCPPorts;
  };

  # SERVICES

  services.scrutiny = {
    enable = true;
    openFirewall = true;
    collector.enable = true;
    settings.web.listen.port = 5500;
  };

  services.vnstat.enable = true;

  services.immich = {
    enable = true;
    openFirewall = true;
    host = "0.0.0.0";
    port = 2283;
  };

  users.users.joonas.extraGroups = [
    "media"
    "immich"
  ];

  # https://github.com/NixOS/nixpkgs/issues/360592
  # sonarr is not updated to .NET 8 yet but 6 is marked as insecure
  nixpkgs.config.permittedInsecurePackages = [
    "aspnetcore-runtime-6.0.36"
    "aspnetcore-runtime-wrapped-6.0.36"
    "dotnet-sdk-6.0.428"
    "dotnet-sdk-wrapped-6.0.428"
  ];

  # The *arr suite
  nixarr = {
    enable = true;
    mediaDir = "/data/media";
    stateDir = "/var/lib/nixarr";

    jellyfin.enable = true; # 8096

    prowlarr.enable = true; # 9696
    radarr.enable = true; # 7878
    sonarr.enable = true; # 8989
    bazarr.enable = true; # 6767
  };

  users.groups = {
    torrenter = { };
    cross-seed = { };
  };

  users.users.torrenter = {
    isSystemUser = true;
    group = "torrenter";
  };

  # set up vpn confinement namespace
  vpnNamespaces.wg = {
    enable = true;
    # airvpn wireguard configuration
    wireguardConfigFile = config.sops.secrets."wireguard.conf".path;

    portMappings = [
      {
        from = config.services.deluge.web.port;
        to = config.services.deluge.web.port;
      }
    ];
    openVPNPorts = [
      {
        port = 41886;
        protocol = "both";
      }
    ];
    accessibleFrom = [
      "192.168.1.0/24"
      "10.0.0.0/8"
      "127.0.0.1"
    ];
  };

  # map local port to the vpn port so it's accessible from localhost
  services.nginx.virtualHosts =
    let
      labDomain = "lab.joinemm.dev";
      labCert = {
        useACMEHost = "lab.joinemm.dev";
        forceSSL = true;
      };
    in
    {
      # proxy from vpn confinement to localhost
      "127.0.0.1:${toString config.services.deluge.web.port}" = {
        listen = [
          {
            addr = "0.0.0.0";
            inherit (config.services.deluge.web) port;
          }
        ];
        locations."/" = {
          proxyWebsockets = true;
          proxyPass = "http://${config.vpnNamespaces.wg.namespaceAddress}:${toString config.services.deluge.web.port}";
        };
      };

      # proxy on domain with https, only accessible within local network
      "deluge.${labDomain}" = labCert // {
        locations."/".proxyPass = "http://127.0.0.1:${toString config.services.deluge.web.port}";
      };
      "prowlarr.${labDomain}" = labCert // {
        locations."/".proxyPass = "http://127.0.0.1:9696";
      };
      "radarr.${labDomain}" = labCert // {
        locations."/".proxyPass = "http://127.0.0.1:7878";
      };
      "sonarr.${labDomain}" = labCert // {
        locations."/".proxyPass = "http://127.0.0.1:8989";
      };
      "bazarr.${labDomain}" = labCert // {
        locations."/".proxyPass = "http://127.0.0.1:6767";
      };
      "jellyfin.${labDomain}" = labCert // {
        locations."/".proxyPass = "http://127.0.0.1:8096";
      };
      "immich.${labDomain}" = labCert // {
        locations."/".proxyPass = "http://127.0.0.1:${toString config.services.immich.port}";
      };
      "scrutiny.${labDomain}" = labCert // {
        locations."/".proxyPass = "http://127.0.0.1:${toString config.services.scrutiny.settings.web.listen.port}";
      };
    };

  users.users.nginx.extraGroups = [ "acme" ];

  security.acme = {
    certs."lab.joinemm.dev" = {
      domain = "lab.joinemm.dev";
      extraDomainNames = [ "*.lab.joinemm.dev" ];
      dnsProvider = "cloudflare";
      dnsPropagationCheck = true;
      environmentFile = config.sops.secrets.cloudflare_env.path;
    };
  };

  security.acme = {
    acceptTerms = true;
    defaults.email = user.email;
  };

  # use deluge torrent client
  services.deluge = {
    enable = true;
    user = "torrenter";
    group = "media";
    web = {
      enable = true;
      openFirewall = true;
      port = 8112;
    };
  };

  # run deluge daemon inside the vpn
  systemd.services.deluged.vpnConfinement = {
    enable = true;
    vpnNamespace = "wg";
  };

  # run deluge web ui inside the vpn.
  # while this doesn't matter for leaking of torrents,
  # it's required so the web ui can find the daemon
  systemd.services.delugeweb.vpnConfinement = {
    enable = true;
    vpnNamespace = "wg";
  };

  home-manager.users.${user.name} = {
    imports = [
      inputs.sops-nix.homeManagerModules.sops
    ];
    home.stateVersion = config.system.stateVersion;
    xdg.configFile."recyclarr/recyclarr.yml".source = ./recyclarr.yml;
  };

  # PACKAGES

  environment.systemPackages = with pkgs; [
    mergerfs
    smartmontools
    wireguard-tools
    intel-gpu-tools
    qbittorrent-nox
    recyclarr
  ];
}
