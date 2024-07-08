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
      ssh-access
      syncthing
    ])
    inputs.disko.nixosModules.disko
    inputs.sops-nix.nixosModules.sops
    ../disk-root.nix
    (import ../disk-block-storage.nix {
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
    };
  };

  environment.systemPackages = with pkgs; [
    busybox
  ];

  services.plausible = {
    enable = true;
    server = {
      baseUrl = "https://traffic.joinemm.dev";
      secretKeybaseFile = config.sops.secrets.plausible_secret_key_base.path;
    };
    adminUser = {
      activate = true;
      email = user.email;
      passwordFile = config.sops.secrets.plausible_password.path;
    };
  };

  services.syncthing = {
    dataDir = "${volumePath}/syncthing";
    user = "syncthing";
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
        locations."~ (?<repo>[^/\\s]+)" = {
          return = "301 https://github.com/joinemm/$repo";
        };
      }
      // ssl;

    "traffic.joinemm.dev" = let
      plausibleAddr = "http://127.0.0.1:${toString config.services.plausible.server.port}";
      extraConfig = "proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;";
    in
      {
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
        locations."/" = {
          proxyPass = "http://127.0.0.1:8384";
        };
      }
      // ssl;

    "digitalocean.joinemm.dev" = mkRedirect "https://m.do.co/c/7251aebbc5e0";

    "vultr.joinemm.dev" = mkRedirect "https://vultr.com/?ref=8569244-6G";

    "hetzner.joinemm.dev" = mkRedirect "https://hetzner.cloud/?ref=JkprBlQwg9Kp";
  };
}
